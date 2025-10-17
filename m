Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC810332ECA;
	Fri, 17 Oct 2025 15:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713681; cv=none; b=LYqtvrBPYCJPiOlsWMyEpmHOTeNtAY9hh0VhCA6x/LJMK03BqJhhNva2MqHhyu8Fsb6mnintmxDg2aj2Rgi2udkZRnDC6urJDujyGumSEZE9roYathG8HqfqclPEsxcN93/b0vmsDKnvfE4fLLdhTHMPFb4m80V+c3LXTAaaLdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713681; c=relaxed/simple;
	bh=jU+eJQEdBSLA38Rs3UAqNrEhcv0YkiEkbbCKcJ0zQfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kj8eadCyb6otEd159IwzhPMdQKIu3DamTVz+6oGli3TgkWveOvVgIi8dhA4qWw9ZZ28iUKXWcYA+zpwC3NzbUg4VZFBuLlQDIBw/0VYU9zWsm7CZbchCzThWxQaGxZEXdeB6/EDZGriJ5ETLBaS1hiSJF/n4+AcAsFvQdF4R0UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kg+gKJz/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kg+gKJz/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36CE6C4CEE7;
	Fri, 17 Oct 2025 15:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713681;
	bh=jU+eJQEdBSLA38Rs3UAqNrEhcv0YkiEkbbCKcJ0zQfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kg+gKJz/Vr+u5CugDXG+OZWD1Hr3RUO7GjQxgfDaRrOf4Jys7/z6WXNpg0cKF38Xk
	 lESPUNOWfqk4O9hl4btVZjaRIG0Au5GyUW9a1uJOH6UufAoaC9yJcQjXLCA0WrJT8C
	 nKqIDnRd1gu314+9oJhXVtHVL3ULRSBzcLEuemeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/201] netfilter: nf_tables: drop unused 3rd argument from validate callback ops
Date: Fri, 17 Oct 2025 16:51:50 +0200
Message-ID: <20251017145136.547046855@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit eaf9b2c875ece22768b78aa38da8b232e5de021b ]

Since commit a654de8fdc18 ("netfilter: nf_tables: fix chain dependency validation")
the validate() callback no longer needs the return pointer argument.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: f359b809d54c ("netfilter: nft_objref: validate objref and objrefmap expressions")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h        | 3 +--
 include/net/netfilter/nft_fib.h          | 4 +---
 include/net/netfilter/nft_meta.h         | 3 +--
 include/net/netfilter/nft_reject.h       | 3 +--
 net/bridge/netfilter/nft_meta_bridge.c   | 5 ++---
 net/bridge/netfilter/nft_reject_bridge.c | 3 +--
 net/netfilter/nf_tables_api.c            | 3 +--
 net/netfilter/nft_compat.c               | 6 ++----
 net/netfilter/nft_fib.c                  | 3 +--
 net/netfilter/nft_flow_offload.c         | 3 +--
 net/netfilter/nft_fwd_netdev.c           | 3 +--
 net/netfilter/nft_immediate.c            | 3 +--
 net/netfilter/nft_lookup.c               | 3 +--
 net/netfilter/nft_masq.c                 | 3 +--
 net/netfilter/nft_meta.c                 | 6 ++----
 net/netfilter/nft_nat.c                  | 3 +--
 net/netfilter/nft_osf.c                  | 3 +--
 net/netfilter/nft_queue.c                | 3 +--
 net/netfilter/nft_redir.c                | 3 +--
 net/netfilter/nft_reject.c               | 3 +--
 net/netfilter/nft_reject_inet.c          | 3 +--
 net/netfilter/nft_reject_netdev.c        | 3 +--
 net/netfilter/nft_rt.c                   | 3 +--
 net/netfilter/nft_socket.c               | 3 +--
 net/netfilter/nft_synproxy.c             | 3 +--
 net/netfilter/nft_tproxy.c               | 3 +--
 net/netfilter/nft_xfrm.c                 | 3 +--
 27 files changed, 30 insertions(+), 60 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index c0f4b91e4f5ec..32606d5430605 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -955,8 +955,7 @@ struct nft_expr_ops {
 						const struct nft_expr *expr,
 						bool reset);
 	int				(*validate)(const struct nft_ctx *ctx,
-						    const struct nft_expr *expr,
-						    const struct nft_data **data);
+						    const struct nft_expr *expr);
 	bool				(*reduce)(struct nft_regs_track *track,
 						  const struct nft_expr *expr);
 	bool				(*gc)(struct net *net,
diff --git a/include/net/netfilter/nft_fib.h b/include/net/netfilter/nft_fib.h
index 167640b843ef8..38cae7113de46 100644
--- a/include/net/netfilter/nft_fib.h
+++ b/include/net/netfilter/nft_fib.h
@@ -21,9 +21,7 @@ nft_fib_is_loopback(const struct sk_buff *skb, const struct net_device *in)
 int nft_fib_dump(struct sk_buff *skb, const struct nft_expr *expr, bool reset);
 int nft_fib_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		 const struct nlattr * const tb[]);
