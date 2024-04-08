Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE066FE35;
	Mon,  8 Apr 2024 13:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583125; cv=none; b=FvcpQgqFf5MBGMirILs8NJRnolempk3U+gIdrH1usFZXoUB4oJWxPPKxGkhj6wgyf1ncytSwhsMuzBA4Q78Qec8ckJFLJ5+L8gisa4XpiO07x4GozeGymoXYMDPSMLlnwE11mQx6kSkjZ6aVBgcmwnrTrQxLuK37GIrqr+srEd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583125; c=relaxed/simple;
	bh=XT7eD3gZ0iCGfIBhSmcLRNsDqRAPzs1fJdy9Lp5vWU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E9ulQ7Zcbcs69tpn9B0tQ9pMOLJ+BUlR+9yFs+t/rbWFUMwE/ukn5cAa1OcWePNIztugT/eE5wLgcs4Lq/MpjpmV7+XOL+a5NpF+ZF0IpajGdMImhuKwmKFy18sonbnXQNxkpBtZ+2TxBBBz++37/6yKeZYjxk3CdLpS8Ys08Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WvWGIJPO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WvWGIJPO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18099C433F1;
	Mon,  8 Apr 2024 13:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583124;
	bh=XT7eD3gZ0iCGfIBhSmcLRNsDqRAPzs1fJdy9Lp5vWU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WvWGIJPOyTQVkcMIz7KCfuO7oTGAuLecMR2UWb3RGTrIwu/w5jvyXRUyoyO/uSPvY
	 t4uAJHnbrw9ssdWfmOhBMZknWrZ9TL3/gux2tQWEwuVroIoWUanKFVoBaWyjoJq17S
	 b+4AwrZRDeHeCG0wLo+zNdNn3yybMjiGEeAvNH9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 142/273] selftests: mptcp: use += operator to append strings
Date: Mon,  8 Apr 2024 14:56:57 +0200
Message-ID: <20240408125313.699861057@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit e7c42bf4d320affe37337aa83ae0347832b3f568 ]

This patch uses addition assignment operator (+=) to append strings
instead of duplicating the variable name in mptcp_connect.sh and
mptcp_join.sh.

This can make the statements shorter.

Note: in mptcp_connect.sh, add a local variable extra in do_transfer to
save the various extra warning logs, using += to append it. And add a
new variable tc_info to save various tc info, also using += to append it.
This can make the code more readable and prepare for the next commit.

Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240308-upstream-net-next-20240308-selftests-mptcp-unification-v1-8-4f42c347b653@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 7a1b3490f47e ("mptcp: don't account accept() of non-MPC client as fallback to TCP")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/net/mptcp/mptcp_connect.sh      | 53 ++++++++++---------
 .../testing/selftests/net/mptcp/mptcp_join.sh | 30 +++++------
 2 files changed, 43 insertions(+), 40 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index cce0e553976f2..f8e1b3daa7489 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -332,15 +332,15 @@ do_transfer()
 	TEST_COUNT=$((TEST_COUNT+1))
 
 	if [ "$rcvbuf" -gt 0 ]; then
-		extra_args="$extra_args -R $rcvbuf"
+		extra_args+=" -R $rcvbuf"
 	fi
 
 	if [ "$sndbuf" -gt 0 ]; then
-		extra_args="$extra_args -S $sndbuf"
+		extra_args+=" -S $sndbuf"
 	fi
 
 	if [ -n "$testmode" ]; then
-		extra_args="$extra_args -m $testmode"
+		extra_args+=" -m $testmode"
 	fi
 
 	if [ -n "$extra_args" ] && $options_log; then
@@ -459,6 +459,7 @@ do_transfer()
 	mptcp_lib_check_transfer $cin $sout "file received by server"
 	rets=$?
 
+	local extra=""
 	local stat_synrx_now_l
 	local stat_ackrx_now_l
 	local stat_cookietx_now
@@ -492,7 +493,7 @@ do_transfer()
 				"${stat_ackrx_now_l}" "${expect_ackrx}" 1>&2
 			rets=1
 		else
-			printf "[ Note ] fallback due to TCP OoO"
+			extra+=" [ Note ] fallback due to TCP OoO"
 		fi
 	fi
 
@@ -515,39 +516,41 @@ do_transfer()
 		fi
 	fi
 
