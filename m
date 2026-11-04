Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831618;
	b=FGm2kYtu4aXPYEZLPSSKWgWPUVejl9jBGvInQ7qLMooMi6y3l57tNAA5EitsBXtkuvxe
	 cTYESwJe3fF4wFSD4NsJ4PCslS+xr80keYN3M4n70TZ40xVC+bqAC8KsDfiCNg5QjNCNB
	 VXAuJikHM017ZSR1OCyr4Tso3tNL766/RZp6xAgCmT2bDmnWopIC2NpKX0f3F1XHrkpfd
	 s1XqAevWcbJb09TnMm7v+sqEmb8QMkwgh/zt6EaQi+r+uWDtAD7dGrbWc8l+Y1gtPsOtp
	 +gSmRVUUgvi2f5tH7U++bVygtUYnsPKjoKocFZRxS71ST7oPyOOuglmAuXn9wOfgaQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831618;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z3LdxjZhmkNsrSRy0AJ3mG+88RR95BvAhy1XkvwNywQ=;
	b=gJo7dlz8dqDNOM3Bq+n60LI3+yHe7vV/j5iQamius8Q310v9yePiiQzQP4AZ0UGjtnOr
	 AOyvL7h3Q7EaYWnc5sdw2avPVBx4QkaUElB50iwXcu++PCSp5wjUcSb2vvp/UIE1PfzZN
	 kEk8RTpDKpLmI9z1nm+oW6DJHKC27VVRN52S/9mp6jumPuDJ/CFvHcpy0Fmal91zwUkl2
	 /Ii/JDjMgRRNwTZohCUJyVIQTo8nGmFEY6xDSBtqid1bpZ0QcK/29t+96wuuB0SWuzGLy
	 JN45PL+ppXl6mEXbUQ9Ye37cjKnLUV1/dazH4X9ARv2rRhHj1d8BoE+Vsh//oUFAWcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=afY0UMnn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603DF606A326;
	Wed,  4 Nov 2026 22:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=afY0UMnn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50D91F0093A;
	Wed,  4 Nov 2026 22:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831617;
	bh=z3LdxjZhmkNsrSRy0AJ3mG+88RR95BvAhy1XkvwNywQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=afY0UMnnp780UC3+vehZoc2U7G/Z2zvKoEQK7nlSPmK8MUFCwBUJ9/DZZpxPGlw1C
	 A+XUrZX4TMNgcJgUgEvkjS7SN/m5GF70DOAXpWQPALxyww0m5uwL90uaM64mLmPiSN
	 7UUj5BBb6bwjs0IW7fGyh+mENYMAM2ZF6G/r9XR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0814/1005] netfilter: nft_meta: add double-tagged vlan and pppoe support
Date: Wed,  4 Nov 2026 16:09:07 -0500
Message-ID: <20261104211106.148895059@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 3785091c6c16a1ce4a5e0460881fc81ed8d2c8a1 ]

Currently:

  add rule netdev x y ip saddr 1.1.1.1

does not work with neither double-tagged vlan nor pppoe packets. This is
because the network and transport header offset are not pointing to the
IP and transport protocol headers in the stack.

This patch expands NFT_META_PROTOCOL and NFT_META_L4PROTO to parse
double-tagged vlan and pppoe packets so matching network and transport
header fields becomes possible with the existing userspace generated
bytecode. Note that this parser only supports double-tagged vlan which
is composed of vlan offload + vlan header in the skb payload area for
simplicity.

NFT_META_PROTOCOL is used by bridge and netdev family as an implicit
dependency in the bytecode to match on network header fields.
Similarly, there is also NFT_META_L4PROTO, which is also used as an
implicit dependency when matching on the transport protocol header
fields.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h      |  4 ++
 include/net/netfilter/nf_tables_ipv4.h | 17 +++++---
 include/net/netfilter/nf_tables_ipv6.h | 16 +++++---
 net/netfilter/nf_tables_core.c         |  2 +-
 net/netfilter/nft_meta.c               | 54 +++++++++++++++++++++++++-
 net/netfilter/nft_payload.c            |  2 +-
 6 files changed, 82 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 4c691d5e4ae9b..ac04b4eb17d78 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -32,7 +32,9 @@ struct nft_pktinfo {
 	const struct nf_hook_state	*state;
 	u8				flags;
 	u8				tprot;
+	__be16				ethertype;
 	u16				fragoff;
+	u16				nhoff;
 	u16				thoff;
 	u16				inneroff;
 };
@@ -84,6 +86,8 @@ static inline void nft_set_pktinfo_unspec(struct nft_pktinfo *pkt)
 {
 	pkt->flags = 0;
 	pkt->tprot = 0;
+	pkt->ethertype = pkt->skb->protocol;
+	pkt->nhoff = 0;
 	pkt->thoff = 0;
 	pkt->fragoff = 0;
 }
