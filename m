Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025404;
	b=w60EU5xbD4GjLJz0CygueRDHZuKD3U9auIuXNnmS9Y31FvygZ/pLWoP/7VLMgMfpaqq+
	 EejGk56OrP1+j3Xj5KN0CEueNdDdmCrH37JAOjVFTWy/htN6zVrqY42zahgMaQ49+nABR
	 I53mceUvcMU+1cMagNoNJEFI/EK9zUUVgxmFPxdLApV3Et5jGzsZj/BQH50++jWUyc8bL
	 /3zJu54MfI8K4rLWIW8GzzKn5Urzgu5uoqw8y8gE0Hp6Pekm+x7Iwv7CmfYqPJtWIMf8c
	 wNArC4ApJGyExjhmO33/0LAJOyWzyYYbF5Vey5GyJu2Inf3qS2R1KVpv8sJp68pmeFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025404;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ud/pwfGpfcwtcZMKyNPIo8uY9/KflCq4VMAIbAP9ghA=;
	b=iUkdIvsmsiWC0zq0YVXHDULtj/WcTLhhbdket8gl9m3Qwz9q8itqEwISTnzd1yZ4Aw7X
	 eGZAkSNUZBkLSrgS5ivo1aXSj8pPxSeTvwPIcykZmoKns2QoVhaP1A18L0ska0x3ZnubQ
	 BJTBNhc7ZewxSHbh0GsMNOsKt8kle9NhHtTzM63OguXVFcyqHuuRo1e77tYY6Skm14Uo6
	 hzhKWhEwDgtX6RTu5mC3bEoVUfDfRWyD4HOXr+ZYEDVhyz7uzEvC+S9nXcsnpTHDZ4ncP
	 LzzllrG4XqHlolvPGWYeu+sV12rYR8IfPiFL/Nhh2gYr3XhMUdtbqTset4r0E1ILETw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZiSSPrdN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547C6606A31C;
	Wed, 18 Nov 2026 18:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZiSSPrdN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88681F000C4;
	Wed, 18 Nov 2026 18:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025404;
	bh=Ud/pwfGpfcwtcZMKyNPIo8uY9/KflCq4VMAIbAP9ghA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZiSSPrdNWl1yw5u4wQR4mre7Kiz42xPv5I4MjA2bdDb7NxSrqku3ndpjmlbtwrOht
	 VVqNnhfWK9KyC5LnQh7Fx23QN5k77hvega625uWEKPR3Q3ono/4sYEPfZIcCebyZsI
	 fG465cdYb1E98BPGHawnGYMQh5V4aWvgvprk3Adc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aristo Chen <aristo.chen@canonical.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1026/2151] phy: freescale: fsl-samsung-hdmi: initialize default rate
Date: Wed, 18 Nov 2026 15:46:01 +0100
Message-ID: <20261118150159.765948598@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aristo Chen <aristo.chen@canonical.com>

[ Upstream commit c01ccf91b257741e9edc374a465126bae9ae4711 ]

The HDMI PHY clock reports 74.25 MHz when cur_cfg is unset, but does
not establish that rate in hardware. The common clock framework caches
the reported rate when registering the clock and skips a first
clk_set_rate(74250000) request because the rate appears unchanged.

Consequently, a display whose initial mode uses a 74.25 MHz pixel clock
can leave the PHY with its bootloader register state and receive no
TMDS signal. Requesting another rate first avoids the issue because the
set_rate callback configures the PHY.

Program the 74.25 MHz table entry with the reference clock enabled
before registering the clock provider. recalc_rate can then report the
configured rate, and a skipped first rate change is safe. Also enable
the reference clock when restoring that configuration on resume.

Fixes: 6ad082bee902 ("phy: freescale: add Samsung HDMI PHY")
Signed-off-by: Aristo Chen <aristo.chen@canonical.com>
Link: https://patch.msgid.link/20260903054811.9720-1-aristo.chen@canonical.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/freescale/phy-fsl-samsung-hdmi.c | 59 +++++++++++++++-----
 1 file changed, 44 insertions(+), 15 deletions(-)

diff --git a/drivers/phy/freescale/phy-fsl-samsung-hdmi.c b/drivers/phy/freescale/phy-fsl-samsung-hdmi.c
index 191c282246d96..33866f129124c 100644
--- a/drivers/phy/freescale/phy-fsl-samsung-hdmi.c
+++ b/drivers/phy/freescale/phy-fsl-samsung-hdmi.c
@@ -44,6 +44,8 @@
 #define MHZ	(1000UL * 1000UL)
 #endif
 
