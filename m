Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210758;
	b=eKLvHpy1D9sk5Gfg+xpil6GG9fBXXJnSRhuaVFVBeArlPwyUyRk1+A2LPrQzN0MHDVhs
	 nX6SKRiO9bj7lauUJ8FzbHWZ1iCjmxEVzLivsL+I1fCTux1pLbgmuTJeYI3jDLMf+3HES
	 OEmUGFYLVS7MkIxrfEE3kLYCP/ZybJQiNGN0uHV+eAKLnHBn5Ezwfi+ozFRYPQ3MydyCQ
	 RGKF2B1ZdNDqNJ6Xexx/+R3UoUfvDEbMDxOALJx4VBpkTECrnMNgWKsHB+VlHU20VTSe8
	 iflCVqv++Huos/yhm5G+asFe9bc31qELOnG/wnAD+OZbTqlIKawIKhc9xUcBMFm9uVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210758;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y011cFZ1E2+1G75biMlbcGUp57R2m/aZYACYmuhJ1EA=;
	b=kkJFmQIejoe6r1pjFYun2cNPJE6IFAPuzM9+2ZINYSy5q1SddzQrhLZu9ay6CEOYkrL5
	 RDmy2Va8FNMYNOWJMhae+a5akPkoWKxX+kViNXZqYb/b3uevykDzCscU8SIdrWz9Fs3MC
	 tUn7kTyR39yln449UZXv29sEGo5CSlv5hULOub7pokcUGgR0lyIGR5ahIwjDhtKlrMZzd
	 /XJPlqnxdP4EraZgy7naUE/2yNy0XBwjInQPSIixgBGtObUTBIMurGpX/HWBCU9Nh2N+Y
	 Q0aGntn7RpEtMNKlL1HMTxRuH1Hif8FTYy89H79Sr+sQPYsTbs1QKlsnErOiBLu8rWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kUKWC9yW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DB8606A31D;
	Wed, 28 Oct 2026 18:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kUKWC9yW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19131F01825;
	Wed, 28 Oct 2026 18:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210757;
	bh=y011cFZ1E2+1G75biMlbcGUp57R2m/aZYACYmuhJ1EA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kUKWC9yWzevcabsoma9r9fLINILXHWPmYqPBwk3kmHKLWNTx7cTxU2Tj5yTmRFDML
	 QtcXiHRBO4Q83pV7vKoBdIjTu8g4nYeF4Q7Xj+G19OwdPmQKl/jf9rAmZfxMl4NAFI
	 PjhrKedpxg1q5bUSG+x285zivmEY0+gnPqjl1PEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TencentOS Corvus AI <corvus@tencent.com>,
	Aohan Mei <henrymei@tencent.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 139/571] netfilter: nft_flow_offload: drop flowtable reference on init error path
Date: Wed, 28 Oct 2026 17:54:46 +0100
Message-ID: <20261028170011.315034006@linuxfoundation.org>
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
@@ -394,6 +394,7 @@ static int nft_flow_offload_init(const s
 	struct nft_flow_offload *priv = nft_expr_priv(expr);
 	u8 genmask = nft_genmask_next(ctx->net);
 	struct nft_flowtable *flowtable;
+	int err;
 
 	if (!tb[NFTA_FLOW_TABLE_NAME])
 		return -EINVAL;
@@ -408,7 +409,11 @@ static int nft_flow_offload_init(const s
 
 	priv->flowtable = flowtable;
 
-	return nf_ct_netns_get(ctx->net, ctx->family);
+	err = nf_ct_netns_get(ctx->net, ctx->family);
+	if (err < 0)
+		nft_use_dec(&flowtable->use);
+
+	return err;
 }
 
 static void nft_flow_offload_deactivate(const struct nft_ctx *ctx,


