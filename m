Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216125;
	b=M79mwv+KLbRlUXQUd9ggs+XNyFHCglSWRd1e2Q7atDphhxh/xllJmv4C9VCKwCH0I+n5
	 UiHFANJGH5tKJJ0/Ewi9g1DvJPsKZn8hnX5LBth+v2/XPY2CsWJMPQ7kaSqcyDekgeG6+
	 lv/dvUfBIg78yu8mrf3I9iSgWGvOTpocHH9qSLv8eBqVrkDc9qdV2wqSuTYsD6dcfuqJH
	 98CEuCCTcmS/VzUiQcgww9NU6eDDR3VOx7KKnMix3GNxGUbgWJDtjixHk8jQwCq1pz8IJ
	 0C0IfugABJ4/QoUAPGejFESFc8dvavR6PxI1Zyn9ZM3tFmzZIfpVAACtHTqj8Mv6V2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216125;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y3L4Lc9exEo0lhHv2Yog/UApLJnl0xGDhdERyMm4zrI=;
	b=lL4XNc4nefzsSNbnFVbfhXp5oR75xhcEOvpvM1jImmXhsZ2wbWGxtuWUKUYz80jUH1lh
	 4PmAD1F2ObKgnxOxErI+1tH3cCQN2CbuIn7sQjKUNpRrZQ12+yqjiWwMorgFoPHb7CE8p
	 ba9+hAvZC7fP0hdB/9AsgvkJH8VKqp8j4r809hUwjzsZrev/stBJcDPJD394eeq9IYIaV
	 o76sZBjvdOgNXt7FOyLp3SHoT7f58Rk1q8knFfBF16sGvdOWv+ialtChL8fdCMd93putT
	 kjNlKnFkUqkT6Y2UYyqFgPGsoKMkfKRhL7drIsZ9IMeMrC0bU1HCzeMePks2Za76BRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yYwBFCSV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D174A606A31A;
	Wed, 28 Oct 2026 19:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yYwBFCSV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B141F01825;
	Wed, 28 Oct 2026 19:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216124;
	bh=y3L4Lc9exEo0lhHv2Yog/UApLJnl0xGDhdERyMm4zrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yYwBFCSVOfFmcbfgtbt8jAqLpkM5zPTvzkFEgUJZO/Tex7uc+xdHN7K2MggkmhlND
	 DLDNBpI51tTIkEV9vLk9+1W1DGl5uT9GNGtd2zwHhqHa9dFhIGl2fA9cQujIr+1NLq
	 AQC3epJUmQ9W1X2qaYbZSL9XEoc0DR7BqnXGni78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1448/1887] ipv4: nexthop: allocate skb dynamically in rtm_get_nexthop()
Date: Wed, 28 Oct 2026 17:59:04 +0100
Message-ID: <20261028170532.411398817@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 14cf0cd35361f4e94824bf8a42f72713d7702a73 ]

When querying a nexthop object via RTM_GETNEXTHOP, the kernel currently
allocates a fixed-size skb using NLMSG_GOODSIZE. While sufficient for
single nexthops and small Equal-Cost Multi-Path groups, this fixed
allocation fails for large nexthop groups like 512 nexthops.

This results in the following warning splat:

 WARNING: net/ipv4/nexthop.c:3395 at rtm_get_nexthop+0x176/0x1c0, CPU#20: rep/4608
 [...]
 RIP: 0010:rtm_get_nexthop (net/ipv4/nexthop.c:3395)
 [...]
 Call Trace:
  <TASK>
  rtnetlink_rcv_msg (net/core/rtnetlink.c:6989)
  netlink_rcv_skb (net/netlink/af_netlink.c:2550)
  netlink_unicast (net/netlink/af_netlink.c:1319 net/netlink/af_netlink.c:1344)
  netlink_sendmsg (net/netlink/af_netlink.c:1894)
  ____sys_sendmsg (net/socket.c:721 net/socket.c:736 net/socket.c:2585)
  ___sys_sendmsg (net/socket.c:2641)
  __sys_sendmsg (net/socket.c:2671)
  do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94)
  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
  </TASK>

Fix this by allocating the size dynamically using nh_nlmsg_size() and
using nlmsg_new(), this is consistent with nexthop_notify() behavior. In
addition, adjust nh_nlmsg_size_grp() so it calculates the size needed
based on flags passed. While at it, also add the size of NHA_FDB for
nexthop group size calculation as it was missing too.

This cannot be reproduced via iproute2 as the group size is currently
limited and the command fails as follows:

addattr_l ERROR: message exceeded bound of 1048

Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Closes: https://lore.kernel.org/netdev/CAL_bE8Li2h4KO+AQFXW4S6Yb_u5X4oSKnkywW+LPFjuErhqELA@mail.gmail.com/
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260402072613.25262-2-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/nexthop.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index b48fbc0f42899..790135fd80e7f 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -790,7 +790,8 @@ static size_t nh_nlmsg_size_grp(struct nexthop *nh)
 	struct nh_group *nhg = rtnl_dereference(nh->nh_grp);
 	size_t sz = sizeof(struct nexthop_grp) * nhg->num_nh;
 	size_t tot = nla_total_size(sz) +
-		nla_total_size(2); /* NHA_GROUP_TYPE */
+		nla_total_size(2) +	/* NHA_GROUP_TYPE */
+		nla_total_size(0);	/* NHA_FDB */
 
 	if (nhg->resilient)
 		tot += nh_nlmsg_size_grp_res(nhg);
@@ -3070,15 +3071,15 @@ static int rtm_get_nexthop(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 	if (err)
 		return err;
 
-	err = -ENOBUFS;
-	skb = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
-	if (!skb)
-		goto out;
-
 	err = -ENOENT;
 	nh = nexthop_find_by_id(net, id);
 	if (!nh)
-		goto errout_free;
+		goto out;
+
+	err = -ENOBUFS;
+	skb = nlmsg_new(nh_nlmsg_size(nh), GFP_KERNEL);
+	if (!skb)
+		goto out;
 
 	err = nh_fill_node(skb, nh, RTM_NEWNEXTHOP, NETLINK_CB(in_skb).portid,
 			   nlh->nlmsg_seq, 0);
-- 
2.53.0



