Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619310;
	b=4O0oonI7xzYafrQ3EqDD0nqrnhTfs5bgKwc3BmifgSdHiA+gpX8JSx6zHTSv5EVA06x4
	 RXFOOi1tZKRptzxBC9A+eY872B23F5kKeowfvE0u4+Cckb6DDQlbtqFzfTd6GWZS6YzPD
	 yM0WLuEWpYUbCcq+WAT0uNDrwV87B2YFfVlul35Qv+wRN+v9nxXrJYbID4Dj79PQqnlzB
	 g6z+xX/Z4jWabBKAjQKDfajeEABnRLxqqhoMLW6JkEq8ib5l3ysNPcmQOrsWWOtQEVzri
	 lciCW2QwVdGS+E3G2I2rteim+VLoAvQEMuGy/EVl9DaCZJKs+UA6eLZ4k1fjjsllSRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619310;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R3g13roKbdCFOAzUcbKJ1KFnuT2Zg8r2+NEPi/1wBRc=;
	b=EHKFMmnai0VayGkEwmwl73vRzCh4TU+TZPGtDcd088ExJWFUI0RHIA/5U/oV7N5gAdvH
	 34iy45gwdIRs7uPqXCleyNRsbDQUwIJbZxEKgqq9gybNZQ2NmzyzGURZO6+yW/tQih06A
	 HkJEgEimfso1HhUyePVfsa5fp5RTL4Qv5SVQt7Bob8WqVJTryANgv7wpDo/iXXxvZ16I4
	 a5g5TW4zblj9Cqt5zp9N2Af3qA2TY/BGaoLOpe9Z2rb9wSwpuqlbdcfrkaaY57EIyJSYj
	 /du/Oamd7A1fNPhpH7yO7hZz7Se0cQk34SxpDYU9OH+i/vJ4Z/AlDIJz3/+aHwOsvYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qE4J5zlO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB2F606A31E;
	Wed, 25 Nov 2026 15:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qE4J5zlO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B29EE1F000C0;
	Wed, 25 Nov 2026 15:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619310;
	bh=R3g13roKbdCFOAzUcbKJ1KFnuT2Zg8r2+NEPi/1wBRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qE4J5zlOVKpaQwAHWZUXa/jJQ3PbL0pB76PsF61YExdRwSa2t0nmtA2ppgG15d5Yj
	 f6ClfcW4wQaGsOGs89tiCuaz8ypqeH0kH3mQZnpSOy1LGEoraHLt/feVVSoew+2ZfK
	 qZ9psaE+Z0LbOXhn1Vp+KcCB8r49z2srSopHzGUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iustin Stolniceanu <iustin.stolniceanu@analog.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0549/1005] net: phy: c45: select BASE-T1 type for the forced speed
Date: Wed, 25 Nov 2026 15:31:27 +0100
Message-ID: <20261125143834.605525256@linuxfoundation.org>
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

From: Iustin Stolniceanu <iustin.stolniceanu@analog.com>

[ Upstream commit df501db9b18fae4d3edd534b992675f4673a938e ]

Commit 25108a834e14 ("net: phy: c45: add support for 1000BASE-T1 forced
setup") made genphy_c45_pma_setup_forced() write the type selection
field (bits 3:0) of the BASE-T1 PMA/PMD control register (1.2100) on
every forced setup: 1000BASE-T1 for SPEED_1000, and 0 for everything
else. 0 selects 100BASE-T1, so forcing a 10BASE-T1L PHY to 10 Mbit/s
now also switches its PMA to 100BASE-T1, a mode it does not implement.

Seen on an ADIN1110 (internal ADIN1100 PHY): after

  ethtool -s ethX autoneg off speed 10 master-slave forced-master

1.2100 reads 0xc000 instead of the 0xc002. Since the field is not
restored by re-enabling autoneg, the PHY keeps the wrong type until
the next forced setup or reset.

Add a helper that returns the type selection value for the forced speed
and the supported link modes: 100BASE-T1, 1000BASE-T1, and 10BASE-T1L or
10BASE-T1S for SPEED_10 depending on the supported 10 Mbit/s modes. Fail
with -EINVAL when no type matches instead of writing 100BASE-T1. This
also applies to forced 2.5G, 5G and 10G on BASE-T1 capable PHYs, for
which there are no link modes yet.

The field is called "type selection" in IEEE 802.3-2022 (45.2.1.214,
Table 45-178). Keep the old STRAP names as aliases.

Tested on EVAL-ADIN1110EBZ: with this change, forcing 10 Mbit/s writes
1.2100 = 0xc002 (10BASE-T1L) instead of the invalid 0xc000.

Fixes: 25108a834e14 ("net: phy: c45: add support for 1000BASE-T1 forced setup")
Signed-off-by: Iustin Stolniceanu <iustin.stolniceanu@analog.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20261111100053.345196-1-iustin.stolniceanu@analog.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy-c45.c | 46 ++++++++++++++++++++++++++++++++++-----
 include/uapi/linux/mdio.h | 13 +++++++++--
 2 files changed, 52 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index 870920311f9a0..828af4c4e9d4c 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -104,6 +104,36 @@ int genphy_c45_pma_baset1_setup_master_slave(struct phy_device *phydev)
 }
 EXPORT_SYMBOL_GPL(genphy_c45_pma_baset1_setup_master_slave);
 
