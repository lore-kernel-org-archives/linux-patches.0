Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032535;
	b=hr99fvYoAllqceTy4EeR+y6LCkxGZrlfnfHe/KwYTFML17UNf1QAT96CPugcyVGzhacy
	 EsxXWlobagfhsLegSLZB5Ufx7B/N+lXJUSsNUz9kvapH+WNX8dEEWTp3f28WUinxJLxBp
	 DjLO2iCWqxf6nlSX5j5Ho60GZ0hIupErTkKzw6BtlKfYAWAF/MokjWbF8wr0Bgwz2BHU9
	 nWcyUzOHs3kW71oSL8jK1d7KlunzJU58PWzz9m7a9A3vly4tktDMK57CxfGZpSVWJJcTc
	 D6lWWbsb21FIVXVt7OUKE3vawtfYjfmPPzF5DVM4GOqyKqD0Ch9GHBCkFLmlqg41KSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032535;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xRg4Zk1l8KdKPTZwUWdeuvey/ZXuzuSNhXhubUGojJA=;
	b=UIKsnKq5+7eBPYIG/E8x2uSOxgJLu7vy/5jR6GLSbtx9DoUoYXtuwW2C3fjjzkDVZfCV
	 oM0GSKjQbrxJVJ4NYXfjVoq+pnEzFft/62J4PZ9iKYbcnpxoz9MlaUEBOjBs0nasfrWvf
	 LjCvD6IDSgXnXzE3ZV/TUXvnEej0jSOL8ZbA7F+h90/172lj+S7YRJ53JzR2IQ2e1UH2s
	 rx0VbFWw4uUvoRQrxGSndlz8eDBdklRNX2ipDTQLplR0zUaIhLvrGAH/YGlcDja0HZFXf
	 fHCmL+MjwloSeRlPviUJK8u9M4xSvzLVRNyjmsscB7yIVdxfZsxinLo2B9wDhfoTRZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ik4MYb5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF34C60A260A;
	Wed, 18 Nov 2026 20:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ik4MYb5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE761F000C4;
	Wed, 18 Nov 2026 20:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032535;
	bh=xRg4Zk1l8KdKPTZwUWdeuvey/ZXuzuSNhXhubUGojJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ik4MYb5EF2yy8MBKj3F2H/QC6lqcA0wwRXt6zMSuWLSdwaRkCTACRvAjQF0v6gdb
	 D1vbjLswuxK3VlvU4jnLwUm3m4KTllW+NNqxJa8PnETJZsir/P92UJuZaAy56Zcoq2
	 Z3hxPuIiw2sDIigvAyS1P2UZluwl+KywS8RhoPGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Braunwarth <daniel.braunwarth@kuka.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1445/1756] net: phy: realtek: Add support for WOL magic packet on RTL8211F
Date: Wed, 18 Nov 2026 15:59:32 +0100
Message-ID: <20261118150106.650453279@linuxfoundation.org>
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

From: Daniel Braunwarth <daniel.braunwarth@kuka.com>

[ Upstream commit 7840e4d6f48a75413470935ebdc4bab4fc0c035e ]

The RTL8211F supports multiple WOL modes. This patch adds support for
magic packets.

The PHY notifies the system via the INTB/PMEB pin when a WOL event
occurs.

Signed-off-by: Daniel Braunwarth <daniel.braunwarth@kuka.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250429-realtek_wol-v2-1-8f84def1ef2c@kuka.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 20c0c6773624 ("net: phy: realtek: restore RTL8211F RGMII delays on resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/realtek/realtek_main.c | 69 ++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/drivers/net/phy/realtek/realtek_main.c b/drivers/net/phy/realtek/realtek_main.c
index 33eb91dd34fbc..ac72b12c2922a 100644
--- a/drivers/net/phy/realtek/realtek_main.c
+++ b/drivers/net/phy/realtek/realtek_main.c
@@ -10,6 +10,7 @@
 #include <linux/bitops.h>
 #include <linux/of.h>
 #include <linux/phy.h>
+#include <linux/netdevice.h>
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/clk.h>
@@ -36,6 +37,24 @@
 
 #define RTL8211F_INSR				0x1d
 
+/* RTL8211F WOL interrupt configuration */
+#define RTL8211F_INTBCR_PAGE			0xd40
+#define RTL8211F_INTBCR				0x16
+#define RTL8211F_INTBCR_INTB_PMEB		BIT(5)
+
+/* RTL8211F WOL settings */
+#define RTL8211F_WOL_SETTINGS_PAGE		0xd8a
+#define RTL8211F_WOL_SETTINGS_EVENTS		16
+#define RTL8211F_WOL_EVENT_MAGIC		BIT(12)
+#define RTL8211F_WOL_SETTINGS_STATUS		17
+#define RTL8211F_WOL_STATUS_RESET		(BIT(15) | 0x1fff)
+
+/* RTL8211F Unique phyiscal and multicast address (WOL) */
+#define RTL8211F_PHYSICAL_ADDR_PAGE		0xd8c
+#define RTL8211F_PHYSICAL_ADDR_WORD0		16
+#define RTL8211F_PHYSICAL_ADDR_WORD1		17
+#define RTL8211F_PHYSICAL_ADDR_WORD2		18
+
 #define RTL8211F_LEDCR				0x10
 #define RTL8211F_LEDCR_MODE			BIT(15)
 #define RTL8211F_LEDCR_ACT_TXRX			BIT(4)
@@ -110,6 +129,7 @@ struct rtl821x_priv {
 	u16 phycr2;
 	bool has_phycr2;
 	struct clk *clk;
+	u32 saved_wolopts;
 };
 
 static int rtl821x_read_page(struct phy_device *phydev)
@@ -341,6 +361,53 @@ static irqreturn_t rtl8211f_handle_interrupt(struct phy_device *phydev)
 	return IRQ_HANDLED;
 }
 
