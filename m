Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214604;
	b=It/ULPwD6u8Z9RkD2Ub3DyoufOxxD8sopH8RfsZaWJCKF/IrJdGLlJpXHWOCVuMMeby8
	 yNTLJSrJZ5nUE/aUrdZVGMF6h1X9ohY+dS+W2EqHJXFFPvC6ubSStvrLiHyzpewDBUQiR
	 TX/BM9q7vdc81LGYc00X7K+lahDyyPeiMt0I+IUnkVn+LNKqnMJY1tA7TqhdogPz/yfXZ
	 0XK0Xca0AFNIuewYpgpkhr0Unefx4uCAiN4IbXq4f6Ha96b2pqEcwus33LCI3U9Jrb4bE
	 dRYEqpVR/mTEBlVGIQkqaOvf53f/s1GrfC8eEZFF7tlW0TLH88VHk/K4aUiXXnUCKuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214604;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mGXcEKY82Bvip8LULPQGa5Qew1ryaz4cpDyNaZLaAsw=;
	b=tGk3+sU5JyC37JLY9YoC8tFO1xAhjSf0F4An46nR3ymt5AVyCkgcJUmIuubVQTvoVIAu
	 PdDXHJYmNtU/03Yv74rm+2qaDs+Dlpe8N4PkOjlg+h0hgRuQTrFxKFMztTmSkRYxKDH4D
	 oTuOZM6vUdarO+j8sNA71L5gzNktMk5+T20vaBaqyYECwcS5vFEP5krhjH4M/iWgjrT7c
	 MLr/SfjpMcN7pLA0ozAvEMixY0LCjoAJ2Y2E19jFQgB2YgnLKMuFcNe2aZMYIhuKCRGN2
	 4JHjLvIgxbmt4M1mmoGeRj5pTRDwtMlG7WpU1OwfcoEDc8bQsZRpdqojLx6CttcUFsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xAK6+efH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDA1606A32E;
	Wed, 28 Oct 2026 19:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xAK6+efH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909BD1F01828;
	Wed, 28 Oct 2026 19:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214604;
	bh=mGXcEKY82Bvip8LULPQGa5Qew1ryaz4cpDyNaZLaAsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xAK6+efHgWWGNHf3BF5CKSHgvRcwwW+d7giqKMQNarEN3LKthTFw6XUQBpFFrWdmx
	 jSkUSIej9L5DITdkv2BVCM2Pevo8tRLkzPRNWG3Nh4ZO/OQZmQ07APDkbv7FOj9bPO
	 tQxdrFo6v3IY6sciM/FaMT7CTlzBbesUw/YQVYE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0918/1887] wifi: rtw88: Use devm_kmemdup() in rtw_set_supported_band()
Date: Wed, 28 Oct 2026 17:50:14 +0100
Message-ID: <20261028170520.307393372@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 6546420a8135f..32459c6ebecdf 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1605,11 +1605,13 @@ static u16 rtw_get_max_scan_ie_len(struct rtw_dev *rtwdev)
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
@@ -1618,7 +1620,8 @@ static void rtw_set_supported_band(struct ieee80211_hw *hw,
 	}
 
 	if (chip->band & RTW_BAND_5G) {
-		sband = kmemdup(&rtw_band_5ghz, sizeof(*sband), GFP_KERNEL);
+		sband = devm_kmemdup(dev, &rtw_band_5ghz, sizeof(*sband),
+				     GFP_KERNEL);
 		if (!sband)
 			goto err_out;
 		if (chip->ht_supported)
@@ -1634,13 +1637,6 @@ static void rtw_set_supported_band(struct ieee80211_hw *hw,
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
@@ -2238,10 +2234,7 @@ EXPORT_SYMBOL(rtw_register_hw);
 
 void rtw_unregister_hw(struct rtw_dev *rtwdev, struct ieee80211_hw *hw)
 {
-	const struct rtw_chip_info *chip = rtwdev->chip;
-
 	ieee80211_unregister_hw(hw);
-	rtw_unset_supported_band(hw, chip);
 	rtw_debugfs_deinit(rtwdev);
 }
 EXPORT_SYMBOL(rtw_unregister_hw);
-- 
2.53.0



