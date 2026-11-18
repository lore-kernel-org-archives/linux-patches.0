Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040009;
	b=oWiKYLmVflfA0zJ0ggSzM06lanmKb6Ej3UXZLEUwo7QEM+atustLtOHallk+wQIReJYS
	 IWKXAOR+Xaa9AVNeAvrfzxF1IGcGiKD74omDj/Zf2RTieQ86XSzqcYCJ+akpNoKyX1pP2
	 27voq7ZXRssv42XZhULS8GqBuJN169h0L3VGPehquu2Ou0Fdgt8u9PpQScXmURvIvl8Hm
	 xwJnZo+2qArqh/YtbAYa0Rv2sRBFqVpBiy+ypPAnSTsAl8GcxOGAFe/DGEW9h9kjLhXt3
	 cbW1OS4iaebEV/QP2uUZN2ksHeU0tFaCeRgIBrMNDffAKqTnaTflu6DYvQvnvBe1ayQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040009;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z2kcqxMLP/1PqP0EUm1y/O7gg0/Hd2d+RNUIy7XPTNw=;
	b=DMlAHAmzgF2HWco+KjfnQgDgcsRd10QsREI1yeY/hid0PnhJ8u+7dSItaST3vmf5KgQ3
	 CazUZ/7xyizdTEGxeX2FOFq6tP1N1xyimA5VF+hL9Ao9mC1lwrJuuavg80nE+U/dgODGl
	 6+7bq4Q3PO/kK3/e/aNHfAcN7rA3U8PeNdJmoYwXNMTQUQcZHU8FB4C61VCzqiO4MivfD
	 NOqP4Fm9OBzfIc+ALHYCVvwNe5sgieVirbIqH5Q2TElxHOchV01ZHjMgvre2MykiAcGkf
	 e1oVtVTy2frOumzoGKw8YFz2BakXhtyIEPsHGIjIVEDgByoypR41VnVd8th4KzTu/7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OTz4B3Sl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0BB4606A325;
	Wed, 18 Nov 2026 22:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OTz4B3Sl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87DC1F000C4;
	Wed, 18 Nov 2026 22:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040009;
	bh=z2kcqxMLP/1PqP0EUm1y/O7gg0/Hd2d+RNUIy7XPTNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OTz4B3SlwpKH0pPlx5l/qYxb9VBkPHcaEVh7wUYlIZCfQ6/CRN1Mf81ktiivS73L+
	 Os9Gy7Y5n/4+pZNdVHBXjq3v0qrfxlyZ88X8IhwnkZ3cx5KNmaC80mwOCxl127T9fX
	 g5E8nIHOEi4TBrUg0Rpz3iK7BqM0ipP676Qhw1Gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2303/3318] crypto: hisilicon/hpre - remove dma_free_coherent on NULL req->dst in ECDH
Date: Wed, 18 Nov 2026 15:48:45 +0100
Message-ID: <20261118150430.796790546@linuxfoundation.org>
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

[ Upstream commit 5b87f619cc5c0a55dcd85ce97974e3f5b9333b7b ]

In hpre_ecdh_hw_data_clr_all(), req->dst is always NULL because
hpre_ecdh_dst_data_init() sets hpre_req->dst = NULL before mapping
the user buffer with dma_map_single(). The dma_free_coherent() call
on req->dst is therefore dead code. Remove it.

Fixes: 05e7b906aa7c ("crypto: hisilicon/hpre - add 'ECDH' algorithm")
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 81a3e0c8a358d..9aae4ec6fc159 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1462,8 +1462,6 @@ static void hpre_ecdh_hw_data_clr_all(struct hpre_ctx *ctx,
 	if (unlikely(dma_mapping_error(dev, dma)))
 		return;
 
-	if (req->dst)
-		dma_free_coherent(dev, ctx->key_sz << 1, req->dst, dma);
 	if (dst)
 		dma_unmap_single(dev, dma, ctx->key_sz << 1, DMA_FROM_DEVICE);
 }
-- 
2.53.0



