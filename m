Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE474772A7;
	Thu, 20 Aug 2026 17:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248116; cv=none; b=h0XbEn+PPUFd3leNR525Xb68A7GScuw7zJmXyuFEZIg2ZqMixhhuzgAvPtjUsoxZ+aTBUm8atvGqSFDObBp4EsVA3wBbCrcZncaGJ0i26ObR/cJ4Zsg4bQmW+0vXaMrZ0QQx1VPezMehnzIZVUgvmoJ+4cWkEHWfoInFwYD+7AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248116; c=relaxed/simple;
	bh=7fp+f5aKz81x9lyR83e4y83PgQOXJnzF7DvAYLyXMHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jH1lnL8MWBjMc6l3ScapC2sluIwkuiz1AImQohj/5+HQspyzSOEg1hMJ/ViDjKHR5hbUhEOQrhbbM7+utlnZJA4Pbv1SxkOfe4MP6iPM0nYazQuX8NJB/YlfEonTc68/82S4talzusw67nyYjSTyx9aWNH4azoiPTqLNWBy6aLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J61n9lXq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J61n9lXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA6AC1F000E9;
	Thu, 20 Aug 2026 17:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248114;
	bh=zdLD9HCVf9QtGbKkqhU1jOizUAq5rC2l51D82keotQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J61n9lXqYLmy36VCZXPEtyL3b8zsCkBXVMETiTFL6d1WvGGqqKXpFezAtxxbyEsjT
	 fHo+42VG7SIlekKOYS5+76jL416t8PmvrfNwh4k84vsPTOVK2I9Dum1MF6dC5hHmLP
	 x7+IGKiFn0bVCw0K3CmIMTV+InyUKJG23kw+ktOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 116/303] netfilter: nf_tables: drop unused 3rd argument from validate callback ops
Date: Thu, 20 Aug 2026 16:54:12 +0200
Message-ID: <20260820145256.766252146@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit eaf9b2c875ece22768b78aa38da8b232e5de021b ]

Since commit a654de8fdc18 ("netfilter: nf_tables: fix chain dependency validation")
the validate() callback no longer needs the return pointer argument.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: d07955dd34ec ("netfilter: nft_fib: reject fib expression on the netdev egress hook")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_tables.h        |    3 +--
 include/net/netfilter/nft_fib.h          |    4 +---
 include/net/netfilter/nft_meta.h         |    3 +--
 include/net/netfilter/nft_reject.h       |    3 +--
 net/bridge/netfilter/nft_reject_bridge.c |    3 +--
 net/netfilter/nf_tables_api.c            |    3 +--
 net/netfilter/nft_compat.c               |    6 ++----
 net/netfilter/nft_fib.c                  |    3 +--
 net/netfilter/nft_flow_offload.c         |    3 +--
 net/netfilter/nft_fwd_netdev.c           |    3 +--
 net/netfilter/nft_immediate.c            |    3 +--
 net/netfilter/nft_lookup.c               |    3 +--
 net/netfilter/nft_masq.c                 |    3 +--
 net/netfilter/nft_meta.c                 |    6 ++----
 net/netfilter/nft_nat.c                  |    3 +--
 net/netfilter/nft_osf.c                  |    3 +--
 net/netfilter/nft_queue.c                |    3 +--
 net/netfilter/nft_redir.c                |    3 +--
 net/netfilter/nft_reject.c               |    3 +--
 net/netfilter/nft_reject_inet.c          |    3 +--
 net/netfilter/nft_reject_netdev.c        |    3 +--
 net/netfilter/nft_rt.c                   |    3 +--
 net/netfilter/nft_socket.c               |    3 +--
 net/netfilter/nft_synproxy.c             |    3 +--
 net/netfilter/nft_tproxy.c               |    3 +--
 net/netfilter/nft_xfrm.c                 |    3 +--
 26 files changed, 28 insertions(+), 57 deletions(-)

