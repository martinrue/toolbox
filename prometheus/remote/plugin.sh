#!/usr/bin/env bash

export PROMETHEUS_DIR="/prometheus"
export PROMETHEUS_SERVICE="prometheus.service"
export PROMETHEUS_SERVICE_PATH="/etc/systemd/system/$PROMETHEUS_SERVICE"

_prometheus_abort() {
	local msg="$1"
	echo "prometheus: $msg"
	exit 1
}

prometheus_install() {
	local version="${1:-"2.13.1"}"
	local url="https://github.com/prometheus/prometheus/releases/download/v$version/prometheus-$version.linux-amd64.tar.gz"

	if [[ -d "$PROMETHEUS_DIR" ]]; then
		return 0
	fi

	mkdir -p "$PROMETHEUS_DIR"

	curl -Ls "$url" -o "/prometheus.tar.gz" || _prometheus_abort "curl failed"
	tar -zxf "/prometheus.tar.gz" -C "$PROMETHEUS_DIR" &>/dev/null || _prometheus_abort "tar failed"
	rm -rf "/prometheus.tar.gz"

	adduser --no-create-home --disabled-login "prometheus" &>/dev/null || _prometheus_abort "adduser failed"
	chown -R "prometheus" "$PROMETHEUS_DIR"
	chmod -R 770 "$PROMETHEUS_DIR"

	cp "./toolbox/prometheus/$PROMETHEUS_SERVICE" "$PROMETHEUS_SERVICE_PATH"
	sed -i "s/:VERSION/$version/g" "$PROMETHEUS_SERVICE_PATH"

	systemctl daemon-reload &>/dev/null || _prometheus_abort "systemd reload failed"
	systemctl enable "$PROMETHEUS_SERVICE" &>/dev/null || _prometheus_abort "systemd enable failed"
}

prometheus_start() {
	local ignore_errors="$1"

	if [[ -n "$ignore_errors" ]]; then
		systemctl start "$PROMETHEUS_SERVICE" || true
	else
		systemctl start "$PROMETHEUS_SERVICE" || _prometheus_abort "start failed"
	fi
}

prometheus_stop() {
	local ignore_errors="$1"

	if [[ -n "$ignore_errors" ]]; then
		systemctl stop "$PROMETHEUS_SERVICE" || true
	else
		systemctl stop "$PROMETHEUS_SERVICE" || _prometheus_abort "stop failed"
	fi
}

prometheus_restart() {
	local ignore_errors="$1"

	if [[ -n "$ignore_errors" ]]; then
		systemctl restart "$PROMETHEUS_SERVICE" || true
	else
		systemctl restart "$PROMETHEUS_SERVICE" || _prometheus_abort "restart failed"
	fi
}
