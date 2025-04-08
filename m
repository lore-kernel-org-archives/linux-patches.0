Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E4A266EFC;
	Tue,  8 Apr 2025 11:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111277; cv=none; b=saQmLvhojJ6J3OdJ1XFu3U9kV/JOj27mRtuLpyVV28nAKvKdFzskQGY3fzGZOv8n8smGo7N7oJcn3r3rAnoR5uZT+Po8kYDMjL2YXAO0SBQfAZP6By0VaA+BoKyglIZhV/a7g0y4ARDvdCnNkFJV91XNN5jKawlp+aBI6hxsylk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111277; c=relaxed/simple;
	bh=I/JHxvAKiPyQlUKxA3OpbAl6kvZRSNDMIjjqQ3xXYqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KHW8NomBbvj9YTxfVzB54bZUwcPDdia1iPH2E12AMT+8zTiwPNxqDxkW6wdj2WBLU4tb8COuNzbTA77g83yE8hMzTLoYpeyVpaTYaO9+JZsWEmhLPVsuIJ+otmNNdTCZcAtdapwvA2TtPfuvUUomRYOb9rgWBsATWsIhps5+xQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fuVOLLtZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fuVOLLtZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C21C4CEE5;
	Tue,  8 Apr 2025 11:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111277;
	bh=I/JHxvAKiPyQlUKxA3OpbAl6kvZRSNDMIjjqQ3xXYqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fuVOLLtZsNe7M4ue2G55tYR6s2GgcE1CJFDAYppg262ydTzEzuGxmPPMYtPVLAgYa
	 ohyiYq0pKw12dz/J3zhGrnO4NBA0ywOC+gqso9peP+D/1/riHvL7pWigftwsRHb5Ih
	 /tY6EXBGYGFjUpQBgOyKvUdFwbmKlFbHNtq+JXGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 372/731] clk: renesas: r8a08g045: Check the source of the CPU PLL settings
Date: Tue,  8 Apr 2025 12:44:29 +0200
Message-ID: <20250408104922.931670661@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

[ Upstream commit dc0f16c1b76293ac942a783e960abfd19e95fdf5 ]

On the RZ/G3S SoC, the CPU PLL settings can be set and retrieved through
the CPG_PLL1_CLK1 and CPG_PLL1_CLK2 registers.  However, these settings
are applied only when CPG_PLL1_SETTING.SEL_PLL1 is set to 0.
Otherwise, the CPU PLL operates at the default frequency of 1.1 GHz.
Hence add support to the PLL driver for returning the 1.1 GHz frequency
when the CPU PLL is configured with the default frequency.

Fixes: 01eabef547e6 ("clk: renesas: rzg2l: Add support for RZ/G3S PLL")
Fixes: de60a3ebe410 ("clk: renesas: Add minimal boot support for RZ/G3S SoC")
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/20250115142059.1833063-1-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r9a08g045-cpg.c |  5 +++--
 drivers/clk/renesas/rzg2l-cpg.c     | 13 ++++++++++++-
 drivers/clk/renesas/rzg2l-cpg.h     | 10 +++++++---
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/renesas/r9a08g045-cpg.c b/drivers/clk/renesas/r9a08g045-cpg.c
index 0e7e3bf05b52d..cb63d397429f6 100644
--- a/drivers/clk/renesas/r9a08g045-cpg.c
+++ b/drivers/clk/renesas/r9a08g045-cpg.c
@@ -51,7 +51,7 @@
 #define G3S_SEL_SDHI2		SEL_PLL_PACK(G3S_CPG_SDHI_DSEL, 8, 2)
 
 /* PLL 1/4/6 configuration registers macro. */
