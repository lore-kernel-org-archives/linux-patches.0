Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032540;
	b=EaCoPJ8/ZsVmH0TeTfklF4HFv3G4MP2UwmdXiIRXt0aWkx9rh9vKLG31EKryscC2oVlX
	 r6PQq8IA6I7t1G3hE2Ity1fEPp24EjgfkB86zr89pGOzF7r9O3rG6eCTWVxwr47BOZ3kx
	 QiSgVzJtVMfBuevyvCHRNomsVvAxTVA6PivpKN5BPJhodLchrR80Ru6pwqpb5euIGsA7v
	 86xUZZWSBIAhZ7fMBPH+86EjJh0azE1Um2mpBZFJGmMb4usGlxucchXkniWOnojPlUmUA
	 JqVYe1H7JmXZN7dutafSJow/uGEHbUo4yT2hXyKE8t3iJPAsCx4NchW+c8Q79YNh1eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032540;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nHVcbN1WvMdYDlUoHRVTZIRAQxRfvda2EY55Bi6xW/Q=;
	b=CwjtH0Q8lrbDQhqf1x03muNJUaTR9m3BJhLu2airU/AaMI3B5VX4eqmGXMFgUpixJ3GL
	 ZLriu6rDZsCxHkJ3e6F0J/F6JdjinUJM2V2ZiK5B4hYwIGWRW7fkbcPMETmA31E8xOLvq
	 xBVJMeK/0MwisIuPZznSbjkDE3sphi8AjULgadaYqNmtg18y0IHwi5rG+ftjqPJQAaIdV
	 2bsbP5ml0ftcvtmE88wvoMQBbLMM8PLetPFm3CWU7TLdfZBLn+CLOb6bpmlcU6MlDQ1Yw
	 6kBwi02Y+52FyiLpOzsK03lu77ZD+QZ7FwUtW//nHPkeHOtmqPMquMkY63lbl09Bg2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=STXUNE6+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DC3606A31C;
	Wed, 18 Nov 2026 20:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=STXUNE6+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00FD21F000C5;
	Wed, 18 Nov 2026 20:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032539;
	bh=nHVcbN1WvMdYDlUoHRVTZIRAQxRfvda2EY55Bi6xW/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=STXUNE6+PlCtyu3ECCs47zKqp2xL9suBBY+yFEbKbsPrSg9QICB3hT9iwiv2lo1+A
	 44KHilSUOXm+vvAAkV/D9skRXAzuz+TMYKhNJK6evV5hDx/2yU08yjDDr9yKguIR2b
	 xAQ1+di0MLXi/KXZB8zegYCk1wVWw3A4RpjSSFiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Klein <michael@fossekall.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1446/1756] net: phy: realtek: add RTL8211F register defines
Date: Wed, 18 Nov 2026 15:59:33 +0100
Message-ID: <20261118150106.683693793@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Michael Klein <michael@fossekall.de>

[ Upstream commit 12d40df259e38851a0d973535e6023b33e2ea4f9 ]

Add some more defines for RTL8211F page and register numbers.

