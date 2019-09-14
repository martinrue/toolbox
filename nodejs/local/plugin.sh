#!/usr/bin/env bash

nodejs_install() {
	local version="${1:-"10"}"

	belt_remote_exec <<-SCRIPT
		source ./toolbox/nodejs/plugin.sh
		nodejs_install "$version"
	SCRIPT
}
