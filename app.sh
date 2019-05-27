#!/bin/bash

function isTorServiceRunning() {
  isTorRunning="$(/usr/local/bin/brew services ls | grep tor | awk '{ print $2 }' | grep -q started)"

  if [ $isTorRunning -n ]; then
    return 0
  else
    return 1
  fi
}

function isSocksProxyUp() {
  isSocksFirewallProxyRunning="$(/usr/sbin/networksetup -getsocksfirewallproxy Wi-Fi | grep Enabled: | awk '{ print $2 }' | grep -q Yes)"

  if [ $isSocksFirewallProxyRunning -n ]; then
    return 0
  else
    return 1
  fi
}

function startTorDaemon() {
  echo "[+] Starting Tor Daemon"
  /usr/local/bin/brew services start tor
}

function stopTorDaemon() {
  echo "[+] Stopping Tor Daemon"
  /usr/local/bin/brew services stop tor
}


function enableSocksProxy() {
  echo "[+] Enabling Socks5 Proxy"
 /usr/sbin/networksetup -setsocksfirewallproxystate Wi-Fi on 
}

function disableSocksProxy() {
  echo "[+] Disabling Socks5 Proxy"
 /usr/sbin/networksetup -setsocksfirewallproxystate Wi-Fi off 
}


function main() {
  isTorEnabled=isTorServiceRunning 
  isSocksProxyEnabled=isSocksProxyUp

  if [ isTorEnabled == 1 ] && [ isSocksProxyEnabled == 1 ]; then
    stopTorDaemon
    disableSocksProxy
  else
    startTorDaemon
    enableSocksProxy
  fi

}

main

