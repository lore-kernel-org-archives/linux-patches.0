Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2902D3396E4;
	Tue, 16 Dec 2025 11:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884707; cv=none; b=hDOwMpUGbYTw65/a2CwMS8tdKm8qgWEpx3ODNGLQW9oJ6yuMQ1g3v1qAYDzbAx73X+LTJygN4x33URskX+ejGuNs+wFEmkvEr9X0qOkSA3LijljuFTygbDh30LkaIrhwWsYrIJ888n8NEBZ8I4IGY0X2nX0jBYZR/hJ/MHUhN0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884707; c=relaxed/simple;
	bh=NbRc2lMHdjSTN6EMHCO/ZjNFKTaJXZRgiLwxlHLEX4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PsUQJyPfu9QDMQ4dmDpv+8NDnFcQvOddOQ8/ccgShUhtCn9tMkbipEaxdguCTIDCQtrwVaZE8jPYoLb+wI9/rTLjYiVzB1DEtceNPGbgwyTzepYKnokwftRn2I9fiXdBQbTIQV2nJWNZ/My2ZkWk2NGL/tR4uj8k/ApTb7JpKa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZqhOFDz0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZqhOFDz0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C58BC4CEF1;
	Tue, 16 Dec 2025 11:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884707;
	bh=NbRc2lMHdjSTN6EMHCO/ZjNFKTaJXZRgiLwxlHLEX4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZqhOFDz0wH+Ji0kq/+xSeG8bZV/gx2dHxEoN7vOoDSepkXxLV5eAP4Wjf8Yv47Qmr
	 UC+xeJslnJYgID0wSghTouVXgxWHtHPMLVyGqnHZnou0DVuIvIAN3r3VOm6fFL6ia4
	 J46Xr59jhYWGwqDTjXOFxz/tmdPxepKRcK476XEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Etienne Champetier <champetier.etienne@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 273/354] selftests: bonding: add ipvlan over bond testing
Date: Tue, 16 Dec 2025 12:14:00 +0100
Message-ID: <20251216111330.806433080@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Etienne Champetier <champetier.etienne@gmail.com>

[ Upstream commit 08ac69b24507ab06871c18adc421c9d4f1008c61 ]

This rework bond_macvlan.sh into bond_macvlan_ipvlan.sh
We only test bridge mode for macvlan and l2 mode

]# ./bond_macvlan_ipvlan.sh
TEST: active-backup/macvlan_bridge: IPv4: client->server            [ OK ]
...
TEST: active-backup/ipvlan_l2: IPv4: client->server                 [ OK ]
...
TEST: balance-tlb/macvlan_bridge: IPv4: client->server              [ OK ]
...
TEST: balance-tlb/ipvlan_l2: IPv4: client->server                   [ OK ]
...
TEST: balance-alb/macvlan_bridge: IPv4: client->server              [ OK ]
...
TEST: balance-alb/ipvlan_l2: IPv4: client->server                   [ OK ]
...

Signed-off-by: Etienne Champetier <champetier.etienne@gmail.com>
Link: https://patch.msgid.link/20250109032819.326528-3-champetier.etienne@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 2c28ee720ad1 ("selftests: bonding: add delay before each xvlan_over_bond connectivity check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/drivers/net/bonding/Makefile    |  2 +-
 .../drivers/net/bonding/bond_macvlan.sh       | 99 -------------------
 .../net/bonding/bond_macvlan_ipvlan.sh        | 96 ++++++++++++++++++
 .../selftests/drivers/net/bonding/config      |  1 +
 4 files changed, 98 insertions(+), 100 deletions(-)
 delete mode 100755 tools/testing/selftests/drivers/net/bonding/bond_macvlan.sh
 create mode 100755 tools/testing/selftests/drivers/net/bonding/bond_macvlan_ipvlan.sh

diff --git a/tools/testing/selftests/drivers/net/bonding/Makefile b/tools/testing/selftests/drivers/net/bonding/Makefile
index 03a089165d3fb..2b10854e4b1e3 100644
--- a/tools/testing/selftests/drivers/net/bonding/Makefile
+++ b/tools/testing/selftests/drivers/net/bonding/Makefile
@@ -10,7 +10,7 @@ TEST_PROGS := \
 	mode-2-recovery-updelay.sh \
 	bond_options.sh \
 	bond-eth-type-change.sh \
-	bond_macvlan.sh
+	bond_macvlan_ipvlan.sh
 
 TEST_FILES := \
 	lag_lib.sh \
