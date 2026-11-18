Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054130;
	b=dspih46Y+atvBiiT9ISIqcj/oYnvb7MCqUNK0ouP+iYzkwOBTwN5vtLrWwjIRJ1qWz5y
	 aRlp96y7BwNxW1IoDNWZjkQm2KVha4SppO9Kq8OIIWzrNdXyO3f/FHSuAQFz7vGn2o4P7
	 bP/hpIIi3tkY5sbDKwu07DiJSLW6iT1XuES3Ug2q6vfdXlgZSNE4sQ6W94Jpg0HEQwJMN
	 axn+FAs8i2F8Cc0KYggjl+UUnd2YrUg1lxGIzg07S9Fz4UhvNxtMve29phRoKYLEgunI9
	 KhDjSXtAjqn6X91VN8OwIkqqaNG4ghHcEgRcEIh1uHM0Jel9T8SQO4YPD+PtVyEJQnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9K690g28AWKlEVGK1sGjviKbMbfx4Mz+qWWSXIF2Pbw=;
	b=gqq+9nSf2+JWG3ABS5uD2x7/E06dmKb7J8p9x7nlu6gCbcLgruRHgd2Qh0+Xfa8JvOtW
	 c3yYgJnPIEg5mBOXABHAh8O5Jt2JiONIDd9PMfLC2+NXpr9mcMhUdq08iro+W3RpGx8HD
	 eI/L60Il1gvDn2ckcISIkZeEk9NMvI0AL6nNRAuevcOCHWrwM73MHItmApYcQLLKBbir+
	 UYwHlO8O6xh0iah3DSWwe/4qd+MzNeE5HdklKGU3c07Uo9Nh3GsFXVJgMhrsgStmjnEra
	 u9sDSslqYjaz0TtuCYqTY5YwCW8V+uErm/EGail1DpdHohwLSYshT2+Zo/01i0N8aEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kRqJ+pL9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12C8606A325;
	Thu, 19 Nov 2026 02:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kRqJ+pL9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF0121F000C4;
	Thu, 19 Nov 2026 02:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054130;
	bh=9K690g28AWKlEVGK1sGjviKbMbfx4Mz+qWWSXIF2Pbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kRqJ+pL9rFfW9SoT/Hgk83UCVrJP4av1fOFWnJqvCJsbJLVq9JXDrJmOWGpgKJo2n
	 llYxcSz9lBRdVAgR+fDrenQrrs3kd6VbBYor3MxNsgDEpb7uSUbdrtyd7YfHfYL02O
	 lu+XAtbt3ymw0WMJuDZkcr/XG8oKdds4hFFjyMM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Stephen Boyd <swboyd@chromium.org>,
	Abhinav Kumar <abhinavk@codeaurora.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1166/2214] drm/msm/hdmi: use bulk regulator API
Date: Wed, 18 Nov 2026 15:47:22 +0100
Message-ID: <20261118150058.663058221@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 31b3b1f5e35252b255f2a0d6a3883b09b5c4af97 ]

Switch to using bulk regulator API instead of hand coding loops.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Abhinav Kumar <abhinavk@codeaurora.org>
Link: https://lore.kernel.org/r/20211015001100.4193241-1-dmitry.baryshkov@linaro.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Stable-dep-of: d27f831aaf20 ("drm/msm/hdmi_phy: Cleanup after msm_hdmi_phy_resource_enable() failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/hdmi/hdmi.c        | 34 ++++++++------------------
 drivers/gpu/drm/msm/hdmi/hdmi.h        |  6 ++---
 drivers/gpu/drm/msm/hdmi/hdmi_bridge.c | 20 +++++----------
 drivers/gpu/drm/msm/hdmi/hdmi_hpd.c    | 24 +++++++-----------
 drivers/gpu/drm/msm/hdmi/hdmi_phy.c    | 33 +++++++++----------------
 5 files changed, 40 insertions(+), 77 deletions(-)

diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.c b/drivers/gpu/drm/msm/hdmi/hdmi.c
index 2c944419e1758..eb11fac881334 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -165,19 +165,13 @@ static struct hdmi *msm_hdmi_init(struct platform_device *pdev)
 		ret = -ENOMEM;
 		goto fail;
 	}
