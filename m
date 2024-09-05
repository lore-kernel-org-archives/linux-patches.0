Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F1F1494DB;
	Thu,  5 Sep 2024 10:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530452; cv=none; b=maj4JBHo60atpHRFR4bogZyuETyZc3xtYPtVaFlt48TNwITq/MwetUy6cksU+QcDqUZ5K+Ljp8CQiqN6qUvrAYwrhL79lu1E0PwMKBpQDOQDGqKhQXvr7DMV9wgMy1A6cyomJKqBW1b6KhsGi22WbwClG9a9FOQdD22UOJkIQVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530452; c=relaxed/simple;
	bh=kpbNxOl9DJcVJW8U01gFEFcIsmzD84QRydvd7Uxv+r8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oq8kaeAYPo+R2sZ1UGMSRbHIFP49kJ6KCDmOENgzXDhPv2qutQVokYyhdH3vpVPP1uHbACdSSpoqoTaLw1NTDj+iz4cHoWDuLlDoZUn86kY4XRJ+j5EHlml9/37Sf9Ir68U2s6WQGX0g6rjgV7GG9k07YBzdJf5YVBb1xX/8Fos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=162sBK2V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="162sBK2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9794AC4CEC3;
	Thu,  5 Sep 2024 10:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530452;
	bh=kpbNxOl9DJcVJW8U01gFEFcIsmzD84QRydvd7Uxv+r8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=162sBK2VDu4FqFSIXc7NIAS3ghKeu+aTVRujGAmQgCF/QZBN8HiiTgDmhTgtvnvxf
	 hUozi67BXaCE3z3i5GkgBlZziqPHsKSXJQZi5KXXA6kz9bc9ButlqG+O40My9S0mwr
	 bPAUvPVsAxcaMhssFcQwvkgeUvMoXbRLd6eCRnbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 009/101] mptcp: make pm_remove_addrs_and_subflows static
Date: Thu,  5 Sep 2024 11:40:41 +0200
Message-ID: <20240905093716.453528048@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9e16ae1b23fc7..fa0579c2a6ee2 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1667,8 +1667,8 @@ void mptcp_pm_remove_addrs(struct mptcp_sock *msk, struct list_head *rm_list)
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
index c3cd68edab779..ee973d25f5eb5 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -837,8 +837,6 @@ int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 			   bool echo);
 int mptcp_pm_remove_addr(struct mptcp_sock *msk, const struct mptcp_rm_list *rm_list);
 void mptcp_pm_remove_addrs(struct mptcp_sock *msk, struct list_head *rm_list);
-void mptcp_pm_remove_addrs_and_subflows(struct mptcp_sock *msk,
-					struct list_head *rm_list);
 
 void mptcp_free_local_addr_list(struct mptcp_sock *msk);
 int mptcp_nl_cmd_announce(struct sk_buff *skb, struct genl_info *info);
-- 
2.43.0



