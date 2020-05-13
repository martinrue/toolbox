#!/usr/bin/env bash

export CADDY_BINARY="/usr/bin/caddy"
export CADDY_CONFIG_DIR="/etc/caddy"
export CADDY_SERVICE_FILE="/etc/systemd/system/caddy.service"
export CADDY_SERVICE="caddy.service"

_caddy_abort() {
	local msg="$1"
	echo "caddy: $msg"
	exit 1
}

caddy_install() {
	local tag="$1"
	local asset="$2"
	local url="https://github.com/caddyserver/caddy/releases/download/$tag/$asset"

	if [[ -x "$(command -v caddy)" ]]; then
		return 0
	fi
	
	curl -Ls "$url" -o "/root/caddy.tar.gz" || _caddy_abort "curl failed"

	mkdir -p "/root/caddy" || _caddy_abort "mkdir failed"
	tar -zxf "/root/caddy.tar.gz" -C "/root/caddy" &>/dev/null || _caddy_abort "tar failed"
	mv "/root/caddy/caddy" "$CADDY_BINARY"
	rm -rf "/root/caddy" "/root/caddy.tar.gz" 

	groupadd --system caddy || _caddy_abort "groupadd failed"
	useradd --system --gid caddy --create-home --home-dir /var/lib/caddy --shell /usr/sbin/nologin caddy || _caddy_abort "useradd failed"

	chown caddy:caddy "$CADDY_BINARY"
	chmod 755 "$CADDY_BINARY"
	setcap 'cap_net_bind_service=+eip' "$CADDY_BINARY" || _caddy_abort "setcap failed"

	mkdir -p "$CADDY_CONFIG_DIR/vhosts"
	chown -R caddy:caddy "$CADDY_CONFIG_DIR"

	cp "./toolbox/caddy/Caddyfile" "$CADDY_CONFIG_DIR/Caddyfile"
	chown caddy:caddy "$CADDY_CONFIG_DIR/Caddyfile"

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
