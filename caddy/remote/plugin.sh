#!/usr/bin/env bash

export CADDY_BINARY="/usr/local/bin/caddy"
export CADDY_CONFIG_DIR="/etc/caddy"
export CADDY_SSL_DIR="/etc/ssl/caddy"
export CADDY_SERVICE_FILE="/etc/systemd/system/caddy.service"
export CADDY_SERVICE="caddy.service"

_caddy_abort() {
	local msg="$1"
	echo "caddy: $msg"
	exit 1
}

caddy_install() {
	if [[ -x "$(command -v caddy)" ]]; then
		return 0
	fi

	(curl -s https://getcaddy.com | bash -s personal &>/dev/null) || _caddy_abort "install failed"

	chown root:root "$CADDY_BINARY"
	chmod 755 "$CADDY_BINARY"

	setcap 'cap_net_bind_service=+eip' "$CADDY_BINARY"

	mkdir -p "$CADDY_CONFIG_DIR/vhosts"
	chown -R root:www-data "$CADDY_CONFIG_DIR"

	mkdir -p "$CADDY_SSL_DIR"
	chown -R www-data:root "$CADDY_SSL_DIR"
	chmod 770 "$CADDY_SSL_DIR"

	cp "./toolbox/caddy/Caddyfile" "$CADDY_CONFIG_DIR/Caddyfile"

	cp "./toolbox/caddy/caddy.service" "$CADDY_SERVICE_FILE"
	chown root:root "$CADDY_SERVICE_FILE"
	chmod 744 "$CADDY_SERVICE_FILE"

	systemctl daemon-reload &>/dev/null || _caddy_abort "systemd reload failed"

	systemctl enable "$CADDY_SERVICE" &>/dev/null || _caddy_abort "systemd enable failed"
}

caddy_start() {
	local ignore_errors="$1"

	if [[ -n "$ignore_errors" ]]; then
		systemctl start "$CADDY_SERVICE" || true
	else
		systemctl start "$CADDY_SERVICE" || _caddy_abort "start failed"
	fi
}

caddy_stop() {
	local ignore_errors="$1"

	if [[ -n "$ignore_errors" ]]; then
		systemctl stop "$CADDY_SERVICE" || true
	else
		systemctl stop "$CADDY_SERVICE" || _caddy_abort "stop failed"
	fi
}

caddy_restart() {
	local ignore_errors="$1"

	if [[ -n "$ignore_errors" ]]; then
		systemctl restart "$CADDY_SERVICE" || true
	else
		systemctl restart "$CADDY_SERVICE" || _caddy_abort "restart failed"
	fi
}