--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -932,8 +932,7 @@ struct nft_expr_ops {
 	int				(*dump)(struct sk_buff *skb,
 						const struct nft_expr *expr);
 	int				(*validate)(const struct nft_ctx *ctx,
-						    const struct nft_expr *expr,
-						    const struct nft_data **data);
+						    const struct nft_expr *expr);
 	bool				(*reduce)(struct nft_regs_track *track,
 						  const struct nft_expr *expr);
 	bool				(*gc)(struct net *net,
--- a/include/net/netfilter/nft_fib.h
+++ b/include/net/netfilter/nft_fib.h
@@ -21,9 +21,7 @@ nft_fib_is_loopback(const struct sk_buff
 int nft_fib_dump(struct sk_buff *skb, const struct nft_expr *expr);
 int nft_fib_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		 const struct nlattr * const tb[]);
-int nft_fib_validate(const struct nft_ctx *ctx, const struct nft_expr *expr,
-		     const struct nft_data **data);
-
+int nft_fib_validate(const struct nft_ctx *ctx, const struct nft_expr *expr);
 
 void nft_fib4_eval_type(const struct nft_expr *expr, struct nft_regs *regs,
 			const struct nft_pktinfo *pkt);
--- a/include/net/netfilter/nft_meta.h
+++ b/include/net/netfilter/nft_meta.h
@@ -41,8 +41,7 @@ void nft_meta_set_destroy(const struct n
 			  const struct nft_expr *expr);
 
 int nft_meta_set_validate(const struct nft_ctx *ctx,
-			  const struct nft_expr *expr,
-			  const struct nft_data **data);
+			  const struct nft_expr *expr);
 
 bool nft_meta_get_reduce(struct nft_regs_track *track,
 			 const struct nft_expr *expr);
--- a/include/net/netfilter/nft_reject.h
+++ b/include/net/netfilter/nft_reject.h
@@ -15,8 +15,7 @@ struct nft_reject {
 extern const struct nla_policy nft_reject_policy[];
 
 int nft_reject_validate(const struct nft_ctx *ctx,
-			const struct nft_expr *expr,
-			const struct nft_data **data);
+			const struct nft_expr *expr);
 
 int nft_reject_init(const struct nft_ctx *ctx,
 		    const struct nft_expr *expr,
--- a/net/bridge/netfilter/nft_reject_bridge.c
+++ b/net/bridge/netfilter/nft_reject_bridge.c
@@ -170,8 +170,7 @@ out:
 }
 
 static int nft_reject_bridge_validate(const struct nft_ctx *ctx,
-				      const struct nft_expr *expr,
-				      const struct nft_data **data)
+				      const struct nft_expr *expr)
 {
 	return nft_chain_validate_hooks(ctx->chain, (1 << NF_BR_PRE_ROUTING) |
 						    (1 << NF_BR_LOCAL_IN));
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3538,7 +3538,6 @@ static void nf_tables_rule_release(const
 int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
 {
 	struct nft_expr *expr, *last;
-	const struct nft_data *data;
 	struct nft_rule *rule;
 	int err;
 
@@ -3556,7 +3555,7 @@ int nft_chain_validate(const struct nft_
 			/* This may call nft_chain_validate() recursively,
 			 * callers that do so must increment ctx->level.
 			 */
-			err = expr->ops->validate(ctx, expr, &data);
+			err = expr->ops->validate(ctx, expr);
 			if (err < 0)
 				return err;
 		}
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -350,8 +350,7 @@ nla_put_failure:
 }
 
 static int nft_target_validate(const struct nft_ctx *ctx,
-			       const struct nft_expr *expr,
-			       const struct nft_data **data)
+			       const struct nft_expr *expr)
 {
 	struct xt_target *target = expr->ops->data;
 	unsigned int hook_mask = 0;
@@ -610,8 +609,7 @@ static int nft_match_large_dump(struct s
 }
 
 static int nft_match_validate(const struct nft_ctx *ctx,
-			      const struct nft_expr *expr,
-			      const struct nft_data **data)
+			      const struct nft_expr *expr)
 {
 	struct xt_match *match = expr->ops->data;
 	unsigned int hook_mask = 0;
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -25,8 +25,7 @@ EXPORT_SYMBOL(nft_fib_policy);
 			NFTA_FIB_F_MARK | NFTA_FIB_F_IIF | NFTA_FIB_F_OIF | \
 			NFTA_FIB_F_PRESENT)
 
-int nft_fib_validate(const struct nft_ctx *ctx, const struct nft_expr *expr,
-		     const struct nft_data **data)
+int nft_fib_validate(const struct nft_ctx *ctx, const struct nft_expr *expr)
 {
 	const struct nft_fib *priv = nft_expr_priv(expr);
 	unsigned int hooks;
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -392,8 +392,7 @@ out:
 }
 
 static int nft_flow_offload_validate(const struct nft_ctx *ctx,
-				     const struct nft_expr *expr,
-				     const struct nft_data **data)
+				     const struct nft_expr *expr)
 {
 	unsigned int hook_mask = (1 << NF_INET_FORWARD);
 
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -212,8 +212,7 @@ nla_put_failure:
 }
 
 static int nft_fwd_validate(const struct nft_ctx *ctx,
-			    const struct nft_expr *expr,
-			    const struct nft_data **data)
+			    const struct nft_expr *expr)
 {
 	return nft_chain_validate_hooks(ctx->chain, (1 << NF_NETDEV_INGRESS) |
 						    (1 << NF_NETDEV_EGRESS));
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -243,8 +243,7 @@ nla_put_failure:
 }
 
 static int nft_immediate_validate(const struct nft_ctx *ctx,
-				  const struct nft_expr *expr,
-				  const struct nft_data **d)
+				  const struct nft_expr *expr)
 {
 	const struct nft_immediate_expr *priv = nft_expr_priv(expr);
 	struct nft_ctx *pctx = (struct nft_ctx *)ctx;
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -200,8 +200,7 @@ nla_put_failure:
 }
 
 static int nft_lookup_validate(const struct nft_ctx *ctx,
-			       const struct nft_expr *expr,
-			       const struct nft_data **d)
+			       const struct nft_expr *expr)
 {
 	const struct nft_lookup *priv = nft_expr_priv(expr);
 	struct nft_set_iter iter;
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -26,8 +26,7 @@ static const struct nla_policy nft_masq_
 };
 
 static int nft_masq_validate(const struct nft_ctx *ctx,
-			     const struct nft_expr *expr,
-			     const struct nft_data **data)
+			     const struct nft_expr *expr)
 {
 	int err;
 
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -581,8 +581,7 @@ static int nft_meta_get_validate_xfrm(co
 }
 
 static int nft_meta_get_validate(const struct nft_ctx *ctx,
-				 const struct nft_expr *expr,
-				 const struct nft_data **data)
+				 const struct nft_expr *expr)
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
 
