Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBF41946C7;
	Wed,  5 Mar 2025 17:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197037; cv=none; b=j0T6IEocf/4dF1e39LBcnPOq5oVXafWec43aTNAdwuW4xGz5G6+74Y4T9Zxm52I4Lzs6thfPRfXBFz+7T3En5b/7OLwUq8RrSpZCI2wrG5mbJe7Ps24rMHkj6OiUS8OkDSXHiF3JDSvhDXD0QgNAavJK5GIj7VFxqfCfo7q/bP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197037; c=relaxed/simple;
	bh=Ju2Dg2NFSa35L8ANPMWzP3ZmrzPxPTD2N0DGq8Nx66g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b1capRO1UheVKPM6ok+5a7aKcp+TY/Q9F/25ws4ywaYJ9LeLIOAql2udeLQhVS+iSGngyjnId8Mz93H/USCRTw+sneXvw+YFDx7YWGys34AXLfzSqQv7OSgZXZ5LmbriStylqCnrj9LwWHLdi6oyPEEqldgo5+g4WetrKvj2Xns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f3YImxxy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f3YImxxy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1B3C4CED1;
	Wed,  5 Mar 2025 17:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197036;
	bh=Ju2Dg2NFSa35L8ANPMWzP3ZmrzPxPTD2N0DGq8Nx66g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f3YImxxywmrr70cywtA6ng+pos2V7uR2TPrJKzpEE1eS8UlcOT7VV4s6ldluITEfg
	 lxOGCvg7KCTbjKJlmaaIryLyjT4hiMjgDCIUTqa/vLXqJqAqr1wyE1z7yL1Vj1kDC8
	 o4gDEM6GKJBuaeuJzx9o4u/8hf3DDCrqRC++gaZw=
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
Subject: [PATCH 6.1 018/176] clk: mediatek: clk-mtk: Add dummy clock ops
Date: Wed,  5 Mar 2025 18:46:27 +0100
Message-ID: <20250305174506.194172398@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit b8eb1081d267708ba976525a1fe2162901b34f3a ]

In order to migrate some (few) old clock drivers to the common
mtk_clk_simple_probe() function, add dummy clock ops to be able
to insert a dummy clock with ID 0 at the beginning of the list.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Miles Chen <miles.chen@mediatek.com>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Tested-by: Miles Chen <miles.chen@mediatek.com>
Link: https://lore.kernel.org/r/20230120092053.182923-8-angelogioacchino.delregno@collabora.com
Tested-by: Mingming Su <mingming.su@mediatek.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: 7c8746126a4e ("clk: mediatek: mt2701-vdec: fix conversion to mtk_clk_simple_probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mtk.c | 16 ++++++++++++++++
 drivers/clk/mediatek/clk-mtk.h | 19 +++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/drivers/clk/mediatek/clk-mtk.c b/drivers/clk/mediatek/clk-mtk.c
index 9dbfc11d5c591..7b1ad73309b1a 100644
--- a/drivers/clk/mediatek/clk-mtk.c
+++ b/drivers/clk/mediatek/clk-mtk.c
@@ -21,6 +21,22 @@
 #include "clk-gate.h"
 #include "clk-mux.h"
 
+const struct mtk_gate_regs cg_regs_dummy = { 0, 0, 0 };
+EXPORT_SYMBOL_GPL(cg_regs_dummy);
+
+static int mtk_clk_dummy_enable(struct clk_hw *hw)
+{
+	return 0;
+}
+
+static void mtk_clk_dummy_disable(struct clk_hw *hw) { }
+
+const struct clk_ops mtk_clk_dummy_ops = {
+	.enable		= mtk_clk_dummy_enable,
+	.disable	= mtk_clk_dummy_disable,
+};
+EXPORT_SYMBOL_GPL(mtk_clk_dummy_ops);
+
 static void mtk_init_clk_data(struct clk_hw_onecell_data *clk_data,
 			      unsigned int clk_num)
 {
diff --git a/drivers/clk/mediatek/clk-mtk.h b/drivers/clk/mediatek/clk-mtk.h
index 65c24ab6c9470..04f371730ee30 100644
--- a/drivers/clk/mediatek/clk-mtk.h
+++ b/drivers/clk/mediatek/clk-mtk.h
@@ -22,6 +22,25 @@
 
 struct platform_device;
 
+/*
+ * We need the clock IDs to start from zero but to maintain devicetree
+ * backwards compatibility we can't change bindings to start from zero.
+ * Only a few platforms are affected, so we solve issues given by the
+ * commonized MTK clocks probe function(s) by adding a dummy clock at
+ * the beginning where needed.
+ */
+#define CLK_DUMMY		0
+
+extern const struct clk_ops mtk_clk_dummy_ops;
+extern const struct mtk_gate_regs cg_regs_dummy;
+
+#define GATE_DUMMY(_id, _name) {				\
+		.id = _id,					\
+		.name = _name,					\
+		.regs = &cg_regs_dummy,				\
+		.ops = &mtk_clk_dummy_ops,			\
+	}
+
 struct mtk_fixed_clk {
 	int id;
 	const char *name;
-- 
2.39.5



