Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7F238A73B;
	Tue, 10 Mar 2026 11:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142069; cv=none; b=AsKsM7x2s1d1eC1D+gHuRdk218Tg0kloAVnMzgK1J++kpuHolAZZXIrD1WwxLb5nepdgKxYdQNFddKFf4AkAp5M7QamDq1lEK+Ek+XHBaTuBloS2s45hfjHEjGqHZ8CKLnWHytSUgxKfGS5E+mK04w+NQOOg5FwnZ9IiraavT0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142069; c=relaxed/simple;
	bh=x2Axq/3908O+8x+ncLAiQR7DiOYEnpGzrmIlo4rUxAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tIpu1saCIAJ/MbsK0L6snuec5qedKJGZVEXCrWkGjs/ZpIfyTEXk2S0F4W6QOgC/TuYTlDA+LjXMc4go78XOSWrqABeB05i8vZEzpkqFzHIenkhpNyYZzLTkumuCmuIWiMkpqZpMst003dmrVVpoMrms72Z+ysx8EypcAcMvhbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OE8B8zVm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OE8B8zVm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8733C2BC86;
	Tue, 10 Mar 2026 11:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142069;
	bh=x2Axq/3908O+8x+ncLAiQR7DiOYEnpGzrmIlo4rUxAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OE8B8zVm+h2IkJj/tN/Ui52Ho7XSybnHRONEFpxdWgTomFBKhZiVZjq6rCJpA5ElD
	 HTOPD9u/gH8yGG/8a8mZE7/3Jci7HbjLmZ+dMRkB19FtnC9Ip3JiUwohtGnfyF4ITR
	 gfw2LY53+PxCd4sP7n5NFbbFeVnRZwwbw7V97qgp84MegixBodZccUtYfV1kFl3cXc
	 tDJvcQjgHqOoHuxzugBEjAIcnpMUtuzvVOkAZeYu50LKET3X2m/4Qpg5c9BdJMO+55
	 QS13DmiEvvQjCz1qqCmeTfLvX6RzxiUDXdz21NfnF3CBq6F8UM7aahl/+xm3O5omdn
	 S1j796ku2tqWw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.18 195/314] Revert "netfilter: nft_set_rbtree: validate open interval overlap"
Date: Tue, 10 Mar 2026 07:17:34 -0400
Message-ID: <507e002b1c7ae7f1a9a3da924837f11eecc081e1.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 12b1681793e9b7552495290785a3570c539f409d which is
commit 648946966a08e4cb1a71619e3d1b12bd7642de7b upstream.

It is causing netfilter issues, so revert it for now.

Link: https://lore.kernel.org/r/aaeEd8UqYQ33Af7_@chamomile
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_tables.h |  4 --
 net/netfilter/nf_tables_api.c     | 21 ++-------
 net/netfilter/nft_set_rbtree.c    | 71 +++++--------------------------
 3 files changed, 14 insertions(+), 82 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 05f57ba622447..f1b67b40dd4de 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -278,8 +278,6 @@ struct nft_userdata {
 	unsigned char		data[];
 };
 
-#define NFT_SET_ELEM_INTERNAL_LAST	0x1
-
 /* placeholder structure for opaque set element backend representation. */
 struct nft_elem_priv { };
 
@@ -289,7 +287,6 @@ struct nft_elem_priv { };
  *	@key: element key
  *	@key_end: closing element key
  *	@data: element data
- * 	@flags: flags
  *	@priv: element private data and extensions
  */
 struct nft_set_elem {
@@ -305,7 +302,6 @@ struct nft_set_elem {
 		u32		buf[NFT_DATA_VALUE_MAXLEN / sizeof(u32)];
 		struct nft_data val;
 	} data;
-	u32			flags;
 	struct nft_elem_priv	*priv;
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d4babc4d3bff3..89039bbf7d638 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7272,8 +7272,7 @@ static u32 nft_set_maxsize(const struct nft_set *set)
 }
 
 static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
