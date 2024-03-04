Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C0111193;
	Mon,  4 Mar 2024 21:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588529; cv=none; b=OJYG4R+E0ZBz80h25ep0kb9ZzT0gNTT9qAcfpmIh0MGCw6H4/nn4lBgCYBCw5thAApEZKaQkjOQSAKoqKqZtQSsLqYxyE4kw+HEDFKf4B8kGLF9vDHD4psdOVzhNTH8/l2kFDUlquTCX6YhkvGjcqIGqMOdAhgybdISneDrBs98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588529; c=relaxed/simple;
	bh=Satxx0qUQfu+gPNycyiZNMo5W0Ce3cKwYI9o5m9J4YU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=db+n5dJ9XgIrPlITto/nJwByN3ZAhz+THoAB1yknYgm1Nm95UAnt6K7g5vM8DexyoWYE05x8YgbgG4dLC/CaRBDa9UHODCMLBP0yxD7mJ8r2XNn+uh8596RJwJQJ9NdbDfJl+bQ0K+9m0OqmI+bDpsGpCcuMCf7FwhbxblRbHlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cVMfENy0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cVMfENy0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA54C433C7;
	Mon,  4 Mar 2024 21:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588528;
	bh=Satxx0qUQfu+gPNycyiZNMo5W0Ce3cKwYI9o5m9J4YU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cVMfENy0pfrc+mVb4Nlocqm4kTuhT1rbOw95tlNag7hdIJ1k5EGQYZLoVwOPSK/u6
	 VZc5JxJZywkI1zYihMgvSu6DnFQGbQRkwYBok+g5vIlKi4wjVwL6I2P4XjCjli3ezk
	 IKHMQFpL/X+i5S50Uw3lYY9fyoZ9iVfHzGieODPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 142/143] selftests: mptcp: rm subflow with v4/v4mapped addr
Date: Mon,  4 Mar 2024 21:24:22 +0000
Message-ID: <20240304211554.439365961@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

From: Geliang Tang <tanggeliang@kylinos.cn>

commit 7092dbee23282b6fcf1313fc64e2b92649ee16e8 upstream.

Now both a v4 address and a v4-mapped address are supported when
destroying a userspace pm subflow, this patch adds a second subflow
to "userspace pm add & remove address" test, and two subflows could
be removed two different ways, one with the v4mapped and one with v4.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/387
Fixes: 48d73f609dcc ("selftests: mptcp: update userspace pm addr tests")
Cc: stable@vger.kernel.org
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240223-upstream-net-20240223-misc-fixes-v1-2-162e87e48497@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   28 +++++++++++++-----------
 tools/testing/selftests/net/mptcp/mptcp_lib.sh  |    4 +--
 2 files changed, 18 insertions(+), 14 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3325,16 +3325,17 @@ userspace_pm_rm_sf()
 {
 	local evts=$evts_ns1
 	local t=${3:-1}
-	local ip=4
+	local ip
 	local tk da dp sp
 	local cnt
 
 	[ "$1" == "$ns2" ] && evts=$evts_ns2
-	if mptcp_lib_is_v6 $2; then ip=6; fi
+	[ -n "$(mptcp_lib_evts_get_info "saddr4" "$evts" $t)" ] && ip=4
+	[ -n "$(mptcp_lib_evts_get_info "saddr6" "$evts" $t)" ] && ip=6
 	tk=$(mptcp_lib_evts_get_info token "$evts")
-	da=$(mptcp_lib_evts_get_info "daddr$ip" "$evts" $t)
-	dp=$(mptcp_lib_evts_get_info dport "$evts" $t)
-	sp=$(mptcp_lib_evts_get_info sport "$evts" $t)
+	da=$(mptcp_lib_evts_get_info "daddr$ip" "$evts" $t $2)
+	dp=$(mptcp_lib_evts_get_info dport "$evts" $t $2)
+	sp=$(mptcp_lib_evts_get_info sport "$evts" $t $2)
 
 	cnt=$(rm_sf_count ${1})
 	ip netns exec $1 ./pm_nl_ctl dsf lip $2 lport $sp \
@@ -3421,20 +3422,23 @@ userspace_tests()
 	if reset_with_events "userspace pm add & remove address" &&
 	   continue_if mptcp_lib_has_file '/proc/sys/net/mptcp/pm_type'; then
 		set_userspace_pm $ns1
-		pm_nl_set_limits $ns2 1 1
+		pm_nl_set_limits $ns2 2 2
 		speed=5 \
 			run_tests $ns1 $ns2 10.0.1.1 &
 		local tests_pid=$!
 		wait_mpj $ns1
 		userspace_pm_add_addr $ns1 10.0.2.1 10
-		chk_join_nr 1 1 1
-		chk_add_nr 1 1
-		chk_mptcp_info subflows 1 subflows 1
-		chk_subflows_total 2 2
-		chk_mptcp_info add_addr_signal 1 add_addr_accepted 1
+		userspace_pm_add_addr $ns1 10.0.3.1 20
+		chk_join_nr 2 2 2
+		chk_add_nr 2 2
+		chk_mptcp_info subflows 2 subflows 2
+		chk_subflows_total 3 3
+		chk_mptcp_info add_addr_signal 2 add_addr_accepted 2
 		userspace_pm_rm_addr $ns1 10
 		userspace_pm_rm_sf $ns1 "::ffff:10.0.2.1" $SUB_ESTABLISHED
-		chk_rm_nr 1 1 invert
+		userspace_pm_rm_addr $ns1 20
+		userspace_pm_rm_sf $ns1 10.0.3.1 $SUB_ESTABLISHED
+		chk_rm_nr 2 2 invert
 		chk_mptcp_info subflows 0 subflows 0
 		chk_subflows_total 1 1
 		kill_events_pids
--- a/tools/testing/selftests/net/mptcp/mptcp_lib.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_lib.sh
@@ -213,9 +213,9 @@ mptcp_lib_get_info_value() {
 	grep "${2}" | sed -n 's/.*\('"${1}"':\)\([0-9a-f:.]*\).*$/\2/p;q'
 }
 
-# $1: info name ; $2: evts_ns ; $3: event type
+# $1: info name ; $2: evts_ns ; [$3: event type; [$4: addr]]
 mptcp_lib_evts_get_info() {
-	mptcp_lib_get_info_value "${1}" "^type:${3:-1}," < "${2}"
+	grep "${4:-}" "${2}" | mptcp_lib_get_info_value "${1}" "^type:${3:-1},"
 }
 
 # $1: PID


