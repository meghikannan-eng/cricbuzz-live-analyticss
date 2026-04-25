# Cricbuzz Live Analytics

A Streamlit dashboard that pulls live cricket data from the Cricbuzz
RapidAPI feed, stores historical results in MySQL, and lets you run 25
pre-built analytical SQL queries with one click.

## Modules

| Module | What it does |
| --- | --- |
| Home | Landing page plus a health check for the API key and DB connection. |
| Live Matches | Live, upcoming and recently-completed international matches. |
| Top Player Stats | ICC batting / bowling / all-rounder rankings per format. |
| SQL Analytics | Runs any of the 25 question files against MySQL and shows the result tables. |
| CRUD Operations | Create / read / update / delete rows in the `players` table. |

## Project structure

```
cricbuzz_project/
├── main.py               # Streamlit app (all 4 modules)
├── requirements.txt      # Dependencies
├── schema.sql            # Consolidated schema + sample seed data
├── README.md             # This file
├── .env.example          # Template for credentials
├── .gitignore
└── sql_questions/        # Drop the 25 .sql question files here
    ├── 1.PLAYERS_COUNT.sql
    ├── 2.RECENT-MATCHES.sql
    ...
    └── 25.QUARTERLY-TIMESERIES.sql
```

## Setup

### 1. Clone / copy the project

```bash
git clone <your-repo-url> cricbuzz_project
cd cricbuzz_project
```

### 2. Create a virtual environment and install dependencies

```bash
python -m venv .venv
# Windows
.venv\Scripts\activate
# macOS / Linux
source .venv/bin/activate

pip install -r requirements.txt
```

### 3. Configure secrets

Copy `.env.example` to `.env` and fill in your own values:

```bash
cp .env.example .env
```

```dotenv
RAPIDAPI_KEY=your_rapidapi_key_here
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_mysql_password_here
DB_NAME=cricket_db
```

Get a free RapidAPI key from
<https://rapidapi.com/cricketapilive/api/cricbuzz-cricket>.

### 4. Initialise the database

```bash
mysql -u root -p < schema.sql
```

This creates the `cricket_db` database, every table required by the 25
analytical questions, and a small sample seed so queries have something to
return even before the API-populated notebooks run.

### 5. Drop the SQL questions into place

Place the 25 question files into `./sql_questions/`. They should be named
`1.PLAYERS_COUNT.sql` ... `25.QUARTERLY-TIMESERIES.sql`. The dashboard
picks them up automatically in numerical order.

### 6. Run the dashboard

```bash
streamlit run main.py
```

Streamlit opens at <http://localhost:8501>. Use the sidebar to switch
between the five pages.

## API key configuration

The RapidAPI key is read from `RAPIDAPI_KEY` in the `.env` file. It is
never hard-coded in `main.py`, which means you can safely commit the
source to Git. If the key is missing the dashboard still starts, but the
Live Matches and Top Player Stats pages show a "key missing" message
instead of calling the API.

## Development notes

* **PEP 8** - the code follows PEP 8 style with type hints and docstrings
  on every function.
* **Error handling** - every API call is wrapped in a try/except that
  catches `requests.RequestException` and falls back to an empty payload;
  every database call catches `mysql.connector.Error` and surfaces a
  friendly message via `st.error`.
* **Modularity** - each of the five pages is its own `page_*` function,
  and network / DB plumbing lives in dedicated helpers (`api_get`,
  `get_connection`, `run_query`, `run_statement`, `run_sql_script`).
* **Caching** - `api_get` is wrapped in `@st.cache_data(ttl=60)` so
  refreshing the dashboard doesn't hammer the RapidAPI free tier.

## Version control

```bash
git init
git add .
git commit -m "Initial commit: Cricbuzz Live Analytics dashboard"
```

`.gitignore` already excludes `.env`, the virtualenv directory and
Python build artefacts.

## Troubleshooting

| Symptom | Fix |
| --- | --- |
| *"Could not connect to MySQL"* | Check `DB_*` values in `.env`; make sure the MySQL server is running. |
| *"API call failed"* | Verify your `RAPIDAPI_KEY` and that the RapidAPI free-tier quota isn't exhausted. |
| *"No .sql files found"* | Populate the `./sql_questions/` folder with the 25 question files. |
| Live page is empty | The live feed returns no matches when none are in play - try the Upcoming or Recent tab. |
