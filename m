Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592413644B3;
	Tue, 21 Jul 2026 19:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662521; cv=none; b=o2Wp0vEp6g2z2pp/WaUApoINdi0RVSrlZ7OiDRLxoWspPEXmd2Bime+IUE7a5uSUsDbEkyU2pIXVTpMlFN134aIFxvmFDub7SybKxyeyNh+6HfUm10zfbqjegkkxYfgcFhta1395eadCqYsg7ODLVkrOXtlhPbKoOFwcxTRBM4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662521; c=relaxed/simple;
	bh=JH4Kvs7lLFtKiF0pDCpN+utbk7tSB5UC2qIXNTURfZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RiBxLoFt2dmf6Ddhg/ldA7kcP/pQUlVirwsqWu4qIUxeKmSZJy3l8lKauq8/2NIJGNWn2FBLun+Y7HDtZV3PolKFszpKCF+EQT7A44GOQ9owbuP6Ewel+3Yj0ZoiMIY9na0T6honZBkbiTIDdMjuk7B2LFBk+wp9/5Ij6H2MSxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yIE7LMf2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yIE7LMf2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5321F000E9;
	Tue, 21 Jul 2026 19:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662520;
	bh=3chBuurU8WIdfin2ISkHJuCGAaHPTWdBLnyPJ2EeVjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yIE7LMf2iiz7uegOLO0pLUzBN24OgitBoKsVRoSWK2+8xQXD5pZwf0qI3dHXp8z+5
	 XnrbkkMCJOnSPMyUvzw+X9yyC8OaR60s9qyZjildHQczwmrafNW2nZdg91MR44lX7v
	 eyWdkr2XW+fU2Q6uPl2KAW8rLMudr6/vbvSwjnTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <zhengxingda@iscas.ac.cn>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0477/1276] dmaengine: qcom: gpi: set DMA_PRIVATE capability
Date: Tue, 21 Jul 2026 17:15:20 +0200
Message-ID: <20260721152456.777924348@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Icenowy Zheng <zhengxingda@iscas.ac.cn>

[ Upstream commit 4e351f408743354d54ee1af5193fc78234f2044e ]

The GPI DMA controller is only responsible for QUP peripherals, and
cannot work as a general-purpose DMA accelerator.

Set DMA_PRIVATE capability for it.

This fixes error messages about GPI being shown when an async-tx
consumer is loaded.

Fixes: 5d0c3533a19f ("dmaengine: qcom: Add GPI dma driver")
Signed-off-by: Icenowy Zheng <zhengxingda@iscas.ac.cn>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://patch.msgid.link/20260602070344.3707256-1-zhengxingda@iscas.ac.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/qcom/gpi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/qcom/gpi.c b/drivers/dma/qcom/gpi.c
index b0ed6260e75bd2..da0fa1020347f5 100644
--- a/drivers/dma/qcom/gpi.c
+++ b/drivers/dma/qcom/gpi.c
@@ -2245,6 +2245,7 @@ static int gpi_probe(struct platform_device *pdev)
 	/* clear and Set capabilities */
 	dma_cap_zero(gpi_dev->dma_device.cap_mask);
 	dma_cap_set(DMA_SLAVE, gpi_dev->dma_device.cap_mask);
+	dma_cap_set(DMA_PRIVATE, gpi_dev->dma_device.cap_mask);
 
 	/* configure dmaengine apis */
 	gpi_dev->dma_device.directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
-- 
2.53.0



