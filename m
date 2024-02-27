Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD6E13A25D;
	Tue, 27 Feb 2024 13:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041422; cv=none; b=sZZVCSHy+v970dpcJy2g7m00MMQSDr61bmoaUovsP7svDVwCjWw+YhGUVqJ84NUZSy2ylxe0EtL676lzovdOw4hXE/o+vw8A2Wrx7n74rp0oY9oPZ5CVmd3wTkkyl8MsgXBm46WC5my0h5SP6t+CmoVbe2VdVWVNqT9ZY7itkfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041422; c=relaxed/simple;
	bh=NMBRxP9lMbFtDZAPScFh0rd5UnY2hSWMYdN5fJwel9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r51Z3s9rHscZJguYGGaf7qrZ3Cbna4KSjkRwSVfBdRLyuWY+l08+yKPBrjjoMQkeG6Vp2Bh1E/sqmdQSv5d8bXaDH2b+6+A/9/4Tf9GXvZhw0VMSJWGoqk8PFq6J/Ed5LWjW9Ly8uIyDPXpOHpnfNaIiJJ2H5o5PP8r1hqzXwxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vpUHiwEG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vpUHiwEG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BDFDC433F1;
	Tue, 27 Feb 2024 13:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041421;
	bh=NMBRxP9lMbFtDZAPScFh0rd5UnY2hSWMYdN5fJwel9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vpUHiwEGvQob+WsqxriaJ4ZcKz2ewszPETYiLD5wmlsn+3s2r4n1QlJtvzMPSmn0Q
	 MHb74Bip9nyT1AyMgBwDbpnykLGKIYLRk8VEp/JvRdyE1H0lL3sVpOEd8CfssGH4ZM
	 4UGiwK+4sge7smLHliDE/zVo+IfXlTHwaNFPmnXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matttbe@kernel.org>,
	Geliang Tang <geliang.tang@suse.com>,
	Mat Martineau <martineau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.7 334/334] selftests: mptcp: add mptcp_lib_get_counter
Date: Tue, 27 Feb 2024 14:23:12 +0100
Message-ID: <20240227131641.938182946@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

commit 61c131f5d4d2b79904af2fdcb2839a9db8e7c55c upstream.

To avoid duplicated code in different MPTCP selftests, we can add
and use helpers defined in mptcp_lib.sh.

The helper get_counter() in mptcp_join.sh and get_mib_counter() in
mptcp_connect.sh have the same functionality, export get_counter() into
mptcp_lib.sh and rename it as mptcp_lib_get_counter(). Use this new
helper instead of get_counter() and get_mib_counter().

Use this helper in test_prio() in userspace_pm.sh too instead of
open-coding.

Reviewed-by: Matthieu Baerts <matttbe@kernel.org>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <martineau@kernel.org>
Link: https://lore.kernel.org/r/20231128-send-net-next-2023107-v4-11-8d6b94150f6b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |   41 +++------
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |   88 ++++++++-------------
 tools/testing/selftests/net/mptcp/mptcp_lib.sh     |   16 +++
 tools/testing/selftests/net/mptcp/userspace_pm.sh  |   14 +--
 4 files changed, 73 insertions(+), 86 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -341,21 +341,6 @@ do_ping()
 	return 0
 }
 
