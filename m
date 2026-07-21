Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A58415F10;
	Tue, 21 Jul 2026 22:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674644; cv=none; b=DOZ5boLgStip6u/nT9gP9CA3rvaZQXWXXH2PH2CTN/7SJ90gFRPmUzYY6XhP38KCyKWUjCV1gGRez2hs/yh4dBx7ub3Y6m9JhPviIBUuYAxetJDui/QK1BuI5JN7OP7Jv6UkNZHYbrtOgQ4LN5ykyFO0+nApIiXpqUsxGgKa7M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674644; c=relaxed/simple;
	bh=4OYmIbBNlhsO1RRX1A2HFObah4/4k4iqzuMTuvZ3/i0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iM8ZpLjGYn2i5V02RcahupH8+tZry3R6PLC4Wkrju4mARx3psOCDfJjIRHmeipTC9POWyFz13Mcsy9LYPQEWxbBeUetuhYbq9/6peZ4xL3pnWtktzR73tplroJJRf9p5Qu8jI8Im04Jl5ErPpqJ5WoarIYwlflnJae+x2hkfcjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AgE8npJD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AgE8npJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181121F000E9;
	Tue, 21 Jul 2026 22:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674642;
	bh=l/9zouENuzMnz4xNgUUyEVgmVl6TA/72HNxhYqtsueU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AgE8npJDR5tsnc8mUkw2bzSiSDbNoh/hHtt13fTlrBZSGXznLjY1JyAh9UJyIbmL2
	 kIr4yCgV9sT2dKjuvOY+YCVdJKwzT97aQZHnwiL6RkyKFVFbpHTN0n+py6mK+IhsBQ
	 UYeSZ7GKqdAFxYuuJzPlGcN+iOZdG8H88NIGYXrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Fabio Aiuto <fabioaiuto83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 617/699] staging: rtl8723bs: remove 5Ghz code related to channel plan definition
Date: Tue, 21 Jul 2026 17:26:16 +0200
Message-ID: <20260721152409.661998262@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Aiuto <fabioaiuto83@gmail.com>

[ Upstream commit ec84d0ae54a6774091b3b7d1e9da32589f48b2f9 ]

remove 5Ghz code related to channel plan definition.

Acked-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Fabio Aiuto <fabioaiuto83@gmail.com>
Link: https://lore.kernel.org/r/17a707952cec951893748d2cb59d02a294cdd1be.1624367071.git.fabioaiuto83@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: a1fc19d61f66 ("staging: rtl8723bs: fix WEP length underflow and OOB read in OnAuth()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c     |  210 +++++++++-------------
 drivers/staging/rtl8723bs/hal/hal_com_phycfg.c    |   34 ---
 drivers/staging/rtl8723bs/include/rtw_mlme_ext.h  |    6 
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c |    2 
 drivers/staging/rtl8723bs/os_dep/ioctl_linux.c    |    1 
 5 files changed, 94 insertions(+), 159 deletions(-)

