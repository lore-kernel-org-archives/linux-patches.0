Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042188;
	b=31UTs3+5RLY1h1Gryo+Ceq0Ra3MMAyyjRqOleOC5vvleWY2ER5z55WaUXO2SAR0T7JcZ
	 RyNkXyyqqOjnzcCuyXFi5e3Ex3JJp8iHxAH/dzOF0KklyXCuTktUHafM5doLhpM9jBmh6
	 RoMMNzwjsTTCDK/sMgX4cth5gPcIyXBV6J77HdLhoDKPRSEh81vndPwDOTdPQe/S2EofC
	 2yJEgrH3khA315bO+kvAfLvo+mLtduLqtCGmKwqbJvv3Lkpdyp7lzTTztMiMfihT72rL4
	 xtksBZq8jzxAUnt7ArDOKe7pSy2Ctx0LFJ049W3Qy3o0JQ+s2Usbsw4oVY1jV29W6IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042188;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TjFHOLFqIYmdirFZ4qe5G+kHGkvSOcMFo45wpFrwDGY=;
	b=D0++wowsZ98q1BwV3EBGFizuCl4P6LbXDsqYsVxr4gJS67OMXx/cUvJs+VS7dYy+5q1Z
	 THCFtwu9Zi9ApneGuwLaoYEBNlkQLr6OUiyY363jDaLZB363uigfphz9h13d7GlPAvN7H
	 SFexGrg31IY2iw6vzBiPrAdZNjDXuBestedI7IztJ91lJyGc0TdYp5sj5PDAK2TfPj9lv
	 m+CDgoG8sgfgOhbbIzD9i8h/qyP+p3U4tlkVeJ3LhEeTL2MHn0In5aGDfYiy42Hu4M9p1
	 jRM22d17ls4IuIpz1h/wU+NCRQolMTvt8JubqNdWTtY8BWDQXQS+XpGoMuc9a3jr8aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0Hm/mDEl";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CD7606A31C;
	Wed, 18 Nov 2026 22:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Hm/mDEl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9991F000C4;
	Wed, 18 Nov 2026 22:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042188;
	bh=TjFHOLFqIYmdirFZ4qe5G+kHGkvSOcMFo45wpFrwDGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Hm/mDElKZmKDw4b9/Qf/48tgOmabck+KnoJXIXuGthHutdeo+Tdxul/Oq3S3QgiM
	 /qiKDPQBf943LCsLSqWfErCUB1dQ6Fvq1Jolis3YjVGTamvf9KwSL9HGjIw4rfyWXY
	 RnBIJEQ1DJoQsupab2ImPD5N5SLLpMuFP1CmRkvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <netdev-bot+sashiko@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Eric Dumazet <edumazet@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3082/3318] ipv6: Hold RCU when emitting route hardware flags notification
Date: Wed, 18 Nov 2026 16:01:44 +0100
Message-ID: <20261118150452.524343716@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 7c9cb1edaf8fd8e1af25e39741e603500986ef66 ]

fib6_info_hw_flags_set() is called by drivers from process context
without RTNL or RCU. When the route uses a nexthop object,
rt6_nlmsg_size() and rt6_fill_node() access the nexthop's RCU protected
nexthop info and group pointers via rcu_dereference_rtnl(), resulting in
suspicious RCU usage splats [1].

Fix by holding RCU while sizing and filling the notification, like
fib_alias_hw_flags_set() already does. Switch to GFP_ATOMIC for the skb
allocation accordingly.

Reproducer:

 # echo "10 0" > /sys/bus/netdevsim/new_device
 # sysctl -wq net.ipv6.fib_notify_on_flag_change=1
 # sysctl -wq net.ipv4.nexthop_compat_mode=1
 # ip -6 nexthop add id 1 blackhole
 # ip -6 route add 2001:db8:1::1/128 nhid 1

[1]
WARNING: suspicious RCU usage
7.3.0-rc7-virtme-g191aa41548b2 #38 Not tainted
net/ipv4/nexthop.c:1539 suspicious rcu_dereference_check() usage!
[...]
Workqueue: events nsim_fib_event_work
Call Trace:
 <TASK>
 dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:120)
 lockdep_rcu_suspicious.cold (kernel/locking/lockdep.c:6972)
 nexthop_for_each_fib6_nh (net/ipv4/nexthop.c:1539 (discriminator 16))
 rt6_nlmsg_size (net/ipv6/route.c:5728)
 fib6_info_hw_flags_set (net/ipv6/route.c:6503)
 nsim_fib6_rt_add (drivers/net/netdevsim/fib.c:671 drivers/net/netdevsim/fib.c:694)
 nsim_fib6_rt_insert (drivers/net/netdevsim/fib.c:759)
 nsim_fib_event_work (drivers/net/netdevsim/fib.c:856 drivers/net/netdevsim/fib.c:889 drivers/net/netdevsim/fib.c:1493)
 process_one_work (kernel/workqueue.c:3396)
 worker_thread (kernel/workqueue.c:3479 kernel/workqueue.c:3560)
 kthread (kernel/kthread.c:436)
 ret_from_fork (arch/x86/kernel/process.c:158)
 ret_from_fork_asm (arch/x86/entry/entry_64.S:245)
 </TASK>

Fixes: 907eea486888 ("net: ipv6: Emit notification when fib hardware flags are changed")
Reported-by: Sashiko <netdev-bot+sashiko@kernel.org>
Closes: https://lore.kernel.org/netdev/179152182668.434549.18232968419539498055@kernel.org/
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20261019140337.2886875-2-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index bbc5b400a27e7..970af77d58461 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6340,7 +6340,9 @@ void fib6_info_hw_flags_set(struct net *net, struct fib6_info *f6i,
 	if (!net->ipv6.sysctl.fib_notify_on_flag_change)
 		return;
 
-	skb = nlmsg_new(rt6_nlmsg_size(f6i), GFP_KERNEL);
+	rcu_read_lock();
+
+	skb = nlmsg_new(rt6_nlmsg_size(f6i), GFP_ATOMIC);
 	if (!skb) {
 		err = -ENOBUFS;
 		goto errout;
@@ -6353,10 +6355,13 @@ void fib6_info_hw_flags_set(struct net *net, struct fib6_info *f6i,
 		goto errout;
 	}
 
+	rcu_read_unlock();
+
 	rtnl_notify(skb, net, 0, RTNLGRP_IPV6_ROUTE, NULL, GFP_KERNEL);
 	return;
 
 errout:
+	rcu_read_unlock();
 	rtnl_set_sk_err(net, RTNLGRP_IPV6_ROUTE, err);
 }
 EXPORT_SYMBOL(fib6_info_hw_flags_set);
-- 
2.53.0



