Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B651A18B48A;
	Tue, 10 Sep 2024 10:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965137; cv=none; b=PwuCgmnP4dSem+6e/4CyDaEQY7Kw7ybwvYDMsR7sQf3I24NccN0KLWJxcfzYfJ1Mwhm+uoJ6peT0cueftWs5jZLe+YDG/4OhZ7qtbYgHFMzqXp6Hq05JfyiiGKbkQsPo4cEipb6Dyu8FLEMWSJOzSYemPdGsF4kFnq3vm2iq5Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965137; c=relaxed/simple;
	bh=YpjJfqbY+UKjW6+YjhTo9PyziV/Ld43mCCfmXlOM+fI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HWHqtvfUd0X/T1RayGA/jmaERfoHV29YW4tUylYvWqzk2AYUfpzccmc4hOaVP6NINmN6oyraRnVk15nhUQYwUZqHiNnRI7l4tVVcYvRKbA7v7N0I439FSIgRBxD6KLoq1rEBF4Ksk77jWW8DLF1vftxN+ZZXGKxlhT3opejKzI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sPRdzkQi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sPRdzkQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87F8C4CEC3;
	Tue, 10 Sep 2024 10:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965137;
	bh=YpjJfqbY+UKjW6+YjhTo9PyziV/Ld43mCCfmXlOM+fI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sPRdzkQiV6T8AcO1MlEoAIsiBIxJeAkkv2/mdIut0KBC0biI/+spEZd5C0fRK79QN
	 VOBVd4TNYmzBoe2KKjH9V2DS3SkBVcppdgXqQDSgH70KaZYdoFMCdX0DqKz0QN36Uh
	 lKRE+sGmO4T3GlOZJwTKZ3apFzhclEVAqjPsdCuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 122/186] fou: remove sparse errors
Date: Tue, 10 Sep 2024 11:33:37 +0200
Message-ID: <20240910092559.594756531@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 8d65cd8d25fa23951171094553901d69a88ccdff ]

We need to add __rcu qualifier to avoid these errors:

net/ipv4/fou.c:250:18: warning: incorrect type in assignment (different address spaces)
net/ipv4/fou.c:250:18:    expected struct net_offload const **offloads
net/ipv4/fou.c:250:18:    got struct net_offload const [noderef] __rcu **
net/ipv4/fou.c:251:15: error: incompatible types in comparison expression (different address spaces):
net/ipv4/fou.c:251:15:    struct net_offload const [noderef] __rcu *
net/ipv4/fou.c:251:15:    struct net_offload const *
net/ipv4/fou.c:272:18: warning: incorrect type in assignment (different address spaces)
net/ipv4/fou.c:272:18:    expected struct net_offload const **offloads
net/ipv4/fou.c:272:18:    got struct net_offload const [noderef] __rcu **
net/ipv4/fou.c:273:15: error: incompatible types in comparison expression (different address spaces):
net/ipv4/fou.c:273:15:    struct net_offload const [noderef] __rcu *
net/ipv4/fou.c:273:15:    struct net_offload const *
net/ipv4/fou.c:442:18: warning: incorrect type in assignment (different address spaces)
net/ipv4/fou.c:442:18:    expected struct net_offload const **offloads
net/ipv4/fou.c:442:18:    got struct net_offload const [noderef] __rcu **
net/ipv4/fou.c:443:15: error: incompatible types in comparison expression (different address spaces):
net/ipv4/fou.c:443:15:    struct net_offload const [noderef] __rcu *
net/ipv4/fou.c:443:15:    struct net_offload const *
net/ipv4/fou.c:489:18: warning: incorrect type in assignment (different address spaces)
net/ipv4/fou.c:489:18:    expected struct net_offload const **offloads
net/ipv4/fou.c:489:18:    got struct net_offload const [noderef] __rcu **
net/ipv4/fou.c:490:15: error: incompatible types in comparison expression (different address spaces):
net/ipv4/fou.c:490:15:    struct net_offload const [noderef] __rcu *
net/ipv4/fou.c:490:15:    struct net_offload const *
net/ipv4/udp_offload.c:170:26: warning: incorrect type in assignment (different address spaces)
net/ipv4/udp_offload.c:170:26:    expected struct net_offload const **offloads
net/ipv4/udp_offload.c:170:26:    got struct net_offload const [noderef] __rcu **
net/ipv4/udp_offload.c:171:23: error: incompatible types in comparison expression (different address spaces):
net/ipv4/udp_offload.c:171:23:    struct net_offload const [noderef] __rcu *
net/ipv4/udp_offload.c:171:23:    struct net_offload const *

Fixes: efc98d08e1ec ("fou: eliminate IPv4,v6 specific GRO functions")
Fixes: 8bce6d7d0d1e ("udp: Generalize skb_udp_segment")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 7e4196935069 ("fou: Fix null-ptr-deref in GRO.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fou.c         | 10 +++++-----
 net/ipv4/udp_offload.c |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/fou.c b/net/ipv4/fou.c
index e5f69b0bf3df..8fcbc6258ec5 100644
--- a/net/ipv4/fou.c
+++ b/net/ipv4/fou.c
@@ -230,8 +230,8 @@ static struct sk_buff *fou_gro_receive(struct sock *sk,
 				       struct list_head *head,
 				       struct sk_buff *skb)
 {
+	const struct net_offload __rcu **offloads;
 	u8 proto = fou_from_sock(sk)->protocol;
-	const struct net_offload **offloads;
 	const struct net_offload *ops;
 	struct sk_buff *pp = NULL;
 
@@ -263,10 +263,10 @@ static struct sk_buff *fou_gro_receive(struct sock *sk,
 static int fou_gro_complete(struct sock *sk, struct sk_buff *skb,
 			    int nhoff)
 {
-	const struct net_offload *ops;
+	const struct net_offload __rcu **offloads;
 	u8 proto = fou_from_sock(sk)->protocol;
+	const struct net_offload *ops;
 	int err = -ENOSYS;
-	const struct net_offload **offloads;
 
 	rcu_read_lock();
 	offloads = NAPI_GRO_CB(skb)->is_ipv6 ? inet6_offloads : inet_offloads;
@@ -311,7 +311,7 @@ static struct sk_buff *gue_gro_receive(struct sock *sk,
 				       struct list_head *head,
 				       struct sk_buff *skb)
 {
-	const struct net_offload **offloads;
+	const struct net_offload __rcu **offloads;
 	const struct net_offload *ops;
 	struct sk_buff *pp = NULL;
 	struct sk_buff *p;
@@ -457,8 +457,8 @@ static struct sk_buff *gue_gro_receive(struct sock *sk,
 
 static int gue_gro_complete(struct sock *sk, struct sk_buff *skb, int nhoff)
 {
-	const struct net_offload **offloads;
 	struct guehdr *guehdr = (struct guehdr *)(skb->data + nhoff);
+	const struct net_offload __rcu **offloads;
 	const struct net_offload *ops;
 	unsigned int guehlen = 0;
 	u8 proto;
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index a0b569d0085b..57168d4fa195 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -149,8 +149,8 @@ struct sk_buff *skb_udp_tunnel_segment(struct sk_buff *skb,
 				       netdev_features_t features,
 				       bool is_ipv6)
 {
+	const struct net_offload __rcu **offloads;
 	__be16 protocol = skb->protocol;
-	const struct net_offload **offloads;
 	const struct net_offload *ops;
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
 	struct sk_buff *(*gso_inner_segment)(struct sk_buff *skb,
-- 
2.43.0



