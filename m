Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF7B7FBCF;
	Mon,  8 Apr 2024 14:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585101; cv=none; b=aGZsFdgT0+JxofRxjl6b3MSrlg5gfWupXXlePun6roCfjKxc//DGm5epAlJts2iZdsD6a87Xbg+ULh5HSiBBtgL65Flt1yX76qaaccQ2B8O9QqQw2ObsS7Jt/vUaC9NTypjVAH2se0KJXobciglUEsMU2jeuPO40Uh8VlgMVH7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585101; c=relaxed/simple;
	bh=31SwdHWZufX3i+XuLQrSZF59EKGxOxN1nbTJQwNVEFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SAMvbciJ4o9Nh21kwZoVjshs3j8gg/zf/oDrxPT9kQKSi2Y4cRcH8s8PyHe/N+FKedx//3iIL2QsVRN2CH1K0feuDl3n0/ccKpF4g1CWzEXlgrGupPv/beaBEPvZ/Xw1P3Rl8AIdwxJzI2UCDBzSv5wz/v4nELLDU034YceGJ8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kq8y4jZu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kq8y4jZu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 217E7C43390;
	Mon,  8 Apr 2024 14:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585101;
	bh=31SwdHWZufX3i+XuLQrSZF59EKGxOxN1nbTJQwNVEFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kq8y4jZudrdPDWmXyuQXx90+aDXQ/64Tz6afqCN1D6gd8NExWeIBDxGdk96iteoFO
	 oQj5BfFNScNPGUo3WLTgrHX4Vig/xS3f9tGGqwxhiGKdZbNf/uUv8E7gE0e2CWkbjU
	 rs5qDqYM8jcdTwhEL/F9xA1eKG+kAW6nuYskKaD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dennis Kirjanov <dkirjanov@suse.de>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 664/690] drivers: net: convert to boolean for the mac_managed_pm flag
Date: Mon,  8 Apr 2024 14:58:50 +0200
Message-ID: <20240408125423.736953092@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Kirjanov <dkirjanov@suse.de>

[ Upstream commit eca485d22165695587bed02d8b9d0f7f44246c4a ]

Signed-off-by: Dennis Kirjanov <dkirjanov@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: cbc17e7802f5 ("net: fec: Set mac_managed_pm during probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 2 +-
 drivers/net/ethernet/realtek/r8169_main.c | 2 +-
 drivers/net/usb/asix_devices.c            | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 39875ccbaa0fc..6662c0013959e 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2132,7 +2132,7 @@ static int fec_enet_mii_probe(struct net_device *ndev)
 	fep->link = 0;
 	fep->full_duplex = 0;
 
-	phy_dev->mac_managed_pm = 1;
+	phy_dev->mac_managed_pm = true;
 
 	phy_attached_info(phy_dev);
 
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index e7e805a152631..623286f221054 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5177,7 +5177,7 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
 		return -EUNATCH;
 	}
 
-	tp->phydev->mac_managed_pm = 1;
+	tp->phydev->mac_managed_pm = true;
 
 	phy_support_asym_pause(tp->phydev);
 
diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 254637c2b1830..5a4137b2531f1 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -694,7 +694,7 @@ static int ax88772_init_phy(struct usbnet *dev)
 	}
 
 	phy_suspend(priv->phydev);
-	priv->phydev->mac_managed_pm = 1;
+	priv->phydev->mac_managed_pm = true;
 
 	phy_attached_info(priv->phydev);
 
@@ -711,7 +711,7 @@ static int ax88772_init_phy(struct usbnet *dev)
 		return -ENODEV;
 	}
 
-	priv->phydev_int->mac_managed_pm = 1;
+	priv->phydev_int->mac_managed_pm = true;
 	phy_suspend(priv->phydev_int);
 
 	return 0;
-- 
2.43.0



