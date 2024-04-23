Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13040143C49;
	Tue, 23 Apr 2024 21:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908728; cv=none; b=pUPvWspbCBIhaQDyuFrmxnwRt1AiUYhR6CtykJu1Z2guAsHsN7B/xPzCMVXLgtErQWNnbznBcpiD3UthiSvzczj2e5XxLplRjD0IrCYWmm+aXmkS4omIh1iU48vnf+27mqnhyn07OPQAVkDxYMDAy2Fx7b1fzf6twyAevCHvN9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908728; c=relaxed/simple;
	bh=kavt5TSsOY+5RvKOP7OiA1S6sTBhazn1Uoibc23/TY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pol3+dBzJ9DvU0nVl0lcpe4OA+qN9uiCtIw5Mq3jyBEPrZR8F/vngTnE8kjpaEbMb9+fRRzT5hIxhpxqT+aLCK0muElpWPm27YdyLzcru7/hv/Y6NogupMPIo8FIUOoPX8g7VzqfJ4LbdkksX2iY0asMQJDUWtycp6K1hEF7Ptw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C9WZFPlp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C9WZFPlp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4619C3277B;
	Tue, 23 Apr 2024 21:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908727;
	bh=kavt5TSsOY+5RvKOP7OiA1S6sTBhazn1Uoibc23/TY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C9WZFPlpaBcTuljOak0o7vjE85UNCmbh1Axa8mJjhYzAQKOuGZUvidmhw4Um+1Rsv
	 nUdrArALrT5KCpGZrIvypEjdlkAQQROQTc0zhugp4Zuk/Fy0vZJ6mKh0H2zZWkgXv8
	 a9AzldVPkk52thVSl6W4wBFmm7SsL+0yudS/gaKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Miles Chen <miles.chen@mediatek.com>,
	Mingming Su <mingming.su@mediatek.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 093/141] clk: mediatek: clk-mtk: Propagate struct device for composites
Date: Tue, 23 Apr 2024 14:39:21 -0700
Message-ID: <20240423213856.197780239@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 01a6c1ab57c3a474c8d23c7d82c3fcce85f62612 ]

