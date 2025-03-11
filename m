Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1050C25DAFD;
	Tue, 11 Mar 2025 15:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705443; cv=none; b=gzhITwKgFQztQPwT9xiAJ4dPZCzKxaKaH7CM0j80j2h8Nour7qJl8kCYApWKTn5+rV3gVRxEhox0epQjQyRPP1EeePmm/M/finue5WJUApyZSLAitDYWioXQHGnxsYe2a9BuTKN5/EjYnq7Ato2kpeMvzghB4vL9NOzzCRTGm8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705443; c=relaxed/simple;
	bh=ovpBpeojAmhLMtRfBn1UBrZ5v8zSSyqc1aG3W/pXvQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TPVWBW5R9kds4SWzAWrhRL/hjRx1VQiz41aosAklFdJdcBHivHkfDLQnbf2xmffPnrI73Ip4rVYJmXUev39t4WOq56eMhs4TU5EInsmcjezYkbJyxsgm1zx90Z84Lb+tZfVAlWeuF3bEboy8DpoYzRZimJXdLBhaCt+TxhShbPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PmQz451i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PmQz451i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8777DC4CEE9;
	Tue, 11 Mar 2025 15:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705442;
	bh=ovpBpeojAmhLMtRfBn1UBrZ5v8zSSyqc1aG3W/pXvQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PmQz451iR9yOhs/PfmRrG/RG0/IuM/mTWEQ6IBmCEuAu8W6XlVDTMIWFEX7K5ANRK
	 SH1MGejgkhr9n/GHmY00LpooAGjM3KMoMhZNepJcj8J0HNpWFEOPIN4+NoPRVNw1pf
	 iTaKTkAEsvSqqVBcLZ8UvKufYUB/WmpEKLaBsUPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 018/328] wifi: rtlwifi: remove unused timer and related code
Date: Tue, 11 Mar 2025 15:56:28 +0100
Message-ID: <20250311145715.610080695@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 5898109b1c3e8..3c844d7ba2bef 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -448,8 +448,7 @@ static int _rtl_init_deferred_work(struct ieee80211_hw *hw)
 	/* <1> timer */
 	timer_setup(&rtlpriv->works.watchdog_timer,
 		    rtl_watch_dog_timer_callback, 0);
-	timer_setup(&rtlpriv->works.dualmac_easyconcurrent_retrytimer,
-		    rtl_easy_concurrent_retrytimer_callback, 0);
+
 	/* <2> work queue */
 	rtlpriv->works.hw = hw;
 	rtlpriv->works.rtl_wq = wq;
@@ -2378,19 +2377,6 @@ void rtl_c2hcmd_wq_callback(void *data)
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
index e4a7e074ae3ff..1eccdf9d62a66 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.h
+++ b/drivers/net/wireless/realtek/rtlwifi/base.h
@@ -127,7 +127,6 @@ int rtl_send_smps_action(struct ieee80211_hw *hw,
 u8 *rtl_find_ie(u8 *data, unsigned int len, u8 ie);
 void rtl_recognize_peer(struct ieee80211_hw *hw, u8 *data, unsigned int len);
 u8 rtl_tid_to_ac(u8 tid);
-void rtl_easy_concurrent_retrytimer_callback(struct timer_list *t);
 extern struct rtl_global_var rtl_global_var;
 void rtl_phy_scan_operation_backup(struct ieee80211_hw *hw, u8 operation);
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index abec9ceabe285..eebbd01256415 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2302,7 +2302,6 @@ struct rtl_hal_ops {
 			  u32 regaddr, u32 bitmask, u32 data);
 	void (*linked_set_reg)(struct ieee80211_hw *hw);
 	void (*chk_switch_dmdp)(struct ieee80211_hw *hw);
-	void (*dualmac_easy_concurrent)(struct ieee80211_hw *hw);
 	void (*dualmac_switch_to_dmdp)(struct ieee80211_hw *hw);
 	bool (*phy_rf6052_config)(struct ieee80211_hw *hw);
 	void (*phy_rf6052_set_cck_txpower)(struct ieee80211_hw *hw,
@@ -2468,7 +2467,6 @@ struct rtl_works {
 
 	/*timer */
 	struct timer_list watchdog_timer;
-	struct timer_list dualmac_easyconcurrent_retrytimer;
 	struct timer_list fw_clockoff_timer;
 	struct timer_list fast_antenna_training_timer;
 	/*task */
-- 
2.39.5



