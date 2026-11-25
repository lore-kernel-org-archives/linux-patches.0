Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621705;
	b=cmdkuUEy8BCDY8eSH1vVE/9IieSRVXpdcni9iz8rRhbrSR+srrLewzEaM30TzvjSJD+N
	 rgmlg3WR7JF2J5k/VUS8jw+6uxbWsJujE5T/3RrN0/tjtpsy5W2/4mJLSFjmJNd9D3p3x
	 Tf4Djlb3J/Xxgt6kBEKhH4GWlaC+6f/z+OyP8ULccC5wH2XucdheM/t8vvC1XbGj4pODF
	 lhs+xM14PdoKJn9b7SqpIqsa8n7CXocTWQ5MkmPJReM6E+UsBnpxzkSOAviLcVmktdHgS
	 MMQ0HLpW9FPuK4LH7KBP5bGDabKL+08kembV/gqHldUK0YC8TDXHVIXaeYUG80pkkXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621705;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=35OqlTFr7Ozmk7sH87le3Lxyd+SSpe6xhKoX0CxwFNc=;
	b=Z2xDYsxiNWCxQ1rYO8G2P6R96qzrqqo87KVcs9oxUuDy447wHzHSXknmIpaBVt8JpK3T
	 VD8PS/akbDZfHsIVuYwkxokEJa0DBukB8VzccDua7aYzYdfFf6AsdIy+dwhDURE11nm5l
	 bystlkk4i94uTFx5QtK8cFZpIUdhNtP+xg+0nHcEaZpB8mH6VP/D+IKxEGp6KyLD3CUJN
	 CX+QqK4HmLmscDgeolz/SkkMg2pYDigHU+Cq9oQ2jFZm4WBoqy+mwMN2044vo6pNPiyKX
	 fD/IxmnuS395YGWVeRDIY4QM3gjUEuKJhdGEHK9xJusEcRw8yN92eWnRMsh6FtjW/BA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qpJeFEzJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE76606A32E;
	Wed, 25 Nov 2026 15:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qpJeFEzJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A7E1F000C0;
	Wed, 25 Nov 2026 15:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621704;
	bh=35OqlTFr7Ozmk7sH87le3Lxyd+SSpe6xhKoX0CxwFNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qpJeFEzJLB3x3LyY9Tsd5yCUCBbJDXADsvkvhvrGjnAyv0PuzjBqt/6Roy0tlv7L5
	 Muw+unOYheW7HdJWhncDyp48uuxzhsaDXCl2CgonLyCdwNxPGprSrkzvxdhvzJt2Mx
	 ZCnsqQHubFF81zezCU6kjHs2zP7IWjk778Kwv2mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Xia Yan <yanxia@cmss.chinamobile.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 255/990] net: skbuff: reject zero MPLS TTL before decrementing
Date: Wed, 25 Nov 2026 15:27:02 +0100
Message-ID: <20261125143828.065166235@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 24614e72df484ad50ecba98aaa88c7df2448c122 ]

skb_mpls_dec_ttl() decrements the u8 TTL before checking whether it
expired. An incoming TTL of zero wraps to 255, causing the TC MPLS
dec_ttl action to pass an expired packet instead of dropping it.

Reject a zero TTL before the decrement while preserving the existing
behavior for TTL one and valid TTL values.

Fixes: 2a2ea50870ba ("net: sched: add mpls manipulation actions to TC")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Reviewed-by: Xia Yan <yanxia@cmss.chinamobile.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261031114135.3784868-2-thnkslprpt@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e28802a46fd29..f1b0045667124 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6713,7 +6713,7 @@ int skb_mpls_dec_ttl(struct sk_buff *skb)
 
 	lse = be32_to_cpu(mpls_hdr(skb)->label_stack_entry);
 	ttl = (lse & MPLS_LS_TTL_MASK) >> MPLS_LS_TTL_SHIFT;
-	if (!--ttl)
+	if (!ttl || !--ttl)
 		return -EINVAL;
 
 	lse &= ~MPLS_LS_TTL_MASK;
-- 
2.53.0



