Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060041;
	b=UfAWkspIsIza9FMExDZEQoyQZc4ks80gNpAp+WhAJ7Q8qbdd6kkk6njpmmwnsTolUwVp
	 Lp8+1yv0qMQ0/5Oy0HiF+oRgPUp70ipGrniqNhf4bkQNZ4H0HaGGyvQl7fVem0+X2vOMZ
	 S4D1e3VX6+XxCOeDXofslnkwbdQMpag00K2oLvQTrZ9WafCkm3A8qG3NAOH4/cPspVWp8
	 JtbzNmOxpgun29bwFCSMV1VhOtqXmsAg/Tf/PcHWRJku7/lUmw0vaszwGutiSnQTO7wWL
	 MvfMPFCIZluECZT8bN6DbgvfM2a/Zwnr+3vKkPQlFlqljpBY6EMO4QgPIWoNS6sPnCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=++WYrMx0xI6W7KpXdEZWKy0x6ypcqxwmvovIOiTZpgo=;
	b=NGqIw8DYeJ3qJ+GdUmJetkfiAqBHkoHOk1v6yaNJhNh5jC7sl+/dWsbGPcY3QaRmVGNu
	 u6NkN0ef/7U2DFeekEmrUBBPD34FBKY0gJBkUxWOBC+M6NQ7E+/hhb2VROlTgsKSqn0C8
	 8e/W+jmOciis7/mlLip77rEZ+n9lyuRXL3U8g60cBBCywEeIyQWDSL5i/soYqgeyAEMMA
	 NVprr4bR1XbstADAyWOyzvtuiSYalSqmyaBVxAKnx/jxRfFtiZzolv3lx8K8F9L/tTFb9
	 914zaPy6iYwXZCEXjCHCpAL132BYN9S0fBUpUT4nlIa1L12VSTPhCO6qzC+FCxypRcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kxrA1lQb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9AB606A320;
	Thu, 19 Nov 2026 03:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kxrA1lQb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAEDD1F000C7;
	Thu, 19 Nov 2026 03:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060041;
	bh=++WYrMx0xI6W7KpXdEZWKy0x6ypcqxwmvovIOiTZpgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kxrA1lQb1Z1cGa22mtsjG8g1sFjmGq5YAUjOduAK8/Sy0zt64BHockbYdkWCy6VC4
	 aLKol5ErFBKFTt2wcr4HVg7v3f6BDMk91GaRSzZE0adTuTQVyf59HY+hCodjrt0wPP
	 A3aEoACXA1WPO7MySXBc35oHSAVJzyQAZxJF7+kY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1056/1848] drm/msm/hdmi: Handle msm_hdmi_power_on() errors during .atomic_pre_enable()
Date: Wed, 18 Nov 2026 15:51:34 +0100
Message-ID: <20261118150001.628603939@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit dd6ecace57851878e62367a6f1a26dd5b9aa217f ]

Properly handle power up failures during .atomic_pre_enable() by
aborting the .atomic_pre_enable() to avoid accessing registers why
blocks did not bring up.  Otherwise this could lead to imprecise aborts
when accessing MMIO while entire power domain is off.

Cc: <stable@vger.kernel.org>
Fixes: ba3d7bf3a7ab ("drm/msm/hdmi: Convert PHY files according to new design")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/752652/
Link: https://lore.kernel.org/r/20260911-drm-msm-hdmi-fixes-before-eliza-v4-2-87bdb9f1987f@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
[ sashal: adapted error handling to the non-atomic pre_enable callback and regulator/power-clock arrays without state_mutex locking ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/hdmi/hdmi_bridge.c | 30 +++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/msm/hdmi/hdmi_bridge.c b/drivers/gpu/drm/msm/hdmi/hdmi_bridge.c
index dcfefc12385ab..d7dc6cbbea463 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi_bridge.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi_bridge.c
@@ -17,7 +17,7 @@ void msm_hdmi_bridge_destroy(struct drm_bridge *bridge)
 	msm_hdmi_hpd_disable(hdmi_bridge);
 }
 
-static void msm_hdmi_power_on(struct drm_bridge *bridge)
+static int msm_hdmi_power_on(struct drm_bridge *bridge)
 {
 	struct drm_device *dev = bridge->dev;
 	struct hdmi_bridge *hdmi_bridge = to_hdmi_bridge(bridge);
@@ -25,11 +25,15 @@ static void msm_hdmi_power_on(struct drm_bridge *bridge)
 	const struct hdmi_platform_config *config = hdmi->config;
 	int i, ret;
 
-	pm_runtime_get_sync(&hdmi->pdev->dev);
+	ret = pm_runtime_resume_and_get(&hdmi->pdev->dev);
+	if (ret)
+		return ret;
 
 	ret = regulator_bulk_enable(config->pwr_reg_cnt, hdmi->pwr_regs);
-	if (ret)
+	if (ret) {
 		DRM_DEV_ERROR(dev->dev, "failed to enable pwr regulator: %d\n", ret);
+		goto err_pm_put;
+	}
 
 	if (config->pwr_clk_cnt > 0) {
 		DBG("pixclock: %lu", hdmi->pixclock);
@@ -45,8 +49,19 @@ static void msm_hdmi_power_on(struct drm_bridge *bridge)
 		if (ret) {
 			DRM_DEV_ERROR(dev->dev, "failed to enable pwr clk: %s (%d)\n",
 					config->pwr_clk_names[i], ret);
+			goto err_clk_disable;
 		}
 	}
+
+	return 0;
+
+err_clk_disable:
+	while (i--)
+		clk_disable_unprepare(hdmi->pwr_clks[i]);
+	regulator_bulk_disable(config->pwr_reg_cnt, hdmi->pwr_regs);
+err_pm_put:
+	pm_runtime_put(&hdmi->pdev->dev);
+	return ret;
 }
 
 static void power_off(struct drm_bridge *bridge)
@@ -141,8 +156,13 @@ static void msm_hdmi_bridge_pre_enable(struct drm_bridge *bridge)
 	DBG("power up");
 
 	if (!hdmi->power_on) {
-		msm_hdmi_phy_resource_enable(phy);
-		msm_hdmi_power_on(bridge);
+		if (msm_hdmi_phy_resource_enable(phy))
+			return;
+
+		if (msm_hdmi_power_on(bridge)) {
+			msm_hdmi_phy_resource_disable(phy);
+			return;
+		}
 		hdmi->power_on = true;
 		if (hdmi->hdmi_mode) {
 			msm_hdmi_config_avi_infoframe(hdmi);
-- 
2.53.0



