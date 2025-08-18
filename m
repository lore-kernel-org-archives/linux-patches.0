Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C85E27B324;
	Mon, 18 Aug 2025 14:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525608; cv=none; b=eydYR0qyWAR3G3LBRAm4aPvC7EYUuSVw1N/oZ8bKwaYauLldqtORHHXWnT9cYzzi2XwrgHZJfPnDkFqt3ja6LtZpFUnXwiH9WcW1l5OhUufmWqvUubbnmT35L5MDAcj2QKltJCf1jX2u3z7Ze2SOhV6KfT/ihyHS/W6yz7V+J58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525608; c=relaxed/simple;
	bh=FYWNiU4t+ds1i9txGWKUXEdL7e+kNvMv1Vv19+s00QU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=boNycKJ06A8grqFQ+B8P1OId3Z4s8mZGmfJrK9kVOMlSM6JO5eeFKs6oaJENrA2C30qK5rJKImWYu/7PETz0Rq//gZ/z+llpYZsOnmwLCj6SqhoHenhywBd5DH6xxqiLQQBUF8BfyImuf3M2hGVLisGt/IT6AdPfjqWnC7ElW30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gbWBVjLn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gbWBVjLn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89372C4CEEB;
	Mon, 18 Aug 2025 14:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525608;
	bh=FYWNiU4t+ds1i9txGWKUXEdL7e+kNvMv1Vv19+s00QU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gbWBVjLnysTClKgXC8LEmQ9zn3gZjCEnCy2fMAn1OKOoaLxbgEwa71S6XfNQSiVQ7
	 yNXgEYiJ0YxhqUYKYHC+3uXaEXVQGVRuwi7zqFYR3zOu3ReguA/hpplFT+uHLdu9ZZ
	 Ea+ilQw7ls25hewOgAW1IAtSsNkOotQ5vKdYDwXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ching-Te Ku <ku920601@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 314/570] wifi: rtw89: coex: Not to set slot duration to zero to avoid firmware issue
Date: Mon, 18 Aug 2025 14:45:01 +0200
Message-ID: <20250818124517.964622286@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



