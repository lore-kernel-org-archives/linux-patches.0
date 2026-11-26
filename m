Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704138;
	b=RZY64IpFbFq/Wq07Du5+6EGiqMm/5ALr45srXfKFsUuZOL4ga8nsZOtFzV4ygXXpNQtZ
	 aInq7aE2ZG2blR8WrT04W6Ytc3m/4Cc0dkqo6gVUKJp/E40xvO8dpkO6tHu6Pb6Q0IL40
	 riuBAE1NUm+k5GqrjFuZDyhdwdR0A/zAIuLKu8FkbShfYRd2ch9QLZKC+M1Ncio7RqqwS
	 wIFxqifMzyto4a6kjwiMZepfakGn8h+YOj1hPBXnIOYvapPVYsLYMOFrJJqSWGvn/+f8O
	 2LMn2mNvAph+ze2zYZbLbduLmUxVWLXEADXU02yk1nzAJo8szND8KECQKquumSuPc6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BsnYDWbRsrcPL4tuqSRl2A1+YqT1Igw1lI+TMEEdTv0=;
	b=3NVyMQVxEM1X6MbjQQODx2V5ny0soIcADCOGh7aMuHPU1x6OsU8RXjRZ3/gfMxP8kjsc
	 vAQ3e/NdvyOBzKJxZ1g6ajy2cmtd7wAAJguKbwO2XLdN1RXiKb7cpmReBzGKG/Naxtm5U
	 zBVsWNmd1OGbvBGcMalFRy7X3BtLjTZ0qi8yZymc1/HtRtUBEotoizOXsf4ModuMqjCNH
	 XRJ2HIG//fI76dSG5jNBerv8p3EPZX2hpWMnvXE94WCmsJdjoNDULZ5asFu+os9RfTv1Q
	 UXuo0LI3mKnQXtQ+NU1Hst4ozggXLLrPi52+kVp1Sq405Z72ZVFn8/C87y1B6yLsYCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QABVmI0z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B653606A321;
	Thu, 26 Nov 2026 14:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QABVmI0z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C771F000D1;
	Thu, 26 Nov 2026 14:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704137;
	bh=BsnYDWbRsrcPL4tuqSRl2A1+YqT1Igw1lI+TMEEdTv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QABVmI0zO1UoWxcHLVfAZS8Sa38YgG/rWBsYWzjmd076iA/pcWdYn2rmLvCibk6od
	 jksAwtoAMEOz98yLt3zttb4eQ7fVkSbJ6HSXmHRnQd0HlPJhHAXLca9Q4wVYvcpGU3
	 ZXn8LuCyYho7ytGsmvvLU/RY6hP2dbbCmnUpkhCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Mark Bundschuh <mkbund@amazon.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 002/265] netfilter: nft_ct: expectation timeouts are passed in milliseconds
Date: Thu, 26 Nov 2026 15:35:32 +0100
Message-ID: <20261126143605.236144978@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 6fb421bd07f156cdf0cdede062d31f1c21def326 ]

Userspace passes '5000' in case user asks for 5 seconds.

Allowing for sub-second expectation lifetimes makes sense to me. so
fix up the kernel side instead of munging nft to send a value rounded
up to next second.

Also note that this violates nft convention of passing integers in
network byte order, but we can't change this anymore.

Fixes: 857b46027d6f ("netfilter: nft_ct: add ct expectations support")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 3679da4ad8be ("netfilter: nft_ct: move custom expectation support to helper")
[ b8b09dc2bf35 ("netfilter: nf_conntrack_expect: use conntrack GC to
  reap expectations") is not backported because it replaces the
  expectation timer with GC reaping in 9 files, so timer_list expires is
  set, and mod_timer_pending() after insert. ]
Signed-off-by: Mark Bundschuh <mkbund@amazon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_ct.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 5e4ea0f800d28..a17357e4a59a5 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1181,11 +1181,23 @@ struct nft_ct_expect_obj {
 	u32		timeout;
 };
 
+static int nft_ct_expect_timeout_get(const struct nlattr *attr, u32 *val)
+{
+	unsigned long jiffies_val = msecs_to_jiffies(nla_get_u32(attr));
+
+	if (jiffies_val > UINT_MAX)
+		return -ERANGE;
+
+	*val = jiffies_val;
+	return 0;
+}
+
 static int nft_ct_expect_obj_init(const struct nft_ctx *ctx,
 				  const struct nlattr * const tb[],
 				  struct nft_object *obj)
 {
 	struct nft_ct_expect_obj *priv = nft_obj_data(obj);
+	int err;
 
 	if (!tb[NFTA_CT_EXPECT_L4PROTO] ||
 	    !tb[NFTA_CT_EXPECT_DPORT] ||
@@ -1221,8 +1233,11 @@ static int nft_ct_expect_obj_init(const struct nft_ctx *ctx,
 		return -EOPNOTSUPP;
 	}
 
+	err = nft_ct_expect_timeout_get(tb[NFTA_CT_EXPECT_TIMEOUT], &priv->timeout);
+	if (err)
+		return err;
+
 	priv->dport = nla_get_be16(tb[NFTA_CT_EXPECT_DPORT]);
-	priv->timeout = nla_get_u32(tb[NFTA_CT_EXPECT_TIMEOUT]);
 	priv->size = nla_get_u8(tb[NFTA_CT_EXPECT_SIZE]);
 
 	return nf_ct_netns_get(ctx->net, ctx->family);
@@ -1242,7 +1257,7 @@ static int nft_ct_expect_obj_dump(struct sk_buff *skb,
 	if (nla_put_be16(skb, NFTA_CT_EXPECT_L3PROTO, htons(priv->l3num)) ||
 	    nla_put_u8(skb, NFTA_CT_EXPECT_L4PROTO, priv->l4proto) ||
 	    nla_put_be16(skb, NFTA_CT_EXPECT_DPORT, priv->dport) ||
-	    nla_put_u32(skb, NFTA_CT_EXPECT_TIMEOUT, priv->timeout) ||
+	    nla_put_u32(skb, NFTA_CT_EXPECT_TIMEOUT, jiffies_to_msecs(priv->timeout)) ||
 	    nla_put_u8(skb, NFTA_CT_EXPECT_SIZE, priv->size))
 		return -1;
 
@@ -1292,7 +1307,7 @@ static void nft_ct_expect_obj_eval(struct nft_object *obj,
 		          &ct->tuplehash[!dir].tuple.src.u3,
 		          &ct->tuplehash[!dir].tuple.dst.u3,
 		          priv->l4proto, NULL, &priv->dport);
-	exp->timeout.expires = jiffies + priv->timeout * HZ;
+	exp->timeout.expires = jiffies + priv->timeout;
 
 	if (nf_ct_expect_related(exp, 0) != 0)
 		regs->verdict.code = NF_DROP;
-- 
2.53.0



