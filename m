Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186B41C4ED4;
	Tue, 27 Aug 2024 14:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769902; cv=none; b=Q9lakLQ4p+QgX/BOORtaezGIv4j68YMF0qLbVr6WmKtuHngLjEF1jAo0LXHFu8fgQ6A12vacFEJjgeLzG4GHRL654maqqUFMVmoGDSsW/S0h7+3KckM9muewzJ53FNhCKFM0qqfzVvOB/SE5ztudgM8seR5MI+pSZKG09dNdmuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769902; c=relaxed/simple;
	bh=vN0vT5Ss7QAJrFs/wJ8wBPBgBzGCHSp32F9giXO3pTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cr5vt7tzIuzem5d0OBTLH4S5hmBTdaXIhQ7xRQtH94XlltZgnr4+zPC85RTPjq+hZeCuv0pUCQvpWCtdMSmda9+O1EMskozT3JvuhClP0KiwIIzY/neZ2edywtN1KoGCutkhdlRq6PdvJ/yDfb1BhwoAAuNsyWhg/GVCfHVKKjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rbdhU6ye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rbdhU6ye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D39C61063;
	Tue, 27 Aug 2024 14:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769902;
	bh=vN0vT5Ss7QAJrFs/wJ8wBPBgBzGCHSp32F9giXO3pTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rbdhU6yepEYMCJwoK6La4+UvAEIJfq9HQETlSBywkj9oRptvF/JWarrV3+Y1b2iRP
	 tTe3mApcq2Wv0KsN6Y/zy28Z5yDezCsULObZ8zgx1OJbDJNd4cjEio6eJQeuoOi1kj
	 cl9/acpoZ2NjMafa1o11nhJSqbloKyokU4tDl14w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 069/341] netfilter: nf_tables: A better name for nft_obj_filter
Date: Tue, 27 Aug 2024 16:35:00 +0200
Message-ID: <20240827143846.038729941@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit ecf49cad807061d880bea27a5da8e0114ddc7690 ]

Name it for what it is supposed to become, a real nft_obj_dump_ctx. No
functional change intended.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: bd662c4218f9 ("netfilter: nf_tables: Add locking for NFT_MSG_GETOBJ_RESET requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 35d5848cb3d0d..ca5fb700d15cf 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7717,7 +7717,7 @@ static void audit_log_obj_reset(const struct nft_table *table,
 	kfree(buf);
 }
 
-struct nft_obj_filter {
+struct nft_obj_dump_ctx {
 	char		*table;
 	u32		type;
 };
@@ -7727,7 +7727,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 	const struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
 	const struct nft_table *table;
 	unsigned int idx = 0, s_idx = cb->args[0];
-	struct nft_obj_filter *filter = cb->data;
+	struct nft_obj_dump_ctx *ctx = cb->data;
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
 	struct nftables_pernet *nft_net;
@@ -7753,10 +7753,10 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 				goto cont;
 			if (idx < s_idx)
 				goto cont;
-			if (filter->table && strcmp(filter->table, table->name))
+			if (ctx->table && strcmp(ctx->table, table->name))
 				goto cont;
-			if (filter->type != NFT_OBJECT_UNSPEC &&
-			    obj->ops->type->type != filter->type)
+			if (ctx->type != NFT_OBJECT_UNSPEC &&
+			    obj->ops->type->type != ctx->type)
 				goto cont;
 
 			rc = nf_tables_fill_obj_info(skb, net,
@@ -7788,33 +7788,33 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 static int nf_tables_dump_obj_start(struct netlink_callback *cb)
 {
 	const struct nlattr * const *nla = cb->data;
-	struct nft_obj_filter *filter = NULL;
+	struct nft_obj_dump_ctx *ctx = NULL;
 
-	filter = kzalloc(sizeof(*filter), GFP_ATOMIC);
-	if (!filter)
+	ctx = kzalloc(sizeof(*ctx), GFP_ATOMIC);
+	if (!ctx)
 		return -ENOMEM;
 
 	if (nla[NFTA_OBJ_TABLE]) {
-		filter->table = nla_strdup(nla[NFTA_OBJ_TABLE], GFP_ATOMIC);
-		if (!filter->table) {
-			kfree(filter);
+		ctx->table = nla_strdup(nla[NFTA_OBJ_TABLE], GFP_ATOMIC);
+		if (!ctx->table) {
+			kfree(ctx);
 			return -ENOMEM;
 		}
 	}
 
 	if (nla[NFTA_OBJ_TYPE])
-		filter->type = ntohl(nla_get_be32(nla[NFTA_OBJ_TYPE]));
+		ctx->type = ntohl(nla_get_be32(nla[NFTA_OBJ_TYPE]));
 
-	cb->data = filter;
+	cb->data = ctx;
 	return 0;
 }
 
 static int nf_tables_dump_obj_done(struct netlink_callback *cb)
 {
-	struct nft_obj_filter *filter = cb->data;
+	struct nft_obj_dump_ctx *ctx = cb->data;
 
-	kfree(filter->table);
-	kfree(filter);
+	kfree(ctx->table);
+	kfree(ctx);
 
 	return 0;
 }
-- 
2.43.0



