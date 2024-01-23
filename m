Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440C867736;
	Tue, 23 Jan 2024 02:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975287; cv=none; b=sXxwYFH7TjW7tIx17rLyR0Xor2o7+tNhvHUDaZ152JMklm8Eotv8ASXZk6wIJ3c3kpUNS8fPkbY4e0D/enfIagyEWRsd4eHkA+G/5146oVxN6Yih+SSwDoLAQu/X6Z2lsaFfHfd7E7xAJOl3LlSC5qlHdTwi7XTxrQF7nSiDKSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975287; c=relaxed/simple;
	bh=ReG7VVeGzUNYRrvH8z0IifQYNNwLZUfqCby5oGgtIWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fyeLK4v0kKOsc/+Czy1prG8Tv7c279X7LU0UzU7p2osyg3WkEBCdk/lajod6KGfDGjkL9ZlguxdqbGgfC8aqV2Ozri7QtByaSuUX6Qr+HF26EJT8+O9sM1GscrUj558R4UYE8f3yXt5Ag0KL+cnV4uxwXJudMSZkBf8/Jy7Wdzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oEYYl3j+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oEYYl3j+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBC4C433C7;
	Tue, 23 Jan 2024 02:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975287;
	bh=ReG7VVeGzUNYRrvH8z0IifQYNNwLZUfqCby5oGgtIWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oEYYl3j+3kX1pCQswo6Z/APtIDV5BMPNyCO5jH+jEo/3ZsK+c1M1QQFP+32/OVC0T
	 CKiSkcFMnsDzb8NmdRWzADjg86HJGc96lK7UJjRJFnbOuscTYvotf1y5zYHe9oS6PT
	 Lpa4lcoEZZdMDSQn/wAp3zSGo0Y2/3vio9A6jQII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 348/374] netfilter: nft_limit: rename stateful structure
Date: Mon, 22 Jan 2024 16:00:04 -0800
Message-ID: <20240122235757.037377495@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 369b6cb5d391750fc01ce951c2500281d2975705 ]