+static void rtl8211f_get_wol(struct phy_device *dev, struct ethtool_wolinfo *wol)
+{
+	wol->supported = WAKE_MAGIC;
+	if (phy_read_paged(dev, RTL8211F_WOL_SETTINGS_PAGE, RTL8211F_WOL_SETTINGS_EVENTS)
+	    & RTL8211F_WOL_EVENT_MAGIC)
+		wol->wolopts = WAKE_MAGIC;
+}
+
+static int rtl8211f_set_wol(struct phy_device *dev, struct ethtool_wolinfo *wol)
+{
+	const u8 *mac_addr = dev->attached_dev->dev_addr;
+	int oldpage;
+
+	oldpage = phy_save_page(dev);
+	if (oldpage < 0)
+		goto err;
+
+	if (wol->wolopts & WAKE_MAGIC) {
+		/* Store the device address for the magic packet */
+		rtl821x_write_page(dev, RTL8211F_PHYSICAL_ADDR_PAGE);
+		__phy_write(dev, RTL8211F_PHYSICAL_ADDR_WORD0, mac_addr[1] << 8 | (mac_addr[0]));
+		__phy_write(dev, RTL8211F_PHYSICAL_ADDR_WORD1, mac_addr[3] << 8 | (mac_addr[2]));
+		__phy_write(dev, RTL8211F_PHYSICAL_ADDR_WORD2, mac_addr[5] << 8 | (mac_addr[4]));
+
+		/* Enable magic packet matching and reset WOL status */
+		rtl821x_write_page(dev, RTL8211F_WOL_SETTINGS_PAGE);
+		__phy_write(dev, RTL8211F_WOL_SETTINGS_EVENTS, RTL8211F_WOL_EVENT_MAGIC);
+		__phy_write(dev, RTL8211F_WOL_SETTINGS_STATUS, RTL8211F_WOL_STATUS_RESET);
+
+		/* Enable the WOL interrupt */
+		rtl821x_write_page(dev, RTL8211F_INTBCR_PAGE);
+		__phy_set_bits(dev, RTL8211F_INTBCR, RTL8211F_INTBCR_INTB_PMEB);
+	} else {
+		/* Disable the WOL interrupt */
+		rtl821x_write_page(dev, RTL8211F_INTBCR_PAGE);
+		__phy_clear_bits(dev, RTL8211F_INTBCR, RTL8211F_INTBCR_INTB_PMEB);
+
+		/* Disable magic packet matching and reset WOL status */
+		rtl821x_write_page(dev, RTL8211F_WOL_SETTINGS_PAGE);
+		__phy_write(dev, RTL8211F_WOL_SETTINGS_EVENTS, 0);
+		__phy_write(dev, RTL8211F_WOL_SETTINGS_STATUS, RTL8211F_WOL_STATUS_RESET);
+	}
+
+err:
+	return phy_restore_page(dev, oldpage, 0);
+}
+
 static int rtl8211_config_aneg(struct phy_device *phydev)
 {
 	int ret;
@@ -1349,6 +1416,8 @@ static struct phy_driver realtek_drvs[] = {
 		.read_status	= rtlgen_read_status,
 		.config_intr	= &rtl8211f_config_intr,
 		.handle_interrupt = rtl8211f_handle_interrupt,
+		.set_wol	= rtl8211f_set_wol,
+		.get_wol	= rtl8211f_get_wol,
 		.suspend	= rtl821x_suspend,
 		.resume		= rtl821x_resume,
 		.read_page	= rtl821x_read_page,
-- 
2.53.0



