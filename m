Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211944;
	b=qIWJ5yeuFKo7hSAA3MLb+R6B4EZsmRVNPKvlTnsJ2hme9FYj1XPnGPF5lzd2Uigaaffr
	 Hg+P92k8UqB0H3lYqFlIR04bgLWWOpK+2oHN4l4D2fOBOHW6odynnVoN5nMKbIvhq+25n
	 /PNe1wi+WAaDIhsoMFWvz0yyWh/YiMoPd91U25nMpMzEzfq52hc8U+gsvstsO90w3PVx1
	 o0i5px3g+hFG/49c/J1dpR14FtxYXVxL1VlriRDqEastbq9SKhnK/vyx0Uuyj/6sGNa71
	 I/Yisje1GTGR55G59x1rIGVl9Yd/zZmUVgG5N0I9Jrsi+sodKS1Zj1KWrF46t3SjDTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211944;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p1DvK5w7yidq51jZNM8fwTRLHGgFtxfFpRpvIfmGwIQ=;
	b=YC/EIGc07+vlOmrq/FRQNs4aB4q96E7F9IhcRf2H5bJOEJCIgqc3tDHpZvJYfGPwcEr7
	 7SqHJM5uyr454cClAb+lGJzkzib9zAMuT//7CozUvWVCVa9kx1F3W0rSmc+R9LpLpC38f
	 GJ/JGdwjDtT3ym4mN9hsqQ387tcUplkWYQEFB6CRqYEOqL/qy+X9vp/NLcpg7ZaCleVSa
	 VHxl7GWFSXEwEAj00lySS1Ye/JEGsHFGY1ixTlMJfF2OC/cphPA5TBF1Gta7J1WWCSHYV
	 1J1T424etyyC+Z9LsYfNq7PYcZN4vBCodtLjwqxZXMzqWD66YNLJGRCNTDAv9h9u6CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EClacsy1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DE1606A31C;
	Wed, 28 Oct 2026 18:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EClacsy1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C989C1F01825;
	Wed, 28 Oct 2026 18:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211943;
	bh=p1DvK5w7yidq51jZNM8fwTRLHGgFtxfFpRpvIfmGwIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EClacsy1lpKfwhg+j7xTPLVcKjzK5Up6gLwhqwdFwKVtf/2UuUG4ky+WYuTpS7XLA
	 g8nCTl6QuPAT7Me6qIciQMX+gmDLaP7fRJoV7F6VMK9VEWGGoOC+Yft3tMnp3IAFVD
	 PpGm3fLQ1XoAacfVE3vshnW1LTPP7fhMus7ZqVJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Inseo An <y0un9sa@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Steffen Pfendtner <steffen.pfendtner@kernelscan.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 553/571] netfilter: nf_tables: unconditionally bump set->nelems before insertion
Date: Wed, 28 Oct 2026 18:01:40 +0100
Message-ID: <20261028170021.158121392@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ Backport to 5.15.y: applies on top of d4b7f29eb85c ("netfilter:
  nf_tables: always increment set element count"), as in 6.1.y. 5.15
  has no nft_set_maxsize() helper (introduced by 8d738c1869f6
  "netfilter: nf_tables: fix set size with rbtree backend", not in
  5.15), so the ceiling is the same expression the prerequisite inlines:
  set->size ? set->size + set->ndeact : UINT_MAX. The update-path hunk
  from the upstream commit does not apply: 5.15 has no in-place
  element-update path here. ]
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c |   29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6261,6 +6261,7 @@ static int nft_add_set_elem(struct nft_c
 	enum nft_registers dreg;
 	struct nft_trans *trans;
 	void *elem_priv;
+	bool set_full = false;
 	u64 timeout;
 	u64 expiration;
 	int err, i;
@@ -6547,10 +6548,19 @@ static int nft_add_set_elem(struct nft_c
 	if (err < 0)
 		goto err_elem_expr;
 
+	if (!(flags & NFT_SET_ELEM_CATCHALL)) {
+		unsigned int max = set->size ? set->size + set->ndeact : UINT_MAX;
+		unsigned int nelems;
+
+		nelems = atomic_inc_return(&set->nelems);
+		if (nelems > max)
+			set_full = true;
+	}
+
 	trans = nft_trans_elem_alloc(ctx, NFT_MSG_NEWSETELEM, set);
 	if (trans == NULL) {
 		err = -ENOMEM;
-		goto err_elem_expr;
+		goto err_set_size;
 	}
 
 	ext->genmask = nft_genmask_cur(ctx->net);
@@ -6583,23 +6593,16 @@ static int nft_add_set_elem(struct nft_c
 		goto err_element_clash;
 	}
 
-	if (!(flags & NFT_SET_ELEM_CATCHALL)) {
-		unsigned int max = set->size ? set->size + set->ndeact : UINT_MAX;
-
-		if (!atomic_add_unless(&set->nelems, 1, max)) {
-			err = -ENFILE;
-			goto err_set_full;
-		}
-	}
-
 	nft_trans_elem(trans) = elem;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
-	return 0;
 
-err_set_full:
-	nft_setelem_remove(ctx->net, set, &elem);
+	return set_full ? -ENFILE : 0;
+
 err_element_clash:
 	kfree(trans);
+err_set_size:
+	if (!(flags & NFT_SET_ELEM_CATCHALL))
+		atomic_dec(&set->nelems);
 err_elem_expr:
 	nf_tables_set_elem_destroy(ctx, set, elem.priv);
 err_parse_data:


