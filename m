Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024606;
	b=NjvOsRYtu2gbBMKcBCEPylEGrOQYln99+mVLLTlGMZCdW3pQK83u2WU/zRIP/y5oWg+r
	 gGw2q+3X3VG6RW6O0CaN4bo3GXJ8h1TyZYGoS3TZf1kuAyt2ZkYUNS4HzsvuJZHAKAjzS
	 Bm8lnooKexvosR+MgjHMqbUYEAVTYjZnYMg/DkyAIPnVn4v01cX75ln/mRAtpVcjC62Ni
	 0J1SH12SsIe0rNWqNfBq3JK6tND6z64WbqT7JTkThYwIg0IFS0FCU/L/qGxepgcEdbW5S
	 iar5WaHSCJKcWAoaEZQUYrgg/Ddo1UyGBPt2UlfcX2fT983PHbSbmUStcVGok1o6qGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024606;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cmgS4xw7wFTzr4kMjlwUAflDfrYyp3UXnzrigtbyzlk=;
	b=QVslxkiwWcmYJeb253PAY1bABegw9bhXnPVaRXaLF2LtiumQg7Xi2J28RdAdDcfQZ7IP
	 UJyEsMg1aJwfBR2qUh1Y+JqQjQ6A5CZVyVkl+0fwxeT9oV7XWTnbXdc0uVtQaVRb7MV8w
	 3QqaNqUMnBYI1oOP8XqpTpqk5iGIx+bDRLJaCD2wErAAIWrt7yPuESVEjLhxmNf5k18ku
	 yeXPSr3eSMtZH2lXDaxwlbrFwi09SXb1bARkxSJwcNJwzHb0fxlVLAYsjwEWGm1VV658j
	 l9pG+sstFnTpFxoVnx/CxVzkOMdb3HZueL1ySXAlnpBbZMWsCiRCaOjsIMeldAVP4GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XwxYF2B5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77329606A320;
	Wed, 18 Nov 2026 17:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XwxYF2B5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6CAE1F000C4;
	Wed, 18 Nov 2026 17:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024606;
	bh=cmgS4xw7wFTzr4kMjlwUAflDfrYyp3UXnzrigtbyzlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XwxYF2B5UBxeMzHjYjYo5JPwZIn3aAkLdriSFfySJtt20KTghVcaXiqPCofesPrg3
	 /tsvx4XOIfNxetUAzTwf4e/63shzLnL3K6dzAlPRDsTMKDT5+7MDRDpcr0janBF2vA
	 /IcmiBrOUWMmZW97i7J5p/GKvIQVyueWfzOyibTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0778/2151] netfilter: nfnetlink: Fix for interrupted hook dumps
Date: Wed, 18 Nov 2026 15:41:53 +0100
Message-ID: <20261118150150.461901661@linuxfoundation.org>
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

[ Upstream commit d3950004ba90350bcdf414c5f804da277178564a ]

Handling of concurrent hook changes with a dump in progress was
problematic in nfnl_hook_dump and entirely broken in nfnl_hook_dump_nat.
Address all issues in a single patch to please the review LLM.

Introduce sequence numbers in struct netns_nf to replace pointer
value-based modification detection which may fail due to memory buffer
reuse. This also eliminates the need for most manual cb->seq updates and
excessive array index value checks.

Since nat hook updates are protected by a different mutex than others,
they have to bump their own sequence number. nfnl_hook_dump_nat
therefore open-codes what nl_dump_check_consistent does but bumps
cb->seq instead of setting NLM_F_DUMP_INTR flag.

Dumps of many nat hooks was entirely broken since the array index was
not (re)stored. Use cb->args[1] for that and make sure it is reset upon
completion as the same dump may loop over multiple arrays of nat hooks.

In nfnl_hook_dump, don't signal NLM_F_DUMP_INTR if
nfnl_hook_entries_head returns error: This is a permanent condition
which does not change during a dump. It is already caught by
nfnl_hook_dump_start though, so should not happen anyway.

In general, access ops array pointer values using READ_ONCE since they
are assigned to using WRITE_ONCE.

Avoid setting NLM_F_DUMP_INTR flag in garbage memory by calling
nl_dump_check_consistent only for non-empty skbs. If not a single
netlink message was created, nfnetlink code will take care of setting
the flag.

Fixes: e2cf17d3774c ("netfilter: add new hook nfnl subsystem")
Fixes: b010e2a4a9ac ("netfilter: nfnetlink_hook: Dump nat type chains")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netns/netfilter.h  |  2 +
 net/netfilter/core.c           | 18 ++++++++-
 net/netfilter/nf_nat_core.c    | 11 +++++
 net/netfilter/nfnetlink_hook.c | 74 ++++++++++++++++++++--------------
 4 files changed, 73 insertions(+), 32 deletions(-)