+/* Type selection value for the BASE-T1 PMA/PMD control register (1.2100,
+ * 802.3-2022 Table 45-178) matching the forced speed. 10 Mbit/s is ambiguous
+ * between 10BASE-T1L and 10BASE-T1S, so the supported link modes decide.
+ * 2.5G, 5G and 10GBASE-T1 are not handled as there are no link modes for them
+ * yet.
+ */
+static int genphy_c45_baset1_type_sel(struct phy_device *phydev)
+{
+	switch (phydev->speed) {
+	case SPEED_10:
+		if (linkmode_test_bit(ETHTOOL_LINK_MODE_10baseT1L_Full_BIT,
+				      phydev->supported))
+			return MDIO_PMA_PMD_BT1_CTRL_TYPE_SEL_10BT1L;
+		if (linkmode_test_bit(ETHTOOL_LINK_MODE_10baseT1S_Full_BIT,
+				      phydev->supported) ||
+		    linkmode_test_bit(ETHTOOL_LINK_MODE_10baseT1S_Half_BIT,
+				      phydev->supported) ||
+		    linkmode_test_bit(ETHTOOL_LINK_MODE_10baseT1S_P2MP_Half_BIT,
+				      phydev->supported))
+			return MDIO_PMA_PMD_BT1_CTRL_TYPE_SEL_10BT1S;
+		return -EINVAL;
+	case SPEED_100:
+		return MDIO_PMA_PMD_BT1_CTRL_TYPE_SEL_100BT1;
+	case SPEED_1000:
+		return MDIO_PMA_PMD_BT1_CTRL_TYPE_SEL_1000BT1;
+	default:
+		return -EINVAL;
+	}
+}
+
 /**
  * genphy_c45_pma_setup_forced - configures a forced speed
  * @phydev: target phy_device struct
@@ -166,6 +196,16 @@ int genphy_c45_pma_setup_forced(struct phy_device *phydev)
 		return -EINVAL;
 	}
 
+	/* Resolve the type before the first write, so a speed without a
+	 * matching type leaves the PHY untouched.
+	 */
+	bt1_ctrl = 0;
+	if (genphy_c45_baset1_able(phydev)) {
+		bt1_ctrl = genphy_c45_baset1_type_sel(phydev);
+		if (bt1_ctrl < 0)
+			return bt1_ctrl;
+	}
+
 	ret = phy_write_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_CTRL1, ctrl1);
 	if (ret < 0)
 		return ret;
@@ -179,12 +219,8 @@ int genphy_c45_pma_setup_forced(struct phy_device *phydev)
 		if (ret < 0)
 			return ret;
 
-		bt1_ctrl = 0;
-		if (phydev->speed == SPEED_1000)
-			bt1_ctrl = MDIO_PMA_PMD_BT1_CTRL_STRAP_B1000;
-
 		ret = phy_modify_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_PMD_BT1_CTRL,
-				     MDIO_PMA_PMD_BT1_CTRL_STRAP, bt1_ctrl);
+				     MDIO_PMA_PMD_BT1_CTRL_TYPE_SEL, bt1_ctrl);
 		if (ret < 0)
 			return ret;
 	}
diff --git a/include/uapi/linux/mdio.h b/include/uapi/linux/mdio.h
index 06f4bc3c20c71..2806f60ed1054 100644
--- a/include/uapi/linux/mdio.h
+++ b/include/uapi/linux/mdio.h
@@ -417,8 +417,17 @@
 #define MDIO_AN_10BT1_AN_STAT_LPA_EEE_T1L	0x4000 /* 10BASE-T1L LP EEE ability advertisement */
 
 /* BASE-T1 PMA/PMD control register */
-#define MDIO_PMA_PMD_BT1_CTRL_STRAP		0x000F /* Type selection (Strap) */
-#define MDIO_PMA_PMD_BT1_CTRL_STRAP_B1000	0x0001 /* Select 1000BASE-T1 */
+#define MDIO_PMA_PMD_BT1_CTRL_TYPE_SEL		0x000F /* Type selection */
+#define MDIO_PMA_PMD_BT1_CTRL_TYPE_SEL_100BT1	0x0000 /* Select 100BASE-T1 */
+#define MDIO_PMA_PMD_BT1_CTRL_TYPE_SEL_1000BT1	0x0001 /* Select 1000BASE-T1 */
+#define MDIO_PMA_PMD_BT1_CTRL_TYPE_SEL_10BT1L	0x0002 /* Select 10BASE-T1L */
+#define MDIO_PMA_PMD_BT1_CTRL_TYPE_SEL_10BT1S	0x0003 /* Select 10BASE-T1S */
+#define MDIO_PMA_PMD_BT1_CTRL_TYPE_SEL_2P5GBT1	0x0004 /* Select 2.5GBASE-T1 */
+#define MDIO_PMA_PMD_BT1_CTRL_TYPE_SEL_5GBT1	0x0005 /* Select 5GBASE-T1 */
+#define MDIO_PMA_PMD_BT1_CTRL_TYPE_SEL_10GBT1	0x0006 /* Select 10GBASE-T1 */
+/* Legacy names, kept for userspace */
+#define MDIO_PMA_PMD_BT1_CTRL_STRAP		MDIO_PMA_PMD_BT1_CTRL_TYPE_SEL
+#define MDIO_PMA_PMD_BT1_CTRL_STRAP_B1000	MDIO_PMA_PMD_BT1_CTRL_TYPE_SEL_1000BT1
 #define MDIO_PMA_PMD_BT1_CTRL_CFG_MST		0x4000 /* MASTER-SLAVE config value */
 
 /* 1000BASE-T1 PCS control register */
-- 
2.53.0