-# $1: ns, $2: MIB counter
-get_mib_counter()
-{
-	local listener_ns="${1}"
-	local mib="${2}"
-
-	# strip the header
-	ip netns exec "${listener_ns}" \
-		nstat -z -a "${mib}" | \
-			tail -n+2 | \
-			while read a count c rest; do
-				echo $count
-			done
-}
-
 # $1: ns, $2: port
 wait_local_port_listen()
 {
@@ -441,12 +426,12 @@ do_transfer()
 			nstat -n
 	fi
 
-	local stat_synrx_last_l=$(get_mib_counter "${listener_ns}" "MPTcpExtMPCapableSYNRX")
-	local stat_ackrx_last_l=$(get_mib_counter "${listener_ns}" "MPTcpExtMPCapableACKRX")
-	local stat_cookietx_last=$(get_mib_counter "${listener_ns}" "TcpExtSyncookiesSent")
-	local stat_cookierx_last=$(get_mib_counter "${listener_ns}" "TcpExtSyncookiesRecv")
-	local stat_csum_err_s=$(get_mib_counter "${listener_ns}" "MPTcpExtDataCsumErr")
-	local stat_csum_err_c=$(get_mib_counter "${connector_ns}" "MPTcpExtDataCsumErr")
+	local stat_synrx_last_l=$(mptcp_lib_get_counter "${listener_ns}" "MPTcpExtMPCapableSYNRX")
+	local stat_ackrx_last_l=$(mptcp_lib_get_counter "${listener_ns}" "MPTcpExtMPCapableACKRX")
+	local stat_cookietx_last=$(mptcp_lib_get_counter "${listener_ns}" "TcpExtSyncookiesSent")
+	local stat_cookierx_last=$(mptcp_lib_get_counter "${listener_ns}" "TcpExtSyncookiesRecv")
+	local stat_csum_err_s=$(mptcp_lib_get_counter "${listener_ns}" "MPTcpExtDataCsumErr")
+	local stat_csum_err_c=$(mptcp_lib_get_counter "${connector_ns}" "MPTcpExtDataCsumErr")
 
 	timeout ${timeout_test} \
 		ip netns exec ${listener_ns} \
@@ -509,11 +494,11 @@ do_transfer()
 	check_transfer $cin $sout "file received by server"
 	rets=$?
 
-	local stat_synrx_now_l=$(get_mib_counter "${listener_ns}" "MPTcpExtMPCapableSYNRX")
-	local stat_ackrx_now_l=$(get_mib_counter "${listener_ns}" "MPTcpExtMPCapableACKRX")
-	local stat_cookietx_now=$(get_mib_counter "${listener_ns}" "TcpExtSyncookiesSent")
-	local stat_cookierx_now=$(get_mib_counter "${listener_ns}" "TcpExtSyncookiesRecv")
-	local stat_ooo_now=$(get_mib_counter "${listener_ns}" "TcpExtTCPOFOQueue")
+	local stat_synrx_now_l=$(mptcp_lib_get_counter "${listener_ns}" "MPTcpExtMPCapableSYNRX")
+	local stat_ackrx_now_l=$(mptcp_lib_get_counter "${listener_ns}" "MPTcpExtMPCapableACKRX")
+	local stat_cookietx_now=$(mptcp_lib_get_counter "${listener_ns}" "TcpExtSyncookiesSent")
+	local stat_cookierx_now=$(mptcp_lib_get_counter "${listener_ns}" "TcpExtSyncookiesRecv")
+	local stat_ooo_now=$(mptcp_lib_get_counter "${listener_ns}" "TcpExtTCPOFOQueue")
 
 	expect_synrx=$((stat_synrx_last_l))
 	expect_ackrx=$((stat_ackrx_last_l))
@@ -542,8 +527,8 @@ do_transfer()
 	fi
 
 	if $checksum; then
-		local csum_err_s=$(get_mib_counter "${listener_ns}" "MPTcpExtDataCsumErr")
-		local csum_err_c=$(get_mib_counter "${connector_ns}" "MPTcpExtDataCsumErr")
+		local csum_err_s=$(mptcp_lib_get_counter "${listener_ns}" "MPTcpExtDataCsumErr")
+		local csum_err_c=$(mptcp_lib_get_counter "${connector_ns}" "MPTcpExtDataCsumErr")
 
 		local csum_err_s_nr=$((csum_err_s - stat_csum_err_s))
 		if [ $csum_err_s_nr -gt 0 ]; then
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -611,25 +611,9 @@ wait_local_port_listen()
 	done
 }
 
-# $1: ns ; $2: counter
-get_counter()
-{
-	local ns="${1}"
-	local counter="${2}"
-	local count
-
-	count=$(ip netns exec ${ns} nstat -asz "${counter}" | awk 'NR==1 {next} {print $2}')
-	if [ -z "${count}" ]; then
-		mptcp_lib_fail_if_expected_feature "${counter} counter"
-		return 1
-	fi
-
-	echo "${count}"
-}
-
 rm_addr_count()
 {
-	get_counter "${1}" "MPTcpExtRmAddr"
+	mptcp_lib_get_counter "${1}" "MPTcpExtRmAddr"
 }
 
 # $1: ns, $2: old rm_addr counter in $ns