Like done for cpumux clocks, propagate struct device for composite
clocks registered through clk-mtk helpers to be able to get runtime
pm support for MTK clocks.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Tested-by: Miles Chen <miles.chen@mediatek.com>
Link: https://lore.kernel.org/r/20230120092053.182923-6-angelogioacchino.delregno@collabora.com
Tested-by: Mingming Su <mingming.su@mediatek.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: 2f7b1d8b5505 ("clk: mediatek: Do a runtime PM get on controllers during probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mt2701.c          | 10 ++++++----
 drivers/clk/mediatek/clk-mt2712.c          | 12 ++++++++----
 drivers/clk/mediatek/clk-mt6779.c          | 10 ++++++----
 drivers/clk/mediatek/clk-mt6795-pericfg.c  |  3 ++-
 drivers/clk/mediatek/clk-mt6795-topckgen.c |  3 ++-
 drivers/clk/mediatek/clk-mt6797.c          |  3 ++-
 drivers/clk/mediatek/clk-mt7622.c          |  8 +++++---
 drivers/clk/mediatek/clk-mt7629.c          |  8 +++++---
 drivers/clk/mediatek/clk-mt8135.c          | 10 ++++++----
 drivers/clk/mediatek/clk-mt8167.c          | 10 ++++++----
 drivers/clk/mediatek/clk-mt8173.c          | 10 ++++++----
 drivers/clk/mediatek/clk-mt8183.c          | 15 +++++++++------
 drivers/clk/mediatek/clk-mt8186-mcu.c      |  3 ++-
 drivers/clk/mediatek/clk-mt8186-topckgen.c |  6 ++++--
 drivers/clk/mediatek/clk-mt8192.c          |  6 ++++--
 drivers/clk/mediatek/clk-mt8195-topckgen.c |  3 ++-
 drivers/clk/mediatek/clk-mt8365.c          |  7 ++++---
 drivers/clk/mediatek/clk-mt8516.c          | 10 ++++++----
 drivers/clk/mediatek/clk-mtk.c             | 11 ++++++-----
 drivers/clk/mediatek/clk-mtk.h             |  3 ++-
 20 files changed, 93 insertions(+), 58 deletions(-)

diff --git a/drivers/clk/mediatek/clk-mt2701.c b/drivers/clk/mediatek/clk-mt2701.c
index c7510f7ba4cc9..e80fe9c942eeb 100644
--- a/drivers/clk/mediatek/clk-mt2701.c
+++ b/drivers/clk/mediatek/clk-mt2701.c
@@ -679,8 +679,9 @@ static int mtk_topckgen_init(struct platform_device *pdev)
 	mtk_clk_register_factors(top_fixed_divs, ARRAY_SIZE(top_fixed_divs),
 								clk_data);
 
-	mtk_clk_register_composites(top_muxes, ARRAY_SIZE(top_muxes),
-				base, &mt2701_clk_lock, clk_data);
+	mtk_clk_register_composites(&pdev->dev, top_muxes,
+				    ARRAY_SIZE(top_muxes), base,
+				    &mt2701_clk_lock, clk_data);
 
 	mtk_clk_register_dividers(top_adj_divs, ARRAY_SIZE(top_adj_divs),
 				base, &mt2701_clk_lock, clk_data);
@@ -905,8 +906,9 @@ static int mtk_pericfg_init(struct platform_device *pdev)
 	mtk_clk_register_gates(&pdev->dev, node, peri_clks,
 			       ARRAY_SIZE(peri_clks), clk_data);
 
-	mtk_clk_register_composites(peri_muxs, ARRAY_SIZE(peri_muxs), base,
-			&mt2701_clk_lock, clk_data);
+	mtk_clk_register_composites(&pdev->dev, peri_muxs,
+				    ARRAY_SIZE(peri_muxs), base,
+				    &mt2701_clk_lock, clk_data);
 
 	r = of_clk_add_hw_provider(node, of_clk_hw_onecell_get, clk_data);
 	if (r)
diff --git a/drivers/clk/mediatek/clk-mt2712.c b/drivers/clk/mediatek/clk-mt2712.c
index 78ebb4f2335c1..a0f0c9ed48d10 100644
--- a/drivers/clk/mediatek/clk-mt2712.c
+++ b/drivers/clk/mediatek/clk-mt2712.c
@@ -1320,8 +1320,9 @@ static int clk_mt2712_top_probe(struct platform_device *pdev)
 	mtk_clk_register_factors(top_early_divs, ARRAY_SIZE(top_early_divs),
 			top_clk_data);
 	mtk_clk_register_factors(top_divs, ARRAY_SIZE(top_divs), top_clk_data);
-	mtk_clk_register_composites(top_muxes, ARRAY_SIZE(top_muxes), base,
-			&mt2712_clk_lock, top_clk_data);
+	mtk_clk_register_composites(&pdev->dev, top_muxes,
+				    ARRAY_SIZE(top_muxes), base,
+				    &mt2712_clk_lock, top_clk_data);
 	mtk_clk_register_dividers(top_adj_divs, ARRAY_SIZE(top_adj_divs), base,
 			&mt2712_clk_lock, top_clk_data);
 	mtk_clk_register_gates(&pdev->dev, node, top_clks,
@@ -1395,8 +1396,11 @@ static int clk_mt2712_mcu_probe(struct platform_device *pdev)
 
 	clk_data = mtk_alloc_clk_data(CLK_MCU_NR_CLK);
 
-	mtk_clk_register_composites(mcu_muxes, ARRAY_SIZE(mcu_muxes), base,
-			&mt2712_clk_lock, clk_data);
+	r = mtk_clk_register_composites(&pdev->dev, mcu_muxes,
+					ARRAY_SIZE(mcu_muxes), base,
+					&mt2712_clk_lock, clk_data);
+	if (r)
+		dev_err(&pdev->dev, "Could not register composites: %d\n", r);
 
 	r = of_clk_add_hw_provider(node, of_clk_hw_onecell_get, clk_data);
 
diff --git a/drivers/clk/mediatek/clk-mt6779.c b/drivers/clk/mediatek/clk-mt6779.c
index 5a396d2464ce5..2c20e40d7c809 100644
--- a/drivers/clk/mediatek/clk-mt6779.c
+++ b/drivers/clk/mediatek/clk-mt6779.c
@@ -1251,11 +1251,13 @@ static int clk_mt6779_top_probe(struct platform_device *pdev)
 	mtk_clk_register_muxes(top_muxes, ARRAY_SIZE(top_muxes),
 			       node, &mt6779_clk_lock, clk_data);
 
-	mtk_clk_register_composites(top_aud_muxes, ARRAY_SIZE(top_aud_muxes),
-				    base, &mt6779_clk_lock, clk_data);
+	mtk_clk_register_composites(&pdev->dev, top_aud_muxes,
+				    ARRAY_SIZE(top_aud_muxes), base,
+				    &mt6779_clk_lock, clk_data);
 
-	mtk_clk_register_composites(top_aud_divs, ARRAY_SIZE(top_aud_divs),
-				    base, &mt6779_clk_lock, clk_data);
+	mtk_clk_register_composites(&pdev->dev, top_aud_divs,
+				    ARRAY_SIZE(top_aud_divs), base,
+				    &mt6779_clk_lock, clk_data);
 
 	return of_clk_add_hw_provider(node, of_clk_hw_onecell_get, clk_data);
 }
diff --git a/drivers/clk/mediatek/clk-mt6795-pericfg.c b/drivers/clk/mediatek/clk-mt6795-pericfg.c
index f69e715e0c1f3..08aaa9b09c363 100644
--- a/drivers/clk/mediatek/clk-mt6795-pericfg.c
+++ b/drivers/clk/mediatek/clk-mt6795-pericfg.c
@@ -114,7 +114,8 @@ static int clk_mt6795_pericfg_probe(struct platform_device *pdev)
 	if (ret)
 		goto free_clk_data;
 
-	ret = mtk_clk_register_composites(peri_clks, ARRAY_SIZE(peri_clks), base,
+	ret = mtk_clk_register_composites(&pdev->dev, peri_clks,
+					  ARRAY_SIZE(peri_clks), base,
 					  &mt6795_peri_clk_lock, clk_data);
 	if (ret)
 		goto unregister_gates;
diff --git a/drivers/clk/mediatek/clk-mt6795-topckgen.c b/drivers/clk/mediatek/clk-mt6795-topckgen.c
index 2948dd1aee8fa..845cc87049303 100644
--- a/drivers/clk/mediatek/clk-mt6795-topckgen.c
+++ b/drivers/clk/mediatek/clk-mt6795-topckgen.c
@@ -557,7 +557,8 @@ static int clk_mt6795_topckgen_probe(struct platform_device *pdev)
 	if (ret)
 		goto unregister_factors;
 
-	ret = mtk_clk_register_composites(top_aud_divs, ARRAY_SIZE(top_aud_divs), base,
+	ret = mtk_clk_register_composites(&pdev->dev, top_aud_divs,
+					  ARRAY_SIZE(top_aud_divs), base,
 					  &mt6795_top_clk_lock, clk_data);
 	if (ret)
 		goto unregister_muxes;
diff --git a/drivers/clk/mediatek/clk-mt6797.c b/drivers/clk/mediatek/clk-mt6797.c
index 29211744b1736..0429a80f3cad7 100644
--- a/drivers/clk/mediatek/clk-mt6797.c
+++ b/drivers/clk/mediatek/clk-mt6797.c
@@ -398,7 +398,8 @@ static int mtk_topckgen_init(struct platform_device *pdev)
 	mtk_clk_register_factors(top_fixed_divs, ARRAY_SIZE(top_fixed_divs),
 				 clk_data);
 
-	mtk_clk_register_composites(top_muxes, ARRAY_SIZE(top_muxes), base,
+	mtk_clk_register_composites(&pdev->dev, top_muxes,
+				    ARRAY_SIZE(top_muxes), base,
 				    &mt6797_clk_lock, clk_data);
 
 	return of_clk_add_hw_provider(node, of_clk_hw_onecell_get, clk_data);
diff --git a/drivers/clk/mediatek/clk-mt7622.c b/drivers/clk/mediatek/clk-mt7622.c
index bba88018f056a..67a296646722f 100644
--- a/drivers/clk/mediatek/clk-mt7622.c
+++ b/drivers/clk/mediatek/clk-mt7622.c
@@ -615,8 +615,9 @@ static int mtk_topckgen_init(struct platform_device *pdev)
 	mtk_clk_register_factors(top_divs, ARRAY_SIZE(top_divs),
 				 clk_data);
 
-	mtk_clk_register_composites(top_muxes, ARRAY_SIZE(top_muxes),
-				    base, &mt7622_clk_lock, clk_data);
+	mtk_clk_register_composites(&pdev->dev, top_muxes,
+				    ARRAY_SIZE(top_muxes), base,
+				    &mt7622_clk_lock, clk_data);
 
 	mtk_clk_register_dividers(top_adj_divs, ARRAY_SIZE(top_adj_divs),
 				  base, &mt7622_clk_lock, clk_data);
@@ -685,7 +686,8 @@ static int mtk_pericfg_init(struct platform_device *pdev)
 	mtk_clk_register_gates(&pdev->dev, node, peri_clks,
 			       ARRAY_SIZE(peri_clks), clk_data);
 
-	mtk_clk_register_composites(peri_muxes, ARRAY_SIZE(peri_muxes), base,
+	mtk_clk_register_composites(&pdev->dev, peri_muxes,
+				    ARRAY_SIZE(peri_muxes), base,
 				    &mt7622_clk_lock, clk_data);
 
 	r = of_clk_add_hw_provider(node, of_clk_hw_onecell_get, clk_data);
diff --git a/drivers/clk/mediatek/clk-mt7629.c b/drivers/clk/mediatek/clk-mt7629.c
index c0cdaf0242961..2019e272d1cd7 100644
--- a/drivers/clk/mediatek/clk-mt7629.c
+++ b/drivers/clk/mediatek/clk-mt7629.c
@@ -566,8 +566,9 @@ static int mtk_topckgen_init(struct platform_device *pdev)
 	mtk_clk_register_factors(top_divs, ARRAY_SIZE(top_divs),
 				 clk_data);
 
-	mtk_clk_register_composites(top_muxes, ARRAY_SIZE(top_muxes),
-				    base, &mt7629_clk_lock, clk_data);
+	mtk_clk_register_composites(&pdev->dev, top_muxes,
+				    ARRAY_SIZE(top_muxes), base,
+				    &mt7629_clk_lock, clk_data);
 
 	clk_prepare_enable(clk_data->hws[CLK_TOP_AXI_SEL]->clk);
 	clk_prepare_enable(clk_data->hws[CLK_TOP_MEM_SEL]->clk);
@@ -613,7 +614,8 @@ static int mtk_pericfg_init(struct platform_device *pdev)
 	mtk_clk_register_gates(&pdev->dev, node, peri_clks,
 			       ARRAY_SIZE(peri_clks), clk_data);
 
-	mtk_clk_register_composites(peri_muxes, ARRAY_SIZE(peri_muxes), base,
+	mtk_clk_register_composites(&pdev->dev, peri_muxes,
+				    ARRAY_SIZE(peri_muxes), base,
 				    &mt7629_clk_lock, clk_data);
 
 	r = of_clk_add_hw_provider(node, of_clk_hw_onecell_get, clk_data);
diff --git a/drivers/clk/mediatek/clk-mt8135.c b/drivers/clk/mediatek/clk-mt8135.c
index 8137cf2252724..a39ad58e27418 100644
--- a/drivers/clk/mediatek/clk-mt8135.c
+++ b/drivers/clk/mediatek/clk-mt8135.c
@@ -536,8 +536,9 @@ static void __init mtk_topckgen_init(struct device_node *node)
 
 	mtk_clk_register_factors(root_clk_alias, ARRAY_SIZE(root_clk_alias), clk_data);
 	mtk_clk_register_factors(top_divs, ARRAY_SIZE(top_divs), clk_data);
-	mtk_clk_register_composites(top_muxes, ARRAY_SIZE(top_muxes), base,
-			&mt8135_clk_lock, clk_data);
+	mtk_clk_register_composites(NULL, top_muxes,
+				    ARRAY_SIZE(top_muxes), base,
+				    &mt8135_clk_lock, clk_data);
 
 	r = of_clk_add_hw_provider(node, of_clk_hw_onecell_get, clk_data);
 	if (r)
@@ -581,8 +582,9 @@ static void __init mtk_pericfg_init(struct device_node *node)
 
 	mtk_clk_register_gates(NULL, node, peri_gates,
 			       ARRAY_SIZE(peri_gates), clk_data);
-	mtk_clk_register_composites(peri_clks, ARRAY_SIZE(peri_clks), base,
-			&mt8135_clk_lock, clk_data);
+	mtk_clk_register_composites(NULL, peri_clks,
+				    ARRAY_SIZE(peri_clks), base,
+				    &mt8135_clk_lock, clk_data);
 
 	r = of_clk_add_hw_provider(node, of_clk_hw_onecell_get, clk_data);
 	if (r)
diff --git a/drivers/clk/mediatek/clk-mt8167.c b/drivers/clk/mediatek/clk-mt8167.c
index 59fe82ba5c7a1..91669ebafaf9b 100644
--- a/drivers/clk/mediatek/clk-mt8167.c
+++ b/drivers/clk/mediatek/clk-mt8167.c
@@ -940,8 +940,9 @@ static void __init mtk_topckgen_init(struct device_node *node)
 	mtk_clk_register_gates(NULL, node, top_clks, ARRAY_SIZE(top_clks), clk_data);
 
 	mtk_clk_register_factors(top_divs, ARRAY_SIZE(top_divs), clk_data);
-	mtk_clk_register_composites(top_muxes, ARRAY_SIZE(top_muxes), base,
-		&mt8167_clk_lock, clk_data);
+	mtk_clk_register_composites(NULL, top_muxes,
+				    ARRAY_SIZE(top_muxes), base,
+				    &mt8167_clk_lock, clk_data);
 	mtk_clk_register_dividers(top_adj_divs, ARRAY_SIZE(top_adj_divs),
 				base, &mt8167_clk_lock, clk_data);
 
@@ -966,8 +967,9 @@ static void __init mtk_infracfg_init(struct device_node *node)
 
 	clk_data = mtk_alloc_clk_data(CLK_IFR_NR_CLK);
 
-	mtk_clk_register_composites(ifr_muxes, ARRAY_SIZE(ifr_muxes), base,
-		&mt8167_clk_lock, clk_data);
+	mtk_clk_register_composites(NULL, ifr_muxes,
+				    ARRAY_SIZE(ifr_muxes), base,
+				    &mt8167_clk_lock, clk_data);
 
 	r = of_clk_add_hw_provider(node, of_clk_hw_onecell_get, clk_data);
 	if (r)
diff --git a/drivers/clk/mediatek/clk-mt8173.c b/drivers/clk/mediatek/clk-mt8173.c
index 74ed7dd129f47..d05c1109b4f87 100644
--- a/drivers/clk/mediatek/clk-mt8173.c
+++ b/drivers/clk/mediatek/clk-mt8173.c
@@ -869,8 +869,9 @@ static void __init mtk_topckgen_init(struct device_node *node)
 
 	mtk_clk_register_fixed_clks(fixed_clks, ARRAY_SIZE(fixed_clks), clk_data);
 	mtk_clk_register_factors(top_divs, ARRAY_SIZE(top_divs), clk_data);
-	mtk_clk_register_composites(top_muxes, ARRAY_SIZE(top_muxes), base,
-			&mt8173_clk_lock, clk_data);
+	mtk_clk_register_composites(NULL, top_muxes,
+				    ARRAY_SIZE(top_muxes), base,
+				    &mt8173_clk_lock, clk_data);
 
 	r = of_clk_add_hw_provider(node, of_clk_hw_onecell_get, clk_data);
 	if (r)
@@ -920,8 +921,9 @@ static void __init mtk_pericfg_init(struct device_node *node)
 
 	mtk_clk_register_gates(NULL, node, peri_gates,
 			       ARRAY_SIZE(peri_gates), clk_data);
-	mtk_clk_register_composites(peri_clks, ARRAY_SIZE(peri_clks), base,
-			&mt8173_clk_lock, clk_data);
+	mtk_clk_register_composites(NULL, peri_clks,
+				    ARRAY_SIZE(peri_clks), base,
+				    &mt8173_clk_lock, clk_data);
 
 	r = of_clk_add_hw_provider(node, of_clk_hw_onecell_get, clk_data);
 	if (r)
diff --git a/drivers/clk/mediatek/clk-mt8183.c b/drivers/clk/mediatek/clk-mt8183.c
index ba0d6ba10b359..bf7b342332536 100644
--- a/drivers/clk/mediatek/clk-mt8183.c
+++ b/drivers/clk/mediatek/clk-mt8183.c
@@ -1241,11 +1241,13 @@ static int clk_mt8183_top_probe(struct platform_device *pdev)
 	mtk_clk_register_muxes(top_muxes, ARRAY_SIZE(top_muxes),
 		node, &mt8183_clk_lock, top_clk_data);
 
-	mtk_clk_register_composites(top_aud_muxes, ARRAY_SIZE(top_aud_muxes),
-		base, &mt8183_clk_lock, top_clk_data);
+	mtk_clk_register_composites(&pdev->dev, top_aud_muxes,
+				    ARRAY_SIZE(top_aud_muxes), base,
+				    &mt8183_clk_lock, top_clk_data);
 
-	mtk_clk_register_composites(top_aud_divs, ARRAY_SIZE(top_aud_divs),
-		base, &mt8183_clk_lock, top_clk_data);
+	mtk_clk_register_composites(&pdev->dev, top_aud_divs,
+				    ARRAY_SIZE(top_aud_divs), base,
+				    &mt8183_clk_lock, top_clk_data);
 
 	mtk_clk_register_gates(&pdev->dev, node, top_clks,
 			       ARRAY_SIZE(top_clks), top_clk_data);
@@ -1308,8 +1310,9 @@ static int clk_mt8183_mcu_probe(struct platform_device *pdev)
 
 	clk_data = mtk_alloc_clk_data(CLK_MCU_NR_CLK);
 
-	mtk_clk_register_composites(mcu_muxes, ARRAY_SIZE(mcu_muxes), base,
-			&mt8183_clk_lock, clk_data);
+	mtk_clk_register_composites(&pdev->dev, mcu_muxes,
+				    ARRAY_SIZE(mcu_muxes), base,
+				    &mt8183_clk_lock, clk_data);
 
 	return of_clk_add_hw_provider(node, of_clk_hw_onecell_get, clk_data);
 }
diff --git a/drivers/clk/mediatek/clk-mt8186-mcu.c b/drivers/clk/mediatek/clk-mt8186-mcu.c
index dfc305c1fc5d8..e52a2d986c99c 100644
--- a/drivers/clk/mediatek/clk-mt8186-mcu.c
+++ b/drivers/clk/mediatek/clk-mt8186-mcu.c
@@ -65,7 +65,8 @@ static int clk_mt8186_mcu_probe(struct platform_device *pdev)
 		goto free_mcu_data;
 	}
 
-	r = mtk_clk_register_composites(mcu_muxes, ARRAY_SIZE(mcu_muxes), base,
+	r = mtk_clk_register_composites(&pdev->dev, mcu_muxes,
+					ARRAY_SIZE(mcu_muxes), base,
 					NULL, clk_data);
 	if (r)
 		goto free_mcu_data;
diff --git a/drivers/clk/mediatek/clk-mt8186-topckgen.c b/drivers/clk/mediatek/clk-mt8186-topckgen.c
index d7f2c4663c853..4ac157320a6b9 100644
--- a/drivers/clk/mediatek/clk-mt8186-topckgen.c
+++ b/drivers/clk/mediatek/clk-mt8186-topckgen.c
@@ -720,12 +720,14 @@ static int clk_mt8186_topck_probe(struct platform_device *pdev)
 	if (r)
 		goto unregister_factors;
 
-	r = mtk_clk_register_composites(top_muxes, ARRAY_SIZE(top_muxes), base,
+	r = mtk_clk_register_composites(&pdev->dev, top_muxes,
+					ARRAY_SIZE(top_muxes), base,
 					&mt8186_clk_lock, clk_data);
 	if (r)
 		goto unregister_muxes;
 
-	r = mtk_clk_register_composites(top_adj_divs, ARRAY_SIZE(top_adj_divs), base,
+	r = mtk_clk_register_composites(&pdev->dev, top_adj_divs,
+					ARRAY_SIZE(top_adj_divs), base,
 					&mt8186_clk_lock, clk_data);
 	if (r)
 		goto unregister_composite_muxes;
diff --git a/drivers/clk/mediatek/clk-mt8192.c b/drivers/clk/mediatek/clk-mt8192.c
index ac1eee513649b..ab856d0276184 100644
--- a/drivers/clk/mediatek/clk-mt8192.c
+++ b/drivers/clk/mediatek/clk-mt8192.c
@@ -1117,12 +1117,14 @@ static int clk_mt8192_top_probe(struct platform_device *pdev)
 	if (r)
 		goto unregister_factors;
 
-	r = mtk_clk_register_composites(top_muxes, ARRAY_SIZE(top_muxes), base,
+	r = mtk_clk_register_composites(&pdev->dev, top_muxes,
+					ARRAY_SIZE(top_muxes), base,
 					&mt8192_clk_lock, top_clk_data);
 	if (r)
 		goto unregister_muxes;
 
-	r = mtk_clk_register_composites(top_adj_divs, ARRAY_SIZE(top_adj_divs), base,
+	r = mtk_clk_register_composites(&pdev->dev, top_adj_divs,
+					ARRAY_SIZE(top_adj_divs), base,
 					&mt8192_clk_lock, top_clk_data);
 	if (r)
 		goto unregister_top_composites;
diff --git a/drivers/clk/mediatek/clk-mt8195-topckgen.c b/drivers/clk/mediatek/clk-mt8195-topckgen.c
index e6e0298d64494..aae31ef3903de 100644
--- a/drivers/clk/mediatek/clk-mt8195-topckgen.c
+++ b/drivers/clk/mediatek/clk-mt8195-topckgen.c
@@ -1281,7 +1281,8 @@ static int clk_mt8195_topck_probe(struct platform_device *pdev)
 	if (r)
 		goto unregister_muxes;
 
-	r = mtk_clk_register_composites(top_adj_divs, ARRAY_SIZE(top_adj_divs), base,
+	r = mtk_clk_register_composites(&pdev->dev, top_adj_divs,
+					ARRAY_SIZE(top_adj_divs), base,
 					&mt8195_clk_lock, top_clk_data);
 	if (r)
 		goto unregister_muxes;
diff --git a/drivers/clk/mediatek/clk-mt8365.c b/drivers/clk/mediatek/clk-mt8365.c
index b30cbeae1c3d3..0482a8aa43cc9 100644
--- a/drivers/clk/mediatek/clk-mt8365.c
+++ b/drivers/clk/mediatek/clk-mt8365.c
@@ -952,7 +952,7 @@ static int clk_mt8365_top_probe(struct platform_device *pdev)
 	if (ret)
 		goto unregister_factors;
 
-	ret = mtk_clk_register_composites(top_misc_mux_gates,
+	ret = mtk_clk_register_composites(&pdev->dev, top_misc_mux_gates,
 					  ARRAY_SIZE(top_misc_mux_gates), base,
 					  &mt8365_clk_lock, clk_data);
 	if (ret)
@@ -1080,8 +1080,9 @@ static int clk_mt8365_mcu_probe(struct platform_device *pdev)
 	if (!clk_data)
 		return -ENOMEM;
 
-	ret = mtk_clk_register_composites(mcu_muxes, ARRAY_SIZE(mcu_muxes),
-					  base, &mt8365_clk_lock, clk_data);
+	ret = mtk_clk_register_composites(&pdev->dev, mcu_muxes,
+					  ARRAY_SIZE(mcu_muxes), base,
+					  &mt8365_clk_lock, clk_data);
 	if (ret)
 		goto free_clk_data;
 
diff --git a/drivers/clk/mediatek/clk-mt8516.c b/drivers/clk/mediatek/clk-mt8516.c
index bde0b8c761d47..6983d3a48dc9a 100644
--- a/drivers/clk/mediatek/clk-mt8516.c
+++ b/drivers/clk/mediatek/clk-mt8516.c
@@ -658,8 +658,9 @@ static void __init mtk_topckgen_init(struct device_node *node)
 	mtk_clk_register_gates(NULL, node, top_clks, ARRAY_SIZE(top_clks), clk_data);
 
 	mtk_clk_register_factors(top_divs, ARRAY_SIZE(top_divs), clk_data);
-	mtk_clk_register_composites(top_muxes, ARRAY_SIZE(top_muxes), base,
-		&mt8516_clk_lock, clk_data);
+	mtk_clk_register_composites(NULL, top_muxes,
+				    ARRAY_SIZE(top_muxes), base,
+				    &mt8516_clk_lock, clk_data);
 	mtk_clk_register_dividers(top_adj_divs, ARRAY_SIZE(top_adj_divs),
 				base, &mt8516_clk_lock, clk_data);
 
@@ -684,8 +685,9 @@ static void __init mtk_infracfg_init(struct device_node *node)
 
 	clk_data = mtk_alloc_clk_data(CLK_IFR_NR_CLK);
 
-	mtk_clk_register_composites(ifr_muxes, ARRAY_SIZE(ifr_muxes), base,
-		&mt8516_clk_lock, clk_data);
+	mtk_clk_register_composites(NULL, ifr_muxes,
+				    ARRAY_SIZE(ifr_muxes), base,
+				    &mt8516_clk_lock, clk_data);
 
 	r = of_clk_add_hw_provider(node, of_clk_hw_onecell_get, clk_data);
 	if (r)
diff --git a/drivers/clk/mediatek/clk-mtk.c b/drivers/clk/mediatek/clk-mtk.c
index 6123b234d3c3b..152f3d906ef8a 100644
--- a/drivers/clk/mediatek/clk-mtk.c
+++ b/drivers/clk/mediatek/clk-mtk.c
@@ -197,8 +197,8 @@ void mtk_clk_unregister_factors(const struct mtk_fixed_factor *clks, int num,
 }
 EXPORT_SYMBOL_GPL(mtk_clk_unregister_factors);
 
-static struct clk_hw *mtk_clk_register_composite(const struct mtk_composite *mc,
-		void __iomem *base, spinlock_t *lock)
+static struct clk_hw *mtk_clk_register_composite(struct device *dev,
+		const struct mtk_composite *mc, void __iomem *base, spinlock_t *lock)
 {
 	struct clk_hw *hw;
 	struct clk_mux *mux = NULL;
@@ -264,7 +264,7 @@ static struct clk_hw *mtk_clk_register_composite(const struct mtk_composite *mc,
 		div_ops = &clk_divider_ops;
 	}
 
-	hw = clk_hw_register_composite(NULL, mc->name, parent_names, num_parents,
+	hw = clk_hw_register_composite(dev, mc->name, parent_names, num_parents,
 		mux_hw, mux_ops,
 		div_hw, div_ops,
 		gate_hw, gate_ops,
@@ -308,7 +308,8 @@ static void mtk_clk_unregister_composite(struct clk_hw *hw)
 	kfree(mux);
 }
 
-int mtk_clk_register_composites(const struct mtk_composite *mcs, int num,
+int mtk_clk_register_composites(struct device *dev,
+				const struct mtk_composite *mcs, int num,
 				void __iomem *base, spinlock_t *lock,
 				struct clk_hw_onecell_data *clk_data)
 {
@@ -327,7 +328,7 @@ int mtk_clk_register_composites(const struct mtk_composite *mcs, int num,
 			continue;
 		}
 
-		hw = mtk_clk_register_composite(mc, base, lock);
+		hw = mtk_clk_register_composite(dev, mc, base, lock);
 
 		if (IS_ERR(hw)) {
 			pr_err("Failed to register clk %s: %pe\n", mc->name,
diff --git a/drivers/clk/mediatek/clk-mtk.h b/drivers/clk/mediatek/clk-mtk.h
index 63ae7941aa92f..3993a60738c77 100644
--- a/drivers/clk/mediatek/clk-mtk.h
+++ b/drivers/clk/mediatek/clk-mtk.h
@@ -149,7 +149,8 @@ struct mtk_composite {
 		.flags = 0,						\
 	}
 
-int mtk_clk_register_composites(const struct mtk_composite *mcs, int num,
+int mtk_clk_register_composites(struct device *dev,
+				const struct mtk_composite *mcs, int num,
 				void __iomem *base, spinlock_t *lock,
 				struct clk_hw_onecell_data *clk_data);
 void mtk_clk_unregister_composites(const struct mtk_composite *mcs, int num,
-- 
2.43.0



