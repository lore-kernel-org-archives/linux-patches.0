Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704916;
	b=u2v7/3fd81tYOH3j9ghJ+7fz/OHYlZtJ4t/UhgsOR4uehz92rckOli2wt3ilvNC8v5wu
	 h2p143k1emrYkjvfOiv/1UaKzLn4prGF8/kKIYY+qIc6+7kzeW8HTBvc3446RX5QOM3VI
	 HfD1X00y1+vLPUlcwsDDo1ib+g1FxtvhM5Ls8vV3HChpplRMabjF2Gg0FmX9+kcTXXcS+
	 whj8BjH2Bz8NT/rzHzcm9DHg8bcvaDZ5RJZrje6Gw/DtL9Lz6FYc6ARBvoRXwzc8+mE8w
	 e5pbCECJ8lVZFs27epglcb9jTTObYAAInJ8Ohc//Pr29b3+f3s9BrXezkrWs50LjShA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704916;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WPHjeaelukrD8paaS2kPfKoVZqpHVmuCqozgswpnVJ4=;
	b=RJn0fzSKp+OU4G7xl7yhaIqFMlFvcqZWqV2gfLPzSCNsJa2APSgFzO2mm2WFbdY+65IU
	 /oOJc3bkJUuErXTl/jin7ZB8ahm/EZiJOMjNOhIB7kqO6waq05bxva7sEu9pGWPHtq4/O
	 6AlQIRS5DOybZgbU6n3oKkzg9A69slJNIYv7ltZFBB3MjURm4fyiARAGfEVIJMv0sQpQs
	 v9T8Qj4NvmC59+aO0dBSBBC5NB4/N+7Yn1WYkuel21iqOE91bihvjaRsnMqk+Ipg9ZXGq
	 U+91lpOvbkdeLko/a3KKa5BuzysSyJwwc2KFK/dsoWiOpILgPvMSTn+HJnfsxK1kFng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C9R4pc2w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57648606A31E;
	Thu, 26 Nov 2026 14:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C9R4pc2w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D341F000C4;
	Thu, 26 Nov 2026 14:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704915;
	bh=WPHjeaelukrD8paaS2kPfKoVZqpHVmuCqozgswpnVJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C9R4pc2w0hmVrlY3/O7SYLIS+3WMQy/XnK7EluBj/8bz19m5q6KQGOW2F8wf2RfEe
	 TczMBxtZdW++iumVIxt1aQLlM4Qts8q0F9NMPmgncQXt3Rb2BmZVHQEuMVr53iVu88
	 ZRY4LYSvVH5Ln/XmoyI5yyEK7mUxjqP5ekD+nd6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Mark Bundschuh <mkbund@amazon.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 002/319] netfilter: nft_ct: expectation timeouts are passed in milliseconds
Date: Thu, 26 Nov 2026 15:36:10 +0100
Message-ID: <20261126144006.793159536@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4e723257f356d..af58d86b07838 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1184,11 +1184,23 @@ struct nft_ct_expect_obj {
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
@@ -1224,8 +1236,11 @@ static int nft_ct_expect_obj_init(const struct nft_ctx *ctx,
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
@@ -1245,7 +1260,7 @@ static int nft_ct_expect_obj_dump(struct sk_buff *skb,
 	if (nla_put_be16(skb, NFTA_CT_EXPECT_L3PROTO, htons(priv->l3num)) ||
 	    nla_put_u8(skb, NFTA_CT_EXPECT_L4PROTO, priv->l4proto) ||
 	    nla_put_be16(skb, NFTA_CT_EXPECT_DPORT, priv->dport) ||
-	    nla_put_u32(skb, NFTA_CT_EXPECT_TIMEOUT, priv->timeout) ||
+	    nla_put_u32(skb, NFTA_CT_EXPECT_TIMEOUT, jiffies_to_msecs(priv->timeout)) ||
 	    nla_put_u8(skb, NFTA_CT_EXPECT_SIZE, priv->size))
 		return -1;
 
@@ -1295,7 +1310,7 @@ static void nft_ct_expect_obj_eval(struct nft_object *obj,
 		          &ct->tuplehash[!dir].tuple.src.u3,
 		          &ct->tuplehash[!dir].tuple.dst.u3,
 		          priv->l4proto, NULL, &priv->dport);
-	exp->timeout.expires = jiffies + priv->timeout * HZ;
+	exp->timeout.expires = jiffies + priv->timeout;
 
 	if (nf_ct_expect_related(exp, 0) != 0)
 		regs->verdict.code = NF_DROP;
-- 
2.53.0



