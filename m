Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062102;
	b=BEgB7LHYBh20dGSVOTYgdiuGm9HESLDnOjdkbvkMLGawAFqO6bIvF/q9+GcrCCUGfeDA
	 Xf/YZKH3mGkTC3OrnG0TtrRc5PfmRVB7oowuglhyfUpkh+988ucz8IAHrSqaX30sma5AP
	 cze36kwFVCakYVO1zMen6zJMNKyUc9LhLVokSWWgbzlgV4+A/Z8PxL7xJV1ZJxnnbaXRA
	 cqN5+2kpBbb5xtVqPegXEAmvTQj8zJyrrExM36OTFASyZ3sazLZSPn8kOOg6xphdrCFu7
	 F8W5KwfUYk3R+QgN2kRBqbkluqidlacuWQiI6xs8t9+Mu8L9Kc5GVQmSybeLA8n4lHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062102;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HI2Z8qP4sNBRleJUW0Bql0GmvDo4YDiXX5pr/KeV7dE=;
	b=03WNwQiCiHwTrGMGNKhp+s/ceXCmE6fWxnaF4WP3aWZONEZh0LXPLtqcnkLzISfem2Br
	 i6/6skojcYeM0PI+//dY11yAjUMw8hTIWgDC5JalMv91zecSEZkS5m6/p7h3fnVic6QG+
	 E6yKvjPmQtsRHYozvBZKyYPsQQamMDVQJZtIYCT/CO5Pyr5qLhQ19/a9vlYzjy004RpWl
	 HvDzVI6niZZg8DOY7PL9pLU02u9Cx5m/cUn3MKwrfoQuS38QNITtIaxrnkoeEbOCtXlsr
	 gpOP52TRm+yyAHpppn37afdFrF1oWohy1IwNJHJSk0bfaB/Tfp4FTil7tV2P3TIOmcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vtrHy+24;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9364E60A263F;
	Sat,  7 Nov 2026 14:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vtrHy+24
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A061F0089F;
	Sat,  7 Nov 2026 14:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062102;
	bh=HI2Z8qP4sNBRleJUW0Bql0GmvDo4YDiXX5pr/KeV7dE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vtrHy+24a8FxK+rSHnJNORWdSI7juq7pS4xOpAwqKOr4b6Ps3XwrvpOlK86AqtytL
	 1UZxctGW8gvDeJ02z9xwMvTcj2uAQs36Pc4S3vMQmHFfEyhHhmhHDeU+jCqvJdz9Sq
	 Tu4qRWMV/ib+H6hYVFnXGmoUc6Z86ZiwbcHsGLJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1037/1536] crypto: hisilicon/hpre - fix ECDH destination DMA mapping
Date: Sat,  7 Nov 2026 08:50:53 -0500
Message-ID: <20261107135026.801838294@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 072f5ad6739f3..2ad88d9fb111f 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1572,13 +1572,13 @@ static int hpre_ecdh_dst_data_init(struct hpre_asym_request *hpre_req,
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



