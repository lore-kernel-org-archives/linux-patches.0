Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624361E7C33;
	Tue, 15 Oct 2024 11:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992386; cv=none; b=sRUrXOQ6HoXNMH3mYq2P4CvqGSKKAR9zn46SxVmlQAID3UpW5lXZu593UMIgTFXSueNVWY3gCf2NwMZewW/7QdJXnTojxlOUz/MDTmUbqNKErJOMYe5L52JMBFDGT2l3Ws2yvrFWFedJCI/dHY/pgranmwZbjJA8BmxC6Vadjgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992386; c=relaxed/simple;
	bh=uvmq+UJTLr9dmR4YfAZ9zg+GiLR+s5Jg91Z3m355OoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JcctVozpFfwnVbf4VHRJSZCVB/qpHaySOmYj7/JUcdBinoLSvS4PuGFoX/tO+B1lgadpPI7rff/01AbOXOUjREQNo5489RJmT79gOSmFXF28ykZdBErXTMP2oDe/g3CG0cP3c1VUC3vzBdiQ54MnJr9r7JR031gv0qPsak7wuFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ncowjmEl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ncowjmEl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F09C4CEC6;
	Tue, 15 Oct 2024 11:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992386;
	bh=uvmq+UJTLr9dmR4YfAZ9zg+GiLR+s5Jg91Z3m355OoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ncowjmElRsit/JiNTOvy6LMFd1qwbyyGndplblGNeJBKpug4T3VGX//BjTHhneht+
	 FxpN2UWtAYytlBMdl8ogAU2/zDq3UncB+MK7sx7bSiGhd3psjtQtxhR1dv/4g7pN0c
	 +l43MUk0HDjGWwCrEx1zpGZXH2S+WPd1zrOp7tew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Kandybka <d.kandybka@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 101/691] wifi: rtw88: remove CPT execution branch never used
Date: Tue, 15 Oct 2024 13:20:49 +0200
Message-ID: <20241015112444.370260463@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Kandybka <d.kandybka@gmail.com>

[ Upstream commit 77c977327dfaa9ae2e154964cdb89ceb5c7b7cf1 ]

In 'rtw_coex_action_bt_a2dp_pan', 'wl_cpt_test' and 'bt_cpt_test' are
hardcoded to false, so corresponding 'table_case' and 'tdma_case'
assignments are never met.
Also 'rtw_coex_set_rf_para(rtwdev, chip->wl_rf_para_rx[1])' is never
executed. Assuming that CPT was never fully implemented, remove
lookalike leftovers. Compile tested only.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 76f631cb401f ("rtw88: coex: update the mechanism for A2DP + PAN")

Signed-off-by: Dmitry Kandybka <d.kandybka@gmail.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20240809085310.10512-1-d.kandybka@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/coex.c | 38 ++++++-----------------
 1 file changed, 10 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/coex.c b/drivers/net/wireless/realtek/rtw88/coex.c
index 2551e228b5819..347fc36068edb 100644
--- a/drivers/net/wireless/realtek/rtw88/coex.c
+++ b/drivers/net/wireless/realtek/rtw88/coex.c
@@ -2103,7 +2103,6 @@ static void rtw_coex_action_bt_a2dp_pan(struct rtw_dev *rtwdev)
 	struct rtw_efuse *efuse = &rtwdev->efuse;
 	struct rtw_chip_info *chip = rtwdev->chip;
 	u8 table_case, tdma_case;
-	bool wl_cpt_test = false, bt_cpt_test = false;
 
 	rtw_dbg(rtwdev, RTW_DBG_COEX, "[BTCoex], %s()\n", __func__);
 
@@ -2111,29 +2110,16 @@ static void rtw_coex_action_bt_a2dp_pan(struct rtw_dev *rtwdev)
 	rtw_coex_set_rf_para(rtwdev, chip->wl_rf_para_rx[0]);
 	if (efuse->share_ant) {
 		/* Shared-Ant */
-		if (wl_cpt_test) {
-			if (coex_stat->wl_gl_busy) {
-				table_case = 20;
-				tdma_case = 17;
-			} else {
-				table_case = 10;
-				tdma_case = 15;
-			}
-		} else if (bt_cpt_test) {
-			table_case = 26;
-			tdma_case = 26;
-		} else {
-			if (coex_stat->wl_gl_busy &&
-			    coex_stat->wl_noisy_level == 0)
-				table_case = 14;
-			else
-				table_case = 10;
+		if (coex_stat->wl_gl_busy &&
+		    coex_stat->wl_noisy_level == 0)
+			table_case = 14;
+		else
+			table_case = 10;
 
-			if (coex_stat->wl_gl_busy)
-				tdma_case = 15;
-			else
-				tdma_case = 20;
-		}
+		if (coex_stat->wl_gl_busy)
+			tdma_case = 15;
+		else
+			tdma_case = 20;
 	} else {
 		/* Non-Shared-Ant */
 		table_case = 112;
@@ -2144,11 +2130,7 @@ static void rtw_coex_action_bt_a2dp_pan(struct rtw_dev *rtwdev)
 			tdma_case = 120;
 	}
 
-	if (wl_cpt_test)
-		rtw_coex_set_rf_para(rtwdev, chip->wl_rf_para_rx[1]);
-	else
-		rtw_coex_set_rf_para(rtwdev, chip->wl_rf_para_rx[0]);
-
+	rtw_coex_set_rf_para(rtwdev, chip->wl_rf_para_rx[0]);
 	rtw_coex_table(rtwdev, false, table_case);
 	rtw_coex_tdma(rtwdev, false, tdma_case);
 }
-- 
2.43.0



