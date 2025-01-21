Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FEF1F7569;
	Tue, 21 Jan 2025 18:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737483142; cv=none; b=K/rsJZ7FxAwory30TmdGOcg7/byVM6qW3+CuvEKCP6mJisWeQYtZU3JG3rHGXroLFOqUzYSHI95e75Ae6bhYuSEObqyHjjRxSVDCtvp4P9VWiwFaXlsxmJiDhIaK08WmN6/9++eCOt/meQCHXDMg6bdz651m322e7jk1ip9FxbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737483142; c=relaxed/simple;
	bh=/91cAhBbSnYsP6JnRLAGmNo419VXTeLstrobwIlJG9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QcraSykREBTXcOXlzfhV4s8/9eZGdQKoj4JElGLr36j8GP+9b38dDg3TJHAVcNYSV0tNiVJpRRu1OuzrxBNvTtLE+lrDn5ASubcjHl4IgaQj77LqfO7e+czJUvatjaPeL1vwwa3uDUSlKOmosLHh3hiLqDiz/fyiy8L/Gf3EFc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WMh5/GQW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WMh5/GQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C425DC4CEDF;
	Tue, 21 Jan 2025 18:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737483142;
	bh=/91cAhBbSnYsP6JnRLAGmNo419VXTeLstrobwIlJG9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WMh5/GQWyn9htxG8uRnnhD5nOHtwpk2txtRWDosysrhud1+8mLIYewEcIzpzlQpO+
	 +wq4Ch5nV5DhVKP/vLq0yBcJU4bMco0S76WFVJRZi4/pzvgQyYXUAS/gpmoM8KymTg
	 bPEZTRwzG5p9FyhnKpsH3k05yDQhYyQGr+pkEQt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 105/127] net: ethernet: xgbe: re-add aneg to supported features in PHY quirks
Date: Tue, 21 Jan 2025 18:52:57 +0100
Message-ID: <20250121174533.701419437@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

commit 6be7aca91009865d8c2b73589270224a6b6e67ab upstream.

In 4.19, before the switch to linkmode bitmaps, PHY_GBIT_FEATURES
included feature bits for aneg and TP/MII ports.

				 SUPPORTED_TP | \
				 SUPPORTED_MII)

				 SUPPORTED_10baseT_Full)

				 SUPPORTED_100baseT_Full)

				 SUPPORTED_1000baseT_Full)

				 PHY_100BT_FEATURES | \
				 PHY_DEFAULT_FEATURES)

				 PHY_1000BT_FEATURES)

Referenced commit expanded PHY_GBIT_FEATURES, silently removing
PHY_DEFAULT_FEATURES. The removed part can be re-added by using
the new PHY_GBIT_FEATURES definition.
Not clear to me is why nobody seems to have noticed this issue.

I stumbled across this when checking what it takes to make
phy_10_100_features_array et al private to phylib.

Fixes: d0939c26c53a ("net: ethernet: xgbe: expand PHY_GBIT_FEAUTRES")
Cc: stable@vger.kernel.org
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://patch.msgid.link/46521973-7738-4157-9f5e-0bb6f694acba@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c |   19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -856,7 +856,6 @@ static void xgbe_phy_free_phy_device(str
 
 static bool xgbe_phy_finisar_phy_quirks(struct xgbe_prv_data *pdata)
 {
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported) = { 0, };
 	struct xgbe_phy_data *phy_data = pdata->phy_data;
 	unsigned int phy_id = phy_data->phydev->phy_id;
 
@@ -878,14 +877,7 @@ static bool xgbe_phy_finisar_phy_quirks(
 	phy_write(phy_data->phydev, 0x04, 0x0d01);
 	phy_write(phy_data->phydev, 0x00, 0x9140);
 
-	linkmode_set_bit_array(phy_10_100_features_array,
-			       ARRAY_SIZE(phy_10_100_features_array),
-			       supported);
-	linkmode_set_bit_array(phy_gbit_features_array,
-			       ARRAY_SIZE(phy_gbit_features_array),
-			       supported);
-
-	linkmode_copy(phy_data->phydev->supported, supported);
+	linkmode_copy(phy_data->phydev->supported, PHY_GBIT_FEATURES);
 
 	phy_support_asym_pause(phy_data->phydev);
 
@@ -897,7 +889,6 @@ static bool xgbe_phy_finisar_phy_quirks(
 
 static bool xgbe_phy_belfuse_phy_quirks(struct xgbe_prv_data *pdata)
 {
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported) = { 0, };
 	struct xgbe_phy_data *phy_data = pdata->phy_data;
 	struct xgbe_sfp_eeprom *sfp_eeprom = &phy_data->sfp_eeprom;
 	unsigned int phy_id = phy_data->phydev->phy_id;
@@ -961,13 +952,7 @@ static bool xgbe_phy_belfuse_phy_quirks(
 	reg = phy_read(phy_data->phydev, 0x00);
 	phy_write(phy_data->phydev, 0x00, reg & ~0x00800);
 
-	linkmode_set_bit_array(phy_10_100_features_array,
-			       ARRAY_SIZE(phy_10_100_features_array),
-			       supported);
-	linkmode_set_bit_array(phy_gbit_features_array,
-			       ARRAY_SIZE(phy_gbit_features_array),
-			       supported);
-	linkmode_copy(phy_data->phydev->supported, supported);
+	linkmode_copy(phy_data->phydev->supported, PHY_GBIT_FEATURES);
 	phy_support_asym_pause(phy_data->phydev);
 
 	netif_dbg(pdata, drv, pdata->netdev,


