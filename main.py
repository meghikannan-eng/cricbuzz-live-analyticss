"""
Cricbuzz Live Analytics Dashboard
=================================

A Streamlit application that combines four modules:
    1. Home            - landing page with project overview.
    2. Live Matches    - live and recently-completed matches via the Cricbuzz
                         RapidAPI feed.
    3. Top Player Stats- top batting / bowling rankings per format.
    4. SQL Analytics   - 25 pre-built SQL questions executed against a local
                         MySQL database.
    5. CRUD Operations - create, read, update, delete records for the
                         `players` table (demonstration table).

Credentials are loaded from environment variables (with an optional `.env`
file), so no secrets are checked into source. Every network call and every
database call is guarded with a try/except block so the dashboard keeps
running even if a dependency is unavailable.

Run with::

    streamlit run main.py
"""

from __future__ import annotations

import os
from datetime import datetime
from pathlib import Path
from typing import Any, Dict, List, Optional, Tuple

import pandas as pd
import requests
import streamlit as st

try:
    import mysql.connector
    from mysql.connector import Error as MySQLError
except ImportError:  # pragma: no cover - package must be installed
    mysql = None  # type: ignore
    MySQLError = Exception  # type: ignore

# Optional .env support - purely convenience; the app still works without it.
try:
    from dotenv import load_dotenv

    load_dotenv()
except ImportError:  # pragma: no cover
    pass


# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

API_HOST = "cricbuzz-cricket.p.rapidapi.com"
API_BASE = f"https://{API_HOST}"

# Credentials come from environment variables. Safe defaults are only used so
# the app can be browsed locally without crashing, but real deployments must
# override these.
API_KEY = os.getenv("RAPIDAPI_KEY", "")
DB_CONFIG: Dict[str, Any] = {
    "host": os.getenv("DB_HOST", "localhost"),
    "port": int(os.getenv("DB_PORT", "3306")),
    "user": os.getenv("DB_USER", "root"),
    "password": os.getenv("DB_PASSWORD", ""),
    "database": os.getenv("DB_NAME", "cricket_db"),
}

# Folder that contains the 25 SQL question files (files named 1.*.sql ...
# 25.*.sql). The default points at the sibling ``sql_questions`` folder inside
# the project so the app works out of the box once the user drops the .sql
# files in.
SQL_DIR = Path(os.getenv("SQL_QUESTIONS_DIR",
                         Path(__file__).parent / "sql_questions"))


# ---------------------------------------------------------------------------
# Helpers - API
# ---------------------------------------------------------------------------

def api_headers() -> Dict[str, str]:
    """Return the RapidAPI header block for Cricbuzz."""
    return {
        "x-rapidapi-key": API_KEY,
        "x-rapidapi-host": API_HOST,
        "Content-Type": "application/json",
    }


