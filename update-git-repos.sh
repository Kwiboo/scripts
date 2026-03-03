#!/bin/bash

find $PWD -maxdepth 2 -name .git -type d -print0 | while IFS= read -r -d $'\0' line; do
	pushd $(dirname $line)
		git fetch --all
	popd
done
