Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130CA847A
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EBA6C4339B;
	Wed,  1 Mar 2023 18:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677694066;
	bh=8LBZxdm372jxLC8ZhItmbl6QwtsaUE4WNTfcIL3TMt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tdUQRg8rwiD2zPFTDrhcJbtBkc0mhrjOhkISdeNb2u4IQNGgNMUaWNqozWbQELEwp
	 p2mGzYAOX8mNepg1oqppJMq17zYdKh72/64KVkFvSrliCLEDm6OonOXZTfEMnQbsDr
	 fGSMyj+u/f0Ahb1UfwPbPaS0oj+h1OwCf4mBLjnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Vinod Koul <vkoul@kernel.org>,
	"Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.19 7/9] dmaengine: sh: rcar-dmac: Check for error num after dma_set_max_seg_size
Date: Wed,  1 Mar 2023 19:07:23 +0100
Message-Id: <20230301180650.679766964@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180650.395562988@linuxfoundation.org>
References: <20230301180650.395562988@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

commit da2ad87fba0891576aadda9161b8505fde81a84d upstream.

As the possible failure of the dma_set_max_seg_size(), it should be
better to check the return value of the dma_set_max_seg_size().

Fixes: 97d49c59e219 ("dmaengine: rcar-dmac: set scatter/gather max segment size")
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20220111011239.452837-1-jiasheng@iscas.ac.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/dma/sh/rcar-dmac.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/dma/sh/rcar-dmac.c
+++ b/drivers/dma/sh/rcar-dmac.c
@@ -1816,7 +1816,10 @@ static int rcar_dmac_probe(struct platfo
 	dmac->dev = &pdev->dev;
 	platform_set_drvdata(pdev, dmac);
 	dmac->dev->dma_parms = &dmac->parms;
-	dma_set_max_seg_size(dmac->dev, RCAR_DMATCR_MASK);
+	ret = dma_set_max_seg_size(dmac->dev, RCAR_DMATCR_MASK);
+	if (ret)
+		return ret;
+
 	ret = dma_set_mask_and_coherent(dmac->dev, DMA_BIT_MASK(40));
 	if (ret)
 		return ret;