-int nft_fib_validate(const struct nft_ctx *ctx, const struct nft_expr *expr,
-		     const struct nft_data **data);
-
+int nft_fib_validate(const struct nft_ctx *ctx, const struct nft_expr *expr);
 
 void nft_fib4_eval_type(const struct nft_expr *expr, struct nft_regs *regs,
 			const struct nft_pktinfo *pkt);
diff --git a/include/net/netfilter/nft_meta.h b/include/net/netfilter/nft_meta.h
index ba1238f12a487..d602263590fed 100644
--- a/include/net/netfilter/nft_meta.h
+++ b/include/net/netfilter/nft_meta.h
@@ -41,8 +41,7 @@ void nft_meta_set_destroy(const struct nft_ctx *ctx,
 			  const struct nft_expr *expr);
 
 int nft_meta_set_validate(const struct nft_ctx *ctx,
-			  const struct nft_expr *expr,
-			  const struct nft_data **data);
+			  const struct nft_expr *expr);
 
 bool nft_meta_get_reduce(struct nft_regs_track *track,
 			 const struct nft_expr *expr);
diff --git a/include/net/netfilter/nft_reject.h b/include/net/netfilter/nft_reject.h
index 6d9ba62efd750..19060212988a1 100644
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
diff --git a/net/bridge/netfilter/nft_meta_bridge.c b/net/bridge/netfilter/nft_meta_bridge.c
index bd4d1b4d745f6..affb740c8685e 100644
--- a/net/bridge/netfilter/nft_meta_bridge.c
+++ b/net/bridge/netfilter/nft_meta_bridge.c
@@ -168,8 +168,7 @@ static bool nft_meta_bridge_set_reduce(struct nft_regs_track *track,
 }
 
 static int nft_meta_bridge_set_validate(const struct nft_ctx *ctx,
-					const struct nft_expr *expr,
-					const struct nft_data **data)
+					const struct nft_expr *expr)
 {
 	struct nft_meta *priv = nft_expr_priv(expr);
 	unsigned int hooks;
@@ -179,7 +178,7 @@ static int nft_meta_bridge_set_validate(const struct nft_ctx *ctx,
 		hooks = 1 << NF_BR_PRE_ROUTING;
 		break;
 	default:
-		return nft_meta_set_validate(ctx, expr, data);
+		return nft_meta_set_validate(ctx, expr);
 	}
 
 	return nft_chain_validate_hooks(ctx->chain, hooks);
diff --git a/net/bridge/netfilter/nft_reject_bridge.c b/net/bridge/netfilter/nft_reject_bridge.c
index 71b54fed7263d..1cb5c16e97b7f 100644
--- a/net/bridge/netfilter/nft_reject_bridge.c
+++ b/net/bridge/netfilter/nft_reject_bridge.c
@@ -170,8 +170,7 @@ static void nft_reject_bridge_eval(const struct nft_expr *expr,
 }
 
 static int nft_reject_bridge_validate(const struct nft_ctx *ctx,
-				      const struct nft_expr *expr,
-				      const struct nft_data **data)
+				      const struct nft_expr *expr)
 {
 	return nft_chain_validate_hooks(ctx->chain, (1 << NF_BR_PRE_ROUTING) |
 						    (1 << NF_BR_LOCAL_IN));
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4ffb5ef79ca13..5ca1d775e976d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3793,7 +3793,6 @@ static void nf_tables_rule_release(const struct nft_ctx *ctx, struct nft_rule *r
 int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
 {
 	struct nft_expr *expr, *last;
-	const struct nft_data *data;
 	struct nft_rule *rule;
 	int err;
 
@@ -3814,7 +3813,7 @@ int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
 			/* This may call nft_chain_validate() recursively,
 			 * callers that do so must increment ctx->level.
 			 */
-			err = expr->ops->validate(ctx, expr, &data);
+			err = expr->ops->validate(ctx, expr);
 			if (err < 0)
 				return err;
 		}
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index d3d11dede5450..52cdfee17f73f 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -350,8 +350,7 @@ static int nft_target_dump(struct sk_buff *skb,
 }
 
 static int nft_target_validate(const struct nft_ctx *ctx,
-			       const struct nft_expr *expr,
-			       const struct nft_data **data)
+			       const struct nft_expr *expr)
 {
 	struct xt_target *target = expr->ops->data;
 	unsigned int hook_mask = 0;
@@ -611,8 +610,7 @@ static int nft_match_large_dump(struct sk_buff *skb,
 }
 
 static int nft_match_validate(const struct nft_ctx *ctx,
-			      const struct nft_expr *expr,
-			      const struct nft_data **data)
+			      const struct nft_expr *expr)
 {
 	struct xt_match *match = expr->ops->data;
 	unsigned int hook_mask = 0;
diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index bf825f6cb974e..507b7eba9bcdc 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -26,8 +26,7 @@ const struct nla_policy nft_fib_policy[NFTA_FIB_MAX + 1] = {
 };
 EXPORT_SYMBOL(nft_fib_policy);
 
-int nft_fib_validate(const struct nft_ctx *ctx, const struct nft_expr *expr,
-		     const struct nft_data **data)
+int nft_fib_validate(const struct nft_ctx *ctx, const struct nft_expr *expr)
 {
 	const struct nft_fib *priv = nft_expr_priv(expr);
 	unsigned int hooks;
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 5a3d685420420..1894032a7971c 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -385,8 +385,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 }
 
 static int nft_flow_offload_validate(const struct nft_ctx *ctx,
-				     const struct nft_expr *expr,
-				     const struct nft_data **data)
+				     const struct nft_expr *expr)
 {
 	unsigned int hook_mask = (1 << NF_INET_FORWARD);
 
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index a5268e6dd32f1..fa9e4ae00b16a 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -204,8 +204,7 @@ static int nft_fwd_neigh_dump(struct sk_buff *skb,
 }
 
 static int nft_fwd_validate(const struct nft_ctx *ctx,
-			    const struct nft_expr *expr,
-			    const struct nft_data **data)
+			    const struct nft_expr *expr)
 {
 	return nft_chain_validate_hooks(ctx->chain, (1 << NF_NETDEV_INGRESS) |
 						    (1 << NF_NETDEV_EGRESS));
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index ac2422c215e54..02ee5fb69871f 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -244,8 +244,7 @@ static int nft_immediate_dump(struct sk_buff *skb,
 }
 
 static int nft_immediate_validate(const struct nft_ctx *ctx,
-				  const struct nft_expr *expr,
-				  const struct nft_data **d)
+				  const struct nft_expr *expr)
 {
 	const struct nft_immediate_expr *priv = nft_expr_priv(expr);
 	struct nft_ctx *pctx = (struct nft_ctx *)ctx;
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 1b9edf2b33937..dd5441f92fdb0 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -206,8 +206,7 @@ static int nft_lookup_dump(struct sk_buff *skb,
 }
 
 static int nft_lookup_validate(const struct nft_ctx *ctx,
-			       const struct nft_expr *expr,
-			       const struct nft_data **d)
+			       const struct nft_expr *expr)
 {
 	const struct nft_lookup *priv = nft_expr_priv(expr);
 	struct nft_set_iter iter;
diff --git a/net/netfilter/nft_masq.c b/net/netfilter/nft_masq.c
index 8a14aaca93bbd..eee05394c5339 100644
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -27,8 +27,7 @@ static const struct nla_policy nft_masq_policy[NFTA_MASQ_MAX + 1] = {
 };
 
 static int nft_masq_validate(const struct nft_ctx *ctx,
-			     const struct nft_expr *expr,
-			     const struct nft_data **data)
+			     const struct nft_expr *expr)
 {
 	int err;
 
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 9139ce38ea7b9..dec76d28a0ac6 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -581,8 +581,7 @@ static int nft_meta_get_validate_xfrm(const struct nft_ctx *ctx)
 }
 
 static int nft_meta_get_validate(const struct nft_ctx *ctx,
-				 const struct nft_expr *expr,
-				 const struct nft_data **data)
+				 const struct nft_expr *expr)
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
 
