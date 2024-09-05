Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70358155730;
	Thu,  5 Sep 2024 09:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529997; cv=none; b=kV0l5GXUUPi8W/Uqt07qnTK87bzFU910EIh8/HvruSVSeyT17HKUvxJ8oaV9fmUMD3JR+B5Jph67CetQieuZFxFzLOdSGz6yPdQ8rE5U0dzY8e3ECEPXJrWsKQf9vMG59zlwcKmvqppvkKVOE97yMeSWAGpKCcUw/MdJkuTtXho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529997; c=relaxed/simple;
	bh=GcIKeNnu5SPjxoe9uc1HraLIknM2YkpIL4WR7RtmhQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4g8S22gIHB7j1psmnTunEm9XWMeQTEENIKfnmCd0sFlVBi+nRG2EzLwF1oMSrwF7mOFlEE+BtpSb+kvkhHFZHc4m/SfqMkEXhw3Fc9eyIAYykHFBDDR3z9T0o+sjIhG4YVFqi+0j5U5pdPC0DIxwUlZbvgN6H/xm9hGGLfstOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OzJuW3Vt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OzJuW3Vt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F0DC4CEC3;
	Thu,  5 Sep 2024 09:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529997;
	bh=GcIKeNnu5SPjxoe9uc1HraLIknM2YkpIL4WR7RtmhQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OzJuW3VtirqCjSl59sdXGuR0LvSHrye1ijdgNCMXe5ceXlk/XpUlG4wYLxQX4GETS
	 +Ik8vW45BffeAz4976ABTItlUl2LhJ7VcT/7HLpoojid9+Wl4TITUUSd7PCp4h0B1w
	 Jv8O5R/08YH0SgtxNtcjIhUtcdGbSZn2Os5keHOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/132] mptcp: make pm_remove_addrs_and_subflows static
Date: Thu,  5 Sep 2024 11:40:09 +0200
Message-ID: <20240905093723.099513346@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

[ Upstream commit e38b117d7f3b4a5d810f6d0069ad0f643e503796 ]

mptcp_pm_remove_addrs_and_subflows() is only used in pm_netlink.c, it's
no longer used in pm_userspace.c any more since the commit 8b1c94da1e48
("mptcp: only send RM_ADDR in nl_cmd_remove"). So this patch changes it
to a static function.

Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 87b5896f3f78 ("mptcp: pm: fix RM_ADDR ID for the initial subflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_netlink.c | 4 ++--
 net/mptcp/protocol.h   | 2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 7dd10bacc8d28..e40c06a51b167 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1701,8 +1701,8 @@ void mptcp_pm_remove_addrs(struct mptcp_sock *msk, struct list_head *rm_list)
 	}
 }
 
-void mptcp_pm_remove_addrs_and_subflows(struct mptcp_sock *msk,
-					struct list_head *rm_list)
+static void mptcp_pm_remove_addrs_and_subflows(struct mptcp_sock *msk,
+					       struct list_head *rm_list)
 {
 	struct mptcp_rm_list alist = { .nr = 0 }, slist = { .nr = 0 };
 	struct mptcp_pm_addr_entry *entry;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 20736f31dc534..940fd94006489 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -948,8 +948,6 @@ int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 			   bool echo);
 int mptcp_pm_remove_addr(struct mptcp_sock *msk, const struct mptcp_rm_list *rm_list);
 void mptcp_pm_remove_addrs(struct mptcp_sock *msk, struct list_head *rm_list);
-void mptcp_pm_remove_addrs_and_subflows(struct mptcp_sock *msk,
-					struct list_head *rm_list);
 
 void mptcp_free_local_addr_list(struct mptcp_sock *msk);
 int mptcp_nl_cmd_announce(struct sk_buff *skb, struct genl_info *info);
-- 
2.43.0



