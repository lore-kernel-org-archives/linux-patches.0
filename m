Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C6E21FF23;
	Mon, 18 Aug 2025 13:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523843; cv=none; b=PgH4+/YwIt0cFQzSaT7VWg5075KptRkYtABbYlBnHRGwUuEgE9MW3ogynRkbc2KCEBsMLTPZHVywbm6DlHnZ4Vs2aSBmv9sn4dRI/amO5wJf7D5l7ImOg22nk9U8VBTXtUMSRqUC/lnhvQIzJwm7bg/egxC/hXK3XWO7Wi+9YNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523843; c=relaxed/simple;
	bh=aUivljUl/BzriVt/e01ksWa4nUtri6mfVIqtsuQCYB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJr4XhhDegq9ELxQstZiRCJTItEu8kan9Lyi4Sqa+lDLmf/CNRYQZqYLLjZZ3U/OaDK12LSOvHK2sGbXBN9CDAEFmgPVy4OhU1D97jSsz/ysFaqG6leyWmawm6wyNHGTFPsi1ogb4oxH8XR7owLLJ4fe+PbtB5DIrX+nRKSm82g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hIEHPVNW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hIEHPVNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E399C4CEEB;
	Mon, 18 Aug 2025 13:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523842;
	bh=aUivljUl/BzriVt/e01ksWa4nUtri6mfVIqtsuQCYB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hIEHPVNW2YD4XZEUVMEgHivRNvzqrjkdg17aCCBU4fvayg5nHgRN6V0RcdtsZqcDE
	 r9J5DpegJQZpAGjWmTXMTRqlqSBShOiAyXXXjc9gqq//wWl2r4JWTWZGn6QSnMcvOK
	 cnAEXiviAda3kSRHUMpjQWSq2WiLGCTOkavPoTRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ching-Te Ku <ku920601@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 288/515] wifi: rtw89: coex: Not to set slot duration to zero to avoid firmware issue
Date: Mon, 18 Aug 2025 14:44:34 +0200
Message-ID: <20250818124509.500971320@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ching-Te Ku <ku920601@realtek.com>

[ Upstream commit a7feafea4ce80d5fa5284d05d54b4f108d2ab575 ]

If the duration set to zero, Wi-Fi firmware will trigger some unexpected
issue when firmware try to enable timer.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250616090252.51098-9-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 5ccf0cbaed2f..ea3664103fbf 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -3836,13 +3836,13 @@ void rtw89_btc_set_policy_v1(struct rtw89_dev *rtwdev, u16 policy_type)
 
 		switch (policy_type) {
 		case BTC_CXP_OFFE_2GBWISOB: /* for normal-case */
-			_slot_set(btc, CXST_E2G, 0, tbl_w1, SLOT_ISO);
+			_slot_set(btc, CXST_E2G, 5, tbl_w1, SLOT_ISO);
 			_slot_set_le(btc, CXST_EBT, s_def[CXST_EBT].dur,
 				     s_def[CXST_EBT].cxtbl, s_def[CXST_EBT].cxtype);
 			_slot_set_dur(btc, CXST_EBT, dur_2);
 			break;
 		case BTC_CXP_OFFE_2GISOB: /* for bt no-link */
-			_slot_set(btc, CXST_E2G, 0, cxtbl[1], SLOT_ISO);
+			_slot_set(btc, CXST_E2G, 5, cxtbl[1], SLOT_ISO);
 			_slot_set_le(btc, CXST_EBT, s_def[CXST_EBT].dur,
 				     s_def[CXST_EBT].cxtbl, s_def[CXST_EBT].cxtype);
 			_slot_set_dur(btc, CXST_EBT, dur_2);
@@ -3868,15 +3868,15 @@ void rtw89_btc_set_policy_v1(struct rtw89_dev *rtwdev, u16 policy_type)
 			break;
 		case BTC_CXP_OFFE_2GBWMIXB:
 			if (a2dp->exist)
-				_slot_set(btc, CXST_E2G, 0, cxtbl[2], SLOT_MIX);
+				_slot_set(btc, CXST_E2G, 5, cxtbl[2], SLOT_MIX);
 			else
-				_slot_set(btc, CXST_E2G, 0, tbl_w1, SLOT_MIX);
+				_slot_set(btc, CXST_E2G, 5, tbl_w1, SLOT_MIX);
 			_slot_set_le(btc, CXST_EBT, s_def[CXST_EBT].dur,
 				     s_def[CXST_EBT].cxtbl, s_def[CXST_EBT].cxtype);
 			break;
 		case BTC_CXP_OFFE_WL: /* for 4-way */
-			_slot_set(btc, CXST_E2G, 0, cxtbl[1], SLOT_MIX);
-			_slot_set(btc, CXST_EBT, 0, cxtbl[1], SLOT_MIX);
+			_slot_set(btc, CXST_E2G, 5, cxtbl[1], SLOT_MIX);
+			_slot_set(btc, CXST_EBT, 5, cxtbl[1], SLOT_MIX);
 			break;
 		default:
 			break;
-- 
2.39.5