@@ -600,8 +599,7 @@ static int nft_meta_get_validate(const struct nft_ctx *ctx,
 }
 
 int nft_meta_set_validate(const struct nft_ctx *ctx,
-			  const struct nft_expr *expr,
-			  const struct nft_data **data)
+			  const struct nft_expr *expr)
 {
 	struct nft_meta *priv = nft_expr_priv(expr);
 	unsigned int hooks;
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index 808f5802c2704..3d3e639a7a837 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -137,8 +137,7 @@ static const struct nla_policy nft_nat_policy[NFTA_NAT_MAX + 1] = {
 };
 
 static int nft_nat_validate(const struct nft_ctx *ctx,
-			    const struct nft_expr *expr,
-			    const struct nft_data **data)
+			    const struct nft_expr *expr)
 {
 	struct nft_nat *priv = nft_expr_priv(expr);
 	int err;
diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index 7f61506e5b44b..123b4f47ccef4 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -113,8 +113,7 @@ static int nft_osf_dump(struct sk_buff *skb,
 }
 
 static int nft_osf_validate(const struct nft_ctx *ctx,
-			    const struct nft_expr *expr,
-			    const struct nft_data **data)
+			    const struct nft_expr *expr)
 {
 	unsigned int hooks;
 
diff --git a/net/netfilter/nft_queue.c b/net/netfilter/nft_queue.c
index b2b8127c8d438..b8ebb187814f2 100644
--- a/net/netfilter/nft_queue.c
+++ b/net/netfilter/nft_queue.c
@@ -69,8 +69,7 @@ static void nft_queue_sreg_eval(const struct nft_expr *expr,
 }
 
 static int nft_queue_validate(const struct nft_ctx *ctx,
-			      const struct nft_expr *expr,
-			      const struct nft_data **data)
+			      const struct nft_expr *expr)
 {
 	static const unsigned int supported_hooks = ((1 << NF_INET_PRE_ROUTING) |
 						     (1 << NF_INET_LOCAL_IN) |
diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index a58bd8d291ff2..9051863509f31 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -27,8 +27,7 @@ static const struct nla_policy nft_redir_policy[NFTA_REDIR_MAX + 1] = {
 };
 
 static int nft_redir_validate(const struct nft_ctx *ctx,
-			      const struct nft_expr *expr,
-			      const struct nft_data **data)
+			      const struct nft_expr *expr)
 {
 	int err;
 
diff --git a/net/netfilter/nft_reject.c b/net/netfilter/nft_reject.c
index ed2e668474d67..196a92c7ea09b 100644
--- a/net/netfilter/nft_reject.c
+++ b/net/netfilter/nft_reject.c
@@ -24,8 +24,7 @@ const struct nla_policy nft_reject_policy[NFTA_REJECT_MAX + 1] = {
 EXPORT_SYMBOL_GPL(nft_reject_policy);
 
 int nft_reject_validate(const struct nft_ctx *ctx,
-			const struct nft_expr *expr,
-			const struct nft_data **data)
+			const struct nft_expr *expr)
 {
 	return nft_chain_validate_hooks(ctx->chain,
 					(1 << NF_INET_LOCAL_IN) |
diff --git a/net/netfilter/nft_reject_inet.c b/net/netfilter/nft_reject_inet.c
index 973fa31a9dd6c..49020e67304ad 100644
--- a/net/netfilter/nft_reject_inet.c
+++ b/net/netfilter/nft_reject_inet.c
@@ -61,8 +61,7 @@ static void nft_reject_inet_eval(const struct nft_expr *expr,
 }
 
 static int nft_reject_inet_validate(const struct nft_ctx *ctx,
-				    const struct nft_expr *expr,
-				    const struct nft_data **data)
+				    const struct nft_expr *expr)
 {
 	return nft_chain_validate_hooks(ctx->chain,
 					(1 << NF_INET_LOCAL_IN) |
diff --git a/net/netfilter/nft_reject_netdev.c b/net/netfilter/nft_reject_netdev.c
index 7865cd8b11bb6..2558ce1505d98 100644
--- a/net/netfilter/nft_reject_netdev.c
+++ b/net/netfilter/nft_reject_netdev.c
@@ -145,8 +145,7 @@ static void nft_reject_netdev_eval(const struct nft_expr *expr,
 }
 
 static int nft_reject_netdev_validate(const struct nft_ctx *ctx,
-				      const struct nft_expr *expr,
-				      const struct nft_data **data)
+				      const struct nft_expr *expr)
 {
 	return nft_chain_validate_hooks(ctx->chain, (1 << NF_NETDEV_INGRESS));
 }
diff --git a/net/netfilter/nft_rt.c b/net/netfilter/nft_rt.c
index 2434c624aafde..9525f1e02a7d8 100644
--- a/net/netfilter/nft_rt.c
+++ b/net/netfilter/nft_rt.c
@@ -160,8 +160,7 @@ static int nft_rt_get_dump(struct sk_buff *skb,
 	return -1;
 }
 
-static int nft_rt_validate(const struct nft_ctx *ctx, const struct nft_expr *expr,
-			   const struct nft_data **data)
+static int nft_rt_validate(const struct nft_ctx *ctx, const struct nft_expr *expr)
 {
 	const struct nft_rt *priv = nft_expr_priv(expr);
 	unsigned int hooks;
diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index 187b667bad6c3..35d0409b00950 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -275,8 +275,7 @@ static bool nft_socket_reduce(struct nft_regs_track *track,
 }
 
 static int nft_socket_validate(const struct nft_ctx *ctx,
-			       const struct nft_expr *expr,
-			       const struct nft_data **data)
+			       const struct nft_expr *expr)
 {
 	if (ctx->family != NFPROTO_IPV4 &&
 	    ctx->family != NFPROTO_IPV6 &&
diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index 1d737f89dfc18..5d3e518259859 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -248,8 +248,7 @@ static void nft_synproxy_eval(const struct nft_expr *expr,
 }
 
 static int nft_synproxy_validate(const struct nft_ctx *ctx,
-				 const struct nft_expr *expr,
-				 const struct nft_data **data)
+				 const struct nft_expr *expr)
 {
 	if (ctx->family != NFPROTO_IPV4 &&
 	    ctx->family != NFPROTO_IPV6 &&
diff --git a/net/netfilter/nft_tproxy.c b/net/netfilter/nft_tproxy.c
index 71412adb73d41..ed344af2a439b 100644
--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -313,8 +313,7 @@ static int nft_tproxy_dump(struct sk_buff *skb,
 }
 
 static int nft_tproxy_validate(const struct nft_ctx *ctx,
-			       const struct nft_expr *expr,
-			       const struct nft_data **data)
+			       const struct nft_expr *expr)
 {
 	if (ctx->family != NFPROTO_IPV4 &&
 	    ctx->family != NFPROTO_IPV6 &&
diff --git a/net/netfilter/nft_xfrm.c b/net/netfilter/nft_xfrm.c
index 1c866757db552..8a07b46cc8fb7 100644
--- a/net/netfilter/nft_xfrm.c
+++ b/net/netfilter/nft_xfrm.c
@@ -229,8 +229,7 @@ static int nft_xfrm_get_dump(struct sk_buff *skb,
 	return 0;
 }
 
-static int nft_xfrm_validate(const struct nft_ctx *ctx, const struct nft_expr *expr,
-			     const struct nft_data **data)
+static int nft_xfrm_validate(const struct nft_ctx *ctx, const struct nft_expr *expr)
 {
 	const struct nft_xfrm *priv = nft_expr_priv(expr);
 	unsigned int hooks;
-- 
2.51.0



