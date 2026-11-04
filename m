Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831619;
	b=XXYac0nB8UWXoT26H16WJCa+gey5Pi0Tu54Pxl/hRmTD3oBZDS9M4zgVHe5qoL5hYsr4
	 YEt5fNowvV793/KQBNNsIlCcKsP3Vj37fuJBkXH7O3W37uHb8B4MCYRL9QGQE+5t7r/6y
	 pSBr8ATcf/EH9zlxniGvHmw4+59h6pC1w7LWcRcucCiQ0yO5r1A0xRJGybmW4E9IL/6oj
	 0AiVZ3638W+6W7SNdOCIaWPC2S0ka+qPGSMP7gtWTCeUsuowpN1fClXIFMxIOCOK7FUMh
	 9G4Y5HvQ6RBIVlJgJlepXCcR3VxFXovz8pSpzqlzVbsyaA3xjhN2fzj/yW0LMKyTxzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831619;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F8FKFY81/g7BVFW8PW0Qz6JJYxHgr47TxO+mqTZpoLo=;
	b=Gt6RmjVulY/pm7m13whtRuT3mRZAxC2GFFDQC93L+y6nrINJZEYXlVgM8LPmAFVjnqZ7
	 FL378ndsT4bbTAN1YPWbb7omPzYqNHzNbLJv9GAF4EWc6PNHlDrYsio1lrB3UysCWwTqZ
	 GecPO1xMhQ1cGE3ueiuxADHAxtXPCEdLMXAWkWe1ZLv5fIQUNsmcSjTmv+qtM/pcfyS4b
	 sjx0xs1rj5MNlqKtIbjSHfai+DZUcpmfMTVwsv6/vk3kuuRiPudyW5hNScdpADFds5C5T
	 B6WXmbCJ6kdUPBLd1SVRCwmNLr4ZwLE9T92aTm4j9Tzm8d1EpbGuysbnsiHzf+NWoNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mNywCRxY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98342606A326;
	Wed,  4 Nov 2026 22:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mNywCRxY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336821F0093A;
	Wed,  4 Nov 2026 22:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831619;
	bh=F8FKFY81/g7BVFW8PW0Qz6JJYxHgr47TxO+mqTZpoLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mNywCRxY3Gm5DX55+WJ1zCNunHIllSwr/6dC5TTTdj7fUjALCtuJ0jKa/CRaLzfSA
	 iGszTKR2smFU7aI55fCzNC4quPrkPVnuKhMf3TQqXuRMOmnjpcfQmYYVCoUQWJyK5s
	 +Dc75VWgCExEugMBrkF4Ta89OayepCwLoRBaQzHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0815/1005] netfilter: nftables: restrict linklayer and network header writes
Date: Wed,  4 Nov 2026 16:09:08 -0500
Message-ID: <20261104211106.174754799@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit df07998dfd40796a05fff7ffea2661ad65ed42a7 ]

Don't permit arbitrary writes to linklayer and network header data.
Several spots in network stack trust header validation performed in
ipv4/ipv6 before PRE_ROUTING hook.

For linklayer, allow writes for netdev ingress. For other hooks, only
allow link layer writes that do not spill into network header.

For network header, check the offset/length combinations:
 - changing dscp requires store at offset 0 for checsum fixups, so
 make sure ip version + length field isn't altered.
 - ip6 dscp starts directly after the version field, so make sure it
   remains 6.

Several of these checks could already be done at rule insertion time.
Risk is that this might cause ruleset load failures for existing
rulesets. With this change such writes are silently skipped and packet
passes unchanged.

Transport and inner header bases are not checked / restricted.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_payload.c | 170 ++++++++++++++++++++++++++++++++++++
 1 file changed, 170 insertions(+)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 125650be78436..2562af7b879ab 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -824,6 +824,172 @@ nft_payload_set_vlan(const u32 *src, struct sk_buff *skb, u16 offset, u8 len,
 	return true;
 }
 
