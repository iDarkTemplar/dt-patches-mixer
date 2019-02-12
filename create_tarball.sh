#!/bin/bash

output_dir=$1
version=$2
project=$3

usage() {
	echo "Usage: $0 output_dir [ version [ project_name_override ] ]"
}

if [ -z "${output_dir}" ] ; then
	usage
	exit 1
fi

if [ ! -d "${output_dir}" ] ; then
	echo "Error: ${output_dir} is not a valid directory"
	usage
	exit 1
fi

project_dir="$(dirname "$(readlink -e $0)")"

if [ -z "${project}" ] ; then
	project="$(basename "${project_dir}")"
fi

filename=${project}.tar.bz2

if [ ! -z "$version" ] ; then
	filename=${project}-${version}.tar.bz2
fi

cd "${project_dir}"

tar --owner=root --group=root --mtime="$(git log -1 --format=%ci --no-show-signature)" -cjvf "${output_dir}/$filename" $(git ls-files | grep -v '^create_tarball.sh$')
echo "Created \"${output_dir}/$filename\""
