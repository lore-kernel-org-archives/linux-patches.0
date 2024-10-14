Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9A01AAE0C;
	Mon, 14 Oct 2024 14:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917401; cv=none; b=hlR0fiVapE7ATKZ68EVWJ8eJEjaEMcX2r5AHksGCIxFlusvFnQ3wzgDWZZHUzSWtJVGgo7WWop67Gvf4JgI7c5CXemUbrpxPul8YEhd4PHse3HrIT6Ui1ajyBssHrGNwrTQhr1SC8Dlynpf0YYep+n//HOLEKSqJidas4vy/coo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917401; c=relaxed/simple;
	bh=rSxQvAObKBXj5v+sZsROu5iSzWof/6+Pn7vs2w0N7AY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YOmwcxQqBVJK/6jCGV8e7aXOf6s4rsaSR2q2t4wn3k+lAK20rtEbTKYiC/XY35k7/QADvH4bBiiuLSh85n1Y3aRvEVB02K3VlU+Y29079ZAwvZZtEqSsR2GC2NOz9CexdMHOGrE2hwvsG599Xhi724wCuSr08aHHFdmrLVDAF4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UIveLzpq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UIveLzpq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E70C4CEC3;
	Mon, 14 Oct 2024 14:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917401;
	bh=rSxQvAObKBXj5v+sZsROu5iSzWof/6+Pn7vs2w0N7AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UIveLzpqxfqt0A1bPLeZZZCkR5ZXX34gr0V/EgXyqelRLK1pBQH03X83OXgcXS/RM
	 l/sqim8bcL7qjNY1pf6MDieX7sDieHE1OOev/3wzvSGFhsTm8lAQ56Gnzp29xtTXFz
	 YgjsO7dNod4q7JjyX72I970CHD7d0ga83LW9kn5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Kandybka <d.kandybka@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 009/798] wifi: rtw88: remove CPT execution branch never used
Date: Mon, 14 Oct 2024 16:09:23 +0200
Message-ID: <20241014141218.316417939@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a82476f47a7c4..8627ab0ce3bdf 100644
--- a/drivers/net/wireless/realtek/rtw88/coex.c
+++ b/drivers/net/wireless/realtek/rtw88/coex.c
@@ -2195,7 +2195,6 @@ static void rtw_coex_action_bt_a2dp_pan(struct rtw_dev *rtwdev)
 	struct rtw_coex_stat *coex_stat = &coex->stat;
 	struct rtw_efuse *efuse = &rtwdev->efuse;
 	u8 table_case, tdma_case;
-	bool wl_cpt_test = false, bt_cpt_test = false;
 
 	rtw_dbg(rtwdev, RTW_DBG_COEX, "[BTCoex], %s()\n", __func__);
 
@@ -2203,29 +2202,16 @@ static void rtw_coex_action_bt_a2dp_pan(struct rtw_dev *rtwdev)
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
@@ -2236,11 +2222,7 @@ static void rtw_coex_action_bt_a2dp_pan(struct rtw_dev *rtwdev)
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



