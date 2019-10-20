#!/usr/bin/env bash

ufw_enable() {
	belt_remote_exec "ufw --force enable &>/dev/null"
}

ufw_disable() {
	belt_remote_exec "ufw --force disable &>/dev/null"
}

ufw_allow() {
	local port="$1"
	belt_remote_exec "ufw allow \"$port\" &>/dev/null"
}

ufw_deny() {
	local port="$1"
	belt_remote_exec "ufw deny \"$port\" &>/dev/null"
}

ufw_deny_from() {
	local host="$1"
	belt_remote_exec "ufw insert 1 deny from \"$host\" to any &>/dev/null"
}