@st.cache_data(ttl=60)
def api_get(path: str, params: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
    """
    Make a GET request against the Cricbuzz API.

    Parameters
    ----------
    path : str
        Path fragment starting with ``/`` (e.g. ``/matches/v1/live``).
    params : dict, optional
        Query string parameters.

    Returns
    -------
    dict
        Parsed JSON body, or an empty dict on any failure.
    """
    if not API_KEY:
        return {}
    url = f"{API_BASE}{path}"
    try:
        response = requests.get(url, headers=api_headers(),
                                params=params, timeout=15)
        response.raise_for_status()
        return response.json() or {}
    except (requests.RequestException, ValueError) as exc:
        st.warning(f"API call failed for {path}: {exc}")
        return {}


# ---------------------------------------------------------------------------
# Helpers - Database
# ---------------------------------------------------------------------------

def get_connection():
    """
    Return a fresh MySQL connection or ``None`` if the driver is missing or
    credentials are wrong. The caller is responsible for closing the
    connection in a ``finally`` block.
    """
    if mysql is None:
        st.error("mysql-connector-python is not installed. "
                 "Run `pip install -r requirements.txt`.")
        return None
    try:
        return mysql.connector.connect(**DB_CONFIG)
    except MySQLError as exc:
        st.error(f"Could not connect to MySQL: {exc}")
        return None


def run_query(sql: str, params: Optional[Tuple[Any, ...]] = None) -> pd.DataFrame:
    """
    Execute a SELECT-style statement and return the results as a DataFrame.

    Empty DataFrame is returned if the statement produces no rows or the
    connection fails, so the caller never has to deal with ``None``.
    """
    conn = get_connection()
    if conn is None:
        return pd.DataFrame()
    try:
        cursor = conn.cursor()
        cursor.execute(sql, params or ())
        rows = cursor.fetchall()
        cols = [c[0] for c in cursor.description] if cursor.description else []
        return pd.DataFrame(rows, columns=cols)
    except MySQLError as exc:
        st.error(f"Query error: {exc}")
        return pd.DataFrame()
    finally:
        try:
            cursor.close()  # type: ignore[name-defined]
        except Exception:
            pass
        conn.close()


def run_statement(sql: str, params: Optional[Tuple[Any, ...]] = None) -> bool:
    """
    Execute an INSERT / UPDATE / DELETE statement.

    Returns ``True`` on success, ``False`` otherwise. The connection is
    committed before closing.
    """
    conn = get_connection()
    if conn is None:
        return False
    try:
        cursor = conn.cursor()
        cursor.execute(sql, params or ())
        conn.commit()
        return True
    except MySQLError as exc:
        st.error(f"Statement error: {exc}")
        return False
    finally:
        try:
            cursor.close()  # type: ignore[name-defined]
        except Exception:
            pass
        conn.close()


def run_sql_script(script: str) -> List[pd.DataFrame]:
    """
    Split a multi-statement .sql script on semicolons and execute every
    non-empty statement. SELECTs return DataFrames; other statements return
    empty DataFrames. The list preserves execution order.
    """
    conn = get_connection()
    if conn is None:
        return []
    results: List[pd.DataFrame] = []
    try:
        cursor = conn.cursor()
        for raw in script.split(";"):
            stmt = raw.strip()
            if not stmt or stmt.startswith("--"):
                continue
            try:
                cursor.execute(stmt)
                if cursor.with_rows:
                    rows = cursor.fetchall()
                    cols = [c[0] for c in cursor.description]
                    results.append(pd.DataFrame(rows, columns=cols))
                else:
                    # DDL/DML - consume any unread result set.
                    while cursor.nextset():
                        pass
            except MySQLError as exc:
                st.warning(f"Skipped statement due to error: {exc}")
        conn.commit()
    finally:
        try:
            cursor.close()  # type: ignore[name-defined]
        except Exception:
            pass
        conn.close()
    return results


# ---------------------------------------------------------------------------
# Module 1 - Home
# ---------------------------------------------------------------------------

def page_home() -> None:
    """Landing page with a short project description."""
    st.title("Cricbuzz Live Analytics")
    st.caption("Real-time cricket insights powered by the Cricbuzz RapidAPI + MySQL.")

    st.markdown(
        """
        **Modules available in this dashboard**

        * **Live Matches** - shows live, upcoming and recently-completed
          international games pulled live from the Cricbuzz feed.
        * **Top Player Stats** - browse ICC batting / bowling rankings per
          format (Test / ODI / T20I).
        * **SQL Analytics** - 25 pre-built analytical queries covering
          beginner, intermediate and advanced difficulty levels.
        * **CRUD Operations** - add, update or delete records in the
          `players` table straight from the UI.

        Use the sidebar on the left to navigate between modules.
        """
    )

    api_ok = bool(API_KEY)
    db_ok = get_connection() is not None
    col1, col2 = st.columns(2)
    col1.metric("RapidAPI key", "configured" if api_ok else "missing")
    col2.metric("MySQL connection", "ok" if db_ok else "not reachable")


# ---------------------------------------------------------------------------
# Module 2 - Live Matches
# ---------------------------------------------------------------------------

def _flatten_matches(raw: Dict[str, Any]) -> pd.DataFrame:
    """Turn the nested /matches response into a flat DataFrame."""
    rows: List[Dict[str, Any]] = []
    for tm in raw.get("typeMatches", []):
        match_type = tm.get("matchType", "")
        for sm in tm.get("seriesMatches", []):
            wrap = sm.get("seriesAdWrapper") or {}
            series_name = wrap.get("seriesName", "")
            for m in wrap.get("matches", []):
                info = m.get("matchInfo", {}) or {}
                venue = info.get("venueInfo", {}) or {}
                t1 = (info.get("team1") or {}).get("teamName", "")
                t2 = (info.get("team2") or {}).get("teamName", "")
                try:
                    start = datetime.fromtimestamp(
                        int(info.get("startDate", 0)) / 1000
                    )
                    start_str = start.strftime("%Y-%m-%d %H:%M")
                except Exception:
                    start_str = ""
                rows.append({
                    "Match Type": match_type,
                    "Series": series_name,
                    "Description": info.get("matchDesc", ""),
                    "Format": info.get("matchFormat", ""),
                    "Team 1": t1,
                    "Team 2": t2,
                    "Status": info.get("status", ""),
                    "Venue": venue.get("ground", ""),
                    "City": venue.get("city", ""),
                    "Start": start_str,
                })
    return pd.DataFrame(rows)


def page_live_matches() -> None:
    """Module showing live / upcoming / recent matches."""
    st.title("Live Matches")

    choice = st.radio(
        "Feed",
        ["Live", "Upcoming", "Recent"],
        horizontal=True,
    )
    endpoint = {
        "Live": "/matches/v1/live",
        "Upcoming": "/matches/v1/upcoming",
        "Recent": "/matches/v1/recent",
    }[choice]

    with st.spinner(f"Loading {choice.lower()} matches..."):
        data = api_get(endpoint)
    df = _flatten_matches(data)

    if df.empty:
        st.info("No matches returned by the API right now. "
                "Check your API key or try another feed.")
        return

    st.dataframe(df, use_container_width=True)
    st.caption(f"{len(df)} match(es) loaded from {endpoint}.")


# ---------------------------------------------------------------------------
# Module 3 - Top Player Stats
# ---------------------------------------------------------------------------

def page_top_stats() -> None:
    """ICC batting / bowling rankings with player search + country filter."""
    st.title("Top Player Stats")

    # ── Category & format selectors ─────────────────────────────────────
    col1, col2 = st.columns(2)
    with col1:
        category = st.selectbox("Category", ["batsmen", "bowlers", "allrounders"])
    with col2:
        fmt = st.selectbox("Format", ["test", "odi", "t20"])

    with st.spinner("Fetching rankings..."):
        data = api_get(f"/stats/v1/rankings/{category}",
                       params={"formatType": fmt})

    players = data.get("rank", []) or []
    if not players:
        st.info("No ranking data available right now.")
        return

    rows = [{
        "Rank": p.get("rank", ""),
        "Player": p.get("name", ""),
        "Country": p.get("country", ""),
        "Rating": p.get("rating", ""),
        "Points": p.get("points", ""),
    } for p in players]
    df = pd.DataFrame(rows)

    # ── Search + country filter row ─────────────────────────────────────
    st.markdown("---")
    st.subheader("🔍 Search & Filter")
    search_col, country_col = st.columns([2, 1])

    with search_col:
        search_query = st.text_input(
            "Search by player name",
            placeholder="e.g. Joe Root, Smith, Kohli...",
            help="Type any part of a player's name (case-insensitive)",
        )

    with country_col:
        countries = ["All"] + sorted(df["Country"].dropna().unique().tolist())
        country_filter = st.selectbox("Filter by country", countries)

    # ── Apply filters ───────────────────────────────────────────────────
    filtered = df.copy()
    if search_query.strip():
        filtered = filtered[
            filtered["Player"].astype(str).str.contains(
                search_query.strip(), case=False, na=False
            )
        ]
    if country_filter != "All":
        filtered = filtered[filtered["Country"] == country_filter]

    # ── Show results ────────────────────────────────────────────────────
    if filtered.empty:
        st.warning(
            f"No players found"
            + (f" matching '{search_query}'" if search_query.strip() else "")
            + (f" from {country_filter}" if country_filter != "All" else "")
            + ". Try a different name or country."
        )
        return

    has_filter = bool(search_query.strip()) or country_filter != "All"
    if has_filter:
        st.success(f"Found {len(filtered)} player(s) matching your filters")
    else:
        st.caption(f"Showing all {len(filtered)} ranked players")

    st.dataframe(filtered, use_container_width=True, hide_index=True)

    # ── Highlight top match details when searching ──────────────────────
    if search_query.strip() and len(filtered) >= 1:
        top = filtered.iloc[0]
        with st.expander(f"📊 Top match: {top['Player']}", expanded=True):
            c1, c2, c3, c4 = st.columns(4)
            c1.metric("Rank", top["Rank"])
            c2.metric("Country", top["Country"])
            c3.metric("Rating", top["Rating"])
            c4.metric("Points", top["Points"])


# ---------------------------------------------------------------------------
# Module 4 - SQL Analytics
# ---------------------------------------------------------------------------

def list_sql_files() -> List[Path]:
    """Return every .sql file inside ``SQL_DIR``, sorted by question number."""
    if not SQL_DIR.exists():
        return []
    files = list(SQL_DIR.glob("*.sql"))

    def sort_key(p: Path) -> int:
        stem = p.stem
        num = ""
        for ch in stem:
            if ch.isdigit():
                num += ch
            else:
                break
        return int(num) if num else 9999

    return sorted(files, key=sort_key)


def page_sql_analytics() -> None:
    """25 canned SQL questions with one-click execution."""
    st.title("SQL Analytics")
    st.caption("Pick one of the 25 pre-built analytical queries and run it "
               "against your local MySQL instance.")

    files = list_sql_files()
    if not files:
        st.warning(
            f"No .sql files found in `{SQL_DIR}`. "
            "Drop the 25 question files into that folder (they are named "
            "`1.PLAYERS_COUNT.sql` ... `25.QUARTERLY-TIMESERIES.sql`)."
        )
        return

    labels = [f.stem for f in files]
    choice = st.selectbox("Question", labels)
    selected = files[labels.index(choice)]
    script = selected.read_text(encoding="utf-8", errors="ignore")

    with st.expander("Preview SQL", expanded=False):
        st.code(script, language="sql")

    if st.button("Run query", type="primary"):
        with st.spinner("Executing..."):
            results = run_sql_script(script)
        if not results:
            st.info("Query executed - no result set returned.")
        for i, df in enumerate(results, 1):
            st.subheader(f"Result set {i}")
            st.dataframe(df, use_container_width=True)


# ---------------------------------------------------------------------------
# Module 5 - CRUD Operations
# ---------------------------------------------------------------------------

CRUD_TABLE = "players"


def ensure_crud_table() -> None:
    """Create the demo `players` table if it does not yet exist."""
    run_statement(
        f"""
        CREATE TABLE IF NOT EXISTS {CRUD_TABLE} (
            id           INT AUTO_INCREMENT PRIMARY KEY,
            name         VARCHAR(100),
            fullName     VARCHAR(150),
            role         VARCHAR(100),
            battingStyle VARCHAR(100),
            bowlingStyle VARCHAR(100),
            teamName     VARCHAR(100)
        )
        """
    )


def page_crud() -> None:
    """Add / read / update / delete rows in the `players` table."""
    st.title("CRUD Operations")
    st.caption(f"Table: `{CRUD_TABLE}`")

    ensure_crud_table()
    action = st.radio("Action",
                      ["Read", "Create", "Update", "Delete"],
                      horizontal=True)

    if action == "Read":
        df = run_query(f"SELECT * FROM {CRUD_TABLE} ORDER BY id DESC")
        st.dataframe(df, use_container_width=True)
        st.caption(f"{len(df)} row(s).")
        return

    if action == "Create":
        with st.form("create_form"):
            name = st.text_input("Short name")
            full_name = st.text_input("Full name")
            role = st.text_input("Role")
            batting = st.text_input("Batting style")
            bowling = st.text_input("Bowling style")
            team = st.text_input("Team")
            if st.form_submit_button("Insert"):
                ok = run_statement(
                    f"""INSERT INTO {CRUD_TABLE}
                        (name, fullName, role, battingStyle,
                         bowlingStyle, teamName)
                        VALUES (%s, %s, %s, %s, %s, %s)""",
                    (name, full_name, role, batting, bowling, team),
                )
                if ok:
                    st.success("Row inserted.")
        return

    if action == "Update":
        ids = run_query(f"SELECT id, name FROM {CRUD_TABLE} ORDER BY id DESC")
        if ids.empty:
            st.info("No rows to update yet.")
            return
        target = st.selectbox(
            "Row",
            ids["id"].tolist(),
            format_func=lambda i: f"{i} - "
                                  f"{ids.loc[ids['id'] == i, 'name'].iloc[0]}",
        )
        current = run_query(
            f"SELECT * FROM {CRUD_TABLE} WHERE id = %s", (int(target),)
        )
        if current.empty:
            return
        row = current.iloc[0]
        with st.form("update_form"):
            name = st.text_input("Short name", row["name"] or "")
            full_name = st.text_input("Full name", row["fullName"] or "")
            role = st.text_input("Role", row["role"] or "")
            batting = st.text_input("Batting style", row["battingStyle"] or "")
            bowling = st.text_input("Bowling style", row["bowlingStyle"] or "")
            team = st.text_input("Team", row["teamName"] or "")
            if st.form_submit_button("Save"):
                ok = run_statement(
                    f"""UPDATE {CRUD_TABLE}
                        SET name=%s, fullName=%s, role=%s,
                            battingStyle=%s, bowlingStyle=%s, teamName=%s
                        WHERE id=%s""",
                    (name, full_name, role, batting, bowling, team,
                     int(target)),
                )
                if ok:
                    st.success("Row updated.")
        return

    # Delete
    ids = run_query(f"SELECT id, name FROM {CRUD_TABLE} ORDER BY id DESC")
    if ids.empty:
        st.info("No rows to delete.")
        return
    target = st.selectbox(
        "Row to delete",
        ids["id"].tolist(),
        format_func=lambda i: f"{i} - "
                              f"{ids.loc[ids['id'] == i, 'name'].iloc[0]}",
    )
    if st.button("Delete", type="primary"):
        ok = run_statement(
            f"DELETE FROM {CRUD_TABLE} WHERE id=%s", (int(target),)
        )
        if ok:
            st.success("Row deleted.")


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

PAGES = {
    "Home": page_home,
    "Live Matches": page_live_matches,
    "Top Player Stats": page_top_stats,
    "SQL Analytics": page_sql_analytics,
    "CRUD Operations": page_crud,
}


def main() -> None:
    """Set up the Streamlit app shell and dispatch to the chosen module."""
    st.set_page_config(
        page_title="Cricbuzz Live Analytics",
        page_icon=":cricket_bat_and_ball:",
        layout="wide",
    )
    st.sidebar.title("Navigation")
    choice = st.sidebar.radio("Go to", list(PAGES.keys()))
    st.sidebar.markdown("---")
    st.sidebar.caption("Configure credentials in `.env` before running "
                       "Live Matches, Top Stats or SQL Analytics.")

    PAGES[choice]()


if __name__ == "__main__":
    main()