+#define PHY_DEFAULT_RATE	74250000
+
 #define PHY_PLL_DIV_REGS_NUM 7
 
 struct phy_config {
@@ -489,17 +491,6 @@ static int fsl_samsung_hdmi_phy_configure(struct fsl_samsung_hdmi_phy *phy,
 	return ret;
 }
 
-static unsigned long phy_clk_recalc_rate(struct clk_hw *hw,
-					 unsigned long parent_rate)
-{
-	struct fsl_samsung_hdmi_phy *phy = to_fsl_samsung_hdmi_phy(hw);
-
-	if (!phy->cur_cfg)
-		return 74250000;
-
-	return phy->cur_cfg->pixclk;
-}
-
 /* Helper function to lookup the available fractional-divider rate */
 static const struct phy_config *fsl_samsung_hdmi_phy_lookup_rate(unsigned long rate)
 {
@@ -520,6 +511,14 @@ static const struct phy_config *fsl_samsung_hdmi_phy_lookup_rate(unsigned long r
 		&phy_pll_cfg[i] : &phy_pll_cfg[i+1]);
 }
 
+static unsigned long phy_clk_recalc_rate(struct clk_hw *hw,
+					 unsigned long parent_rate)
+{
+	struct fsl_samsung_hdmi_phy *phy = to_fsl_samsung_hdmi_phy(hw);
+
+	return phy->cur_cfg->pixclk;
+}
+
 static void fsl_samsung_hdmi_calculate_phy(struct phy_config *cal_phy, unsigned long rate,
 				    u8 p, u16 m, u8 s)
 {
@@ -637,6 +636,7 @@ static int phy_clk_register(struct fsl_samsung_hdmi_phy *phy)
 
 static int fsl_samsung_hdmi_phy_probe(struct platform_device *pdev)
 {
+	const struct phy_config *default_cfg;
 	struct fsl_samsung_hdmi_phy *phy;
 	int ret;
 
@@ -661,6 +661,23 @@ static int fsl_samsung_hdmi_phy_probe(struct platform_device *pdev)
 		return dev_err_probe(phy->dev, PTR_ERR(phy->refclk),
 				     "failed to get ref clk\n");
 
+	/*
+	 * Establish the rate reported by recalc_rate() before registering the
+	 * clock. Otherwise CCF may skip the first set_rate() when it requests
+	 * the assumed default rate, leaving the PHY unconfigured.
+	 */
+	ret = clk_prepare_enable(phy->refclk);
+	if (ret)
+		return dev_err_probe(phy->dev, ret,
+				     "failed to enable ref clk\n");
+
+	default_cfg = fsl_samsung_hdmi_phy_lookup_rate(PHY_DEFAULT_RATE);
+	ret = fsl_samsung_hdmi_phy_configure(phy, default_cfg);
+	clk_disable_unprepare(phy->refclk);
+	if (ret)
+		return dev_err_probe(phy->dev, ret,
+				     "failed to configure default rate\n");
+
 	pm_runtime_get_noresume(phy->dev);
 	pm_runtime_set_active(phy->dev);
 	pm_runtime_enable(phy->dev);
@@ -696,7 +713,7 @@ static int __maybe_unused fsl_samsung_hdmi_phy_suspend(struct device *dev)
 static int __maybe_unused fsl_samsung_hdmi_phy_resume(struct device *dev)
 {
 	struct fsl_samsung_hdmi_phy *phy = dev_get_drvdata(dev);
-	int ret = 0;
+	int ret;
 
 	ret = clk_prepare_enable(phy->apbclk);
 	if (ret) {
@@ -704,11 +721,23 @@ static int __maybe_unused fsl_samsung_hdmi_phy_resume(struct device *dev)
 		return ret;
 	}
 
-	if (phy->cur_cfg)
-		ret = fsl_samsung_hdmi_phy_configure(phy, phy->cur_cfg);
+	if (!phy->cur_cfg)
+		return 0;
 
-	return ret;
+	ret = clk_prepare_enable(phy->refclk);
+	if (ret) {
+		dev_err(phy->dev, "failed to enable ref clk\n");
+		goto disable_apbclk;
+	}
+
+	ret = fsl_samsung_hdmi_phy_configure(phy, phy->cur_cfg);
+	clk_disable_unprepare(phy->refclk);
+	if (!ret)
+		return 0;
 
+disable_apbclk:
+	clk_disable_unprepare(phy->apbclk);
+	return ret;
 }
 
 static DEFINE_RUNTIME_DEV_PM_OPS(fsl_samsung_hdmi_phy_pm_ops,
-- 
2.53.0



