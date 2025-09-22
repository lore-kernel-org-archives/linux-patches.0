Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31CC2F0C5C;
	Mon, 22 Sep 2025 19:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569795; cv=none; b=dgtYigEC/gnAxNyFPy/2krAsXYWD9f43ogI4CVrLZG2BWodxDsbDrz+v+27nCTcDbybN+Eqem+dU+2mpQgWpORi1AScydQvRoh29x4mjIV4JAiz0aDYhUwE3nJfqeH9MoV4EUYHmX8Dq5ZIe4gqm394WqYmZgRQ4lAFVwOG6dwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569795; c=relaxed/simple;
	bh=hdNPuewVEG/0/jFF9KCu3Ldqm8roAHH3pugLA8IXilw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rWyhafzcxSSoA7VNOjJMIRBD9OhbFiPJmsdciX5SoQq9FWEZhJGJ89VR0cBpFgURNjZFyqbl08jDoRc5WI1MkJPobeTJldVOtOT5XYLwW7JusZouc5loaJXj7Ondr2y8TcHSI0QwZMUtAGCJmjEkOE554RH8Ska5eJfWekVS+sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tML+A54M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tML+A54M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8806FC4CEF0;
	Mon, 22 Sep 2025 19:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569794;
	bh=hdNPuewVEG/0/jFF9KCu3Ldqm8roAHH3pugLA8IXilw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tML+A54Mr6cPPZMFnboGGHq+sppOUiCI6ryT9b90Sd3xxvKJoCgR5cYsU5c5wU7zZ
	 578KSzXn8+GmGo7IKaLLAyqEUWONqFIdtLrx71CexX61BEb98Zketsk3Fen5tEWYUB
	 6omutWt7sSJCS28rXW36nnXG+zcN+LA2l35EnDgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 59/70] selftests: mptcp: userspace pm: validate deny-join-id0 flag
Date: Mon, 22 Sep 2025 21:29:59 +0200
Message-ID: <20250922192406.183370035@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

commit 24733e193a0d68f20d220e86da0362460c9aa812 upstream.

The previous commit adds the MPTCP_PM_EV_FLAG_DENY_JOIN_ID0 flag. Make
sure it is correctly announced by the other peer when it has been
received.

pm_nl_ctl will now display 'deny_join_id0:1' when monitoring the events,
and when this flag was set by the other peer.

The 'Fixes' tag here below is the same as the one from the previous
commit: this patch here is not fixing anything wrong in the selftests,
but it validates the previous fix for an issue introduced by this commit
ID.

Fixes: 702c2f646d42 ("mptcp: netlink: allow userspace-driven subflow establishment")
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250912-net-mptcp-pm-uspace-deny_join_id0-v1-3-40171884ade8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Conflict in userspace_pm.sh, because of a difference in the context,
  introduced by commit c66fb480a330 ("selftests: userspace pm: avoid
  relaunching pm events"), which is not in this version. The same lines
  can still be added at the same place. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c     |    7 +++++++
 tools/testing/selftests/net/mptcp/userspace_pm.sh |   14 +++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
+++ b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
@@ -194,6 +194,13 @@ static int capture_events(int fd, int ev
 					fprintf(stderr, ",error:%u", *(__u8 *)RTA_DATA(attrs));
 				else if (attrs->rta_type == MPTCP_ATTR_SERVER_SIDE)
 					fprintf(stderr, ",server_side:%u", *(__u8 *)RTA_DATA(attrs));
+				else if (attrs->rta_type == MPTCP_ATTR_FLAGS) {
+					__u16 flags = *(__u16 *)RTA_DATA(attrs);
+
+					/* only print when present, easier */
+					if (flags & MPTCP_PM_EV_FLAG_DENY_JOIN_ID0)
+						fprintf(stderr, ",deny_join_id0:1");
+				}
 
 				attrs = RTA_NEXT(attrs, msg_len);
 			}
--- a/tools/testing/selftests/net/mptcp/userspace_pm.sh
+++ b/tools/testing/selftests/net/mptcp/userspace_pm.sh
@@ -196,6 +196,9 @@ make_connection()
 		is_v6="v4"
 	fi
 
+	# set this on the client side only: will not affect the rest
+	ip netns exec "$ns2" sysctl -q net.mptcp.allow_join_initial_addr_port=0
+
 	# Capture netlink events over the two network namespaces running
 	# the MPTCP client and server
 	if [ -z "$client_evts" ]; then
@@ -227,23 +230,28 @@ make_connection()
 	local client_token
 	local client_port
 	local client_serverside
+	local client_nojoin
 	local server_token
 	local server_serverside
+	local server_nojoin
 
 	client_token=$(mptcp_lib_evts_get_info token "$client_evts")
 	client_port=$(mptcp_lib_evts_get_info sport "$client_evts")
 	client_serverside=$(mptcp_lib_evts_get_info server_side "$client_evts")
+	client_nojoin=$(mptcp_lib_evts_get_info deny_join_id0 "$client_evts")
 	server_token=$(mptcp_lib_evts_get_info token "$server_evts")
 	server_serverside=$(mptcp_lib_evts_get_info server_side "$server_evts")
+	server_nojoin=$(mptcp_lib_evts_get_info deny_join_id0 "$server_evts")
 
 	print_test "Established IP${is_v6} MPTCP Connection ns2 => ns1"
-	if [ "$client_token" != "" ] && [ "$server_token" != "" ] && [ "$client_serverside" = 0 ] &&
-		   [ "$server_serverside" = 1 ]
+	if [ "${client_token}" != "" ] && [ "${server_token}" != "" ] &&
+	   [ "${client_serverside}" = 0 ] && [ "${server_serverside}" = 1 ] &&
+	   [ "${client_nojoin:-0}" = 0 ] && [ "${server_nojoin:-0}" = 1 ]
 	then
 		test_pass
 		print_title "Connection info: ${client_addr}:${client_port} -> ${connect_addr}:${app_port}"
 	else
-		test_fail "Expected tokens (c:${client_token} - s:${server_token}) and server (c:${client_serverside} - s:${server_serverside})"
+		test_fail "Expected tokens (c:${client_token} - s:${server_token}), server (c:${client_serverside} - s:${server_serverside}), nojoin (c:${client_nojoin} - s:${server_nojoin})"
 		mptcp_lib_result_print_all_tap
 		exit 1
 	fi


