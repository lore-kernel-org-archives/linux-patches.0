Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD0946E009;
	Tue, 21 Jul 2026 18:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660387; cv=none; b=YTg0pLov9QyCFkjhWDlhhhBzop0lqVCRzUgO1705EphoG7KqoWCs3+d79lhKEUdyDKfZ5AAtMWTA+G2Z7rtB/TRuCbjTF0AhsuEJ6bgkfNTAJwxj3UYIOPjBxfd3uCrIc22dCT+3dajsDI5P94GTOlFrgjSYxNPteW3Ron2Nw70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660387; c=relaxed/simple;
	bh=x0lj8yYY2KsiHO+baJ9kAqUcqxrjjgGEC50bpMpcyhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qRanfrVXwOCRE/q4+nU8NvCabi7dxcgpqDPnnKsz5/Mmmo92sjQ/tjuQEjLfdBZurjcppvmihBPjQ4YgzwCwSHOOI0eR8vcX4ZrqtPW1lIuZ+IHuLLXWpmXcv8OBhP9qi59pwx5ARO07S4OxC458H6KblYoNwwBmUpuvRcVhBEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L1dVmj4B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L1dVmj4B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054001F000E9;
	Tue, 21 Jul 2026 18:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660385;
	bh=c2OxA2QiwAq5HycvP+H+e+o+mUZZJUP4IKsU6ttWApo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L1dVmj4ByFF0/nLLLaspRJ8QHNx4SfVTVOMz/Vtg57KaJvKGxhGddAyBVX8GPndOM
	 JFJLmhUTTrLk8h6PM1joHUDMR+2Do0XrmPyGg5IAGOkNrIe3XNenzD8XJiBtj8rc7z
	 hFIx0OhCqniDaluB3i8SUqGTCSNcSORFkxw1zITM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <zhengxingda@iscas.ac.cn>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0958/2077] dmaengine: qcom: gpi: set DMA_PRIVATE capability
Date: Tue, 21 Jul 2026 17:10:31 +0200
Message-ID: <20260721152615.415511833@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index c9a6f610ffd9fa..a5055a6273af62 100644
--- a/drivers/dma/qcom/gpi.c
+++ b/drivers/dma/qcom/gpi.c
@@ -2260,6 +2260,7 @@ static int gpi_probe(struct platform_device *pdev)
 	/* clear and Set capabilities */
 	dma_cap_zero(gpi_dev->dma_device.cap_mask);
 	dma_cap_set(DMA_SLAVE, gpi_dev->dma_device.cap_mask);
+	dma_cap_set(DMA_PRIVATE, gpi_dev->dma_device.cap_mask);
 
 	/* configure dmaengine apis */
 	gpi_dev->dma_device.directions = BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
-- 
2.53.0



