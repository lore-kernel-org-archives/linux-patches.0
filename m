Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D71876C9C;
	Tue, 20 Feb 2024 21:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463656; cv=none; b=POF7RIs48r42lQHfNrXi5YnqRAMfh+ioGOZzAM5F1ikpm1GFOa1zGHhIxIijVpDpFOcnMNk7X8qkhyI8zsJ9ZrUlJyAPCcS9a/ICkwjDSy71DeNxLgtZLAvBHQWd7mAFXkYN9Donb+vGEgtXN3z5nICQkzBkZQooEBXuc/bFYMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463656; c=relaxed/simple;
	bh=Fd1o14m0wjaJWbr963gy+LaygJYxP8U+Lhv0eakhqoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ot0QHyn50SNpeJQRaoDwiybAES8nTp0I7ddspaSo3k0KM9GDejE3LIPl0Ae1KUrp57qUFGcnv6eYWTSUC9Nq+V5Mxn06tRFja76JgAXOeLbabvNOjGyvN7tMtSLpDTbDIoUX/YOplnW3aN3o/xp5dCYzrabOHFyaT15nIjryZ6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yuygyKP2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yuygyKP2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD772C433F1;
	Tue, 20 Feb 2024 21:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463656;
	bh=Fd1o14m0wjaJWbr963gy+LaygJYxP8U+Lhv0eakhqoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yuygyKP2RgzvDFlRzYcELv7Wnjbc8YbeBeSlDP02stjtBkvq+fYGm3j3cOm4aZjrK
	 Uj0rJxS+/aj0c6tPpjSRgsVnbFTOOu76EFe8UzGMr86yc73Zx2V2OEKpaMxoMNLyXq
	 A3GsAmkUnZey2y2JjaUEZ12mhm5Ct6y9vK9wrxrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matttbe@kernel.org>,
	Geliang Tang <geliang.tang@suse.com>,
	Mat Martineau <martineau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 111/331] selftests: mptcp: add mptcp_lib_kill_wait
Date: Tue, 20 Feb 2024 21:53:47 +0100
Message-ID: <20240220205641.103272861@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

From: Geliang Tang <geliang.tang@suse.com>

commit bdbef0a6ff10603895b0ba39f56bf874cb2b551a upstream.

To avoid duplicated code in different MPTCP selftests, we can add
and use helpers defined in mptcp_lib.sh.

Export kill_wait() helper in userspace_pm.sh into mptcp_lib.sh and
rename it as mptcp_lib_kill_wait(). It can be used to instead of
kill_wait() in mptcp_join.sh. Use the new helper in both scripts.

Reviewed-by: Matthieu Baerts <matttbe@kernel.org>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <martineau@kernel.org>
Link: https://lore.kernel.org/r/20231128-send-net-next-2023107-v4-9-8d6b94150f6b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh   |   10 +------
 tools/testing/selftests/net/mptcp/mptcp_lib.sh    |    9 ++++++
 tools/testing/selftests/net/mptcp/userspace_pm.sh |   31 +++++++---------------
 3 files changed, 22 insertions(+), 28 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -682,16 +682,10 @@ wait_mpj()
 	done
 }
 
-kill_wait()
-{
-	kill $1 > /dev/null 2>&1
-	wait $1 2>/dev/null
-}
-
 kill_events_pids()
 {
-	kill_wait $evts_ns1_pid
-	kill_wait $evts_ns2_pid
+	mptcp_lib_kill_wait $evts_ns1_pid
+	mptcp_lib_kill_wait $evts_ns2_pid
 }
 
 kill_tests_wait()
--- a/tools/testing/selftests/net/mptcp/mptcp_lib.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_lib.sh
@@ -207,3 +207,12 @@ mptcp_lib_result_print_all_tap() {
 		printf "%s\n" "${subtest}"
 	done
 }
+
+# $1: PID
+mptcp_lib_kill_wait() {
+	[ "${1}" -eq 0 ] && return 0
+
+	kill -SIGUSR1 "${1}" > /dev/null 2>&1
+	kill "${1}" > /dev/null 2>&1
+	wait "${1}" 2>/dev/null
+}
--- a/tools/testing/selftests/net/mptcp/userspace_pm.sh
+++ b/tools/testing/selftests/net/mptcp/userspace_pm.sh
@@ -108,15 +108,6 @@ test_fail()
 	mptcp_lib_result_fail "${test_name}"
 }
 
