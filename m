Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625095;
	b=YsxiE9OHypXF4LgEpKJenMQ6cD6tqnM7XLnClhQz0aeQy083fVPHWLmHGZcPGrYt3CLs
	 6dAsYLZJxxnurmyV6P0hh0ul17sbscne4Qx/RHaFt7TLTLYAbt/M4a9OtunJOSwmjlFTD
	 zdE9jeoq9PUfq7Js08d4JRRtWoZOPnf7uy7CtV87TbGvaeHi0M4Js34iGK3ijA173FVsX
	 qQ7mXjErqKg+NfQQdCDfuNbHZkbjcYKGbdNH+xi+KRbWjVJ55PkGZdJwMsB37jQkmOxSn
	 L8mV2Q4OvFs4fuSMzBA5KrNrX8C1Tp9o+ps7u3pTAU+GO3LjfkvDi0czFFhW8O54p/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625095;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hSQSrstuLfcsHvoDBo3wCi7c7n6I/PfNCsuvQEScw+8=;
	b=xqYtBZkYvSolI926NTgUsVVlHyxZuSVqpLHuFR29AB85aGkqumTnWY9ZhUuv6IRDCLCJ
	 S6bR2wP//VlazVXvugnDCvtw15GCTlgqwiF/+qNHCZAxIqIIMDuRsHP3b+cEQLvfqifvE
	 KXbvVAkvz46RUmdrqP7XgUYsjtHGXQ7VDWClQR048m3tEIgcW4UHhN9GTg8VtgjItyBKt
	 nKEzBJfi3h6efZdyAFRn3gEA7kWHoidTlwZpuBRVl49K1FF82wo8+Sga9J5CWp/J5PSH0
	 XbjxFTZoMvNwhOIU3v054bmNwJrDUlcimzfZrUz+NfscbDU3SlWkhTgQEzfoI0djJEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="t/9cvXRY";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D0A606A321;
	Wed, 25 Nov 2026 16:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t/9cvXRY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065111F000C4;
	Wed, 25 Nov 2026 16:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625095;
	bh=hSQSrstuLfcsHvoDBo3wCi7c7n6I/PfNCsuvQEScw+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t/9cvXRYeBkBKnLitXp6bGY9ujqY9gtgnaj8H7B3CyTvUGNsIw7Z4CUHPTL63djlm
	 mQEudjl0sTgl7KOGgnV2GUxYSfuhgYbHLA+V73GqnV1A6MlxnCJex7iPXu0mrGC8tK
	 POuywfQcoY2ez2wC8HmQqki7MiJTlhw5VToYWujU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 404/816] phy: samsung: usbdrd: propagate GS101 PIPE3 lock failures
Date: Wed, 25 Nov 2026 15:32:32 +0100
Message-ID: <20261125143858.548434299@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 2ef1e78ef7223eb16d9cf20814a1b2873456f671 ]

The GS101 PIPE3 initialization checks the PMA PLL lock and then checks
the CDR lock. The PLL helper returns an error, but the GS101 PIPE3 init
path dropped that result. The CDR helper only logged a timeout. PHY
initialization could therefore still return success after either the PLL
or the selected receive lane had not locked.

Make the in-file SoC-specific phy_init hook return an int so helpers
with real failure results can propagate them through the existing PHY
init paths. Keep the register-only helpers returning success and use the
new return path to report the GS101 CDR wait failure. Other SoC helper
paths keep their previous success behavior.

Fixes: 32267c29bc7d ("phy: exynos5-usbdrd: support Exynos USBDRD 3.1 combo phy (HS & SS)")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260623135349.42739-1-pengpeng@iscas.ac.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
[ sashal: Dropped the exynos7870, exynos2200 and exynosautov920 phy_init conversions (SoCs not present), and adapted the CDR helper and exynos850 phy_init to the older code without phy_mutex or scoped_guard. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/samsung/phy-exynos5-usbdrd.c | 51 +++++++++++++++++-------
 1 file changed, 37 insertions(+), 14 deletions(-)

diff --git a/drivers/phy/samsung/phy-exynos5-usbdrd.c b/drivers/phy/samsung/phy-exynos5-usbdrd.c
index 28d02ae60cc14..ad4a7dfa1ab32 100644
--- a/drivers/phy/samsung/phy-exynos5-usbdrd.c
+++ b/drivers/phy/samsung/phy-exynos5-usbdrd.c
@@ -355,7 +355,7 @@ struct exynos5_usbdrd_phy;
 struct exynos5_usbdrd_phy_config {
 	u32 id;
 	void (*phy_isol)(struct phy_usb_instance *inst, bool isolate);
-	void (*phy_init)(struct exynos5_usbdrd_phy *phy_drd);
+	int (*phy_init)(struct exynos5_usbdrd_phy *phy_drd);
 	unsigned int (*set_refclk)(struct phy_usb_instance *inst);
 };
 
@@ -579,7 +579,7 @@ exynos5_usbdrd_apply_phy_tunes(struct exynos5_usbdrd_phy *phy_drd,
 	}
 }
 
