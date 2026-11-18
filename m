Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034096;
	b=yJr4mhlxSIjk19kMIYR7F4cLgdV0WfcMyviJtDeL1iNDTRthWgYxoggYn1gBRQamFz52
	 uUHXt9ylgdGQ3U2oMPW9gHMfonXPumnovK1fWHY48cRudFnfd3I5QvvVeMkeyT83j4q0+
	 PQCwaHz+Xq23vo0LzJUKM2+KCc5ngAbzn2d+gqEzIdn+fMaZod6GZM0ga59v3p/6sVJaL
	 eVpEC2yDs0yAOX14tweCIlaf+utTv7EB8CyZ8mfQ7KiHg7g2B3Xgqf2YScWmphs3W17ng
	 seGt7dRZ2Ff4LxAi3R6MQZpc6Z6VmxWBigW43WUSTONTuUuHo/GHRU6qOmIMS6Bv03Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034096;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5Z2yC1FEahIhTeV70/PO6Qw8VUiBjIY7qS+a1jxTNoA=;
	b=PKh4bBEV61+V0PnmzZWUcKL679pE6b5xA3Ea1DVLk+xN8dpCtQnPbE5QvINnfsU0t0CS
	 UslMuPmoMwE9pSI1Frtd5Mq0kmtflQw06m/vqv4v3RONSQUEJX/cb6VYqzsxMvfM3S1KY
	 GQg89/t9uHBI751YFBMrgw2OITUZw5YE9JxTZSFXWx2FU/MgWajSvC97e5BA+//VxXAFq
	 GAcm9M2GMhjSU2LpvqXqpDTj/wOMpxudkN+RYQCvyt4ZGaream9mXs9NEINjD0gTXuwbO
	 pQY7a9vcVbPazhFWsbX8exfR5qd0aPFtzw72J8dBHpYMy1VpImJWE70awAqK5ZtHQsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L5jPmfAb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F46C606A31C;
	Wed, 18 Nov 2026 20:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L5jPmfAb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811D31F000C4;
	Wed, 18 Nov 2026 20:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034096;
	bh=5Z2yC1FEahIhTeV70/PO6Qw8VUiBjIY7qS+a1jxTNoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L5jPmfAbX2+RalBFPX3U5SijF10sVPyo85SN8Y7Z8rc6poB4Qzu3/3iF+lr213dxI
	 pm5UhYbAWkPxrlH1qMqNPShlZicOm4mdj7bR/zK6oLD5FQeS7dEbo/vxNErJwzV/gy
	 WJFBFMlvttYzQ6yalJpLUujUbAcMlSu+eniX98yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0208/3318] netfilter: nf_tables: call skb_valid_dst() before skb_dst()
Date: Wed, 18 Nov 2026 15:13:50 +0100
Message-ID: <20261118150321.155265837@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 689db98e535bf8efb5bc9c36f4fd3de3bd715eb6 ]

When fetching the dst_entry from the skb, check if it valid, ie. this is
not a template dst, for extensions that can be used from the netdev
ingress and egress chains.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/nf_reject_ipv4.c | 6 ++++--
 net/ipv6/netfilter/nf_reject_ipv6.c | 8 ++++++--
 net/netfilter/nft_meta.c            | 6 ++++--
 net/netfilter/nft_rt.c              | 6 ++++--
 net/netfilter/nft_xfrm.c            | 9 ++++++++-
 5 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 1632cedcd348c..549d355ebb1d9 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -8,6 +8,7 @@
 #include <net/tcp.h>
 #include <net/route.h>
 #include <net/dst.h>
+#include <net/dst_metadata.h>
 #include <net/netfilter/ipv4/nf_reject.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_bridge.h>
@@ -256,6 +257,7 @@ static int nf_reject_fill_skb_dst(struct sk_buff *skb_in)
 	if (!dst)
 		return -1;
 
+	skb_dst_drop(skb_in);
 	skb_dst_set(skb_in, dst);
 	return 0;
 }
@@ -272,7 +274,7 @@ void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	if (!oth)
 		return;
 
-	if (!skb_dst(oldskb) && nf_reject_fill_skb_dst(oldskb) < 0)
+	if (!skb_valid_dst(oldskb) && nf_reject_fill_skb_dst(oldskb) < 0)
 		return;
 
 	if (skb_rtable(oldskb)->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))
@@ -345,7 +347,7 @@ void nf_send_unreach(struct sk_buff *skb_in, int code, int hook)
 	if (iph->frag_off & htons(IP_OFFSET))
 		return;
 
