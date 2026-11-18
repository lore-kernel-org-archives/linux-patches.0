Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036034;
	b=gFz59QN3cwWqEvsUQmNgRpYZ4RR4leCKDoV2fUvbfdvQn5KQZ6DiZnPqqpb2m+46H5MC
	 cSwmVpIQtGvISuQms3eN2In+YVjTLVSUr6sOTZDJK1D+e1zBDLAyzb3tZ4K9jqG+BUSaY
	 +eUPtd2Zo8s0GGzrjuwnDD/3NbfOYyzber+3r7HOT8A5M1TOcCfVPQc4BbmXuLQuWJ1l7
	 TSCZCtccAmmo1oAIujcrta4IVsLDFSli0CtZbgROd74tBqumFfX3rRDpao80x6bucu04w
	 EkctB0+GBj/ArRqVWSojFX23rYjWHMVqQfLLHNtfqUVNsrY1XazkPny7EGdMZppfmHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036034;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oxy+BjdWxyhbEYD9ss6x7Kjn+eJB916gKmU+WIl8jaM=;
	b=Z0+sAjSNOA2oaEA1dVG0TMqIf1A4n1aHWtlxqIbck3chzDvoZFpRntPVYygsfxlPEgTB
	 cvS8u2ZSsM9/gvafPz/ZNChXD6zGXbMvb2+Gnq6K3yZPEr+/aUz1EakxeXXDWsHTJcg+S
	 kzbSquNVkeGdaQjjp2IlMcHGBESZRCRAEfMtOgo5UdQMxWMyPkukMn0728zyLqBlHcQQr
	 lPZ+/fxs6sGyEfYh5UAixfvIn/pUs4eMrfwwe71KpoD1zQ2c9AInem5ZnoUFIAqcheliV
	 RoDx8qTTBZnwKzRLFV5jcfyPolMgQZ/4divPCShq4kghOsNUjNdJYPSKIFTNBneMlnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r6o+nHnC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7A0606A320;
	Wed, 18 Nov 2026 21:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r6o+nHnC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827751F000C4;
	Wed, 18 Nov 2026 21:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036034;
	bh=oxy+BjdWxyhbEYD9ss6x7Kjn+eJB916gKmU+WIl8jaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r6o+nHnCINe5mtIKmRAXS+xCPHW5fJr4M8a1vkCIakRfXBJSlGvxZalgNr/JKXLmA
	 GFFvvRQQ3+FpGotCFFuo/VkmzQN7zyuE2dPQTHUHQn1uCEh2BioIE0RpkjpVMCy09S
	 QAyxlY40JUIXSOesE/RvXXGHTIDSt609ygdKZSpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0914/3318] crypto: hisilicon/hpre - fix ECDH destination DMA mapping
Date: Wed, 18 Nov 2026 15:25:36 +0100
Message-ID: <20261118150346.937998866@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4ccd39780f929..2d2dc969f40d8 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1567,13 +1567,13 @@ static int hpre_ecdh_dst_data_init(struct hpre_asym_request *hpre_req,
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



