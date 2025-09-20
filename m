Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D765CDF1;
	Sat, 20 Sep 2025 07:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758352368; cv=none; b=cho4M5EV07OTm0GNlwdGXrYOPfBcxw0lOduXszn0wkJeJp6HRl4z2PDsKC2D2/206OlVut61pXVpzPq3OXW/pD8LlD24OsgB8yi7pUEU4Pe2nHbYxxBxLRKohw3ly6HSgruFOoOZssewp6o1vDeGxEob+NMhWiDH2lSOWDxW3Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758352368; c=relaxed/simple;
	bh=3CUk2zv6pVK+DAzJhFpy9PexeTVmlPjoXsrlHOE0niE=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=oLNhE1/dQx+GkH4EPB0ChqWiBeuj5I5KmUzD0SPTanrhifF9UmvM5wsOAf2+K+rY6gxesqU93XoSSf0nI4EYPeqwMzB6S2idk/SaOtFTaRmb7Pyh36pcYKcW73Y2A2/cSHqJq+tNzx77jIIRISuIN8li+F+FJ/B1Sj1lrpIuAIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=aehAui2e; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="aehAui2e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	References:In-Reply-To:Subject:CC:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LukVCNTdOqemuWDZ04mzYHzWG0Cg4MLcuhaHt8lQkF4=; b=aehAui2edb76D9/6joKNhG+ePa
	R9+xtDyxMcBSFSe/C5cyKCZ6s8RT+fcV8FvtV5PsYddyQf5ts8ZtOiF2WYdY1Z3trKEdT2ixQdqYk
	P1Y6seM8Wr2EVI/znCxBMu9Hdo0n/3Jw9dx4cXwVI/hMC3GNYu+CcfhXwvKh/sVDcL9lbLOJVHOjl
	e9y5IXfJheaebkLKDWuWe+8jGMWrPnNR0ahDR1tafD4sghKzIOgt3D2zlh73FhZFB+9nrXUtawX+t
	FDjyMv6N4ulgaeNPOhv1+F2QRUqPEGBSKscbZff3NyGR+eNuGHfHqemQtlCevwxZxLqmutU8kxuuo
	liAUNmpA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (tmo-113-134.customers.d1-online.com) smtp.remote-ip=80.187.113.134;
	auth=pass (PLAIN) smtp.auth=n0-1
Received: from tmo-113-134.customers.d1-online.com ([80.187.113.134] helo=ehlo.thunderbird.net)
	by orbyte.nwl.cc with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uzrlk-000000004o2-3iWg;
	Sat, 20 Sep 2025 09:12:35 +0200
Date: Sat, 20 Sep 2025 09:12:21 +0200
From: Phil Sutter <phil@nwl.cc>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
CC: patches@lists.linux.dev, Pablo Neira Ayuso <pablo@netfilter.org>,
 Sasha Levin <sashal@kernel.org>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_6=2E12_113/140=5D_netfilter=3A_nf=5Ftables?=
 =?US-ASCII?Q?=3A_Reintroduce_shortened_deletion_notifications?=
In-Reply-To: <20250917123347.067172658@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org> <20250917123347.067172658@linuxfoundation.org>
Message-ID: <C2AE0418-CB38-4660-80F8-238FEF0D47E4@nwl.cc>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Greg,

please skip this one, it's a pure feature which requires user space modifi=
cations=2E

Thanks, Phil