@@ -600,8 +599,7 @@ static int nft_meta_get_validate(const s
 }
 
 int nft_meta_set_validate(const struct nft_ctx *ctx,
-			  const struct nft_expr *expr,
-			  const struct nft_data **data)
+			  const struct nft_expr *expr)
 {
 	struct nft_meta *priv = nft_expr_priv(expr);
 	unsigned int hooks;
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -136,8 +136,7 @@ static const struct nla_policy nft_nat_p
 };
 
 static int nft_nat_validate(const struct nft_ctx *ctx,
-			    const struct nft_expr *expr,
-			    const struct nft_data **data)
+			    const struct nft_expr *expr)
 {
 	struct nft_nat *priv = nft_expr_priv(expr);
 	int err;
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -117,8 +117,7 @@ nla_put_failure:
 }
 
 static int nft_osf_validate(const struct nft_ctx *ctx,
-			    const struct nft_expr *expr,
-			    const struct nft_data **data)
+			    const struct nft_expr *expr)
 {
 	unsigned int hooks;
 
--- a/net/netfilter/nft_queue.c
+++ b/net/netfilter/nft_queue.c
@@ -69,8 +69,7 @@ static void nft_queue_sreg_eval(const st
 }
 
 static int nft_queue_validate(const struct nft_ctx *ctx,
-			      const struct nft_expr *expr,
-			      const struct nft_data **data)
+			      const struct nft_expr *expr)
 {
 	static const unsigned int supported_hooks = ((1 << NF_INET_PRE_ROUTING) |
 						     (1 << NF_INET_LOCAL_IN) |
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -26,8 +26,7 @@ static const struct nla_policy nft_redir
 };
 
 static int nft_redir_validate(const struct nft_ctx *ctx,
-			      const struct nft_expr *expr,
-			      const struct nft_data **data)
+			      const struct nft_expr *expr)
 {
 	int err;
 
--- a/net/netfilter/nft_reject.c
+++ b/net/netfilter/nft_reject.c
@@ -24,8 +24,7 @@ const struct nla_policy nft_reject_polic
 EXPORT_SYMBOL_GPL(nft_reject_policy);
 
 int nft_reject_validate(const struct nft_ctx *ctx,
-			const struct nft_expr *expr,
-			const struct nft_data **data)
+			const struct nft_expr *expr)
 {
 	return nft_chain_validate_hooks(ctx->chain,
 					(1 << NF_INET_LOCAL_IN) |
--- a/net/netfilter/nft_reject_inet.c
+++ b/net/netfilter/nft_reject_inet.c
@@ -61,8 +61,7 @@ static void nft_reject_inet_eval(const s
 }
 
 static int nft_reject_inet_validate(const struct nft_ctx *ctx,
-				    const struct nft_expr *expr,
-				    const struct nft_data **data)
+				    const struct nft_expr *expr)
 {
 	return nft_chain_validate_hooks(ctx->chain,
 					(1 << NF_INET_LOCAL_IN) |
--- a/net/netfilter/nft_reject_netdev.c
+++ b/net/netfilter/nft_reject_netdev.c
@@ -145,8 +145,7 @@ out:
 }
 
 static int nft_reject_netdev_validate(const struct nft_ctx *ctx,
-				      const struct nft_expr *expr,
-				      const struct nft_data **data)
+				      const struct nft_expr *expr)
 {
 	return nft_chain_validate_hooks(ctx->chain, (1 << NF_NETDEV_INGRESS));
 }
--- a/net/netfilter/nft_rt.c
+++ b/net/netfilter/nft_rt.c
@@ -160,8 +160,7 @@ nla_put_failure:
 	return -1;
 }
 
