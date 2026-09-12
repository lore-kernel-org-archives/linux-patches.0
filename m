Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6697B30D3F6;
	Sat, 12 Sep 2026 14:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222633; cv=none; b=cRZ9K4TzQv4GfqPJYU71eedxcl72Xrgoz5sRub8NAa0LZAE0HdfqYw2ycfZaZ+CPd6o2FNSt5U4XecZ1ncrki6Usu3Y74sB/WysvPMpv6FBLKFnRmIq8x3qSGXVipEMkMjNCP/l0CNpNYDn7FQ4JyJf8Uf3R7rJiYGEROy6z4vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222633; c=relaxed/simple;
	bh=UkAv30iq+AVKtiYsuGhDOHeTUR7N0HFZu3bTR3updOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ao4GbHN6OIFLm2b6Z/9lkL6e8jqJpa1cn8bO3EWs16FMSY1nlCa3tUKtHtae/9aKkuRu3AMMQRw8YxIWMt3pNaGub7CJn3iGbKL7mqaN4m9++6oDlvPq/D7NIRPa4PUho7/o/3sckT+hg0qJBP/Rmp7VAul4rB1Ni9jkxtLsXIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UmxkTHO8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UmxkTHO8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8641F000FF;
	Sat, 12 Sep 2026 14:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222632;
	bh=8kp9U3JyrqzmxHtkUPwOeYugo4XjaNvUQPvdNKjWf5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UmxkTHO8E2MCITzsd3QkRjqRqkhAQ1TioWMytbJfW3xvrB0H3P2O8Xcez0JsT/Ggl
	 ZZFkhG1nxvIcMt5TQ3lucFyTRvi3eYUq5wTq8mIvxGH3Qmcc5XWz9NrIRwLLcJQKrQ
	 0qqOWhBgX2h30UJRpgGRch+k38JQuKixxTT3Axh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0624/1424] dmaengine: hisilicon: Return -ENOMEM on dynamic memory allocation in probe
Date: Sat, 12 Sep 2026 08:50:56 +0200
Message-ID: <20260912065621.265306446@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Zapolskiy <vz@kernel.org>

[ Upstream commit cbabdd6ce1b313b5877c7fbb2f5e2f7936564d2f ]

Out of memory situation on driver's probe is expected to be reported to
the driver's framework with a proper -ENOMEM error code.

Fixes: e9f08b65250d ("dmaengine: hisilicon: Add Kunpeng DMA engine support")
Signed-off-by: Vladimir Zapolskiy <vz@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260630144214.4080302-1-vz@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/hisi_dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/hisi_dma.c b/drivers/dma/hisi_dma.c
index c1350a36fddd9..bbd4d44bae220 100644
--- a/drivers/dma/hisi_dma.c
+++ b/drivers/dma/hisi_dma.c
@@ -983,7 +983,7 @@ static int hisi_dma_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	hdma_dev = devm_kzalloc(dev, struct_size(hdma_dev, chan, chan_num),
 				GFP_KERNEL);
 	if (!hdma_dev)
-		return -EINVAL;
+		return -ENOMEM;
 
 	hdma_dev->base = pcim_iomap_table(pdev)[PCI_BAR_2];
 	hdma_dev->pdev = pdev;
-- 
2.53.0