-	if [ $retc -eq 0 ] && [ $rets -eq 0 ]; then
-		printf "[ OK ]"
-		mptcp_lib_result_pass "${TEST_GROUP}: ${result_msg}"
-	else
-		mptcp_lib_result_fail "${TEST_GROUP}: ${result_msg}"
-	fi
-
 	if [ $cookies -eq 2 ];then
 		if [ $stat_cookietx_last -ge $stat_cookietx_now ] ;then
-			printf " WARN: CookieSent: did not advance"
+			extra+=" WARN: CookieSent: did not advance"
 		fi
 		if [ $stat_cookierx_last -ge $stat_cookierx_now ] ;then
-			printf " WARN: CookieRecv: did not advance"
+			extra+=" WARN: CookieRecv: did not advance"
 		fi
 	else
 		if [ $stat_cookietx_last -ne $stat_cookietx_now ] ;then
-			printf " WARN: CookieSent: changed"
+			extra+=" WARN: CookieSent: changed"
 		fi
 		if [ $stat_cookierx_last -ne $stat_cookierx_now ] ;then
-			printf " WARN: CookieRecv: changed"
+			extra+=" WARN: CookieRecv: changed"
 		fi
 	fi
 
 	if [ ${stat_synrx_now_l} -gt ${expect_synrx} ]; then
-		printf " WARN: SYNRX: expect %d, got %d (probably retransmissions)" \
-			"${expect_synrx}" "${stat_synrx_now_l}"
+		extra+=" WARN: SYNRX: expect ${expect_synrx},"
+		extra+=" got ${stat_synrx_now_l} (probably retransmissions)"
 	fi
 	if [ ${stat_ackrx_now_l} -gt ${expect_ackrx} ]; then
-		printf " WARN: ACKRX: expect %d, got %d (probably retransmissions)" \
-			"${expect_ackrx}" "${stat_ackrx_now_l}"
+		extra+=" WARN: ACKRX: expect ${expect_ackrx},"
+		extra+=" got ${stat_ackrx_now_l} (probably retransmissions)"
+	fi
+
+	if [ $retc -eq 0 ] && [ $rets -eq 0 ]; then
+		printf "[ OK ]%s\n" "${extra:1}"
+		mptcp_lib_result_pass "${TEST_GROUP}: ${result_msg}"
+	else
+		if [ -n "${extra}" ]; then
+			printf "%s\n" "${extra:1}"
+		fi
+		mptcp_lib_result_fail "${TEST_GROUP}: ${result_msg}"
 	fi
 
-	echo
 	cat "$capout"
 	[ $retc -eq 0 ] && [ $rets -eq 0 ]
 }
@@ -872,8 +875,8 @@ mptcp_lib_result_code "${ret}" "ping tests"
 stop_if_error "Could not even run ping tests"
 
 [ -n "$tc_loss" ] && tc -net "$ns2" qdisc add dev ns2eth3 root netem loss random $tc_loss delay ${tc_delay}ms
-echo -n "INFO: Using loss of $tc_loss "
-test "$tc_delay" -gt 0 && echo -n "delay $tc_delay ms "
+tc_info="loss of $tc_loss "
+test "$tc_delay" -gt 0 && tc_info+="delay $tc_delay ms "
 
 reorder_delay=$((tc_delay / 4))
 
@@ -884,17 +887,17 @@ if [ -z "${tc_reorder}" ]; then
 
 	if [ $reorder_delay -gt 0 ] && [ $reorder1 -lt 100 ] && [ $reorder2 -gt 0 ]; then
 		tc_reorder="reorder ${reorder1}% ${reorder2}%"
-		echo -n "$tc_reorder with delay ${reorder_delay}ms "
+		tc_info+="$tc_reorder with delay ${reorder_delay}ms "
 	fi
 elif [ "$tc_reorder" = "0" ];then
 	tc_reorder=""
 elif [ "$reorder_delay" -gt 0 ];then
 	# reordering requires some delay
 	tc_reorder="reorder $tc_reorder"
-	echo -n "$tc_reorder with delay ${reorder_delay}ms "
+	tc_info+="$tc_reorder with delay ${reorder_delay}ms "
 fi
 
-echo "on ns3eth4"
+echo "INFO: Using ${tc_info}on ns3eth4"
 
 tc -net "$ns3" qdisc add dev ns3eth4 root netem delay ${reorder_delay}ms $tc_reorder
 
diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 81f493ce58759..24be952b4d4a1 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -799,18 +799,18 @@ pm_nl_check_endpoint()
 		line="${line% }"
 		# the dump order is: address id flags port dev
 		[ -n "$addr" ] && expected_line="$addr"