@@ -649,7 +633,7 @@ wait_rm_addr()
 
 rm_sf_count()
 {
-	get_counter "${1}" "MPTcpExtRmSubflow"
+	mptcp_lib_get_counter "${1}" "MPTcpExtRmSubflow"
 }
 
 # $1: ns, $2: old rm_sf counter in $ns
@@ -672,11 +656,11 @@ wait_mpj()
 	local ns="${1}"
 	local cnt old_cnt
 
-	old_cnt=$(get_counter ${ns} "MPTcpExtMPJoinAckRx")
+	old_cnt=$(mptcp_lib_get_counter ${ns} "MPTcpExtMPJoinAckRx")
 
 	local i
 	for i in $(seq 10); do
-		cnt=$(get_counter ${ns} "MPTcpExtMPJoinAckRx")
+		cnt=$(mptcp_lib_get_counter ${ns} "MPTcpExtMPJoinAckRx")
 		[ "$cnt" = "${old_cnt}" ] || break
 		sleep 0.1
 	done
@@ -1271,7 +1255,7 @@ chk_csum_nr()
 	fi
 
 	print_check "sum"
-	count=$(get_counter ${ns1} "MPTcpExtDataCsumErr")
+	count=$(mptcp_lib_get_counter ${ns1} "MPTcpExtDataCsumErr")
 	if [ "$count" != "$csum_ns1" ]; then
 		extra_msg="$extra_msg ns1=$count"
 	fi
@@ -1284,7 +1268,7 @@ chk_csum_nr()
 		print_ok
 	fi
 	print_check "csum"
-	count=$(get_counter ${ns2} "MPTcpExtDataCsumErr")
+	count=$(mptcp_lib_get_counter ${ns2} "MPTcpExtDataCsumErr")
 	if [ "$count" != "$csum_ns2" ]; then
 		extra_msg="$extra_msg ns2=$count"
 	fi
@@ -1328,7 +1312,7 @@ chk_fail_nr()
 	fi
 
 	print_check "ftx"
-	count=$(get_counter ${ns_tx} "MPTcpExtMPFailTx")
+	count=$(mptcp_lib_get_counter ${ns_tx} "MPTcpExtMPFailTx")
 	if [ "$count" != "$fail_tx" ]; then
 		extra_msg="$extra_msg,tx=$count"
 	fi
@@ -1342,7 +1326,7 @@ chk_fail_nr()
 	fi
 
 	print_check "failrx"
-	count=$(get_counter ${ns_rx} "MPTcpExtMPFailRx")
+	count=$(mptcp_lib_get_counter ${ns_rx} "MPTcpExtMPFailRx")
 	if [ "$count" != "$fail_rx" ]; then
 		extra_msg="$extra_msg,rx=$count"
 	fi
@@ -1375,7 +1359,7 @@ chk_fclose_nr()
 	fi
 
 	print_check "ctx"
-	count=$(get_counter ${ns_tx} "MPTcpExtMPFastcloseTx")
+	count=$(mptcp_lib_get_counter ${ns_tx} "MPTcpExtMPFastcloseTx")
 	if [ -z "$count" ]; then
 		print_skip
 	elif [ "$count" != "$fclose_tx" ]; then
@@ -1386,7 +1370,7 @@ chk_fclose_nr()
 	fi
 
 	print_check "fclzrx"
-	count=$(get_counter ${ns_rx} "MPTcpExtMPFastcloseRx")
+	count=$(mptcp_lib_get_counter ${ns_rx} "MPTcpExtMPFastcloseRx")
 	if [ -z "$count" ]; then
 		print_skip
 	elif [ "$count" != "$fclose_rx" ]; then
@@ -1416,7 +1400,7 @@ chk_rst_nr()
 	fi
 
 	print_check "rtx"
-	count=$(get_counter ${ns_tx} "MPTcpExtMPRstTx")
+	count=$(mptcp_lib_get_counter ${ns_tx} "MPTcpExtMPRstTx")
 	if [ -z "$count" ]; then
 		print_skip
 	# accept more rst than expected except if we don't expect any
@@ -1428,7 +1412,7 @@ chk_rst_nr()
 	fi
 
 	print_check "rstrx"
