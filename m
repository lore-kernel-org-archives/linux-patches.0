Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052325;
	b=sj3bcYCAe/mxPz/+VcNVZQ5+8RPdmCOhodB671mllag6+SnlTxhgfksEGIOM4OND+ufD
	 snFzPikxftS+bjfPpwg8AHIEoL33NT+p2ig7rG/kp39v7I+Hf3LO7HjTPW59Q/mzDwlhS
	 jqfxJnYTgf1Z3EzxZ88X1UTS9foqBs3J1a1W8A51zWp3ej5W1Te3mLKKS1ZCqxf7YgDRO
	 fZ2BWNMvh3Y1YsAbfkKcejNbIt9fsD0oa0XJ2bgTnhvVbuh/rA+Bdp8ZEReFzfftdfFwa
	 mjOHN9uq1ZfYeKn7VL/7xBuzdkluVteapfjpBR2+vGAxVmzPFcC5S6m9Z10KzjIqeqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052325;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1iNZWHT+L/ZdSk78fm9U79CKyjS05Uuk6f67zeYqbjo=;
	b=I9qXVpY8x2A6diwMXuMHpCEiyH4Sizhlqologr/xF+Mw1OStfwM0YobqZ0JlWMbaP1lq
	 UxDvawScG9hfqCkaHdlZFP7N72D1r6bSTZPHdQwvVSc+Y6LUCyfQMRM5Ya2jemtGL9bew
	 zWMFZxCEo8jsAr2Qaf6X9PbY9ZxFf+GCzUPk9qZeJTSif3ungfZpFtW5r4yMeEbpcnNSR
	 EdOKGmX5x7TsJ13X6cdfwYaalRY3vFlMZHgnx06EPs0dF/gFyxaMYgyRseI14liNXjSsG
	 1Ors4Mu2xWsZbo6J/+b9V7BVPoice7BEHoPXJQG7Bo/yUehluizdR02btmlFYtgGiUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MEKYO4cx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C42606A33F;
	Thu, 19 Nov 2026 01:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MEKYO4cx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0121F00937;
	Thu, 19 Nov 2026 01:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052325;
	bh=1iNZWHT+L/ZdSk78fm9U79CKyjS05Uuk6f67zeYqbjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MEKYO4cxxH1NkzQC+kCY0y4iSdaR4Mg6ugSa93ukFrCLMgbW9GYicgAU7p4wS04jS
	 H0zjxMxUTytEo5J7hG5baYB8GeCDxI/cCWcueRCfUMDheUz1/dZDsLQk1WQx/dJcPu
	 MTBj+oKkud+97IYDXpixUx6WQ/MlqcAnNCfZXnUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0520/2214] crypto: hisilicon/hpre - fix ECDH destination DMA mapping
Date: Wed, 18 Nov 2026 15:36:36 +0100
Message-ID: <20261118150031.889149639@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
index 759929839c779..72b6a7452ccaa 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1543,13 +1543,13 @@ static int hpre_ecdh_dst_data_init(struct hpre_asym_request *hpre_req,
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



