Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047978;
	b=IgvqGZZ4nTw8bnA5LOlYcGRCTWjzwUMgS/dMvzyczWBLWT80ljgnE4WUgDd8wSWPsWNJ
	 912V23/CJriDKejgqfFSXk0GnAjVJCf8K2nMFRKTJnSGYP0NGnGRurj8ONPZAfNd8iI+G
	 ySURsPoyN687iPOO4yQp9Q2N4LVfVTIjpjI+7k+eEt50Z10pAbJFT9Nxp8Lul9sHYpQ1N
	 IeIqD2s3+GyXrQPWcGIRAunU6GwUSohyZzldrIF//TadaSDOq8Bgg/bpypZO090MrYqLR
	 kAWz4XO5gTENH3mmwnFI8CNJPOMNLy853zXCgmi2OVwvmYPMoevUL//+nCTa+ODBuYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047978;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=0kJltkFiL/beRtx+8cW1I5nKNTeoCXVnKXNaYI51t7o=;
	b=XJjhu4gy2j4ipu1oyHOc41fK6lBFPQ9tnQhwV5OiiHlWQhbe7LH8jJ/6Q/NdAwrjIBTS
	 L7nPEW/AHDDeMHAAX5+LLfoV670GVr0ajnTfna7Kr+1zv7dmEYbDz7c9m7iKqw46fGuMI
	 RPmu55iYIx7WmDtzJzlJ2rZmPt9u98LZzLD61bFHiBg3twPGVlenlt81SKbRP8ir/cYfb
	 Y6GFBmJvYkLYIuk1oQLidk9/kuI9WWKPDMqPf1aT83j7l93eUGJ/yAXBgFt2aH6YOlheI
	 HdhTOkerWhKAOLgtdMAThnJgeZIDU3pOciwczTzluM9quiHUq6MrUz2/z/g94Z/Zpbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c+uo0yfP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0764606A325;
	Thu, 19 Nov 2026 00:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c+uo0yfP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ADD51F000C4;
	Thu, 19 Nov 2026 00:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047978;
	bh=0kJltkFiL/beRtx+8cW1I5nKNTeoCXVnKXNaYI51t7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c+uo0yfPCcih9yUBQyPikCjU+dQW5U6WFiN86fO2NYCYhP90MKPrtygCn+LwHyRV4
	 HvGwd/BwGF7slzIyU1MOd89IWH90x2f54O81fRvmgDjDaI0sGAtyuQgtKrWcbfJBSq
	 bO9VTQjtndUYf4fAi2uONF4U+SSmBBKE2SGNtt4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1832/2857] dmaengine: zynqmp_dma: drop redundant label
Date: Wed, 18 Nov 2026 15:47:46 +0100
Message-ID: <20261118150307.215783708@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinod Koul <vkoul@kernel.org>

[ Upstream commit 08f04d5ab868bc28d3115f7406499e8e5d1d1765 ]

Commit 3f30db282c28 ("dmaengine: zynqmp_dma: Fix chan probe/remove error
handling") dropped the use of err_disable_pm label causing warning:

drivers/dma/xilinx/zynqmp_dma.c: In function ‘zynqmp_dma_probe’:
drivers/dma/xilinx/zynqmp_dma.c:1171:1: error: label ‘err_disable_pm’ defined but not used [-Werror=unused-label]
 1171 | err_disable_pm:

Drop it

Fixes: 3f30db282c28 ("dmaengine: zynqmp_dma: Fix chan probe/remove error handling")
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260903170357.1711462-1-vkoul@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/zynqmp_dma.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/dma/xilinx/zynqmp_dma.c b/drivers/dma/xilinx/zynqmp_dma.c
index b1dbfc9beda0b..b10f626ca2c99 100644
--- a/drivers/dma/xilinx/zynqmp_dma.c
+++ b/drivers/dma/xilinx/zynqmp_dma.c
@@ -1155,7 +1155,6 @@ static int zynqmp_dma_probe(struct platform_device *pdev)
 
 free_chan_resources:
 	zynqmp_dma_chan_remove(zdev->chan);
-err_disable_pm:
 	if (!pm_runtime_enabled(zdev->dev))
 		zynqmp_dma_runtime_suspend(zdev->dev);
 	pm_runtime_disable(zdev->dev);
-- 
2.53.0



