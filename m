Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217361;
	b=oQL6/8j+mkYf1z7NSul8ITChjv4JJn4OVcDijwTf0Ail14qWk28BPBJaXTuzrxmYJmWx
	 qIShlYNVJSIvf7O6LYdCzvmxKd4az+Z3Toikcfu8MBWEz3mw6CLkbNvKcqBz2s8EdrZkT
	 eK/oI/WGNbiWfdKPZo/MfMZb0NtjtWINvBgY4uZQndbb6qnG17HDHfhftbuvVqB++D2NY
	 9XnNOtN7EX42L0MD4AOwM0IVVsO5o33tp0PVuSz+VZBhZhTDCtjOGy96UacSGf7poZy9V
	 RbhpBOmHCYN9aeS9ieeNhFOFwUS/G+xLBP4Wll7oY+yCDzyMnRbYeBo4juw8eQClSlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217361;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U+nRZGQWvvO2c1PsaARzFMtNGXD5fT7HOIqK5RakcTg=;
	b=kFxscCcNvPp8B0Y/srO2F3MXtlxqh1HI4x3JfjvUdUFfq1pW0AJ9PUt/trPeRDhS9qL6
	 WeAqmxxW51/cmozj940xrUbSn9lPj4fgNMEbVBlLxgrpLx/zhuENzRt/uHpdh8OU4UXo4
	 scTEtWJGSWUN0z2IkyTSWaGuKu5/JX5bGrmlW6X1Eb6y/hTvEgEDDR8OKkUl/dfNSw7OX
	 VVKGr3hS2OV5kpg7EO8LYwP91HsvFm7Ee/OmnyAlEITWsPpjJEsAOTeFAH00UASvz63LN
	 0JUxWReEENrmfj1kpTB8X4jengckqKvyBfJw0qDbclPKzAjhCVUL3vKRAo1Y7Lkfgew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F0zZHdj8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF731606A31A;
	Wed, 28 Oct 2026 19:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F0zZHdj8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0391F031E1;
	Wed, 28 Oct 2026 19:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217360;
	bh=U+nRZGQWvvO2c1PsaARzFMtNGXD5fT7HOIqK5RakcTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F0zZHdj8HUOZbSYCy+Muw84Eh74REoL3t+wsfB5SmGiM+qkpLzpBFT+BaM5hc8ILC
	 hmlE4Nh/tUswuWN0vkyCMvA5Pz6ynnA/tPKjbPiN8/I/SQWhZz+se4txe4JlpUxoQu
	 RonH59cZmgH2VVROdnZ3JBlO46jQ0dH5VMyvUYqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1875/1887] netfilter: ctnetlink: do not expose expectation DEAD flag
Date: Wed, 28 Oct 2026 18:06:11 +0100
Message-ID: <20261028170542.123941990@linuxfoundation.org>
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
index f45998d5772b6..b0ec7f7790bab 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3043,7 +3043,7 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 #endif
 	if (nla_put_be32(skb, CTA_EXPECT_TIMEOUT, htonl(timeout)) ||
 	    nla_put_be32(skb, CTA_EXPECT_ID, nf_expect_get_id(exp)) ||
-	    nla_put_be32(skb, CTA_EXPECT_FLAGS, htonl(exp->flags)) ||
+	    nla_put_be32(skb, CTA_EXPECT_FLAGS, htonl(exp->flags & NF_CT_EXPECT_MASK)) ||
 	    nla_put_be32(skb, CTA_EXPECT_CLASS, htonl(exp->class)))
 		goto nla_put_failure;
 
-- 
2.53.0