--- a/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
@@ -123,93 +123,93 @@ static RT_CHANNEL_PLAN_5G	RTW_ChannelPla
 
 static RT_CHANNEL_PLAN_MAP	RTW_ChannelPlanMap[RT_CHANNEL_DOMAIN_MAX] = {
 	/*  0x00 ~ 0x1F , Old Define ===== */
-	{0x02, 0x20},	/* 0x00, RT_CHANNEL_DOMAIN_FCC */
-	{0x02, 0x0A},	/* 0x01, RT_CHANNEL_DOMAIN_IC */
-	{0x01, 0x01},	/* 0x02, RT_CHANNEL_DOMAIN_ETSI */
-	{0x01, 0x00},	/* 0x03, RT_CHANNEL_DOMAIN_SPAIN */
-	{0x01, 0x00},	/* 0x04, RT_CHANNEL_DOMAIN_FRANCE */
-	{0x03, 0x00},	/* 0x05, RT_CHANNEL_DOMAIN_MKK */
-	{0x03, 0x00},	/* 0x06, RT_CHANNEL_DOMAIN_MKK1 */
-	{0x01, 0x09},	/* 0x07, RT_CHANNEL_DOMAIN_ISRAEL */
-	{0x03, 0x09},	/* 0x08, RT_CHANNEL_DOMAIN_TELEC */
-	{0x03, 0x00},	/* 0x09, RT_CHANNEL_DOMAIN_GLOBAL_DOAMIN */
-	{0x00, 0x00},	/* 0x0A, RT_CHANNEL_DOMAIN_WORLD_WIDE_13 */
-	{0x02, 0x0F},	/* 0x0B, RT_CHANNEL_DOMAIN_TAIWAN */
-	{0x01, 0x08},	/* 0x0C, RT_CHANNEL_DOMAIN_CHINA */
-	{0x02, 0x06},	/* 0x0D, RT_CHANNEL_DOMAIN_SINGAPORE_INDIA_MEXICO */
-	{0x02, 0x0B},	/* 0x0E, RT_CHANNEL_DOMAIN_KOREA */
-	{0x02, 0x09},	/* 0x0F, RT_CHANNEL_DOMAIN_TURKEY */
-	{0x01, 0x01},	/* 0x10, RT_CHANNEL_DOMAIN_JAPAN */
-	{0x02, 0x05},	/* 0x11, RT_CHANNEL_DOMAIN_FCC_NO_DFS */
-	{0x01, 0x21},	/* 0x12, RT_CHANNEL_DOMAIN_JAPAN_NO_DFS */
-	{0x00, 0x04},	/* 0x13, RT_CHANNEL_DOMAIN_WORLD_WIDE_5G */
-	{0x02, 0x10},	/* 0x14, RT_CHANNEL_DOMAIN_TAIWAN_NO_DFS */
-	{0x00, 0x21},	/* 0x15, RT_CHANNEL_DOMAIN_ETSI_NO_DFS */
-	{0x00, 0x22},	/* 0x16, RT_CHANNEL_DOMAIN_KOREA_NO_DFS */
-	{0x03, 0x21},	/* 0x17, RT_CHANNEL_DOMAIN_JAPAN_NO_DFS */
-	{0x06, 0x08},	/* 0x18, RT_CHANNEL_DOMAIN_PAKISTAN_NO_DFS */
-	{0x02, 0x08},	/* 0x19, RT_CHANNEL_DOMAIN_TAIWAN2_NO_DFS */
-	{0x00, 0x00},	/* 0x1A, */
-	{0x00, 0x00},	/* 0x1B, */
-	{0x00, 0x00},	/* 0x1C, */
-	{0x00, 0x00},	/* 0x1D, */
-	{0x00, 0x00},	/* 0x1E, */
-	{0x06, 0x04},	/* 0x1F, RT_CHANNEL_DOMAIN_WORLD_WIDE_ONLY_5G */
+	{0x02},	/* 0x00, RT_CHANNEL_DOMAIN_FCC */
+	{0x02},	/* 0x01, RT_CHANNEL_DOMAIN_IC */
+	{0x01},	/* 0x02, RT_CHANNEL_DOMAIN_ETSI */
+	{0x01},	/* 0x03, RT_CHANNEL_DOMAIN_SPAIN */
+	{0x01},	/* 0x04, RT_CHANNEL_DOMAIN_FRANCE */
+	{0x03},	/* 0x05, RT_CHANNEL_DOMAIN_MKK */
+	{0x03},	/* 0x06, RT_CHANNEL_DOMAIN_MKK1 */
+	{0x01},	/* 0x07, RT_CHANNEL_DOMAIN_ISRAEL */
+	{0x03},	/* 0x08, RT_CHANNEL_DOMAIN_TELEC */
+	{0x03},	/* 0x09, RT_CHANNEL_DOMAIN_GLOBAL_DOAMIN */
+	{0x00},	/* 0x0A, RT_CHANNEL_DOMAIN_WORLD_WIDE_13 */
+	{0x02},	/* 0x0B, RT_CHANNEL_DOMAIN_TAIWAN */
+	{0x01},	/* 0x0C, RT_CHANNEL_DOMAIN_CHINA */
+	{0x02},	/* 0x0D, RT_CHANNEL_DOMAIN_SINGAPORE_INDIA_MEXICO */
+	{0x02},	/* 0x0E, RT_CHANNEL_DOMAIN_KOREA */
+	{0x02},	/* 0x0F, RT_CHANNEL_DOMAIN_TURKEY */
+	{0x01},	/* 0x10, RT_CHANNEL_DOMAIN_JAPAN */
+	{0x02},	/* 0x11, RT_CHANNEL_DOMAIN_FCC_NO_DFS */
+	{0x01},	/* 0x12, RT_CHANNEL_DOMAIN_JAPAN_NO_DFS */
+	{0x00},	/* 0x13, RT_CHANNEL_DOMAIN_WORLD_WIDE_5G */
+	{0x02},	/* 0x14, RT_CHANNEL_DOMAIN_TAIWAN_NO_DFS */
+	{0x00},	/* 0x15, RT_CHANNEL_DOMAIN_ETSI_NO_DFS */
+	{0x00},	/* 0x16, RT_CHANNEL_DOMAIN_KOREA_NO_DFS */
+	{0x03},	/* 0x17, RT_CHANNEL_DOMAIN_JAPAN_NO_DFS */
+	{0x06},	/* 0x18, RT_CHANNEL_DOMAIN_PAKISTAN_NO_DFS */
+	{0x02},	/* 0x19, RT_CHANNEL_DOMAIN_TAIWAN2_NO_DFS */
+	{0x00},	/* 0x1A, */
+	{0x00},	/* 0x1B, */
+	{0x00},	/* 0x1C, */
+	{0x00},	/* 0x1D, */
+	{0x00},	/* 0x1E, */
+	{0x06},	/* 0x1F, RT_CHANNEL_DOMAIN_WORLD_WIDE_ONLY_5G */
 	/*  0x20 ~ 0x7F , New Define ===== */
-	{0x00, 0x00},	/* 0x20, RT_CHANNEL_DOMAIN_WORLD_NULL */
-	{0x01, 0x00},	/* 0x21, RT_CHANNEL_DOMAIN_ETSI1_NULL */
-	{0x02, 0x00},	/* 0x22, RT_CHANNEL_DOMAIN_FCC1_NULL */
-	{0x03, 0x00},	/* 0x23, RT_CHANNEL_DOMAIN_MKK1_NULL */
-	{0x04, 0x00},	/* 0x24, RT_CHANNEL_DOMAIN_ETSI2_NULL */
-	{0x02, 0x04},	/* 0x25, RT_CHANNEL_DOMAIN_FCC1_FCC1 */
-	{0x00, 0x01},	/* 0x26, RT_CHANNEL_DOMAIN_WORLD_ETSI1 */
-	{0x03, 0x0C},	/* 0x27, RT_CHANNEL_DOMAIN_MKK1_MKK1 */
-	{0x00, 0x0B},	/* 0x28, RT_CHANNEL_DOMAIN_WORLD_KCC1 */
-	{0x00, 0x05},	/* 0x29, RT_CHANNEL_DOMAIN_WORLD_FCC2 */
-	{0x00, 0x00},	/* 0x2A, */
-	{0x00, 0x00},	/* 0x2B, */
-	{0x00, 0x00},	/* 0x2C, */
-	{0x00, 0x00},	/* 0x2D, */
-	{0x00, 0x00},	/* 0x2E, */
-	{0x00, 0x00},	/* 0x2F, */
-	{0x00, 0x06},	/* 0x30, RT_CHANNEL_DOMAIN_WORLD_FCC3 */
-	{0x00, 0x07},	/* 0x31, RT_CHANNEL_DOMAIN_WORLD_FCC4 */
-	{0x00, 0x08},	/* 0x32, RT_CHANNEL_DOMAIN_WORLD_FCC5 */
-	{0x00, 0x09},	/* 0x33, RT_CHANNEL_DOMAIN_WORLD_FCC6 */
-	{0x02, 0x0A},	/* 0x34, RT_CHANNEL_DOMAIN_FCC1_FCC7 */
-	{0x00, 0x02},	/* 0x35, RT_CHANNEL_DOMAIN_WORLD_ETSI2 */
-	{0x00, 0x03},	/* 0x36, RT_CHANNEL_DOMAIN_WORLD_ETSI3 */
-	{0x03, 0x0D},	/* 0x37, RT_CHANNEL_DOMAIN_MKK1_MKK2 */
-	{0x03, 0x0E},	/* 0x38, RT_CHANNEL_DOMAIN_MKK1_MKK3 */
-	{0x02, 0x0F},	/* 0x39, RT_CHANNEL_DOMAIN_FCC1_NCC1 */
-	{0x00, 0x00},	/* 0x3A, */
-	{0x00, 0x00},	/* 0x3B, */
-	{0x00, 0x00},	/* 0x3C, */
-	{0x00, 0x00},	/* 0x3D, */
-	{0x00, 0x00},	/* 0x3E, */
-	{0x00, 0x00},	/* 0x3F, */
-	{0x02, 0x10},	/* 0x40, RT_CHANNEL_DOMAIN_FCC1_NCC2 */
-	{0x05, 0x00},	/* 0x41, RT_CHANNEL_DOMAIN_GLOBAL_NULL */
-	{0x01, 0x12},	/* 0x42, RT_CHANNEL_DOMAIN_ETSI1_ETSI4 */
-	{0x02, 0x05},	/* 0x43, RT_CHANNEL_DOMAIN_FCC1_FCC2 */
-	{0x02, 0x11},	/* 0x44, RT_CHANNEL_DOMAIN_FCC1_NCC3 */
-	{0x00, 0x13},	/* 0x45, RT_CHANNEL_DOMAIN_WORLD_ETSI5 */
-	{0x02, 0x14},	/* 0x46, RT_CHANNEL_DOMAIN_FCC1_FCC8 */
-	{0x00, 0x15},	/* 0x47, RT_CHANNEL_DOMAIN_WORLD_ETSI6 */
-	{0x00, 0x16},	/* 0x48, RT_CHANNEL_DOMAIN_WORLD_ETSI7 */
-	{0x00, 0x17},	/* 0x49, RT_CHANNEL_DOMAIN_WORLD_ETSI8 */
-	{0x00, 0x18},	/* 0x50, RT_CHANNEL_DOMAIN_WORLD_ETSI9 */
-	{0x00, 0x19},	/* 0x51, RT_CHANNEL_DOMAIN_WORLD_ETSI10 */
-	{0x00, 0x1A},	/* 0x52, RT_CHANNEL_DOMAIN_WORLD_ETSI11 */
-	{0x02, 0x1B},	/* 0x53, RT_CHANNEL_DOMAIN_FCC1_NCC4 */
-	{0x00, 0x1C},	/* 0x54, RT_CHANNEL_DOMAIN_WORLD_ETSI12 */
-	{0x02, 0x1D},	/* 0x55, RT_CHANNEL_DOMAIN_FCC1_FCC9 */
-	{0x00, 0x1E},	/* 0x56, RT_CHANNEL_DOMAIN_WORLD_ETSI13 */
-	{0x02, 0x1F},	/* 0x57, RT_CHANNEL_DOMAIN_FCC1_FCC10 */
+	{0x00},	/* 0x20, RT_CHANNEL_DOMAIN_WORLD_NULL */
+	{0x01},	/* 0x21, RT_CHANNEL_DOMAIN_ETSI1_NULL */
+	{0x02},	/* 0x22, RT_CHANNEL_DOMAIN_FCC1_NULL */
+	{0x03},	/* 0x23, RT_CHANNEL_DOMAIN_MKK1_NULL */
+	{0x04},	/* 0x24, RT_CHANNEL_DOMAIN_ETSI2_NULL */
+	{0x02},	/* 0x25, RT_CHANNEL_DOMAIN_FCC1_FCC1 */
+	{0x00},	/* 0x26, RT_CHANNEL_DOMAIN_WORLD_ETSI1 */
+	{0x03},	/* 0x27, RT_CHANNEL_DOMAIN_MKK1_MKK1 */
+	{0x00},	/* 0x28, RT_CHANNEL_DOMAIN_WORLD_KCC1 */
+	{0x00},	/* 0x29, RT_CHANNEL_DOMAIN_WORLD_FCC2 */
+	{0x00},	/* 0x2A, */
+	{0x00},	/* 0x2B, */
+	{0x00},	/* 0x2C, */
+	{0x00},	/* 0x2D, */
+	{0x00},	/* 0x2E, */
+	{0x00},	/* 0x2F, */
+	{0x00},	/* 0x30, RT_CHANNEL_DOMAIN_WORLD_FCC3 */
+	{0x00},	/* 0x31, RT_CHANNEL_DOMAIN_WORLD_FCC4 */
+	{0x00},	/* 0x32, RT_CHANNEL_DOMAIN_WORLD_FCC5 */
+	{0x00},	/* 0x33, RT_CHANNEL_DOMAIN_WORLD_FCC6 */
+	{0x02},	/* 0x34, RT_CHANNEL_DOMAIN_FCC1_FCC7 */
+	{0x00},	/* 0x35, RT_CHANNEL_DOMAIN_WORLD_ETSI2 */
+	{0x00},	/* 0x36, RT_CHANNEL_DOMAIN_WORLD_ETSI3 */
+	{0x03},	/* 0x37, RT_CHANNEL_DOMAIN_MKK1_MKK2 */
+	{0x03},	/* 0x38, RT_CHANNEL_DOMAIN_MKK1_MKK3 */
+	{0x02},	/* 0x39, RT_CHANNEL_DOMAIN_FCC1_NCC1 */
+	{0x00},	/* 0x3A, */
+	{0x00},	/* 0x3B, */
+	{0x00},	/* 0x3C, */
+	{0x00},	/* 0x3D, */
+	{0x00},	/* 0x3E, */
+	{0x00},	/* 0x3F, */
+	{0x02},	/* 0x40, RT_CHANNEL_DOMAIN_FCC1_NCC2 */
+	{0x05},	/* 0x41, RT_CHANNEL_DOMAIN_GLOBAL_NULL */
+	{0x01},	/* 0x42, RT_CHANNEL_DOMAIN_ETSI1_ETSI4 */
+	{0x02},	/* 0x43, RT_CHANNEL_DOMAIN_FCC1_FCC2 */
+	{0x02},	/* 0x44, RT_CHANNEL_DOMAIN_FCC1_NCC3 */
+	{0x00},	/* 0x45, RT_CHANNEL_DOMAIN_WORLD_ETSI5 */
+	{0x02},	/* 0x46, RT_CHANNEL_DOMAIN_FCC1_FCC8 */
+	{0x00},	/* 0x47, RT_CHANNEL_DOMAIN_WORLD_ETSI6 */
+	{0x00},	/* 0x48, RT_CHANNEL_DOMAIN_WORLD_ETSI7 */
+	{0x00},	/* 0x49, RT_CHANNEL_DOMAIN_WORLD_ETSI8 */
+	{0x00},	/* 0x50, RT_CHANNEL_DOMAIN_WORLD_ETSI9 */
+	{0x00},	/* 0x51, RT_CHANNEL_DOMAIN_WORLD_ETSI10 */
+	{0x00},	/* 0x52, RT_CHANNEL_DOMAIN_WORLD_ETSI11 */
+	{0x02},	/* 0x53, RT_CHANNEL_DOMAIN_FCC1_NCC4 */
+	{0x00},	/* 0x54, RT_CHANNEL_DOMAIN_WORLD_ETSI12 */
+	{0x02},	/* 0x55, RT_CHANNEL_DOMAIN_FCC1_FCC9 */
+	{0x00},	/* 0x56, RT_CHANNEL_DOMAIN_WORLD_ETSI13 */
+	{0x02},	/* 0x57, RT_CHANNEL_DOMAIN_FCC1_FCC10 */
 };
 
  /* use the combination for max channel numbers */
