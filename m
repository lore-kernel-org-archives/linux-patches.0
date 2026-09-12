Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFF2419FC9;
	Sat, 12 Sep 2026 09:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207111; cv=none; b=RsyhQG+GAcrd4biHzRnpNkY2zj0rtU5FTXEJxyDXpOQ7+uXF7fC6hdgnMlnj/ZRsltsw5uZUC5dJQhUm3zd74/yVbW5wW3lVhOuH0Ac6P+1fGhgBKGI1vYde6HfydqxCxJaXU742uvnlOZS4ZeGw+RroD5dOGqEVK9HWCvAAmpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207111; c=relaxed/simple;
	bh=M9aXv4qsq8U1gCcUy3PbahaJca9daK9ad75KFpH26S4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iCBKFxYbF3jtc+KZWz9OgpyGzaMOtMEUouQR+w+wajvZ12FJx0pWTCwDNYeSeVswXeFPndN+klE9QKpSvmeWaeFSovg3o1eMdnwZauvKm7oDfYarQHlZEcVhqmKPGZ3AensIL3ayxOC+zKKY9XIN4F1psMl7Xs2abrggehu38Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bzpV4iaY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bzpV4iaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA101F000FF;
	Sat, 12 Sep 2026 09:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207109;
	bh=/AeGUI9UQjFP0uDZCL2ourTwjo1g254sw6M7egR18h4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bzpV4iaY98YtvUelLachNI5FuY1ozSUPaXz85G6llhi9jU/M33jPkyZHgq0+2E/xf
	 iVHCaWxm55wXojSf+iMEUXdHgpqm1n9uXjYNXeVbz1CWaGbea5h3uXpgd5cyKp2BMY
	 D3MDsXjvU9zlITSUYpwyFUHPczB9NPBVm+4VPX5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohit Dsor <mohit.dsor@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Thorsten Leemhuis <regressions@leemhuis.info>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0345/1518] Revert "drm/msm: dsi: fix PLL init in bonded mode"
Date: Sat, 12 Sep 2026 08:41:54 +0200
Message-ID: <20260912065631.277300634@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 44784327815b2a1ad8bb56b9236770cb538c7c27 ]

Commit 93c97bc8d85d ("drm/msm: dsi: fix PLL init in bonded mode") fixed
one of the issues with the DSI bonded mode, but broke non-bonded usecase
for DSI as reported by Mohit Dsor. Clock divider is being programmed
incorrectly, resultin in the wrong display mode being selected. Revert
the offending commit, letting Neil to work on a better fix.

Fixes: 93c97bc8d85d ("drm/msm: dsi: fix PLL init in bonded mode")
Reported-by: Mohit Dsor <mohit.dsor@oss.qualcomm.com>
Closes: https://lore.kernel.org/r/ae07cef84AmXK43H@hu-mdsor-hyd.qualcomm.com
Cc: Neil Armstrong <neil.armstrong@linaro.org>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/739459/
Link: https://lore.kernel.org/r/20260712-msm-revert-dsi-pll-fix-v1-1-40122689ea25@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.h     |  1 +
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c | 18 ++++++++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy.h b/drivers/gpu/drm/msm/dsi/phy/dsi_phy.h
index 3cbf082314924..e391505fdaf04 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy.h
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy.h
@@ -109,6 +109,7 @@ struct msm_dsi_phy {
 	struct msm_dsi_dphy_timing timing;
 	const struct msm_dsi_phy_cfg *cfg;
 	void *tuning_cfg;
+	void *pll_data;
 
 	enum msm_dsi_phy_usecase usecase;
 	bool regulator_ldo_mode;
diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c
index c5e1d2016bcca..32f06edd21a9f 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c
@@ -426,8 +426,11 @@ static void dsi_pll_enable_pll_bias(struct dsi_pll_7nm *pll)
 	u32 data;
 
 	spin_lock_irqsave(&pll->pll_enable_lock, flags);
-	pll->pll_enable_cnt++;
-	WARN_ON(pll->pll_enable_cnt == INT_MAX);
+	if (pll->pll_enable_cnt++) {
+		spin_unlock_irqrestore(&pll->pll_enable_lock, flags);
+		WARN_ON(pll->pll_enable_cnt == INT_MAX);
+		return;
+	}
 
 	data = readl(pll->phy->base + REG_DSI_7nm_PHY_CMN_CTRL_0);
 	data |= DSI_7nm_PHY_CMN_CTRL_0_PLL_SHUTDOWNB;
@@ -873,6 +876,7 @@ static int dsi_pll_7nm_init(struct msm_dsi_phy *phy)
 	spin_lock_init(&pll_7nm->pll_enable_lock);
 
 	pll_7nm->phy = phy;
+	phy->pll_data = pll_7nm;
 
 	ret = pll_7nm_register(pll_7nm, phy->provided_clocks->hws);
 	if (ret) {
@@ -961,8 +965,10 @@ static int dsi_7nm_phy_enable(struct msm_dsi_phy *phy,
 	u32 const delay_us = 5;
 	u32 const timeout_us = 1000;
 	struct msm_dsi_dphy_timing *timing = &phy->timing;
+	struct dsi_pll_7nm *pll = phy->pll_data;
 	void __iomem *base = phy->base;
 	bool less_than_1500_mhz;
+	unsigned long flags;
 	u32 vreg_ctrl_0, vreg_ctrl_1, lane_ctrl0;
 	u32 glbl_pemph_ctrl_0;
 	u32 glbl_str_swi_cal_sel_ctrl, glbl_hstx_str_ctrl_0;
@@ -1084,10 +1090,13 @@ static int dsi_7nm_phy_enable(struct msm_dsi_phy *phy,
 		glbl_rescode_bot_ctrl = 0x3c;
 	}
 
+	spin_lock_irqsave(&pll->pll_enable_lock, flags);
+	pll->pll_enable_cnt = 1;
 	/* de-assert digital and pll power down */
 	data = DSI_7nm_PHY_CMN_CTRL_0_DIGTOP_PWRDN_B |
 	       DSI_7nm_PHY_CMN_CTRL_0_PLL_SHUTDOWNB;
 	writel(data, base + REG_DSI_7nm_PHY_CMN_CTRL_0);
+	spin_unlock_irqrestore(&pll->pll_enable_lock, flags);
 
 	/* Assert PLL core reset */
 	writel(0x00, base + REG_DSI_7nm_PHY_CMN_PLL_CNTRL);
@@ -1200,7 +1209,9 @@ static bool dsi_7nm_set_continuous_clock(struct msm_dsi_phy *phy, bool enable)
 
 static void dsi_7nm_phy_disable(struct msm_dsi_phy *phy)
 {
+	struct dsi_pll_7nm *pll = phy->pll_data;
 	void __iomem *base = phy->base;
+	unsigned long flags;
 	u32 data;
 
 	DBG("");
@@ -1227,8 +1238,11 @@ static void dsi_7nm_phy_disable(struct msm_dsi_phy *phy)
 	writel(data, base + REG_DSI_7nm_PHY_CMN_CTRL_0);
 	writel(0, base + REG_DSI_7nm_PHY_CMN_LANE_CTRL0);
 
+	spin_lock_irqsave(&pll->pll_enable_lock, flags);
+	pll->pll_enable_cnt = 0;
 	/* Turn off all PHY blocks */
 	writel(0x00, base + REG_DSI_7nm_PHY_CMN_CTRL_0);
+	spin_unlock_irqrestore(&pll->pll_enable_lock, flags);
 
 	/* make sure phy is turned off */
 	wmb();
-- 
2.53.0



