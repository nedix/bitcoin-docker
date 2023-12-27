#!/usr/bin/env sh

. "${0%/*}/testcase.sh"

setup

${0%/*}/external-mode/it_should_dispatch_notifications.sh
${0%/*}/external-mode/it_should_discover_public_peers.sh
${0%/*}/external-mode/it_should_download_blocks.sh
${0%/*}/external-mode/it_should_respond_to_rpcs.sh
${0%/*}/external-mode/it_shouldnt_respond_to_wallet_rpcs.sh

${0%/*}/internal-mode/it_should_dispatch_notifications.sh
${0%/*}/internal-mode/it_should_connect_to_one_specific_peer.sh
${0%/*}/internal-mode/it_should_respond_to_rpcs.sh
