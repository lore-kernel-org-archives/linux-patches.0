Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6097746EF77;
	Wed, 30 Sep 2026 19:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797254; cv=none; b=pnEdU40gWCwvLAE7HCHYJxFRTBBr3JCXEPmbOCGayBp8HzRra+tvTdCx/WItgjEudAEBqYqv/5PVjMv/3u4jRfcTRjPkubsuaSpCcGJe3vJMrSPutM/LXYlL5NUz0eNd5oyD7jJm8zoZgIX68swKnioD435ZvenJdL9KnZTLAh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797254; c=relaxed/simple;
	bh=8OsbC9F5MXipLjRk8yRlM0P2zc6SYTZ959Q46VMrPgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QuGMbctu/detbUqGDTSqeZKvVrSQGIaMKyCmi51RpLoV5Z3bWpjKFG/5rfMFDreTlmv3wY2fdYRUvZtR3YNWosGJb6Qs+7nN5KsMFYj6ui37LEW526Xo3boXjRKDo260JuCNQVBByAJ86PQi6cHmTKggGyKDkPovEQpow3wHs4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H9Z5Hn2D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H9Z5Hn2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B942F1F000FF;
	Wed, 30 Sep 2026 19:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797253;
	bh=jNLSFed2Pvr6tXJ4XUbFIb/E4hxzzIdrekFBV/csdRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H9Z5Hn2D7Lz6GERZ9NjwivRNd7zXab65P6/qJczN0/ftjuof3CzFrYSzlWPs3vUqo
	 bEBBVDHJjE1dW/Hb2eJgWwrTntTlqnyUABktbtQW3XbJtyvDpiRSVjk7Yo7OqhzRS/
	 dyBHchX28Ld8bB9gYeDHT6+wstjAnhNbyi68bnaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	Yang Li <yang.lee@linux.alibaba.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1189/1193] netfilter: nft_set_rbtree: Remove unused variable nft_net
Date: Wed, 30 Sep 2026 17:31:13 +0200
Message-ID: <20260930152500.662536974@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Li <yang.lee@linux.alibaba.com>

[ Upstream commit 67059b61597c004e23b074547b40604222bee3a0 ]

The code that uses nft_net has been removed, and the nft_pernet function
is merely obtaining a reference to shared data through the net pointer.
The content of the net pointer is not modified or changed, so both of
them should be removed.

silence the warning:
net/netfilter/nft_set_rbtree.c:627:26: warning: variable ‘nft_net’ set but not used

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=7103
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 7904b94768e9 ("netfilter: nf_tables: don't queue packet path object notifications")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c  |   28 +++++++++++++++-------------
 net/netfilter/nft_set_rbtree.c |    2 --
 2 files changed, 15 insertions(+), 15 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -922,11 +922,11 @@ nf_tables_chain_type_lookup(struct net *
 	return ERR_PTR(-ENOENT);
 }
 
-static __be16 nft_base_seq(const struct net *net)
+static unsigned int nft_base_seq(const struct net *net)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
 