diff --git a/include/net/netfilter/nf_tables_ipv4.h b/include/net/netfilter/nf_tables_ipv4.h
index fcf967286e37c..e715405a73cb9 100644
--- a/include/net/netfilter/nf_tables_ipv4.h
+++ b/include/net/netfilter/nf_tables_ipv4.h
@@ -12,16 +12,19 @@ static inline void nft_set_pktinfo_ipv4(struct nft_pktinfo *pkt)
 	ip = ip_hdr(pkt->skb);
 	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = ip->protocol;
+	pkt->ethertype = pkt->skb->protocol;
+	pkt->nhoff = 0;
 	pkt->thoff = ip_hdrlen(pkt->skb);
 	pkt->fragoff = ntohs(ip->frag_off) & IP_OFFSET;
 }
 
-static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt)
+static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt,
+						  int nhoff)
 {
 	struct iphdr *iph, _iph;
 	u32 len, thoff, skb_len;
 
-	iph = skb_header_pointer(pkt->skb, skb_network_offset(pkt->skb),
+	iph = skb_header_pointer(pkt->skb, skb_network_offset(pkt->skb) + nhoff,
 				 sizeof(*iph), &_iph);
 	if (!iph)
 		return -1;
@@ -31,7 +34,7 @@ static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt)
 
 	len = iph_totlen(pkt->skb, iph);
 	thoff = iph->ihl * 4;
-	skb_len = pkt->skb->len - skb_network_offset(pkt->skb);
+	skb_len = pkt->skb->len - skb_network_offset(pkt->skb) - nhoff;
 
 	if (skb_len < len)
 		return -1;
@@ -42,7 +45,9 @@ static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt)
 
 	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = iph->protocol;
-	pkt->thoff = skb_network_offset(pkt->skb) + thoff;
+	pkt->ethertype = pkt->skb->protocol;
+	pkt->nhoff = nhoff;
+	pkt->thoff = skb_network_offset(pkt->skb) + nhoff + thoff;
 	pkt->fragoff = ntohs(iph->frag_off) & IP_OFFSET;
 
 	return 0;
@@ -50,7 +55,7 @@ static inline int __nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt)
 
 static inline void nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt)
 {
-	if (__nft_set_pktinfo_ipv4_validate(pkt) < 0)
+	if (__nft_set_pktinfo_ipv4_validate(pkt, 0) < 0)
 		nft_set_pktinfo_unspec(pkt);
 }
 
@@ -78,6 +83,8 @@ static inline int nft_set_pktinfo_ipv4_ingress(struct nft_pktinfo *pkt)
 	}
 
 	pkt->flags = NFT_PKTINFO_L4PROTO;
+	pkt->ethertype = pkt->skb->protocol;
+	pkt->nhoff = 0;
 	pkt->tprot = iph->protocol;
 	pkt->thoff = thoff;
 	pkt->fragoff = ntohs(iph->frag_off) & IP_OFFSET;
diff --git a/include/net/netfilter/nf_tables_ipv6.h b/include/net/netfilter/nf_tables_ipv6.h
index c53ac00bb974d..d7b8c559b795b 100644
--- a/include/net/netfilter/nf_tables_ipv6.h
+++ b/include/net/netfilter/nf_tables_ipv6.h
@@ -20,21 +20,23 @@ static inline void nft_set_pktinfo_ipv6(struct nft_pktinfo *pkt)
 
 	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = protohdr;
+	pkt->ethertype = pkt->skb->protocol;
+	pkt->nhoff = 0;
 	pkt->thoff = thoff;
 	pkt->fragoff = frag_off;
 }
 
-static inline int __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt)
+static inline int __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt, int nhoff)
 {
 #if IS_ENABLED(CONFIG_IPV6)
 	unsigned int flags = IP6_FH_F_AUTH;
 	struct ipv6hdr *ip6h, _ip6h;
-	unsigned int thoff = 0;
+	unsigned int thoff = nhoff;
 	unsigned short frag_off;
 	u32 pkt_len, skb_len;
 	int protohdr;
 
-	ip6h = skb_header_pointer(pkt->skb, skb_network_offset(pkt->skb),
+	ip6h = skb_header_pointer(pkt->skb, skb_network_offset(pkt->skb) + nhoff,
 				  sizeof(*ip6h), &_ip6h);
 	if (!ip6h)
 		return -1;
@@ -43,7 +45,7 @@ static inline int __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt)
 		return -1;
 
 	pkt_len = ipv6_payload_len(pkt->skb, ip6h);
-	skb_len = pkt->skb->len - skb_network_offset(pkt->skb);
+	skb_len = pkt->skb->len - skb_network_offset(pkt->skb) - nhoff;
 	if (pkt_len + sizeof(*ip6h) > skb_len)
 		return -1;
 
@@ -53,6 +55,8 @@ static inline int __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt)
 
 	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = protohdr;
+	pkt->ethertype = pkt->skb->protocol;
+	pkt->nhoff = nhoff;
 	pkt->thoff = thoff;
 	pkt->fragoff = frag_off;
 