-static RT_CHANNEL_PLAN_MAP RTW_CHANNEL_PLAN_MAP_REALTEK_DEFINE = {0x03, 0x02};
+static RT_CHANNEL_PLAN_MAP RTW_CHANNEL_PLAN_MAP_REALTEK_DEFINE = {0x03};
 
 /* Search the @param ch in given @param ch_set
  * @ch_set: the given channel set
@@ -231,23 +231,6 @@ int rtw_ch_set_search_ch(RT_CHANNEL_INFO
 	return i;
 }
 
-/* Check the @param ch is fit with setband setting of @param adapter
- * @adapter: the given adapter
- * @ch: the given channel number
- *
- * return true when check valid, false not valid
- */
-bool rtw_mlme_band_check(struct adapter *adapter, const u32 ch)
-{
-	if (adapter->setband == GHZ24_50 /* 2.4G and 5G */
-		|| (adapter->setband == GHZ_24 && ch < 35) /* 2.4G only */
-		|| (adapter->setband == GHZ_50 && ch > 35) /* 5G only */
-	) {
-		return true;
-	}
-	return false;
-}
-
 /****************************************************************************
 
 Following are the initialization functions for WiFi MLME
@@ -424,7 +407,6 @@ static u8 init_channel_set(struct adapte
 				else if ((channel_set[chanset_size].ChannelNum  >= 12 && channel_set[chanset_size].ChannelNum  <= 14))
 					channel_set[chanset_size].ScanType  = SCAN_PASSIVE;
 			} else if (RT_CHANNEL_DOMAIN_WORLD_WIDE_13 == ChannelPlan ||
-				RT_CHANNEL_DOMAIN_WORLD_WIDE_5G == ChannelPlan ||
 				RT_CHANNEL_DOMAIN_2G_WORLD == Index2G) { /*  channel 12~13, passive scan */
 				if (channel_set[chanset_size].ChannelNum <= 11)
 					channel_set[chanset_size].ScanType = SCAN_ACTIVE;
