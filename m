Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212504;
	b=xsM/AlmEI96/rbmDXjSP7Qw7ioNH2brQafTL9zMihxFKtFAnIWPD6zA1rgnC3HrNKqU+
	 jcuEBXuLsFmCGcrDl35NFWi4Re2m6qfJb2Xga17MV17d21swPCxiTEkLD/GRLuFx0f/ml
	 d782TB409gN1z/L07wYL4KNtJRk46B//O4iz/Dilp+iy5aU98eLxKwYnVes3KVtWVYOvz
	 3Hls0x2sohDQiuBmvQj1ZwiU6r3cxelN/kjnqq1lvxm1zNyfaicWb7up9nvrM6GSEKjo4
	 Khb1/GXsnAdtQFr+NufDfnhQ97kyeJ8TDnQsvqLEaKvPxA+7smIcXiiOzw4tszpTz7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212504;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tncit59fb0zzlNzpTTarPYRgUL04EISetxaDSoHT1BM=;
	b=rcvj0u4WC0YmYTzJr6/uRRqLZT5JWL+MUiFKxhDxgA8Bcl0hCT1YVcaO7VzBG81xNOyJ
	 MB8ZLC3l/2GrnqCqOFlcFhulFLw9eT9U1yv7chhmY5OgvCHg5859gfG+Gxi+uxW+hHYfg
	 m16bbXCcxf/86/GIyYllfRB7VfuYZHr0RaLXoMvGOY8HoLNSz85FGBLZmW1ywWCAcj184
	 IIv+gutv0wH0mCo31jxGqHXIhT4DfHJf0NkXh16PRCge9+c8yM2CDWuxgTnPAdZSLGoR9
	 uOIwGRVw+4HA09t4lYOceuRt9h4Jmys/wFOI49uSsYqxNLezHcB8bCEMzUFqg2HmanA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e2wJQt9V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3D5606A31D;
	Wed, 28 Oct 2026 18:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e2wJQt9V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB681F01825;
	Wed, 28 Oct 2026 18:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212504;
	bh=tncit59fb0zzlNzpTTarPYRgUL04EISetxaDSoHT1BM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e2wJQt9V8729Xk5KfBO9qdrWH+u49/tGtyBtt8guBEJ4p7NsEedCn26OtwHamCAQD
	 HBhEF7ruYTL7Der6A12k1vn7Zocq7BDYJwI+tjyOFDcq4CKxiZmXvcnnO5/PRYHUpj
	 QsT9qWqVdm14dqPlzODCSMp74QLJdX6m59vJKupc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TencentOS Corvus AI <corvus@tencent.com>,
	Aohan Mei <henrymei@tencent.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.1 0177/1887] netfilter: nft_flow_offload: drop flowtable reference on init error path
Date: Wed, 28 Oct 2026 17:37:53 +0100
Message-ID: <20261028170503.263570935@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aohan Mei <henrymei@tencent.com>

commit 747928b5d4ff8c8de55138a54c13980e4bb88578 upstream.

nft_flow_offload_init() bumps the flowtable use count with
nft_use_inc() before calling nf_ct_netns_get().  When the latter
fails, the error is returned as-is and the reference is leaked.

The upper layers do not balance it either: nf_tables_newexpr()
clears expr->ops when the expression init callback fails, so the
nft_expr_more() iteration in nft_rule_expr_deactivate() and
nf_tables_rule_destroy() stops right before the failed expression
and its ->destroy callback, which would drop the reference, never
runs.

Each failed rule addition therefore leaks one flowtable reference
and the flowtable can no longer be removed: NFT_MSG_DELFLOWTABLE
keeps reporting -EBUSY even though no rule references it.

Save the nf_ct_netns_get() return value and undo the nft_use_inc()
when it fails, restoring the inc/dec pairing within
nft_flow_offload_init() itself.

Fixes: a3c90f7a2323 ("netfilter: nf_tables: flow offload expression")
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Cc: stable@vger.kernel.org
Assisted-by: CodeBuddy:Kimi-K3
Signed-off-by: Aohan Mei <henrymei@tencent.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_flow_offload.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -416,6 +416,7 @@ static int nft_flow_offload_init(const s
 	struct nft_flow_offload *priv = nft_expr_priv(expr);
 	u8 genmask = nft_genmask_next(ctx->net);
 	struct nft_flowtable *flowtable;
+	int err;
 
 	if (!tb[NFTA_FLOW_TABLE_NAME])
 		return -EINVAL;
@@ -430,7 +431,11 @@ static int nft_flow_offload_init(const s
 
 	priv->flowtable = flowtable;
 
-	return nf_ct_netns_get(ctx->net, ctx->family);
+	err = nf_ct_netns_get(ctx->net, ctx->family);
+	if (err < 0)
+		nft_use_dec(&flowtable->use);
+
+	return err;
 }
 
 static void nft_flow_offload_deactivate(const struct nft_ctx *ctx,


