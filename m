Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF681F941D;
	Tue, 15 Oct 2024 12:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994345; cv=none; b=KM07R2Ru/nRcZGZ5+Uoy/bSTbUfu7YGc3OkafnK0iYIPJhHnaix1nNBiSqa6iGvw/Jh1AaAiNrnD3QY9Q3dthi41Kz4YRfLTyNLk1nmRuaLLyW0Ha4dNdIs8lj7vi4goLUC7BnM6hQTNsopZq13pKMsB2jhkEEl4v2gvFUNzFiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994345; c=relaxed/simple;
	bh=1MCcX+L29fA3mCY73igKwgZVIn3GiG/Awat3719K+lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0sce9N10S6RPkoc6KMODRyfiq1DAIkUk3N9rjOSPGz7sqr9i9uBLykjoqEs43bqaDi3ErKONyxl4LRi1JbTNnYn80c8THYsa6o8fEYWquOQBAutIBlVzBf97PgoXGQ8EIUTZj/uidJOlAW2dpH9b4iChiBpKkS8BkkfJbuo3VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j448HoZg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j448HoZg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE5AC4CED0;
	Tue, 15 Oct 2024 12:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994344;
	bh=1MCcX+L29fA3mCY73igKwgZVIn3GiG/Awat3719K+lQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j448HoZgIxhp/xspMfBLjBbmlcn+1HhPi4z1fdixMXLHSTeb01cRgXU3wSgCRkBOD
	 YpUzoxCAG1gpRTEo6TIH1sHYJposCOcmC1WFUbuBmHgar7rnknzCpOrFBGcI1G017D
	 JnIvDBsOosr6NitCMBDI+iElxODWNo9d6QgtF9kM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 654/691] net: rtnetlink: add msg kind names
Date: Tue, 15 Oct 2024 13:30:02 +0200
Message-ID: <20241015112506.284016368@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit 12dc5c2cb7b269c5a1c6d02844f40bfce942a7a6 ]

Add rtnl kind names instead of using raw values. We'll need to
check for DEL kind later to validate bulk flag support.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: d51705614f66 ("mctp: Handle error of rtnl_register_module().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/rtnetlink.h | 7 +++++++
 net/core/rtnetlink.c    | 6 +++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
index a2a74e0e5c494..c9d3ae92c9321 100644
--- a/include/net/rtnetlink.h
+++ b/include/net/rtnetlink.h
@@ -13,6 +13,13 @@ enum rtnl_link_flags {
 	RTNL_FLAG_DOIT_UNLOCKED = 1,
 };
 
+enum rtnl_kinds {
+	RTNL_KIND_NEW,
+	RTNL_KIND_DEL,
+	RTNL_KIND_GET,
+	RTNL_KIND_SET
+};
+
 void rtnl_register(int protocol, int msgtype,
 		   rtnl_doit_func, rtnl_dumpit_func, unsigned int flags);
 int rtnl_register_module(struct module *owner, int protocol, int msgtype,
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index eca7f6f4a52f5..8fc86d1edf561 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -5521,11 +5521,11 @@ static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 {
 	struct net *net = sock_net(skb->sk);
 	struct rtnl_link *link;
+	enum rtnl_kinds kind;
 	struct module *owner;
 	int err = -EOPNOTSUPP;
 	rtnl_doit_func doit;
 	unsigned int flags;
-	int kind;
 	int family;
 	int type;
 
@@ -5542,11 +5542,11 @@ static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	family = ((struct rtgenmsg *)nlmsg_data(nlh))->rtgen_family;
 	kind = type&3;
 
-	if (kind != 2 && !netlink_net_capable(skb, CAP_NET_ADMIN))
+	if (kind != RTNL_KIND_GET && !netlink_net_capable(skb, CAP_NET_ADMIN))
 		return -EPERM;
 
 	rcu_read_lock();
-	if (kind == 2 && nlh->nlmsg_flags&NLM_F_DUMP) {
+	if (kind == RTNL_KIND_GET && (nlh->nlmsg_flags & NLM_F_DUMP)) {
 		struct sock *rtnl;
 		rtnl_dumpit_func dumpit;
 		u32 min_dump_alloc = 0;
-- 
2.43.0