diff --git a/tools/testing/selftests/drivers/net/bonding/bond_macvlan.sh b/tools/testing/selftests/drivers/net/bonding/bond_macvlan.sh
deleted file mode 100755
index b609fb6231f48..0000000000000
--- a/tools/testing/selftests/drivers/net/bonding/bond_macvlan.sh
+++ /dev/null
@@ -1,99 +0,0 @@
-#!/bin/bash
-# SPDX-License-Identifier: GPL-2.0
-#
-# Test macvlan over balance-alb
-
-lib_dir=$(dirname "$0")
-source ${lib_dir}/bond_topo_2d1c.sh
-
-m1_ns="m1-$(mktemp -u XXXXXX)"
-m2_ns="m1-$(mktemp -u XXXXXX)"
-m1_ip4="192.0.2.11"
-m1_ip6="2001:db8::11"
-m2_ip4="192.0.2.12"
-m2_ip6="2001:db8::12"
-
-cleanup()
-{
-	ip -n ${m1_ns} link del macv0
-	ip netns del ${m1_ns}
-	ip -n ${m2_ns} link del macv0
-	ip netns del ${m2_ns}
-
-	client_destroy
-	server_destroy
-	gateway_destroy
-}
-
-check_connection()
-{
-	local ns=${1}
-	local target=${2}
-	local message=${3:-"macvlan_over_bond"}
-	RET=0
-
-
-	ip netns exec ${ns} ping ${target} -c 4 -i 0.1 &>/dev/null
-	check_err $? "ping failed"
-	log_test "$mode: $message"
-}
-
-macvlan_over_bond()
-{
-	local param="$1"
-	RET=0
-
-	# setup new bond mode
-	bond_reset "${param}"
-
-	ip -n ${s_ns} link add link bond0 name macv0 type macvlan mode bridge
-	ip -n ${s_ns} link set macv0 netns ${m1_ns}
-	ip -n ${m1_ns} link set dev macv0 up
-	ip -n ${m1_ns} addr add ${m1_ip4}/24 dev macv0
-	ip -n ${m1_ns} addr add ${m1_ip6}/24 dev macv0
-
-	ip -n ${s_ns} link add link bond0 name macv0 type macvlan mode bridge
-	ip -n ${s_ns} link set macv0 netns ${m2_ns}
-	ip -n ${m2_ns} link set dev macv0 up
-	ip -n ${m2_ns} addr add ${m2_ip4}/24 dev macv0
-	ip -n ${m2_ns} addr add ${m2_ip6}/24 dev macv0
-
-	sleep 2
-
-	check_connection "${c_ns}" "${s_ip4}" "IPv4: client->server"
-	check_connection "${c_ns}" "${s_ip6}" "IPv6: client->server"
-	check_connection "${c_ns}" "${m1_ip4}" "IPv4: client->macvlan_1"
-	check_connection "${c_ns}" "${m1_ip6}" "IPv6: client->macvlan_1"
-	check_connection "${c_ns}" "${m2_ip4}" "IPv4: client->macvlan_2"
-	check_connection "${c_ns}" "${m2_ip6}" "IPv6: client->macvlan_2"
-	check_connection "${m1_ns}" "${m2_ip4}" "IPv4: macvlan_1->macvlan_2"
-	check_connection "${m1_ns}" "${m2_ip6}" "IPv6: macvlan_1->macvlan_2"
-
-
-	sleep 5
-
-	check_connection "${s_ns}" "${c_ip4}" "IPv4: server->client"
-	check_connection "${s_ns}" "${c_ip6}" "IPv6: server->client"
-	check_connection "${m1_ns}" "${c_ip4}" "IPv4: macvlan_1->client"
-	check_connection "${m1_ns}" "${c_ip6}" "IPv6: macvlan_1->client"
-	check_connection "${m2_ns}" "${c_ip4}" "IPv4: macvlan_2->client"
-	check_connection "${m2_ns}" "${c_ip6}" "IPv6: macvlan_2->client"
-	check_connection "${m2_ns}" "${m1_ip4}" "IPv4: macvlan_2->macvlan_2"
-	check_connection "${m2_ns}" "${m1_ip6}" "IPv6: macvlan_2->macvlan_2"
-
-	ip -n ${c_ns} neigh flush dev eth0
-}
-
-trap cleanup EXIT
-
-setup_prepare
-ip netns add ${m1_ns}
-ip netns add ${m2_ns}
-
-modes="active-backup balance-tlb balance-alb"
-
-for mode in $modes; do
-	macvlan_over_bond "mode $mode"
-done
-
-exit $EXIT_STATUS
diff --git a/tools/testing/selftests/drivers/net/bonding/bond_macvlan_ipvlan.sh b/tools/testing/selftests/drivers/net/bonding/bond_macvlan_ipvlan.sh
new file mode 100755
index 0000000000000..c4711272fe45d
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/bonding/bond_macvlan_ipvlan.sh
@@ -0,0 +1,96 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test macvlan/ipvlan over bond
+
+lib_dir=$(dirname "$0")
+source ${lib_dir}/bond_topo_2d1c.sh
+
+xvlan1_ns="xvlan1-$(mktemp -u XXXXXX)"
+xvlan2_ns="xvlan2-$(mktemp -u XXXXXX)"
+xvlan1_ip4="192.0.2.11"
+xvlan1_ip6="2001:db8::11"
+xvlan2_ip4="192.0.2.12"
+xvlan2_ip6="2001:db8::12"
+
+cleanup()
+{
+	client_destroy
+	server_destroy
+	gateway_destroy
+
+	ip netns del ${xvlan1_ns}
+	ip netns del ${xvlan2_ns}
+}
+
+check_connection()
+{
+	local ns=${1}
+	local target=${2}
+	local message=${3}
+	RET=0
+
+	ip netns exec ${ns} ping ${target} -c 4 -i 0.1 &>/dev/null
+	check_err $? "ping failed"
+	log_test "${bond_mode}/${xvlan_type}_${xvlan_mode}: ${message}"
+}
+
+xvlan_over_bond()
+{
+	local param="$1"
+	local xvlan_type="$2"
+	local xvlan_mode="$3"
+	RET=0
+
+	# setup new bond mode
+	bond_reset "${param}"
+
+	ip -n ${s_ns} link add link bond0 name ${xvlan_type}0 type ${xvlan_type} mode ${xvlan_mode}
+	ip -n ${s_ns} link set ${xvlan_type}0 netns ${xvlan1_ns}
+	ip -n ${xvlan1_ns} link set dev ${xvlan_type}0 up
+	ip -n ${xvlan1_ns} addr add ${xvlan1_ip4}/24 dev ${xvlan_type}0
+	ip -n ${xvlan1_ns} addr add ${xvlan1_ip6}/24 dev ${xvlan_type}0
+
+	ip -n ${s_ns} link add link bond0 name ${xvlan_type}0 type ${xvlan_type} mode ${xvlan_mode}
+	ip -n ${s_ns} link set ${xvlan_type}0 netns ${xvlan2_ns}
+	ip -n ${xvlan2_ns} link set dev ${xvlan_type}0 up
+	ip -n ${xvlan2_ns} addr add ${xvlan2_ip4}/24 dev ${xvlan_type}0
+	ip -n ${xvlan2_ns} addr add ${xvlan2_ip6}/24 dev ${xvlan_type}0
+
+	sleep 2
+
+	check_connection "${c_ns}" "${s_ip4}" "IPv4: client->server"
+	check_connection "${c_ns}" "${s_ip6}" "IPv6: client->server"
+	check_connection "${c_ns}" "${xvlan1_ip4}" "IPv4: client->${xvlan_type}_1"
+	check_connection "${c_ns}" "${xvlan1_ip6}" "IPv6: client->${xvlan_type}_1"
+	check_connection "${c_ns}" "${xvlan2_ip4}" "IPv4: client->${xvlan_type}_2"
+	check_connection "${c_ns}" "${xvlan2_ip6}" "IPv6: client->${xvlan_type}_2"
+	check_connection "${xvlan1_ns}" "${xvlan2_ip4}" "IPv4: ${xvlan_type}_1->${xvlan_type}_2"
+	check_connection "${xvlan1_ns}" "${xvlan2_ip6}" "IPv6: ${xvlan_type}_1->${xvlan_type}_2"
+
+	check_connection "${s_ns}" "${c_ip4}" "IPv4: server->client"
+	check_connection "${s_ns}" "${c_ip6}" "IPv6: server->client"
+	check_connection "${xvlan1_ns}" "${c_ip4}" "IPv4: ${xvlan_type}_1->client"
+	check_connection "${xvlan1_ns}" "${c_ip6}" "IPv6: ${xvlan_type}_1->client"
+	check_connection "${xvlan2_ns}" "${c_ip4}" "IPv4: ${xvlan_type}_2->client"
+	check_connection "${xvlan2_ns}" "${c_ip6}" "IPv6: ${xvlan_type}_2->client"
+	check_connection "${xvlan2_ns}" "${xvlan1_ip4}" "IPv4: ${xvlan_type}_2->${xvlan_type}_1"
+	check_connection "${xvlan2_ns}" "${xvlan1_ip6}" "IPv6: ${xvlan_type}_2->${xvlan_type}_1"
+
+	ip -n ${c_ns} neigh flush dev eth0
+}
+
+trap cleanup EXIT
+
+setup_prepare
+ip netns add ${xvlan1_ns}
+ip netns add ${xvlan2_ns}
+
+bond_modes="active-backup balance-tlb balance-alb"
+
+for bond_mode in ${bond_modes}; do
+	xvlan_over_bond "mode ${bond_mode}" macvlan bridge
+	xvlan_over_bond "mode ${bond_mode}" ipvlan  l2
+done
+
+exit $EXIT_STATUS
diff --git a/tools/testing/selftests/drivers/net/bonding/config b/tools/testing/selftests/drivers/net/bonding/config
index 899d7fb6ea8e9..dad4e5fda4db3 100644
--- a/tools/testing/selftests/drivers/net/bonding/config
+++ b/tools/testing/selftests/drivers/net/bonding/config
@@ -3,6 +3,7 @@ CONFIG_BRIDGE=y
 CONFIG_DUMMY=y
 CONFIG_IPV6=y
 CONFIG_MACVLAN=y
+CONFIG_IPVLAN=y
 CONFIG_NET_ACT_GACT=y
 CONFIG_NET_CLS_FLOWER=y
 CONFIG_NET_SCH_INGRESS=y
-- 
2.51.0



