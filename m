Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291473C3439;
	Tue, 16 Jun 2026 16:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628371; cv=none; b=ic2l86uQjVvfAKdMeo2/KzkacSTSr6DVwNBusP66bwsu0u8bhadgAZ1mx+fwGUEUDDQPc76rkUyjArltZpDQSZNW34/ribvvZ2PzhXRoexa3LNQ3xSD7n6O3CB7M8dYbRXgK93w0Ktd4ES2Ycil7WtVe8oGR/GlgJaDM5wLwahY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628371; c=relaxed/simple;
	bh=XfJRR+yrOgKxL8b9K3qHVBnm9ZEvxqHmBtk7xhVGfPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2ngt2UCfbFfqExkQfSAqxM4sEt5bEJd5spdsuKq+DH0XG4+PJzrQ8vefVSr9Mjx/co/wxAW+n8pSenNVMJHDw3tDJlA1mScYrBT9mbZ1rwMuCNBkjKmMuxmG03l0jGyw8qp6XYI2qRE28K4BSj3W4u/Rvn7JI77aBjZ9u8Afvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G8KWAom/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G8KWAom/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3331F000E9;
	Tue, 16 Jun 2026 16:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628370;
	bh=y8Hp64Xp8H1W6tg9N1NI/KTslYfBkuoRMDHctT5HpVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G8KWAom/0Z8QcWO9VuR4fTmKtlcrvAwiM9uy4jaCaGNqqXr87OOdSzmARPPZOw3Sx
	 uz7C9iJyrtRvjIdVXPrQQ06OIfxdnWJ3x9qthc4diXFvGtz/FSHXLl/kzca1Z+O7jm
	 kJfhj+3whc0hHSI1LAfLkuK2zmov769EuMDu4+r4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/452] phy: mscc: Use PHY_ID_MATCH_EXACT for VSC8584, VSC8582, VSC8575, VSC856X
Date: Tue, 16 Jun 2026 20:25:02 +0530
Message-ID: <20260616145121.845221933@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit 1bc80d673087e5704adbb3ee8e4b785c14899cce ]

As the PHYs VSC8584, VSC8582, VSC8575 and VSC856X exists only as rev B,
we can use PHY_ID_MATCH_EXACT to match exactly on revision B of the PHY.
Because of this change then there is not need the check if it is a
different revision than rev B in the function vsc8584_probe() as we
already know that this will never happen.
These changes are a preparation for the next patch because in that patch
we will make the PHYs VSC8574 and VSC8572 to use vsc8584_probe() and
these PHYs have multiple revision.

Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Link: https://patch.msgid.link/20251023191350.190940-2-horatiu.vultur@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mscc/mscc.h      |  8 ++++----
 drivers/net/phy/mscc/mscc_main.c | 23 ++++-------------------
 2 files changed, 8 insertions(+), 23 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index 4ba6e32cf6d8d1..c7aaf2c1ee52f1 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -286,12 +286,12 @@ enum rgmii_clock_delay {
 #define PHY_ID_VSC8540			  0x00070760
 #define PHY_ID_VSC8541			  0x00070770
 #define PHY_ID_VSC8552			  0x000704e0
-#define PHY_ID_VSC856X			  0x000707e0
+#define PHY_ID_VSC856X			  0x000707e1
 #define PHY_ID_VSC8572			  0x000704d0
 #define PHY_ID_VSC8574			  0x000704a0
-#define PHY_ID_VSC8575			  0x000707d0
-#define PHY_ID_VSC8582			  0x000707b0
-#define PHY_ID_VSC8584			  0x000707c0
+#define PHY_ID_VSC8575			  0x000707d1
+#define PHY_ID_VSC8582			  0x000707b1
+#define PHY_ID_VSC8584			  0x000707c1
 #define PHY_VENDOR_MSCC			0x00070400
 
 #define MSCC_VDDMAC_1500		  1500
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 0a4aa8e08827aa..bce7ff8555c2e9 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -1724,12 +1724,6 @@ static int vsc8584_config_init(struct phy_device *phydev)
 	 * in this pre-init function.
 	 */
 	if (phy_package_init_once(phydev)) {
-		/* The following switch statement assumes that the lowest
-		 * nibble of the phy_id_mask is always 0. This works because
-		 * the lowest nibble of the PHY_ID's below are also 0.
-		 */
-		WARN_ON(phydev->drv->phy_id_mask & 0xf);
-
 		switch (phydev->phy_id & phydev->drv->phy_id_mask) {
 		case PHY_ID_VSC8504:
 		case PHY_ID_VSC8552:
@@ -2268,11 +2262,6 @@ static int vsc8584_probe(struct phy_device *phydev)
 	   VSC8531_DUPLEX_COLLISION};
 	int ret;
 
-	if ((phydev->phy_id & MSCC_DEV_REV_MASK) != VSC8584_REVB) {
-		dev_err(&phydev->mdio.dev, "Only VSC8584 revB is supported.\n");
-		return -ENOTSUPP;
-	}
-
 	vsc8531 = devm_kzalloc(&phydev->mdio.dev, sizeof(*vsc8531), GFP_KERNEL);
 	if (!vsc8531)
 		return -ENOMEM;
@@ -2559,9 +2548,8 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_stats      = &vsc85xx_get_stats,
 },
 {
-	.phy_id		= PHY_ID_VSC856X,
+	PHY_ID_MATCH_EXACT(PHY_ID_VSC856X),
 	.name		= "Microsemi GE VSC856X SyncE",
-	.phy_id_mask	= 0xfffffff0,
 	/* PHY_GBIT_FEATURES */
 	.soft_reset	= &genphy_soft_reset,
 	.config_init    = &vsc8584_config_init,
@@ -2633,9 +2621,8 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_stats      = &vsc85xx_get_stats,
 },
 {
-	.phy_id		= PHY_ID_VSC8575,
+	PHY_ID_MATCH_EXACT(PHY_ID_VSC8575),
 	.name		= "Microsemi GE VSC8575 SyncE",
-	.phy_id_mask	= 0xfffffff0,
 	/* PHY_GBIT_FEATURES */
 	.soft_reset	= &genphy_soft_reset,
 	.config_init    = &vsc8584_config_init,
@@ -2657,9 +2644,8 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_stats      = &vsc85xx_get_stats,
 },
 {
-	.phy_id		= PHY_ID_VSC8582,
+	PHY_ID_MATCH_EXACT(PHY_ID_VSC8582),
 	.name		= "Microsemi GE VSC8582 SyncE",
-	.phy_id_mask	= 0xfffffff0,
 	/* PHY_GBIT_FEATURES */
 	.soft_reset	= &genphy_soft_reset,
 	.config_init    = &vsc8584_config_init,
@@ -2681,9 +2667,8 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_stats      = &vsc85xx_get_stats,
 },
 {
-	.phy_id		= PHY_ID_VSC8584,
+	PHY_ID_MATCH_EXACT(PHY_ID_VSC8584),
 	.name		= "Microsemi GE VSC8584 SyncE",
-	.phy_id_mask	= 0xfffffff0,
 	/* PHY_GBIT_FEATURES */
 	.soft_reset	= &genphy_soft_reset,
 	.config_init    = &vsc8584_config_init,
-- 
2.53.0



