Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CB517593;
	Sat,  3 Feb 2024 04:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933580; cv=none; b=Ca0HbHDi3MPJdlhTrMsZ2getwwFHhyoZoy32m4TM/AHUD7hjtW6AuWfZ2dJwHVjoX0J2ZWy0VU0csJLZCCs4pIf9mVuydYDh8ZkkrcWMRjQlSuDc156oOl7DvS3NU0H92ZzTzPOKbba7KvPz2mE+oEsDtpdnMhdSnQ3QmqXwadw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933580; c=relaxed/simple;
	bh=s3SXs3a5T/VZVAXctZlArcx2iKpTSFEoIFDX62OaUrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PjBhY1sZtnoSYqXxE8DyTkbtBJjOhSnbRabQCcOgG5GhNI2XHhHcP+BQgbsnH0QttxROWci4x6/GO5jIhmDZoOPCiS78LzidGFs3vc+RRXxh9mcllXVFllZ67RzEf1oPqzvPLr2DwZ2z2vfUr0Ygt+PnMiG58BTVVet/Cs1Eapo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iNrB5dIs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iNrB5dIs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EBEFC43390;
	Sat,  3 Feb 2024 04:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933580;
	bh=s3SXs3a5T/VZVAXctZlArcx2iKpTSFEoIFDX62OaUrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iNrB5dIsGRIAWiRB2JgUSrcfv7tV3MMM7NZjypGb9GrcRVeaJXltUuglUvpHZcbnP
	 KeZr/VIT6+uOD1R0XmIqKkaPZcNKNdU/N14Fhpg7x3iQ5cYY3PgAN+suATPaPqKObr
	 smL3mJlejBzDExOeGaEHthCmHo+iwKAuKzRKEsc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ching-Te Ku <ku920601@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 141/322] wifi: rtw89: coex: Fix wrong Wi-Fi role info and FDDT parameter members
Date: Fri,  2 Feb 2024 20:03:58 -0800
Message-ID: <20240203035403.705545254@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4ba8b3df70ae..6ab1b6ffbb50 100644
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
index 04ce221730f9..ee6ae2a0c798 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -2230,12 +2230,6 @@ struct rtw89_btc_fbtc_fddt_cell_status {
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
@@ -2299,9 +2293,9 @@ struct rtw89_btc_fbtc_cysta_v5 { /* statistics for cycles */
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



