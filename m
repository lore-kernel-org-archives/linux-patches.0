Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048552;
	b=rRKtiFLDyxy8BxmZDizk8SK1yLrOEgQeYXn3CIkHIdxRGoVtSDssOo5aPLzzEd5ekzS/
	 faVuU4ACD6BnWuhmJCBtOHMVLxEIsX0WFlQ+Ct4PGatHvOE3beDX5/MV89MC9lTGf36Uk
	 YQero/YvZ/+opqgaXQnaO97UG+QN8oZICOQwhoUuGDF5RRvj6ay9pfDvlOuwwQAd2WYQE
	 z10pjJcU4LxT9H/f0tlrXhGGeb8g2elmtiyHr04VLIvZE6h/hFpp0vUkhAgawONSFX2c/
	 kWsLEzqkq/eixv22QWkUaUY0D1g/cOEGe5kV//WXYFxz4DI/6Zkh2fscqwIcjBK55xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048552;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/kTb85x8Khc5aRAqAYuT3jgvehuQuqZJoUqvIAp/gss=;
	b=3ytgxiQKlUcu+c9i3tAkqs2GuhZ9xyIOOwYddCED7oOyYwVNmBYqV99JUS841YpVIKlQ
	 pqyBGgri0TplW9qeww4gmAWYKifrzGsqQJ1ZyAjSZLUNBcgW4P3dPE5BM5HjLLwysGaPV
	 17DmMhIKTbwRO7cFTkm6Moggs8TOVS6VCdAh8FAsMzvBdm3+EDq2H4AihzmoACNSReCMm
	 DXnZAYRdFYti2n33TZBfiIxcQ2zRaN1BGLXTtSYqcf+zyWNCR5Fnq+cuudfm6VIRxeLY6
	 pqPhkoXL0e3EkbIKA6FayFXS/JlGr0aRMy8xzN5rWm6fA5NJs7wDR7A7mQMJlwl9jKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WuUwcB68;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0463606A325;
	Thu, 19 Nov 2026 00:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WuUwcB68
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105031F000C4;
	Thu, 19 Nov 2026 00:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048552;
	bh=/kTb85x8Khc5aRAqAYuT3jgvehuQuqZJoUqvIAp/gss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WuUwcB68tCe7pVNdGTtKJQl6XDAH4WWgAPZqdbSV4kWHjkFjD7zch6X+rCp04DJd+
	 BrTVBcXUEliSzXAgnJCiECYPiAH4Yf8+RvtP2IDz9vu62wHwXYv4yYgc9gH+Z6qZD3
	 lRPyY6HVg6oMi+leMICfaWiO6+Fl9q9zqDN7CQf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1994/2857] RDMA/core: Fix partial copy of IPv6 flow_lbl in LAG hash skb
Date: Wed, 18 Nov 2026 15:50:28 +0100
Message-ID: <20261118150313.170309872@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index c77d7d2559a11..c18642accfce5 100644
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



