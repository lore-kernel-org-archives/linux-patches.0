Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E99C9443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:28:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D90C433C8;
	Sun, 13 Aug 2023 21:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962082;
	bh=ZEv/HAweZuiGnvwv6eZxaATYoGfoTROek+O5VAPXFVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RggbMd6OkRqX91HvpfssEAYikuN4y1WtgleeClc3BGAtSlaqrnACc2CO1D1C7C5oQ
	 tY1EdWASfRl79hvAdNZbcm6PtJE6X9kfZWEF4soPn/RDFIbZXNou6BsYyWVS9Fu1s9
	 mOZH7ujdFMs6aXw+JKN/oW3pGC1yIt5KmW7EqvbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minjie Du <duminjie@vivo.com>,
	Michal Simek <michal.simek@amd.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.4 107/206] dmaengine: xilinx: xdma: Fix Judgment of the return value
Date: Sun, 13 Aug 2023 23:17:57 +0200
Message-ID: <20230813211728.115845481@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Minjie Du <duminjie@vivo.com>

commit a68b48afc050a9456ed4ed19d8755e0f925b44e6 upstream.

Fix: make IS_ERR() judge the devm_ioremap_resource() function return.

Fixes: 17ce252266c7 ("dmaengine: xilinx: xdma: Add xilinx xdma driver")
Signed-off-by: Minjie Du <duminjie@vivo.com>
Acked-by: Michal Simek <michal.simek@amd.com>
Link: https://lore.kernel.org/r/20230705113912.16247-1-duminjie@vivo.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/xilinx/xdma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/xilinx/xdma.c
+++ b/drivers/dma/xilinx/xdma.c
@@ -894,7 +894,7 @@ static int xdma_probe(struct platform_de
 	}
 
 	reg_base = devm_ioremap_resource(&pdev->dev, res);
-	if (!reg_base) {
+	if (IS_ERR(reg_base)) {
 		xdma_err(xdev, "ioremap failed");
 		goto failed;
 	}


