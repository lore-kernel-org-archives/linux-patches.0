Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024054;
	b=l1JwdqiDBtJKYLYyadO8l3C/cjmg8Zm0hYzzNvRK9lWtxeYoLYEc4jl7Nohu4MrWAbKW
	 uOlF5hPzu/9P04yRMiusYcrwpdRLQIqhCi7rQomVisXM9E9pIbPXOk+886Ipj+OUjqBXY
	 jtHMo43ildQCW5l4v2xH0K56KTpnQymSx51w8zi93NpyE4xnoVhjb4wjZmrCHpN5rpuPD
	 0s9fx3QBETXZ3yGjT6NbUrwqFBqax78cQk1Q7O0ehIEOyFybpPOnlX+Yjrvd5HSRKlwvW
	 +3SEomc+HmVxEHRdv/UE0VKDSNYpsTJ+oeSZ06upMXgcFgell3ZORq75odP6bWuaYdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024054;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WGa0SSsJ1C7rzz1alQwLS+GsowR03iyI23292rxSFvc=;
	b=fGWTwk1bWOP6EL9QkK98ZUmQLcKC1FC6YwkN9HExlua56u8ZTHZTPVNLWLJWSuQ90BFk
	 ZQj5B6z+MTe7mmcYSS7B/p0Ll+OogTcf7w6B/D9LC8ih1R+xaJ97l7u5ywhYLoVJIAvOz
	 yXAbq0sE6dMk/yi0msW6PVlshHNitQe/GqdA8TSJPPTQAj9PVtubWLHKoFxt75iUw4fah
	 Lm71LWqwRis5XB1q4Y1aY3BWx3Wx+MDenwMcapFBwczlQQq5XYiLB6lcF4MH40rEMw7pl
	 Q3k7bS8vICe0Zfa6Ptfpb0sWu0xsCi24N5JwU7mQNDY8xsghsZyb0jRJqx09G9QELIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NrPpOo9r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F860606A320;
	Wed, 18 Nov 2026 17:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NrPpOo9r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D3F1F000C4;
	Wed, 18 Nov 2026 17:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024054;
	bh=WGa0SSsJ1C7rzz1alQwLS+GsowR03iyI23292rxSFvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NrPpOo9rfXXz8WuE2dQLUj5aObRUNHso1WJZwxDO+/Q+wb3U0yxUEK0EEVs8G2Pe0
	 f/2/dc+njNJ15aOHr1oBtgA5y3/7JMn0NMX59INn5oCUU2T+0q67s4lcwPTbgjpXvK
	 WMtOIwxVOj99qCTGncBdyA0gWWyTyy9xyV8wLKpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0588/2151] RDMA/core: Fix partial copy of IPv6 flow_lbl in LAG hash skb
Date: Wed, 18 Nov 2026 15:38:43 +0100
Message-ID: <20261118150143.373995589@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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



