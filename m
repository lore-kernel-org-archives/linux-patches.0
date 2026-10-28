Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208650;
	b=Kjwoc/wm56IpqnNElD6YNUV7Zz6dGzL8CV+bYG+jxTLu7DgMs8vRBdsX2SAaxBwJiueu
	 1grdRHMG9WDHXtX8GTcCzsVFKZW0ZdQJgKOKkAlIfmPHSxxuvR3xUVpg8rYIwKeWNHZ0N
	 nk6E0Gls/6HYGeen+QRL6m2XWtNXAAoiBS2qjrci+xDkIvk9DaDw+ZpM3nOVSwYea0h1P
	 vCAx2/uvQKOucnlRhZkcISI2yODKD3mKL8IRk+FttCRcdRtcbO6zbungKthJ2fA56bIQn
	 na1ZyUwCYNLS4gkI5DV+KV8xA1mkcYT2EgcpjF4MDidHJ9GDggGAIARpSYzt0bZhCpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208650;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2/ib+AaOaPE3iGbq0Aini9LA4hsHXaRnTkE4yQF04ME=;
	b=vv7gO3nbN02wb/4tHL5J3jLdUVwoPT5Uv7pX1VMvsjwpqO/NOwKVOC7CQZQRs/b/wx2E
	 JsiYiIvSrRM4Rqb4UuCvtkSe1QG/r1F2xFKpLkOFzZ8gwgCq6LGSFgeKvcLTKxzzah3GN
	 qitu70GrI9bl0mXggnwUMpdRox5KVQLtNuL1TL60f9EoHYOysSLFCeXvA68r5zeLnNkSo
	 xImqWNQVT1yI/veKzWwR71bkMgICEDq1kAa3IiEe+cCjnEXk9yqEIs8r9w8CGaI0elkRS
	 2bqy+Xsi8Bghcp0TaRzsUJbj9bRAT7SVP+8XS/YDQectsmac1qKjlzfUCwt225Vg8SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a2e81R66;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95416606A31A;
	Wed, 28 Oct 2026 17:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a2e81R66
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58BC1F031E0;
	Wed, 28 Oct 2026 17:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208650;
	bh=2/ib+AaOaPE3iGbq0Aini9LA4hsHXaRnTkE4yQF04ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a2e81R66lKjR7KII+lVKn75/6g+JoBtOP1DC+IqTZ9JMSGjkYO1JyRS96TwCp3dPi
	 BrdxBKNIC3w4Yx2P+Qgr8izuew4loJlMTQ/UyAsbEZCD/mvZCdjHczlL3XRxP3+ebG
	 KNeBqKql7WyD/mP2gbHZotHCH+LplsRC9Mohqk9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TencentOS Corvus AI <corvus@tencent.com>,
	Aohan Mei <henrymei@tencent.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 141/516] netfilter: nft_flow_offload: drop flowtable reference on init error path
Date: Wed, 28 Oct 2026 17:54:53 +0100
Message-ID: <20261028170006.849915951@linuxfoundation.org>
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
@@ -170,6 +170,7 @@ static int nft_flow_offload_init(const s
 	struct nft_flow_offload *priv = nft_expr_priv(expr);
 	u8 genmask = nft_genmask_next(ctx->net);
 	struct nft_flowtable *flowtable;
+	int err;
 
 	if (!tb[NFTA_FLOW_TABLE_NAME])
 		return -EINVAL;
@@ -184,7 +185,11 @@ static int nft_flow_offload_init(const s
 
 	priv->flowtable = flowtable;
 
-	return nf_ct_netns_get(ctx->net, ctx->family);
+	err = nf_ct_netns_get(ctx->net, ctx->family);
+	if (err < 0)
+		nft_use_dec(&flowtable->use);
+
+	return err;
 }
 
 static void nft_flow_offload_deactivate(const struct nft_ctx *ctx,


