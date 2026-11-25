Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618207;
	b=VnRJFzZrrbvT4Mkc7mFPZYrA+qj1AZKPAmGYCv9owYEFUtu0rcmCEo0C6ue6j4A+Ey7R
	 1mXDunCg79MHkbVdMaR/t8RtybtKBYOBnje0ytCdgvBiiQQApj6CQGcy9BVm46Utm0kFu
	 cYASb3i5tdg+CqRLo0bkzGWiLEn0LXBKNxYM2lFUTa33dACZ5CU/C2spBrxnHLJ9VkkWE
	 4Ha3f85ReRgtRl9K7hSuDykAdCNDvkFG3+Dws/62K7UuFNsgA0TCusZSCke158J0W5PwJ
	 BWV7Yq9BV75Z2ADLDI8uc+7Wt/NGVTFYoDeLS+4Ws45ELJkSJW9sU06SjETC+qMkxZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618207;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h7fc0NB3sgJ3qRi7eTvxaWrmldCgvfzC04PbzhtBykY=;
	b=bH2ThNFXIq8jIxsiajiHlKmod5WEs8B083tvM9KuvrJn0Kkq4ZsSLF6PkCyt8zjJDT1Z
	 T30oFpXc0Jf+QG+SDyMBxgmpELOJpCRj0gJ+JiKb+MgEIQnb9EpGwQyoUkCOK9+eq9dBD
	 RmcmayP4vvgI2JB2vvTk8BLSakhmgIYH+ZekFqBMfJTSH0OXCk5QUyvdKNp01Ju8c9bBz
	 ItnqDZ/f344MqzN984j3lE32Y3utfy2XeZkAs7fxjugrjuQJyvIYMzRO+okMONDxfdjnr
	 jJ71wB1KmFmPn8YOAJwNzIjiEySzyewiNhrWKqcxpKM01KlGGDbcOnRqVF66yUgmn7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RDyfdIJc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D788C606A31E;
	Wed, 25 Nov 2026 14:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RDyfdIJc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7A01F000D0;
	Wed, 25 Nov 2026 14:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618207;
	bh=h7fc0NB3sgJ3qRi7eTvxaWrmldCgvfzC04PbzhtBykY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RDyfdIJcyNbRsFw+pCU2jDUFW6cjl3R6aHmZzlBZR4iMFRZKFXIkbRvWM+WYkveB1
	 DaO507DBjPRZ4TwNmGbO5VTYF2NyflbpvJWhzGIM5rQDpwyFvL4CKdQYlC5+Gs98+O
	 Ih64+5xKeOUhBy23FrHT4XHUgaXmnkEZgLGSQSiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Stockhausen <markus.stockhausen@gmx.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0169/1005] net: phy: add phy_detach_internal() helper
Date: Wed, 25 Nov 2026 15:25:07 +0100
Message-ID: <20261125143825.700823271@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Markus Stockhausen <markus.stockhausen@gmx.de>

[ Upstream commit 2df76677c1c08f622cc577a49f0645a5976d7c91 ]

For the upcoming MDIO bus notification enhancements the PHY detach path
needs to inform the bus about these actions. Until now phy_detach() is
used for the regular detach path as well as from the phy_attach_direct()
error paths So in the future there must be a clear indication if a
notification is needed (normal path) or not (cleanup path).

Carve out the phy_detach() code into a new helper phy_detach_internal()
and make phy_detach() a short stub that calls the new helper.

Signed-off-by: Markus Stockhausen <markus.stockhausen@gmx.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260831143439.2404484-5-markus.stockhausen@gmx.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: d1cf56164dc2 ("net: phy: don't require RTNL to detach a PHY from an unregistered netdev")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 172 +++++++++++++++++++----------------
 1 file changed, 92 insertions(+), 80 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 94b2e85e00a37..2827d2226d6a9 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1734,6 +1734,98 @@ static bool phy_drv_supports_irq(const struct phy_driver *phydrv)
 	return phydrv->config_intr && phydrv->handle_interrupt;
 }
 
