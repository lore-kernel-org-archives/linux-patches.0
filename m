Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C7919D8BC;
	Sat, 12 Sep 2026 07:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197423; cv=none; b=jY9iREy81oYjsAGHcozaXH1aPN9OD+rg3upzcbUKyIsdUIdUo4tbv1SjsUSIuTkooNoX0t0TjAR4pzHGB2+fMsm5xiepxJUprShYXqDZpFwgymdg7jT+8xC7YSCgCeIKKjbjX1d1qBz3WylFWqA/WuAGOl8N8cSuYMLPNVNKoGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197423; c=relaxed/simple;
	bh=9L21W7Z7n6DHF3uZbX5fNfAoghGCyue6Q/tWPRZ9SwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O9artT5mWduCpYKPvZ6df2pUUY8kzuKN1hggc2Whz24FWbJkCcfV9xtd7MyyWwImqw6Axfjb9lVpxNr0A1JR1xWRdG+jET48W7mesGuQ0QdIGPYu06BrfaIThfUpuJKP4LaT8X3xpxBFcO6CxJ3DaVYnXPcLwyo+IuQ6D5Iwt04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZpDzuP51; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZpDzuP51"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE8A1F000FF;
	Sat, 12 Sep 2026 07:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197422;
	bh=tjs2ZZlU0B1HwQwBZZBLuzD/fW7elwZh8gLUNgwkjeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZpDzuP51rm9zkw93ClwOy1GM4V9fAGDVizi8knyn21IwwThK452wGYhMmgx0oCJE/
	 6firpveESHMXg54hYpavJPveAcTmCGz+jfsVBDIue0G01FykrQh6Fx057NdUU06cVI
	 Y5P7NmjKLdp+QFHm3WXADfoZtvZQa8asR64CKuEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zong-Zhe Yang <kevin_yang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0170/1815] wifi: rtw89: fw: fix link ID filling for LPS MLO common info
Date: Sat, 12 Sep 2026 08:32:00 +0200
Message-ID: <20260912065652.997616875@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zong-Zhe Yang <kevin_yang@realtek.com>

[ Upstream commit c1eabaaa088ddbb1b937cd339adfa4c18e93c93d ]

The link ID field in H2C command of LPS MLO common info is incorrectly
filled with the PHY index. Fix it with the target link ID.

Fixes: 20380a039ddd ("wifi: rtw89: phy: add H2C command to send detail RX gain and link parameters for PS mode")
Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260625061545.44808-8-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 4 ++--
 drivers/net/wireless/realtek/rtw89/fw.h | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index c91e7ec8b9722..2824cee964cb2 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -3439,7 +3439,7 @@ int rtw89_fw_h2c_lps_ml_cmn_info_v1(struct rtw89_dev *rtwdev,
 	h2c->rfe_type = efuse->rfe_type;
 	h2c->rssi_main = U8_MAX;
 
-	memset(h2c->link_id, 0xfe, RTW89_BB_PS_LINK_BUF_MAX);
+	memset(h2c->link_id, RTW89_BB_PS_LINK_ID_SKIP, RTW89_BB_PS_LINK_BUF_MAX);
 
 	rtw89_vif_for_each_link(rtwvif, rtwvif_link, link_id) {
 		u8 phy_idx = rtwvif_link->phy_idx;
@@ -3447,7 +3447,7 @@ int rtw89_fw_h2c_lps_ml_cmn_info_v1(struct rtw89_dev *rtwdev,
 		bb = rtw89_get_bb_ctx(rtwdev, phy_idx);
 		chan = rtw89_chan_get(rtwdev, rtwvif_link->chanctx_idx);
 
-		h2c->link_id[phy_idx] = phy_idx;
+		h2c->link_id[phy_idx] = link_id;
 		h2c->central_ch[phy_idx] = chan->channel;
 		h2c->pri_ch[phy_idx] = chan->primary_channel;
 		h2c->band[phy_idx] = chan->band_type;
diff --git a/drivers/net/wireless/realtek/rtw89/fw.h b/drivers/net/wireless/realtek/rtw89/fw.h
index 20721d5209aa3..5873301fc4729 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.h
+++ b/drivers/net/wireless/realtek/rtw89/fw.h
@@ -2053,6 +2053,8 @@ enum rtw89_bb_link_rx_gain_table_type {
 	RTW89_BB_PS_LINK_RX_GAIN_TAB_MAX,
 };
 
+#define RTW89_BB_PS_LINK_ID_SKIP 0xfe
+
 enum rtw89_bb_ps_link_buf_id {
 	RTW89_BB_PS_LINK_BUF_0 = 0x00,
 	RTW89_BB_PS_LINK_BUF_1 = 0x01,
-- 
2.53.0



