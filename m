Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209529;
	b=cXBpm6UkhEgO4R4a1QgXEevQgUPpVLsPh12fwCm8QqxCwbl7/t+FMdo2/dIb0CnzEJRe
	 yduHvbEc/3YjzcW/DDohQMf78Q3B7vxDCybyMRTe7YYrqWpnyenfuNpn3bQGnP4FEjzsa
	 Y1aLUBg7YZecN92f/usqGb1+w0dtYQlgRaJLKtYMMG4E21QYYYmatpjL5ktmLKbD+2UgR
	 zF91jDzRVDuW7GvWjINODcqtMVMChUkYhd3FQQGql2z6SKbFPhAM2AAD7OUGJf28rMHu4
	 j74LVpC/fwnUwe0adOrVzGBpzNMEfqTb83phScD0KVVv1G/flYClAuU4TTzJEeMmF/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209529;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qSDh4UtPXQ84GmPdoNry5/sWFpoFqR39IEid0diq768=;
	b=CX3s/W2Tj6AlBOsT8OSUwg88R91tP13Yqu60iuGVDp4+3uUHqVWeMBXjlFLOw1FBtyMO
	 vhIDd9SatCz6dm0NrZ5LYf68Ek63R8O0I5PRrtPbQuQ2YBav1exFyHOLC/Vh8P2eWUUE+
	 Meb5pekXp/+N+NbovYrD+uiUPU2AqwKTh/7Y/Pn3hZOGXZu8rM2BdEzKQwL/UcSrQvcDP
	 Z7VcvWTklbbYPA1XlJ25Ff++NAP+mc02wyOPvsZUTFBRGxyaHasm9cACH5bdJ0sVjX66Z
	 bMzmFN9NLTR0dmftMH+EbzkBlzsNE8SdOgy/BbslkCWMj7W2Hb9j5g/YybmxDF0wetA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L09JrY4I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62C4606A31A;
	Wed, 28 Oct 2026 17:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L09JrY4I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C441F01825;
	Wed, 28 Oct 2026 17:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209528;
	bh=qSDh4UtPXQ84GmPdoNry5/sWFpoFqR39IEid0diq768=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L09JrY4IoLpULzSDhGxzp/ONwKUbZh4Su6SuoR2LWgabJ4Vb3RvLkqW5uQqR+3/uz
	 6ndc3h7sFWAIP3B+C5dgB5OdjIFG/s9yWIpogl5Ethj9ccmWaK/w03Rd+YlZ4rC8z1
	 xaUUjHGnZ5qHUUsnih7dp7yDoFSUvw+xhAyTQ6tY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Inseo An <y0un9sa@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Steffen Pfendtner <steffen.pfendtner@kernelscan.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 502/516] netfilter: nf_tables: unconditionally bump set->nelems before insertion
Date: Wed, 28 Oct 2026 18:00:54 +0100
Message-ID: <20261028170015.369779699@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit def602e498a4f951da95c95b1b8ce8ae68aa733a ]

In case that the set is full, a new element gets published then removed
without waiting for the RCU grace period, while RCU reader can be
walking over it already.

To address this issue, add the element transaction even if set is full,
but toggle the set_full flag to report -ENFILE so the abort path safely
unwinds the set to its previous state.

As for element updates, decrement set->nelems to restore it.

A simpler fix is to call synchronize_rcu() in the error path.
However, with a large batch adding elements to already maxed-out set,
this could cause noticeable slowdown of such batches.

Fixes: 35d0ac9070ef ("netfilter: nf_tables: fix set->nelems counting with no NLM_F_EXCL")
Reported-by: Inseo An <y0un9sa@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
[ Backport to 5.10.y: applies on top of d4b7f29eb85c ("netfilter:
  nf_tables: always increment set element count"), as in 6.1.y. 5.10
  has neither the nft_set_maxsize() helper (8d738c1869f6) nor the
  NFT_SET_ELEM_CATCHALL element class, so the ceiling is the same
  expression the prerequisite inlines, set->size ? set->size +
  set->ndeact : UINT_MAX, and every element is counted. On the
  full-set path the element is left in the transaction and unwound by
  the abort path, which removes it, decrements nelems and frees it only
  after synchronize_rcu(), instead of the in-place set->ops->remove()
  this replaces. The update-path hunk from the upstream commit does not
  apply: 5.10 has no in-place element-update path here. ]
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 867b5e152d677..cde499274fd37 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5596,6 +5596,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_data_desc desc;
 	enum nft_registers dreg;
 	struct nft_trans *trans;
+	unsigned int max, nelems;
+	bool set_full = false;
 	u32 flags = 0;
 	u64 timeout;
 	u64 expiration;
@@ -5806,10 +5808,15 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		goto err_elem_expr;
 	expr = NULL;
 
+	max = set->size ? set->size + set->ndeact : UINT_MAX;
+	nelems = atomic_inc_return(&set->nelems);
+	if (nelems > max)
+		set_full = true;
+
 	trans = nft_trans_elem_alloc(ctx, NFT_MSG_NEWSETELEM, set);
 	if (trans == NULL) {
 		err = -ENOMEM;
-		goto err_elem_expr;
+		goto err_set_size;
 	}
 
 	ext->genmask = nft_genmask_cur(ctx->net);
@@ -5841,20 +5848,15 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		goto err_element_clash;
 	}
 
-	if (!atomic_add_unless(&set->nelems, 1,
-			       set->size ? set->size + set->ndeact : UINT_MAX)) {
-		err = -ENFILE;
-		goto err_set_full;
-	}
-
 	nft_trans_elem(trans) = elem;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
-	return 0;
 
-err_set_full:
-	set->ops->remove(ctx->net, set, &elem);
+	return set_full ? -ENFILE : 0;
+
 err_element_clash:
 	kfree(trans);
+err_set_size:
+	atomic_dec(&set->nelems);
 err_elem_expr:
 	nf_tables_set_elem_destroy(ctx, set, elem.priv);
 err_parse_data:
-- 
2.53.0



