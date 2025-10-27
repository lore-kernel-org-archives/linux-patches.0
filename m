Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15EF329C7B;
	Mon, 27 Oct 2025 18:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590807; cv=none; b=Clg/n0oEjyivPjGtHzD4BL4c/4yCJXgSDRzasA5gYhpJXklK7E6u7BQjK/YTO6GrLg//RbYBIt+EFKZyS37vgNT3OdeQyx5muQK+8BKr+8EbUx1VxCJ/JbFGpKxcYONQBadZs+ohyUkBbSoDcZs6nfPElosHaLAdsL6tpN1qY7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590807; c=relaxed/simple;
	bh=6HaxomTQNZOdDDkHtQbx90aWDtKemytXnF6YW/5Dpf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HpDKgUlBj4Az4Y/07OpP5FkvNmytaiHOmbJnMbUW1WiwgVN17JPLakjXwYXEXOEwonPeAPRDt3IEm6vf26PsPweFdOzGoigL8fzzb00Cn0ynYKsnd/D1goqJtOvr80dHpS+5UZEz2Xfk8f1iCtzARX/l+/0oNMtavNRh5Jwns/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QU72lxqk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QU72lxqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A19BC4CEF1;
	Mon, 27 Oct 2025 18:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590807;
	bh=6HaxomTQNZOdDDkHtQbx90aWDtKemytXnF6YW/5Dpf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QU72lxqkFxNKJCLAXRIuV6NU7QcXSY3ujRwqH8Kl/NbHi1Oj045ks6MfcJhdhO2ro
	 RiHZnywCytR3hItrn/xSUFFijyrGZY0NIyPCDpbZ5NVzh5OBbZLQLWs/xMWcKpyRku
	 AJgejCXovKKFZjDLac+cLvSD7mnCXma9owMFQuGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 183/224] net: rtnetlink: add msg kind names
Date: Mon, 27 Oct 2025 19:35:29 +0100
Message-ID: <20251027183513.750034016@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index f1338734c2eee..2cdb07dd263bd 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -5193,11 +5193,11 @@ static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
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
 
@@ -5214,11 +5214,11 @@ static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
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
 		u16 min_dump_alloc = 0;
-- 
2.51.0



