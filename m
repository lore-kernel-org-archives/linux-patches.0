Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032542;
	b=nS4BN08TTKM7KdGWeJUM+LhJcuLYhbD/WU2eO9LwVFtO2DQkjHZEah+VNbCm23wmAZ00
	 whUAv46g5ScwCNa5Q9xaZxVQsMZcRZtsgU5ql37mKfKbILO0ra0FbLqqpXR6lHd+lqOTb
	 vKH2TY300pzkvOUesS70+ttyRsr5oB/dOPuRodBa2mxVzKKcRPM0JvZLgmIUE3/uT4eWR
	 8CCaI+VM4QOcqD02MDtEbo8I0uJfDuGoM2TZkEryb+OjiABueexrnggR0qXVrEFgzCrrk
	 iFXuRW4BnCsk9nEhaoUZ0HWqJCoOUjZ8bUWtO+AUpjoYBRAe4mFE16qBqlBEs66SIUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032542;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DPz7j/IV5zHZdvIcEo6cluf1j3Gph4d1atbzQ94s9TE=;
	b=EqRyZU8mRCz/r6mOPElamKDJrbG1rv9CLne0vx07jp5PIQqHtSGW81LCNndTXXT144St
	 fL5D7VlXhRCK95G1/cRTFPIcdecz32vPFkI9m1QuWAre6fqcPrswsSoo/aWLFoJkDK36N
	 X3b+FG0lyOxTo93t5kPdzn7xQ+HcAtu6Gh2DWituQq5gk16KQfunkTCiMeoWdGoofUdSk
	 qwflxPWcxl7GVZ9x+SMY40dJkA8GZ2EQjSgC5XI9pAeFw5ydFh1QiP3p4Ip5GbU4OrGNH
	 oboDQ4rLXghVG3gNn5imqUnlweYhPqcDw6FA91SOjCrvADmSn1/014n4BzLU2WkJ20Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ameVLq5o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D82606A31C;
	Wed, 18 Nov 2026 20:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ameVLq5o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42541F000C4;
	Wed, 18 Nov 2026 20:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032542;
	bh=DPz7j/IV5zHZdvIcEo6cluf1j3Gph4d1atbzQ94s9TE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ameVLq5oiwRl9nFV3ldT6Bp8XkYzT6YMPFs7TiOFy1Cf4RDOoIsxw1g/BSFzQ+rDI
	 IQcjiW7G6E2oSd2JRt65aLGsPa4ud+2+nmooP2AMGZ/+7EJ8CzgeKHuX5oVvGkSf4a
	 5D0MR+JdgpfYQoD/g+deLabzIqHqyY5FyEOhMNws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut@mailbox.org>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1447/1756] net: phy: realtek: Avoid PHYCR2 access if PHYCR2 not present
Date: Wed, 18 Nov 2026 15:59:34 +0100
Message-ID: <20261118150106.719109738@linuxfoundation.org>
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

From: Marek Vasut <marek.vasut@mailbox.org>

[ Upstream commit 2c67301584f2671e320236df6bbe75ae09feb4d0 ]

The driver is currently checking for PHYCR2 register presence in
rtl8211f_config_init(), but it does so after accessing PHYCR2 to
disable EEE. This was introduced in commit bfc17c165835 ("net:
phy: realtek: disable PHY-mode EEE"). Move the PHYCR2 presence
test before the EEE disablement and simplify the code.

Fixes: bfc17c165835 ("net: phy: realtek: disable PHY-mode EEE")
Signed-off-by: Marek Vasut <marek.vasut@mailbox.org>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/20251011110309.12664-1-marek.vasut@mailbox.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 20c0c6773624 ("net: phy: realtek: restore RTL8211F RGMII delays on resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/realtek/realtek_main.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/realtek/realtek_main.c b/drivers/net/phy/realtek/realtek_main.c
index 8ea6f68795c38..613c3df083414 100644
--- a/drivers/net/phy/realtek/realtek_main.c
+++ b/drivers/net/phy/realtek/realtek_main.c
@@ -521,26 +521,25 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 			str_enabled_disabled(val_rxdly));
 	}
 
+	if (!priv->has_phycr2)
+		return 0;
+
 	/* Disable PHY-mode EEE so LPI is passed to the MAC */
 	ret = phy_modify_paged(phydev, RTL8211F_PHYCR_PAGE, RTL8211F_PHYCR2,
 			       RTL8211F_PHYCR2_PHY_EEE_ENABLE, 0);
 	if (ret)
 		return ret;
 
-	if (priv->has_phycr2) {
-		ret = phy_modify_paged(phydev, RTL8211F_PHYCR_PAGE,
-				       RTL8211F_PHYCR2, RTL8211F_CLKOUT_EN,
-				       priv->phycr2);
-		if (ret < 0) {
-			dev_err(dev, "clkout configuration failed: %pe\n",
-				ERR_PTR(ret));
-			return ret;
-		}
-
-		return genphy_soft_reset(phydev);
+	ret = phy_modify_paged(phydev, RTL8211F_PHYCR_PAGE,
+			       RTL8211F_PHYCR2, RTL8211F_CLKOUT_EN,
+			       priv->phycr2);
+	if (ret < 0) {
+		dev_err(dev, "clkout configuration failed: %pe\n",
+			ERR_PTR(ret));
+		return ret;
 	}
 
-	return 0;
+	return genphy_soft_reset(phydev);
 }
 
 static int rtl821x_suspend(struct phy_device *phydev)
-- 
2.53.0



