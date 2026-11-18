Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032545;
	b=vlkZW6oaSCtFOmX4IbgT/C3zGna461bSqf0xJsMhcJZU8BlMDfAXT5ZZtOASd1HBfTiC
	 0S1/X4kKs7yKm9iL0LgMJJKWFtghBMmgTyMm2E7mX+VqzlsiS9zxbke7URckZ/0o+ZmHF
	 I58uu9YT2MoLuFwZtFQWrq6qywtr+PZVCf/VgqfhY9rDVlEVquiZUnu/MlABA/w0PNv2u
	 kroK7dyCOm1Z8Ikvb0ls6pDMfRKC9EwVANwMRX6w7qPMGKLgBS06SGUp2fGps7h49HlKl
	 F3yLy/bCpr4bpTOdnipgzvzBoPmkkH1ExrQs0xUz3OKVxCzy2RAE0nkrRkOsFb097vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032545;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FPg+rjbSbJRryC2C1CiekFyA+yMwhUYS6LhXhYrzZ48=;
	b=mV3xh3EkidWVOVfmVEdBz7jnarEI/biTu758EZkuyx69Sn/WvdsWyZEa3B1Rmy9qYwsb
	 suJCygs6mMguel3VgxJw7jylmkYZAIoNYfRAg/o1NdCzBGDJ1AeWOTZ+uJSr07W7Y16qQ
	 xrgI9w9eSow9502TsmtQW1RvOGvn9BJ4BmjZrLLa1olltJjrJo/XlzxmWCMFRH+DQBFfk
	 YGYjBO7mWlyWkaJbYYsfyhcKCEW7eysG8cKfsVpxoOQ7nayeoQoPX9noWPzx9o/7H4xbP
	 7tZkvDJ5ADFfvkByRIOOyNjMxrS30G7/rl94uBZUG6SLKv/5zCLZbqCdEUyAChschYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lm3diWYH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E764606A330;
	Wed, 18 Nov 2026 20:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lm3diWYH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4D51F000C5;
	Wed, 18 Nov 2026 20:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032545;
	bh=FPg+rjbSbJRryC2C1CiekFyA+yMwhUYS6LhXhYrzZ48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lm3diWYHr8mdAVc/UY3dlcDUTlRoq/6xv8ZxRdlFzNVIb+F9lYibqpuCb+yl/lADe
	 zlLtEuhDJMi6LYJY0NWzJXh8gcWjaUVVqtSh6fJmkIOYrscprWRLrzZ+4cvccpoF8Q
	 kcwBBW6jx9+hbngfkGWm521i8CaVLqWuSG5x8qj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1448/1756] net: phy: realtek: create rtl8211f_config_rgmii_delay()
Date: Wed, 18 Nov 2026 15:59:35 +0100
Message-ID: <20261118150106.756412621@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 8e982441ba601d982dd0739972115d85ae01d99b ]

The control flow in rtl8211f_config_init() has some pitfalls which were
probably unintended. Specifically it has an early return:

	switch (phydev->interface) {
	...
	default: /* the rest of the modes imply leaving delay as is. */
		return 0;
	}

which exits the entire config_init() function. This means it also skips
doing things such as disabling CLKOUT or disabling PHY-mode EEE.

For the RTL8211FS, which uses PHY_INTERFACE_MODE_SGMII, this might be a
problem. However, I don't know that it is, so there is no Fixes: tag.
The issue was observed through code inspection.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20251117234033.345679-2-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 20c0c6773624 ("net: phy: realtek: restore RTL8211F RGMII delays on resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/realtek/realtek_main.c | 65 +++++++++++++++-----------
 1 file changed, 39 insertions(+), 26 deletions(-)

diff --git a/drivers/net/phy/realtek/realtek_main.c b/drivers/net/phy/realtek/realtek_main.c
index 613c3df083414..72afa280c939f 100644
--- a/drivers/net/phy/realtek/realtek_main.c
+++ b/drivers/net/phy/realtek/realtek_main.c
@@ -448,22 +448,11 @@ static int rtl8211c_config_init(struct phy_device *phydev)
 			    CTL1000_ENABLE_MASTER | CTL1000_AS_MASTER);
 }
 