+/* Ingress is very early, before l3 protocol handlers.
+ * There should be no in-tree code that trusts l3/l4 headers
+ * between ingress and NF_INET_PRE_ROUTING hooks.
+ */
+static bool nft_in_ingress(const struct nf_hook_state *s)
+{
+	return s->pf == NFPROTO_NETDEV && s->hook == NF_NETDEV_INGRESS;
+}
+
+static bool nft_nh_write_ok_ip4(const struct nft_pktinfo *pkt,
+				const struct nft_payload_set *priv,
+				const u32 *src)
+{
+	unsigned int offset = priv->offset + skb_network_offset(pkt->skb);
+	const u8 *new_octets = (const u8 *)src;
+	u8 old_octet;
+
+	switch (priv->offset) {
+	case 0: /* csum fixups does expand dscp/tos store to 2 bytes.
+		 * make sure ihl/version remain unchanged.
+		 */
+		if (skb_copy_bits(pkt->skb, offset, &old_octet, sizeof(old_octet)))
+			return false;
+
+		return priv->len == 2 &&
+		       *new_octets == old_octet;
+	case offsetof(struct iphdr, tos):
+		return priv->len == 1;
+	case offsetof(struct iphdr, id):
+		return priv->len == 2;
+	case offsetof(struct iphdr, ttl):
+		if (priv->len == 1)
+			return true;
+
+		if (priv->len != 2)
+			return false;
+
+		/* same, csum fixup does expand ttl store to two bytes.
+		 * check protocol is not altered.
+		 */
+		if (skb_copy_bits(pkt->skb, offset + 1, &old_octet, sizeof(old_octet)))
+			return false;
+
+		return new_octets[1] == old_octet;
+	case offsetof(struct iphdr, check):
+		return priv->len <= 2 + 4 + 4;
+	case offsetof(struct iphdr, saddr):
+		return priv->len <= 4 + 4;
+	case offsetof(struct iphdr, daddr):
+		return priv->len <= 4;
+	}
+
+	return false;
+}
+
+static bool nft_nh_write_ok_ip6(const struct nft_pktinfo *pkt,
+				const struct nft_payload_set *priv,
+				const u32 *src)
+{
+	const struct ipv6hdr *ih = (const void *)src;
+
+	switch (priv->offset) {
+	case 0: /* store to dscp must not alter ip6 version */
+		return priv->len <= 4 && ih->version == 6;
+	case 2:
+		return priv->len <= 2;
+	case offsetof(struct ipv6hdr, hop_limit):
+		return priv->len == 1;
+	case offsetof(struct ipv6hdr, saddr):
+		return priv->len <= 16 + 16;
+	case offsetof(struct ipv6hdr, daddr):
+		return priv->len <= 16;
+	}
+
+	return false;
+}
+
+static bool nft_nh_write_ok_arp(const struct nft_payload_set *priv)
+{
+	/* Variable size for standard ethernet arp */
+	const unsigned int eth_ip = 2 * (ETH_ALEN + 4);
+	unsigned int offset = priv->offset;
+
+	switch (offset) {
+	case offsetof(struct arphdr, ar_op):
+		return priv->len == 2;
+	default:
+		break;
+	}
+
+	/* permit writes post fixed arp header size. offset + len are
+	 * checked vs skb size via skb_ensure_writable.
+	 */
+	return offset >= sizeof(struct arphdr) && priv->len <= eth_ip;
+}
+
+static bool nft_nh_write_ok_netdev(const struct nft_pktinfo *pkt,
+				   const struct nft_payload_set *priv,
+				   const u32 *src)
+{
+#ifdef CONFIG_NF_TABLES_NETDEV
+	switch (pkt->skb->protocol) {
+	case htons(ETH_P_ARP):
+		return nft_nh_write_ok_arp(priv);
+	case htons(ETH_P_IP):
+		return nft_nh_write_ok_ip4(pkt, priv, src);
+	case htons(ETH_P_IPV6):
+		return nft_nh_write_ok_ip6(pkt, priv, src);
+	}
+#endif
+	/* default to false for now, relax later in case we have
+	 * use-cases that need inner header manipulation for
+	 * encapsulated traffic like vlan or PPPoE.
+	 */
+	return false;
+}
+
+static bool nft_nh_write_ok_bridge(const struct nft_pktinfo *pkt,
+				   const struct nft_payload_set *priv,
+				   const u32 *src)
+{
+#if IS_ENABLED(CONFIG_NF_TABLES_BRIDGE)
+	switch (pkt->ethertype) {
+	case htons(ETH_P_ARP):
+		return nft_nh_write_ok_arp(priv);
+	case htons(ETH_P_IP):
+		return nft_nh_write_ok_ip4(pkt, priv, src);
+	case htons(ETH_P_IPV6):
+		return nft_nh_write_ok_ip6(pkt, priv, src);
+	}
+#endif
+	/* see nft_nh_write_ok_netdev: default to false */
+	return false;
+}
+
+static bool nft_nh_write_ok(const struct nft_pktinfo *pkt,
+			    const struct nft_payload_set *priv,
+			    const u32 *src)
+{
+	switch (pkt->state->pf) {
+	case NFPROTO_ARP:
+		return nft_nh_write_ok_arp(priv);
+	case NFPROTO_BRIDGE:
+		return nft_nh_write_ok_bridge(pkt, priv, src);
+	case NFPROTO_IPV4:
+		return nft_nh_write_ok_ip4(pkt, priv, src);
+	case NFPROTO_IPV6:
+		return nft_nh_write_ok_ip6(pkt, priv, src);
+	case NFPROTO_NETDEV:
+		if (pkt->state->hook == NF_NETDEV_INGRESS)
+			return true;
+		return nft_nh_write_ok_netdev(pkt, priv, src);
+	}
+
+	return false;
+}
+
+/* check linklayer modifications don't spill into network header. */
+static bool nft_ll_write_ok(const struct nft_pktinfo *pkt, int offset)
+{
+	if (nft_in_ingress(pkt->state))
+		return true;
+
+	return offset <= skb_network_offset(pkt->skb);
+}
+
 static void nft_payload_set_eval(const struct nft_expr *expr,
 				 struct nft_regs *regs,
 				 const struct nft_pktinfo *pkt)
@@ -851,8 +1017,12 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 		}
 
 		offset = skb_mac_header(skb) - skb->data - vlan_hlen;
+		if (!nft_ll_write_ok(pkt, priv->len + priv->offset + offset))
+			goto err;
 		break;
 	case NFT_PAYLOAD_NETWORK_HEADER:
+		if (!nft_nh_write_ok(pkt, priv, src))
+			goto err;
 		offset = skb_network_offset(skb);
 		break;
 	case NFT_PAYLOAD_TRANSPORT_HEADER:
-- 
2.53.0



