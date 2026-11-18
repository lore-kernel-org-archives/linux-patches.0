Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055939;
	b=RFMiC26xgIK2zmR/xrzbS3MVf+FaZGVWFnhdNbyCt4yQIbiovUPzCUy8PFIv/z7IBbEP
	 qMrnYhMzNMz8epJH2nPlqL3POUOH+HDT6QRTZl14mGIFTvjQctDX5gzr4s+BTccdgiXFt
	 SsnXl3etQuIwVPxh78Xlq0pLehexthpMStuK/qXft5bJw3/sx6HWtxH2HGveKu9BSFUtu
	 ridvTZhLzoedKaiydMWCmZ/FNs1ZFWei6aKuK9Ly6bGYNpTon/WDf0BNg9jd9DgBWeF0J
	 8fU8aZCXMKNuxWr8CnEIVuN132+OreMiwOwzreOPqw9JHAjSPALZZT4PLLYja170AHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055939;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=40czwgof8jr5OUrmUdgzf7bQK+Q3D9KzkEwaD/IFDNY=;
	b=nrcJfev5fhy+j+qfJ18fV0vrjdLGrF249eLgDMJ+RARgPO3jdmI42i+xFn6d7eQL8XbZ
	 qFiU4GgNph1q9MjcvA6Hxp46iS36gX2nq/pxX+NJPrxk864/W9kKEoGCg4ij4y77zwaC/
	 obnlf494x6zPlZTU3d5eitWqLZImtOFfBj7FqQXYy0QIh8Fs2dMVZgOT0og3UEFOVDOSM
	 cpHf/yp3vbpiUDlVPFQtkBV4sbz/fBK4Ax93rhxvSFS304VN8uWZVCD97hGrPUO5Ym+PS
	 Emaiqbs4j1I467mbwWhi2TpCZs0E+7S3K8JzQH3bBL4D47fRQ/aDxVvX2bUJv+w25JA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HyxBG25A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62B5606A31C;
	Thu, 19 Nov 2026 02:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HyxBG25A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378411F000C4;
	Thu, 19 Nov 2026 02:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055939;
	bh=40czwgof8jr5OUrmUdgzf7bQK+Q3D9KzkEwaD/IFDNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HyxBG25AVMDv+5ZqiffhcbnESWh6FksgzU7P37VhVRxpRaXmuHzq9OxKZtni7r2jV
	 eiIkW991oTKK5CLXMzoLQmYzKshn2RiV6q8kIvSjjtyS+ciKcFiE+2aRxPAdX8iUMt
	 oUW1Q1/TyI176HwIrqs1FLHmsTn7wYXXsKTNgxwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julia Lawall <Julia.Lawall@inria.fr>,
	Linus Walleij <linus.walleij@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1773/2214] dmaengine: ste_dma40: fix typo in comment
Date: Wed, 18 Nov 2026 15:57:29 +0100
Message-ID: <20261118150122.437880016@linuxfoundation.org>
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

From: Julia Lawall <Julia.Lawall@inria.fr>

[ Upstream commit a71da24ce1f8f6844c6378ae394b5c4b31ff5725 ]

Spelling mistake (triple letters) in comment.
Detected with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20220521111145.81697-17-Julia.Lawall@inria.fr
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 0ac4a90c4805 ("dmaengine: ste_dma40: Validate memcpy configuration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 923a0a1b01666..58e281c8aaaf8 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2060,7 +2060,7 @@ static int d40_config_memcpy(struct d40_chan *d40c)
 		   dma_has_cap(DMA_SLAVE, cap)) {
 		d40c->dma_cfg = dma40_memcpy_conf_phy;
 
-		/* Generate interrrupt at end of transfer or relink. */
+		/* Generate interrupt at end of transfer or relink. */
 		d40c->dst_def_cfg |= BIT(D40_SREG_CFG_TIM_POS);
 
 		/* Generate interrupt on error. */
-- 
2.53.0



