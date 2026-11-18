Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024727;
	b=ipKgwE78pwIukw61dgjyVV1uev+8uf+GDkM+wfJOWVTE/mHxboWbCN1skVz7kHe+oNP/
	 jjIW8fGq7mcednUgsWu5XBMgCQhAqexO8BnMgYHmO+aFNyoIBEuqODWmeOw8PCBBufSp9
	 3vtUePUNyJ91x2OweM2xLghLyjkQr/8xi6wB3rG5vKE/oUl8ItafMtLuBrjKE/39Xutf3
	 AHKv6IEuJmK9EfiH8S/N1deSmU44IbB4vR3l1rt0dKVQ6oiGaZoP+BSx3bZcUvNZ3atoE
	 cDr4jProyUYqlPsSlxvS9pPO1dXP32qkFDn3mrKqRpSzzhF2+fO9tS8zxKRN9nJuPgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024727;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZZR2NnYJSWk21NdLMzNng/mzP3ZWdFyANgdeG22/dXs=;
	b=KTPr7jRH3J872TqlWmRdIB0U+hsPRMqwLxMU5+LIrDMpKDHKUujifd4U0PwL39bTzpxR
	 jxHI+zEs2J5FrODvtE/mqrekZmOIKgKoiH8cN6+UiLGvINv3WgTSApaN6fyroLJpW9iTy
	 nTT1lX6adHAVZUiyeFGOhkPJ6RIQGMSjmTvg1HejwZIKcygdjwDmW1oGvStKkEMv0X3W0
	 6+S9gDeGXO6x52StYLEeP58w/CqAXZGFa1kB16VGBntCkMjZciB3PciJRdyGSDqz0B88k
	 bHIMkO2Vk4JHdbUanuP+53F1hgg3MO4etCXE3ayi9QVMmmm/CjWvB4VZJGdJoGumcFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ToJsHMH0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490E5606A325;
	Wed, 18 Nov 2026 17:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ToJsHMH0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9732E1F000C4;
	Wed, 18 Nov 2026 17:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024727;
	bh=ZZR2NnYJSWk21NdLMzNng/mzP3ZWdFyANgdeG22/dXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ToJsHMH0xl+SpA7+9+tt24esi+mb5yWqggbn5qOY2WsxwSKTsbe2nGpwuk7EVSsSX
	 Nxf6vf078/lAtp4DG2gdYcqLgArmmuJwoZcaR05Oit7b6KCOd8BoYsjZDemuSyqYNx
	 6ZUaXyBLX2eHQQcwqTtOyHkGipkUBMVldqW3mq1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0777/2151] netfilter: nfnetlink_hook: Dump nat type chains
Date: Wed, 18 Nov 2026 15:41:52 +0100
Message-ID: <20261118150150.430783369@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit b010e2a4a9ac2bcd0db2c3a41877d59d827a8a80 ]

These chains are indirectly attached to the hook since they are
not called for packets belonging to an established connection.

Introduce NF_HOOK_OP_NAT to identify the container and dump attached
entries instead of the container itself.