@@ -64,7 +68,7 @@ static inline int __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt)
 
 static inline void nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt)
 {
-	if (__nft_set_pktinfo_ipv6_validate(pkt) < 0)
+	if (__nft_set_pktinfo_ipv6_validate(pkt, 0) < 0)
 		nft_set_pktinfo_unspec(pkt);
 }
 
@@ -99,6 +103,8 @@ static inline int nft_set_pktinfo_ipv6_ingress(struct nft_pktinfo *pkt)
 
 	pkt->flags = NFT_PKTINFO_L4PROTO;
 	pkt->tprot = protohdr;
+	pkt->ethertype = pkt->skb->protocol;
+	pkt->nhoff = 0;
 	pkt->thoff = thoff;
 	pkt->fragoff = frag_off;
 
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 6557a4018c099..5ddd5b6e135f1 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -151,7 +151,7 @@ static bool nft_payload_fast_eval(const struct nft_expr *expr,
 	unsigned char *ptr;
 
 	if (priv->base == NFT_PAYLOAD_NETWORK_HEADER)
-		ptr = skb_network_header(skb);
+		ptr = skb_network_header(skb) + pkt->nhoff;
 	else {
 		if (!(pkt->flags & NFT_PKTINFO_L4PROTO))
 			return false;
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index f3c7b7edb10c0..a6e83279d0b6b 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -24,6 +24,8 @@
 #include <net/tcp_states.h> /* for TCP_TIME_WAIT */
 #include <net/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables_core.h>
+#include <net/netfilter/nf_tables_ipv4.h>
+#include <net/netfilter/nf_tables_ipv6.h>
 #include <net/netfilter/nft_meta.h>
 #include <net/netfilter/nf_tables_offload.h>
 
@@ -308,6 +310,54 @@ nft_meta_get_eval_sdifname(u32 *dest, const struct nft_pktinfo *pkt)
 	nft_meta_store_ifname(dest, dev);
 }
 
+static void nft_meta_pktinfo_may_update(struct nft_pktinfo *pkt)
+{
+	struct sk_buff *skb = pkt->skb;
+	struct vlan_ethhdr *veth;
+	__be16 ethertype;
+	int nhoff;
+
+	/* Is this an IP packet? Then, skip. */
+	if (pkt->flags)
+		return;
+
+	/* ... else maybe an IP packet over PPPoE or Q-in-Q? */
+	switch (skb->protocol) {
+	case htons(ETH_P_8021Q):
+		if (!pskb_may_pull(skb, skb_mac_offset(skb) + sizeof(*veth)))
+			return;
+
+		veth = (struct vlan_ethhdr *)skb_mac_header(skb);
+		nhoff = VLAN_HLEN;
+		ethertype = veth->h_vlan_encapsulated_proto;
+		break;
+	case htons(ETH_P_PPP_SES):
+		if (!nf_flow_pppoe_proto(skb, &ethertype))
+			return;
+
+		nhoff = PPPOE_SES_HLEN;
+		break;
+	default:
+		return;
+	}
+
+	nhoff += skb_network_offset(skb);
+	switch (ethertype) {
+	case htons(ETH_P_IP):
+		if (__nft_set_pktinfo_ipv4_validate(pkt, nhoff))
+			nft_set_pktinfo_unspec(pkt);
+		break;
+	case htons(ETH_P_IPV6):
+		if (__nft_set_pktinfo_ipv6_validate(pkt, nhoff))
+			nft_set_pktinfo_unspec(pkt);
+		break;
+	default:
+		break;
+	}
+
+	pkt->ethertype = ethertype;
+}
+
 void nft_meta_get_eval(const struct nft_expr *expr,
 		       struct nft_regs *regs,
 		       const struct nft_pktinfo *pkt)
@@ -321,12 +371,14 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		*dest = skb->len;
 		break;
 	case NFT_META_PROTOCOL:
-		nft_reg_store16(dest, (__force u16)skb->protocol);
+		nft_meta_pktinfo_may_update((struct nft_pktinfo *)pkt);
+		nft_reg_store16(dest, (__force u16)pkt->ethertype);
 		break;
 	case NFT_META_NFPROTO:
 		nft_reg_store8(dest, nft_pf(pkt));
 		break;
 	case NFT_META_L4PROTO:
+		nft_meta_pktinfo_may_update((struct nft_pktinfo *)pkt);
 		if (!(pkt->flags & NFT_PKTINFO_L4PROTO))
 			goto err;
 		nft_reg_store8(dest, pkt->tprot);
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 4034d61e2a135..125650be78436 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -183,7 +183,7 @@ void nft_payload_eval(const struct nft_expr *expr,
 		offset = skb_mac_header(skb) - skb->data;
 		break;
 	case NFT_PAYLOAD_NETWORK_HEADER:
-		offset = skb_network_offset(skb);
+		offset = skb_network_offset(skb) + pkt->nhoff;
 		break;
 	case NFT_PAYLOAD_TRANSPORT_HEADER:
 		if (!(pkt->flags & NFT_PKTINFO_L4PROTO) || pkt->fragoff)
-- 
2.53.0