-static void exynos5_usbdrd_pipe3_init(struct exynos5_usbdrd_phy *phy_drd)
+static int exynos5_usbdrd_pipe3_init(struct exynos5_usbdrd_phy *phy_drd)
 {
 	u32 reg;
 
@@ -592,6 +592,8 @@ static void exynos5_usbdrd_pipe3_init(struct exynos5_usbdrd_phy *phy_drd)
 	reg = readl(phy_drd->reg_phy + EXYNOS5_DRD_PHYTEST);
 	reg &= ~PHYTEST_POWERDOWN_SSP;
 	writel(reg, phy_drd->reg_phy + EXYNOS5_DRD_PHYTEST);
+
+	return 0;
 }
 
 static void
@@ -686,7 +688,7 @@ exynos5_usbdrd_usbdp_g2_v4_pma_check_pll_lock(struct exynos5_usbdrd_phy *phy_drd
 	return err;
 }
 
-static void
+static int
 exynos5_usbdrd_usbdp_g2_v4_pma_check_cdr_lock(struct exynos5_usbdrd_phy *phy_drd)
 {
 	static const unsigned int timeout_us = 40000;
@@ -703,7 +705,7 @@ exynos5_usbdrd_usbdp_g2_v4_pma_check_cdr_lock(struct exynos5_usbdrd_phy *phy_drd
 			phy_drd->reg_pma + EXYNOS9_PMA_USBDP_TRSV_REG03C3,
 			reg, (reg & locked) == locked, sleep_us, timeout_us);
 	if (!err)
-		return;
+		return 0;
 
 	dev_err(phy_drd->dev,
 		"timed out waiting for CDR lock (l0): %#.8x, retrying\n", reg);
@@ -715,9 +717,11 @@ exynos5_usbdrd_usbdp_g2_v4_pma_check_cdr_lock(struct exynos5_usbdrd_phy *phy_drd
 	if (err)
 		dev_err(phy_drd->dev,
 			"timed out waiting for CDR lock (l2): %#.8x\n", reg);
+
+	return err;
 }
 
-static void exynos5_usbdrd_utmi_init(struct exynos5_usbdrd_phy *phy_drd)
+static int exynos5_usbdrd_utmi_init(struct exynos5_usbdrd_phy *phy_drd)
 {
 	u32 reg;
 
@@ -739,6 +743,8 @@ static void exynos5_usbdrd_utmi_init(struct exynos5_usbdrd_phy *phy_drd)
 	reg = readl(phy_drd->reg_phy + EXYNOS5_DRD_PHYTEST);
 	reg &= ~PHYTEST_POWERDOWN_HSP;
 	writel(reg, phy_drd->reg_phy + EXYNOS5_DRD_PHYTEST);
+
+	return 0;
 }
 
 static int exynos5_usbdrd_phy_init(struct phy *phy)
@@ -775,7 +781,9 @@ static int exynos5_usbdrd_phy_init(struct phy *phy)
 	writel(reg, phy_drd->reg_phy + EXYNOS5_DRD_PHYUTMICLKSEL);
 
 	/* UTMI or PIPE3 specific init */
-	inst->phy_cfg->phy_init(phy_drd);
+	ret = inst->phy_cfg->phy_init(phy_drd);
+	if (ret)
+		goto disable_clks;
 
 	/* reference clock settings */
 	reg = inst->phy_cfg->set_refclk(inst);
@@ -798,9 +806,10 @@ static int exynos5_usbdrd_phy_init(struct phy *phy)
 	reg &= ~PHYCLKRST_PORTRESET;
 	writel(reg, phy_drd->reg_phy + EXYNOS5_DRD_PHYCLKRST);
 
+disable_clks:
 	clk_bulk_disable_unprepare(phy_drd->drv_data->n_clks, phy_drd->clks);
 
-	return 0;
+	return ret;
 }
 
 static int exynos5_usbdrd_phy_exit(struct phy *phy)