Dump these entries with the dispatcher's priority value since their own
priority merely defines ordering within the dispatcher's list.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Florian Westphal <fw@strlen.de>
Stable-dep-of: d3950004ba90 ("netfilter: nfnetlink: Fix for interrupted hook dumps")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netfilter.h      |  7 +++++++
 net/netfilter/nf_nat_core.c    |  6 ------
 net/netfilter/nf_nat_proto.c   |  8 ++++++++
 net/netfilter/nfnetlink_hook.c | 37 ++++++++++++++++++++++++++++++----
 4 files changed, 48 insertions(+), 10 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index efbbfa770d661..e99afc1414cd3 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -93,6 +93,7 @@ enum nf_hook_ops_type {
 	NF_HOOK_OP_NF_TABLES,
 	NF_HOOK_OP_BPF,
 	NF_HOOK_OP_NFT_FT,
+	NF_HOOK_OP_NAT,
 };
 
 struct nf_hook_ops {
@@ -140,6 +141,12 @@ struct nf_hook_entries {
 	 */
 };
 
+struct nf_nat_lookup_hook_priv {
+	struct nf_hook_entries __rcu *entries;
+
+	struct rcu_head rcu_head;
+};
+
 #ifdef CONFIG_NETFILTER
 static inline struct nf_hook_ops **nf_hook_entries_get_hook_ops(const struct nf_hook_entries *e)
 {
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index f628122bf8a82..3a29b1e411907 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -39,12 +39,6 @@ static struct hlist_head *nf_nat_bysource __read_mostly;
 static unsigned int nf_nat_htable_size __read_mostly;
 static siphash_aligned_key_t nf_nat_hash_rnd;
 
-struct nf_nat_lookup_hook_priv {
-	struct nf_hook_entries __rcu *entries;
-
-	struct rcu_head rcu_head;
-};
-
 struct nf_nat_hooks_net {
 	struct nf_hook_ops *nat_hook_ops;
 	unsigned int users;
diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index b14a434b95612..74897e868ca30 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -789,6 +789,7 @@ static const struct nf_hook_ops nf_nat_ipv4_ops[] = {
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_PRE_ROUTING,
 		.priority	= NF_IP_PRI_NAT_DST,
+		.hook_ops_type	= NF_HOOK_OP_NAT,
 	},
 	/* After packet filtering, change source */
 	{
@@ -796,6 +797,7 @@ static const struct nf_hook_ops nf_nat_ipv4_ops[] = {
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_POST_ROUTING,
 		.priority	= NF_IP_PRI_NAT_SRC,
+		.hook_ops_type	= NF_HOOK_OP_NAT,
 	},
 	/* Before packet filtering, change destination */
 	{
@@ -803,6 +805,7 @@ static const struct nf_hook_ops nf_nat_ipv4_ops[] = {
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP_PRI_NAT_DST,
+		.hook_ops_type	= NF_HOOK_OP_NAT,
 	},
 	/* After packet filtering, change source */
 	{
@@ -810,6 +813,7 @@ static const struct nf_hook_ops nf_nat_ipv4_ops[] = {
 		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP_PRI_NAT_SRC,
+		.hook_ops_type	= NF_HOOK_OP_NAT,
 	},
 };
 
@@ -1050,6 +1054,7 @@ static const struct nf_hook_ops nf_nat_ipv6_ops[] = {
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_PRE_ROUTING,
 		.priority	= NF_IP6_PRI_NAT_DST,
+		.hook_ops_type	= NF_HOOK_OP_NAT,
 	},
 	/* After packet filtering, change source */
 	{
@@ -1057,6 +1062,7 @@ static const struct nf_hook_ops nf_nat_ipv6_ops[] = {
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_POST_ROUTING,
 		.priority	= NF_IP6_PRI_NAT_SRC,
+		.hook_ops_type	= NF_HOOK_OP_NAT,
 	},
 	/* Before packet filtering, change destination */
 	{
@@ -1064,6 +1070,7 @@ static const struct nf_hook_ops nf_nat_ipv6_ops[] = {
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP6_PRI_NAT_DST,
+		.hook_ops_type	= NF_HOOK_OP_NAT,
 	},
 	/* After packet filtering, change source */
 	{
@@ -1071,6 +1078,7 @@ static const struct nf_hook_ops nf_nat_ipv6_ops[] = {
 		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP6_PRI_NAT_SRC,
+		.hook_ops_type	= NF_HOOK_OP_NAT,
 	},
 };
 
diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
index 92d869317cba5..65cf5e1ded858 100644
--- a/net/netfilter/nfnetlink_hook.c
+++ b/net/netfilter/nfnetlink_hook.c
@@ -190,7 +190,7 @@ static int nfnl_hook_put_nft_ft_info(struct sk_buff *nlskb,
 
 static int nfnl_hook_dump_one(struct sk_buff *nlskb,
 			      const struct nfnl_dump_hook_data *ctx,
-			      const struct nf_hook_ops *ops,
+			      const struct nf_hook_ops *ops, int priority,
 			      int family, unsigned int seq)
 {
 	u16 event = nfnl_msg_type(NFNL_SUBSYS_HOOK, NFNL_MSG_HOOK_GET);
@@ -244,7 +244,7 @@ static int nfnl_hook_dump_one(struct sk_buff *nlskb,
 	if (ret)
 		goto nla_put_failure;
 
-	ret = nla_put_be32(nlskb, NFNLA_HOOK_PRIORITY, htonl(ops->priority));
+	ret = nla_put_be32(nlskb, NFNLA_HOOK_PRIORITY, htonl(priority));
 	if (ret)
 		goto nla_put_failure;
 
@@ -337,6 +337,30 @@ nfnl_hook_entries_head(u8 pf, unsigned int hook, struct net *net, const char *de
 	return hook_head;
 }
 
+static int nfnl_hook_dump_nat(struct sk_buff *nlskb,
+			      const struct nfnl_dump_hook_data *ctx,
+			      const struct nf_hook_ops *ops,
+			      int family, unsigned int seq)
+{
+	struct nf_nat_lookup_hook_priv *priv = ops->priv;
+	struct nf_hook_entries *e = rcu_dereference(priv->entries);
+	struct nf_hook_ops **nat_ops;
+	int i, err;
+
+	if (!e)
+		return 0;
+
+	nat_ops = nf_hook_entries_get_hook_ops(e);
+
+	for (i = 0; i < e->num_hook_entries; i++) {
+		err = nfnl_hook_dump_one(nlskb, ctx, nat_ops[i],
+					 ops->priority, family, seq);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
 static int nfnl_hook_dump(struct sk_buff *nlskb,
 			  struct netlink_callback *cb)
 {
@@ -365,8 +389,13 @@ static int nfnl_hook_dump(struct sk_buff *nlskb,
 	ops = nf_hook_entries_get_hook_ops(e);
 
 	for (; i < e->num_hook_entries; i++) {
-		err = nfnl_hook_dump_one(nlskb, ctx, ops[i], family,
-					 cb->nlh->nlmsg_seq);
+		if (ops[i]->hook_ops_type == NF_HOOK_OP_NAT)
+			err = nfnl_hook_dump_nat(nlskb, ctx, ops[i], family,
+						 cb->nlh->nlmsg_seq);
+		else
+			err = nfnl_hook_dump_one(nlskb, ctx, ops[i],
+						 ops[i]->priority, family,
+						 cb->nlh->nlmsg_seq);
 		if (err)
 			break;
 	}
-- 
2.53.0



