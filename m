Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B727818873F;
	Fri, 15 Nov 2024 06:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653719; cv=none; b=eVQxXjKqHNyIjxkRq0H7nSxLXDQHdQYk+5S+hgMYaFE5O+ZJ8njZf4eZWT2yBW4Yy2QiTKkpcLBdT27oX+d01AQRQTvN2+JqkGDYZPOGU8AIWKGLmOt6o9MoRSIkG0DO6YUff8LRyu474HvFXYZ4/RQV7DjCoPslmXhWQnU3nkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653719; c=relaxed/simple;
	bh=wZvdsX5+m1ZcDBdhGUO3HYnWdveM/2AVsZKUu27+IvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qYg/jgq26LSUqE+KFvKMulojX0ZavNCvEUabyLIjLwho9YDqewQZjFa5SAhl8X0tIZvyEYmYfeuhOYmcLKjg3kFk5Jz2Bdslhfe5gZZdhOT8IAy3RNwKiuJ/6NPZ/KtaFJaW69Jy9EsFWDhkED7+sI0FjLAUWvfN6GetNiiFvis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HCmuTGmu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HCmuTGmu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B431FC4CECF;
	Fri, 15 Nov 2024 06:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653719;
	bh=wZvdsX5+m1ZcDBdhGUO3HYnWdveM/2AVsZKUu27+IvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HCmuTGmutQ2l4LIM3EwCdUG6QZAq+d8LmbOoHWF1dpbP3h6AEjkTdSMRFSRokHCXP
	 x4aG874oi39G2kgN2WazzmUXl57zAtqRhYnyNZ18b3F9ewj7CcN9U4CSUhYfpo/Shq
	 qYBJAZ4fAMoPvPbaaDszO9ZPdh1UnJgZ5xKpw4ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandru Ardelean <alexandru.ardelean@analog.com>,
	Andre Edich <andre.edich@microchip.com>,
	Antoine Tenart <atenart@kernel.org>,
	Baruch Siach <baruch@tkos.co.il>,
	Christophe Leroy <christophe.leroy@c-s.fr>,
	Dan Murphy <dmurphy@ti.com>,
	Divya Koppera <Divya.Koppera@microchip.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Kavya Sree Kotagiri <kavyasree.kotagiri@microchip.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Marco Felsch <m.felsch@pengutronix.de>,
	Marek Vasut <marex@denx.de>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Mathias Kresin <dev@kresin.me>,
	Maxim Kochetkov <fido_max@inbox.ru>,
	Michael Walle <michael@walle.cc>,
	Neil Armstrong <narmstrong@baylibre.com>,
	Nisar Sayed <Nisar.Sayed@microchip.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Philippe Schenker <philippe.schenker@toradex.com>,
	Willy Liu <willy.liu@realtek.com>,
	Yuiko Oshino <yuiko.oshino@microchip.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 17/82] net: phy: export phy_error and phy_trigger_machine
Date: Fri, 15 Nov 2024 07:37:54 +0100
Message-ID: <20241115063726.184846596@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit 293e9a3d950dfebc76d9fa6931e6f91ef856b9ab ]

These functions are currently used by phy_interrupt() to either signal
an error condition or to trigger the link state machine. In an attempt
to actually support shared PHY IRQs, export these two functions so that
the actual PHY drivers can use them.

Cc: Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc: Andre Edich <andre.edich@microchip.com>
Cc: Antoine Tenart <atenart@kernel.org>
Cc: Baruch Siach <baruch@tkos.co.il>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Dan Murphy <dmurphy@ti.com>
Cc: Divya Koppera <Divya.Koppera@microchip.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Jerome Brunet <jbrunet@baylibre.com>
Cc: Kavya Sree Kotagiri <kavyasree.kotagiri@microchip.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Marco Felsch <m.felsch@pengutronix.de>
Cc: Marek Vasut <marex@denx.de>
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: Mathias Kresin <dev@kresin.me>
Cc: Maxim Kochetkov <fido_max@inbox.ru>
Cc: Michael Walle <michael@walle.cc>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Nisar Sayed <Nisar.Sayed@microchip.com>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Philippe Schenker <philippe.schenker@toradex.com>
Cc: Willy Liu <willy.liu@realtek.com>
Cc: Yuiko Oshino <yuiko.oshino@microchip.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 256748d5480b ("net: phy: ti: add PHY_RST_AFTER_CLK_EN flag")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy.c | 6 ++++--
 include/linux/phy.h   | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index f3e606b6617e9..eb0f2e11cc216 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -461,10 +461,11 @@ EXPORT_SYMBOL(phy_queue_state_machine);
  *
  * @phydev: the phy_device struct
  */
-static void phy_trigger_machine(struct phy_device *phydev)
+void phy_trigger_machine(struct phy_device *phydev)
 {
 	phy_queue_state_machine(phydev, 0);
 }
+EXPORT_SYMBOL(phy_trigger_machine);
 
 static void phy_abort_cable_test(struct phy_device *phydev)
 {
@@ -970,7 +971,7 @@ void phy_stop_machine(struct phy_device *phydev)
  * Must not be called from interrupt context, or while the
  * phydev->lock is held.
  */
-static void phy_error(struct phy_device *phydev)
+void phy_error(struct phy_device *phydev)
 {
 	WARN_ON(1);
 
@@ -980,6 +981,7 @@ static void phy_error(struct phy_device *phydev)
 
 	phy_trigger_machine(phydev);
 }
+EXPORT_SYMBOL(phy_error);
 
 /**
  * phy_disable_interrupts - Disable the PHY interrupts from the PHY side
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 08725a262f320..203d53ea19d1b 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1542,8 +1542,10 @@ void phy_drivers_unregister(struct phy_driver *drv, int n);
 int phy_driver_register(struct phy_driver *new_driver, struct module *owner);
 int phy_drivers_register(struct phy_driver *new_driver, int n,
 			 struct module *owner);
+void phy_error(struct phy_device *phydev);
 void phy_state_machine(struct work_struct *work);
 void phy_queue_state_machine(struct phy_device *phydev, unsigned long jiffies);
+void phy_trigger_machine(struct phy_device *phydev);
 void phy_mac_interrupt(struct phy_device *phydev);
 void phy_start_machine(struct phy_device *phydev);
 void phy_stop_machine(struct phy_device *phydev);
-- 
2.43.0



