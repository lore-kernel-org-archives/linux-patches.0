Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215511;
	b=imG9g5fH/RrYYNzPnvx7m9XPR7dmMFWU7yVU53nHGVoynuQ4BGfKLYHaDw4OJO3DDSp7
	 p/qnR9fRpY4GQRK7S02ZBmELKCDHOR6wp5mKq6ui645qrciN3f03l7eijjvyj11i5iH5S
	 +b9RWvPtGTk/+wbr/2d1n9wZIsR5J8+pJ2nCDkK70NlgG5s53fyDlE0qCEjiCWFYa3YAk
	 cWFZ1XM6Jb6zpcedUwEiIWxxKP62VH/duqdeTWMH3Nk4ULsxDOJE3KzryTMyyvQwa1kws
	 +mtOZDCqm0WjjIVhqz4wY66Mp6d8PfpWHjX5DWWA7VZoBiBs1a1mzhTyxCVChbRPzXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215511;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/KmowxCtAgMgmsmBvRChH5gIM8PcrzLnPt5++EQ5R5E=;
	b=Th26vjK2P2PhtrpXdsA5TGTdhFmtB3Q1MjPyWDEFn3rIJabfls4g4po0oXTcTwiSHeHW
	 vLT4qR6Pb+rzlBc0ZmzjAEfkm+tArCPLxI5MPiEBCs0kcove+Kt+IvKnHk4bntVtDjA4+
	 Hj8FOLmitSF/IQYK9a6+fDk+ynOZwT6svQRgAt4vX4LFrEaUDhglkD6AwLGcgjV6/MihI
	 Rv58dJJ7PTWLx6C4b4tJMWchKnmb1/O2UwBF3mUSElE4CEkM7A9aRa/T/h2ZwyMXh0y2Z
	 lCNRFucKqn4zSJAgVb+bFM7nucE+E640F2wjkzqoRpefIy7SKNdvzNv6R9WLexEGECQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j0rmFtOy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831E0606A31D;
	Wed, 28 Oct 2026 19:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j0rmFtOy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82161F01825;
	Wed, 28 Oct 2026 19:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215511;
	bh=/KmowxCtAgMgmsmBvRChH5gIM8PcrzLnPt5++EQ5R5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j0rmFtOyQh3f6eNlbosvEnD3iaxYRwp54Pzwwk53TnJHn0lRZdM31ihmrRP+sUmrS
	 4zV5Q3LE8eIAgJ9wUj1sdpZe0SvMqGndFNLR3b0PwNThVhuZXzp8J8/SsBnXUi+8To
	 wS+hbZ6y9isDEDnU+cBgV+SVQT0gLciU58DgdbcQ=
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
Subject: [PATCH 6.1 1237/1887] netfilter: nft_compat: ebtables emulation must reject non-bridge targets
Date: Wed, 28 Oct 2026 17:55:33 +0100
Message-ID: <20261028170527.573412481@linuxfoundation.org>
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
index 1e8142e64e808..67a138b9be3a6 100644
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



