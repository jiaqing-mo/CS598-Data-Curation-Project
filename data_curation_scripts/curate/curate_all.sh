#!/usr/bin/env bash
set -euo pipefail

echo "=== Curating grades (must run first) ==="
python -m curate.grades

echo "=== Curating calendar ==="
python -m curate.calendar

echo "=== Curating dinning ==="
python -m curate.dinning

echo "=== Curating sms ==="
python -m curate.sms

echo "=== Curating call_log ==="
python -m curate.call_log

echo "=== Curating app_usage ==="
python -m curate.app_usage

echo "=== Curating education_piazza ==="
python -m curate.piazza

echo "=== Curating class enrollments ==="
python -m curate.classes

echo "=== Curating deadlines ==="
python -m curate.deadlines

echo "=== Curating sensing/activity ==="
python -m curate.activity

echo "=== All curation jobs completed successfully ==="