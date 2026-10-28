Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212706;
	b=Lcs3CXerQ1MyNx+OAhGIoZSk9wTopbO1rKcZXoN8RZduT1HYzVc0HgVm59ZJcnxX0E2A
	 iNTvZ4GiXvdDi6n+eWZV1noNR/qEzkrPgBWyXjxB18hcXoDKE5NixS5Hc0YjslawVxnqT
	 1WvayjOmp++/bx/ajrHLf4/oT9CUuxK1QAD0M1/nVZSi7F+8yB/HmHrWliH/8Ds8ERqOi
	 OiAiqGHy+vAt4FKaS2AB3CJI3CRAoY1ExJXJwmLF6fRT3djhbjD2r8Kz5T8TllknRUOwY
	 qk5ioF5GehlI0orE6uCTC22+XfVaRNFPp5/HMWlea31kI0ONqiE0aao7/Am9CYlq6eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212706;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KXqDhlin8U+/PXI34rAB5KFv14nNAzAYQ3wDIl8d+gE=;
	b=RjEaNQYaMpdmFJfOcS7+CZEdaPNXYMN1AgqxNqCpmgbwQw8mZ2LjgeNr7etLuJ5QqTUB
	 tRiWemaycsrLBVJEM/8uBUQA10xpzuFR8turk1z/Vp2mgcZ3JPnq/eLDFhZe9myZrfX2i
	 YRkKYh7hWTxi2pkFPZPY4x6q/QLNmh3+KJhTd0Bzpjp6Gflg68EiiDEloRXxeKFrfr4ta
	 doA9uvpYKj9alwCFYYbQ0l2jx75NOw0RVFE+zwrycrHT9FqSbmt8meCCakY4XZdN3kA4Q
	 rfIs4xkbPZ+95EuO+9kpAZnwppudtIn/8i7uBtNu0St1ZsMt+ZZc7Pkq6MdL3ZuI5ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SRdzzkLY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B5B606A31E;
	Wed, 28 Oct 2026 18:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SRdzzkLY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08F91F01825;
	Wed, 28 Oct 2026 18:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212706;
	bh=KXqDhlin8U+/PXI34rAB5KFv14nNAzAYQ3wDIl8d+gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SRdzzkLYXc973JmxxUvQj1VLJfqu0OvMzweN5OfeNionBb+OZU4cjUXri97V7n/yl
	 B1xpSlq+wSzvtxc6LbMm69H5gTNJndDBRWTkwJOjjTS1MXZoePREyJ1cEah6wQYTRx
	 xFg1PkayH0/hS3Am6fhbDIcjtxKE3pKbYIKQfCyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Paasch <cpaasch@apple.com>,
	Willem de Bruijn <willemb@google.com>,
	Florian Westphal <fw@strlen.de>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0246/1887] net: add and use skb_get_hash_net
Date: Wed, 28 Oct 2026 17:39:02 +0100
Message-ID: <20261028170504.828654235@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit b975d3ee5962237c1e2f5d5aeeaaf0dc2173486c ]

Years ago flow dissector gained ability to delegate flow dissection
to a bpf program, scoped per netns.

Unfortunately, skb_get_hash() only gets an sk_buff argument instead
of both net+skb.  This means the flow dissector needs to obtain the
netns pointer from somewhere else.

The netns is derived from skb->dev, and if that is not available, from
skb->sk.  If neither is set, we hit a (benign) WARN_ON_ONCE().

Trying both dev and sk covers most cases, but not all, as recently
reported by Christoph Paasch.

In case of nf-generated tcp reset, both sk and dev are NULL:

WARNING: .. net/core/flow_dissector.c:1104
 skb_flow_dissect_flow_keys include/linux/skbuff.h:1536 [inline]
 skb_get_hash include/linux/skbuff.h:1578 [inline]
 nft_trace_init+0x7d/0x120 net/netfilter/nf_tables_trace.c:320
 nft_do_chain+0xb26/0xb90 net/netfilter/nf_tables_core.c:268
 nft_do_chain_ipv4+0x7a/0xa0 net/netfilter/nft_chain_filter.c:23
 nf_hook_slow+0x57/0x160 net/netfilter/core.c:626
 __ip_local_out+0x21d/0x260 net/ipv4/ip_output.c:118
 ip_local_out+0x26/0x1e0 net/ipv4/ip_output.c:127
 nf_send_reset+0x58c/0x700 net/ipv4/netfilter/nf_reject_ipv4.c:308
 nft_reject_ipv4_eval+0x53/0x90 net/ipv4/netfilter/nft_reject_ipv4.c:30
 [..]

syzkaller did something like this:
table inet filter {
  chain input {
    type filter hook input priority filter; policy accept;
    meta nftrace set 1
    tcp dport 42 reject with tcp reset
   }
   chain output {
    type filter hook output priority filter; policy accept;
    # empty chain is enough
   }
}

