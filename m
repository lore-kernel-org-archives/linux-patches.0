Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777EA2E63B
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4BBFC433C9;
	Wed, 20 Sep 2023 12:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211815;
	bh=2Mphd1WoRtpR3HujuCbxZTgVX5h+R5BkDlU8NPsjj90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S2oKX3dnCZoPp3TYqhnCvjY6jS4q/g2/RxuYreKtVGPdA/nqw6h6Q2akm15cJQBCi
	 ON+L3O0EmwUzWTZXYnaupazB4TuaxEOPar7ZoCfG1sLNmj+djYP3PGgNuiDSMGXQtM
	 mn4p7QRitZIGA8no8tMEO93CmnxjtkodYF033rvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wenxu <wenxu@ucloud.cn>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 046/273] netfilter: nft_flow_offload: fix underflow in flowtable reference counter
Date: Wed, 20 Sep 2023 13:28:06 +0200
Message-ID: <20230920112847.839984406@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wenxu <wenxu@ucloud.cn>

commit 8ca79606cdfde2e37ee4f0707b9d1874a6f0eb38 upstream.

The .deactivate and .activate interfaces already deal with the reference
counter. Otherwise, this results in spurious "Device is busy" errors.

Fixes: a3c90f7a2323 ("netfilter: nf_tables: flow offload expression")
Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_flow_offload.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -197,9 +197,6 @@ static void nft_flow_offload_activate(co
 static void nft_flow_offload_destroy(const struct nft_ctx *ctx,
 				     const struct nft_expr *expr)
 {
-	struct nft_flow_offload *priv = nft_expr_priv(expr);
-
-	priv->flowtable->use--;
 	nf_ct_netns_put(ctx->net, ctx->family);
 }
 


