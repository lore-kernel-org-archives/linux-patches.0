Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215119;
	b=XtHsPl8V6ChbovWS2XcvHzc910TCv/4EgueKwtgfChtW0oHpsJ5veuBvVLxh7bqRMGB+
	 BB9gvqx0k3/1I5xJHsIRSeOSfjhMAXek3QbIcICIRmuWr9MnbsHgMTlJZgfqwZXhEZ7IX
	 P3esp76avQ5BqLgiRHNyZCF/4fneGkz1D+kM7ZKbIssE2OgRMjWEm4WVk0FkKBuyMBy76
	 KXKz8BZXlGY98iiLphmZ8Ag+o6/3dhGYqR4VduxOC0CE9GKt+i3yrdu6bVmJFdxvXMKjp
	 ckkx11bz6ww8k84sFOLisOaErHgxHeWfM9zE3D0DCtkpP2icWZEm8JY0j9ZnnvIWn1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215119;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zg66qxL0MkCBO0HcSkglmTQ32Q6EoXAnfNkEN7LYDu0=;
	b=iRPOrlxp635gvwlo8hlC3gBprLQmO/FF4zjIKRmQ9+7vhSbh26g7xr6aPnjoSnswqtny
	 bQ0Hlemvwi0xfw5XKvHWwl7EV/rYFa2nm35dZVgR4cQcqwvM+SSJ6W8tFsRFbTNJVUdk4
	 GSb9/8pDN16JrHLWgc0nxToCPAUvc5R/jq3VGTEpVC6XKrQjbRobUsoh73wvubNJAbzen
	 4kIWxkUtDlZMhAkh4bzcdGYFlCKGWzhoeaX9VZxyPZu6j7vyEGptPzWyEn5/PaTCiQKOe
	 e/GJzSD6SAqKXa8ms5cQxbVs0PyJZrCErIPayCYF78/f8BVcSi3Qs5ByYGSZfqiDATw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JmnTj0eJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753DA606A31C;
	Wed, 28 Oct 2026 19:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JmnTj0eJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A551F01825;
	Wed, 28 Oct 2026 19:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215119;
	bh=zg66qxL0MkCBO0HcSkglmTQ32Q6EoXAnfNkEN7LYDu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JmnTj0eJBmeaoVRRkWIX5bA2+TCcB8IcPOt7O8hErT/615J75hb/cvK5LGCbyOj9I
	 9sFzpPMpx1X4bUXVygY6dunDTBOxfsWwdv9GQq4J0pDg4nxJJpDDNBKCSzynEw7I3+
	 OSiIMHQQOmB0BSboeoK7twSRBBNjwv2khvrNVaP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1100/1887] netfilter: nft_ct: bail out on template ct in get eval
Date: Wed, 28 Oct 2026 17:53:16 +0100
Message-ID: <20261028170524.436732995@linuxfoundation.org>
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

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 3027ecbdb5fdf9200251c21d4818e4c447ef78e1 ]

I noticed this issue while looking at a historic syzbot report [1].

A rule like the one below is enough to trigger the bug:

    table ip t {
        chain pre {
            type filter hook prerouting priority raw;
            ct zone set 1
            ct original saddr 1.2.3.4 accept
        }
    }

The first expression attaches a per-cpu template ct via
nft_ct_set_zone_eval() (nf_ct_tmpl_alloc -> kzalloc, tuple is all
zero, nf_ct_l3num(ct) == 0). The next expression then calls
nft_ct_get_eval() on the same skb, treats the template as a real ct
and hits the 16-byte memcpy path. With dreg at NFT_REG32_15 this
overflows past struct nft_regs on the kernel stack; with smaller
dreg values it silently clobbers adjacent registers.

Reject template ct at the eval entry and in nft_ct_get_fast_eval(),
mirroring the check nft_ct_set_eval() already has. Additionally,
bound the address copy in NFT_CT_SRC / NFT_CT_DST by priv->len
instead of by nf_ct_l3num(ct): nf_ct_get_tuple() zeroes the tuple
before pkt_to_tuple() fills in only the protocol-relevant leading
bytes, so the trailing bytes of tuple->{src,dst}.u3.all are
well-defined zero. priv->len is validated at rule load, so the
copy size is now bounded by the destination register rather than
by an untrusted field on the conntrack.

[1]: https://syzkaller.appspot.com/bug?id=389cf09cb72926114fce90dc85a2c3231dcb647c

Fixes: 45d9bcda21f4 ("netfilter: nf_tables: validate len in nft_validate_data_load()")
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_ct.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index e2ef510ab0489..f35cf4e600379 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -88,7 +88,7 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 		break;
 	}
 
-	if (ct == NULL)
+	if (!ct || nf_ct_is_template(ct))
 		goto err;
 
 	switch (priv->key) {
@@ -190,12 +190,10 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 	tuple = &ct->tuplehash[priv->dir].tuple;
 	switch (priv->key) {
 	case NFT_CT_SRC:
-		memcpy(dest, tuple->src.u3.all,
-		       nf_ct_l3num(ct) == NFPROTO_IPV4 ? 4 : 16);
+		memcpy(dest, tuple->src.u3.all, priv->len);
 		return;
 	case NFT_CT_DST:
-		memcpy(dest, tuple->dst.u3.all,
-		       nf_ct_l3num(ct) == NFPROTO_IPV4 ? 4 : 16);
+		memcpy(dest, tuple->dst.u3.all, priv->len);
 		return;
 	case NFT_CT_PROTO_SRC:
 		nft_reg_store16(dest, (__force u16)tuple->src.u.all);
-- 
2.53.0



