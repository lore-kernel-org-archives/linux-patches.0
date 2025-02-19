Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9AC1DE889;
	Wed, 19 Feb 2025 09:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956144; cv=none; b=nH4HXI4Lye5P0qT+UeSt2ab+m3S2vI6N2o/CmZEpXjahQpdrVUaCKy64psdIM5Whx974LEU1XAQ1GcE+Wljhfaox0HgSZ7Bg100z5FIAQD72qci5o721LKgtP/quoMgSKV4hRNKq8rYltMxd1EuhGjGunRC27JTfGaVMQpdhb3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956144; c=relaxed/simple;
	bh=JXupe+ugzTuV7ix72bAn6Aeu8cFf21xIssZd4vt0PWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0EA0G8BXNljCZuyE8HWcl7QHltnh6W4wmMfveEFjM25ZZrVv2k16ixHsRuNyemDxTdLns8jpdbDnwFGsDDpbMpNL4zsuTov4l3Hm7KVZi3LKYVu5/EnmHHynIF/Q4Wzx7eEKqkastNEODyJJh8e6UhciaJG6tAIn78svCI3Pmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HqEiyEN0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HqEiyEN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893F1C4CED1;
	Wed, 19 Feb 2025 09:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956143;
	bh=JXupe+ugzTuV7ix72bAn6Aeu8cFf21xIssZd4vt0PWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HqEiyEN0DTunxZgcm8QH58QkzJ1JUzpqDhUMadwPoq68RQjNJ/pnOZVasmp0+Wpz7
	 eAU7G+0rUpt2dct98iIkhty9/cbnvTubGfuKRDFKqVPVf6Kdrj72GoBvSDoHhcC2F6
	 4N6qghNx7nkNKcT/asyoHg3xOrtc8FRBEL0Y20vE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/578] wifi: rtlwifi: remove unused timer and related code
Date: Wed, 19 Feb 2025 09:20:52 +0100
Message-ID: <20250219082654.782103555@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 358b94f0a7cadd2ec7824531d54dadaa8b71de04 ]

Drop unused 'dualmac_easyconcurrent_retrytimer' of 'struct rtl_works',
corresponding 'rtl_easy_concurrent_retrytimer_callback()' handler,
'dualmac_easy_concurrent' function pointer of 'struct rtl_hal_ops'
and related call to 'timer_setup()' in '_rtl_init_deferred_work()'.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230602065940.149198-1-dmantipov@yandex.ru
Stable-dep-of: 2fdac64c3c35 ("wifi: rtlwifi: remove unused check_buddy_priv")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 16 +---------------
 drivers/net/wireless/realtek/rtlwifi/base.h |  1 -
 drivers/net/wireless/realtek/rtlwifi/wifi.h |  2 --
 3 files changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 9e7e98b55eff8..44846e96b2abe 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -452,8 +452,7 @@ static int _rtl_init_deferred_work(struct ieee80211_hw *hw)
 	/* <1> timer */
 	timer_setup(&rtlpriv->works.watchdog_timer,
 		    rtl_watch_dog_timer_callback, 0);
-	timer_setup(&rtlpriv->works.dualmac_easyconcurrent_retrytimer,
-		    rtl_easy_concurrent_retrytimer_callback, 0);
+
 	/* <2> work queue */
 	rtlpriv->works.hw = hw;
 	rtlpriv->works.rtl_wq = wq;
@@ -2366,19 +2365,6 @@ static void rtl_c2hcmd_wq_callback(struct work_struct *work)
 	rtl_c2hcmd_launcher(hw, 1);
 }
 
-void rtl_easy_concurrent_retrytimer_callback(struct timer_list *t)
-{
-	struct rtl_priv *rtlpriv =
-		from_timer(rtlpriv, t, works.dualmac_easyconcurrent_retrytimer);
-	struct ieee80211_hw *hw = rtlpriv->hw;
-	struct rtl_priv *buddy_priv = rtlpriv->buddy_priv;
-
-	if (buddy_priv == NULL)
-		return;
-
-	rtlpriv->cfg->ops->dualmac_easy_concurrent(hw);
-}
-
 /*********************************************************
  *
  * frame process functions
diff --git a/drivers/net/wireless/realtek/rtlwifi/base.h b/drivers/net/wireless/realtek/rtlwifi/base.h
index 0e4f8a8ae3a5f..f081a9a90563f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.h
+++ b/drivers/net/wireless/realtek/rtlwifi/base.h
@@ -124,7 +124,6 @@ int rtl_send_smps_action(struct ieee80211_hw *hw,
 u8 *rtl_find_ie(u8 *data, unsigned int len, u8 ie);
 void rtl_recognize_peer(struct ieee80211_hw *hw, u8 *data, unsigned int len);
 u8 rtl_tid_to_ac(u8 tid);
-void rtl_easy_concurrent_retrytimer_callback(struct timer_list *t);
 extern struct rtl_global_var rtl_global_var;
 void rtl_phy_scan_operation_backup(struct ieee80211_hw *hw, u8 operation);
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 0bac788ccd6e3..1991cffd3dd4a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2300,7 +2300,6 @@ struct rtl_hal_ops {
 			  u32 regaddr, u32 bitmask, u32 data);
 	void (*linked_set_reg)(struct ieee80211_hw *hw);
 	void (*chk_switch_dmdp)(struct ieee80211_hw *hw);
-	void (*dualmac_easy_concurrent)(struct ieee80211_hw *hw);
 	void (*dualmac_switch_to_dmdp)(struct ieee80211_hw *hw);
 	bool (*phy_rf6052_config)(struct ieee80211_hw *hw);
 	void (*phy_rf6052_set_cck_txpower)(struct ieee80211_hw *hw,
@@ -2465,7 +2464,6 @@ struct rtl_works {
 
 	/*timer */
 	struct timer_list watchdog_timer;
-	struct timer_list dualmac_easyconcurrent_retrytimer;
 	struct timer_list fw_clockoff_timer;
 	struct timer_list fast_antenna_training_timer;
 	/*task */
-- 
2.39.5



