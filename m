Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A43428935A;
	Fri, 17 Oct 2025 15:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714982; cv=none; b=H8b6FxfvInob6ynixqWSa2NcjBCZpCbNbQX1XLc9PIxNN22GO+3japPiNKwB7AthZWKdA4MRFUqA9ofpF9oaQElyUPXYT71mTWCzuuX3G9Ox1zFbt+VvcLXsUGYQUtZPdUgXllfQw6CGVuSGpC+3vK1Ok5nRCOaSuLxqdNUuPSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714982; c=relaxed/simple;
	bh=csSFrZl2c745TdFuy74QEw1pQaBoSPE+T9AcPK6cjjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sm8HiQWdmGkni4fEmnSUXWH61clr5e0JcbBWMICu3hZQ4Zn1fStnURXyovoh7T3PeLJ/lsXEidLmnPHzk0rkDvlV62G1Qun0LQA0IWHIubOzOFAfctgSol/80hmdfEv+WnkzFkh1kqGNNyWlLshYPYLWYLTsm5WyTQA1aZHIOV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qp3t2McX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qp3t2McX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8DEFC4CEFE;
	Fri, 17 Oct 2025 15:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714982;
	bh=csSFrZl2c745TdFuy74QEw1pQaBoSPE+T9AcPK6cjjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qp3t2McXR6QeNYBvgWa2dJwcY/DBW6/LasrpzGDOkaXcai/gk1WfCQGmfnhrBxxff
	 NeOk9GsyCCzhhvgCaVnAQ5pe6zTmwQGJc7KOX72zz1RiQVkpxSMzLegaYLjIqgw0q+
	 ZOgonh3wjbPbciWkKgb4UU/wwfs+csAGsNCHQzSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 024/371] clk: renesas: r9a08g045: Add MSTOP for GPIO
Date: Fri, 17 Oct 2025 16:49:59 +0200
Message-ID: <20251017145202.672200256@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit f0cb3463d0244765ab66792a88dc5e2152c130e1 ]

The GPIO module also supports MSTOP. Add it in the description of the gpio
clock.

Fixes: c49695952746 ("clk: renesas: r9a08g045: Drop power domain instantiation")
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/20250806092129.621194-2-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r9a08g045-cpg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/renesas/r9a08g045-cpg.c b/drivers/clk/renesas/r9a08g045-cpg.c
index ed0661997928b..3b28edfabc34e 100644
--- a/drivers/clk/renesas/r9a08g045-cpg.c
+++ b/drivers/clk/renesas/r9a08g045-cpg.c
@@ -284,7 +284,8 @@ static const struct rzg2l_mod_clk r9a08g045_mod_clks[] = {
 					MSTOP(BUS_MCPU2, BIT(5))),
 	DEF_MOD("scif5_clk_pck",	R9A08G045_SCIF5_CLK_PCK, R9A08G045_CLK_P0, 0x584, 5,
 					MSTOP(BUS_MCPU3, BIT(4))),
-	DEF_MOD("gpio_hclk",		R9A08G045_GPIO_HCLK, R9A08G045_OSCCLK, 0x598, 0, 0),
+	DEF_MOD("gpio_hclk",		R9A08G045_GPIO_HCLK, R9A08G045_OSCCLK, 0x598, 0,
+					MSTOP(BUS_PERI_CPU, BIT(6))),
 	DEF_MOD("adc_adclk",		R9A08G045_ADC_ADCLK, R9A08G045_CLK_TSU, 0x5a8, 0,
 					MSTOP(BUS_MCPU2, BIT(14))),
 	DEF_MOD("adc_pclk",		R9A08G045_ADC_PCLK, R9A08G045_CLK_TSU, 0x5a8, 1,
-- 
2.51.0



