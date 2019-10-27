#!/usr/bin/env bash

export GRAFANA_SERVICE="grafana-server.service"
export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

_grafana_abort() {
	local msg="$1"
	echo "grafana: $msg"
	exit 1
}

grafana_install() {
	curl -Ls https://packages.grafana.com/gpg.key | apt-key add - &>/dev/null || _grafana_abort "apt-key add failed"
	add-apt-repository "deb https://packages.grafana.com/oss/deb stable main" &>/dev/null || _grafana_abort "add-app-repository failed"

	apt-get update &>/dev/null || _grafana_abort "apt-get update failed"
	apt-get install -y grafana &>/dev/null || _grafana_abort "apt-get install failed"

	systemctl daemon-reload &>/dev/null || _grafana_abort "systemd reload failed"
	systemctl enable "$GRAFANA_SERVICE" &>/dev/null || _grafana_abort "systemd enable failed"
}

grafana_start() {
	local ignore_errors="$1"

	if [[ -n "$ignore_errors" ]]; then
		systemctl start "$GRAFANA_SERVICE" || true
	else
		systemctl start "$GRAFANA_SERVICE" || _grafana_abort "start failed"
	fi
}

grafana_stop() {
	local ignore_errors="$1"

	if [[ -n "$ignore_errors" ]]; then
		systemctl stop "$GRAFANA_SERVICE" || true
	else
		systemctl stop "$GRAFANA_SERVICE" || _grafana_abort "stop failed"
	fi
}

grafana_restart() {
	local ignore_errors="$1"

	if [[ -n "$ignore_errors" ]]; then
		systemctl restart "$GRAFANA_SERVICE" || true
	else
		systemctl restart "$GRAFANA_SERVICE" || _grafana_abort "restart failed"
	fi
}
