#!/usr/bin/env bash

echo "Cleaning go files..."
go clean
rm -fr bin

echo "Cleaning vars files..."
rm -f pat_tmp_vars.yml

echo "Cleaning sandbox..."
rm -fr sandbox