-			    const struct nlattr *attr, u32 nlmsg_flags,
-			    bool last)
+			    const struct nlattr *attr, u32 nlmsg_flags)
 {
 	struct nft_expr *expr_array[NFT_SET_EXPR_MAX] = {};
 	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
@@ -7559,11 +7558,6 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (flags)
 		*nft_set_ext_flags(ext) = flags;
 
-	if (last)
-		elem.flags = NFT_SET_ELEM_INTERNAL_LAST;
-	else
-		elem.flags = 0;
-
 	if (obj)
 		*nft_set_ext_obj(ext) = obj;
 
@@ -7727,8 +7721,7 @@ static int nf_tables_newsetelem(struct sk_buff *skb,
 	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
-		err = nft_add_set_elem(&ctx, set, attr, info->nlh->nlmsg_flags,
-				       nla_is_last(attr, rem));
+		err = nft_add_set_elem(&ctx, set, attr, info->nlh->nlmsg_flags);
 		if (err < 0) {
 			NL_SET_BAD_ATTR(extack, attr);
 			return err;
@@ -7852,7 +7845,7 @@ static void nft_trans_elems_destroy_abort(const struct nft_ctx *ctx,
 }
 
 static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
-			   const struct nlattr *attr, bool last)
+			   const struct nlattr *attr)
 {
 	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
 	struct nft_set_ext_tmpl tmpl;
@@ -7920,11 +7913,6 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	if (flags)
 		*nft_set_ext_flags(ext) = flags;
 
-	if (last)
-		elem.flags = NFT_SET_ELEM_INTERNAL_LAST;
-	else
-		elem.flags = 0;
-
 	trans = nft_trans_elem_alloc(ctx, NFT_MSG_DELSETELEM, set);
 	if (trans == NULL)
 		goto fail_trans;
@@ -8072,8 +8060,7 @@ static int nf_tables_delsetelem(struct sk_buff *skb,
 		return nft_set_flush(&ctx, set, genmask);
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
-		err = nft_del_setelem(&ctx, set, attr,
-				      nla_is_last(attr, rem));
+		err = nft_del_setelem(&ctx, set, attr);
 		if (err == -ENOENT &&
 		    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYSETELEM)
 			continue;
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 644d4b9167057..a4fb5b517d9de 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -304,19 +304,10 @@ static void nft_rbtree_set_start_cookie(struct nft_rbtree *priv,
 	priv->start_rbe_cookie = (unsigned long)rbe;
 }
 
-static void nft_rbtree_set_start_cookie_open(struct nft_rbtree *priv,
-					     const struct nft_rbtree_elem *rbe,
-					     unsigned long open_interval)
-{
-	priv->start_rbe_cookie = (unsigned long)rbe | open_interval;
-}
-
-#define NFT_RBTREE_OPEN_INTERVAL	1UL
-
 static bool nft_rbtree_cmp_start_cookie(struct nft_rbtree *priv,
 					const struct nft_rbtree_elem *rbe)
 {
-	return (priv->start_rbe_cookie & ~NFT_RBTREE_OPEN_INTERVAL) == (unsigned long)rbe;
+	return priv->start_rbe_cookie == (unsigned long)rbe;
 }
 
 static bool nft_rbtree_insert_same_interval(const struct net *net,
@@ -346,14 +337,13 @@ static bool nft_rbtree_insert_same_interval(const struct net *net,
 
 static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			       struct nft_rbtree_elem *new,
-			       struct nft_elem_priv **elem_priv, u64 tstamp, bool last)
+			       struct nft_elem_priv **elem_priv, u64 tstamp)
 {
 	struct nft_rbtree_elem *rbe, *rbe_le = NULL, *rbe_ge = NULL, *rbe_prev;
 	struct rb_node *node, *next, *parent, **p, *first = NULL;
 	struct nft_rbtree *priv = nft_set_priv(set);
 	u8 cur_genmask = nft_genmask_cur(net);
 	u8 genmask = nft_genmask_next(net);
-	unsigned long open_interval = 0;
 	int d;
 
 	/* Descend the tree to search for an existing element greater than the
@@ -459,18 +449,10 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 		}
 	}
 
-	if (nft_rbtree_interval_null(set, new)) {
+	if (nft_rbtree_interval_null(set, new))
+		priv->start_rbe_cookie = 0;
+	else if (nft_rbtree_interval_start(new) && priv->start_rbe_cookie)
 		priv->start_rbe_cookie = 0;
-	} else if (nft_rbtree_interval_start(new) && priv->start_rbe_cookie) {
-		if (nft_set_is_anonymous(set)) {
-			priv->start_rbe_cookie = 0;
-		} else if (priv->start_rbe_cookie & NFT_RBTREE_OPEN_INTERVAL) {
-			/* Previous element is an open interval that partially
-			 * overlaps with an existing non-open interval.
-			 */
-			return -ENOTEMPTY;
-		}
-	}
 
 	/* - new start element matching existing start element: full overlap
 	 *   reported as -EEXIST, cleared by caller if NLM_F_EXCL is not given.
@@ -478,27 +460,7 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	if (rbe_ge && !nft_rbtree_cmp(set, new, rbe_ge) &&
 	    nft_rbtree_interval_start(rbe_ge) == nft_rbtree_interval_start(new)) {
 		*elem_priv = &rbe_ge->priv;
-
-		/* - Corner case: new start element of open interval (which
-		 *   comes as last element in the batch) overlaps the start of
-		 *   an existing interval with an end element: partial overlap.
-		 */
-		node = rb_first(&priv->root);
-		rbe = __nft_rbtree_next_active(node, genmask);
-		if (rbe && nft_rbtree_interval_end(rbe)) {
-			rbe = nft_rbtree_next_active(rbe, genmask);
-			if (rbe &&
-			    nft_rbtree_interval_start(rbe) &&
-			    !nft_rbtree_cmp(set, new, rbe)) {
-				if (last)
-					return -ENOTEMPTY;
-
-				/* Maybe open interval? */
-				open_interval = NFT_RBTREE_OPEN_INTERVAL;
-			}
-		}
-		nft_rbtree_set_start_cookie_open(priv, rbe_ge, open_interval);
-
+		nft_rbtree_set_start_cookie(priv, rbe_ge);
 		return -EEXIST;
 	}
 
@@ -553,12 +515,6 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 	    nft_rbtree_interval_end(rbe_ge) && nft_rbtree_interval_end(new))
 		return -ENOTEMPTY;
 
