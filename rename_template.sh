#!/usr/bin/env bash

a=1
for i in $(ls id* | sort -R); do
  new=$(printf "%03d.scss" "$a")
  mv -- "$i" "$new"
  let a=a+1
done
