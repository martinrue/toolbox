#!/usr/bin/env bash

_postgresql_internal() {
	local cmd="$1"
	shift
	local args="$*"

	belt_remote_exec <<-SCRIPT
		source "./toolbox/postgresql/plugin.sh"
		"$cmd" $args
	SCRIPT
}

postgresql_install() {
	_postgresql_internal "${FUNCNAME[0]}"
}

postgresql_start() {
	_postgresql_internal "${FUNCNAME[0]}"
}

postgresql_stop() {
	_postgresql_internal "${FUNCNAME[0]}"
}

postgresql_restart() {
	_postgresql_internal "${FUNCNAME[0]}"
}

postgresql_psql_exec() {
	_postgresql_internal "${FUNCNAME[0]}" "$@"
}

postgresql_create_database() {
	_postgresql_internal "${FUNCNAME[0]}" "$@"
}

postgresql_create_role() {
	_postgresql_internal "${FUNCNAME[0]}" "$@"
}

postgresql_add_role_to_db() {
	_postgresql_internal "${FUNCNAME[0]}" "$@"
}
