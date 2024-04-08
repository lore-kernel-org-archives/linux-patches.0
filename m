Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE24F7B3E5;
	Mon,  8 Apr 2024 13:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582124; cv=none; b=QCgpO+XJ1x3GJ3k+z+DGwmLUJVEALxORcXSzF1yw8+5kAVvxSmdl1NkQwEVTCdWg977S5sCCM9FBiwON6HqMeqxm2Z8bW/h6eLdlnASJdGRxnUjVMQY+aqPzDqtuM/XziTXwY/PRA8UTKFuaJ9FMv2rWYbfrAwT4L4SVGeyPWHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582124; c=relaxed/simple;
	bh=+Qc7XtZpDgOveubuvJSn4arihzMIVGLLvbek/przUKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lddzU9tTMhq5oJh4qNXP70/eqgboUnTEUnpbTAvYNraKMYCkZzWpN8mY3wGyJp2s/M4gUuFFRQ+V5kdqs2kz856TQu1WNUo739TO9KqIJ4wnv4kBggALrUSjkBR3yW3yrUSzH/y/ADPO5lA0elL810ZVPUElrAcdUx7XGxJSIIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ki6pOqfm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ki6pOqfm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D617C43390;
	Mon,  8 Apr 2024 13:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582124;
	bh=+Qc7XtZpDgOveubuvJSn4arihzMIVGLLvbek/przUKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ki6pOqfm9lEbzxWwiVOXgGa6GaDpVXKe7edKVz1CpHtxaS/iu7yD5/dlfVJ7m6muB
	 eUxLav63AyUS5vFc95KIQjVxk7ttzmi4zQ0ZC+xZ3V7zyeWTZIv/eEXhlY5HoRIerV
	 Bj7G5APxhat+/BU5gFiKscv20fZIvC3Sr7byGrew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dennis Kirjanov <dkirjanov@suse.de>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/138] drivers: net: convert to boolean for the mac_managed_pm flag
Date: Mon,  8 Apr 2024 14:58:14 +0200
Message-ID: <20240408125258.714038773@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 97d12c7eea772..51eb30c20c7cf 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2236,7 +2236,7 @@ static int fec_enet_mii_probe(struct net_device *ndev)
 	fep->link = 0;
 	fep->full_duplex = 0;
 
-	phy_dev->mac_managed_pm = 1;
+	phy_dev->mac_managed_pm = true;
 
 	phy_attached_info(phy_dev);
 
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 256630f57ffe1..6e3417712e402 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5148,7 +5148,7 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
 		return -EUNATCH;
 	}
 
-	tp->phydev->mac_managed_pm = 1;
+	tp->phydev->mac_managed_pm = true;
 
 	phy_support_asym_pause(tp->phydev);
 
diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 6eacbf17f1c0c..34cd568b27f19 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -714,7 +714,7 @@ static int ax88772_init_phy(struct usbnet *dev)
 	}
 
 	phy_suspend(priv->phydev);
-	priv->phydev->mac_managed_pm = 1;
+	priv->phydev->mac_managed_pm = true;
 
 	phy_attached_info(priv->phydev);
 
@@ -734,7 +734,7 @@ static int ax88772_init_phy(struct usbnet *dev)
 		return -ENODEV;
 	}
 
-	priv->phydev_int->mac_managed_pm = 1;
+	priv->phydev_int->mac_managed_pm = true;
 	phy_suspend(priv->phydev_int);
 
 	return 0;
-- 
2.43.0



