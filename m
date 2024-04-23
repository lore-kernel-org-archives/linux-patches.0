Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0DA143C49;
	Tue, 23 Apr 2024 21:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908729; cv=none; b=IjRjDkz+Al3pslgEjhUUIYQ2qI320yOAl4d1sfWU94GzV1w8WaQtpcz8MHo4QvsqFv6cqpvXZzkVLRZrzbcGtuKwrD0H+NfGYALD8A6Gmul0788eANS6RQIW3Qad0vYzL/lqzA9t2HLIadd8PN99xhDhgWGBBrAxaBPTFLGP1k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908729; c=relaxed/simple;
	bh=+U1JW3/RDi4Cud2eOTn/z9fVrflOp+lLmisf6bp26KI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PE7B/g43vwuB2GnKCAi7s/gfAHPRzqEM6TjoBHWOEUy3nfgn/eqkpT8vmHL2z4IyXO1P3NavtNY45vjStAAo0dVThQHuvybEicyBHaiVdplnITURrtUD+MQJf3wzjdQVKkDUVt7j8Etjvk6nNDjn4jdQAIl+I5E2Q33/bzITHeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=146BLQhN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="146BLQhN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E8AC32782;
	Tue, 23 Apr 2024 21:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908729;
	bh=+U1JW3/RDi4Cud2eOTn/z9fVrflOp+lLmisf6bp26KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=146BLQhNP/bk6mCA9DNDYHl21V6Ib2Qqh/uH1/kosXllG0Ljn5ApN+Eck9lbXrvQX
	 i7fr4RjOfKMRp3DKeChMcxUJJZYTN8kB6+op0nTMHESv0P4moB+UviwbiiqXY4/9/2
	 FKDZiHWovAfJSfb9w/AxkkltkIvtn2eA8n4ctoMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Miles Chen <miles.chen@mediatek.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Mingming Su <mingming.su@mediatek.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 095/141] clk: mediatek: clk-mtk: Extend mtk_clk_simple_probe()
Date: Tue, 23 Apr 2024 14:39:23 -0700
Message-ID: <20240423213856.261572909@linuxfoundation.org>
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

[ Upstream commit 7b6183108c8ccf0dc295f39cdf78bd8078455636 ]

As a preparation to increase probe functions commonization across
various MediaTek SoC clock controller drivers, extend function
mtk_clk_simple_probe() to be able to register not only gates, but
also fixed clocks, factors, muxes and composites.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Miles Chen <miles.chen@mediatek.com>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Tested-by: Miles Chen <miles.chen@mediatek.com>
Link: https://lore.kernel.org/r/20230120092053.182923-13-angelogioacchino.delregno@collabora.com
Tested-by: Mingming Su <mingming.su@mediatek.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: 2f7b1d8b5505 ("clk: mediatek: Do a runtime PM get on controllers during probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mtk.c | 101 ++++++++++++++++++++++++++++++---
 drivers/clk/mediatek/clk-mtk.h |  10 ++++
 2 files changed, 103 insertions(+), 8 deletions(-)

diff --git a/drivers/clk/mediatek/clk-mtk.c b/drivers/clk/mediatek/clk-mtk.c
index 152f3d906ef8a..bfabd94a474a5 100644
--- a/drivers/clk/mediatek/clk-mtk.c
+++ b/drivers/clk/mediatek/clk-mtk.c
@@ -11,12 +11,14 @@
 #include <linux/mfd/syscon.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 
 #include "clk-mtk.h"
 #include "clk-gate.h"
+#include "clk-mux.h"
 
 static void mtk_init_clk_data(struct clk_hw_onecell_data *clk_data,
 			      unsigned int clk_num)
@@ -450,20 +452,71 @@ int mtk_clk_simple_probe(struct platform_device *pdev)
 	const struct mtk_clk_desc *mcd;
 	struct clk_hw_onecell_data *clk_data;
 	struct device_node *node = pdev->dev.of_node;
-	int r;
+	void __iomem *base;
+	int num_clks, r;
 
 	mcd = of_device_get_match_data(&pdev->dev);
 	if (!mcd)
 		return -EINVAL;
 
-	clk_data = mtk_alloc_clk_data(mcd->num_clks);
+	/* Composite clocks needs us to pass iomem pointer */
+	if (mcd->composite_clks) {
+		if (!mcd->shared_io)
+			base = devm_platform_ioremap_resource(pdev, 0);
+		else
+			base = of_iomap(node, 0);
+
+		if (IS_ERR_OR_NULL(base))
+			return IS_ERR(base) ? PTR_ERR(base) : -ENOMEM;
+	}
+
+	/* Calculate how many clk_hw_onecell_data entries to allocate */
+	num_clks = mcd->num_clks + mcd->num_composite_clks;
+	num_clks += mcd->num_fixed_clks + mcd->num_factor_clks;
+	num_clks += mcd->num_mux_clks;
+
+	clk_data = mtk_alloc_clk_data(num_clks);
 	if (!clk_data)
 		return -ENOMEM;
 
-	r = mtk_clk_register_gates(&pdev->dev, node, mcd->clks, mcd->num_clks,
-				   clk_data);
-	if (r)
-		goto free_data;
+	if (mcd->fixed_clks) {
+		r = mtk_clk_register_fixed_clks(mcd->fixed_clks,
+						mcd->num_fixed_clks, clk_data);
+		if (r)
+			goto free_data;
+	}
+
+	if (mcd->factor_clks) {
+		r = mtk_clk_register_factors(mcd->factor_clks,
+					     mcd->num_factor_clks, clk_data);
+		if (r)
+			goto unregister_fixed_clks;
+	}
+
+	if (mcd->mux_clks) {
+		r = mtk_clk_register_muxes(&pdev->dev, mcd->mux_clks,
+					   mcd->num_mux_clks, node,
+					   mcd->clk_lock, clk_data);
+		if (r)
+			goto unregister_factors;
+	};
+
+	if (mcd->composite_clks) {
+		/* We don't check composite_lock because it's optional */
+		r = mtk_clk_register_composites(&pdev->dev,
+						mcd->composite_clks,
+						mcd->num_composite_clks,
+						base, mcd->clk_lock, clk_data);
+		if (r)
+			goto unregister_muxes;
+	}
+
+	if (mcd->clks) {
+		r = mtk_clk_register_gates(&pdev->dev, node, mcd->clks,
+					   mcd->num_clks, clk_data);
+		if (r)
+			goto unregister_composites;
+	}
 
 	r = of_clk_add_hw_provider(node, of_clk_hw_onecell_get, clk_data);
 	if (r)
@@ -481,9 +534,28 @@ int mtk_clk_simple_probe(struct platform_device *pdev)
 	return r;
 
 unregister_clks:
-	mtk_clk_unregister_gates(mcd->clks, mcd->num_clks, clk_data);
+	if (mcd->clks)
+		mtk_clk_unregister_gates(mcd->clks, mcd->num_clks, clk_data);
+unregister_composites:
+	if (mcd->composite_clks)
+		mtk_clk_unregister_composites(mcd->composite_clks,
+					      mcd->num_composite_clks, clk_data);
+unregister_muxes:
+	if (mcd->mux_clks)
+		mtk_clk_unregister_muxes(mcd->mux_clks,
+					 mcd->num_mux_clks, clk_data);
+unregister_factors:
+	if (mcd->factor_clks)
+		mtk_clk_unregister_factors(mcd->factor_clks,
+					   mcd->num_factor_clks, clk_data);
+unregister_fixed_clks:
+	if (mcd->fixed_clks)
+		mtk_clk_unregister_fixed_clks(mcd->fixed_clks,
+					      mcd->num_fixed_clks, clk_data);
 free_data:
 	mtk_free_clk_data(clk_data);
+	if (mcd->shared_io && base)
+		iounmap(base);
 	return r;
 }
 EXPORT_SYMBOL_GPL(mtk_clk_simple_probe);