-	return htons(nft_net->base_seq & 0xffff);
+	return READ_ONCE(nft_net->base_seq);
 }
 
 static const struct nla_policy nft_table_policy[NFTA_TABLE_MAX + 1] = {
@@ -946,7 +946,7 @@ static int nf_tables_fill_table_info(str
 
 	event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
 	nlh = nfnl_msg_put(skb, portid, seq, event, flags, family,
-			   NFNETLINK_V0, nft_base_seq(net));
+			   NFNETLINK_V0, htons(nft_base_seq(net) & 0xffff));
 	if (!nlh)
 		goto nla_put_failure;
 
@@ -1789,7 +1789,7 @@ static int nf_tables_fill_chain_info(str
 
 	event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
 	nlh = nfnl_msg_put(skb, portid, seq, event, flags, family,
-			   NFNETLINK_V0, nft_base_seq(net));
+			   NFNETLINK_V0, htons(nft_base_seq(net) & 0xffff));
 	if (!nlh)
 		goto nla_put_failure;
 
@@ -3398,7 +3398,7 @@ static int nf_tables_fill_rule_info(stru
 	u16 type = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
 
 	nlh = nfnl_msg_put(skb, portid, seq, type, flags, family, NFNETLINK_V0,
-			   nft_base_seq(net));
+			   htons(nft_base_seq(net) & 0xffff));
 	if (!nlh)
 		goto nla_put_failure;
 
@@ -4593,7 +4593,8 @@ static int nf_tables_fill_set(struct sk_
 
 	event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
 	nlh = nfnl_msg_put(skb, portid, seq, event, flags, ctx->family,
-			   NFNETLINK_V0, nft_base_seq(ctx->net));
+			   NFNETLINK_V0,
+			   htons(nft_base_seq(ctx->net) & 0xffff));
 	if (!nlh)
 		goto nla_put_failure;
 
@@ -5938,7 +5939,8 @@ static int nf_tables_dump_set(struct sk_
 	seq    = cb->nlh->nlmsg_seq;
 
 	nlh = nfnl_msg_put(skb, portid, seq, event, NLM_F_MULTI,
-			   table->family, NFNETLINK_V0, nft_base_seq(net));
+			   table->family, NFNETLINK_V0,
+			   htons(nft_base_seq(net) & 0xffff));
 	if (!nlh)
 		goto nla_put_failure;
 
@@ -6018,7 +6020,8 @@ static int nf_tables_fill_setelem_info(s
 
 	event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
 	nlh = nfnl_msg_put(skb, portid, seq, event, flags, ctx->family,
-			   NFNETLINK_V0, nft_base_seq(ctx->net));
+			   NFNETLINK_V0,
+			   htons(nft_base_seq(ctx->net) & 0xffff));
 	if (!nlh)
 		goto nla_put_failure;
 
@@ -7838,7 +7841,7 @@ static int nf_tables_fill_obj_info(struc
 
 	event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
 	nlh = nfnl_msg_put(skb, portid, seq, event, flags, family,
-			   NFNETLINK_V0, nft_base_seq(net));
+			   NFNETLINK_V0, htons(nft_base_seq(net) & 0xffff));
 	if (!nlh)
 		goto nla_put_failure;
 
@@ -8205,9 +8208,8 @@ void nft_obj_notify(struct net *net, con
 		    struct nft_object *obj, u32 portid, u32 seq, int event,
 		    u16 flags, int family, int report, gfp_t gfp)
 {
-	struct nftables_pernet *nft_net = nft_pernet(net);
 	char *buf = kasprintf(gfp, "%s:%u",
-			      table->name, nft_net->base_seq);
+			      table->name, nft_base_seq(net));
 
 	audit_log_nfcfg(buf,
 			family,
@@ -8872,7 +8874,7 @@ static int nf_tables_fill_flowtable_info
 
 	event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
 	nlh = nfnl_msg_put(skb, portid, seq, event, flags, family,
-			   NFNETLINK_V0, nft_base_seq(net));
+			   NFNETLINK_V0, htons(nft_base_seq(net) & 0xffff));
 	if (!nlh)
 		goto nla_put_failure;
 
@@ -9119,7 +9121,7 @@ static int nf_tables_fill_gen_info(struc
 	int event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, NFT_MSG_NEWGEN);
 
 	nlh = nfnl_msg_put(skb, portid, seq, event, 0, AF_UNSPEC,
-			   NFNETLINK_V0, nft_base_seq(net));
+			   NFNETLINK_V0, htons(nft_base_seq(net) & 0xffff));
 	if (!nlh)
 		goto nla_put_failure;
 
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -653,7 +653,6 @@ static void nft_rbtree_gc(struct nft_set
 {
 	struct nft_rbtree *priv = nft_set_priv(set);
 	struct nft_rbtree_elem *rbe, *rbe_end = NULL;
-	struct nftables_pernet *nft_net;
 	struct net *net = read_pnet(&set->net);
 	u64 tstamp = nft_net_tstamp(net);
 	struct rb_node *node, *next;
@@ -661,7 +660,6 @@ static void nft_rbtree_gc(struct nft_set
 
 	set  = nft_set_container_of(priv);
 	net  = read_pnet(&set->net);
-	nft_net = nft_pernet(net);
 
 	gc = nft_trans_gc_alloc(set, 0, GFP_KERNEL);
 	if (!gc)