-kill_wait()
-{
-	[ $1 -eq 0 ] && return 0
-
-	kill -SIGUSR1 $1 > /dev/null 2>&1
-	kill $1 > /dev/null 2>&1
-	wait $1 2>/dev/null
-}
-
 # This function is used in the cleanup trap
 #shellcheck disable=SC2317
 cleanup()
@@ -128,7 +119,7 @@ cleanup()
 	for pid in $client4_pid $server4_pid $client6_pid $server6_pid\
 		   $server_evts_pid $client_evts_pid
 	do
-		kill_wait $pid
+		mptcp_lib_kill_wait $pid
 	done
 
 	local netns
@@ -210,7 +201,7 @@ make_connection()
 	fi
 	:>"$client_evts"
 	if [ $client_evts_pid -ne 0 ]; then
-		kill_wait $client_evts_pid
+		mptcp_lib_kill_wait $client_evts_pid
 	fi
 	ip netns exec "$ns2" ./pm_nl_ctl events >> "$client_evts" 2>&1 &
 	client_evts_pid=$!
@@ -219,7 +210,7 @@ make_connection()
 	fi
 	:>"$server_evts"
 	if [ $server_evts_pid -ne 0 ]; then
-		kill_wait $server_evts_pid
+		mptcp_lib_kill_wait $server_evts_pid
 	fi
 	ip netns exec "$ns1" ./pm_nl_ctl events >> "$server_evts" 2>&1 &
 	server_evts_pid=$!
@@ -627,7 +618,7 @@ test_subflows()
 			      "10.0.2.2" "$client4_port" "23" "$client_addr_id" "ns1" "ns2"
 
 	# Delete the listener from the client ns, if one was created
-	kill_wait $listener_pid
+	mptcp_lib_kill_wait $listener_pid
 
 	local sport
 	sport=$(sed --unbuffered -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q' "$server_evts")
@@ -666,7 +657,7 @@ test_subflows()
 			      "$client_addr_id" "ns1" "ns2"
 
 	# Delete the listener from the client ns, if one was created
-	kill_wait $listener_pid
+	mptcp_lib_kill_wait $listener_pid
 
 	sport=$(sed --unbuffered -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q' "$server_evts")
 
@@ -705,7 +696,7 @@ test_subflows()
 			      "$client_addr_id" "ns1" "ns2"
 
 	# Delete the listener from the client ns, if one was created
-	kill_wait $listener_pid
+	mptcp_lib_kill_wait $listener_pid
 
 	sport=$(sed --unbuffered -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q' "$server_evts")
 
@@ -743,7 +734,7 @@ test_subflows()
 			      "10.0.2.1" "$app4_port" "23" "$server_addr_id" "ns2" "ns1"
 
 	# Delete the listener from the server ns, if one was created
-	kill_wait $listener_pid
+	mptcp_lib_kill_wait $listener_pid
 
 	sport=$(sed --unbuffered -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q' "$client_evts")
 
@@ -782,7 +773,7 @@ test_subflows()
 			      "$server_addr_id" "ns2" "ns1"
 
 	# Delete the listener from the server ns, if one was created
-	kill_wait $listener_pid
+	mptcp_lib_kill_wait $listener_pid
 
 	sport=$(sed --unbuffered -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q' "$client_evts")
 
@@ -819,7 +810,7 @@ test_subflows()
 			      "10.0.2.2" "10.0.2.1" "$new4_port" "23" "$server_addr_id" "ns2" "ns1"
 
 	# Delete the listener from the server ns, if one was created
-	kill_wait $listener_pid
+	mptcp_lib_kill_wait $listener_pid
 
 	sport=$(sed --unbuffered -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q' "$client_evts")
 
@@ -865,7 +856,7 @@ test_subflows_v4_v6_mix()
 			      "$server_addr_id" "ns2" "ns1"
 
 	# Delete the listener from the server ns, if one was created
-	kill_wait $listener_pid
+	mptcp_lib_kill_wait $listener_pid
 
 	sport=$(sed --unbuffered -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q' "$client_evts")
 
@@ -982,7 +973,7 @@ test_listener()
 	sleep 0.5
 
 	# Delete the listener from the client ns, if one was created
-	kill_wait $listener_pid
+	mptcp_lib_kill_wait $listener_pid
 
 	sleep 0.5
 	verify_listener_events $client_evts $LISTENER_CLOSED $AF_INET 10.0.2.2 $client4_port