-	count=$(get_counter ${ns_rx} "MPTcpExtMPRstRx")
+	count=$(mptcp_lib_get_counter ${ns_rx} "MPTcpExtMPRstRx")
 	if [ -z "$count" ]; then
 		print_skip
 	# accept more rst than expected except if we don't expect any
@@ -1449,7 +1433,7 @@ chk_infi_nr()
 	local count
 
 	print_check "itx"
-	count=$(get_counter ${ns2} "MPTcpExtInfiniteMapTx")
+	count=$(mptcp_lib_get_counter ${ns2} "MPTcpExtInfiniteMapTx")
 	if [ -z "$count" ]; then
 		print_skip
 	elif [ "$count" != "$infi_tx" ]; then
@@ -1459,7 +1443,7 @@ chk_infi_nr()
 	fi
 
 	print_check "infirx"
-	count=$(get_counter ${ns1} "MPTcpExtInfiniteMapRx")
+	count=$(mptcp_lib_get_counter ${ns1} "MPTcpExtInfiniteMapRx")
 	if [ -z "$count" ]; then
 		print_skip
 	elif [ "$count" != "$infi_rx" ]; then
@@ -1488,7 +1472,7 @@ chk_join_nr()
 	fi
 
 	print_check "syn"
-	count=$(get_counter ${ns1} "MPTcpExtMPJoinSynRx")
+	count=$(mptcp_lib_get_counter ${ns1} "MPTcpExtMPJoinSynRx")
 	if [ -z "$count" ]; then
 		print_skip
 	elif [ "$count" != "$syn_nr" ]; then
@@ -1499,7 +1483,7 @@ chk_join_nr()
 
 	print_check "synack"
 	with_cookie=$(ip netns exec $ns2 sysctl -n net.ipv4.tcp_syncookies)
-	count=$(get_counter ${ns2} "MPTcpExtMPJoinSynAckRx")
+	count=$(mptcp_lib_get_counter ${ns2} "MPTcpExtMPJoinSynAckRx")
 	if [ -z "$count" ]; then
 		print_skip
 	elif [ "$count" != "$syn_ack_nr" ]; then
@@ -1516,7 +1500,7 @@ chk_join_nr()
 	fi
 
 	print_check "ack"
-	count=$(get_counter ${ns1} "MPTcpExtMPJoinAckRx")
+	count=$(mptcp_lib_get_counter ${ns1} "MPTcpExtMPJoinAckRx")
 	if [ -z "$count" ]; then
 		print_skip
 	elif [ "$count" != "$ack_nr" ]; then
@@ -1549,8 +1533,8 @@ chk_stale_nr()
 
 	print_check "stale"
 
-	stale_nr=$(get_counter ${ns} "MPTcpExtSubflowStale")
-	recover_nr=$(get_counter ${ns} "MPTcpExtSubflowRecover")
+	stale_nr=$(mptcp_lib_get_counter ${ns} "MPTcpExtSubflowStale")
+	recover_nr=$(mptcp_lib_get_counter ${ns} "MPTcpExtSubflowRecover")
 	if [ -z "$stale_nr" ] || [ -z "$recover_nr" ]; then
 		print_skip
 	elif [ $stale_nr -lt $stale_min ] ||
@@ -1587,7 +1571,7 @@ chk_add_nr()
 	timeout=$(ip netns exec $ns1 sysctl -n net.mptcp.add_addr_timeout)
 
 	print_check "add"
-	count=$(get_counter ${ns2} "MPTcpExtAddAddr")
+	count=$(mptcp_lib_get_counter ${ns2} "MPTcpExtAddAddr")
 	if [ -z "$count" ]; then
 		print_skip
 	# if the test configured a short timeout tolerate greater then expected
@@ -1599,7 +1583,7 @@ chk_add_nr()
 	fi
 
 	print_check "echo"
-	count=$(get_counter ${ns1} "MPTcpExtEchoAdd")
+	count=$(mptcp_lib_get_counter ${ns1} "MPTcpExtEchoAdd")
 	if [ -z "$count" ]; then
 		print_skip
 	elif [ "$count" != "$echo_nr" ]; then
@@ -1610,7 +1594,7 @@ chk_add_nr()
 
 	if [ $port_nr -gt 0 ]; then
 		print_check "pt"
