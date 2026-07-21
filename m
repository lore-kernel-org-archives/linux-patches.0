Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B4F3B4EAC;
	Tue, 21 Jul 2026 18:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657808; cv=none; b=EHNx0nIRx0qx+4jVmOLPFmj3J43We+dFIN2v7ThqwQr6uT7h3TGm+Bh81ndhAgjxprr/T6toS8mVhWCrafvQUomFXHdUBEP64DEYL+OnY/xZyoXtgF1tKog2eVVQ3tt4EcdK6SzcNk7Mc9xhA5RhQpjc7zinkse9ug2LCV/fR5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657808; c=relaxed/simple;
	bh=+ldyIAgtSDpj98fIuYmOrWG8hVDCxQ6l/aSVn+Txm3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CBDE9+NNp7XBCbbRZkchirPTdSa5QUkSeS7OwxB1d4JEXfIQhw4YEw67pYz02GFj21NxN1p3zhO2zEwFZ3p9cCPAW4Rgzmd0S2F0cGiVOgxkpfWYAlo+jv8VwS4zJAKcA0FdoPTOjq4Az4nUAeSjwH5p1D52c8GR8ZKxpjMlV4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DEV4DP/F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DEV4DP/F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D079C1F00A3E;
	Tue, 21 Jul 2026 18:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657807;
	bh=bKOd7JVfaeXb+G++t1Wpln8hP3++4dvQmWRl0qpKhzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DEV4DP/FBLKDsv+nEEZ6YqVfNK7nJaeWC3tk7QWFSxjwshXvt/2wwSsb5QalNWdv/
	 on8S9IRSS7beQCZTLRWZHUR1K2Es2TXb1WN98u4fFAe4tirCy8y0wjHIUh/LP7LFNx
	 w4Op/23sGEI5hlxxXfK83HQarwZWo/3OCXnKaszQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ren Wei <n05ec@lzu.edu.cn>,
	Wyatt Feng <bronzed_45_vested@icloud.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0905/1611] netfilter: nft_compat: ebtables emulation must reject non-bridge targets
Date: Tue, 21 Jul 2026 17:17:01 +0200
Message-ID: <20260721152535.746754619@linuxfoundation.org>
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

[ Upstream commit 9dbba7e694ec045f21ede2f892fb42b81b4e1692 ]

xtables targets return netfilter verdicts: NF_ACCEPT, NF_DROP, and so
on.  ebtables targets return incompatible verdicts: EBT_ACCEPT,
EBT_DROP, ...   We cannot allow fallback to NFPROTO_UNSPEC.

ebtables doesn't permit this since
11ff7288beb2 ("netfilter: ebtables: reject non-bridge targets")
but that commit missed the nft_compat layer.

Reported-by: Ren Wei <n05ec@lzu.edu.cn>
Reported-by: Wyatt Feng <bronzed_45_vested@icloud.com>
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_compat.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 08f620311b03f1..a77ffe2fcea75e 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -389,6 +389,22 @@ static int nft_target_validate(const struct nft_ctx *ctx,
 	return 0;
 }
 
+static int nft_target_bridge_validate(const struct nft_ctx *ctx,
+				      const struct nft_expr *expr)
+{
+	struct xt_target *target = expr->ops->data;
+
+	/* Do not allow UNSPEC to stand-in for NFPROTO_BRIDGE
+	 * targets: they are incompatible.  ebtables targets return
+	 * EBT_ACCEPT, DROP and so on which are not compatible with
+	 * NF_ACCEPT, NF_DROP and so on.
+	 */
+	if (target->family != NFPROTO_BRIDGE)
+		return -ENOENT;
+
+	return nft_target_validate(ctx, expr);
+}
+
 static void __nft_match_eval(const struct nft_expr *expr,
 			     struct nft_regs *regs,
 			     const struct nft_pktinfo *pkt,
@@ -916,14 +932,16 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	ops->init = nft_target_init;
 	ops->destroy = nft_target_destroy;
 	ops->dump = nft_target_dump;
-	ops->validate = nft_target_validate;
 	ops->data = target;
 	ops->reduce = NFT_REDUCE_READONLY;
 
-	if (family == NFPROTO_BRIDGE)
+	if (family == NFPROTO_BRIDGE) {
 		ops->eval = nft_target_eval_bridge;
-	else
+		ops->validate = nft_target_bridge_validate;
+	} else {
 		ops->eval = nft_target_eval_xt;
+		ops->validate = nft_target_validate;
+	}
 
 	return ops;
 err:
-- 
2.53.0



