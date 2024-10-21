Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F59A1E0087;
	Mon, 21 Oct 2024 10:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507228; cv=none; b=jMfeIbdQYoPDywH7pFMDllSZDAjYDs9PagbKrU5UJHkFPIOcgeG2hqERVRIbJwxT++r+3Lr29SRq7n0PpEGLSKZn4wPUvGD2AzEPxjUGqRuV2PBU513DO3IBTkapA+vkccm8ScPgHuhCZSDeIrGP3sf8m7kKSXUl1GXZMKVqgAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507228; c=relaxed/simple;
	bh=CO8tP+4lBmS5EX82cqFf/oWgsumsqlacNaErqwM/BF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MmHyy3CXcpbweCPYfKBdte/xEO0G3K17E6GdYs9534Zj0PowyywfU+yYRw9rOtCwDVyAGhQ1x6Wu4erGlciaw5EvLq6qhWzb+eY1eDog7kpMGxz3GShuTSbOeAOq2eroAcfX9qeKAk2yOS0OmOlziRSMR7AsS+Lw61G0Y8g08Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lfLY7p5o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lfLY7p5o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7ED9C4CEC3;
	Mon, 21 Oct 2024 10:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507228;
	bh=CO8tP+4lBmS5EX82cqFf/oWgsumsqlacNaErqwM/BF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lfLY7p5o1LZni6YRduSiwDxcqh9O/CWSV7dOm6qN4y+8ScOKuiBxSN6u96H4fUNTz
	 UnQUOg2VD4ViICzcBugoPbZvzJ8TRGoGaoV6scEg2ND7MUPbRN3KHkrMHazovmzKRi
	 pJrNx010y+Gfed2c3Qv0eWTyx2hChNIoMzA/h/mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 121/124] selftests: mptcp: join: test for prohibited MPC to port-based endp
Date: Mon, 21 Oct 2024 12:25:25 +0200
Message-ID: <20241021102301.403674076@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit 5afca7e996c42aed1b4a42d4712817601ba42aff upstream.

Explicitly verify that MPC connection attempts towards a port-based
signal endpoint fail with a reset.

Note that this new test is a bit different from the other ones, not
using 'run_tests'. It is then needed to add the capture capability, and
the picking the right port which have been extracted into three new
helpers. The info about the capture can also be printed from a single
point, which simplifies the exit paths in do_transfer().

The 'Fixes' tag here below is the same as the one from the previous
commit: this patch here is not fixing anything wrong in the selftests,
but it validates the previous fix for an issue introduced by this commit
ID.

Fixes: 1729cf186d8a ("mptcp: create the listening socket for new port")
Cc: stable@vger.kernel.org
Co-developed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20241014-net-mptcp-mpc-port-endp-v2-2-7faea8e6b6ae@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Conflicts in mptcp_join.sh, because commit 0bd962dd86b2 ("selftests:
  mptcp: join: check CURRESTAB counters"), and commit 9e6a39ecb9a1
  ("selftests: mptcp: export TEST_COUNTER variable") are linked to new
  features, not available in this version. Resolving the conflicts is
  easy, simply adding the new helpers before do_transfer(), and rename
  MPTCP_LIB_TEST_COUNTER to TEST_COUNT that was used before. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |  115 +++++++++++++++++-------
 1 file changed, 85 insertions(+), 30 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -23,6 +23,7 @@ tmpfile=""
 cout=""
 err=""
 capout=""
+cappid=""
 ns1=""
 ns2=""
 ksft_skip=4
@@ -1006,40 +1007,62 @@ pm_nl_set_endpoint()
 	fi
 }
 
