Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0A7274FD0;
	Mon, 27 Oct 2025 19:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591724; cv=none; b=UUYQsaeEMtpmM0G1jImQ0pS82O3xjCDhg77An9YC8vDhTBqnA32YaEepArtPw7zxGH5XyNjhH3PNaMp6lbFONujfh/oQe9V8L/i3MOX8B2ppGwmss9mady7u5h0NwPH/3dzV01tbeE0jgJ+0uA/QtN2nnAZAMVnXDmuNlZGqeiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591724; c=relaxed/simple;
	bh=fzFqLNMEpQs42+4EgdciLwUtYNHLGQCQPv/JOjH5Kmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UxSJmm8EBadNgfzcs+2iHoyJfnmGCqdP1ll5Jfba/alYs1E8K7dX3RuB5Xuw707cOcojl9ucg5LHFFj6aBrmGe2aAty57qUq6doh2f0ijE06Lq0z6rtHHn0FCLmoZyiVy4yegkl099ofShd+jXt4kB/QkumoBB4/ynpylxMiUyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PdB/Z0tP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PdB/Z0tP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51702C4CEF1;
	Mon, 27 Oct 2025 19:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591723;
	bh=fzFqLNMEpQs42+4EgdciLwUtYNHLGQCQPv/JOjH5Kmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PdB/Z0tPw0XsL11T7odK6EeilRYX37rlmYSjhbvaGP+JvROt0+/rnY0V6IloXGv6d
	 Gv3DyI8imi9i8E/kTAnZgb3/nCEqklir8hEhFrb9e9U8zDfsL0DScyTRjmo57jRJIo
	 mg/VrHGHCpYj+4o3a3J6EwceOY4qezPeS/5YlCUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 268/332] net: rtnetlink: add msg kind names
Date: Mon, 27 Oct 2025 19:35:21 +0100
Message-ID: <20251027183531.934753958@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit 12dc5c2cb7b269c5a1c6d02844f40bfce942a7a6 ]

Add rtnl kind names instead of using raw values. We'll need to
check for DEL kind later to validate bulk flag support.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: bf29555f5bdc ("rtnetlink: Allow deleting FDB entries in user namespace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/rtnetlink.h | 7 +++++++
 net/core/rtnetlink.c    | 6 +++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
index 5c2a73bbfabee..74eff5259b361 100644
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
index bc86034e17eab..c0a3cf3ed8f34 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -5513,11 +5513,11 @@ static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
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
 
@@ -5534,11 +5534,11 @@ static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
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
2.51.0