Signed-off-by: Michael Klein <michael@fossekall.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250504172916.243185-4-michael@fossekall.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 20c0c6773624 ("net: phy: realtek: restore RTL8211F RGMII delays on resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/realtek/realtek_main.c | 34 ++++++++++++++++++--------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/net/phy/realtek/realtek_main.c b/drivers/net/phy/realtek/realtek_main.c
index ac72b12c2922a..8ea6f68795c38 100644
--- a/drivers/net/phy/realtek/realtek_main.c
+++ b/drivers/net/phy/realtek/realtek_main.c
@@ -30,11 +30,14 @@
 #define RTL821x_EXT_PAGE_SELECT			0x1e
 #define RTL821x_PAGE_SELECT			0x1f
 
+/* RTL8211F PHY configuration */
+#define RTL8211F_PHYCR_PAGE			0xa43
 #define RTL8211F_PHYCR1				0x18
 #define RTL8211F_PHYCR2				0x19
 #define RTL8211F_CLKOUT_EN			BIT(0)
 #define RTL8211F_PHYCR2_PHY_EEE_ENABLE		BIT(5)
 
+#define RTL8211F_INSR_PAGE			0xa43
 #define RTL8211F_INSR				0x1d
 
 /* RTL8211F WOL interrupt configuration */
@@ -55,6 +58,8 @@
 #define RTL8211F_PHYSICAL_ADDR_WORD1		17
 #define RTL8211F_PHYSICAL_ADDR_WORD2		18
 
+/* RTL8211F LED configuration */
+#define RTL8211F_LEDCR_PAGE			0xd04
 #define RTL8211F_LEDCR				0x10
 #define RTL8211F_LEDCR_MODE			BIT(15)
 #define RTL8211F_LEDCR_ACT_TXRX			BIT(4)
@@ -64,7 +69,13 @@
 #define RTL8211F_LEDCR_MASK			GENMASK(4, 0)
 #define RTL8211F_LEDCR_SHIFT			5
 
+/* RTL8211F RGMII configuration */
+#define RTL8211F_RGMII_PAGE			0xd08
+
+#define RTL8211F_TXCR				0x11
 #define RTL8211F_TX_DELAY			BIT(8)
+
+#define RTL8211F_RXCR				0x15
 #define RTL8211F_RX_DELAY			BIT(3)
 
 #define RTL8211F_ALDPS_PLL_OFF			BIT(1)
@@ -158,7 +169,7 @@ static int rtl821x_probe(struct phy_device *phydev)
 		return dev_err_probe(dev, PTR_ERR(priv->clk),
 				     "failed to get phy clock\n");
 
-	ret = phy_read_paged(phydev, 0xa43, RTL8211F_PHYCR1);
+	ret = phy_read_paged(phydev, RTL8211F_PHYCR_PAGE, RTL8211F_PHYCR1);
 	if (ret < 0)
 		return ret;
 
@@ -168,7 +179,7 @@ static int rtl821x_probe(struct phy_device *phydev)
 
 	priv->has_phycr2 = !(phy_id == RTL_8211FVD_PHYID);
 	if (priv->has_phycr2) {
-		ret = phy_read_paged(phydev, 0xa43, RTL8211F_PHYCR2);
+		ret = phy_read_paged(phydev, RTL8211F_PHYCR_PAGE, RTL8211F_PHYCR2);
 		if (ret < 0)
 			return ret;
 
@@ -204,7 +215,7 @@ static int rtl8211f_ack_interrupt(struct phy_device *phydev)
 {
 	int err;
 
-	err = phy_read_paged(phydev, 0xa43, RTL8211F_INSR);
+	err = phy_read_paged(phydev, RTL8211F_INSR_PAGE, RTL8211F_INSR);
 
 	return (err < 0) ? err : 0;
 }
@@ -347,7 +358,7 @@ static irqreturn_t rtl8211f_handle_interrupt(struct phy_device *phydev)
 {
 	int irq_status;
 
-	irq_status = phy_read_paged(phydev, 0xa43, RTL8211F_INSR);
+	irq_status = phy_read_paged(phydev, RTL8211F_INSR_PAGE, RTL8211F_INSR);
 	if (irq_status < 0) {
 		phy_error(phydev);
 		return IRQ_NONE;
@@ -444,7 +455,7 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 	u16 val_txdly, val_rxdly;
 	int ret;
 
-	ret = phy_modify_paged_changed(phydev, 0xa43, RTL8211F_PHYCR1,
+	ret = phy_modify_paged_changed(phydev, RTL8211F_PHYCR_PAGE, RTL8211F_PHYCR1,
 				       RTL8211F_ALDPS_PLL_OFF | RTL8211F_ALDPS_ENABLE | RTL8211F_ALDPS_XTAL_OFF,
 				       priv->phycr1);
 	if (ret < 0) {
@@ -478,7 +489,8 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 		return 0;
 	}
 
-	ret = phy_modify_paged_changed(phydev, 0xd08, 0x11, RTL8211F_TX_DELAY,
+	ret = phy_modify_paged_changed(phydev, RTL8211F_RGMII_PAGE,
+				       RTL8211F_TXCR, RTL8211F_TX_DELAY,
 				       val_txdly);
 	if (ret < 0) {
 		dev_err(dev, "Failed to update the TX delay register\n");
@@ -493,7 +505,8 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 			str_enabled_disabled(val_txdly));
 	}
 
-	ret = phy_modify_paged_changed(phydev, 0xd08, 0x15, RTL8211F_RX_DELAY,
+	ret = phy_modify_paged_changed(phydev, RTL8211F_RGMII_PAGE,
+				       RTL8211F_RXCR, RTL8211F_RX_DELAY,
 				       val_rxdly);
 	if (ret < 0) {
 		dev_err(dev, "Failed to update the RX delay register\n");
@@ -509,14 +522,15 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 	}
 
 	/* Disable PHY-mode EEE so LPI is passed to the MAC */
-	ret = phy_modify_paged(phydev, 0xa43, RTL8211F_PHYCR2,
+	ret = phy_modify_paged(phydev, RTL8211F_PHYCR_PAGE, RTL8211F_PHYCR2,
 			       RTL8211F_PHYCR2_PHY_EEE_ENABLE, 0);
 	if (ret)
 		return ret;
 
 	if (priv->has_phycr2) {
-		ret = phy_modify_paged(phydev, 0xa43, RTL8211F_PHYCR2,
-				       RTL8211F_CLKOUT_EN, priv->phycr2);
+		ret = phy_modify_paged(phydev, RTL8211F_PHYCR_PAGE,
+				       RTL8211F_PHYCR2, RTL8211F_CLKOUT_EN,
+				       priv->phycr2);
 		if (ret < 0) {
 			dev_err(dev, "clkout configuration failed: %pe\n",
 				ERR_PTR(ret));
-- 
2.53.0



