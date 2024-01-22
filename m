Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574C414534E;
	Tue, 23 Jan 2024 00:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968284; cv=none; b=SFBT6uhXtv3JjZakUVz+7vCximP5zcVfq9QMeTAbw7OyREB/2MEjZiQTqeXYIqad4qU6CEx94TX86Mei7d6Mm7Zubl7huKau4IyGpFboZwuHCw1TNt5/wPFwb2slNmPrAVzGEU3dnk9t87BJvSxOkbAXFidlLS0o3Ji0YZy3XBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968284; c=relaxed/simple;
	bh=PeOm8k68yvJC/7/FROwRaBxmykenGNJefcUCd29IJJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdDml31aVsjMBka1KbwMoVvPrVDyPExVO4hOAarzex2/Y6su0fsUpW4BKdjxwTbDPHsao18MrhN9zhrBNVAJvo7kSO3OztQdy5rtMQrlK0zHiw8o7LeGs2mhMg9xDNbEeIPdvqGw1xkRdo6wEmGNJrb+yvk+PhB6HbwCafibRuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bNkXeEPf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bNkXeEPf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9F1C43399;
	Tue, 23 Jan 2024 00:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968284;
	bh=PeOm8k68yvJC/7/FROwRaBxmykenGNJefcUCd29IJJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bNkXeEPf1hyXiwxQy3JaI7g+q9DpqlStWsCv1yz8NQBH2nl6oGDn2Q8j4y1WfJ++9
	 auF+6zYcq3pG3LdX4xT5cCZXf3JI6EKNCQFJXeSuWpKFfyQ8xhusk2b9SxVMWLLNra
	 uYJCTvVLeBEiWAuDeE2h5cphOac0Nz8fE9lxhYOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Perches <joe@perches.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 070/148] rtlwifi: Use ffs in <foo>_phy_calculate_bit_shift
Date: Mon, 22 Jan 2024 15:57:06 -0800
Message-ID: <20240122235715.226777987@linuxfoundation.org>
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

From: Joe Perches <joe@perches.com>

[ Upstream commit 6c1d61913570d4255548ac598cfbef6f1e3c3eee ]

Remove the loop and use the generic ffs instead.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/e2ab424d24b74901bc0c39f0c60f75e871adf2ba.camel@perches.com
Stable-dep-of: bc8263083af6 ("wifi: rtlwifi: rtl8821ae: phy: fix an undefined bitwise shift behavior")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/realtek/rtlwifi/rtl8188ee/phy.c   | 18 ++++++------------
 .../realtek/rtlwifi/rtl8192c/phy_common.c      |  8 ++------
 .../wireless/realtek/rtlwifi/rtl8192de/phy.c   |  9 ++-------
 .../wireless/realtek/rtlwifi/rtl8192ee/phy.c   |  8 ++------
 .../wireless/realtek/rtlwifi/rtl8192se/phy.c   |  9 ++-------
 .../realtek/rtlwifi/rtl8723com/phy_common.c    |  8 ++------
 .../wireless/realtek/rtlwifi/rtl8821ae/phy.c   | 18 ++++++------------
 7 files changed, 22 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
index 14a256062614..5bbb46f37e71 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c
@@ -38,7 +38,12 @@ static u32 _rtl88e_phy_rf_serial_read(struct ieee80211_hw *hw,
 static void _rtl88e_phy_rf_serial_write(struct ieee80211_hw *hw,
 					enum radio_path rfpath, u32 offset,
 					u32 data);
-static u32 _rtl88e_phy_calculate_bit_shift(u32 bitmask);
+static u32 _rtl88e_phy_calculate_bit_shift(u32 bitmask)
+{
+	u32 i = ffs(bitmask);
+
+	return i ? i - 1 : 32;
+}
 static bool _rtl88e_phy_bb8188e_config_parafile(struct ieee80211_hw *hw);
 static bool _rtl88e_phy_config_mac_with_headerfile(struct ieee80211_hw *hw);
 static bool phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
@@ -232,17 +237,6 @@ static void _rtl88e_phy_rf_serial_write(struct ieee80211_hw *hw,
 		 rfpath, pphyreg->rf3wire_offset, data_and_addr);
 }
 
