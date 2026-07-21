Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000B447127E;
	Tue, 21 Jul 2026 18:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657753; cv=none; b=Bj9u2knajl9XNy33oHC4I3HRNe59QeNB25ZsR/TdBO51bsmR5yraXB5SWz8Qg717s7vE9c8+cfX2/WDhOueAsjN01FTLJmmSCTPDC3CGAV7crq8gzr0QvetX9Tdm4fRyxlIhxUXEuNvfDbZ/kw4nvW3KaDiwCZ4U60/Wywg8BKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657753; c=relaxed/simple;
	bh=2y2o+C1SlA3qL7NkiRRX/b0RPUOfuaV2y9yi0BHlj9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TMjmiDYlbB31bBe4D+impD6Hmp1++54pSeO9dZOMy6AaRAnrhrxODOlN8xqBtbEsZ5u6ibLecPP1ESK2CB4V0IRigPP6G+kXuD+D6KvpQnoInn7s9Q6hT1beeHGiAqfthdbeoA6B8UvA2mPxRt7EiNQxK82q6GFMf6PW3n3K4WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YRxoVlwN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YRxoVlwN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66FD11F00A3D;
	Tue, 21 Jul 2026 18:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657751;
	bh=yQ8FL3Lq7pB1+z4z50RHq/uAK3XVSH7wu77BqGFbows=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YRxoVlwNfXLGY9fYex/0UINu08RmeNruhn/pqBT6JUxLOIVFvsiw89qwkWevOK1KS
	 j3JALJyyxg+I84z+m2K0Cf1ArtY5yPG+7GtH7xwLvcFV8ZceI9cE9JZC+b8LskSeEe
	 Ws6GvUkC5XoMm1S6mR0IOTzHSCTorVzZE1WkZ8Cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0842/1611] netfilter: nft_meta_bridge: add validate callback for get operations
Date: Tue, 21 Jul 2026 17:15:58 +0200
Message-ID: <20260721152534.325819302@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit bff1c8b49a9cb5c04af20f4e7d43bf4af5863bc6 ]

Blamed commit added NFT_META_BRI_IIFHWADDR to the set validate callback,
yet this is a get operation.

Add a get validate callback and move the NFT_META_BRI_IIFHWADDR key
there.

AFAICS this is harmless, NFT_META_BRI_IIFHWADDR can deal with a NULL
input device and the set handler ignores a NFT_META_BRI_IIFHWADDR
operation, but it allows to read 4 bytes off bridge skb->cb[].

Fixes: cbd2257dc96e ("netfilter: nft_meta_bridge: introduce NFT_META_BRI_IIFHWADDR support")
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nft_meta.h       |  2 ++
 net/bridge/netfilter/nft_meta_bridge.c | 19 ++++++++++++++++++-
 net/netfilter/nft_meta.c               |  5 +++--
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nft_meta.h b/include/net/netfilter/nft_meta.h
index d602263590fed5..fab3e6658e91ce 100644
--- a/include/net/netfilter/nft_meta.h
+++ b/include/net/netfilter/nft_meta.h
@@ -40,6 +40,8 @@ void nft_meta_set_eval(const struct nft_expr *expr,
 void nft_meta_set_destroy(const struct nft_ctx *ctx,
 			  const struct nft_expr *expr);
 
+int nft_meta_get_validate(const struct nft_ctx *ctx,
+			  const struct nft_expr *expr);
 int nft_meta_set_validate(const struct nft_ctx *ctx,
 			  const struct nft_expr *expr);
 
diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index 1bcef43b2a8116..2e24696c33b3cd 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -107,12 +107,30 @@ static int nft_meta_bridge_get_init(const struct nft_ctx *ctx,
 					NULL, NFT_DATA_VALUE, len);
 }
 
+static int nft_meta_bridge_get_validate(const struct nft_ctx *ctx,
+					const struct nft_expr *expr)
+{
+	struct nft_meta *priv = nft_expr_priv(expr);
+	unsigned int hooks;
+
+	switch (priv->key) {
+	case NFT_META_BRI_IIFHWADDR:
+		hooks = 1 << NF_BR_PRE_ROUTING;
+		break;
+	default:
+		return nft_meta_get_validate(ctx, expr);
+	}
+
+	return nft_chain_validate_hooks(ctx->chain, hooks);
+}
+
 static struct nft_expr_type nft_meta_bridge_type;
 static const struct nft_expr_ops nft_meta_bridge_get_ops = {
 	.type		= &nft_meta_bridge_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
 	.eval		= nft_meta_bridge_get_eval,
 	.init		= nft_meta_bridge_get_init,
+	.validate	= nft_meta_bridge_get_validate,
 	.dump		= nft_meta_get_dump,
 	.reduce		= nft_meta_get_reduce,
 };
@@ -187,7 +205,6 @@ static int nft_meta_bridge_set_validate(const struct nft_ctx *ctx,
 
 	switch (priv->key) {
 	case NFT_META_BRI_BROUTE:
-	case NFT_META_BRI_IIFHWADDR:
 		hooks = 1 << NF_BR_PRE_ROUTING;
 		break;
 	default:
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 05cd1e6e6a2f61..d3b0efec036aa9 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -580,8 +580,8 @@ static int nft_meta_get_validate_xfrm(const struct nft_ctx *ctx)
 #endif
 }
 
-static int nft_meta_get_validate(const struct nft_ctx *ctx,
-				 const struct nft_expr *expr)
+int nft_meta_get_validate(const struct nft_ctx *ctx,
+			  const struct nft_expr *expr)
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
 
@@ -597,6 +597,7 @@ static int nft_meta_get_validate(const struct nft_ctx *ctx,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(nft_meta_get_validate);
 
 int nft_meta_set_validate(const struct nft_ctx *ctx,
 			  const struct nft_expr *expr)
-- 
2.53.0



