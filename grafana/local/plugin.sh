#!/usr/bin/env bash

_grafana_internal() {
	local cmd="$1"
	shift
	local args="$*"

	belt_remote_exec <<-SCRIPT
		source "./toolbox/grafana/plugin.sh"
		"$cmd" $args
	SCRIPT
}

grafana_install() {
	_grafana_internal "${FUNCNAME[0]}"
}

grafana_start() {
	_grafana_internal "${FUNCNAME[0]}"
}

grafana_stop() {
	_grafana_internal "${FUNCNAME[0]}"
}

grafana_restart() {
	_grafana_internal "${FUNCNAME[0]}"
}

