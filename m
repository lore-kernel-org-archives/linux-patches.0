Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029847;
	b=Ol+wWy94BpYJVAYJUHRpB4AXuHAVjcGiUCX9mN6Shedbl6S6DmHO2HQPzL4RRR4Kx/Dg
	 ifWOlt417i6QK+eP5vUJJlxF5y/KZ6Smii/KxSbzaCR0d8jZ7GC0by9wMwHIm7/RKidjw
	 0alhk1B/zReBnHVEzq7vnGifkd4n0k/onL1XrBxDet+zUvn1PGKMl6jhhERkvHcx4U4cK
	 9P1+fq76r5uE1qMxWW6Le7811RYyc4mTqcMPeHJr/2l02K9GcJoOGSs/8dfq9bg0JvQSN
	 V9fHaX3F4Gx9AAcwmz4anfLg4rv4aPIuVZBhIvW4oVoeBqqQiwuWjwzmNj3wutloMUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029847;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KC8rlucVCv9zzs0eUjhnNyjQBMGaB4jhTCcKGS/K1ak=;
	b=gd8MSENmmNniueZVpX/54VKi04GXIvpBxLJOOnrTPDlZalK98a8qg1t3c1wVKAC0mHCB
	 jHfnvq8LRmF6JxUNvgpxhDDmJ3ebZxmZG6fmxAm7xJQ6TiH8fTN1mgyYHIf1/y4diZTdW
	 F5Rekmt1jWt3/fgOdgymxhuDTeVpZOfD5uR3rAyVsS69oleh5Qtibefy/de/beo6FCJjx
	 JkhSJcFkDxUXLgyByNaAhktLWCddhQwqijTu9jmm/Z/Xe+HzM0z+u3WiPUzHFGhgXUauZ
	 fT/Q8Ogx7BhAEMm61eMp7H+RY4+0AKL+oo45DZ41qK31Ga52ibBvTdSQA09BO9pbhvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W6FSsF2j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CE4606A31C;
	Wed, 18 Nov 2026 19:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W6FSsF2j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1E11F000C4;
	Wed, 18 Nov 2026 19:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029846;
	bh=KC8rlucVCv9zzs0eUjhnNyjQBMGaB4jhTCcKGS/K1ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W6FSsF2jQYflfA8qN0CI5wg3vw69IVSLmE/W0iv6Utz1FjXISUUnk1fextXApvqB3
	 f83PGOKdlGwH3hZ2pciMpp98ggd7MT2PKlJg7yL11jDNoY+lYJTarxJemVdMAnsHJv
	 z/1EI7Rh8GsBbQaTAqk39cwm1Y8MngUzG6Qv2+k0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0495/1756] RDMA/core: Fix partial copy of IPv6 flow_lbl in LAG hash skb
Date: Wed, 18 Nov 2026 15:43:42 +0100
Message-ID: <20261118150028.801893361@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit b63d21631f836528ef660d7b5a0d84890ff6dbd5 ]

rdma_build_skb() constructs a synthetic IPv6 header for LAG slave
selection and copies the flow label from the AH attribute:

	memcpy(&ip6h->flow_lbl, &ah_attr->grh.flow_label,
	       sizeof(*ip6h->flow_lbl));

ipv6hdr.flow_lbl is __u8[3], so sizeof(*ip6h->flow_lbl) dereferences the
array to a single __u8 and yields 1.  The memcpy therefore copies only
the first byte of the flow label, leaving flow_lbl[1] and flow_lbl[2]
uninitialised in the skb buffer (alloc_skb() does not zero the data).
The resulting LAG hash is computed over one byte of real flow-label
data and two bytes of kmalloc residue, so IPv6 RoCEv2 traffic on a
bonded interface can be steered to the wrong slave.

Use sizeof(ip6h->flow_lbl) (the array, 3 bytes) so the whole flow label
is copied.

Fixes: bd3920eac1331 ("RDMA/core: Add LAG functionality")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://patch.msgid.link/20260916120926.1761-1-lirongqing@baidu.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/lag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/lag.c b/drivers/infiniband/core/lag.c
index 8fd80adfe833e..eeae4b0898ee0 100644
--- a/drivers/infiniband/core/lag.c
+++ b/drivers/infiniband/core/lag.c
@@ -59,7 +59,7 @@ static struct sk_buff *rdma_build_skb(struct net_device *netdev,
 		ip6h->version = 6;
 		ip6h->nexthdr = IPPROTO_UDP;
 		memcpy(&ip6h->flow_lbl, &ah_attr->grh.flow_label,
-		       sizeof(*ip6h->flow_lbl));
+		       sizeof(ip6h->flow_lbl));
 		memcpy(&ip6h->saddr, ah_attr->grh.sgid_attr->gid.raw,
 		       sizeof(struct in6_addr));
 		memcpy(&ip6h->daddr, ah_attr->grh.dgid.raw,
-- 
2.53.0



