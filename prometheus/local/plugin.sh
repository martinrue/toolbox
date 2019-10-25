#!/usr/bin/env bash

_prometheus_internal() {
	local cmd="$1"
	shift
	local args="$*"

	belt_remote_exec <<-SCRIPT
		source "./toolbox/prometheus/plugin.sh"
		"$cmd" $args
	SCRIPT
}

prometheus_install() {
	_prometheus_internal "${FUNCNAME[0]}"
}

prometheus_start() {
	_prometheus_internal "${FUNCNAME[0]}"
}

prometheus_stop() {
	_prometheus_internal "${FUNCNAME[0]}"
}

prometheus_restart() {
	_prometheus_internal "${FUNCNAME[0]}"
}

prometheus_update_config() {
	local version="${1:-"2.13.1"}"

	belt_remote_exec <<-SCRIPT
		cp "$BELT_ARCHIVE_EXTRACTED_PATH/prometheus.yml" "/prometheus/prometheus-$version.linux-amd64"
	SCRIPT
}
