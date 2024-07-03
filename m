Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4FF16F8FA;
	Wed,  3 Jul 2024 11:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004835; cv=none; b=a7c2xF79ONB7BuwwYJufDUB4bpEXjgmC0xUUcllJfTkqEX7DKQuFf1grJ+vTqo05pB6FzHdis1rRVfjj3cw8plhqSsfQ1JVGhbmCth/lluD2wOiybVHSDPl4atLuyMlVZp7F0HGQ4J+vn6wU05Ph989XoXZWMujEsnYvPdqfyE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004835; c=relaxed/simple;
	bh=oubAPQA/Tma3aZRmxvnx4Ool5T62BG3KgBaWAmyPLMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WbUaExHCEtNULocXlfUleYsTWxjtWnNwyvWFPmtRGrDNnss9M6586CXBcnwFHL44uT0rse3SsarzHlwMzpeGghqn5OuPQKSVFBOF01x7PKtkRyZuGN9O7eR9XAPnKv40uK0ZthpzzlzXCVOsguMjKVlJmGTS8izkelBCDBLmv+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SBh8gtqy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SBh8gtqy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5916EC2BD10;
	Wed,  3 Jul 2024 11:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004834;
	bh=oubAPQA/Tma3aZRmxvnx4Ool5T62BG3KgBaWAmyPLMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SBh8gtqykJE5cq4QiHMTX3uRS7CMJbbNDTzihcNdL2GfoaP8drlNYy0taF4sl2lXd
	 3uCJTLqJdfVVeo6e/U2mZoiRM4t5WUR0cta1urx1FN4OT0F1llibzo3QXQyhPptQei
	 aAyW1NFBcZ2xZx+Jf8/fJYi9XA/X+YgL2YhxANlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kees Cook <keescook@chromium.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 174/290] rtlwifi: rtl8192de: Style clean-ups
Date: Wed,  3 Jul 2024 12:39:15 +0200
Message-ID: <20240703102910.746484662@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 69831173fcbbfebb7aa2d76523deaf0b87b8eddd ]

Clean up some style issues:
- Use ARRAY_SIZE() even though it's a u8 array.
- Remove redundant CHANNEL_MAX_NUMBER_2G define.
Additionally fix some dead code WARNs.

Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://lore.kernel.org/lkml/57d0d1b6064342309f680f692192556c@realtek.com/
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211119192233.1021063-1-keescook@chromium.org
Stable-dep-of: de4d4be4fa64 ("wifi: rtlwifi: rtl8192de: Fix 5 GHz TX power")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/realtek/rtlwifi/rtl8192de/phy.c    | 17 +++++++----------
 drivers/net/wireless/realtek/rtlwifi/wifi.h     |  1 -
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
index af0c7d74b3f5a..da9acebbe237a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -892,7 +892,7 @@ static u8 _rtl92c_phy_get_rightchnlplace(u8 chnl)
 	u8 place = chnl;
 
 	if (chnl > 14) {
-		for (place = 14; place < sizeof(channel5g); place++) {
+		for (place = 14; place < ARRAY_SIZE(channel5g); place++) {
 			if (channel5g[place] == chnl) {
 				place++;
 				break;
@@ -1359,7 +1359,7 @@ u8 rtl92d_get_rightchnlplace_for_iqk(u8 chnl)
 	u8 place = chnl;
 
 	if (chnl > 14) {
-		for (place = 14; place < sizeof(channel_all); place++) {
+		for (place = 14; place < ARRAY_SIZE(channel_all); place++) {
 			if (channel_all[place] == chnl)
 				return place - 13;
 		}
@@ -2417,7 +2417,7 @@ static bool _rtl92d_is_legal_5g_channel(struct ieee80211_hw *hw, u8 channel)
 
 	int i;
 
-	for (i = 0; i < sizeof(channel5g); i++)
+	for (i = 0; i < ARRAY_SIZE(channel5g); i++)
 		if (channel == channel5g[i])
 			return true;
 	return false;
@@ -2681,9 +2681,8 @@ void rtl92d_phy_reset_iqk_result(struct ieee80211_hw *hw)
 	u8 i;
 
 	rtl_dbg(rtlpriv, COMP_INIT, DBG_LOUD,
-		"settings regs %d default regs %d\n",
-		(int)(sizeof(rtlphy->iqk_matrix) /
-		      sizeof(struct iqk_matrix_regs)),
+		"settings regs %zu default regs %d\n",
+		ARRAY_SIZE(rtlphy->iqk_matrix),
 		IQK_MATRIX_REG_NUM);
 	/* 0xe94, 0xe9c, 0xea4, 0xeac, 0xeb4, 0xebc, 0xec4, 0xecc */
 	for (i = 0; i < IQK_MATRIX_SETTINGS_NUM; i++) {
@@ -2850,16 +2849,14 @@ u8 rtl92d_phy_sw_chnl(struct ieee80211_hw *hw)
 	case BAND_ON_5G:
 		/* Get first channel error when change between
 		 * 5G and 2.4G band. */
-		if (channel <= 14)
+		if (WARN_ONCE(channel <= 14, "rtl8192de: 5G but channel<=14\n"))
 			return 0;
-		WARN_ONCE((channel <= 14), "rtl8192de: 5G but channel<=14\n");
 		break;
 	case BAND_ON_2_4G:
 		/* Get first channel error when change between
 		 * 5G and 2.4G band. */
-		if (channel > 14)
+		if (WARN_ONCE(channel > 14, "rtl8192de: 2G but channel>14\n"))
 			return 0;
-		WARN_ONCE((channel > 14), "rtl8192de: 2G but channel>14\n");
 		break;
 	default:
 		WARN_ONCE(true, "rtl8192de: Invalid WirelessMode(%#x)!!\n",
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index a89e232d6963f..c997d8bfda975 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -108,7 +108,6 @@
 #define	CHANNEL_GROUP_IDX_5GM		6
 #define	CHANNEL_GROUP_IDX_5GH		9
 #define	CHANNEL_GROUP_MAX_5G		9
-#define CHANNEL_MAX_NUMBER_2G		14
 #define AVG_THERMAL_NUM			8
 #define AVG_THERMAL_NUM_88E		4
 #define AVG_THERMAL_NUM_8723BE		4
-- 
2.43.0