-#define G3S_PLL146_CONF(clk1, clk2)	((clk1) << 22 | (clk2) << 12)
+#define G3S_PLL146_CONF(clk1, clk2, setting)	((clk1) << 22 | (clk2) << 12 | (setting))
 
 #define DEF_G3S_MUX(_name, _id, _conf, _parent_names, _mux_flags, _clk_flags) \
 	DEF_TYPE(_name, _id, CLK_TYPE_MUX, .conf = (_conf), \
@@ -134,7 +134,8 @@ static const struct cpg_core_clk r9a08g045_core_clks[] __initconst = {
 
 	/* Internal Core Clocks */
 	DEF_FIXED(".osc_div1000", CLK_OSC_DIV1000, CLK_EXTAL, 1, 1000),
-	DEF_G3S_PLL(".pll1", CLK_PLL1, CLK_EXTAL, G3S_PLL146_CONF(0x4, 0x8)),
+	DEF_G3S_PLL(".pll1", CLK_PLL1, CLK_EXTAL, G3S_PLL146_CONF(0x4, 0x8, 0x100),
+		    1100000000UL),
 	DEF_FIXED(".pll2", CLK_PLL2, CLK_EXTAL, 200, 3),
 	DEF_FIXED(".pll3", CLK_PLL3, CLK_EXTAL, 200, 3),
 	DEF_FIXED(".pll4", CLK_PLL4, CLK_EXTAL, 100, 3),
diff --git a/drivers/clk/renesas/rzg2l-cpg.c b/drivers/clk/renesas/rzg2l-cpg.c
index ddf722ca79eb0..4bd8862dc82be 100644
--- a/drivers/clk/renesas/rzg2l-cpg.c
+++ b/drivers/clk/renesas/rzg2l-cpg.c
@@ -51,6 +51,7 @@
 #define RZG3S_DIV_M		GENMASK(25, 22)
 #define RZG3S_DIV_NI		GENMASK(21, 13)
 #define RZG3S_DIV_NF		GENMASK(12, 1)
+#define RZG3S_SEL_PLL		BIT(0)
 
 #define CLK_ON_R(reg)		(reg)
 #define CLK_MON_R(reg)		(0x180 + (reg))
@@ -60,6 +61,7 @@
 #define GET_REG_OFFSET(val)		((val >> 20) & 0xfff)
 #define GET_REG_SAMPLL_CLK1(val)	((val >> 22) & 0xfff)
 #define GET_REG_SAMPLL_CLK2(val)	((val >> 12) & 0xfff)
+#define GET_REG_SAMPLL_SETTING(val)	((val) & 0xfff)
 
 #define CPG_WEN_BIT		BIT(16)
 
@@ -943,6 +945,7 @@ rzg2l_cpg_sipll5_register(const struct cpg_core_clk *core,
 
 struct pll_clk {
 	struct clk_hw hw;
+	unsigned long default_rate;
 	unsigned int conf;
 	unsigned int type;
 	void __iomem *base;
@@ -980,12 +983,19 @@ static unsigned long rzg3s_cpg_pll_clk_recalc_rate(struct clk_hw *hw,
 {
 	struct pll_clk *pll_clk = to_pll(hw);
 	struct rzg2l_cpg_priv *priv = pll_clk->priv;
-	u32 nir, nfr, mr, pr, val;
+	u32 nir, nfr, mr, pr, val, setting;
 	u64 rate;
 
 	if (pll_clk->type != CLK_TYPE_G3S_PLL)
 		return parent_rate;
 
+	setting = GET_REG_SAMPLL_SETTING(pll_clk->conf);
+	if (setting) {
+		val = readl(priv->base + setting);
+		if (val & RZG3S_SEL_PLL)
+			return pll_clk->default_rate;
+	}
+
 	val = readl(priv->base + GET_REG_SAMPLL_CLK1(pll_clk->conf));
 
 	pr = 1 << FIELD_GET(RZG3S_DIV_P, val);
@@ -1038,6 +1048,7 @@ rzg2l_cpg_pll_clk_register(const struct cpg_core_clk *core,
 	pll_clk->base = priv->base;
 	pll_clk->priv = priv;
 	pll_clk->type = core->type;
+	pll_clk->default_rate = core->default_rate;
 
 	ret = devm_clk_hw_register(dev, &pll_clk->hw);
 	if (ret)
diff --git a/drivers/clk/renesas/rzg2l-cpg.h b/drivers/clk/renesas/rzg2l-cpg.h
index 881a89b5a7100..b74c94a16986e 100644
--- a/drivers/clk/renesas/rzg2l-cpg.h
+++ b/drivers/clk/renesas/rzg2l-cpg.h
@@ -102,7 +102,10 @@ struct cpg_core_clk {
 	const struct clk_div_table *dtable;
 	const u32 *mtable;
 	const unsigned long invalid_rate;
-	const unsigned long max_rate;
+	union {
+		const unsigned long max_rate;
+		const unsigned long default_rate;
+	};
 	const char * const *parent_names;
 	notifier_fn_t notifier;
 	u32 flag;
@@ -144,8 +147,9 @@ enum clk_types {
 	DEF_TYPE(_name, _id, _type, .parent = _parent)
 #define DEF_SAMPLL(_name, _id, _parent, _conf) \
 	DEF_TYPE(_name, _id, CLK_TYPE_SAM_PLL, .parent = _parent, .conf = _conf)
-#define DEF_G3S_PLL(_name, _id, _parent, _conf) \
-	DEF_TYPE(_name, _id, CLK_TYPE_G3S_PLL, .parent = _parent, .conf = _conf)
+#define DEF_G3S_PLL(_name, _id, _parent, _conf, _default_rate) \
+	DEF_TYPE(_name, _id, CLK_TYPE_G3S_PLL, .parent = _parent, .conf = _conf, \
+		 .default_rate = _default_rate)
 #define DEF_INPUT(_name, _id) \
 	DEF_TYPE(_name, _id, CLK_TYPE_IN)
 #define DEF_FIXED(_name, _id, _parent, _mult, _div) \
-- 
2.39.5



