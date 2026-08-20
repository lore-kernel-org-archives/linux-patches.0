Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A72A35DA68;
	Thu, 20 Aug 2026 17:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248118; cv=none; b=urIK7qdShgsYby6loztdp8POg+1X5RqZO+wVBuBskEDEDekZjC3eaQ9L2sjJNarZnm0TR6yUZc2TxCmvcwgharMKBfDSkLdyDsDduK1w5arfjxvQcR2d/h4VTZsvjTXfQ80sR9oxd+fnjsSv4gYyu00xfcZGcSWHgj6JaONFNCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248118; c=relaxed/simple;
	bh=WP0+8/vpnw9Vt22YRYHqFpSo4LHzwCxcgE7K7vVeC5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qIddy9r3KS75j8Fz61uWkMfWhtl5rWVdIDnAPCkLspjC2w+JnRV3J3vV3wNxGD7/55JDAjsxRjDnteG4z98c29QU5vV9GOh9jhNf2tgpkTI5Zcs3OrpvKBrMz3QeETgwVwoxy7iqSiHqLgTLIZMl4HPzU91Vdd21iz8jfOpKtoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hezU48Qw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hezU48Qw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5AF91F000E9;
	Thu, 20 Aug 2026 17:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248117;
	bh=BZcFGQQwgAGxPAKsgnHdnKoKxctgdRsRMrDtAy/E/ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hezU48Qw7kEFD5L1wy7vubTQ+WgABpORCJii3ahpl56HGQymkMB4IxOqvRg7dihlL
	 858tzMcGPQblZytV2CEK1pcE1UeUloFM8xTaEhBVNO1DcOeUtCfMl9w2un3QoATAFH
	 YJjwWjCG7RUiEqMpwXbN3DFnzCRDt4LSo0o+igdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Sowden <jeremy@azazel.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 117/303] netfilter: bitwise: rename some boolean operation functions
Date: Thu, 20 Aug 2026 16:54:13 +0200
Message-ID: <20260820145256.794654785@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeremy Sowden <jeremy@azazel.net>

[ Upstream commit a12143e6084c502fc3cfaa8b717bffc8c14cf806 ]

In the next patch we add support for doing AND, OR and XOR operations
directly in the kernel, so rename some functions and an enum constant
related to mask-and-xor boolean operations.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: d07955dd34ec ("netfilter: nft_fib: reject fib expression on the netdev egress hook")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/netfilter/nf_tables.h |   10 ++++++---
 net/netfilter/nft_bitwise.c              |   34 +++++++++++++++----------------
 2 files changed, 24 insertions(+), 20 deletions(-)