On September 17, 2025 2:34:45 PM GMT+02:00, Greg Kroah-Hartman <gregkh@lin=
uxfoundation=2Eorg> wrote:
>6=2E12-stable review patch=2E  If anyone has any objections, please let m=
e know=2E
>
>------------------
>
>From: Phil Sutter <phil@nwl=2Ecc>
>
>[ Upstream commit a1050dd071682d2c9d8d6d5c96119f8f401b62f0 ]
>
>Restore commit 28339b21a365 ("netfilter: nf_tables: do not send complete
>notification of deletions") and fix it:
>
>- Avoid upfront modification of 'event' variable so the conditionals
>  become effective=2E
>- Always include NFTA_OBJ_TYPE attribute in object notifications, user
>  space requires it for proper deserialisation=2E
>- Catch DESTROY events, too=2E
>
>Signed-off-by: Phil Sutter <phil@nwl=2Ecc>
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter=2Eorg>
>Stable-dep-of: b2f742c846ca ("netfilter: nf_tables: restart set lookup on=
 base_seq change")
>Signed-off-by: Sasha Levin <sashal@kernel=2Eorg>
>---
> net/netfilter/nf_tables_api=2Ec | 67 ++++++++++++++++++++++++++---------
> 1 file changed, 50 insertions(+), 17 deletions(-)
>
>diff --git a/net/netfilter/nf_tables_api=2Ec b/net/netfilter/nf_tables_ap=
i=2Ec
>index 3743e4249dc8c=2E=2E4430bfa34a993 100644
>--- a/net/netfilter/nf_tables_api=2Ec
>+++ b/net/netfilter/nf_tables_api=2Ec
>@@ -1017,9 +1017,9 @@ static int nf_tables_fill_table_info(struct sk_buff=
 *skb, struct net *net,
> {
> 	struct nlmsghdr *nlh;
>=20
>-	event =3D nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
>-	nlh =3D nfnl_msg_put(skb, portid, seq, event, flags, family,
>-			   NFNETLINK_V0, nft_base_seq(net));
>+	nlh =3D nfnl_msg_put(skb, portid, seq,
>+			   nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event),
>+			   flags, family, NFNETLINK_V0, nft_base_seq(net));
> 	if (!nlh)
> 		goto nla_put_failure;
>=20
>@@ -1029,6 +1029,12 @@ static int nf_tables_fill_table_info(struct sk_buf=
f *skb, struct net *net,
> 			 NFTA_TABLE_PAD))
> 		goto nla_put_failure;
>=20
>+	if (event =3D=3D NFT_MSG_DELTABLE ||
>+	    event =3D=3D NFT_MSG_DESTROYTABLE) {
>+		nlmsg_end(skb, nlh);
>+		return 0;
>+	}
>+
> 	if (nla_put_be32(skb, NFTA_TABLE_FLAGS,
> 			 htonl(table->flags & NFT_TABLE_F_MASK)))
> 		goto nla_put_failure;
>@@ -1872,9 +1878,9 @@ static int nf_tables_fill_chain_info(struct sk_buff=
 *skb, struct net *net,
> {
> 	struct nlmsghdr *nlh;
>=20
>-	event =3D nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
>-	nlh =3D nfnl_msg_put(skb, portid, seq, event, flags, family,
>-			   NFNETLINK_V0, nft_base_seq(net));
>+	nlh =3D nfnl_msg_put(skb, portid, seq,
>+			   nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event),
>+			   flags, family, NFNETLINK_V0, nft_base_seq(net));
> 	if (!nlh)
> 		goto nla_put_failure;
>=20
>@@ -1884,6 +1890,13 @@ static int nf_tables_fill_chain_info(struct sk_buf=
f *skb, struct net *net,
> 			 NFTA_CHAIN_PAD))
> 		goto nla_put_failure;
>=20
>+	if (!hook_list &&
>+	    (event =3D=3D NFT_MSG_DELCHAIN ||
>+	     event =3D=3D NFT_MSG_DESTROYCHAIN)) {
>+		nlmsg_end(skb, nlh);
>+		return 0;
>+	}
>+
> 	if (nft_is_base_chain(chain)) {
> 		const struct nft_base_chain *basechain =3D nft_base_chain(chain);
> 		struct nft_stats __percpu *stats;
>@@ -4654,9 +4667,10 @@ static int nf_tables_fill_set(struct sk_buff *skb,=
 const struct nft_ctx *ctx,
> 	u32 seq =3D ctx->seq;
> 	int i;
>=20
>-	event =3D nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
>-	nlh =3D nfnl_msg_put(skb, portid, seq, event, flags, ctx->family,
>-			   NFNETLINK_V0, nft_base_seq(ctx->net));
>+	nlh =3D nfnl_msg_put(skb, portid, seq,
>+			   nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event),
>+			   flags, ctx->family, NFNETLINK_V0,
>+			   nft_base_seq(ctx->net));
> 	if (!nlh)
> 		goto nla_put_failure;
>=20
>@@ -4668,6 +4682,12 @@ static int nf_tables_fill_set(struct sk_buff *skb,=
 const struct nft_ctx *ctx,
> 			 NFTA_SET_PAD))
> 		goto nla_put_failure;
>=20
>+	if (event =3D=3D NFT_MSG_DELSET ||
>+	    event =3D=3D NFT_MSG_DESTROYSET) {
>+		nlmsg_end(skb, nlh);
>+		return 0;
>+	}
>+
> 	if (set->flags !=3D 0)
> 		if (nla_put_be32(skb, NFTA_SET_FLAGS, htonl(set->flags)))
> 			goto nla_put_failure;
>@@ -7990,20 +8010,26 @@ static int nf_tables_fill_obj_info(struct sk_buff=
 *skb, struct net *net,
> {
> 	struct nlmsghdr *nlh;
>=20
>-	event =3D nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
>-	nlh =3D nfnl_msg_put(skb, portid, seq, event, flags, family,
>-			   NFNETLINK_V0, nft_base_seq(net));
>+	nlh =3D nfnl_msg_put(skb, portid, seq,
>+			   nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event),
>+			   flags, family, NFNETLINK_V0, nft_base_seq(net));
> 	if (!nlh)
> 		goto nla_put_failure;
>=20
> 	if (nla_put_string(skb, NFTA_OBJ_TABLE, table->name) ||
> 	    nla_put_string(skb, NFTA_OBJ_NAME, obj->key=2Ename) ||
>+	    nla_put_be32(skb, NFTA_OBJ_TYPE, htonl(obj->ops->type->type)) ||
> 	    nla_put_be64(skb, NFTA_OBJ_HANDLE, cpu_to_be64(obj->handle),
> 			 NFTA_OBJ_PAD))
> 		goto nla_put_failure;
>=20
>-	if (nla_put_be32(skb, NFTA_OBJ_TYPE, htonl(obj->ops->type->type)) ||
>-	    nla_put_be32(skb, NFTA_OBJ_USE, htonl(obj->use)) ||
>+	if (event =3D=3D NFT_MSG_DELOBJ ||
>+	    event =3D=3D NFT_MSG_DESTROYOBJ) {
>+		nlmsg_end(skb, nlh);
>+		return 0;
>+	}
>+
>+	if (nla_put_be32(skb, NFTA_OBJ_USE, htonl(obj->use)) ||
> 	    nft_object_dump(skb, NFTA_OBJ_DATA, obj, reset))
> 		goto nla_put_failure;
>=20
>@@ -9008,9 +9034,9 @@ static int nf_tables_fill_flowtable_info(struct sk_=
buff *skb, struct net *net,
> 	struct nft_hook *hook;
> 	struct nlmsghdr *nlh;
>=20
>-	event =3D nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
>-	nlh =3D nfnl_msg_put(skb, portid, seq, event, flags, family,
>-			   NFNETLINK_V0, nft_base_seq(net));
>+	nlh =3D nfnl_msg_put(skb, portid, seq,
>+			   nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event),
>+			   flags, family, NFNETLINK_V0, nft_base_seq(net));
> 	if (!nlh)
> 		goto nla_put_failure;
>=20
>@@ -9020,6 +9046,13 @@ static int nf_tables_fill_flowtable_info(struct sk=
_buff *skb, struct net *net,
> 			 NFTA_FLOWTABLE_PAD))
> 		goto nla_put_failure;
>=20
>+	if (!hook_list &&
>+	    (event =3D=3D NFT_MSG_DELFLOWTABLE ||
>+	     event =3D=3D NFT_MSG_DESTROYFLOWTABLE)) {
>+		nlmsg_end(skb, nlh);
>+		return 0;
>+	}
>+
> 	if (nla_put_be32(skb, NFTA_FLOWTABLE_USE, htonl(flowtable->use)) ||
> 	    nla_put_be32(skb, NFTA_FLOWTABLE_FLAGS, htonl(flowtable->data=2Efla=
gs)))
> 		goto nla_put_failure;
