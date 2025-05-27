Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB1D1F8670;
	Tue, 27 May 2025 17:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367151; cv=none; b=WVVBkYEuymswKblUV1YpJPflyYTSnlUx2XZBkyOQGFAlQwSNZMarSmKSLcProj8MAdgvO9UwRJydu0NWUQoJmeCdWzeRQP+C+a4fFkFGI/DAKh+RtBUNcg9l/zZ1UXfrykuElNWdAXKJLH/eRCa5n+u73ArsWsb4wwiz6tIMGZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367151; c=relaxed/simple;
	bh=ILa4rh/jgooH7SjbwBuQmctbIl8YpIYaGUaN9pCczv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJVPOmy8L1tLLV3IUh+KL5XFoFxcjrcKG/bQSAJ+ywLdj2H7l69SNwesHfIphXOWsgtN/fgKFtcXdF8Jlh7PVxcJGz+K9yZnvlYi/ay+wrAPNA2aQe3GnAJMDjb0NCWPqCDipumFcWr0LhrEmcU9+GwuXidcdgXXLnBE4k0uhDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tx2MoEXM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tx2MoEXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B63C4CEE9;
	Tue, 27 May 2025 17:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367151;
	bh=ILa4rh/jgooH7SjbwBuQmctbIl8YpIYaGUaN9pCczv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tx2MoEXMG1SQD3aRIz0MeXO4l1737v4b/5JUWxOa0TvVe7WK5KR0BCJz5qglBDkY8
	 JcOcErJHzkOWrgz0MeXCBU3V/6s7eRbJm3dGHczSVzR8T5/H0YUyYSoPrEkDs4c7Xj
	 EAbF3Fm587xkgKbCeNMgzXwRFJJXJAa2vFKCmOxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Botila <andrei.botila@oss.nxp.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 295/783] net: phy: nxp-c45-tja11xx: add match_phy_device to TJA1103/TJA1104
Date: Tue, 27 May 2025 18:21:32 +0200
Message-ID: <20250527162525.094612851@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrei Botila <andrei.botila@oss.nxp.com>

[ Upstream commit a06a868a0cd96bc51401cdea897313a3f6ad01a0 ]

Add .match_phy_device for the existing TJAs to differentiate between
TJA1103 and TJA1104.
TJA1103 and TJA1104 share the same PHY_ID but TJA1104 has MACsec
capabilities while TJA1103 doesn't.

Signed-off-by: Andrei Botila <andrei.botila@oss.nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250228154320.2979000-2-andrei.botila@oss.nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/nxp-c45-tja11xx.c | 54 +++++++++++++++++++++++++++++--
 1 file changed, 52 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index e9fc54517449c..16e1c13ae2f8d 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /* NXP C45 PHY driver
- * Copyright 2021-2023 NXP
+ * Copyright 2021-2025 NXP
  * Author: Radu Pirea <radu-nicolae.pirea@oss.nxp.com>
  */
 
@@ -19,6 +19,8 @@
 
 #include "nxp-c45-tja11xx.h"
 
+#define PHY_ID_MASK			GENMASK(31, 4)
+/* Same id: TJA1103, TJA1104 */
 #define PHY_ID_TJA_1103			0x001BB010
 #define PHY_ID_TJA_1120			0x001BB031
 
@@ -1956,6 +1958,30 @@ static void tja1120_nmi_handler(struct phy_device *phydev,
 	}
 }
 
+static int nxp_c45_macsec_ability(struct phy_device *phydev)
+{
+	bool macsec_ability;
+	int phy_abilities;
+
+	phy_abilities = phy_read_mmd(phydev, MDIO_MMD_VEND1,
+				     VEND1_PORT_ABILITIES);
+	macsec_ability = !!(phy_abilities & MACSEC_ABILITY);
+
+	return macsec_ability;
+}
+
+static int tja1103_match_phy_device(struct phy_device *phydev)
+{
+	return phy_id_compare(phydev->phy_id, PHY_ID_TJA_1103, PHY_ID_MASK) &&
+	       !nxp_c45_macsec_ability(phydev);
+}
+
+static int tja1104_match_phy_device(struct phy_device *phydev)
+{
+	return phy_id_compare(phydev->phy_id, PHY_ID_TJA_1103, PHY_ID_MASK) &&
+	       nxp_c45_macsec_ability(phydev);
+}
+
 static const struct nxp_c45_regmap tja1120_regmap = {
 	.vend1_ptp_clk_period	= 0x1020,
 	.vend1_event_msg_filt	= 0x9010,
@@ -2026,7 +2052,6 @@ static const struct nxp_c45_phy_data tja1120_phy_data = {
 
 static struct phy_driver nxp_c45_driver[] = {
 	{
-		PHY_ID_MATCH_MODEL(PHY_ID_TJA_1103),
 		.name			= "NXP C45 TJA1103",
 		.get_features		= nxp_c45_get_features,
 		.driver_data		= &tja1103_phy_data,
@@ -2048,6 +2073,31 @@ static struct phy_driver nxp_c45_driver[] = {
 		.get_sqi		= nxp_c45_get_sqi,
 		.get_sqi_max		= nxp_c45_get_sqi_max,
 		.remove			= nxp_c45_remove,
+		.match_phy_device	= tja1103_match_phy_device,
+	},
+	{
+		.name			= "NXP C45 TJA1104",
+		.get_features		= nxp_c45_get_features,
+		.driver_data		= &tja1103_phy_data,
+		.probe			= nxp_c45_probe,
+		.soft_reset		= nxp_c45_soft_reset,
+		.config_aneg		= genphy_c45_config_aneg,
+		.config_init		= nxp_c45_config_init,
+		.config_intr		= tja1103_config_intr,
+		.handle_interrupt	= nxp_c45_handle_interrupt,
+		.read_status		= genphy_c45_read_status,
+		.suspend		= genphy_c45_pma_suspend,
+		.resume			= genphy_c45_pma_resume,
+		.get_sset_count		= nxp_c45_get_sset_count,
+		.get_strings		= nxp_c45_get_strings,
+		.get_stats		= nxp_c45_get_stats,
+		.cable_test_start	= nxp_c45_cable_test_start,
+		.cable_test_get_status	= nxp_c45_cable_test_get_status,
+		.set_loopback		= genphy_c45_loopback,
+		.get_sqi		= nxp_c45_get_sqi,
+		.get_sqi_max		= nxp_c45_get_sqi_max,
+		.remove			= nxp_c45_remove,
+		.match_phy_device	= tja1104_match_phy_device,
 	},
 	{
 		PHY_ID_MATCH_MODEL(PHY_ID_TJA_1120),
-- 
2.39.5



