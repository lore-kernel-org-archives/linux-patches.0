Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705110;
	b=k+E8fMOgZl+WtcVHrtqR2Lwsel6IzGBXdsO1vnd4tpp004FJP/YEzVONl7r97Q3cQZTk
	 VIyB4osxS5L6gq7pIoV1q2y7hoQT3Qz0ryB3kx/R1lLK8qh/Rb0eNDJ1fX/2HplsRg0p0
	 3fl8G8ZTyfoK0rDwSWelwhtfePCRfySFAJhvtA6oTVxNXOkXHE9AN4SZoR/tWNnqcM6D7
	 quBFvU4qy/3qwrQGFpH701Aoz1hXi5cc2gDLqzUlmIi+T6EiTd9odImVf5ipaPz5IEdff
	 Vv5PLB3lNxUl1RaE6imie56dZ0//rsJ4BJOEO8BCnSOciUuRQVk02Qc+wAcQnbj3Fjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9xt/CAueG0AK2r5QkFxMcc72MBU010NIBftnqoGY2oo=;
	b=oAUeLsvvtmUWa+Fcw43aDaSy5wLnvDylCt4BWt4zCSH10BII35UChSFe+Lzs/BvLFssq
	 GFMK0mfve00s7YV5lkgdtZIlGtr7injQzpq9u+p5ScKNaRH+RNzCP1qkLj3BsbXioBTf1
	 rFrU8frechbxzmM4Iv5P0HC18u9mv0QvqORKt2Mu8dbT4A29HQmngcb8Z/GsqU+AMAc2R
	 exIbFIF1WDk+Reg2Oz6W1PwsdJu7UzDHbPfx1p7t7CW7oPtdgQc7F/Z1ySC5S1IERE4gu
	 raStlJksPzhDhPC18yDqv0qqHw/wWHgZjUsbKrZXEQlbyXP0pqHocR/eLzqBMzNwOGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NHrqs6qO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D05606A321;
	Thu, 26 Nov 2026 14:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NHrqs6qO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E63E61F000C4;
	Thu, 26 Nov 2026 14:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705109;
	bh=9xt/CAueG0AK2r5QkFxMcc72MBU010NIBftnqoGY2oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NHrqs6qO9WKISh4UONHpRW6Z0+VFIogormytu3gWTIc1BdUgZSdkOkrtt+8CAU/e5
	 fk4ewNYVRT1ywWtcus41n3SeyzvfxyazBXsCslEZ4Uyk+oYQiW/hSpYxdyfYIvmdwX
	 QB/KbWFOaNcjzpSrEFhPWeCg44yq8mtc6U4ruqGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Xia Yan <yanxia@cmss.chinamobile.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 087/319] net: skbuff: reject zero MPLS TTL before decrementing
Date: Thu, 26 Nov 2026 15:37:35 +0100
Message-ID: <20261126144008.707108570@linuxfoundation.org>
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
index 32511b77d8122..7dc2498b544f6 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6183,7 +6183,7 @@ int skb_mpls_dec_ttl(struct sk_buff *skb)
 
 	lse = be32_to_cpu(mpls_hdr(skb)->label_stack_entry);
 	ttl = (lse & MPLS_LS_TTL_MASK) >> MPLS_LS_TTL_SHIFT;
-	if (!--ttl)
+	if (!ttl || !--ttl)
 		return -EINVAL;
 
 	lse &= ~MPLS_LS_TTL_MASK;
-- 
2.53.0