--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -541,16 +541,20 @@ enum nft_immediate_attributes {
 /**
  * enum nft_bitwise_ops - nf_tables bitwise operations
  *
- * @NFT_BITWISE_BOOL: mask-and-xor operation used to implement NOT, AND, OR and
- *                    XOR boolean operations
+ * @NFT_BITWISE_MASK_XOR: mask-and-xor operation used to implement NOT, AND, OR
+ *                        and XOR boolean operations
  * @NFT_BITWISE_LSHIFT: left-shift operation
  * @NFT_BITWISE_RSHIFT: right-shift operation
  */
 enum nft_bitwise_ops {
-	NFT_BITWISE_BOOL,
+	NFT_BITWISE_MASK_XOR,
 	NFT_BITWISE_LSHIFT,
 	NFT_BITWISE_RSHIFT,
 };
+/*
+ * Old name for NFT_BITWISE_MASK_XOR.  Retained for backwards-compatibility.
+ */
+#define NFT_BITWISE_BOOL NFT_BITWISE_MASK_XOR
 
 /**
  * enum nft_bitwise_attributes - nf_tables bitwise expression netlink attributes
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -25,8 +25,8 @@ struct nft_bitwise {
 	struct nft_data		data;
 };
 
-static void nft_bitwise_eval_bool(u32 *dst, const u32 *src,
-				  const struct nft_bitwise *priv)
+static void nft_bitwise_eval_mask_xor(u32 *dst, const u32 *src,
+				      const struct nft_bitwise *priv)
 {
 	unsigned int i;
 
@@ -68,8 +68,8 @@ void nft_bitwise_eval(const struct nft_e
 	u32 *dst = &regs->data[priv->dreg];
 
 	switch (priv->op) {
-	case NFT_BITWISE_BOOL:
-		nft_bitwise_eval_bool(dst, src, priv);
+	case NFT_BITWISE_MASK_XOR:
+		nft_bitwise_eval_mask_xor(dst, src, priv);
 		break;
 	case NFT_BITWISE_LSHIFT:
 		nft_bitwise_eval_lshift(dst, src, priv);
@@ -90,8 +90,8 @@ static const struct nla_policy nft_bitwi
 	[NFTA_BITWISE_DATA]	= { .type = NLA_NESTED },
 };
 
-static int nft_bitwise_init_bool(struct nft_bitwise *priv,
-				 const struct nlattr *const tb[])
+static int nft_bitwise_init_mask_xor(struct nft_bitwise *priv,
+				     const struct nlattr *const tb[])
 {
 	struct nft_data_desc mask = {
 		.type	= NFT_DATA_VALUE,
@@ -186,7 +186,7 @@ static int nft_bitwise_init(const struct
 	if (tb[NFTA_BITWISE_OP]) {
 		priv->op = ntohl(nla_get_be32(tb[NFTA_BITWISE_OP]));
 		switch (priv->op) {
-		case NFT_BITWISE_BOOL:
+		case NFT_BITWISE_MASK_XOR:
 		case NFT_BITWISE_LSHIFT:
 		case NFT_BITWISE_RSHIFT:
 			break;
@@ -194,12 +194,12 @@ static int nft_bitwise_init(const struct
 			return -EOPNOTSUPP;
 		}
 	} else {
-		priv->op = NFT_BITWISE_BOOL;
+		priv->op = NFT_BITWISE_MASK_XOR;
 	}
 
 	switch(priv->op) {
-	case NFT_BITWISE_BOOL:
-		err = nft_bitwise_init_bool(priv, tb);
+	case NFT_BITWISE_MASK_XOR:
+		err = nft_bitwise_init_mask_xor(priv, tb);
 		break;
 	case NFT_BITWISE_LSHIFT:
 	case NFT_BITWISE_RSHIFT:
@@ -210,8 +210,8 @@ static int nft_bitwise_init(const struct
 	return err;
 }
 
-static int nft_bitwise_dump_bool(struct sk_buff *skb,
-				 const struct nft_bitwise *priv)
+static int nft_bitwise_dump_mask_xor(struct sk_buff *skb,
+				     const struct nft_bitwise *priv)
 {
 	if (nft_data_dump(skb, NFTA_BITWISE_MASK, &priv->mask,
 			  NFT_DATA_VALUE, priv->len) < 0)
@@ -248,8 +248,8 @@ static int nft_bitwise_dump(struct sk_bu
 		return -1;
 
 	switch (priv->op) {
-	case NFT_BITWISE_BOOL:
-		err = nft_bitwise_dump_bool(skb, priv);
+	case NFT_BITWISE_MASK_XOR:
+		err = nft_bitwise_dump_mask_xor(skb, priv);
 		break;
 	case NFT_BITWISE_LSHIFT:
 	case NFT_BITWISE_RSHIFT:
@@ -269,7 +269,7 @@ static int nft_bitwise_offload(struct nf
 	const struct nft_bitwise *priv = nft_expr_priv(expr);
 	struct nft_offload_reg *reg = &ctx->regs[priv->dreg];
 
-	if (priv->op != NFT_BITWISE_BOOL)
+	if (priv->op != NFT_BITWISE_MASK_XOR)
 		return -EOPNOTSUPP;
 
 	if (memcmp(&priv->xor, &zero, sizeof(priv->xor)) ||
@@ -405,7 +405,7 @@ nft_bitwise_fast_dump(struct sk_buff *sk
 		return -1;
 	if (nla_put_be32(skb, NFTA_BITWISE_LEN, htonl(sizeof(u32))))
 		return -1;
-	if (nla_put_be32(skb, NFTA_BITWISE_OP, htonl(NFT_BITWISE_BOOL)))
+	if (nla_put_be32(skb, NFTA_BITWISE_OP, htonl(NFT_BITWISE_MASK_XOR)))
 		return -1;
 
 	data.data[0] = priv->mask;
@@ -500,7 +500,7 @@ nft_bitwise_select_ops(const struct nft_
 		return &nft_bitwise_ops;
 
 	if (tb[NFTA_BITWISE_OP] &&
-	    ntohl(nla_get_be32(tb[NFTA_BITWISE_OP])) != NFT_BITWISE_BOOL)
+	    ntohl(nla_get_be32(tb[NFTA_BITWISE_OP])) != NFT_BITWISE_MASK_XOR)
 		return &nft_bitwise_ops;
 
 	return &nft_bitwise_fast_ops;


