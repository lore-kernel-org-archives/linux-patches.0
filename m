Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F81B1C680;
	Mon,  4 Mar 2024 21:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587969; cv=none; b=bSjHKF25qpIOEs+0F3k7cB3QAyEiRKRBw6VzN7x0suP6Y+1PYnkgJfbYuPgnfQbNMBwxJbL7XgtO3lV90VddtTGY4TCXuV2Hg31WGtOWTUvrzzU0Ib6+xBlD3NQ6hv8vAF3zSX9MspHzhDF61ZNlkdUtXeJZGOj0KMo5p5h6HYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587969; c=relaxed/simple;
	bh=0VzPtt8Tp8Iuo64nXBI239qsRdYIMYIbIS33CJlLniQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFYTB+EIHZA2kWVL0xtF34cSlt+yNWoT6TyWGTLfZJkOHBU3Tu80Q1WwjynRtB2rmMvlooWbxMTCiyo/yizB+visBABH6f/Xi7CiDMBC+WVJ2gFBsfKSwWxFTKxwfq7rQtOYXrob9Ouc2VkNH8FeKuB1DrUGMZlVeJ+OiTWnF5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mqdBEHW7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mqdBEHW7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7138C433C7;
	Mon,  4 Mar 2024 21:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587969;
	bh=0VzPtt8Tp8Iuo64nXBI239qsRdYIMYIbIS33CJlLniQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mqdBEHW7pXu5pN2L674vZSHHoz/JaVUXyb4OFPBLstTPsFAAK84TQlRuPgp7/4Dv0
	 pHrwBXap4mY8NxwOgnAmWrgrHVD058LSZD+3UCyxgceCh6FwNUoXUW12S1n8n8wHU1
	 fD9G5BSzzuwErkUINTa2RhIWhBwZC4vNw+Kzabh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matttbe@kernel.org>,
	Geliang Tang <geliang.tang@suse.com>,
	Mat Martineau <martineau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.7 160/162] selftests: mptcp: add mptcp_lib_is_v6
Date: Mon,  4 Mar 2024 21:23:45 +0000
Message-ID: <20240304211556.777592271@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <geliang.tang@suse.com>

commit b850f2c7dd85ecd14a333685c4ffd23f12665e94 upstream.

To avoid duplicated code in different MPTCP selftests, we can add
and use helpers defined in mptcp_lib.sh.

is_v6() helper is defined in mptcp_connect.sh, mptcp_join.sh and
mptcp_sockopt.sh, so export it into mptcp_lib.sh and rename it as
mptcp_lib_is_v6(). Use this new helper in all scripts.

Reviewed-by: Matthieu Baerts <matttbe@kernel.org>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <martineau@kernel.org>
Link: https://lore.kernel.org/r/20231128-send-net-next-2023107-v4-10-8d6b94150f6b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |   16 +++++-----------
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |   14 ++++----------
 tools/testing/selftests/net/mptcp/mptcp_lib.sh     |    5 +++++
 tools/testing/selftests/net/mptcp/mptcp_sockopt.sh |    8 +-------
 4 files changed, 15 insertions(+), 28 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -310,12 +310,6 @@ check_mptcp_disabled()
 	return 0
 }
 
