#!/bin/bash

grep "LOCATION Wikipedia" /scratch/users/$USER/outputs/coreEntities/*.out | sed 's/.*\=//' | sed 's/]//' > /scratch/users/$USER/outputs/coreEntities/entities.txt