@@ -495,7 +567,20 @@ int mtk_clk_simple_remove(struct platform_device *pdev)
 	struct device_node *node = pdev->dev.of_node;
 
 	of_clk_del_provider(node);
-	mtk_clk_unregister_gates(mcd->clks, mcd->num_clks, clk_data);
+	if (mcd->clks)
+		mtk_clk_unregister_gates(mcd->clks, mcd->num_clks, clk_data);
+	if (mcd->composite_clks)
+		mtk_clk_unregister_composites(mcd->composite_clks,
+					      mcd->num_composite_clks, clk_data);
+	if (mcd->mux_clks)
+		mtk_clk_unregister_muxes(mcd->mux_clks,
+					 mcd->num_mux_clks, clk_data);
+	if (mcd->factor_clks)
+		mtk_clk_unregister_factors(mcd->factor_clks,
+					   mcd->num_factor_clks, clk_data);
+	if (mcd->fixed_clks)
+		mtk_clk_unregister_fixed_clks(mcd->fixed_clks,
+					      mcd->num_fixed_clks, clk_data);
 	mtk_free_clk_data(clk_data);
 
 	return 0;
diff --git a/drivers/clk/mediatek/clk-mtk.h b/drivers/clk/mediatek/clk-mtk.h
index 3993a60738c77..880b3d6d80119 100644
--- a/drivers/clk/mediatek/clk-mtk.h
+++ b/drivers/clk/mediatek/clk-mtk.h
@@ -196,7 +196,17 @@ void mtk_clk_unregister_ref2usb_tx(struct clk_hw *hw);
 struct mtk_clk_desc {
 	const struct mtk_gate *clks;
 	size_t num_clks;
+	const struct mtk_composite *composite_clks;
+	size_t num_composite_clks;
+	const struct mtk_fixed_clk *fixed_clks;
+	size_t num_fixed_clks;
+	const struct mtk_fixed_factor *factor_clks;
+	size_t num_factor_clks;
+	const struct mtk_mux *mux_clks;
+	size_t num_mux_clks;
 	const struct mtk_clk_rst_desc *rst_desc;
+	spinlock_t *clk_lock;
+	bool shared_io;
 };
 
 int mtk_clk_simple_probe(struct platform_device *pdev);
-- 
2.43.0



