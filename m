Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064147;
	b=G3/cuilQKT8oE0l0j9cvWTm75xhW0SV+5ILDiFjLEPEAvxko7WtCQ83AT9yOKIYBH8KE
	 3lDcJ9FUYQjaVHu10Pg2rr+9f+EmjYddUCmDQbVLIksg+tr+CybCpsnGylKiKXV8X1xU3
	 QSKgYzKnzRMvyeuo8wRIp2mf39zA085gKpPxPfz0mxnGINAs7A3qjkS3FhPRM9E2hlzNL
	 AoMFogJZ6z6v18GnDsLq7x850W7MjO6fv86+MgBc7bSqyU3Kjmj8qn47vIhy0u0/+Zn+4
	 9pXB4IQaeUBfL+gIYYpmlI0natFd600haA+MEE/RlYDtEcqnCu1bLgV7g43lzKA3iLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064147;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c+Ec4khDoMw1qnVbVJaxI2luT9FpcrmowVeHXdKw53o=;
	b=2E8vkk7aucCJAg9N51tAUfH++UT0mdT9QuE1TmR8lF8YGJgJYowlFsvHe0fnH6N2x06Z
	 Mfefo51UCEUo08A93MsVdqElwK/qe/yH53c3Cd3iI4vKsO8tixXYIzLJRZmJRJzBlKf3H
	 hxEHF/eKXoQndqtTdEvGJhCBghu6PVC1BSao07tmRiEHlI6X5LmNff4Q91qg9Fp5dbI1w
	 Taoe01XtmfrAAb4X2AGuGQ9D4YIy6/J4DZOvAqetWss6CAd8E+f6dkkPQh0xwooqlc4Se
	 IRLGUCAThU6PwpdW/M6t1FPiWRyPOAKGItciYQ3a/mzuec7xRrHt30xlEhv4wFcmL3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jcst1P6m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6774606A33F;
	Sat,  7 Nov 2026 15:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jcst1P6m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 840931F008A3;
	Sat,  7 Nov 2026 15:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064146;
	bh=c+Ec4khDoMw1qnVbVJaxI2luT9FpcrmowVeHXdKw53o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jcst1P6mNNNZ1ptYz/NTBmN7RWsxODbvs2/65QhHTpv9PA0TiPVbObGYPDd1CbUqz
	 GJuX5kZEzpVtfgrzVxKZXyOdkl79x3mo3TiS4lpwTnyON0IqNiVYRHjjRwJXHkl+Xq
	 bz0v8rC5+EusTl18dxhI9OT7EnYgGfgHc5EFucXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0255/1257] crypto: hisilicon/hpre - fix ECDH destination DMA mapping
Date: Sat,  7 Nov 2026 08:42:31 -0500
Message-ID: <20261107134946.546499221@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit 12d8edda8cdb41d18c4891851e25bf58be6be995 ]

hpre_ecdh_dst_data_init() rejects valid requests whose output length
does not equal ctx->key_sz << 1, and maps the user buffer using the
user-provided len instead of the hardware transfer size. Drop the
redundant length check and use ctx->key_sz << 1 for dma_map_single()
so the whole hardware output is mapped.

Fixes: 05e7b906aa7c ("crypto: hisilicon/hpre - add 'ECDH' algorithm")
Cc: stable@vger.kernel.org
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index bad9fe5d8c3c2..64294b3a48f15 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1512,13 +1512,13 @@ static int hpre_ecdh_dst_data_init(struct hpre_asym_request *hpre_req,
 	struct device *dev = ctx->dev;
 	dma_addr_t dma;
 
-	if (unlikely(!data || !sg_is_last(data) || len != ctx->key_sz << 1)) {
-		dev_err(dev, "data or data length is illegal!\n");
+	if (unlikely(!data || !sg_is_last(data))) {
+		dev_err(dev, "data is illegal!\n");
 		return -EINVAL;
 	}
 
 	hpre_req->dst = NULL;
-	dma = dma_map_single(dev, sg_virt(data), len, DMA_FROM_DEVICE);
+	dma = dma_map_single(dev, sg_virt(data), ctx->key_sz << 1, DMA_FROM_DEVICE);
 	if (unlikely(dma_mapping_error(dev, dma))) {
 		dev_err(dev, "dma map data err!\n");
 		return -ENOMEM;
-- 
2.53.0