+/**
+ * phy_detach_internal - detach a PHY device from its network device
+ * @phydev: target phy_device struct
+ *
+ * This detaches the phy device from its network device and the phy
+ * driver, and drops the reference count taken in phy_attach_direct().
+ */
+static void phy_detach_internal(struct phy_device *phydev)
+{
+	struct net_device *dev = phydev->attached_dev;
+	struct module *ndev_owner = NULL;
+	struct mii_bus *bus;
+
+	if (phydev->devlink) {
+		device_link_del(phydev->devlink);
+		phydev->devlink = NULL;
+	}
+
+	if (phydev->sysfs_links) {
+		if (dev)
+			sysfs_remove_link(&dev->dev.kobj, "phydev");
+		sysfs_remove_link(&phydev->mdio.dev.kobj, "attached_dev");
+	}
+
+	if (!phydev->attached_dev)
+		sysfs_remove_file(&phydev->mdio.dev.kobj,
+				  &dev_attr_phy_standalone.attr);
+
+	phy_suspend(phydev);
+	if (dev) {
+		struct hwtstamp_provider *hwprov;
+
+		/* hwprov may technically be protected by ops lock but
+		 * not for devices with a phydev, see phy_link_topo_add_phy()
+		 */
+		hwprov = rtnl_dereference(dev->hwprov);
+		/* Disable timestamp if it is the one selected */
+		if (hwprov && hwprov->phydev == phydev) {
+			rcu_assign_pointer(dev->hwprov, NULL);
+			kfree_rcu(hwprov, rcu_head);
+		}
+
+		phydev->attached_dev->phydev = NULL;
+		phydev->attached_dev = NULL;
+		phy_link_topo_del_phy(dev, phydev);
+	}
+
+	phydev->phy_link_change = NULL;
+	phydev->phylink = NULL;
+
+	if (phydev->mdio.dev.driver)
+		module_put(phydev->mdio.dev.driver->owner);
+
+	/* If the device had no specific driver before (i.e. - it
+	 * was using the generic driver), we unbind the device
+	 * from the generic driver so that there's a chance a
+	 * real driver could be loaded
+	 */
+	if (phydev->is_genphy_driven) {
+		device_release_driver(&phydev->mdio.dev);
+		phydev->is_genphy_driven = 0;
+	}
+
+	/* Assert the reset signal */
+	phy_device_reset(phydev, 1);
+
+	/*
+	 * The phydev might go away on the put_device() below, so avoid
+	 * a use-after-free bug by reading the underlying bus first.
+	 */
+	bus = phydev->mdio.bus;
+
+	put_device(&phydev->mdio.dev);
+	if (dev)
+		ndev_owner = dev->dev.parent->driver->owner;
+	if (ndev_owner != bus->owner)
+		module_put(bus->owner);
+}
+
+/**
+ * phy_detach - detach a PHY device from its network device
+ * @phydev: target phy_device struct
+ *
+ * This detaches the phy device from its network device and the phy
+ * driver, and drops the reference count taken in phy_attach_direct().
+ */
+void phy_detach(struct phy_device *phydev)
+{
+	phy_detach_internal(phydev);
+}
+EXPORT_SYMBOL(phy_detach);
+
 /**
  * phy_attach_direct - attach a network device to a given PHY device pointer
  * @dev: network device to attach
@@ -1906,86 +1998,6 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 }
 EXPORT_SYMBOL(phy_attach_direct);
 
-/**
- * phy_detach - detach a PHY device from its network device
- * @phydev: target phy_device struct
- *
- * This detaches the phy device from its network device and the phy
- * driver, and drops the reference count taken in phy_attach_direct().
- */
-void phy_detach(struct phy_device *phydev)
-{
-	struct net_device *dev = phydev->attached_dev;
-	struct module *ndev_owner = NULL;
-	struct mii_bus *bus;
-
-	if (phydev->devlink) {
-		device_link_del(phydev->devlink);
-		phydev->devlink = NULL;
-	}
-
-	if (phydev->sysfs_links) {
-		if (dev)
-			sysfs_remove_link(&dev->dev.kobj, "phydev");
-		sysfs_remove_link(&phydev->mdio.dev.kobj, "attached_dev");
-	}
-
-	if (!phydev->attached_dev)
-		sysfs_remove_file(&phydev->mdio.dev.kobj,
-				  &dev_attr_phy_standalone.attr);
-
-	phy_suspend(phydev);
-	if (dev) {
-		struct hwtstamp_provider *hwprov;
-
-		/* hwprov may technically be protected by ops lock but
-		 * not for devices with a phydev, see phy_link_topo_add_phy()
-		 */
-		hwprov = rtnl_dereference(dev->hwprov);
-		/* Disable timestamp if it is the one selected */
-		if (hwprov && hwprov->phydev == phydev) {
-			rcu_assign_pointer(dev->hwprov, NULL);
-			kfree_rcu(hwprov, rcu_head);
-		}
-
-		phydev->attached_dev->phydev = NULL;
-		phydev->attached_dev = NULL;
-		phy_link_topo_del_phy(dev, phydev);
-	}
-
-	phydev->phy_link_change = NULL;
-	phydev->phylink = NULL;
-
-	if (phydev->mdio.dev.driver)
-		module_put(phydev->mdio.dev.driver->owner);
-
-	/* If the device had no specific driver before (i.e. - it
-	 * was using the generic driver), we unbind the device
-	 * from the generic driver so that there's a chance a
-	 * real driver could be loaded
-	 */
-	if (phydev->is_genphy_driven) {
-		device_release_driver(&phydev->mdio.dev);
-		phydev->is_genphy_driven = 0;
-	}
-
-	/* Assert the reset signal */
-	phy_device_reset(phydev, 1);
-
-	/*
-	 * The phydev might go away on the put_device() below, so avoid
-	 * a use-after-free bug by reading the underlying bus first.
-	 */
-	bus = phydev->mdio.bus;
-
-	put_device(&phydev->mdio.dev);
-	if (dev)
-		ndev_owner = dev->dev.parent->driver->owner;
-	if (ndev_owner != bus->owner)
-		module_put(bus->owner);
-}
-EXPORT_SYMBOL(phy_detach);
-
 int phy_suspend(struct phy_device *phydev)
 {
 	struct net_device *netdev = phydev->attached_dev;
-- 
2.53.0