-static int nft_rt_validate(const struct nft_ctx *ctx, const struct nft_expr *expr,
-			   const struct nft_data **data)
+static int nft_rt_validate(const struct nft_ctx *ctx, const struct nft_expr *expr)
 {
 	const struct nft_rt *priv = nft_expr_priv(expr);
 	unsigned int hooks;
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -275,8 +275,7 @@ static bool nft_socket_reduce(struct nft
 }
 
 static int nft_socket_validate(const struct nft_ctx *ctx,
-			       const struct nft_expr *expr,
-			       const struct nft_data **data)
+			       const struct nft_expr *expr)
 {
 	if (ctx->family != NFPROTO_IPV4 &&
 	    ctx->family != NFPROTO_IPV6 &&
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -247,8 +247,7 @@ static void nft_synproxy_eval(const stru
 }
 
 static int nft_synproxy_validate(const struct nft_ctx *ctx,
-				 const struct nft_expr *expr,
-				 const struct nft_data **data)
+				 const struct nft_expr *expr)
 {
 	if (ctx->family != NFPROTO_IPV4 &&
 	    ctx->family != NFPROTO_IPV6 &&
--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -313,8 +313,7 @@ static int nft_tproxy_dump(struct sk_buf
 }
 
 static int nft_tproxy_validate(const struct nft_ctx *ctx,
-			       const struct nft_expr *expr,
-			       const struct nft_data **data)
+			       const struct nft_expr *expr)
 {
 	if (ctx->family != NFPROTO_IPV4 &&
 	    ctx->family != NFPROTO_IPV6 &&
--- a/net/netfilter/nft_xfrm.c
+++ b/net/netfilter/nft_xfrm.c
@@ -229,8 +229,7 @@ static int nft_xfrm_get_dump(struct sk_b
 	return 0;
 }
 
-static int nft_xfrm_validate(const struct nft_ctx *ctx, const struct nft_expr *expr,
-			     const struct nft_data **data)
+static int nft_xfrm_validate(const struct nft_ctx *ctx, const struct nft_expr *expr)
 {
 	const struct nft_xfrm *priv = nft_expr_priv(expr);
 	unsigned int hooks;