-static int rtl8211f_config_init(struct phy_device *phydev)
+static int rtl8211f_config_rgmii_delay(struct phy_device *phydev)
 {
-	struct rtl821x_priv *priv = phydev->priv;
-	struct device *dev = &phydev->mdio.dev;
 	u16 val_txdly, val_rxdly;
 	int ret;
 
-	ret = phy_modify_paged_changed(phydev, RTL8211F_PHYCR_PAGE, RTL8211F_PHYCR1,
-				       RTL8211F_ALDPS_PLL_OFF | RTL8211F_ALDPS_ENABLE | RTL8211F_ALDPS_XTAL_OFF,
-				       priv->phycr1);
-	if (ret < 0) {
-		dev_err(dev, "aldps mode  configuration failed: %pe\n",
-			ERR_PTR(ret));
-		return ret;
-	}
-
 	switch (phydev->interface) {
 	case PHY_INTERFACE_MODE_RGMII:
 		val_txdly = 0;
@@ -493,34 +482,58 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 				       RTL8211F_TXCR, RTL8211F_TX_DELAY,
 				       val_txdly);
 	if (ret < 0) {
-		dev_err(dev, "Failed to update the TX delay register\n");
+		phydev_err(phydev, "Failed to update the TX delay register: %pe\n",
+			   ERR_PTR(ret));
 		return ret;
 	} else if (ret) {
-		dev_dbg(dev,
-			"%s 2ns TX delay (and changing the value from pin-strapping RXD1 or the bootloader)\n",
-			str_enable_disable(val_txdly));
+		phydev_dbg(phydev,
+			   "%s 2ns TX delay (and changing the value from pin-strapping RXD1 or the bootloader)\n",
+			   str_enable_disable(val_txdly));
 	} else {
-		dev_dbg(dev,
-			"2ns TX delay was already %s (by pin-strapping RXD1 or bootloader configuration)\n",
-			str_enabled_disabled(val_txdly));
+		phydev_dbg(phydev,
+			   "2ns TX delay was already %s (by pin-strapping RXD1 or bootloader configuration)\n",
+			   str_enabled_disabled(val_txdly));
 	}
 
 	ret = phy_modify_paged_changed(phydev, RTL8211F_RGMII_PAGE,
 				       RTL8211F_RXCR, RTL8211F_RX_DELAY,
 				       val_rxdly);
 	if (ret < 0) {
-		dev_err(dev, "Failed to update the RX delay register\n");
+		phydev_err(phydev, "Failed to update the RX delay register: %pe\n",
+			   ERR_PTR(ret));
 		return ret;
 	} else if (ret) {
-		dev_dbg(dev,
-			"%s 2ns RX delay (and changing the value from pin-strapping RXD0 or the bootloader)\n",
-			str_enable_disable(val_rxdly));
+		phydev_dbg(phydev,
+			   "%s 2ns RX delay (and changing the value from pin-strapping RXD0 or the bootloader)\n",
+			   str_enable_disable(val_rxdly));
 	} else {
-		dev_dbg(dev,
-			"2ns RX delay was already %s (by pin-strapping RXD0 or bootloader configuration)\n",
-			str_enabled_disabled(val_rxdly));
+		phydev_dbg(phydev,
+			   "2ns RX delay was already %s (by pin-strapping RXD0 or bootloader configuration)\n",
+			   str_enabled_disabled(val_rxdly));
 	}
 
+	return 0;
+}
+
+static int rtl8211f_config_init(struct phy_device *phydev)
+{
+	struct rtl821x_priv *priv = phydev->priv;
+	struct device *dev = &phydev->mdio.dev;
+	int ret;
+
+	ret = phy_modify_paged_changed(phydev, RTL8211F_PHYCR_PAGE, RTL8211F_PHYCR1,
+				       RTL8211F_ALDPS_PLL_OFF | RTL8211F_ALDPS_ENABLE | RTL8211F_ALDPS_XTAL_OFF,
+				       priv->phycr1);
+	if (ret < 0) {
+		dev_err(dev, "aldps mode  configuration failed: %pe\n",
+			ERR_PTR(ret));
+		return ret;
+	}
+
+	ret = rtl8211f_config_rgmii_delay(phydev);
+	if (ret)
+		return ret;
+
 	if (!priv->has_phycr2)
 		return 0;
 
-- 
2.53.0



