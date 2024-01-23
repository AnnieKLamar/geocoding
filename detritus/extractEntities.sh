#!/bin/bash
# 1/23/24 now part of wikification.sh
grep "LOCATION Wikipedia" /scratch/users/$USER/outputs/coreEntities/*.out | sed 's/.*\=//' | sed 's/]//' > /scratch/users/$USER/outputs/coreEntities/entities.txt
