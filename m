Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D1F143C49;
	Tue, 23 Apr 2024 21:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908728; cv=none; b=QA99/ua4GH211XnqA4yyc2xMMq3Fzbw0q0IJrC60D6YdkFieNbPZuqh+Vl+CCXTZLChcXQ4cLrb3JZkJinBwPDUJ4Il8dGjudesKVeiAuQJRbZKiI2upTPiUYfZw456qWQtjpPwF0iVzkLWH3LsqzKVB6JLUfg+O7ijIwHX1IJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908728; c=relaxed/simple;
	bh=nNUK7Qn+21C9dLg4ztCCUuk6WKuOQQssg0g1pwyL4xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lIcC/jUGA0C4/crhatvvUHmk++cjhubS7hWuju410YXYSwEYNsJfhGTK2Nw5S7egORafUYeD9twZT28RUl5ptoXg6VcvnIZU0P4UTaJkPoEK1ZQK9XcmZSYj51oeWfHTbrd2Lpv9twTRf4UTM+5XiqShkDd31qC0wvQc0DH1GaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vCp3lWn4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vCp3lWn4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D89C116B1;
	Tue, 23 Apr 2024 21:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908728;
	bh=nNUK7Qn+21C9dLg4ztCCUuk6WKuOQQssg0g1pwyL4xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vCp3lWn4cM6DE7bw1EWLE5T3L0b4jkG8Q5W0Q2YM+7Ql3hsffJF3l3WfbxeSe2Gah
	 OZ3beIRDE1sYptr+gO/ar76MdJrRHtFWXuyFlui4gIvMXK//OjA38LHKzEcgrahdMr
	 lrlbUTpUFNxitzjNbahYnBQMaNA5KsGXwK734kM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Miles Chen <miles.chen@mediatek.com>,
	Mingming Su <mingming.su@mediatek.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/141] clk: mediatek: clk-mux: Propagate struct device for mtk-mux
Date: Tue, 23 Apr 2024 14:39:22 -0700
Message-ID: <20240423213856.231830620@linuxfoundation.org>
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

[ Upstream commit d3d6bd5e25cdc460df33ae1db4f051c4bdd3aa60 ]

Like done for other clocks, propagate struct device for mtk mux clocks
registered through clk-mux helpers to enable runtime pm support.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Tested-by: Miles Chen <miles.chen@mediatek.com>
Link: https://lore.kernel.org/r/20230120092053.182923-7-angelogioacchino.delregno@collabora.com
Tested-by: Mingming Su <mingming.su@mediatek.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: 2f7b1d8b5505 ("clk: mediatek: Do a runtime PM get on controllers during probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mt6765.c          |  3 ++-
 drivers/clk/mediatek/clk-mt6779.c          |  5 +++--
 drivers/clk/mediatek/clk-mt6795-topckgen.c |  3 ++-
 drivers/clk/mediatek/clk-mt7986-infracfg.c |  3 ++-
 drivers/clk/mediatek/clk-mt7986-topckgen.c |  3 ++-
 drivers/clk/mediatek/clk-mt8183.c          |  5 +++--
 drivers/clk/mediatek/clk-mt8186-topckgen.c |  3 ++-
 drivers/clk/mediatek/clk-mt8192.c          |  3 ++-
 drivers/clk/mediatek/clk-mt8195-topckgen.c |  3 ++-
 drivers/clk/mediatek/clk-mt8365.c          |  3 ++-
 drivers/clk/mediatek/clk-mux.c             | 14 ++++++++------
 drivers/clk/mediatek/clk-mux.h             |  3 ++-
 12 files changed, 32 insertions(+), 19 deletions(-)

diff --git a/drivers/clk/mediatek/clk-mt6765.c b/drivers/clk/mediatek/clk-mt6765.c
index 4a7bc6e04580d..c4941523f5520 100644
--- a/drivers/clk/mediatek/clk-mt6765.c
+++ b/drivers/clk/mediatek/clk-mt6765.c
@@ -782,7 +782,8 @@ static int clk_mt6765_top_probe(struct platform_device *pdev)
 				    clk_data);
 	mtk_clk_register_factors(top_divs, ARRAY_SIZE(top_divs),
 				 clk_data);