... then sends a tcp packet to port 42.

Initial attempt to simply set skb->dev from nf_reject_ipv4 doesn't cover
all cases: skbs generated via ipv4 igmp_send_report trigger similar splat.

Moreover, Pablo Neira found that nft_hash.c uses __skb_get_hash_symmetric()
which would trigger same warn splat for such skbs.

Lets allow callers to pass the current netns explicitly.
The nf_trace infrastructure is adjusted to use the new helper.

__skb_get_hash_symmetric is handled in the next patch.

Reported-by: Christoph Paasch <cpaasch@apple.com>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/494
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240608221057.16070-2-fw@strlen.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8ec454dcd00c ("ipv6: sr: use skb_get_hash_net() in seg6_make_flowlabel()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h          | 12 ++++++++++--
 net/core/flow_dissector.c       | 15 +++++++++++----
 net/netfilter/nf_tables_trace.c |  2 +-
 3 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index c5a2b0f6516c7..2d5cf255cf73a 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1487,7 +1487,7 @@ __skb_set_sw_hash(struct sk_buff *skb, __u32 hash, bool is_l4)
 	__skb_set_hash(skb, hash, true, is_l4);
 }
 
-void __skb_get_hash(struct sk_buff *skb);
+void __skb_get_hash_net(const struct net *net, struct sk_buff *skb);
 u32 __skb_get_hash_symmetric(const struct sk_buff *skb);
 u32 skb_get_poff(const struct sk_buff *skb);
 u32 __skb_get_poff(const struct sk_buff *skb, const void *data,
@@ -1567,10 +1567,18 @@ void skb_flow_dissect_hash(const struct sk_buff *skb,
 			   struct flow_dissector *flow_dissector,
 			   void *target_container);
 
+static inline __u32 skb_get_hash_net(const struct net *net, struct sk_buff *skb)
+{
+	if (!skb->l4_hash && !skb->sw_hash)
+		__skb_get_hash_net(net, skb);
+
+	return skb->hash;
+}
+
 static inline __u32 skb_get_hash(struct sk_buff *skb)
 {
 	if (!skb->l4_hash && !skb->sw_hash)
-		__skb_get_hash(skb);
+		__skb_get_hash_net(NULL, skb);
 
 	return skb->hash;
 }
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index e604c6a08cbd0..12216a5710a92 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1760,7 +1760,8 @@ u32 __skb_get_hash_symmetric(const struct sk_buff *skb)
 EXPORT_SYMBOL_GPL(__skb_get_hash_symmetric);
 
 /**
- * __skb_get_hash: calculate a flow hash
+ * __skb_get_hash_net: calculate a flow hash
+ * @net: associated network namespace, derived from @skb if NULL
  * @skb: sk_buff to calculate flow hash from
  *
  * This function calculates a flow hash based on src/dst addresses
@@ -1768,18 +1769,24 @@ EXPORT_SYMBOL_GPL(__skb_get_hash_symmetric);
  * on success, zero indicates no valid hash.  Also, sets l4_hash in skb
  * if hash is a canonical 4-tuple hash over transport ports.
  */
-void __skb_get_hash(struct sk_buff *skb)
+void __skb_get_hash_net(const struct net *net, struct sk_buff *skb)
 {
 	struct flow_keys keys;
 	u32 hash;
 
+	memset(&keys, 0, sizeof(keys));
+
+	__skb_flow_dissect(net, skb, &flow_keys_dissector,
+			   &keys, NULL, 0, 0, 0,
+			   FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL);
+
 	__flow_hash_secret_init();
 
-	hash = ___skb_get_hash(skb, &keys, &hashrnd);
+	hash = __flow_hash_from_keys(&keys, &hashrnd);
 
 	__skb_set_sw_hash(skb, hash, flow_keys_have_l4(&keys));
 }
-EXPORT_SYMBOL(__skb_get_hash);
+EXPORT_SYMBOL(__skb_get_hash_net);
 
 __u32 skb_get_hash_perturb(const struct sk_buff *skb,
 			   const siphash_key_t *perturb)
diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
index 1163ba9c14011..68916b5297e72 100644
--- a/net/netfilter/nf_tables_trace.c
+++ b/net/netfilter/nf_tables_trace.c
@@ -289,7 +289,7 @@ void nft_trace_init(struct nft_traceinfo *info, const struct nft_pktinfo *pkt,
 	net_get_random_once(&trace_key, sizeof(trace_key));
 
 	info->skbid = (u32)siphash_3u32(hash32_ptr(skb),
-					skb_get_hash(skb),
+					skb_get_hash_net(nft_net(pkt), skb),
 					skb->skb_iif,
 					&trace_key);
 }
-- 
2.53.0



