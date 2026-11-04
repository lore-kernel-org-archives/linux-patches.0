Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831623;
	b=v4qsWgdTVJt1A6rTet29HpUOBoE1TBD2yqfmXEHOxbat3M750Ff8pWjNRv24gXfLfqXj
	 C0VTvKcn8gFQn9ucjhVu6zMPqtJoTY7RFpPJTS7VyI6+JGioyIZWF+EI4GQWU+36tdTzZ
	 1jlVnWQzgsoW8Y9WSUJlMDBYTZ4zuzneOGBLz9ISilrAxjYxD3qbmKCcJvELOIbetGTQt
	 aiWPKtVydXuCBPvIYgUWb95rU49mL5tmIz3btajBGciE/Sbws75kwTENHjs5BxlnVGEEB
	 SMvoUeEUHmPi9gv4P7R8TBZQ6CA/zwHBNr188/i4g4l8j3lzQq0Z+pbbvAvmavrBC5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831623;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H5hkG3gMTnD+3ULnJvtbTwFcDz1+T+mtINOE1P6fhbU=;
	b=ztmF+VjUSCLyUx3zLaLIiNRFvUKNq2K/Ohp1VM7aujkpJRH//dlJf8XwGhmDTrA3fIoz
	 6PS0S1zzfqATXHfPDOyBtAug0SyCbkgwHZ1mucUm0UkUpX1j843aEItxEneQ8x7X42vfB
	 IrFxXPTei5Yv6s7TiXVBjnGAufvAJVV/QkrhMMbaW7+LonFBgeDF83D8o8yQzy0++IeHG
	 Z93h7xKEa/ndU71V7A6LMra9D4ngLrznI7PZy2IEhwzPNGw2tY306sh07PoFsAm0HUUOz
	 7cof6BbO/cSINdjxaLRR4Sre2U95N3bg4MOoB4tlSY3T7ykU3eQRVvYDvf9h9nAw5Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PS33E75u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76EF606A326;
	Wed,  4 Nov 2026 22:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PS33E75u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D601F0093A;
	Wed,  4 Nov 2026 22:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831622;
	bh=H5hkG3gMTnD+3ULnJvtbTwFcDz1+T+mtINOE1P6fhbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PS33E75ucKw2xoG14XeE5GqwKa3BnKnX9qguC4Ai/VzHiHe85yiffcDBKEQgL1so4
	 5lPpvIZJfXXfw+8Z7jGPT2xLtzuQrK9wlgXusLNHlmEZlmAFta3guVih5Y3gzN3i3z
	 +tzT+H8lOrKs0sIeIMbio+Va+b9NH56MzJ+S9I6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0816/1005] netfilter: nftables: restrict checkum update offset
Date: Wed,  4 Nov 2026 16:09:09 -0500
Message-ID: <20261104211106.201248142@linuxfoundation.org>
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

[ Upstream commit c3716a3c43465641ded6e01c0b187de42e87a80d ]

After previous patch, writes to network header are restricted.
However, there is another way to manipulate the l3 header: The
checksum update function.

Restrict this for network header writes, only the ipv4 header is
allowed.  This needs run-time checks because BRIDGE, INET, NETDEV
families can carry l3 headers other than IP.

checksum updates to the udp/tcp (l4) headers are not restricted.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_payload.c | 100 ++++++++++++++++++++++++++++++++++++
 1 file changed, 100 insertions(+)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 2562af7b879ab..a6f379ecee8a2 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -990,6 +990,83 @@ static bool nft_ll_write_ok(const struct nft_pktinfo *pkt, int offset)
 	return offset <= skb_network_offset(pkt->skb);
 }
 
