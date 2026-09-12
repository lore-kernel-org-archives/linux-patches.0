Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88E93B71DA;
	Sat, 12 Sep 2026 09:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206317; cv=none; b=OVEZocxJKe/b0L0T1Jod9Q5Urdj9KZbdgqb+k8NwAKyEMfM9YMrap1ZyyyY9CE76vRPMnfGeP+pZv+SmXJhYG+IfK06KsycQj3LsRFBoHcIAy3xPHAVEz1RUPa3fqHAxxIfdrPrNAEETGNmOzKpJSGsqHb+BWkdtn2JDXx47HjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206317; c=relaxed/simple;
	bh=9lqmgmnL3qh5dlw/+XvUbzr46rVF9246hJ/X/vYTOrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u7aO4GBVcER1kE1gk3WW0mqztXBww9QaFrbHkMaJWy1G6yBQ5cHPX5qS3mg6QOKmBU2YNn07Tb7Pw0Lzz1lhu90LdHk0e1ywDbEOVS3zcWgFz+V/n2vYIAKo7I3DbzZf2Kfo0GjnYRQMjMjrF+xHr/mGLMcXPaodpeuNkdJZpvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yverGAYP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yverGAYP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837B81F000FF;
	Sat, 12 Sep 2026 09:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206316;
	bh=2b1qs8+/yKhOMwWNTyC2HZROmBaThV578vDTHkhbLOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yverGAYPjzUHxi0HjqnaWf8/SShYNupr/9ln8Ubbqr+2753Jsxr1lNq09P71ixU0w
	 GyaH6ZhXOUYx8EZ7EaFAUArZ2J4GyXBAdbofcIevu0X+30W9TLZmaJBrFhkHxj4MnH
	 k2V6GHcuwyuChKhs0tRW5VHcFfrDL9zwF7Z3jmOw=
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
Subject: [PATCH 6.18 0180/1518] dmaengine: mediatek: mtk-uart-apdma: Return -ENOMEM on memory allocation failure
Date: Sat, 12 Sep 2026 08:39:09 +0200
Message-ID: <20260912065627.561412987@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 96c18c815f1df..cdba081637975 100644
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