-	for (i = 0; i < config->hpd_reg_cnt; i++) {
-		struct regulator *reg;
-
-		reg = devm_regulator_get(&pdev->dev,
-				config->hpd_reg_names[i]);
-		if (IS_ERR(reg)) {
-			ret = PTR_ERR(reg);
-			DRM_DEV_ERROR(&pdev->dev, "failed to get hpd regulator: %s (%d)\n",
-					config->hpd_reg_names[i], ret);
-			goto fail;
-		}
+	for (i = 0; i < config->hpd_reg_cnt; i++)
+		hdmi->hpd_regs[i].supply = config->hpd_reg_names[i];
 
-		hdmi->hpd_regs[i] = reg;
+	ret = devm_regulator_bulk_get(&pdev->dev, config->hpd_reg_cnt, hdmi->hpd_regs);
+	if (ret) {
+		DRM_DEV_ERROR(&pdev->dev, "failed to get hpd regulator: %d\n", ret);
+		goto fail;
 	}
 
 	hdmi->pwr_regs = devm_kcalloc(&pdev->dev,
@@ -188,19 +182,11 @@ static struct hdmi *msm_hdmi_init(struct platform_device *pdev)
 		ret = -ENOMEM;
 		goto fail;
 	}
-	for (i = 0; i < config->pwr_reg_cnt; i++) {
-		struct regulator *reg;
 
-		reg = devm_regulator_get(&pdev->dev,
-				config->pwr_reg_names[i]);
-		if (IS_ERR(reg)) {
-			ret = PTR_ERR(reg);
-			DRM_DEV_ERROR(&pdev->dev, "failed to get pwr regulator: %s (%d)\n",
-					config->pwr_reg_names[i], ret);
-			goto fail;
-		}
-
-		hdmi->pwr_regs[i] = reg;
+	ret = devm_regulator_bulk_get(&pdev->dev, config->pwr_reg_cnt, hdmi->pwr_regs);
+	if (ret) {
+		DRM_DEV_ERROR(&pdev->dev, "failed to get pwr regulator: %d\n", ret);
+		goto fail;
 	}
 
 	hdmi->hpd_clks = devm_kcalloc(&pdev->dev,
diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.h b/drivers/gpu/drm/msm/hdmi/hdmi.h
index 20f554312b17c..a6c88d157bc3a 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.h
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.h
@@ -48,8 +48,8 @@ struct hdmi {
 	void __iomem *qfprom_mmio;
 	phys_addr_t mmio_phy_addr;
 
-	struct regulator **hpd_regs;
-	struct regulator **pwr_regs;
+	struct regulator_bulk_data *hpd_regs;
+	struct regulator_bulk_data *pwr_regs;
 	struct clk **hpd_clks;
 	struct clk **pwr_clks;
 
@@ -161,7 +161,7 @@ struct hdmi_phy {
 	void __iomem *mmio;
 	struct hdmi_phy_cfg *cfg;
 	const struct hdmi_phy_funcs *funcs;
-	struct regulator **regs;
+	struct regulator_bulk_data *regs;
 	struct clk **clks;
 };
 
diff --git a/drivers/gpu/drm/msm/hdmi/hdmi_bridge.c b/drivers/gpu/drm/msm/hdmi/hdmi_bridge.c
index 11b1919e37b1c..dcfefc12385ab 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi_bridge.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi_bridge.c
@@ -27,13 +27,9 @@ static void msm_hdmi_power_on(struct drm_bridge *bridge)
 
 	pm_runtime_get_sync(&hdmi->pdev->dev);
 
-	for (i = 0; i < config->pwr_reg_cnt; i++) {
-		ret = regulator_enable(hdmi->pwr_regs[i]);
-		if (ret) {
-			DRM_DEV_ERROR(dev->dev, "failed to enable pwr regulator: %s (%d)\n",
-					config->pwr_reg_names[i], ret);
-		}
-	}
+	ret = regulator_bulk_enable(config->pwr_reg_cnt, hdmi->pwr_regs);
+	if (ret)
+		DRM_DEV_ERROR(dev->dev, "failed to enable pwr regulator: %d\n", ret);
 
 	if (config->pwr_clk_cnt > 0) {
 		DBG("pixclock: %lu", hdmi->pixclock);
@@ -69,13 +65,9 @@ static void power_off(struct drm_bridge *bridge)
 	for (i = 0; i < config->pwr_clk_cnt; i++)
 		clk_disable_unprepare(hdmi->pwr_clks[i]);
 
-	for (i = 0; i < config->pwr_reg_cnt; i++) {
-		ret = regulator_disable(hdmi->pwr_regs[i]);
-		if (ret) {
-			DRM_DEV_ERROR(dev->dev, "failed to disable pwr regulator: %s (%d)\n",
-					config->pwr_reg_names[i], ret);
-		}
-	}
+	ret = regulator_bulk_disable(config->pwr_reg_cnt, hdmi->pwr_regs);
+	if (ret)
+		DRM_DEV_ERROR(dev->dev, "failed to disable pwr regulator: %d\n", ret);
 
 	pm_runtime_put_autosuspend(&hdmi->pdev->dev);
 }
diff --git a/drivers/gpu/drm/msm/hdmi/hdmi_hpd.c b/drivers/gpu/drm/msm/hdmi/hdmi_hpd.c
index 52ebe562ca9be..68f5254632c37 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi_hpd.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi_hpd.c
@@ -97,16 +97,13 @@ int msm_hdmi_hpd_enable(struct drm_bridge *bridge)
 	const struct hdmi_platform_config *config = hdmi->config;
 	struct device *dev = &hdmi->pdev->dev;
 	uint32_t hpd_ctrl;
-	int i, ret;
+	int ret;
 	unsigned long flags;
 
-	for (i = 0; i < config->hpd_reg_cnt; i++) {
-		ret = regulator_enable(hdmi->hpd_regs[i]);
-		if (ret) {
-			DRM_DEV_ERROR(dev, "failed to enable hpd regulator: %s (%d)\n",
-					config->hpd_reg_names[i], ret);
-			goto fail;
-		}
+	ret = regulator_bulk_enable(config->hpd_reg_cnt, hdmi->hpd_regs);
+	if (ret) {
+		DRM_DEV_ERROR(dev, "failed to enable hpd regulators: %d\n", ret);
+		goto fail;
 	}
 
 	ret = pinctrl_pm_select_default_state(dev);
@@ -155,7 +152,7 @@ void msm_hdmi_hpd_disable(struct hdmi_bridge *hdmi_bridge)
 	struct hdmi *hdmi = hdmi_bridge->hdmi;
 	const struct hdmi_platform_config *config = hdmi->config;
 	struct device *dev = &hdmi->pdev->dev;
-	int i, ret = 0;
+	int ret;
 
 	/* Disable HPD interrupt */
 	hdmi_write(hdmi, REG_HDMI_HPD_INT_CTRL, 0);
@@ -169,12 +166,9 @@ void msm_hdmi_hpd_disable(struct hdmi_bridge *hdmi_bridge)
 	if (ret)
 		dev_warn(dev, "pinctrl state chg failed: %d\n", ret);
 
-	for (i = 0; i < config->hpd_reg_cnt; i++) {
-		ret = regulator_disable(hdmi->hpd_regs[i]);
-		if (ret)
-			dev_warn(dev, "failed to disable hpd regulator: %s (%d)\n",
-					config->hpd_reg_names[i], ret);
-	}
+	ret = regulator_bulk_disable(config->hpd_reg_cnt, hdmi->hpd_regs);
+	if (ret)
+		dev_warn(dev, "failed to disable hpd regulator: %d\n", ret);
 }
 
 void msm_hdmi_hpd_irq(struct drm_bridge *bridge)
diff --git a/drivers/gpu/drm/msm/hdmi/hdmi_phy.c b/drivers/gpu/drm/msm/hdmi/hdmi_phy.c
index cfaf9c26a9054..326b43c803f09 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi_phy.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi_phy.c
@@ -23,22 +23,15 @@ static int msm_hdmi_phy_resource_init(struct hdmi_phy *phy)
 	if (!phy->clks)
 		return -ENOMEM;
 
-	for (i = 0; i < cfg->num_regs; i++) {
-		struct regulator *reg;
-
-		reg = devm_regulator_get(dev, cfg->reg_names[i]);
-		if (IS_ERR(reg)) {
-			ret = PTR_ERR(reg);
-			if (ret != -EPROBE_DEFER) {
-				DRM_DEV_ERROR(dev,
-					      "failed to get phy regulator: %s (%d)\n",
-					      cfg->reg_names[i], ret);
-			}
+	for (i = 0; i < cfg->num_regs; i++)
+		phy->regs[i].supply = cfg->reg_names[i];
 
-			return ret;
-		}
+	ret = devm_regulator_bulk_get(dev, cfg->num_regs, phy->regs);
+	if (ret) {
+		if (ret != -EPROBE_DEFER)
+			DRM_DEV_ERROR(dev, "failed to get phy regulators: %d\n", ret);
 
-		phy->regs[i] = reg;
+		return ret;
 	}
 
 	for (i = 0; i < cfg->num_clks; i++) {
@@ -66,11 +59,10 @@ int msm_hdmi_phy_resource_enable(struct hdmi_phy *phy)
 
 	pm_runtime_get_sync(dev);
 
-	for (i = 0; i < cfg->num_regs; i++) {
-		ret = regulator_enable(phy->regs[i]);
-		if (ret)
-			DRM_DEV_ERROR(dev, "failed to enable regulator: %s (%d)\n",
-				cfg->reg_names[i], ret);
+	ret = regulator_bulk_enable(cfg->num_regs, phy->regs);
+	if (ret) {
+		DRM_DEV_ERROR(dev, "failed to enable regulators: (%d)\n", ret);
+		return ret;
 	}
 
 	for (i = 0; i < cfg->num_clks; i++) {
@@ -92,8 +84,7 @@ void msm_hdmi_phy_resource_disable(struct hdmi_phy *phy)
 	for (i = cfg->num_clks - 1; i >= 0; i--)
 		clk_disable_unprepare(phy->clks[i]);
 
-	for (i = cfg->num_regs - 1; i >= 0; i--)
-		regulator_disable(phy->regs[i]);
+	regulator_bulk_disable(cfg->num_regs, phy->regs);
 
 	pm_runtime_put_sync(dev);
 }
-- 
2.53.0