-	if (!skb_dst(skb_in) && nf_reject_fill_skb_dst(skb_in) < 0)
+	if (!skb_valid_dst(skb_in) && nf_reject_fill_skb_dst(skb_in) < 0)
 		return;
 
 	if (skb_csum_unnecessary(skb_in) ||
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index a19ca1907de36..d565cea4cc737 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -8,6 +8,7 @@
 #include <net/ip6_route.h>
 #include <net/ip6_fib.h>
 #include <net/ip6_checksum.h>
+#include <net/dst_metadata.h>
 #include <net/netfilter/ipv6/nf_reject.h>
 #include <linux/netfilter_ipv6.h>
 #include <linux/netfilter_bridge.h>
@@ -291,6 +292,7 @@ static int nf_reject6_fill_skb_dst(struct sk_buff *skb_in)
 	if (!dst)
 		return -1;
 
+	skb_dst_drop(skb_in);
 	skb_dst_set(skb_in, dst);
 	return 0;
 }
@@ -323,10 +325,12 @@ void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	fl6.fl6_sport = otcph->dest;
 	fl6.fl6_dport = otcph->source;
 
-	if (!skb_dst(oldskb)) {
+	if (!skb_valid_dst(oldskb)) {
 		nf_ip6_route(net, &dst, flowi6_to_flowi(&fl6), false);
 		if (!dst)
 			return;
+
+		skb_dst_drop(oldskb);
 		skb_dst_set(oldskb, dst);
 	}
 
@@ -427,7 +431,7 @@ void nf_send_unreach6(struct net *net, struct sk_buff *skb_in,
 	if (hooknum == NF_INET_LOCAL_OUT && skb_in->dev == NULL)
 		skb_in->dev = net->loopback_dev;
 
-	if (!skb_dst(skb_in) && nf_reject6_fill_skb_dst(skb_in) < 0)
+	if (!skb_valid_dst(skb_in) && nf_reject6_fill_skb_dst(skb_in) < 0)
 		return;
 
 	icmpv6_send(skb_in, ICMPV6_DEST_UNREACH, code, 0);
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 983158274c68d..9ef4173976c04 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -20,6 +20,7 @@
 #include <net/dst.h>
 #include <net/ip.h>
 #include <net/sock.h>
+#include <net/dst_metadata.h>
 #include <net/tcp_states.h> /* for TCP_TIME_WAIT */
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
@@ -274,11 +275,12 @@ static bool nft_meta_get_eval_ifname(enum nft_meta_keys key, u32 *dest,
 static noinline bool
 nft_meta_get_eval_rtclassid(const struct sk_buff *skb, u32 *dest)
 {
-	const struct dst_entry *dst = skb_dst(skb);
+	const struct dst_entry *dst;
 
-	if (!dst)
+	if (!skb_valid_dst(skb))
 		return false;
 
+	dst = skb_dst(skb);
 	*dest = dst->tclassid;
 	return true;
 }
diff --git a/net/netfilter/nft_rt.c b/net/netfilter/nft_rt.c
index 700656565b656..6b0e7528cd1a4 100644
--- a/net/netfilter/nft_rt.c
+++ b/net/netfilter/nft_rt.c
@@ -8,6 +8,7 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/dst.h>
+#include <net/dst_metadata.h>
 #include <net/ip6_route.h>
 #include <net/route.h>
 #include <net/netfilter/nf_tables.h>
@@ -59,10 +60,11 @@ void nft_rt_get_eval(const struct nft_expr *expr,
 	u32 *dest = &regs->data[priv->dreg];
 	const struct dst_entry *dst;
 
-	dst = skb_dst(skb);
-	if (!dst)
+	if (!skb_valid_dst(skb))
 		goto err;
 
+	dst = skb_dst(skb);
+
 	switch (priv->key) {
 #ifdef CONFIG_IP_ROUTE_CLASSID
 	case NFT_RT_CLASSID:
diff --git a/net/netfilter/nft_xfrm.c b/net/netfilter/nft_xfrm.c
index 81cbe8408c83c..924d6bd389843 100644
--- a/net/netfilter/nft_xfrm.c
+++ b/net/netfilter/nft_xfrm.c
@@ -12,6 +12,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_tables.h>
+#include <net/dst_metadata.h>
 #include <linux/in.h>
 #include <net/xfrm.h>
 
@@ -176,9 +177,15 @@ static void nft_xfrm_get_eval_out(const struct nft_xfrm *priv,
 				  struct nft_regs *regs,
 				  const struct nft_pktinfo *pkt)
 {
-	const struct dst_entry *dst = skb_dst(pkt->skb);
+	const struct dst_entry *dst;
 	int i;
 
+	if (!skb_valid_dst(pkt->skb)) {
+		regs->verdict.code = NFT_BREAK;
+		return;
+	}
+
+	dst = skb_dst(pkt->skb);
 	for (i = 0; dst && dst->xfrm;
 	     dst = ((const struct xfrm_dst *)dst)->child, i++) {
 		if (i < priv->spnum)
-- 
2.53.0



