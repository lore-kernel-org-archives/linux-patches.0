Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831626;
	b=v5Koxg6iOOISeamWBJASHGBVsn9Hv02rtzsCyX69+oqHlF3xoDj+P6GcXEvKt5ENLyhT
	 7K7i4aqMCf1GZldlZr4cHIQjvEANdXQMwZEZ7jSDoqgT0iH5aaQxi6m9iSsneE2Zrq0k+
	 bSKXE2Ap6ja7Lr0PjRxVpj8ttvWk/JX70bUz2H3SZ8nzD+Uef3NCVFSyBDXcJitV2oM5m
	 ItjZGdqSLIjJzMDp9XIuEEZXdDBFuGYT47m+cGhGMLGhMOD1DxJLfvAEu4oMB5/mHDek9
	 N9bSGRbc5JfIGM8S9MTBFSHIOMR5h3YMCk3s8vv/QqF+ZUpk5DdDaq0SrVYe0/Bf9Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831626;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EGhaUigjXkw3v3X+VHMYu8/DZQHp7nrIZTw5CDcfp90=;
	b=0Ry+ZX49Cs0MahE/OtI1Hmah6o5cOKxfdUMpnBJ62vBkQjrS0vOKMgsTd3DHWt/Stz+5
	 neWZxrgYW2SKyyspXS5JJADUbSobvTnd9bxC+TzyO0LrIkyc44d6yXFkKM6jmEcjCQEUe
	 y3pgZdM0n80jace1kaG+0fk5dy4b9YwMfDTs6Pt6tptKXVgpoNprsP4O6rL+hpy7Vp8fj
	 MLW3sarpt8zMwZyKshIZ22ue7ZAU3nOo6Ga+SPkhQtDlOS9mnxIDaw3itcK6RjoimaWFm
	 J39/tfJ7O2xTOovUTkJc3OWAaTIWvBqZUjReF8ASFKXDaHk35m2aQCrErpbu0VJ7Kag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n83+RnyE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2636606A326;
	Wed,  4 Nov 2026 22:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n83+RnyE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709D91F000C1;
	Wed,  4 Nov 2026 22:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831625;
	bh=EGhaUigjXkw3v3X+VHMYu8/DZQHp7nrIZTw5CDcfp90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n83+RnyEMXhfTI/pfK8xqpueSokkO0VN4oEzDX8ILsoev2CoIC5RQyK5kMDqLv0ry
	 9UnJbPH7Ozb3Zdam4xP3lqvb4dn6CbyYxE1tS00FNwt7lQ9T17/1kv+GMJq4ekTXG4
	 NI+nBDQLhxkWU129wcFJz4rJZqRbcnYMurZsJ3UU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0818/1005] netfilter: nft_payload: restrict checksum offsets to known values
Date: Wed,  4 Nov 2026 16:09:11 -0500
Message-ID: <20261104211106.257241774@linuxfoundation.org>
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

[ Upstream commit c2226f0c7fe90b67732e5ae36dc5c3cc01ddf888 ]

We need to prevent userspace from corrupting e.g. tcp->doff, because
many locations in conntrack and conntrack helpers rely on
nf_conntrack_in() having validated the packet headers.
nft_payload allows to alter headers later which invalidates this
assumption.

The 'Fixes' commit restricts writes to safe fields, but there is
another side channel: the checksum location.

Restrict this too.  Reported via sashiko/gemini.

Fixes: 112e447d17f7 ("netfilter: validate L4 headers after userspace packet writes")
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_payload.c | 40 ++++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 592fe48a73f84..7f9561111c8db 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -20,6 +20,7 @@
 #include <linux/tcp.h>
 #include <linux/udp.h>
 #include <net/gre.h>
+#include <linux/icmp.h>
 #include <linux/icmpv6.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
@@ -1008,11 +1009,14 @@ static bool nft_payload_validate_inet_csum_offset(const struct nft_ctx *ctx,
 		if (priv->csum_flags) /* makes no sense, asks for "re-update" of L4 checksum */
 			return false;
 
-		/* no further check here; offset can't be negative so bogus
-		 * offsets can corrupt L4 or payload but not l3 headers.
-		 * We already allow arbitrary l4/inner payload writes.
-		 */
-		return true;
+		/* Validate csum_offset is one of the supported transport header checksums */
+		if (priv->csum_offset == offsetof(struct tcphdr, check) ||
+		    priv->csum_offset == offsetof(struct udphdr, check) ||
+		    priv->csum_offset == offsetof(struct icmphdr, checksum) ||
+		    priv->csum_offset == offsetof(struct icmp6hdr, icmp6_cksum))
+			return true;
+
+		return false;
 	case NFT_PAYLOAD_INNER_HEADER:
 		return true;
 	case NFT_PAYLOAD_TUN_HEADER:
@@ -1046,6 +1050,27 @@ static bool nft_payload_csum_nh_write_ok(const struct nft_payload_set *priv,
 	return false;
 }
 
+static bool nft_payload_csum_th_write_ok(const struct nft_payload_set *priv,
+					 const struct nft_pktinfo *pkt)
+{
+	if (!(pkt->flags & NFT_PKTINFO_L4PROTO))
+		return false;
+
+	switch (pkt->tprot) {
+	case IPPROTO_TCP:
+		return priv->csum_offset == offsetof(struct tcphdr, check);
+	case IPPROTO_UDP:
+	case IPPROTO_UDPLITE:
+		return priv->csum_offset == offsetof(struct udphdr, check);
+	case IPPROTO_ICMPV6:
+		return priv->csum_offset == offsetof(struct icmp6hdr, icmp6_cksum);
+	case IPPROTO_ICMP:
+		return priv->csum_offset == offsetof(struct icmphdr, checksum);
+	}
+
+	return false;
+}
+
 static bool nft_payload_csum_write_ok(const struct nft_pktinfo *pkt,
 				      const struct nft_payload_set *priv)
 {
@@ -1055,9 +1080,10 @@ static bool nft_payload_csum_write_ok(const struct nft_pktinfo *pkt,
 	case NFT_PAYLOAD_NETWORK_HEADER:
 		return nft_payload_csum_nh_write_ok(priv, pkt);
 	case NFT_PAYLOAD_TRANSPORT_HEADER:
+		return nft_payload_csum_th_write_ok(priv, pkt);
 	case NFT_PAYLOAD_INNER_HEADER:
-		/* neither offsets are validated, offsets cannot be
-		 * negative so real l3 headers cannot be mangled.
+		/* offset is not validated, offset cannot be
+		 * negative so real l3/l4 headers cannot be mangled.
 		 */
 		return true;
 	case NFT_PAYLOAD_TUN_HEADER:
-- 
2.53.0



