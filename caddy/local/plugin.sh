#!/usr/bin/env bash

_caddy_internal() {
	local cmd="$1"

	belt_remote_exec <<-SCRIPT
		source "./toolbox/caddy/plugin.sh"
		"$cmd"
	SCRIPT
}

caddy_install() {
	_caddy_internal "${FUNCNAME[0]}"
}

caddy_start() {
	_caddy_internal "${FUNCNAME[0]}"
}

caddy_stop() {
	_caddy_internal "${FUNCNAME[0]}"
}

caddy_restart() {
	_caddy_internal "${FUNCNAME[0]}"
}

caddy_add_vhost() {
	local vhost="${1:-"Caddyfile"}"

	belt_remote_exec <<-SCRIPT
		source "./toolbox/caddy/plugin.sh"
		cp "$BELT_ARCHIVE_EXTRACTED_PATH/$vhost" "\$CADDY_CONFIG_DIR/vhosts/$BELT_ARCHIVE_BASENAME.caddy"
	SCRIPT
}
