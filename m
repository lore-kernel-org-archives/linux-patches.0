Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8F01119C;
	Sat,  3 Feb 2024 04:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933842; cv=none; b=Oc3EKGgDY3KVPxYnqAYmCSkOoAWAMtD+xi1gHpx/Wh8DxKtWVqUqDwaNPWWwAoSVVcMFXmPGh35jkOuFk8eUEBAB2JmwtmOteLj79R0VNeqQN4HDKmpkF52WbygVgYx7wRjilN1XoWfAqWHZMJHEt+rfAJj7q6or+BH4SwnklW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933842; c=relaxed/simple;
	bh=KuCSzq2Wivbcy8c4mViN09t3NuUoyL/3VtANl06dnx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oVo6cEDSIowXv78eO4tOHEDdjak+FTDGeN1myF70C57K2em9/t+hfBQG4S35VC5QySNWnaslesGCdF77K5qal8aXe5FqJ3aKZMqAw37iDd6Ny0eVXFvLGOQk2vJ5bPxEftdbyEr0sfZzGlXOJdsuj3AQDyaUdYrLpcq59JEFGsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UG1nIB0E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UG1nIB0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98DE6C433F1;
	Sat,  3 Feb 2024 04:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933842;
	bh=KuCSzq2Wivbcy8c4mViN09t3NuUoyL/3VtANl06dnx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UG1nIB0ECwkJPqjNLQwSDM4stc8S6IU+tXO80hQRk5NXtHJxAWlVbPG8KIMJsj89d
	 ZMPv7LuQWttKXJfhn6A+UdxdJmZETOM5XHJKJUAyJmBcmWKk+i8c0WgrO9z4y2m+O7
	 F5/KOA+MFfFGBxrgWFv/cCSzyCnHYfuUze3vg234=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ching-Te Ku <ku920601@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 144/353] wifi: rtw89: coex: Fix wrong Wi-Fi role info and FDDT parameter members
Date: Fri,  2 Feb 2024 20:04:22 -0800
Message-ID: <20240203035408.243148293@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ching-Te Ku <ku920601@realtek.com>

[ Upstream commit acc55d7dd4de525ac07e43e90ea3cc630677ec8a ]

The Wi-Fi firmware 29.29.X should use version 2 role info format. FDDT
mechanism version 5 use the same cell members to judge traffic situation,
don't need to add another new format.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20231218061341.51255-2-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/coex.c |  4 ++--
 drivers/net/wireless/realtek/rtw89/core.h | 12 +++---------
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index bdcc172639e4..ace7bbf2cf94 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -131,7 +131,7 @@ static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	 .fcxbtcrpt = 105, .fcxtdma = 3,    .fcxslots = 1, .fcxcysta = 5,
 	 .fcxstep = 3,   .fcxnullsta = 2, .fcxmreg = 2,  .fcxgpiodbg = 1,
 	 .fcxbtver = 1,  .fcxbtscan = 2,  .fcxbtafh = 2, .fcxbtdevinfo = 1,
-	 .fwlrole = 1,   .frptmap = 3,    .fcxctrl = 1,
+	 .fwlrole = 2,   .frptmap = 3,    .fcxctrl = 1,
 	 .info_buf = 1800, .max_role_num = 6,
 	},
 	{RTL8852C, RTW89_FW_VER_CODE(0, 27, 57, 0),
@@ -159,7 +159,7 @@ static const struct rtw89_btc_ver rtw89_btc_ver_defs[] = {
 	 .fcxbtcrpt = 105, .fcxtdma = 3,  .fcxslots = 1, .fcxcysta = 5,
 	 .fcxstep = 3,   .fcxnullsta = 2, .fcxmreg = 2,  .fcxgpiodbg = 1,
 	 .fcxbtver = 1,  .fcxbtscan = 2,  .fcxbtafh = 2, .fcxbtdevinfo = 1,
-	 .fwlrole = 1,   .frptmap = 3,    .fcxctrl = 1,
+	 .fwlrole = 2,   .frptmap = 3,    .fcxctrl = 1,
 	 .info_buf = 1800, .max_role_num = 6,
 	},
 	{RTL8852B, RTW89_FW_VER_CODE(0, 29, 14, 0),
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 91e4d4e79eea..8f59461e58f2 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -2294,12 +2294,6 @@ struct rtw89_btc_fbtc_fddt_cell_status {
 	u8 state_phase; /* [0:3] train state, [4:7] train phase */
 } __packed;
 
-struct rtw89_btc_fbtc_fddt_cell_status_v5 {
-	s8 wl_tx_pwr;
-	s8 bt_tx_pwr;
-	s8 bt_rx_gain;
-} __packed;
-
 struct rtw89_btc_fbtc_cysta_v3 { /* statistics for cycles */
 	u8 fver;
 	u8 rsvd;
@@ -2363,9 +2357,9 @@ struct rtw89_btc_fbtc_cysta_v5 { /* statistics for cycles */
 	struct rtw89_btc_fbtc_cycle_a2dp_empty_info a2dp_ept;
 	struct rtw89_btc_fbtc_a2dp_trx_stat_v4 a2dp_trx[BTC_CYCLE_SLOT_MAX];
 	struct rtw89_btc_fbtc_cycle_fddt_info_v5 fddt_trx[BTC_CYCLE_SLOT_MAX];
-	struct rtw89_btc_fbtc_fddt_cell_status_v5 fddt_cells[FDD_TRAIN_WL_DIRECTION]
-							    [FDD_TRAIN_WL_RSSI_LEVEL]
-							    [FDD_TRAIN_BT_RSSI_LEVEL];
+	struct rtw89_btc_fbtc_fddt_cell_status fddt_cells[FDD_TRAIN_WL_DIRECTION]
+							 [FDD_TRAIN_WL_RSSI_LEVEL]
+							 [FDD_TRAIN_BT_RSSI_LEVEL];
 	__le32 except_map;
 } __packed;
 
-- 
2.43.0



