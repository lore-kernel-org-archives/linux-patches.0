Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4AFB2F0C5C;
	Mon, 22 Sep 2025 19:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569859; cv=none; b=DnP09iGvJaOfuv0OQFfGPm3AY2ysbbRvfectMAK+hAihP/I4yYR99iwliYLbC7wYKNYe4xeCBnOQzQRM5debHJwK3eTQiDgSfcZyxY0e4PA64tqIHrT+HN/qzJLfo27V67lvBfeDSF7paUv9qyQgr0T0ffJGKpW/Swdejero0Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569859; c=relaxed/simple;
	bh=tyHjxJG4K2FrewJKIF/hPZwxvW1226lP8AeUeUpSCnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AteZv75H+kyXNSxrikmfWpJkl+qm4GR7Ly5sckBNmdA23XeIiD6el8rRdiZM7nlMaxVHwKnECxhUxjKMQYl7WPMWJP5MlmbazOfBeAkOMQAyuQjgrVCg924nmP7ZLPo0RxRJ0auLJPMe9/y+cVi61wGHOvTr6hGIC4g/JQAfAEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D26HuJtm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D26HuJtm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE2AC4CEF0;
	Mon, 22 Sep 2025 19:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569859;
	bh=tyHjxJG4K2FrewJKIF/hPZwxvW1226lP8AeUeUpSCnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D26HuJtmBuCRFFFeAku4jdHoue69i15CUfD0s3eKlC/z0lXtYVkWHbrYS5c99acnN
	 mIR0kKwDxEYocTbZ+xtfFrYpWwIlYU53qlDgH0po7E0/9F9vAp/1QbD+Jpc+jyWrk1
	 QH29aZfB4TRLa26cmMEETFQCBwklxqTididL2eO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 016/105] selftests: mptcp: userspace pm: validate deny-join-id0 flag
Date: Mon, 22 Sep 2025 21:28:59 +0200
Message-ID: <20250922192409.333642678@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit 24733e193a0d68f20d220e86da0362460c9aa812 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c     |  7 +++++++
 tools/testing/selftests/net/mptcp/userspace_pm.sh | 14 +++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
index 994a556f46c15..93fea3442216c 100644
--- a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
+++ b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
@@ -188,6 +188,13 @@ static int capture_events(int fd, int event_group)
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
diff --git a/tools/testing/selftests/net/mptcp/userspace_pm.sh b/tools/testing/selftests/net/mptcp/userspace_pm.sh
index 3651f73451cf8..cc682bf675b2b 100755
--- a/tools/testing/selftests/net/mptcp/userspace_pm.sh
+++ b/tools/testing/selftests/net/mptcp/userspace_pm.sh
@@ -173,6 +173,9 @@ make_connection()
 		is_v6="v4"
 	fi
 
+	# set this on the client side only: will not affect the rest
+	ip netns exec "$ns2" sysctl -q net.mptcp.allow_join_initial_addr_port=0
+
 	:>"$client_evts"
 	:>"$server_evts"
 
@@ -195,23 +198,28 @@ make_connection()
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
 		exit ${KSFT_FAIL}
 	fi
-- 
2.51.0



