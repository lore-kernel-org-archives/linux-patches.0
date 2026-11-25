Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618559;
	b=uBydFU5l4nM5+sSrLfK5/pOpLtgytUe7EIJr2NZhg0O4vOE0sDjy/QZAub6sH0g7A21T
	 BTdU9MoM++HZU/H0pC+WcPI7BDzFYgdmb5eLVov6XtwLTjGRrMuRZC7FKs2c1t9cJcnwA
	 3wgpHV2Ef30v2JS8uIHsynCaZ4fUQXBxjk4APPq15oHDTvc92WqvouK4DPwe/6kgXZIY9
	 yGYhmIHJr2iwxuFWFr94qmsXnf+WFQijvJp3SUvEguxdJoDmtw35JXqXnjiQVGTxzOznE
	 uN2K9bQZcJm07ConkytW0kHws4Nb0+B9tftWoY5uJbPuOrKVX8UITbAe4cKScoxP4lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618559;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GBOUSwlyBi8h7S40n/AfmvfnMbkAXo+PSIwx72JJnSA=;
	b=MSXvDsIjMpA6IUplZGPHLJqovqMYYMaO+gj0xohNKN3y6TlpoJCPG3FII7rB0WfUk6NQ
	 VN/3TrBxrgTcXpDSgiG8/zJmcXFdwSthz8omTFmvQinEf4Xe9HRKi5ZLxNWn3+JnKPGYZ
	 Jsox7AIycUu6e+YVfiwLEq+0pMVtwVrZP4c/yICvtrkFRuvWeJlWz89l5FqylnayNJb/y
	 7HlItVTv6iCfxjMIBAU86QkCQrbly8a9bjpRnh1ypzm/zxve3xiovEogcqRKnNObOYrjS
	 F8LRnPZGrRhxx3y63KK5iK2VIdpFy2TTRx0YcfQkj8PNLrqsVZpU+D2o7bV7SGwlglQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gGZh2reo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42301606A32C;
	Wed, 25 Nov 2026 14:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gGZh2reo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9385F1F000CF;
	Wed, 25 Nov 2026 14:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618559;
	bh=GBOUSwlyBi8h7S40n/AfmvfnMbkAXo+PSIwx72JJnSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gGZh2reo1Te6+3dP0Y/11Iokiu8Y2tbbvxlrHkDREilu/q8mU6xefcej/EUDhgknM
	 1JGpczQGyE8dY87XpudYRD8FAylpKeX7/ZaoBrRym8/8DwZfQ4i5MojUTCreKPERR2
	 ubFhhslQfYXr3IbueyQhRhh1XaGwG2EZJhHbL6nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0319/1005] netfilter: nat: zero newrange before filling it in
Date: Wed, 25 Nov 2026 15:27:37 +0100
Message-ID: <20261125143829.209629500@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit d1bb235aa409a4e5aeba6c748d953d948625b1e9 ]

nf_nat_masquerade_ipv4(), nf_nat_masquerade_ipv6(), netmap_tg4() and
netmap_tg6() each build a stack-local struct nf_nat_range2 from the
caller-supplied range, inheriting range->flags unmodified. Two of them
only memset() the min_addr/max_addr members, the other two don't
memset() anything at all, so newrange.base_proto is left as stack
garbage.

If the inherited flags include NF_NAT_RANGE_PROTO_OFFSET,
nf_nat_l4proto_unique_tuple() reads range->base_proto.all to compute
the NAT port offset. Neither the NETMAP nor the MASQUERADE targets
mask the flags field in their checkentry callback, so this
uninitialized stack value can end up feeding the NAT port selection.

The per-member memset()s are not enough: they have to enumerate every
field that must be cleared, and base_proto was missed when
NF_NAT_RANGE_PROTO_OFFSET/base_proto was added to the struct. memset()
the whole struct instead, so every member is covered regardless of
which ones get explicitly assigned afterwards.

There are other places that miss this, but those hardcode .flags so
nat core won't read from the uninitialized fields.

C99 initializers would be preferrable, but this is a more intrusive
change.  Lets followup in nf-next and convert others as well.

This is an LLM finding.

Fixes: 2eb0f624b709 ("netfilter: add NAT support for shifted portmap ranges")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_nat_masquerade.c | 4 ++--
 net/netfilter/xt_NETMAP.c         | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_nat_masquerade.c b/net/netfilter/nf_nat_masquerade.c
index 4de6e0a517015..c2a85bd84af13 100644
--- a/net/netfilter/nf_nat_masquerade.c
+++ b/net/netfilter/nf_nat_masquerade.c
@@ -62,8 +62,7 @@ nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int hooknum,
 		nat->masq_index = out->ifindex;
 
 	/* Transfer from original range. */
-	memset(&newrange.min_addr, 0, sizeof(newrange.min_addr));
-	memset(&newrange.max_addr, 0, sizeof(newrange.max_addr));
+	memset(&newrange, 0, sizeof(newrange));
 	newrange.flags       = range->flags | NF_NAT_RANGE_MAP_IPS;
 	newrange.min_addr.ip = newsrc;
 	newrange.max_addr.ip = newsrc;
@@ -242,6 +241,7 @@ nf_nat_masquerade_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
 	if (nat)
 		nat->masq_index = out->ifindex;
 
+	memset(&newrange, 0, sizeof(newrange));
 	newrange.flags		= range->flags | NF_NAT_RANGE_MAP_IPS;
 	newrange.min_addr.in6	= src;
 	newrange.max_addr.in6	= src;
diff --git a/net/netfilter/xt_NETMAP.c b/net/netfilter/xt_NETMAP.c
index 7da065a472e0e..8bcb3f716d68a 100644
--- a/net/netfilter/xt_NETMAP.c
+++ b/net/netfilter/xt_NETMAP.c
@@ -44,6 +44,7 @@ netmap_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 				   netmask.ip6[i];
 	}
 
+	memset(&newrange, 0, sizeof(newrange));
 	newrange.flags	= range->flags | NF_NAT_RANGE_MAP_IPS;
 	newrange.min_addr	= new_addr;
 	newrange.max_addr	= new_addr;
@@ -91,8 +92,7 @@ netmap_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 		new_ip = ip_hdr(skb)->saddr & ~netmask;
 	new_ip |= mr->range[0].min_ip & netmask;
 
-	memset(&newrange.min_addr, 0, sizeof(newrange.min_addr));
-	memset(&newrange.max_addr, 0, sizeof(newrange.max_addr));
+	memset(&newrange, 0, sizeof(newrange));
 	newrange.flags	     = mr->range[0].flags | NF_NAT_RANGE_MAP_IPS;
 	newrange.min_addr.ip = new_ip;
 	newrange.max_addr.ip = new_ip;
-- 
2.53.0



