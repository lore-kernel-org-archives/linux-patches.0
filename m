Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034454;
	b=rcQC6cEJuwZ2cdZf376tQifjJ7ipKcpJOz8gT7qvPBJMkqrcmCwf0ii/Cyqy9UyLjImA
	 dkeDrJzT/at2hToUfJJ6o0xutLRmVlPuhD7Q92ogU1UfVTtQhq6ZgkYFluUpyJOn7bGr5
	 XkqzMJwBO4qbVY7uerYy6d2KcOCMVKGr+CKh3cRgDUovA0+n6wG0/5yBuFugP0DkvWtNC
	 mB4nJT+/vBDc9Mg/8RH4IAx41M5BTWCcEyinRFkf2IQRaZA01l9784aHJubvel4UKBsoM
	 2eyxKbHN4pZRygQ1akKXzPi72N8oXVb4nHC56e5h8ytgrKbw2RndctHq6A151QldHXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034454;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YQiWBm9FvDDzPd4RaI7XVIejM03H9hxDp3Af6HLncmY=;
	b=ws+QFZzOxxhfSqwIiiferyF9VvQZeepcd3kbA5TB9bQ5NL2Vj8k9e2D+5VXjBOVqGz+F
	 ElGJmYhwdUIq9Jdd+BoGAXdl6jqZNlauOAKsR8DS4NimfRMJpX5pd+ShUsWp95TpqpATZ
	 bl463X6oKeZSbb0OO1fGk7ziRU28eJDZX6sd3G3lDYu3yxrFGYGzAztAdZQy+E96L/QAe
	 57E+r/J1j9UbGr6TwjXSBTLzdlFY6nnwzPlbbwRZExC04L6qxQukLxVaYrnZCKYjq7D/m
	 oSkdVt0LwDotLyQXZpIS6GNjrWjUMqPP14zTc1+G3vFeFpViu/oh2/qiM8CBurYip9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gqB9xyrA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A93606A32F;
	Wed, 18 Nov 2026 20:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gqB9xyrA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883EF1F000C5;
	Wed, 18 Nov 2026 20:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034454;
	bh=YQiWBm9FvDDzPd4RaI7XVIejM03H9hxDp3Af6HLncmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gqB9xyrANDL4TseAMD9VkLl90dY+wR4GAur5BDSqhp5JBRCgjzc9pSpuSBts+1VXl
	 z6hRqdjnHgRRh23+sBUTr1gcDW7Fs3s1y+rsinZ9CQPj1GAj3GxR/n3c6HRUdD2Dh9
	 ONtv6zxjSygTPzvlb1KaE6xo9ZkKW1L22r2fxgos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0373/3318] netfilter: ctnetlink: do not expose expectation DEAD flag
Date: Wed, 18 Nov 2026 15:16:35 +0100
Message-ID: <20261118150327.406743049@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 322371b09058ad10d0282a0e7ec8eaa764e6aaac ]

Expose expectation flags included in the NF_CT_EXPECT_MASK bitmask
only. The DEAD flag is internal, do not expose it.

Fixes: b8b09dc2bf35 ("netfilter: nf_conntrack_expect: use conntrack GC to reap expectations")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index f4627a8ab6e71..895b617bf33df 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3039,7 +3039,7 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 #endif
 	if (nla_put_be32(skb, CTA_EXPECT_TIMEOUT, htonl(timeout)) ||
 	    nla_put_be32(skb, CTA_EXPECT_ID, nf_expect_get_id(exp)) ||
-	    nla_put_be32(skb, CTA_EXPECT_FLAGS, htonl(exp->flags)) ||
+	    nla_put_be32(skb, CTA_EXPECT_FLAGS, htonl(exp->flags & NF_CT_EXPECT_MASK)) ||
 	    nla_put_be32(skb, CTA_EXPECT_CLASS, htonl(exp->class)))
 		goto nla_put_failure;
 
-- 
2.53.0



