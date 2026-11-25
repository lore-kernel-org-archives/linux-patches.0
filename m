Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618429;
	b=eDIOa8vkXCYzg3BIIIVmOfx6+4mExk04YKfe/YMAkG+Cf6jRexuNYb9XXLOopckT6p1f
	 pUvh3gCKLXRyp7e4/w60XiLGjnemf8FthAndsPRyr2W+gwtnzzdmc/jtF9DwbRT9abOME
	 8bBgmGSLAyLfFuoaP4hCB13Ryl2mJSLcQOK/0ICVlQAos3KZdpihLVhnDyt6bQu4Q1z7V
	 9Ez8kQnQOS0BGF3pQt84PPLelKU0G2P+b/Zfee1SKXPWFpc1ZrZmmvkI5ip2TjeRRh/5S
	 oO9sqJkfv4EmHurXY1GbrIczR78jaHEscwC4CojjhEkV4lzdFVy2JjUGANN42Mcd4FQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618429;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y3f3ebTCtuX/ZdruFrlNDxxajBkNWFPni6QT2R/lo7o=;
	b=VuZXRr2x4+gimIvi6bZeGp+rCIXRqcyra05TTpow0+No8g8LUUm1soXfgo0f09zrTLQw
	 uduIXcvyii/S8PHomOKkiPHBwVzLqKHb7RAlMTe1kQcvef0JpF0rOIUSOs5uPec01D5fB
	 YIt/6hvtbWDIdYwtNvz6UewzXyWcU0VjHwy+cOqUCs60Ro39/RtmkrmHS1aGNyE+Nvc1a
	 A9m5JaXjfZJtXJWpiJXd6uE1s2l4qmsucshskE80nFmYjDCSpJJ2QThOUBFHRT31Gvquq
	 6IEytNshr/KGzgMicgLfXsZpmwiRVhC7MzEXvrmbTknAklslFit39GmUPMnPuSjTvUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=biJaxz6u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFD4606A327;
	Wed, 25 Nov 2026 14:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=biJaxz6u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77CD21F00A00;
	Wed, 25 Nov 2026 14:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618429;
	bh=Y3f3ebTCtuX/ZdruFrlNDxxajBkNWFPni6QT2R/lo7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=biJaxz6ues947SFAaCruIXmScAi78fFHYPKHpf/CLrtAyotZAIaaSHDE4CKjxbDBT
	 QXHBDmIlAr6xQSLlmOsjhpnMFQw2FR4OEQ61IS/z+oi7abkmeJGTqRqzG35KZn0w/p
	 QR/4/rVeH8oxz0PHLXJl1aX6SAsKwof76994gUzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris J Arges <carges@cloudflare.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0278/1005] ipv6: Batch rt6_uncached_list_flush_dev() in netdev_run_todo().
Date: Wed, 25 Nov 2026 15:26:56 +0100
Message-ID: <20261125143828.252833170@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit f12d2907992db7ba91cc4a1796dce3cffb01318c ]

IPv6 uncached routes are linked to the global per-cpu lists,
rt6_uncached_list.

When unregistering a netdev, rt6_uncached_list_flush_dev() iterates
over the potentially long lists to find uncached routes tied to
the device and swap it with blackhole_netdev.

Since it is called for every device in dying netns under RTNL,
it adds O(N_dev x (N_cpu + N_route)) costs to any batched device
unregistration.

Let's call it once per batched device unregistration without RTNL.

Because it now runs without RTNL, rt->dst.dev and rt->rt6i_idev->dev
may transition to NETREG_UNREGISTERED at different times.  Thus, we
must check that both devices are blackhole_netdev before unlinking
the route; otherwise, the remaining device reference would not be
flushed when the other device is unregistered.

In addition, since netdev_run_todo() runs even when IPv6 is disabled,
rt6_uncached_list_flush_dev() must check ipv6_mod_enabled() before
touching rt6_uncached_list.

Note also that netdev_run_todo() cannot be called before
rt6_uncached_list is initialised because:

  1. unregister_netdevice_many_notify() panics when
     dev_boot_phase == 1 (net_dev_init() is subsys_initcall()).

  2. the only device registered before fs_initcall_sync() is
     loopback and loopback_net_init() panics in case of failure.