diff --git a/include/net/netns/netfilter.h b/include/net/netns/netfilter.h
index a6a0bf4a247e5..7fd78394d1e7b 100644
--- a/include/net/netns/netfilter.h
+++ b/include/net/netns/netfilter.h
@@ -33,5 +33,7 @@ struct netns_nf {
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
 	unsigned int defrag_ipv6_users;
 #endif
+	unsigned int hook_base_seq;
+	unsigned int nat_hook_base_seq;
 };
 #endif
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 11a702065bab5..f11c980030b1a 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -390,6 +390,15 @@ static void nf_static_key_dec(const struct nf_hook_ops *reg, int pf)
 #endif
 }
 
+static void bump_hook_base_seq(struct net *net)
+{
+	unsigned int base_seq = READ_ONCE(net->nf.hook_base_seq);
+
+	while (++base_seq == 0)
+		;
+	smp_store_release(&net->nf.hook_base_seq, base_seq);
+}
+
 static int __nf_register_net_hook(struct net *net, int pf,
 				  const struct nf_hook_ops *reg)
 {
@@ -434,6 +443,7 @@ static int __nf_register_net_hook(struct net *net, int pf,
 	if (!IS_ERR(new_hooks)) {
 		hooks_validate(new_hooks);
 		rcu_assign_pointer(*pp, new_hooks);
+		bump_hook_base_seq(net);
 	}
 
 	mutex_unlock(&nf_hook_mutex);
@@ -487,6 +497,7 @@ static void __nf_unregister_net_hook(struct net *net, int pf,
 {
 	struct nf_hook_entries __rcu **pp;
 	struct nf_hook_entries *p;
+	bool found;
 
 	pp = nf_hook_entry_head(net, pf, reg->hooknum, reg->dev);
 	if (!pp)
@@ -500,7 +511,8 @@ static void __nf_unregister_net_hook(struct net *net, int pf,
 		return;
 	}
 
-	if (nf_remove_net_hook(p, reg)) {
+	found = nf_remove_net_hook(p, reg);
+	if (found) {
 #ifdef CONFIG_NETFILTER_INGRESS
 		if (nf_ingress_hook(reg, pf))
 			net_dec_ingress_queue();
@@ -515,6 +527,8 @@ static void __nf_unregister_net_hook(struct net *net, int pf,
 	}
 
 	p = __nf_hook_entries_try_shrink(p, pp);
+	if (found)
+		bump_hook_base_seq(net);
 	mutex_unlock(&nf_hook_mutex);
 	if (!p)
 		return;
@@ -788,6 +802,8 @@ static int __net_init netfilter_net_init(struct net *net)
 		return -ENOMEM;
 	}
 #endif
+	net->nf.hook_base_seq = 1;
+	net->nf.nat_hook_base_seq = 1;
 
 	return 0;
 }
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 3a29b1e411907..114ae7e8e5272 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1167,6 +1167,15 @@ nfnetlink_parse_nat_setup(struct nf_conn *ct,
 }
 #endif
 
+static void bump_nat_hook_base_seq(struct net *net)
+{
+	unsigned int base_seq = READ_ONCE(net->nf.nat_hook_base_seq);
+
+	while (++base_seq == 0)
+		;
+	smp_store_release(&net->nf.nat_hook_base_seq, base_seq);
+}
+
 static struct nf_ct_helper_expectfn follow_master_nat = {
 	.name		= "nat-follow-master",
 	.expectfn	= nf_nat_follow_master,
@@ -1251,6 +1260,7 @@ int nf_nat_register_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 		nat_proto_net->nat_hook_ops = nat_ops;
 
 	nat_proto_net->users++;
+	bump_nat_hook_base_seq(net);
 
 	mutex_unlock(&nf_nat_proto_mutex);
 
@@ -1305,6 +1315,7 @@ void nf_nat_unregister_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 		goto unlock;
 	priv = nat_ops[hooknum].priv;
 	nf_hook_entries_delete_raw(&priv->entries, ops);
+	bump_nat_hook_base_seq(net);
 
 	if (nat_proto_net->users == 0) {
 		nf_unregister_net_hooks(net, nat_ops, ops_count);
diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
index 65cf5e1ded858..4567468277950 100644
--- a/net/netfilter/nfnetlink_hook.c
+++ b/net/netfilter/nfnetlink_hook.c
@@ -54,7 +54,6 @@ static int nf_netlink_dump_start_rcu(struct sock *nlsk, struct sk_buff *skb,
 
 struct nfnl_dump_hook_data {
 	char devname[IFNAMSIZ];
-	unsigned long headv;
 	u8 hook;
 };
 
@@ -338,27 +337,47 @@ nfnl_hook_entries_head(u8 pf, unsigned int hook, struct net *net, const char *de
 }
 
 static int nfnl_hook_dump_nat(struct sk_buff *nlskb,
-			      const struct nfnl_dump_hook_data *ctx,
-			      const struct nf_hook_ops *ops,
-			      int family, unsigned int seq)
+			      struct netlink_callback *cb,
+			      const struct nf_hook_ops *ops, int family)
 {
 	struct nf_nat_lookup_hook_priv *priv = ops->priv;
-	struct nf_hook_entries *e = rcu_dereference(priv->entries);
+	struct nfnl_dump_hook_data *ctx = cb->data;
+	struct net *net = sock_net(nlskb->sk);
 	struct nf_hook_ops **nat_ops;
-	int i, err;
+	unsigned int i = cb->args[1];
+	struct nf_hook_entries *e;
+	unsigned int base_seq;
+	int err = 0;
 
+	base_seq = smp_load_acquire(&net->nf.nat_hook_base_seq);
+
+	e = rcu_dereference(priv->entries);
 	if (!e)
-		return 0;
+		goto out;
 
 	nat_ops = nf_hook_entries_get_hook_ops(e);
 
-	for (i = 0; i < e->num_hook_entries; i++) {
-		err = nfnl_hook_dump_one(nlskb, ctx, nat_ops[i],
-					 ops->priority, family, seq);
+	for (; i < e->num_hook_entries; i++) {
+		err = nfnl_hook_dump_one(nlskb, ctx,
+					 READ_ONCE(nat_ops[i]),
+					 ops->priority, family,
+					 cb->nlh->nlmsg_seq);
 		if (err)
-			return err;
+			break;
+
 	}
-	return 0;
+out:
+	if (!err)
+		i = 0;
+	cb->args[1] = i;
+
+	if (cb->args[2] && base_seq != cb->args[2]) {
+		cb->seq++;
+		err = -EINTR;
+	}
+	cb->args[2] = base_seq;
+
+	return err;
 }
 
 static int nfnl_hook_dump(struct sk_buff *nlskb,
@@ -373,35 +392,31 @@ static int nfnl_hook_dump(struct sk_buff *nlskb,
 	unsigned int i = cb->args[0];
 
 	rcu_read_lock();
+	cb->seq = smp_load_acquire(&net->nf.hook_base_seq);
 
 	e = nfnl_hook_entries_head(family, ctx->hook, net, ctx->devname);
-	if (!e)
+	if (!e || IS_ERR(e))
 		goto done;
 
-	if (IS_ERR(e)) {
-		cb->seq++;
-		goto done;
-	}
-
-	if ((unsigned long)e != ctx->headv || i >= e->num_hook_entries)
-		cb->seq++;
-
 	ops = nf_hook_entries_get_hook_ops(e);
 
 	for (; i < e->num_hook_entries; i++) {
-		if (ops[i]->hook_ops_type == NF_HOOK_OP_NAT)
-			err = nfnl_hook_dump_nat(nlskb, ctx, ops[i], family,
-						 cb->nlh->nlmsg_seq);
-		else
-			err = nfnl_hook_dump_one(nlskb, ctx, ops[i],
-						 ops[i]->priority, family,
+		const struct nf_hook_ops *cur = READ_ONCE(ops[i]);
+
+		if (cur->hook_ops_type == NF_HOOK_OP_NAT) {
+			err = nfnl_hook_dump_nat(nlskb, cb, cur, family);
+		} else {
+			err = nfnl_hook_dump_one(nlskb, ctx, cur,
+						 cur->priority, family,
 						 cb->nlh->nlmsg_seq);
+		}
 		if (err)
 			break;
 	}
 
 done:
-	nl_dump_check_consistent(cb, nlmsg_hdr(nlskb));
+	if (nlskb->len > 0)
+		nl_dump_check_consistent(cb, nlmsg_hdr(nlskb));
 	rcu_read_unlock();
 	cb->args[0] = i;
 	return nlskb->len;
@@ -442,10 +457,7 @@ static int nfnl_hook_dump_start(struct netlink_callback *cb)
 		return -ENOMEM;
 
 	strscpy(ctx->devname, name, sizeof(ctx->devname));
-	ctx->headv = (unsigned long)head;
 	ctx->hook = hooknum;
-
-	cb->seq = 1;
 	cb->data = ctx;
 
 	return 0;
-- 
2.53.0