>From struct nft_limit to nft_limit_priv.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 91a139cee120 ("netfilter: nft_limit: do not ignore unsupported flags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_limit.c | 104 +++++++++++++++++++-------------------
 1 file changed, 52 insertions(+), 52 deletions(-)

diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
index 82ec27bdf941..d6e0226b7603 100644
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -14,7 +14,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
 
-struct nft_limit {
+struct nft_limit_priv {
 	spinlock_t	lock;
 	u64		last;
 	u64		tokens;
@@ -25,33 +25,33 @@ struct nft_limit {
 	bool		invert;
 };
 
-static inline bool nft_limit_eval(struct nft_limit *limit, u64 cost)
+static inline bool nft_limit_eval(struct nft_limit_priv *priv, u64 cost)
 {
 	u64 now, tokens;
 	s64 delta;
 
-	spin_lock_bh(&limit->lock);
+	spin_lock_bh(&priv->lock);
 	now = ktime_get_ns();
-	tokens = limit->tokens + now - limit->last;
-	if (tokens > limit->tokens_max)
-		tokens = limit->tokens_max;
+	tokens = priv->tokens + now - priv->last;
+	if (tokens > priv->tokens_max)
+		tokens = priv->tokens_max;
 
-	limit->last = now;
+	priv->last = now;
 	delta = tokens - cost;
 	if (delta >= 0) {
-		limit->tokens = delta;
-		spin_unlock_bh(&limit->lock);
-		return limit->invert;
+		priv->tokens = delta;
+		spin_unlock_bh(&priv->lock);
+		return priv->invert;
 	}
-	limit->tokens = tokens;
-	spin_unlock_bh(&limit->lock);
-	return !limit->invert;
+	priv->tokens = tokens;
+	spin_unlock_bh(&priv->lock);
+	return !priv->invert;
 }
 
 /* Use same default as in iptables. */
 #define NFT_LIMIT_PKT_BURST_DEFAULT	5
 
-static int nft_limit_init(struct nft_limit *limit,
+static int nft_limit_init(struct nft_limit_priv *priv,
 			  const struct nlattr * const tb[], bool pkts)
 {
 	u64 unit, tokens;
@@ -60,58 +60,58 @@ static int nft_limit_init(struct nft_limit *limit,
 	    tb[NFTA_LIMIT_UNIT] == NULL)
 		return -EINVAL;
 
-	limit->rate = be64_to_cpu(nla_get_be64(tb[NFTA_LIMIT_RATE]));
+	priv->rate = be64_to_cpu(nla_get_be64(tb[NFTA_LIMIT_RATE]));
 	unit = be64_to_cpu(nla_get_be64(tb[NFTA_LIMIT_UNIT]));
-	limit->nsecs = unit * NSEC_PER_SEC;
-	if (limit->rate == 0 || limit->nsecs < unit)
+	priv->nsecs = unit * NSEC_PER_SEC;
+	if (priv->rate == 0 || priv->nsecs < unit)
 		return -EOVERFLOW;
 
 	if (tb[NFTA_LIMIT_BURST])
-		limit->burst = ntohl(nla_get_be32(tb[NFTA_LIMIT_BURST]));
+		priv->burst = ntohl(nla_get_be32(tb[NFTA_LIMIT_BURST]));
 
-	if (pkts && limit->burst == 0)
-		limit->burst = NFT_LIMIT_PKT_BURST_DEFAULT;
+	if (pkts && priv->burst == 0)
+		priv->burst = NFT_LIMIT_PKT_BURST_DEFAULT;
 
-	if (limit->rate + limit->burst < limit->rate)
+	if (priv->rate + priv->burst < priv->rate)
 		return -EOVERFLOW;
 
 	if (pkts) {
-		tokens = div64_u64(limit->nsecs, limit->rate) * limit->burst;
+		tokens = div64_u64(priv->nsecs, priv->rate) * priv->burst;
 	} else {
 		/* The token bucket size limits the number of tokens can be
 		 * accumulated. tokens_max specifies the bucket size.
 		 * tokens_max = unit * (rate + burst) / rate.
 		 */
-		tokens = div64_u64(limit->nsecs * (limit->rate + limit->burst),
-				 limit->rate);
+		tokens = div64_u64(priv->nsecs * (priv->rate + priv->burst),
+				 priv->rate);
 	}
 
-	limit->tokens = tokens;
-	limit->tokens_max = limit->tokens;
+	priv->tokens = tokens;
+	priv->tokens_max = priv->tokens;
 
 	if (tb[NFTA_LIMIT_FLAGS]) {
 		u32 flags = ntohl(nla_get_be32(tb[NFTA_LIMIT_FLAGS]));
 
 		if (flags & NFT_LIMIT_F_INV)
-			limit->invert = true;
+			priv->invert = true;
 	}
-	limit->last = ktime_get_ns();
-	spin_lock_init(&limit->lock);
+	priv->last = ktime_get_ns();
+	spin_lock_init(&priv->lock);
 
 	return 0;
 }
 
-static int nft_limit_dump(struct sk_buff *skb, const struct nft_limit *limit,
+static int nft_limit_dump(struct sk_buff *skb, const struct nft_limit_priv *priv,
 			  enum nft_limit_type type)
 {
-	u32 flags = limit->invert ? NFT_LIMIT_F_INV : 0;
-	u64 secs = div_u64(limit->nsecs, NSEC_PER_SEC);
+	u32 flags = priv->invert ? NFT_LIMIT_F_INV : 0;
+	u64 secs = div_u64(priv->nsecs, NSEC_PER_SEC);
 
-	if (nla_put_be64(skb, NFTA_LIMIT_RATE, cpu_to_be64(limit->rate),
+	if (nla_put_be64(skb, NFTA_LIMIT_RATE, cpu_to_be64(priv->rate),
 			 NFTA_LIMIT_PAD) ||
 	    nla_put_be64(skb, NFTA_LIMIT_UNIT, cpu_to_be64(secs),
 			 NFTA_LIMIT_PAD) ||
-	    nla_put_be32(skb, NFTA_LIMIT_BURST, htonl(limit->burst)) ||
+	    nla_put_be32(skb, NFTA_LIMIT_BURST, htonl(priv->burst)) ||
 	    nla_put_be32(skb, NFTA_LIMIT_TYPE, htonl(type)) ||
 	    nla_put_be32(skb, NFTA_LIMIT_FLAGS, htonl(flags)))
 		goto nla_put_failure;
@@ -121,8 +121,8 @@ static int nft_limit_dump(struct sk_buff *skb, const struct nft_limit *limit,
 	return -1;
 }
 
-struct nft_limit_pkts {
-	struct nft_limit	limit;
+struct nft_limit_priv_pkts {
+	struct nft_limit_priv	limit;
 	u64			cost;
 };
 
@@ -130,7 +130,7 @@ static void nft_limit_pkts_eval(const struct nft_expr *expr,
 				struct nft_regs *regs,
 				const struct nft_pktinfo *pkt)
 {
-	struct nft_limit_pkts *priv = nft_expr_priv(expr);
+	struct nft_limit_priv_pkts *priv = nft_expr_priv(expr);
 
 	if (nft_limit_eval(&priv->limit, priv->cost))
 		regs->verdict.code = NFT_BREAK;
@@ -148,7 +148,7 @@ static int nft_limit_pkts_init(const struct nft_ctx *ctx,
 			       const struct nft_expr *expr,
 			       const struct nlattr * const tb[])
 {
-	struct nft_limit_pkts *priv = nft_expr_priv(expr);
+	struct nft_limit_priv_pkts *priv = nft_expr_priv(expr);
 	int err;
 
 	err = nft_limit_init(&priv->limit, tb, true);
@@ -161,7 +161,7 @@ static int nft_limit_pkts_init(const struct nft_ctx *ctx,
 
 static int nft_limit_pkts_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
-	const struct nft_limit_pkts *priv = nft_expr_priv(expr);
+	const struct nft_limit_priv_pkts *priv = nft_expr_priv(expr);
 
 	return nft_limit_dump(skb, &priv->limit, NFT_LIMIT_PKTS);
 }
@@ -169,7 +169,7 @@ static int nft_limit_pkts_dump(struct sk_buff *skb, const struct nft_expr *expr)
 static struct nft_expr_type nft_limit_type;
 static const struct nft_expr_ops nft_limit_pkts_ops = {
 	.type		= &nft_limit_type,
-	.size		= NFT_EXPR_SIZE(sizeof(struct nft_limit_pkts)),
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_limit_priv_pkts)),
 	.eval		= nft_limit_pkts_eval,
 	.init		= nft_limit_pkts_init,
 	.dump		= nft_limit_pkts_dump,
@@ -179,7 +179,7 @@ static void nft_limit_bytes_eval(const struct nft_expr *expr,
 				 struct nft_regs *regs,
 				 const struct nft_pktinfo *pkt)
 {
-	struct nft_limit *priv = nft_expr_priv(expr);
+	struct nft_limit_priv *priv = nft_expr_priv(expr);
 	u64 cost = div64_u64(priv->nsecs * pkt->skb->len, priv->rate);
 
 	if (nft_limit_eval(priv, cost))
@@ -190,7 +190,7 @@ static int nft_limit_bytes_init(const struct nft_ctx *ctx,
 				const struct nft_expr *expr,
 				const struct nlattr * const tb[])
 {
-	struct nft_limit *priv = nft_expr_priv(expr);
+	struct nft_limit_priv *priv = nft_expr_priv(expr);
 
 	return nft_limit_init(priv, tb, false);
 }
@@ -198,14 +198,14 @@ static int nft_limit_bytes_init(const struct nft_ctx *ctx,
 static int nft_limit_bytes_dump(struct sk_buff *skb,
 				const struct nft_expr *expr)
 {
-	const struct nft_limit *priv = nft_expr_priv(expr);
+	const struct nft_limit_priv *priv = nft_expr_priv(expr);
 
 	return nft_limit_dump(skb, priv, NFT_LIMIT_PKT_BYTES);
 }
 
 static const struct nft_expr_ops nft_limit_bytes_ops = {
 	.type		= &nft_limit_type,
-	.size		= NFT_EXPR_SIZE(sizeof(struct nft_limit)),
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_limit_priv)),
 	.eval		= nft_limit_bytes_eval,
 	.init		= nft_limit_bytes_init,
 	.dump		= nft_limit_bytes_dump,
@@ -240,7 +240,7 @@ static void nft_limit_obj_pkts_eval(struct nft_object *obj,
 				    struct nft_regs *regs,
 				    const struct nft_pktinfo *pkt)
 {
-	struct nft_limit_pkts *priv = nft_obj_data(obj);
+	struct nft_limit_priv_pkts *priv = nft_obj_data(obj);
 
 	if (nft_limit_eval(&priv->limit, priv->cost))
 		regs->verdict.code = NFT_BREAK;
@@ -250,7 +250,7 @@ static int nft_limit_obj_pkts_init(const struct nft_ctx *ctx,
 				   const struct nlattr * const tb[],
 				   struct nft_object *obj)
 {
-	struct nft_limit_pkts *priv = nft_obj_data(obj);
+	struct nft_limit_priv_pkts *priv = nft_obj_data(obj);
 	int err;
 
 	err = nft_limit_init(&priv->limit, tb, true);
@@ -265,7 +265,7 @@ static int nft_limit_obj_pkts_dump(struct sk_buff *skb,
 				   struct nft_object *obj,
 				   bool reset)
 {
-	const struct nft_limit_pkts *priv = nft_obj_data(obj);
+	const struct nft_limit_priv_pkts *priv = nft_obj_data(obj);
 
 	return nft_limit_dump(skb, &priv->limit, NFT_LIMIT_PKTS);
 }
@@ -273,7 +273,7 @@ static int nft_limit_obj_pkts_dump(struct sk_buff *skb,
 static struct nft_object_type nft_limit_obj_type;
 static const struct nft_object_ops nft_limit_obj_pkts_ops = {
 	.type		= &nft_limit_obj_type,
-	.size		= NFT_EXPR_SIZE(sizeof(struct nft_limit_pkts)),
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_limit_priv_pkts)),
 	.init		= nft_limit_obj_pkts_init,
 	.eval		= nft_limit_obj_pkts_eval,
 	.dump		= nft_limit_obj_pkts_dump,
@@ -283,7 +283,7 @@ static void nft_limit_obj_bytes_eval(struct nft_object *obj,
 				     struct nft_regs *regs,
 				     const struct nft_pktinfo *pkt)
 {
-	struct nft_limit *priv = nft_obj_data(obj);
+	struct nft_limit_priv *priv = nft_obj_data(obj);
 	u64 cost = div64_u64(priv->nsecs * pkt->skb->len, priv->rate);
 
 	if (nft_limit_eval(priv, cost))
@@ -294,7 +294,7 @@ static int nft_limit_obj_bytes_init(const struct nft_ctx *ctx,
 				    const struct nlattr * const tb[],
 				    struct nft_object *obj)
 {
-	struct nft_limit *priv = nft_obj_data(obj);
+	struct nft_limit_priv *priv = nft_obj_data(obj);
 
 	return nft_limit_init(priv, tb, false);
 }
@@ -303,7 +303,7 @@ static int nft_limit_obj_bytes_dump(struct sk_buff *skb,
 				    struct nft_object *obj,
 				    bool reset)
 {
-	const struct nft_limit *priv = nft_obj_data(obj);
+	const struct nft_limit_priv *priv = nft_obj_data(obj);
 
 	return nft_limit_dump(skb, priv, NFT_LIMIT_PKT_BYTES);
 }
@@ -311,7 +311,7 @@ static int nft_limit_obj_bytes_dump(struct sk_buff *skb,
 static struct nft_object_type nft_limit_obj_type;
 static const struct nft_object_ops nft_limit_obj_bytes_ops = {
 	.type		= &nft_limit_obj_type,
-	.size		= sizeof(struct nft_limit),
+	.size		= sizeof(struct nft_limit_priv),
 	.init		= nft_limit_obj_bytes_init,
 	.eval		= nft_limit_obj_bytes_eval,
 	.dump		= nft_limit_obj_bytes_dump,
-- 
2.43.0



