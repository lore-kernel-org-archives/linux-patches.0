Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3E832B99B;
	Mon, 29 Dec 2025 16:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025022; cv=none; b=HVYfTvQYAny+mgz2NB6s5a8ZYLB+W50FcvNaLUBmj6AUcnliDsc1vh3IZE/i0HXHzV4szXhhJQKYmCcadu7R1NDAdQiFojpLA4bg1YdRtQC1VgemNKERA2RjIE8LybdAVgxpQFzPPX381+FiHuicgm0HN7b8sSnRWeQ7pjwmuUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025022; c=relaxed/simple;
	bh=zPVzim21WYHV8n7CJNCftNXvOyZ3v7meoXzquWdYQOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOikyziwnXf9rVyJgKWG0htUQMgbwKsUnuWsWjy6ow3dWU2soM/HuEVlESv1jlGZPODbC5REkZYbmY9eHqdA2Ue7FC4uwEhG1RJQJmU3l3ydjuDwTunMP2e5iGhPM0bd46vIucfg6tb0bl1BS3hYvBAY1mDrzo3k0a/cV/lOxpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1tyU+y2/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1tyU+y2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97934C4CEF7;
	Mon, 29 Dec 2025 16:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025022;
	bh=zPVzim21WYHV8n7CJNCftNXvOyZ3v7meoXzquWdYQOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1tyU+y2/MZF1kixqmDnik018PdK9jPictECIjHGKeq6Lh4LI4HWQ4T6BSPvOMdxq/
	 7kYiXsfWSJ9UsDmkvAiTjov0B8sVEr7wa0MBWG1hmszdy51XoR+oX2tq1M4Czv1Quv
	 iJuTWpu5FUTnNFnPQNOOUE1JpMfuRFvhZS15OXfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 059/430] net: phy: realtek: eliminate has_phycr2 variable
Date: Mon, 29 Dec 2025 17:07:41 +0100
Message-ID: <20251229160726.539750407@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 910ac7bfb1af1ae4cd141ef80e03a6729213c189 ]

This variable is assigned in rtl821x_probe() and used in
rtl8211f_config_init(), which is more complex than it needs to be.
Simply testing the same condition from rtl821x_probe() in
rtl8211f_config_init() yields the same result (the PHY driver ID is a
runtime invariant), but with one temporary variable less.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20251117234033.345679-4-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 4f0638b12451 ("net: phy: RTL8211FVD: Restore disabling of PHY-mode EEE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/realtek/realtek_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/realtek/realtek_main.c b/drivers/net/phy/realtek/realtek_main.c
index 1625919a47be8..daf2457b378bf 100644
--- a/drivers/net/phy/realtek/realtek_main.c
+++ b/drivers/net/phy/realtek/realtek_main.c
@@ -167,7 +167,6 @@ MODULE_LICENSE("GPL");
 
 struct rtl821x_priv {
 	u16 phycr1;
-	bool has_phycr2;
 	bool disable_clk_out;
 	struct clk *clk;
 	/* rtl8211f */
@@ -218,7 +217,6 @@ static int rtl821x_probe(struct phy_device *phydev)
 {
 	struct device *dev = &phydev->mdio.dev;
 	struct rtl821x_priv *priv;
-	u32 phy_id = phydev->drv->phy_id;
 	int ret;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
@@ -238,7 +236,6 @@ static int rtl821x_probe(struct phy_device *phydev)
 	if (of_property_read_bool(dev->of_node, "realtek,aldps-enable"))
 		priv->phycr1 |= RTL8211F_ALDPS_PLL_OFF | RTL8211F_ALDPS_ENABLE | RTL8211F_ALDPS_XTAL_OFF;
 
-	priv->has_phycr2 = !(phy_id == RTL_8211FVD_PHYID);
 	priv->disable_clk_out = of_property_read_bool(dev->of_node,
 						      "realtek,clkout-disable");
 
@@ -656,7 +653,8 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 	if (ret)
 		return ret;
 
-	if (!priv->has_phycr2)
+	/* RTL8211FVD has no PHYCR2 register */
+	if (phydev->drv->phy_id == RTL_8211FVD_PHYID)
 		return 0;
 
 	/* Disable PHY-mode EEE so LPI is passed to the MAC */
-- 
2.51.0



