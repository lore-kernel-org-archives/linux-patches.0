Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018432;
	b=wD2uuWqwEiDsNSdMgxnssqQTandYoH1qbAFvGdmO9yUGDfPcv2wOr1ocn98c18W22KgF
	 QpOuaqgutIUjZzHHqC3bUQNrMbOUY147V221BxPJb03MTOR0kvaYs1q4hAPmS0N/1kqLE
	 qWi5pQWsxot380iIO69g4K9wk8SuTSat70JmpFo/06o6hzm27TcpdtGFhR/ZPKPEzChRG
	 RmeOlHXNhWA8iD1aAQqbTUdpIVlHvi9vDlDDC+Cs2EHx+6uuuc9ccyP4wnMeFKrZFYgMT
	 250t+6cJ4BirtxsYN0EI+vym2O9MQm/qkVmOYuPfJ+mGNxoOVzTp2dyeKMGWfu4CTVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018432;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zp5K6sbFkYZQVlGq6K3mPZbq45WrMpPsT8gZr1OMtrw=;
	b=U8MrWFsMKUfEZ8N6HmoMAof2IjpjPWB7NiO9a3ehse7YwaIMvqvJl3y6MX43I/RQqlp0
	 DPww2vlCDP9OOPoWMctWjURN1gjEHFGI9Rypg552dnqTBaOzyxl0xtEa6XOL52/8jY1xl
	 QY7qdyrtbBxiObwlsmm/kMimWEyCNnfG5w+G9magd0rAe/p9rHvBRIOxRprqFwkTa1Bpd
	 i5lBfa/JcHb4CBUxVneVp//DIPCMGuhy9BgyiqNMkHzPHjdHdNynSLgrHkkq43urVOqWc
	 +QvbIdFlMJ41GNmaiMZws01MSJG9EvVfqUvEJVz36pPGrendBXQ/JqgmUmL04cU//Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aS0b7Fws;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B26C606A325;
	Wed, 18 Nov 2026 16:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aS0b7Fws
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9951F000C4;
	Wed, 18 Nov 2026 16:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018432;
	bh=Zp5K6sbFkYZQVlGq6K3mPZbq45WrMpPsT8gZr1OMtrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aS0b7FwsgyAgYPlZ8QHqDbkgTcNNYBxwF7kJekpomsmr1YBGGNniNvJTpXUY5tZbH
	 u+x3OgPl53Ygi8m9JJF52ck0R5drRj6ERtp2Obd7QObSiHpmWvxonlO6aord8nXShC
	 OsmqLG57XRdwB+lPcrXRpLGPCRnHncUQPS2+EJy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aristo Chen <aristo.chen@canonical.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1238/2651] phy: freescale: fsl-samsung-hdmi: initialize default rate
Date: Wed, 18 Nov 2026 15:41:18 +0100
Message-ID: <20261118150332.571312313@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 0f25d81de61bb..41addd4ad4149 100644
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
@@ -640,6 +639,7 @@ static int phy_clk_register(struct fsl_samsung_hdmi_phy *phy)
 
 static int fsl_samsung_hdmi_phy_probe(struct platform_device *pdev)
 {
+	const struct phy_config *default_cfg;
 	struct fsl_samsung_hdmi_phy *phy;
 	int ret;
 
@@ -664,6 +664,23 @@ static int fsl_samsung_hdmi_phy_probe(struct platform_device *pdev)
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
@@ -702,7 +719,7 @@ static int __maybe_unused fsl_samsung_hdmi_phy_suspend(struct device *dev)
 static int __maybe_unused fsl_samsung_hdmi_phy_resume(struct device *dev)
 {
 	struct fsl_samsung_hdmi_phy *phy = dev_get_drvdata(dev);
-	int ret = 0;
+	int ret;
 
 	ret = clk_prepare_enable(phy->apbclk);
 	if (ret) {
@@ -710,11 +727,23 @@ static int __maybe_unused fsl_samsung_hdmi_phy_resume(struct device *dev)
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



