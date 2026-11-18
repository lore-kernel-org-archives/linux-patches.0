Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016793;
	b=fVhEcRRnKRf9f4qYAqbMNkdDuSw1hiAzJQxfdpjA603gPORCqtftsTX9jXfobkTo6PwM
	 tPkD4EHNRgDKXchYehAuhiayAH85DWJSaTLmWJ+vZi+3rG/SHrZcQMQoOEeVtlXdHcPg9
	 JkUpJbO2GmMBBInXFIOPaaf3Nqe0mk5E7K70fWbI94+6mEeO9GxbizwVsdOH6d78wDjdh
	 8/pyBUD4RvvpK65ehwpgr9rCdlhpjxUchGgfFunQafyPg/2kIj8gOg2x+737JxlphMZ8m
	 2wljZhIVqLs1sC7yd2Hzl9HToCaZM0cFI+ly47U+QziFkBDPq58tQcY8hFagtcz9bqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016793;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7ZJRRm84oA6SUDIpE8iLp+ZqgMsNrUeHJdCMXTW0U4I=;
	b=QC4/h0rtbpOvKewZVKq/eIFH/J/qywr19Gc41jkJqMPc+7CfVUcq3lzQLwzOyd9EMk36
	 8oBBobBpQJjlGW//Ma1aHeiCYDJwHD0YVWrMBh0NMdPYUzQ2BxRYLBMhM2eut/fA8dNZz
	 kQrBf32RdWjmAE6lJn3D9jm3OmoGM5l9BAgKvRO2AnKEXDm27HG9x6bYKvF6MKetKY6yg
	 Isa+zCSYzXtJPdEE5KY1p7/JHwXUWj5TDt/OA8DefoSg4E9RqgEe/rjtDhm7ZQ2pOLg+W
	 yoeaBJbUDbs5+e0Qx0bxRuFXM0oi3w6fC6xOSRDja290xMrEuf2yBJvs2HAKnHDclCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CLVlfzl9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E76606A31C;
	Wed, 18 Nov 2026 15:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CLVlfzl9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A01921F000C4;
	Wed, 18 Nov 2026 15:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016793;
	bh=7ZJRRm84oA6SUDIpE8iLp+ZqgMsNrUeHJdCMXTW0U4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CLVlfzl9vzsVeatUWrq7fcP2cBh4xrn14Npt8MlYvPtl8ThQU+hhN1UfGNGB7i8vX
	 Hc0BUAHTa92M4wDZkMtHtUIFcsQzX5uiYsdSrd02H4yT7Woc7ekAQ7ohvf+813f1fV
	 HyDsy7tOb/Nx5JLDMBSE/oJ7ycegdPnczEyGRtuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0648/2651] RDMA/core: Fix partial copy of IPv6 flow_lbl in LAG hash skb
Date: Wed, 18 Nov 2026 15:31:28 +0100
Message-ID: <20261118150311.015931409@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 00fe241737ffe..88aac911e8ee1 100644
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