-# $1: IP address
-is_v6()
-{
-	[ -z "${1##*:*}" ]
-}
-
 do_ping()
 {
 	local listener_ns="$1"
@@ -324,7 +318,7 @@ do_ping()
 	local ping_args="-q -c 1"
 	local rc=0
 
-	if is_v6 "${connect_addr}"; then
+	if mptcp_lib_is_v6 "${connect_addr}"; then
 		$ipv6 || return 0
 		ping_args="${ping_args} -6"
 	fi
@@ -620,12 +614,12 @@ run_tests_lo()
 	fi
 
 	# skip if we don't want v6
-	if ! $ipv6 && is_v6 "${connect_addr}"; then
+	if ! $ipv6 && mptcp_lib_is_v6 "${connect_addr}"; then
 		return 0
 	fi
 
 	local local_addr
-	if is_v6 "${connect_addr}"; then
+	if mptcp_lib_is_v6 "${connect_addr}"; then
 		local_addr="::"
 	else
 		local_addr="0.0.0.0"
@@ -693,7 +687,7 @@ run_test_transparent()
 	TEST_GROUP="${msg}"
 
 	# skip if we don't want v6
-	if ! $ipv6 && is_v6 "${connect_addr}"; then
+	if ! $ipv6 && mptcp_lib_is_v6 "${connect_addr}"; then
 		return 0
 	fi
 
@@ -726,7 +720,7 @@ EOF
 	fi
 
 	local local_addr
-	if is_v6 "${connect_addr}"; then
+	if mptcp_lib_is_v6 "${connect_addr}"; then
 		local_addr="::"
 		r6flag="-6"
 	else
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -592,12 +592,6 @@ link_failure()
 	done
 }
 
-# $1: IP address
-is_v6()
-{
-	[ -z "${1##*:*}" ]
-}
-
 # $1: ns, $2: port
 wait_local_port_listen()
 {
@@ -877,7 +871,7 @@ pm_nl_set_endpoint()
 		local id=10
 		while [ $add_nr_ns1 -gt 0 ]; do
 			local addr
-			if is_v6 "${connect_addr}"; then
+			if mptcp_lib_is_v6 "${connect_addr}"; then
 				addr="dead:beef:$counter::1"
 			else
 				addr="10.0.$counter.1"
@@ -929,7 +923,7 @@ pm_nl_set_endpoint()
 		local id=20
 		while [ $add_nr_ns2 -gt 0 ]; do
 			local addr
-			if is_v6 "${connect_addr}"; then
+			if mptcp_lib_is_v6 "${connect_addr}"; then
 				addr="dead:beef:$counter::2"
 			else
 				addr="10.0.$counter.2"
@@ -971,7 +965,7 @@ pm_nl_set_endpoint()
 			pm_nl_flush_endpoint ${connector_ns}
 		elif [ $rm_nr_ns2 -eq 9 ]; then
 			local addr
-			if is_v6 "${connect_addr}"; then
+			if mptcp_lib_is_v6 "${connect_addr}"; then
 				addr="dead:beef:1::2"
 			else
 				addr="10.0.1.2"
@@ -3339,7 +3333,7 @@ userspace_pm_rm_sf()
 	local cnt
 
 	[ "$1" == "$ns2" ] && evts=$evts_ns2
-	if is_v6 $2; then ip=6; fi
+	if mptcp_lib_is_v6 $2; then ip=6; fi
 	tk=$(mptcp_lib_evts_get_info token "$evts")
 	da=$(mptcp_lib_evts_get_info "daddr$ip" "$evts" $t)
 	dp=$(mptcp_lib_evts_get_info dport "$evts" $t)
--- a/tools/testing/selftests/net/mptcp/mptcp_lib.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_lib.sh
@@ -227,6 +227,11 @@ mptcp_lib_kill_wait() {
 	wait "${1}" 2>/dev/null
 }
 
+# $1: IP address
+mptcp_lib_is_v6() {
+	[ -z "${1##*:*}" ]
+}
+
 # $1: ns, $2: MIB counter
 mptcp_lib_get_counter() {
 	local ns="${1}"
--- a/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
@@ -161,12 +161,6 @@ check_transfer()
 	return 0
 }
 
-# $1: IP address
-is_v6()
-{
-	[ -z "${1##*:*}" ]
-}
-
 do_transfer()
 {
 	local listener_ns="$1"
@@ -183,7 +177,7 @@ do_transfer()
 	local mptcp_connect="./mptcp_connect -r 20"
 
 	local local_addr ip
-	if is_v6 "${connect_addr}"; then
+	if mptcp_lib_is_v6 "${connect_addr}"; then
 		local_addr="::"
 		ip=ipv6
 	else


