Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4D435C682;
	Tue, 21 Jul 2026 22:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671843; cv=none; b=q5Avh3TUj0JLyY2FsIYISNLlYcLwfPZnKUVAgbD9GTkF8RKYrYUBkDW+9LH8z6Jvhk/kN0ewxc1KQhMbWIzgQUaMMBKKcLHPOHgs7NInB0kPKgimFkMJV4O7HTRCMbmkZuSyiJHO4NpoA2sZJxkAw2bfPPdKvu+7DxgZZsdbgdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671843; c=relaxed/simple;
	bh=Hfs92ZpKdrQQQZ+EU2N+TqeLHNzPA0BX6UJbHDJCMYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbIgsC91u17stnxLRqBCrw5O1MDiFFT9chZwCoRyyuUz6W6LOFXTiDlVjGbngsduEmiNj4083y0vQaAGCob5+Juta5E6pMhZYfCNTDaccS+jGPaxnEuL9WEYT2rAULIdaPzsAz/OGseQVBSFkA2Y1/s/AojwnKQSChliSm9MyJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VOP+wLHd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VOP+wLHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2021F000E9;
	Tue, 21 Jul 2026 22:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671841;
	bh=ob337bZ/Ni9kujJNNvqKUClD28mj8ItVqXlsHLd+hGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VOP+wLHdEBg8huBMPsfmorGZFSitTt8kLEQuAjL5ILJKhSkIqQUX7PTTOv+onlpkV
	 Zvcd5/WafXC0mJa0i+D+u7NMpLI+8LJlCoiZj/XWCsbaZOx/e8Z3Lpaeo3q3zTv7iN
	 +m59OUpKicdgepLL+DQRwMJaJbzxWnVw7r1FuHyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <zhengxingda@iscas.ac.cn>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 397/843] dmaengine: qcom: gpi: set DMA_PRIVATE capability
Date: Tue, 21 Jul 2026 17:20:32 +0200
Message-ID: <20260721152414.970728732@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5571ef3240d05e..367d4babe3b65c 100644
--- a/drivers/dma/qcom/gpi.c
+++ b/drivers/dma/qcom/gpi.c
@@ -2246,6 +2246,7 @@ static int gpi_probe(struct platform_device *pdev)
 	/* clear and Set capabilities */
 	dma_cap_zero(gpi_dev->dma_device.cap_mask);
 	dma_cap_set(DMA_SLAVE, gpi_dev->dma_device.cap_mask);
+	dma_cap_set(DMA_PRIVATE, gpi_dev->dma_device.cap_mask);
 
 	/* configure dmaengine apis */
 	gpi_dev->dma_device.directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
-- 
2.53.0