@@ -1067,7 +1076,7 @@ exynos5_usbdrd_usb_v3p1_pipe_override(struct exynos5_usbdrd_phy *phy_drd)
 	writel(reg, regs_base + EXYNOS850_DRD_SECPMACTL);
 }
 
-static void exynos850_usbdrd_utmi_init(struct exynos5_usbdrd_phy *phy_drd)
+static int exynos850_usbdrd_utmi_init(struct exynos5_usbdrd_phy *phy_drd)
 {
 	void __iomem *regs_base = phy_drd->reg_phy;
 	u32 reg;
@@ -1171,6 +1180,8 @@ static void exynos850_usbdrd_utmi_init(struct exynos5_usbdrd_phy *phy_drd)
 
 	if (ss_ports)
 		exynos5_usbdrd_usb_v3p1_pipe_override(phy_drd);
+
+	return 0;
 }
 
 static int exynos850_usbdrd_phy_init(struct phy *phy)
@@ -1184,11 +1195,11 @@ static int exynos850_usbdrd_phy_init(struct phy *phy)
 		return ret;
 
 	/* UTMI or PIPE3 specific init */
-	inst->phy_cfg->phy_init(phy_drd);
+	ret = inst->phy_cfg->phy_init(phy_drd);
 
 	clk_bulk_disable_unprepare(phy_drd->drv_data->n_clks, phy_drd->clks);
 
-	return 0;
+	return ret;
 }
 
 static int exynos850_usbdrd_phy_exit(struct phy *phy)
@@ -1235,11 +1246,12 @@ static const struct phy_ops exynos850_usbdrd_phy_ops = {
 	.owner		= THIS_MODULE,
 };
 
-static void exynos5_usbdrd_gs101_pipe3_init(struct exynos5_usbdrd_phy *phy_drd)
+static int exynos5_usbdrd_gs101_pipe3_init(struct exynos5_usbdrd_phy *phy_drd)
 {
 	void __iomem *regs_pma = phy_drd->reg_pma;
 	void __iomem *regs_phy = phy_drd->reg_phy;
 	u32 reg;
+	int ret;
 
 	exynos5_usbdrd_usbdp_g2_v4_ctrl_pma_ready(phy_drd);
 
@@ -1261,8 +1273,11 @@ static void exynos5_usbdrd_gs101_pipe3_init(struct exynos5_usbdrd_phy *phy_drd)
 		 SECPMACTL_PMA_INIT_SW_RST);
 	writel(reg, regs_phy + EXYNOS850_DRD_SECPMACTL);
 
-	if (!exynos5_usbdrd_usbdp_g2_v4_pma_check_pll_lock(phy_drd))
-		exynos5_usbdrd_usbdp_g2_v4_pma_check_cdr_lock(phy_drd);
+	ret = exynos5_usbdrd_usbdp_g2_v4_pma_check_pll_lock(phy_drd);
+	if (ret)
+		return ret;
+
+	return exynos5_usbdrd_usbdp_g2_v4_pma_check_cdr_lock(phy_drd);
 }
 
 static int exynos5_usbdrd_gs101_phy_init(struct phy *phy)
@@ -1287,7 +1302,15 @@ static int exynos5_usbdrd_gs101_phy_init(struct phy *phy)
 	 */
 	exynos5_usbdrd_phy_isol(inst, false);
 
-	return exynos850_usbdrd_phy_init(phy);
+	ret = exynos850_usbdrd_phy_init(phy);
+	if (ret) {
+		exynos5_usbdrd_phy_isol(inst, true);
+		if (inst->phy_cfg->id == EXYNOS5_DRDPHY_UTMI)
+			regulator_bulk_disable(phy_drd->drv_data->n_regulators,
+					       phy_drd->regulators);
+	}
+
+	return ret;
 }
 
 static int exynos5_usbdrd_gs101_phy_exit(struct phy *phy)
-- 
2.53.0



