Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BF743E9FE;
	Thu, 30 Jul 2026 15:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426689; cv=none; b=L81lVd+BBdWRL/ZI4L5KZckNW+fsMn1jKIkIj3WYPf1dVH2J8sLm0Jdr8cUlHOsW1Ah2+wd1jc0TpBg4cFSOmeJnTgQMvkLFxDABirGZoiaZvcaSHNkF+HFUSNpcKi1Z8BM2j4t5qoZ/7Bmc8j0DvRgpaRgGv9/01/0aRzqHSRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426689; c=relaxed/simple;
	bh=44c7jXCoQhR44QiqPqr6LgqfuLbNuSLGFkMirHSbEDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sFYEz4j7wnJL1V+VN3Ns43DgjudjsnG3AEDDs5mgHmK1RXF5lUKZx1BuDqibvnzCdoHGzhPW1CNo3E6lcR6UO8ZJkow7Kd21cOXKTwYl22iYxImkIi3TEkXA+e7+CszpXm2L8yq5w7gj/Mx8t8xBY5VuVMcJbKeC4D52QvLb6yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KlsSwxG7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KlsSwxG7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9100D1F00A3A;
	Thu, 30 Jul 2026 15:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426687;
	bh=EYNu6D/1itFEw14a/73U7sjdBgKc5jzwqsawwz/YNM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KlsSwxG7sKCUduBfKnNq8ti8RKx3Kinvacg41n2cRvPiZvWkTxBX9ZpxIEeeHia9J
	 rp2Ti6CReeXI7EoVgDJLfhLY605HxTAGNAZaHWXQazBPbs6qxykyyrbFanMvrVESYY
	 MUOlCB0or7+zEuq4nccTrJ/VwfFmtfuxVxrn+3FY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Sowden <jeremy@azazel.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 506/602] netfilter: bitwise: rename some boolean operation functions
Date: Thu, 30 Jul 2026 16:14:58 +0200
Message-ID: <20260730141446.620731516@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -564,16 +564,20 @@ enum nft_immediate_attributes {
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
@@ -249,8 +249,8 @@ static int nft_bitwise_dump(struct sk_bu
 		return -1;
 
 	switch (priv->op) {
-	case NFT_BITWISE_BOOL:
-		err = nft_bitwise_dump_bool(skb, priv);
+	case NFT_BITWISE_MASK_XOR:
+		err = nft_bitwise_dump_mask_xor(skb, priv);
 		break;
 	case NFT_BITWISE_LSHIFT:
 	case NFT_BITWISE_RSHIFT:
@@ -270,7 +270,7 @@ static int nft_bitwise_offload(struct nf
 	const struct nft_bitwise *priv = nft_expr_priv(expr);
 	struct nft_offload_reg *reg = &ctx->regs[priv->dreg];
 
-	if (priv->op != NFT_BITWISE_BOOL)
+	if (priv->op != NFT_BITWISE_MASK_XOR)
 		return -EOPNOTSUPP;
 
 	if (memcmp(&priv->xor, &zero, sizeof(priv->xor)) ||
@@ -407,7 +407,7 @@ nft_bitwise_fast_dump(struct sk_buff *sk
 		return -1;
 	if (nla_put_be32(skb, NFTA_BITWISE_LEN, htonl(sizeof(u32))))
 		return -1;
-	if (nla_put_be32(skb, NFTA_BITWISE_OP, htonl(NFT_BITWISE_BOOL)))
+	if (nla_put_be32(skb, NFTA_BITWISE_OP, htonl(NFT_BITWISE_MASK_XOR)))
 		return -1;
 
 	data.data[0] = priv->mask;
@@ -502,7 +502,7 @@ nft_bitwise_select_ops(const struct nft_
 		return &nft_bitwise_ops;
 
 	if (tb[NFTA_BITWISE_OP] &&
-	    ntohl(nla_get_be32(tb[NFTA_BITWISE_OP])) != NFT_BITWISE_BOOL)
+	    ntohl(nla_get_be32(tb[NFTA_BITWISE_OP])) != NFT_BITWISE_MASK_XOR)
 		return &nft_bitwise_ops;
 
 	return &nft_bitwise_fast_ops;


