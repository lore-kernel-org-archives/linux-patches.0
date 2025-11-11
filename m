Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B51227054C;
	Tue, 11 Nov 2025 01:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823334; cv=none; b=W4+Rlc14AVN1sR19xWJHMPVLEDfv2AutK+6uR2MmXMi4Yh4+P5TSDh9IBIs6ffBHdFJlyQhFR+DIJ3/YrYBQk41pgY+9Av+mcbK8AUpY55dl4ysO2X/i7kbT2xdqBQff8ruyo8GMKZH8/VYyHksRATv8fZFvK5hZZcys/2vWmSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823334; c=relaxed/simple;
	bh=a2yDht++kmJE83HbJ8CLSRIozXGQNiSjcS/HftZ5/d8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ly7ik+6XcqodwFZzkLEaEljpPfj0dACX8Ub2a0QtmBYzOjtXAE8x8tS80GfAUWZ6SyNJMgSJrWDgy1V+WN9v0EjAY+BWZeXzNQvOI0gs2Y+AzqndtNuJMtT5kAj/7uxjNzaUPEm8dmBOM9ihMxWd5onyrJrNTx6l9Lkg8QauyDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qTjxIP7u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qTjxIP7u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEBD0C4CEF5;
	Tue, 11 Nov 2025 01:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823334;
	bh=a2yDht++kmJE83HbJ8CLSRIozXGQNiSjcS/HftZ5/d8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qTjxIP7uFMAwYJexHOAdmJn5cGV881B4VUWs5rXmsZNcXy912MxiX/WqPaM50aH2d
	 L+5OOFHLyzEp822rVkp/pXWzsD6vfJvSK1mSBq1gUsw05uQQqNzph25hV2+bMSbEJ5
	 B+PaOWfbYemVz02lEqbz73DxBpBvYODwyVBEigvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Sean Anderson <sean.anderson@linux.dev>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 278/849] wifi: rtw89: add dummy C2H handlers for BCN resend and update done
Date: Tue, 11 Nov 2025 09:37:28 +0900
Message-ID: <20251111004543.145925787@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 04a2de8cfc95076d6c65d4d6d06d0f9d964a2105 ]

Two C2H events are not listed, and driver throws

  MAC c2h class 0 func 6 not support
  MAC c2h class 1 func 3 not support

Since the implementation in vendor driver does nothing, add two dummy
functions for them.

Reported-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Closes: https://lore.kernel.org/linux-wireless/d2d62793-046c-4b55-93ed-1d1f43cff7f2@gmail.com/
Reviewed-by: Sean Anderson <sean.anderson@linux.dev>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250804012234.8913-3-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/mac.c | 13 ++++++++++++-
 drivers/net/wireless/realtek/rtw89/mac.h |  1 +
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
index ef17a307b7702..33a7dd9d6f0e6 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -5235,6 +5235,11 @@ rtw89_mac_c2h_bcn_cnt(struct rtw89_dev *rtwdev, struct sk_buff *c2h, u32 len)
 {
 }
 
+static void
+rtw89_mac_c2h_bcn_upd_done(struct rtw89_dev *rtwdev, struct sk_buff *c2h, u32 len)
+{
+}
+
 static void
 rtw89_mac_c2h_pkt_ofld_rsp(struct rtw89_dev *rtwdev, struct sk_buff *skb_c2h,
 			   u32 len)
@@ -5257,6 +5262,11 @@ rtw89_mac_c2h_pkt_ofld_rsp(struct rtw89_dev *rtwdev, struct sk_buff *skb_c2h,
 	rtw89_complete_cond(wait, cond, &data);
 }
 
+static void
+rtw89_mac_c2h_bcn_resend(struct rtw89_dev *rtwdev, struct sk_buff *c2h, u32 len)
+{
+}
+
 static void
 rtw89_mac_c2h_tx_duty_rpt(struct rtw89_dev *rtwdev, struct sk_buff *skb_c2h, u32 len)
 {
@@ -5646,7 +5656,7 @@ void (* const rtw89_mac_c2h_ofld_handler[])(struct rtw89_dev *rtwdev,
 	[RTW89_MAC_C2H_FUNC_EFUSE_DUMP] = NULL,
 	[RTW89_MAC_C2H_FUNC_READ_RSP] = NULL,
 	[RTW89_MAC_C2H_FUNC_PKT_OFLD_RSP] = rtw89_mac_c2h_pkt_ofld_rsp,
-	[RTW89_MAC_C2H_FUNC_BCN_RESEND] = NULL,
+	[RTW89_MAC_C2H_FUNC_BCN_RESEND] = rtw89_mac_c2h_bcn_resend,
 	[RTW89_MAC_C2H_FUNC_MACID_PAUSE] = rtw89_mac_c2h_macid_pause,
 	[RTW89_MAC_C2H_FUNC_SCANOFLD_RSP] = rtw89_mac_c2h_scanofld_rsp,
 	[RTW89_MAC_C2H_FUNC_TX_DUTY_RPT] = rtw89_mac_c2h_tx_duty_rpt,
@@ -5661,6 +5671,7 @@ void (* const rtw89_mac_c2h_info_handler[])(struct rtw89_dev *rtwdev,
 	[RTW89_MAC_C2H_FUNC_DONE_ACK] = rtw89_mac_c2h_done_ack,
 	[RTW89_MAC_C2H_FUNC_C2H_LOG] = rtw89_mac_c2h_log,
 	[RTW89_MAC_C2H_FUNC_BCN_CNT] = rtw89_mac_c2h_bcn_cnt,
+	[RTW89_MAC_C2H_FUNC_BCN_UPD_DONE] = rtw89_mac_c2h_bcn_upd_done,
 };
 
 static
diff --git a/drivers/net/wireless/realtek/rtw89/mac.h b/drivers/net/wireless/realtek/rtw89/mac.h
index 241e89983c4ad..25fe5e5c8a979 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.h
+++ b/drivers/net/wireless/realtek/rtw89/mac.h
@@ -419,6 +419,7 @@ enum rtw89_mac_c2h_info_func {
 	RTW89_MAC_C2H_FUNC_DONE_ACK,
 	RTW89_MAC_C2H_FUNC_C2H_LOG,
 	RTW89_MAC_C2H_FUNC_BCN_CNT,
+	RTW89_MAC_C2H_FUNC_BCN_UPD_DONE = 0x06,
 	RTW89_MAC_C2H_FUNC_INFO_MAX,
 };
 
-- 
2.51.0



