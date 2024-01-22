Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6AFE56B;
	Tue, 23 Jan 2024 00:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968324; cv=none; b=WQQrsC8gSrVH+RsIpAYCSxQ/td/t8BX7948OQKClLuOv3utPzb5fgARmQsBnb4ugY2dL/4jJmcqUz0GcaBrGXpvNNRT6zPWrPepIJEn9JgfIwl6znoXVlWM3QZfHGz5ymUje63b/JXkZAhXDabCg+5jMQSdYWLl7wLwFjhDA2Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968324; c=relaxed/simple;
	bh=/esWz8hMsPPbU8eJbuoN4uOg1CCeGJAHFSaI+PPtxJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EOHQAH+2P8uSbV9q8DZSWABvUo+aMjxwgPWHG6if/oiv4V/vDZHgzE6DnRmFAvnzEBWWO9MlLbZZSEpZvKBOnkwscubx0hRQeT/ZmY2f2FDPR4jK0qfYSlKxri7vlg7cP0MAlTOt1V9ef9etOwWtQG5c23pm9fTL7zcb8YjFYLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=acqdv3xu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="acqdv3xu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F889C43390;
	Tue, 23 Jan 2024 00:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968323;
	bh=/esWz8hMsPPbU8eJbuoN4uOg1CCeGJAHFSaI+PPtxJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=acqdv3xuPR3H7HboCisNKrk+yEQogHnzFBLyJkBvB0sTDh0+F/3JLNnAYrk+T7WJW
	 anYdg1iteBD5jEnkNvP0FSORXFz/Mqqhp3UecrahyBRNESboseLVt9te0nRuR48OPw
	 LLW2UT6Q7fnodVxKLI4izuktUZRzTCb05G6gxwww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.king@canonical.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 079/148] rtlwifi: rtl8192de: make arrays static const, makes object smaller
Date: Mon, 22 Jan 2024 15:57:15 -0800
Message-ID: <20240122235715.606150752@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 5ff48b47f6ff..89b473caa5f8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -182,6 +182,15 @@ static u32 targetchnl_2g[TARGET_CHNL_NUM_2G] = {
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
@@ -1378,14 +1387,6 @@ static void _rtl92d_phy_switch_rf_setting(struct ieee80211_hw *hw, u8 channel)
 
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
@@ -3240,37 +3241,28 @@ void rtl92d_phy_config_macphymode_info(struct ieee80211_hw *hw)
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



