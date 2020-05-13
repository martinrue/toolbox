#!/usr/bin/env bash

_caddy_internal() {
	local cmd="$1"

	belt_remote_exec <<-SCRIPT
		source "./toolbox/caddy/plugin.sh"
		"$cmd"
	SCRIPT
}

caddy_install() {
	local tag="${1:-"v2.0.0"}"
	local asset="${2:-"caddy_2.0.0_linux_amd64.tar.gz"}"

	belt_remote_exec <<-SCRIPT
		source "./toolbox/caddy/plugin.sh"
		caddy_install "$tag" "$asset"
	SCRIPT
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