@@ -4938,10 +4920,6 @@ static void process_80211d(struct adapte
 	while ((i < MAX_CHANNEL_NUM) && (chplan_new[i].ChannelNum != 0)) {
 		if (chplan_new[i].ChannelNum == channel) {
 			if (chplan_new[i].ScanType == SCAN_PASSIVE) {
-				/* 5G Bnad 2, 3 (DFS) doesn't change to active scan */
-				if (channel >= 52 && channel <= 144)
-					break;
-
 				chplan_new[i].ScanType = SCAN_ACTIVE;
 				RT_TRACE(_module_rtl871x_mlme_c_, _drv_notice_,
 						 ("%s: change channel %d scan type from passive to active\n",
@@ -6250,7 +6228,6 @@ static int rtw_scan_ch_decision(struct a
 		set_idx = rtw_ch_set_search_ch(pmlmeext->channel_set, in[i].hw_value);
 		if (in[i].hw_value && !(in[i].flags & RTW_IEEE80211_CHAN_DISABLED)
 			&& set_idx >= 0
-			&& rtw_mlme_band_check(padapter, in[i].hw_value)
 		) {
 			if (j >= out_num) {
 				DBG_871X_LEVEL(_drv_always_, FUNC_ADPT_FMT" out_num:%u not enough\n",
@@ -6275,21 +6252,18 @@ static int rtw_scan_ch_decision(struct a
 
 			DBG_871X(FUNC_ADPT_FMT" ch:%u\n", FUNC_ADPT_ARG(padapter), pmlmeext->channel_set[i].ChannelNum);
 
-			if (rtw_mlme_band_check(padapter, pmlmeext->channel_set[i].ChannelNum)) {
-
-				if (j >= out_num) {
-					DBG_871X_LEVEL(_drv_always_, FUNC_ADPT_FMT" out_num:%u not enough\n",
-						FUNC_ADPT_ARG(padapter), out_num);
-					break;
-				}
+			if (j >= out_num) {
+				DBG_871X_LEVEL(_drv_always_, FUNC_ADPT_FMT" out_num:%u not enough\n",
+					FUNC_ADPT_ARG(padapter), out_num);
+				break;
+			}
 
-				out[j].hw_value = pmlmeext->channel_set[i].ChannelNum;
+			out[j].hw_value = pmlmeext->channel_set[i].ChannelNum;
 
-				if (pmlmeext->channel_set[i].ScanType == SCAN_PASSIVE)
-					out[j].flags |= RTW_IEEE80211_CHAN_PASSIVE_SCAN;
+			if (pmlmeext->channel_set[i].ScanType == SCAN_PASSIVE)
+				out[j].flags |= RTW_IEEE80211_CHAN_PASSIVE_SCAN;
 
-				j++;
-			}
+			j++;
 		}
 	}
 
--- a/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c
+++ b/drivers/staging/rtl8723bs/hal/hal_com_phycfg.c
@@ -2062,139 +2062,105 @@ void Hal_ChannelPlanToRegulation(struct
 		break;
 	case RT_CHANNEL_DOMAIN_FCC1_FCC1:
 		pHalData->Regulation2_4G = TXPWR_LMT_FCC;
-		pHalData->Regulation5G = TXPWR_LMT_FCC;
 		break;
 	case RT_CHANNEL_DOMAIN_WORLD_ETSI1:
 		pHalData->Regulation2_4G = TXPWR_LMT_FCC;
-		pHalData->Regulation5G = TXPWR_LMT_ETSI;
 		break;
 	case RT_CHANNEL_DOMAIN_MKK1_MKK1:
 		pHalData->Regulation2_4G = TXPWR_LMT_MKK;
-		pHalData->Regulation5G = TXPWR_LMT_MKK;
 		break;
 	case RT_CHANNEL_DOMAIN_WORLD_KCC1:
 		pHalData->Regulation2_4G = TXPWR_LMT_FCC;
-		pHalData->Regulation5G = TXPWR_LMT_MKK;
 		break;
 	case RT_CHANNEL_DOMAIN_WORLD_FCC2:
 		pHalData->Regulation2_4G = TXPWR_LMT_FCC;
-		pHalData->Regulation5G = TXPWR_LMT_FCC;
 		break;
 	case RT_CHANNEL_DOMAIN_WORLD_FCC3:
 		pHalData->Regulation2_4G = TXPWR_LMT_FCC;
-		pHalData->Regulation5G = TXPWR_LMT_FCC;
 		break;
 	case RT_CHANNEL_DOMAIN_WORLD_FCC4:
 		pHalData->Regulation2_4G = TXPWR_LMT_FCC;
-		pHalData->Regulation5G = TXPWR_LMT_FCC;
 		break;
 	case RT_CHANNEL_DOMAIN_WORLD_FCC5:
 		pHalData->Regulation2_4G = TXPWR_LMT_FCC;
-		pHalData->Regulation5G = TXPWR_LMT_FCC;
 		break;
 	case RT_CHANNEL_DOMAIN_WORLD_FCC6:
 		pHalData->Regulation2_4G = TXPWR_LMT_FCC;
-		pHalData->Regulation5G = TXPWR_LMT_FCC;
 		break;
 	case RT_CHANNEL_DOMAIN_FCC1_FCC7:
 		pHalData->Regulation2_4G = TXPWR_LMT_FCC;
-		pHalData->Regulation5G = TXPWR_LMT_FCC;
 		break;
 	case RT_CHANNEL_DOMAIN_WORLD_ETSI2:
 		pHalData->Regulation2_4G = TXPWR_LMT_FCC;
-		pHalData->Regulation5G = TXPWR_LMT_FCC;
 		break;
 	case RT_CHANNEL_DOMAIN_WORLD_ETSI3:
 		pHalData->Regulation2_4G = TXPWR_LMT_FCC;
-		pHalData->Regulation5G = TXPWR_LMT_FCC;
 		break;
 	case RT_CHANNEL_DOMAIN_MKK1_MKK2:
 		pHalData->Regulation2_4G = TXPWR_LMT_MKK;
-		pHalData->Regulation5G = TXPWR_LMT_FCC;
 		break;
 	case RT_CHANNEL_DOMAIN_MKK1_MKK3:
 		pHalData->Regulation2_4G = TXPWR_LMT_MKK;
-		pHalData->Regulation5G = TXPWR_LMT_FCC;
 		break;
 	case RT_CHANNEL_DOMAIN_FCC1_NCC1:
 		pHalData->Regulation2_4G = TXPWR_LMT_FCC;
-		pHalData->Regulation5G = TXPWR_LMT_FCC;
 		break;
 	case RT_CHANNEL_DOMAIN_FCC1_NCC2:
 		pHalData->Regulation2_4G = TXPWR_LMT_FCC;
-		pHalData->Regulation5G = TXPWR_LMT_FCC;
 		break;
 	case RT_CHANNEL_DOMAIN_GLOBAL_NULL:
 		pHalData->Regulation2_4G = TXPWR_LMT_WW;
-		pHalData->Regulation5G = TXPWR_LMT_WW;
 		break;
 	case RT_CHANNEL_DOMAIN_ETSI1_ETSI4:
 		pHalData->Regulation2_4G = TXPWR_LMT_ETSI;
-		pHalData->Regulation5G = TXPWR_LMT_ETSI;
 		break;
 	case RT_CHANNEL_DOMAIN_FCC1_FCC2:
 		pHalData->Regulation2_4G = TXPWR_LMT_FCC;
-		pHalData->Regulation5G = TXPWR_LMT_FCC;
 		break;
 	case RT_CHANNEL_DOMAIN_FCC1_NCC3:
 		pHalData->Regulation2_4G = TXPWR_LMT_FCC;
-		pHalData->Regulation5G = TXPWR_LMT_FCC;
 		break;
 	case RT_CHANNEL_DOMAIN_WORLD_ETSI5:
 		pHalData->Regulation2_4G = TXPWR_LMT_ETSI;
-		pHalData->Regulation5G = TXPWR_LMT_ETSI;
 		break;
 	case RT_CHANNEL_DOMAIN_FCC1_FCC8:
 		pHalData->Regulation2_4G = TXPWR_LMT_FCC;
-		pHalData->Regulation5G = TXPWR_LMT_FCC;
 		break;
 	case RT_CHANNEL_DOMAIN_WORLD_ETSI6:
 		pHalData->Regulation2_4G = TXPWR_LMT_ETSI;
-		pHalData->Regulation5G = TXPWR_LMT_ETSI;
 		break;
 	case RT_CHANNEL_DOMAIN_WORLD_ETSI7:
 		pHalData->Regulation2_4G = TXPWR_LMT_ETSI;
-		pHalData->Regulation5G = TXPWR_LMT_ETSI;
 		break;
 	case RT_CHANNEL_DOMAIN_WORLD_ETSI8:
 		pHalData->Regulation2_4G = TXPWR_LMT_ETSI;
-		pHalData->Regulation5G = TXPWR_LMT_ETSI;
 		break;
 	case RT_CHANNEL_DOMAIN_WORLD_ETSI9:
 		pHalData->Regulation2_4G = TXPWR_LMT_ETSI;
-		pHalData->Regulation5G = TXPWR_LMT_ETSI;
 		break;
 	case RT_CHANNEL_DOMAIN_WORLD_ETSI10:
 		pHalData->Regulation2_4G = TXPWR_LMT_ETSI;
-		pHalData->Regulation5G = TXPWR_LMT_ETSI;
 		break;
 	case RT_CHANNEL_DOMAIN_WORLD_ETSI11:
 		pHalData->Regulation2_4G = TXPWR_LMT_ETSI;
-		pHalData->Regulation5G = TXPWR_LMT_ETSI;
 		break;
 	case RT_CHANNEL_DOMAIN_FCC1_NCC4:
 		pHalData->Regulation2_4G = TXPWR_LMT_FCC;
-		pHalData->Regulation5G = TXPWR_LMT_FCC;
 		break;
 	case RT_CHANNEL_DOMAIN_WORLD_ETSI12:
 		pHalData->Regulation2_4G = TXPWR_LMT_ETSI;
-		pHalData->Regulation5G = TXPWR_LMT_ETSI;
 		break;
 	case RT_CHANNEL_DOMAIN_FCC1_FCC9:
 		pHalData->Regulation2_4G = TXPWR_LMT_FCC;
-		pHalData->Regulation5G = TXPWR_LMT_FCC;
 		break;
 	case RT_CHANNEL_DOMAIN_WORLD_ETSI13:
 		pHalData->Regulation2_4G = TXPWR_LMT_ETSI;
-		pHalData->Regulation5G = TXPWR_LMT_ETSI;
 		break;
 	case RT_CHANNEL_DOMAIN_FCC1_FCC10:
 		pHalData->Regulation2_4G = TXPWR_LMT_FCC;
-		pHalData->Regulation5G = TXPWR_LMT_FCC;
 		break;
 	case RT_CHANNEL_DOMAIN_REALTEK_DEFINE: /* Realtek Reserve */
 		pHalData->Regulation2_4G = TXPWR_LMT_WW;
-		pHalData->Regulation5G = TXPWR_LMT_WW;
 		break;
 	default:
 		break;
--- a/drivers/staging/rtl8723bs/include/rtw_mlme_ext.h
+++ b/drivers/staging/rtl8723bs/include/rtw_mlme_ext.h
@@ -255,7 +255,6 @@ typedef struct _RT_CHANNEL_PLAN_5G {
 
 typedef struct _RT_CHANNEL_PLAN_MAP {
 	unsigned char Index2G;
-	unsigned char Index5G;
 } RT_CHANNEL_PLAN_MAP, *PRT_CHANNEL_PLAN_MAP;
 
 enum Associated_AP {
@@ -360,13 +359,13 @@ struct FW_Sta_Info {
  * When the driver scanned RTW_SCAN_NUM_OF_CH channels, it would switch back to AP's operating channel for
  * RTW_STAY_AP_CH_MILLISECOND * SURVEY_TO milliseconds.
  * Example:
- * For chip supports 2.4G + 5GHz and AP mode is operating in channel 1,
+ * For chip supports 2.4G and AP mode is operating in channel 1,
  * RTW_SCAN_NUM_OF_CH is 8, RTW_STAY_AP_CH_MILLISECOND is 3 and SURVEY_TO is 100.
  * When it's STA mode gets set_scan command,
  * it would
  * 1. Doing the scan on channel 1.2.3.4.5.6.7.8
  * 2. Back to channel 1 for 300 milliseconds
- * 3. Go through doing site survey on channel 9.10.11.36.40.44.48.52
+ * 3. Go through doing site survey on channel 9.10.11
  * 4. Back to channel 1 for 300 milliseconds
  * 5. ... and so on, till survey done.
  */
@@ -423,7 +422,6 @@ typedef struct _RT_CHANNEL_INFO {
 } RT_CHANNEL_INFO, *PRT_CHANNEL_INFO;
 
 int rtw_ch_set_search_ch(RT_CHANNEL_INFO *ch_set, const u32 ch);
-bool rtw_mlme_band_check(struct adapter *adapter, const u32 ch);
 
 /*  P2P_MAX_REG_CLASSES - Maximum number of regulatory classes */
 #define P2P_MAX_REG_CLASSES 10
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
@@ -77,7 +77,6 @@ static struct ieee80211_rate rtw_rates[]
 #define RTW_G_RATES_NUM	12
 
 #define RTW_2G_CHANNELS_NUM 14
-#define RTW_5G_CHANNELS_NUM 37
 
 static struct ieee80211_channel rtw_2ghz_channels[] = {
 	CHAN2G(1, 2412, 0),
@@ -1422,7 +1421,6 @@ void rtw_cfg80211_surveydone_event_callb
 
 		/* report network only if the current channel set contains the channel to which this network belongs */
 		if (rtw_ch_set_search_ch(padapter->mlmeextpriv.channel_set, pnetwork->network.Configuration.DSConfig) >= 0
-			&& rtw_mlme_band_check(padapter, pnetwork->network.Configuration.DSConfig) == true
 			&& true == rtw_validate_ssid(&(pnetwork->network.Ssid))
 		)
 		{
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
@@ -1462,7 +1462,6 @@ static int rtw_wx_get_scan(struct net_de
 
 		/* report network only if the current channel set contains the channel to which this network belongs */
 		if (rtw_ch_set_search_ch(padapter->mlmeextpriv.channel_set, pnetwork->network.Configuration.DSConfig) >= 0
-			&& rtw_mlme_band_check(padapter, pnetwork->network.Configuration.DSConfig) == true
 			&& true == rtw_validate_ssid(&(pnetwork->network.Ssid))) {
 
 			ev = translate_scan(padapter, a, pnetwork, ev, stop);


