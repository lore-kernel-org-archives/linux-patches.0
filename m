Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F3C38656D;
	Sat, 12 Sep 2026 18:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238278; cv=none; b=VP3V6gvKJxcR5VbRLEECKy5slp9c6caGfCCjvKQ1EqzILgHG7AH0B29lFuHpzfE7WTpkdsvOyqKiVSFQb+xmdJl9cupxquUTnAfJwlzlRuCGLnxUGliUnOhueRgbZmDXbEoo/yPQJMH32BaZKaSKrIQVZDelmWpilzY//sbFv4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238278; c=relaxed/simple;
	bh=u/XyKLIErBeqX18/3pWOvsEE7jzhdyfYKmoDFMRhQ0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jhw9IcrcP/M3CSohILkIx8ap09bgv9QH5scv7GQNZR3xAa70EMu6gm6znmLvBw3Jl5SbxklyqM5TuK+xE+P+ATXsv2fi5L7U9L0Li8uM2Kxo4TLjQS7YPJrJD6lKPwLdFqYSdXki6pjVGMC+KqnvFtos4RHAKvDn+62MHsxqqLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VD2cvH1h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VD2cvH1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49CE21F000FF;
	Sat, 12 Sep 2026 18:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238277;
	bh=xZ+7wzd22OdKyBjQB715odGfTSCtG68zMYY8dMAUmng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VD2cvH1hKT+PyJxhDOV26JaNibEgpzrxURq3SenhO4alZ1z8FfnitUalbz7vUyp2+
	 KsuTDztq/ij9Fr4aEMr7QPMv+vTfeK7sJZDbFQshXt9nzTblvtiuiycPvNp+HPSslJ
	 1TFNPX8dkR/jqHbzMPAdBE1oY1F2icojMPKVbdoY=
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
Subject: [PATCH 5.15 428/935] dmaengine: mediatek: mtk-uart-apdma: Return -ENOMEM on memory allocation failure
Date: Sat, 12 Sep 2026 08:57:38 +0200
Message-ID: <20260912065536.644585408@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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
index c1e132a110ffb..20d196b766835 100644
--- a/drivers/dma/mediatek/mtk-uart-apdma.c
+++ b/drivers/dma/mediatek/mtk-uart-apdma.c
@@ -531,7 +531,7 @@ static int mtk_uart_apdma_probe(struct platform_device *pdev)
 	for (i = 0; i < mtkd->dma_requests; i++) {
 		c = devm_kzalloc(mtkd->ddev.dev, sizeof(*c), GFP_KERNEL);
 		if (!c) {
-			rc = -ENODEV;
+			rc = -ENOMEM;
 			goto err_no_dma;
 		}
 
-- 
2.53.0



