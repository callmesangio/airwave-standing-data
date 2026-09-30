# airwave-standing-data

Flattened, always-up-to-date CSV snapshots of the [Virtual Radar Server standing
data](https://github.com/vradarserver/standing-data) set: aircraft, airlines,
airports and routes. They exist to feed
[airwave](https://github.com/callmesangio/airwave), which pulls them on a
schedule to enrich the live traffic it tracks.

Upstream splits most datasets across hundreds of small CSV files (one per
registration prefix, country, airline code, and so on). This repository
concatenates each of those into a single CSV file that can be downloaded and
parsed in one go, copies the ones upstream already ships whole, and refreshes
them all automatically.

## Contents

| File | Description |
| --- | --- |
| `csv/aircraft.csv` | Aircraft registry: ICAO hex, registration, type, operator |
| `csv/airlines.csv` | Airlines: ICAO/IATA codes, name, flight patterns |
| `csv/airports.csv` | Airports: ICAO/IATA codes, name, location, coordinates |
| `csv/routes.csv` | Callsign-to-route mappings |

All four files are UTF-8 with a BOM, comma-separated, with a single header row
carried over from upstream.

## Regenerating locally

Requires `bash`, `git`, `find` and `awk`.

```bash
bash generate.sh
```

`generate.sh` shallow-clones upstream into a temporary directory, then for each
split dataset writes the header of the first CSV it finds followed by the body
rows of every CSV in that directory. Upstream ships airlines as a single file,
so that one is copied verbatim. Everything is written under `csv/`, overwriting
what is there.

## Automation

`.github/workflows/autoupdate.yaml` runs `generate.sh` every six hours (at :16)
and on manual dispatch. If the regenerated files differ from what is committed,
it pushes a single commit as `github-actions[bot]`. Nothing is committed when
upstream has not changed.

Dependabot keeps the workflow's actions current on a weekly schedule.

## Data corrections

Do not send data fixes here: this repository only reshapes upstream content.
Submit corrections to aircraft, airlines, airports and routes through the
Virtual Radar Server [Standing Data
Maintenance](https://sdm.virtualradarserver.co.uk/Edit) site.

## License and credits

The tooling in this repository is released under the MIT License (see
`LICENSE`).

The data itself originates from
[vradarserver/standing-data](https://github.com/vradarserver/standing-data) and
remains subject to its terms; see the Virtual Radar Server
[credits](https://www.virtualradarserver.co.uk/Credits.aspx) for the
contributors behind it.
