#!/usr/bin/env bash

_nodejs_abort() {
	local msg="$1"
	echo "nodejs: $msg"
	exit 1
}

nodejs_install() {
	local version="$1"

	if [ -x "$(command -v node)" ]; then
		return 0
	fi

	curl -sL https://deb.nodesource.com/setup_"$version".x | sudo -E bash - &>/dev/null
	apt install --yes nodejs &>/dev/null || _nodejs_abort "apt installed failed"
}