-		count=$(get_counter ${ns2} "MPTcpExtPortAdd")
+		count=$(mptcp_lib_get_counter ${ns2} "MPTcpExtPortAdd")
 		if [ -z "$count" ]; then
 			print_skip
 		elif [ "$count" != "$port_nr" ]; then
@@ -1620,7 +1604,7 @@ chk_add_nr()
 		fi
 
 		print_check "syn"
-		count=$(get_counter ${ns1} "MPTcpExtMPJoinPortSynRx")
+		count=$(mptcp_lib_get_counter ${ns1} "MPTcpExtMPJoinPortSynRx")
 		if [ -z "$count" ]; then
 			print_skip
 		elif [ "$count" != "$syn_nr" ]; then
@@ -1631,7 +1615,7 @@ chk_add_nr()
 		fi
 
 		print_check "synack"
-		count=$(get_counter ${ns2} "MPTcpExtMPJoinPortSynAckRx")
+		count=$(mptcp_lib_get_counter ${ns2} "MPTcpExtMPJoinPortSynAckRx")
 		if [ -z "$count" ]; then
 			print_skip
 		elif [ "$count" != "$syn_ack_nr" ]; then
@@ -1642,7 +1626,7 @@ chk_add_nr()
 		fi
 
 		print_check "ack"
-		count=$(get_counter ${ns1} "MPTcpExtMPJoinPortAckRx")
+		count=$(mptcp_lib_get_counter ${ns1} "MPTcpExtMPJoinPortAckRx")
 		if [ -z "$count" ]; then
 			print_skip
 		elif [ "$count" != "$ack_nr" ]; then
@@ -1653,7 +1637,7 @@ chk_add_nr()
 		fi
 
 		print_check "syn"
-		count=$(get_counter ${ns1} "MPTcpExtMismatchPortSynRx")
+		count=$(mptcp_lib_get_counter ${ns1} "MPTcpExtMismatchPortSynRx")
 		if [ -z "$count" ]; then
 			print_skip
 		elif [ "$count" != "$mis_syn_nr" ]; then
@@ -1664,7 +1648,7 @@ chk_add_nr()
 		fi
 
 		print_check "ack"
-		count=$(get_counter ${ns1} "MPTcpExtMismatchPortAckRx")
+		count=$(mptcp_lib_get_counter ${ns1} "MPTcpExtMismatchPortAckRx")
 		if [ -z "$count" ]; then
 			print_skip
 		elif [ "$count" != "$mis_ack_nr" ]; then
@@ -1686,7 +1670,7 @@ chk_add_tx_nr()
 	timeout=$(ip netns exec $ns1 sysctl -n net.mptcp.add_addr_timeout)
 
 	print_check "add TX"
-	count=$(get_counter ${ns1} "MPTcpExtAddAddrTx")
+	count=$(mptcp_lib_get_counter ${ns1} "MPTcpExtAddAddrTx")
 	if [ -z "$count" ]; then
 		print_skip
 	# if the test configured a short timeout tolerate greater then expected
@@ -1698,7 +1682,7 @@ chk_add_tx_nr()
 	fi
 
 	print_check "echo TX"
-	count=$(get_counter ${ns2} "MPTcpExtEchoAddTx")
+	count=$(mptcp_lib_get_counter ${ns2} "MPTcpExtEchoAddTx")
 	if [ -z "$count" ]; then
 		print_skip
 	elif [ "$count" != "$echo_tx_nr" ]; then
@@ -1736,7 +1720,7 @@ chk_rm_nr()
 	fi
 
 	print_check "rm"
-	count=$(get_counter ${addr_ns} "MPTcpExtRmAddr")
+	count=$(mptcp_lib_get_counter ${addr_ns} "MPTcpExtRmAddr")
 	if [ -z "$count" ]; then
 		print_skip
 	elif [ "$count" != "$rm_addr_nr" ]; then
@@ -1746,13 +1730,13 @@ chk_rm_nr()
 	fi
 
 	print_check "rmsf"
-	count=$(get_counter ${subflow_ns} "MPTcpExtRmSubflow")
+	count=$(mptcp_lib_get_counter ${subflow_ns} "MPTcpExtRmSubflow")
 	if [ -z "$count" ]; then
 		print_skip
 	elif [ -n "$simult" ]; then
 		local cnt suffix
 