-do_transfer()
+cond_start_capture()
 {
-	local listener_ns="$1"
-	local connector_ns="$2"
-	local cl_proto="$3"
-	local srv_proto="$4"
-	local connect_addr="$5"
-
-	local port=$((10000 + TEST_COUNT - 1))
-	local cappid
-	local FAILING_LINKS=${FAILING_LINKS:-""}
-	local fastclose=${fastclose:-""}
-	local speed=${speed:-"fast"}
+	local ns="$1"
 
-	:> "$cout"
-	:> "$sout"
 	:> "$capout"
 
 	if $capture; then
-		local capuser
-		if [ -z $SUDO_USER ] ; then
+		local capuser capfile
+		if [ -z $SUDO_USER ]; then
 			capuser=""
 		else
 			capuser="-Z $SUDO_USER"
 		fi
 
-		capfile=$(printf "mp_join-%02u-%s.pcap" "$TEST_COUNT" "${listener_ns}")
+		capfile=$(printf "mp_join-%02u-%s.pcap" "$TEST_COUNT" "$ns")
 
 		echo "Capturing traffic for test $TEST_COUNT into $capfile"
-		ip netns exec ${listener_ns} tcpdump -i any -s 65535 -B 32768 $capuser -w $capfile > "$capout" 2>&1 &
+		ip netns exec "$ns" tcpdump -i any -s 65535 -B 32768 $capuser -w "$capfile" > "$capout" 2>&1 &
 		cappid=$!
 
 		sleep 1
 	fi
+}
+
+cond_stop_capture()
+{
+	if $capture; then
+		sleep 1
+		kill $cappid
+		cat "$capout"
+	fi
+}
+
+get_port()
+{
+	echo "$((10000 + TEST_COUNT - 1))"
+}
+
+do_transfer()
+{
+	local listener_ns="$1"
+	local connector_ns="$2"
+	local cl_proto="$3"
+	local srv_proto="$4"
+	local connect_addr="$5"
+	local port
+
+	local FAILING_LINKS=${FAILING_LINKS:-""}
+	local fastclose=${fastclose:-""}
+	local speed=${speed:-"fast"}
+	port=$(get_port)
+
+	:> "$cout"
+	:> "$sout"
+
+	cond_start_capture ${listener_ns}
 
 	NSTAT_HISTORY=/tmp/${listener_ns}.nstat ip netns exec ${listener_ns} \
 		nstat -n
@@ -1125,10 +1148,7 @@ do_transfer()
 	wait $spid
 	local rets=$?
 
-	if $capture; then
-	    sleep 1
-	    kill $cappid
-	fi
+	cond_stop_capture
 
 	NSTAT_HISTORY=/tmp/${listener_ns}.nstat ip netns exec ${listener_ns} \
 		nstat | grep Tcp > /tmp/${listener_ns}.out
@@ -1144,7 +1164,6 @@ do_transfer()
 		ip netns exec ${connector_ns} ss -Menita 1>&2 -o "dport = :$port"
 		cat /tmp/${connector_ns}.out
 
-		cat "$capout"
 		return 1
 	fi
 
@@ -1161,13 +1180,7 @@ do_transfer()
 	fi
 	rets=$?
 
-	if [ $retc -eq 0 ] && [ $rets -eq 0 ];then
-		cat "$capout"
-		return 0
-	fi
-
-	cat "$capout"
-	return 1
+	[ $retc -eq 0 ] && [ $rets -eq 0 ]
 }
 
 make_file()
@@ -2944,6 +2957,32 @@ verify_listener_events()
 	fail_test "$e_type:$type $e_family:$family $e_saddr:$saddr $e_sport:$sport"
 }
 
+chk_mpc_endp_attempt()
+{
+	local retl=$1
+	local attempts=$2
+
+	print_check "Connect"
+
+	if [ ${retl} = 124 ]; then
+		fail_test "timeout on connect"
+	elif [ ${retl} = 0 ]; then
+		fail_test "unexpected successful connect"
+	else
+		print_ok
+
+		print_check "Attempts"
+		count=$(mptcp_lib_get_counter ${ns1} "MPTcpExtMPCapableEndpAttempt")
+		if [ -z "$count" ]; then
+			print_skip
+		elif [ "$count" != "$attempts" ]; then
+			fail_test "got ${count} MPC attempt[s] on port-based endpoint, expected ${attempts}"
+		else
+			print_ok
+		fi
+	fi
+}
+
 add_addr_ports_tests()
 {
 	# signal address with port
@@ -3034,6 +3073,22 @@ add_addr_ports_tests()
 		chk_join_nr 2 2 2
 		chk_add_nr 2 2 2
 	fi
+
+	if reset "port-based signal endpoint must not accept mpc"; then
+		local port retl count
+		port=$(get_port)
+
+		cond_start_capture ${ns1}
+		pm_nl_add_endpoint ${ns1} 10.0.2.1 flags signal port ${port}
+		mptcp_lib_wait_local_port_listen ${ns1} ${port}
+
+		timeout 1 ip netns exec ${ns2} \
+			./mptcp_connect -t ${timeout_poll} -p $port -s MPTCP 10.0.2.1 >/dev/null 2>&1
+		retl=$?
+		cond_stop_capture
+
+		chk_mpc_endp_attempt ${retl} 1
+	fi
 }
 
 syncookies_tests()


