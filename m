Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62AEE392811
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301075; cv=none; b=X386336waFrmyg1IrO5/J1FW7zJxODV1K0x12nAY25aJfXnQUQCHHE2Q7P4vEZfGNJfNcNvSGrezxh5RAqdXu0hZpIM6coWKzrSR661F+Z1HeC21fV5gXVugey3oja1IU9h3j8VacA6ONk3h77ihcW5J6o4gVODM6ABiCvPLSsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301075; c=relaxed/simple;
	bh=DSeS++EwEDiKiYQ08hrhNvl4zKjplGTpvpcRwe/cWmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aVXXs08PHuaWN2Mqcv+obV2ei81ioBxyjs1+yVCgyASkpzK/YNhSuFZmNEOqFozjaiJG47Hs2QFS1VWl5gWli054H1ImvqgPfJ1D9TcOycNx0cWHZuKMBJ36BUMzXipextSKS5KPiLjD6CbDB/r/+2wVpcM0FTh4Emsva7/7164=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=izapoZUt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="izapoZUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE6DC116D0;
	Sat, 28 Feb 2026 17:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301075;
	bh=DSeS++EwEDiKiYQ08hrhNvl4zKjplGTpvpcRwe/cWmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=izapoZUthjrh2ITkHYd6dXFxHfthl2Vhx5QQy/aCAX24gslcMja2oxFRdhXRAPLkB
	 R68uaZQCgqcVbiWi7bkTMW+OEmyCvSqgUpBNW+NkjmvA5T/b7qKuSvEPXTnenkw/8h
	 0EHUpKqOsf4tK2AbEkQeING/Q5gtDtFgIpeq2o+WuPqXaKLjPObz1KzyencwZrhFLm
	 XbdEhcWTVTf5s8Fe2lQcLheWjowQvK/j0o2w8knNwECuU7YplxzwIG3x/X9Clneg9R
	 5Z8pD65EMPFodm2jxyPZKiHSNvFuwI7PMTrumYAfNgTnA3KdcfxH7EWlraTDSn/Eb6
	 8BGG6/DkOhLXA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 221/752] wifi: rtw88: Use devm_kmemdup() in rtw_set_supported_band()
Date: Sat, 28 Feb 2026 12:38:52 -0500
Message-ID: <20260228174750.1542406-221-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit 2ba12401cc1f2d970fa2e7d5b15abde3f5abd40d ]

Simplify the code by using device managed memory allocations.

This also fixes a memory leak in rtw_register_hw(). The supported bands
were not freed in the error path.

Copied from commit 145df52a8671 ("wifi: rtw89: Convert
rtw89_core_set_supported_band to use devm_*").

Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/1aa7fdef-2d5b-4a31-a4e9-fac8257ed30d@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/main.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index f72d12c3b2bc6..6f35357e73246 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1661,11 +1661,13 @@ static u16 rtw_get_max_scan_ie_len(struct rtw_dev *rtwdev)
 static void rtw_set_supported_band(struct ieee80211_hw *hw,
 				   const struct rtw_chip_info *chip)
 {
-	struct rtw_dev *rtwdev = hw->priv;
 	struct ieee80211_supported_band *sband;
+	struct rtw_dev *rtwdev = hw->priv;
+	struct device *dev = rtwdev->dev;
 
 	if (chip->band & RTW_BAND_2G) {
-		sband = kmemdup(&rtw_band_2ghz, sizeof(*sband), GFP_KERNEL);
+		sband = devm_kmemdup(dev, &rtw_band_2ghz, sizeof(*sband),
+				     GFP_KERNEL);
 		if (!sband)
 			goto err_out;
 		if (chip->ht_supported)
@@ -1674,7 +1676,8 @@ static void rtw_set_supported_band(struct ieee80211_hw *hw,
 	}
 
 	if (chip->band & RTW_BAND_5G) {
-		sband = kmemdup(&rtw_band_5ghz, sizeof(*sband), GFP_KERNEL);
+		sband = devm_kmemdup(dev, &rtw_band_5ghz, sizeof(*sband),
+				     GFP_KERNEL);
 		if (!sband)
 			goto err_out;
 		if (chip->ht_supported)
@@ -1690,13 +1693,6 @@ static void rtw_set_supported_band(struct ieee80211_hw *hw,
 	rtw_err(rtwdev, "failed to set supported band\n");
 }
 
-static void rtw_unset_supported_band(struct ieee80211_hw *hw,
-				     const struct rtw_chip_info *chip)
-{
-	kfree(hw->wiphy->bands[NL80211_BAND_2GHZ]);
-	kfree(hw->wiphy->bands[NL80211_BAND_5GHZ]);
-}
-
 static void rtw_vif_smps_iter(void *data, u8 *mac,
 			      struct ieee80211_vif *vif)
 {
@@ -2320,10 +2316,7 @@ EXPORT_SYMBOL(rtw_register_hw);
 
 void rtw_unregister_hw(struct rtw_dev *rtwdev, struct ieee80211_hw *hw)
 {
-	const struct rtw_chip_info *chip = rtwdev->chip;
-
 	ieee80211_unregister_hw(hw);
-	rtw_unset_supported_band(hw, chip);
 	rtw_debugfs_deinit(rtwdev);
 	rtw_led_deinit(rtwdev);
 }
-- 
2.51.0

