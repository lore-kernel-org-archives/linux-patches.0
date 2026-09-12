Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A5C3CF211;
	Sat, 12 Sep 2026 07:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197360; cv=none; b=PMmn5tJyyuUyw41YENQ9Lh8r1dojVT0nQ/LXPFeWguCk7e+CiIfuqs4eSpUoSr8Wh6kAykO0gXYFapoP82lmgz8Ej6xt+5Dz1ZEUoTvcyNgqj9swt2dEwZBL96juNbcQ5UcSHn7Sf90bKTMdvh+qM2JLtD++/0+FOOeHA85dNcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197360; c=relaxed/simple;
	bh=jWA4xsRy1VwyDGHYdsPTtRcy0hiib0gVTIxkuWMAyPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEhmdcIAQQh3bHY9GppDDHLhJzBT4Fir0nEL2Bs7tC1vo+3hk29NChG8fmbeJ/s5Q/geTNnWEOqdbOs4o2e/YCsICqsz7Zcx5BW1im8AXQ47DBkm1NDhVG5pbV9TmYECc2pTqsJ3ZoH0rzQYU64hZ0QwxU1o3bHpeAcTOcjuFzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RAvnKQCz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RAvnKQCz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89B21F000FF;
	Sat, 12 Sep 2026 07:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197358;
	bh=s+gyRyMpgKnqJ3nV/BMSBFhMeOgcyp2KwmGiM/64TQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RAvnKQCz5tS8u8r8hoFPX3zxskvWxXybLs7z5tRWXmFCPjADb2dlxFl4IPQAh/yIW
	 01CMps6X97RPrQ7Fr6cwZNmRBZv5MQejw3AtuqxMmdWWggF0DlL2mtTHmflaFcj8XE
	 qlS31BXNkhCHA6ccoNtsYRd/7iPrlr1pnh6cqmSU=
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
Subject: [PATCH 7.2 0158/1815] dmaengine: mediatek: mtk-uart-apdma: Return -ENOMEM on memory allocation failure
Date: Sat, 12 Sep 2026 08:31:48 +0200
Message-ID: <20260912065652.720564756@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index c269d84d7bd2b..f74e9a3285887 100644
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



