Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55DD3AEF51;
	Sat, 12 Sep 2026 12:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214726; cv=none; b=cdKoX3YE6zgbdu3R09JRxhOO4esEVT/MiHVOR8M0MoCmJNmfHFsDyzLdfft/gkuHLJL8TS5AzuU6JHltjPbgdm0Ba7inarCOGXmmjm9EV+j5GoBfejCDmGcFg++/ltOv64OePDsLZJZsxkDd8olhDhp6rExSvDixoOlXfiv7TbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214726; c=relaxed/simple;
	bh=UXWe0ZDs2lku5xl2ubFnMUA5Y+l6G8Tdxx7MmcFcq5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PqbGnV4U5H+H3zAtTXRR0uRmi+HiPYzgCXCTQVWH+Zt43dpy0hBjrb/MUvUei9k/Y5JJPirSpOmBqA0scTPExUbRf4UwQwtOhm1Odx3tlLlpxEIuCmPc9Q7UkF9CNGHohIkMzvbkSF7IyzxKqFSkmuavDaH/HJRkKxElXriP6LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ah/YaKbR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ah/YaKbR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0781F00893;
	Sat, 12 Sep 2026 12:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214724;
	bh=9FWg1+YvcrRBkn2YvRaziSKBRII1Sg8XgYZQfjh2QWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ah/YaKbRzEqiQvkbss5CSZlOwNPjECAYwPMEBcN0fU4Zr+/XtY/4iyr3P5ln7XeXq
	 5KCn88990fgSCbxm9z3o4fQIGCMtcArKlJq9r3JqNJ8PjLMGiiUL/AkpSilS4L4Tki
	 h+jITifwHzAD2pD7SdnjoBOkLeshwrBbANPM2PCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vz@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Frank Li <Frank.Li@nxp.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0386/1376] dmaengine: mediatek: mtk-uart-apdma: Return -ENOMEM on memory allocation failure
Date: Sat, 12 Sep 2026 08:46:52 +0200
Message-ID: <20260912065616.150470435@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Vladimir Zapolskiy <vz@kernel.org>

[ Upstream commit 467265c750edd7ab43803deeafe7d3120a791d32 ]

If dynamic memory allocation in driver's probe function execution fails, it
should be reported to the driver's framework with -ENOMEM error code.

Fixes: 9135408c3ace ("dmaengine: mediatek: Add MediaTek UART APDMA support")
Signed-off-by: Vladimir Zapolskiy <vz@kernel.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://patch.msgid.link/20260701200703.117929-1-vz@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mediatek/mtk-uart-apdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/mediatek/mtk-uart-apdma.c b/drivers/dma/mediatek/mtk-uart-apdma.c
index 3e7f8acf41dd0..0c439e85c46d0 100644
--- a/drivers/dma/mediatek/mtk-uart-apdma.c
+++ b/drivers/dma/mediatek/mtk-uart-apdma.c
@@ -530,7 +530,7 @@ static int mtk_uart_apdma_probe(struct platform_device *pdev)
 	for (i = 0; i < mtkd->dma_requests; i++) {
 		c = devm_kzalloc(mtkd->ddev.dev, sizeof(*c), GFP_KERNEL);
 		if (!c) {
-			rc = -ENODEV;
+			rc = -ENOMEM;
 			goto err_no_dma;
 		}
 
-- 
2.53.0



