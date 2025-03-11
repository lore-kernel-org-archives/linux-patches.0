Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3305425E815;
	Tue, 11 Mar 2025 15:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706360; cv=none; b=iP1RzGlAjzVaZklePcnAEk1U4R6uCIwnn4OZC1EolY4nD/KYEiTLIit8YlbwpjcMgqhvlVwB7a+Jac/dZIecORsPu6Z9RM7AjTdaXhHmYx51mbFEwq7hqyaauWCO/jAdGyER9LHoDdrboJ+XacVMhWCJ3j8ZdItsRbNsFoLzyVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706360; c=relaxed/simple;
	bh=SPPJW2ewLjyJ+zxLeNyggP3g146QYDt3yP3jdL+tRXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CnAE9tX4/k0KXLXgxSe4r1dWbtGo0XJcZTOj/5TEHV8KrxeevyVdWWB0Ka5RtxnU/3566la51O3IJT7b96UTRffffKNM8KVvjkIizl9ULFD5ul5Y5r9YkOW/+r4XN+DIKpMctx95QFG1YypannoFi1AA9pvdC4LyCVYBnjCoQlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vn8MereK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vn8MereK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58273C4CEE9;
	Tue, 11 Mar 2025 15:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706359;
	bh=SPPJW2ewLjyJ+zxLeNyggP3g146QYDt3yP3jdL+tRXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vn8MereKXl5es+CE5ltt0zBEmygjortbHOIaL9Op1HwkBFpu6S71VIlBuVOg84E/d
	 3FO7xH7EUpE+x40L+8nZa3wFxAT9EWQ09zDSlpOXT8s1aVhpa2NLDylkjwFxOMlQFR
	 jdYIrYSiVV00fTU087LQVCwk2d0L7QN/r6AaEVs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 022/462] wifi: rtlwifi: remove unused dualmac control leftovers
Date: Tue, 11 Mar 2025 15:54:48 +0100
Message-ID: <20250311145759.228511410@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 557123259200b30863e1b6a8f24a8c8060b6fc1d ]

Remove 'struct rtl_dualmac_easy_concurrent_ctl' of 'struct rtl_priv'
and related code in '_rtl_pci_tx_chk_waitq()'.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230602065940.149198-2-dmantipov@yandex.ru
Stable-dep-of: 2fdac64c3c35 ("wifi: rtlwifi: remove unused check_buddy_priv")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/pci.c  | 5 -----
 drivers/net/wireless/realtek/rtlwifi/wifi.h | 9 ---------
 2 files changed, 14 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index f17a365fba070..0dcf5350e0885 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -443,11 +443,6 @@ static void _rtl_pci_tx_chk_waitq(struct ieee80211_hw *hw)
 	if (!rtlpriv->rtlhal.earlymode_enable)
 		return;
 
-	if (rtlpriv->dm.supp_phymode_switch &&
-	    (rtlpriv->easy_concurrent_ctl.switch_in_process ||
-	    (rtlpriv->buddy_priv &&
-	    rtlpriv->buddy_priv->easy_concurrent_ctl.switch_in_process)))
-		return;
 	/* we just use em for BE/BK/VI/VO */
 	for (tid = 7; tid >= 0; tid--) {
 		u8 hw_queue = ac_to_hwq[rtl_tid_to_ac(tid)];
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index d1b36760c8948..f22891c73ade1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2496,14 +2496,6 @@ struct rtl_debug {
 #define MIMO_PS_DYNAMIC			1
 #define MIMO_PS_NOLIMIT			3
 
-struct rtl_dualmac_easy_concurrent_ctl {
-	enum band_type currentbandtype_backfordmdp;
-	bool close_bbandrf_for_dmsp;
-	bool change_to_dmdp;
-	bool change_to_dmsp;
-	bool switch_in_process;
-};
-
 struct rtl_dmsp_ctl {
 	bool activescan_for_slaveofdmsp;
 	bool scan_for_anothermac_fordmsp;
@@ -2744,7 +2736,6 @@ struct rtl_priv {
 	struct list_head list;
 	struct rtl_priv *buddy_priv;
 	struct rtl_global_var *glb_var;
-	struct rtl_dualmac_easy_concurrent_ctl easy_concurrent_ctl;
 	struct rtl_dmsp_ctl dmsp_ctl;
 	struct rtl_locks locks;
 	struct rtl_works works;
-- 
2.39.5



