Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418A333F38A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301086; cv=none; b=u6CLLrEFHCD65AXiqIgHphi2JiM9TQQ0swzUOnmzap/5fSsgNiuoO2MuifDxOl92jOjk/HBnuo52zi+b+71+8MFyVZgqH4BJuX65i6QNURdvY84C6zxfthJrmHO+uvOMjvTb9lHDAGiuUPROfwXXD2yyyA7sJrUKUaIhJSoNCCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301086; c=relaxed/simple;
	bh=HfMBHUooK+Lp9luf0ZHS7pbropNMA8FcQR5o2KD4RwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=otI0ronacFmBKuodtjqRcqq04rBXxq6+3BGqXIcoC3YFRr8NNLZz9Wxh739FzcZplg8/jCpvKMk9/SQlE3mkAvcBktBrUrD7eZpbxrsmGK3YZ4NfIrS828de5OT1qsa0UI1PikzQZ15lclmo2VAp7jp8jvI/Ou+1Oe9EKKoLy0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oDq2ki4B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oDq2ki4B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4501C116D0;
	Sat, 28 Feb 2026 17:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301086;
	bh=HfMBHUooK+Lp9luf0ZHS7pbropNMA8FcQR5o2KD4RwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oDq2ki4B76q3ICMNMB3DuIvbHouGOm5Jl0jQMPgy+ihJl57NzitH8dX9Um/WKR3//
	 W2Bk56NH3w3T8YsG/93d5N58O/2bWmeOt91wZdVOpW+4/dIrGuPzI+qm12CwuRBe/f
	 u/zupIzXws01Xn8Fyd6wp7WlR6xLcLXWWngjZGm2mIV3RzhByQ3lvuaZnbA2OCxNi8
	 MsWEnZA4gFCGmhCgiXnC+YPxzTCl0ooQyHpD5HKxGzXdRVLIdv91WDO1KpuHvFN0Tq
	 hlFue5C9Z1t03Mz2khU2517KG4hY32TrfAMhIAZKbqxVRMmHFFGBfM+XSuSBACVfbr
	 AzOdkvseSvZzQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chin-Yen Lee <timlee@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 235/752] wifi: rtw89: wow: add reason codes for disassociation in WoWLAN mode
Date: Sat, 28 Feb 2026 12:39:06 -0500
Message-ID: <20260228174750.1542406-235-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Chin-Yen Lee <timlee@realtek.com>

[ Upstream commit 2fd8f953f25173d14981d8736b6f5bfcd757e51b ]

Some APs disconnect clients by sending a Disassociation frame
rather than a Deauthentication frame. Since these frames use
different reason codes in WoWLAN mode, this commit adds support
for handling Disassociation to prevent missed disconnection events.

Signed-off-by: Chin-Yen Lee <timlee@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260110022019.2254969-3-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/wow.c | 4 ++++
 drivers/net/wireless/realtek/rtw89/wow.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/wow.c b/drivers/net/wireless/realtek/rtw89/wow.c
index 5faa51ad896a2..f34cd863d1009 100644
--- a/drivers/net/wireless/realtek/rtw89/wow.c
+++ b/drivers/net/wireless/realtek/rtw89/wow.c
@@ -809,6 +809,10 @@ static void rtw89_wow_show_wakeup_reason(struct rtw89_dev *rtwdev)
 
 	reason = rtw89_read8(rtwdev, wow_reason_reg);
 	switch (reason) {
+	case RTW89_WOW_RSN_RX_DISASSOC:
+		wakeup.disconnect = true;
+		rtw89_debug(rtwdev, RTW89_DBG_WOW, "WOW: Rx disassoc\n");
+		break;
 	case RTW89_WOW_RSN_RX_DEAUTH:
 		wakeup.disconnect = true;
 		rtw89_debug(rtwdev, RTW89_DBG_WOW, "WOW: Rx deauth\n");
diff --git a/drivers/net/wireless/realtek/rtw89/wow.h b/drivers/net/wireless/realtek/rtw89/wow.h
index d2ba6cebc2a6b..71e07f482174f 100644
--- a/drivers/net/wireless/realtek/rtw89/wow.h
+++ b/drivers/net/wireless/realtek/rtw89/wow.h
@@ -33,6 +33,7 @@
 enum rtw89_wake_reason {
 	RTW89_WOW_RSN_RX_PTK_REKEY = 0x1,
 	RTW89_WOW_RSN_RX_GTK_REKEY = 0x2,
+	RTW89_WOW_RSN_RX_DISASSOC = 0x4,
 	RTW89_WOW_RSN_RX_DEAUTH = 0x8,
 	RTW89_WOW_RSN_DISCONNECT = 0x10,
 	RTW89_WOW_RSN_RX_MAGIC_PKT = 0x21,
-- 
2.51.0