-		cnt=$(get_counter ${addr_ns} "MPTcpExtRmSubflow")
+		cnt=$(mptcp_lib_get_counter ${addr_ns} "MPTcpExtRmSubflow")
 
 		# in case of simult flush, the subflow removal count on each side is
 		# unreliable
@@ -1781,7 +1765,7 @@ chk_rm_tx_nr()
 	local rm_addr_tx_nr=$1
 
 	print_check "rm TX"
-	count=$(get_counter ${ns2} "MPTcpExtRmAddrTx")
+	count=$(mptcp_lib_get_counter ${ns2} "MPTcpExtRmAddrTx")
 	if [ -z "$count" ]; then
 		print_skip
 	elif [ "$count" != "$rm_addr_tx_nr" ]; then
@@ -1798,7 +1782,7 @@ chk_prio_nr()
 	local count
 
 	print_check "ptx"
-	count=$(get_counter ${ns1} "MPTcpExtMPPrioTx")
+	count=$(mptcp_lib_get_counter ${ns1} "MPTcpExtMPPrioTx")
 	if [ -z "$count" ]; then
 		print_skip
 	elif [ "$count" != "$mp_prio_nr_tx" ]; then
@@ -1808,7 +1792,7 @@ chk_prio_nr()
 	fi
 
 	print_check "prx"
-	count=$(get_counter ${ns1} "MPTcpExtMPPrioRx")
+	count=$(mptcp_lib_get_counter ${ns1} "MPTcpExtMPPrioRx")
 	if [ -z "$count" ]; then
 		print_skip
 	elif [ "$count" != "$mp_prio_nr_rx" ]; then
@@ -1908,7 +1892,7 @@ wait_attempt_fail()
 	while [ $time -lt $timeout_ms ]; do
 		local cnt
 
-		cnt=$(get_counter ${ns} "TcpAttemptFails")
+		cnt=$(mptcp_lib_get_counter ${ns} "TcpAttemptFails")
 
 		[ "$cnt" = 1 ] && return 1
 		time=$((time + 100))
--- a/tools/testing/selftests/net/mptcp/mptcp_lib.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_lib.sh
@@ -216,3 +216,19 @@ mptcp_lib_kill_wait() {
 	kill "${1}" > /dev/null 2>&1
 	wait "${1}" 2>/dev/null
 }
+
+# $1: ns, $2: MIB counter
+mptcp_lib_get_counter() {
+	local ns="${1}"
+	local counter="${2}"
+	local count
+
+	count=$(ip netns exec "${ns}" nstat -asz "${counter}" |
+		awk 'NR==1 {next} {print $2}')
+	if [ -z "${count}" ]; then
+		mptcp_lib_fail_if_expected_feature "${counter} counter"
+		return 1
+	fi
+
+	echo "${count}"
+}
--- a/tools/testing/selftests/net/mptcp/userspace_pm.sh
+++ b/tools/testing/selftests/net/mptcp/userspace_pm.sh
@@ -887,9 +887,10 @@ test_prio()
 
 	# Check TX
 	print_test "MP_PRIO TX"
-	count=$(ip netns exec "$ns2" nstat -as | grep MPTcpExtMPPrioTx | awk '{print $2}')
-	[ -z "$count" ] && count=0
-	if [ $count != 1 ]; then
+	count=$(mptcp_lib_get_counter "$ns2" "MPTcpExtMPPrioTx")
+	if [ -z "$count" ]; then
+		test_skip
+	elif [ $count != 1 ]; then
 		test_fail "Count != 1: ${count}"
 	else
 		test_pass
@@ -897,9 +898,10 @@ test_prio()
 
 	# Check RX
 	print_test "MP_PRIO RX"
-	count=$(ip netns exec "$ns1" nstat -as | grep MPTcpExtMPPrioRx | awk '{print $2}')
-	[ -z "$count" ] && count=0
-	if [ $count != 1 ]; then
+	count=$(mptcp_lib_get_counter "$ns1" "MPTcpExtMPPrioRx")
+	if [ -z "$count" ]; then
+		test_skip
+	elif [ $count != 1 ]; then
 		test_fail "Count != 1: ${count}"
 	else
 		test_pass