Reported-by: Chris J Arges <carges@cloudflare.com>
Closes: https://lore.kernel.org/netdev/20260917-hash-bucket-route-lists-v3-0-30493a37b6eb@cloudflare.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Chris J Arges <carges@cloudflare.com>
Link: https://patch.msgid.link/20261001204752.2572265-7-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: a0fe1a3f390a ("ipv6: Flush rt->from in rt6_uncached_list_flush_dev().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip6_route.h |  7 +++++++
 net/core/dev.c          |  5 ++++-
 net/ipv6/route.c        | 24 ++++++++++++++++--------
 3 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 5fd0c0e4beac0..cf75208bfaa91 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -231,6 +231,13 @@ void rt6_multipath_rebalance(struct fib6_info *f6i);
 
 void rt6_uncached_list_add(struct rt6_info *rt);
 void rt6_uncached_list_del(struct rt6_info *rt);
+#ifdef CONFIG_IPV6
+void rt6_uncached_list_flush_dev(struct net_device *dev);
+#else
+static inline void rt6_uncached_list_flush_dev(struct net_device *dev)
+{
+}
+#endif
 
 static inline const struct rt6_info *skb_rt6_info(const struct sk_buff *skb)
 {
diff --git a/net/core/dev.c b/net/core/dev.c
index 270adccbdcff5..80d37066bf2bf 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -131,6 +131,7 @@
 #include <net/mpls.h>
 #include <net/route.h>
 #include <linux/ipv6.h>
+#include <net/ip6_route.h>
 #include <linux/in.h>
 #include <linux/jhash.h>
 #include <linux/random.h>
@@ -11886,8 +11887,10 @@ void netdev_run_todo(void)
 		linkwatch_sync_dev(dev);
 	}
 
-	if (!list_empty(&list))
+	if (!list_empty(&list)) {
 		rt_flush_dev(NULL);
+		rt6_uncached_list_flush_dev(NULL);
+	}
 
 	cnt = 0;
 	while (!list_empty(&list)) {
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 256b77ac1e6a1..94273e6476885 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -158,10 +158,16 @@ void rt6_uncached_list_del(struct rt6_info *rt)
 	}
 }
 
-static void rt6_uncached_list_flush_dev(struct net_device *dev)
+void rt6_uncached_list_flush_dev(struct net_device *dev)
 {
 	int cpu;
 
+	if (!ipv6_mod_enabled())
+		return;
+
+	if (dev && dev->dismantle)
+		return;
+
 	for_each_possible_cpu(cpu) {
 		struct uncached_list *ul = per_cpu_ptr(&rt6_uncached_list, cpu);
 		struct rt6_info *rt, *safe;
@@ -173,22 +179,24 @@ static void rt6_uncached_list_flush_dev(struct net_device *dev)
 		list_for_each_entry_safe(rt, safe, &ul->head, dst.rt_uncached) {
 			struct inet6_dev *rt_idev = rt->rt6i_idev;
 			struct net_device *rt_dev = rt->dst.dev;
-			bool handled = false;
 
-			if (rt_idev && rt_idev->dev == dev) {
+			if (rt_idev &&
+			    (dev ? rt_idev->dev == dev :
+			     READ_ONCE(rt_idev->dev->reg_state) == NETREG_UNREGISTERED)) {
 				rt->rt6i_idev = in6_dev_get(blackhole_netdev);
 				in6_dev_put(rt_idev);
-				handled = true;
 			}
 
-			if (rt_dev == dev) {
-				rt->dst.dev = blackhole_netdev;
+			if (dev ? rt_dev == dev :
+			    READ_ONCE(rt_dev->reg_state) == NETREG_UNREGISTERED) {
+				rcu_assign_pointer(rt->dst.dev_rcu, blackhole_netdev);
 				netdev_ref_replace(rt_dev, blackhole_netdev,
 						   &rt->dst.dev_tracker,
 						   GFP_ATOMIC);
-				handled = true;
 			}
-			if (handled)
+
+			if (rt->dst.dev == blackhole_netdev &&
+			    (!rt->rt6i_idev || rt->rt6i_idev->dev == blackhole_netdev))
 				list_del_init(&rt->dst.rt_uncached);
 		}
 		spin_unlock_bh(&ul->lock);
-- 
2.53.0



