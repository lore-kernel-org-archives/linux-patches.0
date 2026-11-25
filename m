Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618426;
	b=LIakBNMQV12W0gWPU2H6DgvxK69oKOA77gsbz0c+eqz9e6kjFt8jU5EOk2gSc+NifGFx
	 q2hiJSAZ3j7qDX7SMPuytFOMgBH4w+UAqe+IEKlYH+nivFa1Pj8oh5tX6Hkh9pNuCHKS8
	 xvbUYYQ0NRA/CXcdjRrLcEAx3TbbpZGixvOC+NSs9Ixr8D/8pscwMGblJ4x4zNZWbDkc+
	 mbSELzF57MOW36XsFSG0tqBh9fqPjaAOvXXaP5gHx9zDnEf/TiI8izhI5c2230aPcn5ef
	 Mrg/vDQt+a5x2lrTb38mCGFcyj4m3Vq5AWZ399eCBRBv4U4sNcMByjXZPXB6fC2RmOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618426;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BF9BQhm7SOD5B8VNhda05gWQgBsJnAae5QvgT2/1u3o=;
	b=28XLo88VB/RHZTbByuyssGFRZm7nU5zK68FyDz+mipchttZqiS/6AwbkLZC2u2Nrx6fe
	 W3iWqkT3rXXESMWIFnL2WXu64i6n82elV2ZUmo335UrRsyUcjFFlPDPOwFLNqqSGmKMx3
	 oQNRIbHjyhLOnHN85GGfkhTRjLojO2IYl6cNqUTYem4C+TFddZX/x592akxhgViTieC1Z
	 cIZwH2YhFq8/J6PXdVxigI65LZ3RLEZkYSH5iNGDTg9GmYBwv3/+nMJfX5nUjiZUcZJjs
	 wuvLqAyofNrrvgUo8ryQr+TDhWQW55TbNlLn+7VvOYOQyFaGMuKJrF4ujnNoiFF+6CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L2EWB8YL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F53E606A326;
	Wed, 25 Nov 2026 14:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L2EWB8YL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7801F000C4;
	Wed, 25 Nov 2026 14:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618425;
	bh=BF9BQhm7SOD5B8VNhda05gWQgBsJnAae5QvgT2/1u3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L2EWB8YLYtiNkZdn6f98haxDDiRRnn7aw9XF6/Gs0PVyXFigeq8YrL6jR1jIbukeg
	 lwzgL+TAjnTdUZxv2tdeKSSpvlXd1USp1ARnow1Zot84r6ZzYmtz0EakiN7KSzkmZp
	 Y3Vr3sJCJPMENNdGXfZRbIJHS+JsKt5J7jRPE+T8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris J Arges <carges@cloudflare.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0277/1005] ipv4: Batch rt_flush_dev() in netdev_run_todo().
Date: Wed, 25 Nov 2026 15:26:55 +0100
Message-ID: <20261125143828.228008053@linuxfoundation.org>
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

[ Upstream commit ca6854799069778fef446d307935f764cc3d3afb ]

IPv4 uncached routes are linked to the global per-cpu lists,
rt_uncached_list.

When unregistering a netdev, rt_flush_dev() iterates over the
potentially long lists to find uncached routes tied to the device
and swap it with blackhole_netdev.

Since it is called for every device in dying netns under RTNL,
it adds O(N_dev x (N_cpu + N_route)) costs to any batched device
unregistration.

Let's call it once per batched device unregistration without RTNL.

Note that rt_flush_dev() must be called after setting dev->reg_state
to NETREG_UNREGISTERED.  Otherwise, because rt_flush_dev(NULL) runs
without RTNL, it could race with unregister_netdevice_many_notify()
and prematurely purge routes for NETREG_UNREGISTERING dev, for
which flush_all_backlogs() has not been called yet.

Reported-by: Chris J Arges <carges@cloudflare.com>
Closes: https://lore.kernel.org/netdev/20260917-hash-bucket-route-lists-v3-0-30493a37b6eb@cloudflare.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Chris J Arges <carges@cloudflare.com>
Link: https://patch.msgid.link/20261001204752.2572265-6-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: a0fe1a3f390a ("ipv6: Flush rt->from in rt6_uncached_list_flush_dev().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/route.h |  6 ++++++
 net/core/dev.c      |  4 ++++
 net/ipv4/route.c    | 11 +++++++++--
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/include/net/route.h b/include/net/route.h
index 45290177a33c4..b4dfa2dcfd6cc 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -129,7 +129,13 @@ struct in_device;
 
 int ip_rt_init(void);
 void rt_cache_flush(struct net *net);
+#ifdef CONFIG_INET
 void rt_flush_dev(struct net_device *dev);
+#else
+static inline void rt_flush_dev(struct net_device *dev)
+{
+}
+#endif
 
 static inline void inet_sk_init_flowi4(const struct inet_sock *inet,
 				       struct flowi4 *fl4)
diff --git a/net/core/dev.c b/net/core/dev.c
index cc95d271a3ec8..270adccbdcff5 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -129,6 +129,7 @@
 #include <linux/ip.h>
 #include <net/ip.h>
 #include <net/mpls.h>
+#include <net/route.h>
 #include <linux/ipv6.h>
 #include <linux/in.h>
 #include <linux/jhash.h>
@@ -11885,6 +11886,9 @@ void netdev_run_todo(void)
 		linkwatch_sync_dev(dev);
 	}
 
+	if (!list_empty(&list))
+		rt_flush_dev(NULL);
+
 	cnt = 0;
 	while (!list_empty(&list)) {
 		dev = netdev_wait_allrefs_any(&list);
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 1d8fcd19eaf65..67c4fae2384b3 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1589,6 +1589,9 @@ void rt_flush_dev(struct net_device *dev)
 	struct rtable *rt, *safe;
 	int cpu;
 
+	if (dev && dev->dismantle)
+		return;
+
 	for_each_possible_cpu(cpu) {
 		struct uncached_list *ul = &per_cpu(rt_uncached_list, cpu);
 
@@ -1597,10 +1600,14 @@ void rt_flush_dev(struct net_device *dev)
 
 		spin_lock_bh(&ul->lock);
 		list_for_each_entry_safe(rt, safe, &ul->head, dst.rt_uncached) {
-			if (rt->dst.dev != dev)
+			struct net_device *rt_dev = rt->dst.dev;
+
+			if (dev ? rt_dev != dev :
+			    READ_ONCE(rt_dev->reg_state) != NETREG_UNREGISTERED)
 				continue;
+
 			rcu_assign_pointer(rt->dst.dev_rcu, blackhole_netdev);
-			netdev_ref_replace(dev, blackhole_netdev,
+			netdev_ref_replace(rt_dev, blackhole_netdev,
 					   &rt->dst.dev_tracker, GFP_ATOMIC);
 			list_del_init(&rt->dst.rt_uncached);
 		}
-- 
2.53.0