-static u32 _rtl88e_phy_calculate_bit_shift(u32 bitmask)
-{
-	u32 i;
-
-	for (i = 0; i <= 31; i++) {
-		if (((bitmask >> i) & 0x1) == 1)
-			break;
-	}
-	return i;
-}
-
 bool rtl88e_phy_mac_config(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c
index 7c6e5d91439d..7ebd4d60482e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c
@@ -167,13 +167,9 @@ EXPORT_SYMBOL(_rtl92c_phy_rf_serial_write);
 
 u32 _rtl92c_phy_calculate_bit_shift(u32 bitmask)
 {
-	u32 i;
+	u32 i = ffs(bitmask);
 
-	for (i = 0; i <= 31; i++) {
-		if (((bitmask >> i) & 0x1) == 1)
-			break;
-	}
-	return i;
+	return i ? i - 1 : 32;
 }
 EXPORT_SYMBOL(_rtl92c_phy_calculate_bit_shift);
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
index 53734250479c..5ff48b47f6ff 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -184,14 +184,9 @@ static u32 targetchnl_2g[TARGET_CHNL_NUM_2G] = {
 
 static u32 _rtl92d_phy_calculate_bit_shift(u32 bitmask)
 {
-	u32 i;
-
-	for (i = 0; i <= 31; i++) {
-		if (((bitmask >> i) & 0x1) == 1)
-			break;
-	}
+	u32 i = ffs(bitmask);
 
-	return i;
+	return i ? i - 1 : 32;
 }
 
 u32 rtl92d_phy_query_bb_reg(struct ieee80211_hw *hw, u32 regaddr, u32 bitmask)
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
index 8b072ee8e0d5..7aeff442bd06 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c
@@ -228,13 +228,9 @@ static void _rtl92ee_phy_rf_serial_write(struct ieee80211_hw *hw,
 
 static u32 _rtl92ee_phy_calculate_bit_shift(u32 bitmask)
 {
-	u32 i;
+	u32 i = ffs(bitmask);
 
-	for (i = 0; i <= 31; i++) {
-		if (((bitmask >> i) & 0x1) == 1)
-			break;
-	}
-	return i;
+	return i ? i - 1 : 32;
 }
 
 bool rtl92ee_phy_mac_config(struct ieee80211_hw *hw)
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
index 86cb853f7169..dfc96126a356 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/phy.c
@@ -38,14 +38,9 @@
 
 static u32 _rtl92s_phy_calculate_bit_shift(u32 bitmask)
 {
-	u32 i;
-
-	for (i = 0; i <= 31; i++) {
-		if (((bitmask >> i) & 0x1) == 1)
-			break;
-	}
+	u32 i = ffs(bitmask);
 
-	return i;
+	return i ? i - 1 : 32;
 }
 
 u32 rtl92s_phy_query_bb_reg(struct ieee80211_hw *hw, u32 regaddr, u32 bitmask)
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/phy_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/phy_common.c
index 43d24e1ee5e6..af9cd74e09d4 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723com/phy_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723com/phy_common.c
@@ -75,13 +75,9 @@ EXPORT_SYMBOL_GPL(rtl8723_phy_set_bb_reg);
 
 u32 rtl8723_phy_calculate_bit_shift(u32 bitmask)
 {
-	u32 i;
+	u32 i = ffs(bitmask);
 
-	for (i = 0; i <= 31; i++) {
-		if (((bitmask >> i) & 0x1) == 1)
-			break;
-	}
-	return i;
+	return i ? i - 1 : 32;
 }
 EXPORT_SYMBOL_GPL(rtl8723_phy_calculate_bit_shift);
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index 502ac10cf251..9ec62fff6f1a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -49,7 +49,12 @@ static u32 _rtl8821ae_phy_rf_serial_read(struct ieee80211_hw *hw,
 static void _rtl8821ae_phy_rf_serial_write(struct ieee80211_hw *hw,
 					   enum radio_path rfpath, u32 offset,
 					   u32 data);
-static u32 _rtl8821ae_phy_calculate_bit_shift(u32 bitmask);
+static u32 _rtl8821ae_phy_calculate_bit_shift(u32 bitmask)
+{
+	u32 i = ffs(bitmask);
+
+	return i ? i - 1 : 32;
+}
 static bool _rtl8821ae_phy_bb8821a_config_parafile(struct ieee80211_hw *hw);
 /*static bool _rtl8812ae_phy_config_mac_with_headerfile(struct ieee80211_hw *hw);*/
 static bool _rtl8821ae_phy_config_mac_with_headerfile(struct ieee80211_hw *hw);
@@ -296,17 +301,6 @@ static void _rtl8821ae_phy_rf_serial_write(struct ieee80211_hw *hw,
 		 rfpath, pphyreg->rf3wire_offset, data_and_addr);
 }
 
-static u32 _rtl8821ae_phy_calculate_bit_shift(u32 bitmask)
-{
-	u32 i;
-
-	for (i = 0; i <= 31; i++) {
-		if (((bitmask >> i) & 0x1) == 1)
-			break;
-	}
-	return i;
-}
-
 bool rtl8821ae_phy_mac_config(struct ieee80211_hw *hw)
 {
 	bool rtstatus = 0;
-- 
2.43.0