-	mtk_clk_register_muxes(top_muxes, ARRAY_SIZE(top_muxes), node,
+	mtk_clk_register_muxes(&pdev->dev, top_muxes,
+			       ARRAY_SIZE(top_muxes), node,
 			       &mt6765_clk_lock, clk_data);
 	mtk_clk_register_gates(&pdev->dev, node, top_clks,
 			       ARRAY_SIZE(top_clks), clk_data);
diff --git a/drivers/clk/mediatek/clk-mt6779.c b/drivers/clk/mediatek/clk-mt6779.c
index 2c20e40d7c809..7fe9d12b2dfdd 100644
--- a/drivers/clk/mediatek/clk-mt6779.c
+++ b/drivers/clk/mediatek/clk-mt6779.c
@@ -1248,8 +1248,9 @@ static int clk_mt6779_top_probe(struct platform_device *pdev)
 
 	mtk_clk_register_factors(top_divs, ARRAY_SIZE(top_divs), clk_data);
 
-	mtk_clk_register_muxes(top_muxes, ARRAY_SIZE(top_muxes),
-			       node, &mt6779_clk_lock, clk_data);
+	mtk_clk_register_muxes(&pdev->dev, top_muxes,
+			       ARRAY_SIZE(top_muxes), node,
+			       &mt6779_clk_lock, clk_data);
 
 	mtk_clk_register_composites(&pdev->dev, top_aud_muxes,
 				    ARRAY_SIZE(top_aud_muxes), base,
diff --git a/drivers/clk/mediatek/clk-mt6795-topckgen.c b/drivers/clk/mediatek/clk-mt6795-topckgen.c
index 845cc87049303..2ab8bf5d6d6d9 100644
--- a/drivers/clk/mediatek/clk-mt6795-topckgen.c
+++ b/drivers/clk/mediatek/clk-mt6795-topckgen.c
@@ -552,7 +552,8 @@ static int clk_mt6795_topckgen_probe(struct platform_device *pdev)
 	if (ret)
 		goto unregister_fixed_clks;
 
-	ret = mtk_clk_register_muxes(top_muxes, ARRAY_SIZE(top_muxes), node,
+	ret = mtk_clk_register_muxes(&pdev->dev, top_muxes,
+				     ARRAY_SIZE(top_muxes), node,
 				     &mt6795_top_clk_lock, clk_data);
 	if (ret)
 		goto unregister_factors;
diff --git a/drivers/clk/mediatek/clk-mt7986-infracfg.c b/drivers/clk/mediatek/clk-mt7986-infracfg.c
index 578f150e0ee52..0a4bf87ee1607 100644
--- a/drivers/clk/mediatek/clk-mt7986-infracfg.c
+++ b/drivers/clk/mediatek/clk-mt7986-infracfg.c
@@ -178,7 +178,8 @@ static int clk_mt7986_infracfg_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	mtk_clk_register_factors(infra_divs, ARRAY_SIZE(infra_divs), clk_data);
-	mtk_clk_register_muxes(infra_muxes, ARRAY_SIZE(infra_muxes), node,
+	mtk_clk_register_muxes(&pdev->dev, infra_muxes,
+			       ARRAY_SIZE(infra_muxes), node,
 			       &mt7986_clk_lock, clk_data);
 	mtk_clk_register_gates(&pdev->dev, node, infra_clks,
 			       ARRAY_SIZE(infra_clks), clk_data);
diff --git a/drivers/clk/mediatek/clk-mt7986-topckgen.c b/drivers/clk/mediatek/clk-mt7986-topckgen.c
index de5121cf28774..c9bf47e6098fd 100644
--- a/drivers/clk/mediatek/clk-mt7986-topckgen.c
+++ b/drivers/clk/mediatek/clk-mt7986-topckgen.c
@@ -303,7 +303,8 @@ static int clk_mt7986_topckgen_probe(struct platform_device *pdev)
 	mtk_clk_register_fixed_clks(top_fixed_clks, ARRAY_SIZE(top_fixed_clks),
 				    clk_data);
 	mtk_clk_register_factors(top_divs, ARRAY_SIZE(top_divs), clk_data);
-	mtk_clk_register_muxes(top_muxes, ARRAY_SIZE(top_muxes), node,
+	mtk_clk_register_muxes(&pdev->dev, top_muxes,
+			       ARRAY_SIZE(top_muxes), node,
 			       &mt7986_clk_lock, clk_data);
 
 	clk_prepare_enable(clk_data->hws[CLK_TOP_SYSAXI_SEL]->clk);
diff --git a/drivers/clk/mediatek/clk-mt8183.c b/drivers/clk/mediatek/clk-mt8183.c
index bf7b342332536..78620244144e8 100644
--- a/drivers/clk/mediatek/clk-mt8183.c
+++ b/drivers/clk/mediatek/clk-mt8183.c
@@ -1238,8 +1238,9 @@ static int clk_mt8183_top_probe(struct platform_device *pdev)
 
 	mtk_clk_register_factors(top_divs, ARRAY_SIZE(top_divs), top_clk_data);
 
-	mtk_clk_register_muxes(top_muxes, ARRAY_SIZE(top_muxes),
-		node, &mt8183_clk_lock, top_clk_data);
+	mtk_clk_register_muxes(&pdev->dev, top_muxes,
+			       ARRAY_SIZE(top_muxes), node,
+			       &mt8183_clk_lock, top_clk_data);
 
 	mtk_clk_register_composites(&pdev->dev, top_aud_muxes,
 				    ARRAY_SIZE(top_aud_muxes), base,
diff --git a/drivers/clk/mediatek/clk-mt8186-topckgen.c b/drivers/clk/mediatek/clk-mt8186-topckgen.c
index 4ac157320a6b9..70b6e008a188b 100644
--- a/drivers/clk/mediatek/clk-mt8186-topckgen.c
+++ b/drivers/clk/mediatek/clk-mt8186-topckgen.c
@@ -715,7 +715,8 @@ static int clk_mt8186_topck_probe(struct platform_device *pdev)
 	if (r)
 		goto unregister_fixed_clks;
 
-	r = mtk_clk_register_muxes(top_mtk_muxes, ARRAY_SIZE(top_mtk_muxes), node,
+	r = mtk_clk_register_muxes(&pdev->dev, top_mtk_muxes,
+				   ARRAY_SIZE(top_mtk_muxes), node,
 				   &mt8186_clk_lock, clk_data);
 	if (r)
 		goto unregister_factors;
diff --git a/drivers/clk/mediatek/clk-mt8192.c b/drivers/clk/mediatek/clk-mt8192.c
index ab856d0276184..16feb86dcb1b8 100644
--- a/drivers/clk/mediatek/clk-mt8192.c
+++ b/drivers/clk/mediatek/clk-mt8192.c
@@ -1112,7 +1112,8 @@ static int clk_mt8192_top_probe(struct platform_device *pdev)
 	if (r)
 		goto unregister_early_factors;
 
-	r = mtk_clk_register_muxes(top_mtk_muxes, ARRAY_SIZE(top_mtk_muxes), node,
+	r = mtk_clk_register_muxes(&pdev->dev, top_mtk_muxes,
+				   ARRAY_SIZE(top_mtk_muxes), node,
 				   &mt8192_clk_lock, top_clk_data);
 	if (r)
 		goto unregister_factors;
diff --git a/drivers/clk/mediatek/clk-mt8195-topckgen.c b/drivers/clk/mediatek/clk-mt8195-topckgen.c
index aae31ef3903de..3485ebb17ab83 100644
--- a/drivers/clk/mediatek/clk-mt8195-topckgen.c
+++ b/drivers/clk/mediatek/clk-mt8195-topckgen.c
@@ -1262,7 +1262,8 @@ static int clk_mt8195_topck_probe(struct platform_device *pdev)
 	if (r)
 		goto unregister_fixed_clks;
 
-	r = mtk_clk_register_muxes(top_mtk_muxes, ARRAY_SIZE(top_mtk_muxes), node,
+	r = mtk_clk_register_muxes(&pdev->dev, top_mtk_muxes,
+				   ARRAY_SIZE(top_mtk_muxes), node,
 				   &mt8195_clk_lock, top_clk_data);
 	if (r)
 		goto unregister_factors;
diff --git a/drivers/clk/mediatek/clk-mt8365.c b/drivers/clk/mediatek/clk-mt8365.c
index 0482a8aa43cc9..c9faa07ec0a64 100644
--- a/drivers/clk/mediatek/clk-mt8365.c
+++ b/drivers/clk/mediatek/clk-mt8365.c
@@ -947,7 +947,8 @@ static int clk_mt8365_top_probe(struct platform_device *pdev)
 	if (ret)
 		goto unregister_fixed_clks;
 
-	ret = mtk_clk_register_muxes(top_muxes, ARRAY_SIZE(top_muxes), node,
+	ret = mtk_clk_register_muxes(&pdev->dev, top_muxes,
+				     ARRAY_SIZE(top_muxes), node,
 				     &mt8365_clk_lock, clk_data);
 	if (ret)
 		goto unregister_factors;
diff --git a/drivers/clk/mediatek/clk-mux.c b/drivers/clk/mediatek/clk-mux.c
index ba1720b9e2310..c8593554239d6 100644
--- a/drivers/clk/mediatek/clk-mux.c
+++ b/drivers/clk/mediatek/clk-mux.c
@@ -154,9 +154,10 @@ const struct clk_ops mtk_mux_gate_clr_set_upd_ops  = {
 };
 EXPORT_SYMBOL_GPL(mtk_mux_gate_clr_set_upd_ops);
 
-static struct clk_hw *mtk_clk_register_mux(const struct mtk_mux *mux,
-				 struct regmap *regmap,
-				 spinlock_t *lock)
+static struct clk_hw *mtk_clk_register_mux(struct device *dev,
+					   const struct mtk_mux *mux,
+					   struct regmap *regmap,
+					   spinlock_t *lock)
 {
 	struct mtk_clk_mux *clk_mux;
 	struct clk_init_data init = {};
@@ -177,7 +178,7 @@ static struct clk_hw *mtk_clk_register_mux(const struct mtk_mux *mux,
 	clk_mux->lock = lock;
 	clk_mux->hw.init = &init;
 
-	ret = clk_hw_register(NULL, &clk_mux->hw);
+	ret = clk_hw_register(dev, &clk_mux->hw);
 	if (ret) {
 		kfree(clk_mux);
 		return ERR_PTR(ret);
@@ -198,7 +199,8 @@ static void mtk_clk_unregister_mux(struct clk_hw *hw)
 	kfree(mux);
 }
 
-int mtk_clk_register_muxes(const struct mtk_mux *muxes,
+int mtk_clk_register_muxes(struct device *dev,
+			   const struct mtk_mux *muxes,
 			   int num, struct device_node *node,
 			   spinlock_t *lock,
 			   struct clk_hw_onecell_data *clk_data)
@@ -222,7 +224,7 @@ int mtk_clk_register_muxes(const struct mtk_mux *muxes,
 			continue;
 		}
 
-		hw = mtk_clk_register_mux(mux, regmap, lock);
+		hw = mtk_clk_register_mux(dev, mux, regmap, lock);
 
 		if (IS_ERR(hw)) {
 			pr_err("Failed to register clk %s: %pe\n", mux->name,
diff --git a/drivers/clk/mediatek/clk-mux.h b/drivers/clk/mediatek/clk-mux.h
index 83ff420f4ebe6..7ecb963b0ec68 100644
--- a/drivers/clk/mediatek/clk-mux.h
+++ b/drivers/clk/mediatek/clk-mux.h
@@ -83,7 +83,8 @@ extern const struct clk_ops mtk_mux_gate_clr_set_upd_ops;
 			0, _upd_ofs, _upd, CLK_SET_RATE_PARENT,		\
 			mtk_mux_clr_set_upd_ops)
 
-int mtk_clk_register_muxes(const struct mtk_mux *muxes,
+int mtk_clk_register_muxes(struct device *dev,
+			   const struct mtk_mux *muxes,
 			   int num, struct device_node *node,
 			   spinlock_t *lock,
 			   struct clk_hw_onecell_data *clk_data);
-- 
2.43.0