-	/* - start element overlaps an open interval but end element is new:
-	 *   partial overlap, reported as -ENOEMPTY.
-	 */
-	if (!rbe_ge && priv->start_rbe_cookie && nft_rbtree_interval_end(new))
-		return -ENOTEMPTY;
-
 	/* Accepted element: pick insertion point depending on key value */
 	parent = NULL;
 	p = &priv->root.rb_node;
@@ -668,7 +624,6 @@ static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			     struct nft_elem_priv **elem_priv)
 {
 	struct nft_rbtree_elem *rbe = nft_elem_priv_cast(elem->priv);
-	bool last = !!(elem->flags & NFT_SET_ELEM_INTERNAL_LAST);
 	struct nft_rbtree *priv = nft_set_priv(set);
 	u64 tstamp = nft_net_tstamp(net);
 	int err;
@@ -685,12 +640,8 @@ static int nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 		cond_resched();
 
 		write_lock_bh(&priv->lock);
-		err = __nft_rbtree_insert(net, set, rbe, elem_priv, tstamp, last);
+		err = __nft_rbtree_insert(net, set, rbe, elem_priv, tstamp);
 		write_unlock_bh(&priv->lock);
-
-		if (nft_rbtree_interval_end(rbe))
-			priv->start_rbe_cookie = 0;
-
 	} while (err == -EAGAIN);
 
 	return err;
@@ -778,7 +729,6 @@ nft_rbtree_deactivate(const struct net *net, const struct nft_set *set,
 		      const struct nft_set_elem *elem)
 {
 	struct nft_rbtree_elem *rbe, *this = nft_elem_priv_cast(elem->priv);
-	bool last = !!(elem->flags & NFT_SET_ELEM_INTERNAL_LAST);
 	struct nft_rbtree *priv = nft_set_priv(set);
 	const struct rb_node *parent = priv->root.rb_node;
 	u8 genmask = nft_genmask_next(net);
@@ -819,10 +769,9 @@ nft_rbtree_deactivate(const struct net *net, const struct nft_set *set,
 				continue;
 			}
 
-			if (nft_rbtree_interval_start(rbe)) {
-				if (!last)
-					nft_rbtree_set_start_cookie(priv, rbe);
-			} else if (!nft_rbtree_deactivate_same_interval(net, priv, rbe))
+			if (nft_rbtree_interval_start(rbe))
+				nft_rbtree_set_start_cookie(priv, rbe);
+			else if (!nft_rbtree_deactivate_same_interval(net, priv, rbe))
 				return NULL;
 
 			nft_rbtree_flush(net, set, &rbe->priv);
-- 
2.51.0

