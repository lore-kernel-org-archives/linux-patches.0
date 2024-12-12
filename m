Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2071D1F2381;
	Thu, 12 Dec 2024 17:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023879; cv=none; b=jobvaapewn13573jmZ2RWVu24HCWhZ0vkkPYBuP0TYG5hebGGSCA7s8p+V1egOUAXWI3fFczigtvHwLfBJgBLBmmO6fDEB0+X/QTiQ3wgKU3N2VK5jIbs5TL9Zf8e8Xmcb06lBhNBZtRzdMhvWvliv+1Rh1Z9TGFq+UaZHegp6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023879; c=relaxed/simple;
	bh=F2c6H+L5G/ON6IBah9VzuxpFnwtQJ6nE2zZ6LtKcN/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BXB31HxSdm/R6LWNVpRl2OKZUIQlwXBA6AHCg4U0CEV0+bJgu10Bf+4oAntvP6vkBeSA2BHE5UMRIWGstXMTJBYAjKKL+svm0jbi+eylOMoAhIHq4UbFUmIYNVo2QVrkx3WqH2ahR3WjQls9D6hFU2D7iqWPiBqHZfB817ni0bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S6KmcTL2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S6KmcTL2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A46C4CED4;
	Thu, 12 Dec 2024 17:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023878;
	bh=F2c6H+L5G/ON6IBah9VzuxpFnwtQJ6nE2zZ6LtKcN/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S6KmcTL2Lp7WCIDqCqd5jH3SNsnG8ukDIRDpKDwEER6qY6xZ62ikiABudulaoakIe
	 AO1SbU55cBIuJOcYjCm9ZYTZlHWMk2XPxZBPJMC5F+6m0dhuBFUIPLyetkKSbLQ6dw
	 oYyLijdJTULpMcveguDHzE0hBsyoA7x90Zv0Isa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/459] ASoC: fsl_micfil: fix regmap_write_bits usage
Date: Thu, 12 Dec 2024 15:57:30 +0100
Message-ID: <20241212144257.938808631@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 06df673d20230afb0e383e39235a4fa8b9a62464 ]

The last parameter 1 means BIT(0), which should be the
correct BIT(X).

Fixes: 47a70e6fc9a8 ("ASoC: Add MICFIL SoC Digital Audio Interface driver.")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Link: https://patch.msgid.link/1727424031-19551-2-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_micfil.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/fsl/fsl_micfil.c b/sound/soc/fsl/fsl_micfil.c
index 20215303fa34b..9c781d874c309 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -610,7 +610,7 @@ static irqreturn_t micfil_isr(int irq, void *devid)
 			regmap_write_bits(micfil->regmap,
 					  REG_MICFIL_STAT,
 					  MICFIL_STAT_CHXF(i),
-					  1);
+					  MICFIL_STAT_CHXF(i));
 	}
 
 	for (i = 0; i < MICFIL_FIFO_NUM; i++) {
@@ -645,7 +645,7 @@ static irqreturn_t micfil_err_isr(int irq, void *devid)
 	if (stat_reg & MICFIL_STAT_LOWFREQF) {
 		dev_dbg(&pdev->dev, "isr: ipg_clk_app is too low\n");
 		regmap_write_bits(micfil->regmap, REG_MICFIL_STAT,
-				  MICFIL_STAT_LOWFREQF, 1);
+				  MICFIL_STAT_LOWFREQF, MICFIL_STAT_LOWFREQF);
 	}
 
 	return IRQ_HANDLED;
-- 
2.43.0