-		expected_line="$expected_line $id"
-		[ -n "$_flags" ] && expected_line="$expected_line ${_flags//","/" "}"
-		[ -n "$dev" ] && expected_line="$expected_line $dev"
-		[ -n "$port" ] && expected_line="$expected_line $port"
+		expected_line+=" $id"
+		[ -n "$_flags" ] && expected_line+=" ${_flags//","/" "}"
+		[ -n "$dev" ] && expected_line+=" $dev"
+		[ -n "$port" ] && expected_line+=" $port"
 	else
 		line=$(ip netns exec $ns ./pm_nl_ctl get $_id)
 		# the dump order is: id flags dev address port
 		expected_line="$id"
-		[ -n "$flags" ] && expected_line="$expected_line $flags"
-		[ -n "$dev" ] && expected_line="$expected_line $dev"
-		[ -n "$addr" ] && expected_line="$expected_line $addr"
-		[ -n "$_port" ] && expected_line="$expected_line $_port"
+		[ -n "$flags" ] && expected_line+=" $flags"
+		[ -n "$dev" ] && expected_line+=" $dev"
+		[ -n "$addr" ] && expected_line+=" $addr"
+		[ -n "$_port" ] && expected_line+=" $_port"
 	fi
 	if [ "$line" = "$expected_line" ]; then
 		print_ok
@@ -1261,7 +1261,7 @@ chk_csum_nr()
 	print_check "sum"
 	count=$(mptcp_lib_get_counter ${ns1} "MPTcpExtDataCsumErr")
 	if [ "$count" != "$csum_ns1" ]; then
-		extra_msg="$extra_msg ns1=$count"
+		extra_msg+=" ns1=$count"
 	fi
 	if [ -z "$count" ]; then
 		print_skip
@@ -1274,7 +1274,7 @@ chk_csum_nr()
 	print_check "csum"
 	count=$(mptcp_lib_get_counter ${ns2} "MPTcpExtDataCsumErr")
 	if [ "$count" != "$csum_ns2" ]; then
-		extra_msg="$extra_msg ns2=$count"
+		extra_msg+=" ns2=$count"
 	fi
 	if [ -z "$count" ]; then
 		print_skip
@@ -1318,7 +1318,7 @@ chk_fail_nr()
 	print_check "ftx"
 	count=$(mptcp_lib_get_counter ${ns_tx} "MPTcpExtMPFailTx")
 	if [ "$count" != "$fail_tx" ]; then
-		extra_msg="$extra_msg,tx=$count"
+		extra_msg+=",tx=$count"
 	fi
 	if [ -z "$count" ]; then
 		print_skip
@@ -1332,7 +1332,7 @@ chk_fail_nr()
 	print_check "failrx"
 	count=$(mptcp_lib_get_counter ${ns_rx} "MPTcpExtMPFailRx")
 	if [ "$count" != "$fail_rx" ]; then
-		extra_msg="$extra_msg,rx=$count"
+		extra_msg+=",rx=$count"
 	fi
 	if [ -z "$count" ]; then
 		print_skip
@@ -1367,7 +1367,7 @@ chk_fclose_nr()
 	if [ -z "$count" ]; then
 		print_skip
 	elif [ "$count" != "$fclose_tx" ]; then
-		extra_msg="$extra_msg,tx=$count"
+		extra_msg+=",tx=$count"
 		fail_test "got $count MP_FASTCLOSE[s] TX expected $fclose_tx"
 	else
 		print_ok
@@ -1378,7 +1378,7 @@ chk_fclose_nr()
 	if [ -z "$count" ]; then
 		print_skip
 	elif [ "$count" != "$fclose_rx" ]; then
-		extra_msg="$extra_msg,rx=$count"
+		extra_msg+=",rx=$count"
 		fail_test "got $count MP_FASTCLOSE[s] RX expected $fclose_rx"
 	else
 		print_ok
@@ -1747,7 +1747,7 @@ chk_rm_nr()
 		count=$((count + cnt))
 		if [ "$count" != "$rm_subflow_nr" ]; then
 			suffix="$count in [$rm_subflow_nr:$((rm_subflow_nr*2))]"
-			extra_msg="$extra_msg simult"
+			extra_msg+=" simult"
 		fi
 		if [ $count -ge "$rm_subflow_nr" ] && \
 		   [ "$count" -le "$((rm_subflow_nr *2 ))" ]; then
-- 
2.43.0



