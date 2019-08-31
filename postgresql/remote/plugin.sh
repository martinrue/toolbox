#!/usr/bin/env bash

export POSTGRESQL_SERVICE="postgresql@11-main.service"

_postgresql_abort() {
	local msg="$1"
	echo "postgresql: $msg"
	exit 1
}

postgresql_install() {
	if [ -x "$(command -v psql)" ]; then
		return 0
	fi

	curl -s https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - &>/dev/null \
		|| _postgresql_abort "apt-key add failed"

	sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -sc)-pgdg main" > /etc/apt/sources.list.d/PostgreSQL.list' \
		|| _postgresql_abort "add sources.list failed"

	apt update &>/dev/null || _postgresql_abort "apt update failed"

	apt install --yes postgresql-11 &>/dev/null || _postgresql_abort "apt install failed"
}

postgresql_psql_exec() {
	local cmd="$1"
	cd /usr/lib/postgresql && sudo -u postgres psql -c "$cmd"
}

postgresql_create_database() {
	local db="$1"
	postgresql_psql_exec "CREATE DATABASE $db;" &>/dev/null || _postgresql_abort "create database failed"
}

postgresql_create_role() {
	local role="$1"
	local password="$2"

	postgresql_psql_exec "CREATE USER $role WITH ENCRYPTED PASSWORD '$password';" &>/dev/null \
		|| _postgresql_abort "create role failed"
}

postgresql_add_role_to_database() {
	local role="$1"
	local db="$2"

	postgresql_psql_exec "GRANT ALL ON DATABASE $db TO $role;" &>/dev/null \
		|| _postgresql_abort "grant all failed"
}

postgresql_start() {
	local ignore_errors="$1"

	if [ -n "$ignore_errors" ]; then
		systemctl start "$POSTGRESQL_SERVICE" || true
	else
		systemctl start "$POSTGRESQL_SERVICE" || _postgresql_abort "start failed"
	fi
}

postgresql_stop() {
	local ignore_errors="$1"

	if [ -n "$ignore_errors" ]; then
		systemctl stop "$POSTGRESQL_SERVICE" || true
	else
		systemctl stop "$POSTGRESQL_SERVICE" || _postgresql_abort "stop failed"
	fi
}

postgresql_restart() {
	local ignore_errors="$1"

	if [ -n "$ignore_errors" ]; then
		systemctl restart "$POSTGRESQL_SERVICE" || true
	else
		systemctl restart "$POSTGRESQL_SERVICE" || _postgresql_abort "restart failed"
	fi
}