Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EFE12CDBB;
	Tue, 23 Jan 2024 00:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968978; cv=none; b=i29NtvVILiZidcmEm9xOv2zrxL3Z898vEAMrRyjWPtwxI6DYU/gOORsZojzTfdOXQQ7O5/MztoBYAon1XhAWeXXNjNVDWv6g8bRAmjRDzcYaSrLFOE4LGBOnaV37CW0venSj1FoSualANnTx1mRMwClnpcosau+qGgfDXWt9au8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968978; c=relaxed/simple;
	bh=fmovU0Ly8TaJgd2hX1hqJJKBK7zQrnjvI9mUg2aGSiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g5Z4HDX7nhQ+3lxXhn49n6mgzx5VQKDT/pP1xw90AkPaS2UvhTBapciV2c6koDTd6yKo0dLkbteXRey4t9QMp6if5U/f52pbokNqX21mKMcgrTVAtm/yraQm2EXZnU20PubQf6/YN0WtktRrZv37B4+VexTNpZ0PYHtYFqAUoKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NEsOru52; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NEsOru52"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F85C433C7;
	Tue, 23 Jan 2024 00:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968977;
	bh=fmovU0Ly8TaJgd2hX1hqJJKBK7zQrnjvI9mUg2aGSiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NEsOru52YjOLjs6GQXj3gMVUWcJd9kEPKlW+FoODIeIa6ASBn1MjOQsm4qJhvV3MS
	 s/6TwYHe7aPkg1ThHyIgAyBdNcbbAv9+LhJOLdjXoil5fcn6AAr4mOOOFfucixws3i
	 5+/SzKiUlngloDsypTP8Onykjpw+rTmeFIMleRXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.king@canonical.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 100/194] rtlwifi: rtl8192de: make arrays static const, makes object smaller
Date: Mon, 22 Jan 2024 15:57:10 -0800
Message-ID: <20240122235723.526097238@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit b05897ca8c821a16ac03850c4704fe460b3f21a0 ]

Don't populate arrays the stack but instead make them static const. Replace
array channel_info with channel_all since it contains the same data as
channel_all. Makes object code smaller by 961 bytes.

Before:
   text	   data	    bss	    dec	   hex	filename
 128147	  44250	   1024	 173421	 2a56d	../realtek/rtlwifi/rtl8192de/phy.o

After
   text	   data	    bss	    dec	   hex	filename
 127122	  44314	   1024	 172460	 2a1ac	../realtek/rtlwifi/rtl8192de/phy.o

(gcc version 10.2.0)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210803144949.79433-2-colin.king@canonical.com
Stable-dep-of: b8b2baad2e65 ("wifi: rtlwifi: rtl8192de: using calculate_bit_shift()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/realtek/rtlwifi/rtl8192de/phy.c  | 48 ++++++++-----------
 1 file changed, 20 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
index db4f8fde0f17..7ba2aeaf071f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -160,6 +160,15 @@ static u32 targetchnl_2g[TARGET_CHNL_NUM_2G] = {
 	25711, 25658, 25606, 25554, 25502, 25451, 25328
 };
 
+static const u8 channel_all[59] = {
+	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
+	36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58,
+	60, 62, 64, 100, 102, 104, 106, 108, 110, 112,
+	114, 116, 118, 120, 122, 124, 126, 128,	130,
+	132, 134, 136, 138, 140, 149, 151, 153, 155,
+	157, 159, 161, 163, 165
+};
+
 static u32 _rtl92d_phy_calculate_bit_shift(u32 bitmask)
 {
 	u32 i = ffs(bitmask);
@@ -1356,14 +1365,6 @@ static void _rtl92d_phy_switch_rf_setting(struct ieee80211_hw *hw, u8 channel)
 
 u8 rtl92d_get_rightchnlplace_for_iqk(u8 chnl)
 {
-	u8 channel_all[59] = {
-		1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
-		36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58,
-		60, 62, 64, 100, 102, 104, 106, 108, 110, 112,
-		114, 116, 118, 120, 122, 124, 126, 128,	130,
-		132, 134, 136, 138, 140, 149, 151, 153, 155,
-		157, 159, 161, 163, 165
-	};
 	u8 place = chnl;
 
 	if (chnl > 14) {
@@ -3218,37 +3219,28 @@ void rtl92d_phy_config_macphymode_info(struct ieee80211_hw *hw)
 u8 rtl92d_get_chnlgroup_fromarray(u8 chnl)
 {
 	u8 group;
-	u8 channel_info[59] = {
-		1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
-		36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56,
-		58, 60, 62, 64, 100, 102, 104, 106, 108,
-		110, 112, 114, 116, 118, 120, 122, 124,
-		126, 128, 130, 132, 134, 136, 138, 140,
-		149, 151, 153, 155, 157, 159, 161, 163,
-		165
-	};
 
-	if (channel_info[chnl] <= 3)
+	if (channel_all[chnl] <= 3)
 		group = 0;
-	else if (channel_info[chnl] <= 9)
+	else if (channel_all[chnl] <= 9)
 		group = 1;
-	else if (channel_info[chnl] <= 14)
+	else if (channel_all[chnl] <= 14)
 		group = 2;
-	else if (channel_info[chnl] <= 44)
+	else if (channel_all[chnl] <= 44)
 		group = 3;
-	else if (channel_info[chnl] <= 54)
+	else if (channel_all[chnl] <= 54)
 		group = 4;
-	else if (channel_info[chnl] <= 64)
+	else if (channel_all[chnl] <= 64)
 		group = 5;
-	else if (channel_info[chnl] <= 112)
+	else if (channel_all[chnl] <= 112)
 		group = 6;
-	else if (channel_info[chnl] <= 126)
+	else if (channel_all[chnl] <= 126)
 		group = 7;
-	else if (channel_info[chnl] <= 140)
+	else if (channel_all[chnl] <= 140)
 		group = 8;
-	else if (channel_info[chnl] <= 153)
+	else if (channel_all[chnl] <= 153)
 		group = 9;
-	else if (channel_info[chnl] <= 159)
+	else if (channel_all[chnl] <= 159)
 		group = 10;
 	else
 		group = 11;
-- 
2.43.0