+static bool nft_payload_validate_inet_csum_offset(const struct nft_ctx *ctx,
+						  const struct nft_payload_set *priv)
+{
+	switch (priv->base) {
+	case NFT_PAYLOAD_LL_HEADER:
+		break;
+	case NFT_PAYLOAD_NETWORK_HEADER:
+		if (ctx->family == NFPROTO_IPV4) {
+			if (offsetof(struct iphdr, check) == priv->csum_offset)
+				return true;
+
+			return false;
+		}
+		return true; /* run time validation required */
+	case NFT_PAYLOAD_TRANSPORT_HEADER:
+		if (priv->csum_flags) /* makes no sense, asks for "re-update" of L4 checksum */
+			return false;
+
+		/* no further check here; offset can't be negative so bogus
+		 * offsets can corrupt L4 or payload but not l3 headers.
+		 * We already allow arbitrary l4/inner payload writes.
+		 */
+		return true;
+	case NFT_PAYLOAD_INNER_HEADER:
+		return true;
+	case NFT_PAYLOAD_TUN_HEADER:
+		break;
+	}
+
+	return false;
+}
+
+/* do not allow arbitrary network header mangling via bogus csum_off.
+ * We only support ipv4.  Only NFPROTO_IPV4 can be checked from control
+ * plane.
+ */
+static bool nft_payload_csum_nh_write_ok(const struct nft_payload_set *priv,
+					 const struct nft_pktinfo *pkt)
+{
+	switch (pkt->state->pf) {
+	case NFPROTO_IPV4:
+		/* Warning: NFPROTO_INET was not checked; we can't return true here. */
+		return priv->csum_offset == offsetof(struct iphdr, check);
+	case NFPROTO_IPV6:
+		return false;
+	case NFPROTO_BRIDGE:
+		return pkt->ethertype == htons(ETH_P_IP) &&
+		       priv->csum_offset == offsetof(struct iphdr, check);
+	case NFPROTO_NETDEV:
+		return pkt->skb->protocol == htons(ETH_P_IP) &&
+		       priv->csum_offset == offsetof(struct iphdr, check);
+	}
+
+	return false;
+}
+
+static bool nft_payload_csum_write_ok(const struct nft_pktinfo *pkt,
+				      const struct nft_payload_set *priv)
+{
+	switch (priv->base) {
+	case NFT_PAYLOAD_LL_HEADER:
+		break;
+	case NFT_PAYLOAD_NETWORK_HEADER:
+		return nft_payload_csum_nh_write_ok(priv, pkt);
+	case NFT_PAYLOAD_TRANSPORT_HEADER:
+	case NFT_PAYLOAD_INNER_HEADER:
+		/* neither offsets are validated, offsets cannot be
+		 * negative so real l3 headers cannot be mangled.
+		 */
+		return true;
+	case NFT_PAYLOAD_TUN_HEADER:
+		break;
+	}
+
+	return false;
+}
+
 static void nft_payload_set_eval(const struct nft_expr *expr,
 				 struct nft_regs *regs,
 				 const struct nft_pktinfo *pkt)
@@ -1054,6 +1131,7 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 		tsum = csum_partial(src, priv->len, 0);
 
 		if (priv->csum_type == NFT_PAYLOAD_CSUM_INET &&
+		    nft_payload_csum_write_ok(pkt, priv) &&
 		    nft_payload_csum_inet(skb, src, fsum, tsum, csum_offset))
 			goto err;
 
@@ -1120,7 +1198,26 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
 
 	switch (csum_type) {
 	case NFT_PAYLOAD_CSUM_NONE:
+		if (priv->csum_offset) /* nonsensical */
+			return -EINVAL;
+
+		if (priv->csum_flags == 0)
+			break;
+
+		/* Userspace requests L4 checksum update, e.g.:
+		 * - IPv6 stateless NAT (no l3 csum)
+		 * - transport header mangling
+		 * - inner data mangling
+		 */
+		if (priv->base == NFT_PAYLOAD_NETWORK_HEADER ||
+		    priv->base == NFT_PAYLOAD_TRANSPORT_HEADER ||
+		    priv->base == NFT_PAYLOAD_INNER_HEADER)
+			break;
+
+		return -EINVAL;
 	case NFT_PAYLOAD_CSUM_INET:
+		if (!nft_payload_validate_inet_csum_offset(ctx, priv))
+			return -EINVAL;
 		break;
 	case NFT_PAYLOAD_CSUM_SCTP:
 		if (priv->base != NFT_PAYLOAD_TRANSPORT_HEADER)
@@ -1128,6 +1225,9 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
 
 		if (priv->csum_offset != offsetof(struct sctphdr, checksum))
 			return -EINVAL;
+
+		if (priv->csum_flags)
+			return -EINVAL;
 		break;
 	default:
 		return -EOPNOTSUPP;
-- 
2.53.0



