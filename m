Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478961CFEDA;
	Wed,  2 Oct 2024 13:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875200; cv=none; b=lDdDznM8omy+564h2pj7Wk7HcROw4S3VIUHt9FgXpLy/yDa1M5DPwTgfvsVDONaeCeKpTfbf65ICi8crLGfuOQFGVdjnSzdljk1Zw4xWE58jnvq+CS7JZWAJtpW8/SSG9Pp6JrH5tS/C+wz+J8JnK7mE7J3EEqHwwy9fYE/GIXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875200; c=relaxed/simple;
	bh=WjN2aX/GrLny/+bvRjK8blnw+RbOZjOql41GaU8WvkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TLkuJ/Ylz2jPuUSYXacrUP9udhnQtdOFK2jn82BpGTkZdeWRSRt+tW2ZweeFqKc1XK9KTpXSJHsEePetu5DvuZf3nr33A7c8osUMhMu2SIoDVed4RzYQ49D+l1UxV63MVJdeU/uUZAuHit6opV27NzAdFoRsam+6F5apbXSJOh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H99ilaO4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H99ilaO4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB9FC4CEC5;
	Wed,  2 Oct 2024 13:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875199;
	bh=WjN2aX/GrLny/+bvRjK8blnw+RbOZjOql41GaU8WvkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H99ilaO4H8iVmyPbiT1OlHI1Jszq9H1BOLGeXJQBIyzaPd6mDtLBD1UqCJMALjYQ/
	 FySgRLbbDINAjHdn5OHlwBtK0223vyY2J+58QmGN0Ska2UK6rhGkw4fXW6N9sa6hfZ
	 WR1L8ufdebLzbUvUXnmpXv1tGCgUahiU5hMEqwdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Kandybka <d.kandybka@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 025/695] wifi: rtw88: remove CPT execution branch never used
Date: Wed,  2 Oct 2024 14:50:23 +0200
Message-ID: <20241002125823.499327146@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index de3332eb7a227..a99776af56c27 100644
--- a/drivers/net/wireless/realtek/rtw88/coex.c
+++ b/drivers/net/wireless/realtek/rtw88/coex.c
@@ -2194,7 +2194,6 @@ static void rtw_coex_action_bt_a2dp_pan(struct rtw_dev *rtwdev)
 	struct rtw_coex_stat *coex_stat = &coex->stat;
 	struct rtw_efuse *efuse = &rtwdev->efuse;
 	u8 table_case, tdma_case;
-	bool wl_cpt_test = false, bt_cpt_test = false;
 
 	rtw_dbg(rtwdev, RTW_DBG_COEX, "[BTCoex], %s()\n", __func__);
 
@@ -2202,29 +2201,16 @@ static void rtw_coex_action_bt_a2dp_pan(struct rtw_dev *rtwdev)
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
@@ -2235,11 +2221,7 @@ static void rtw_coex_action_bt_a2dp_pan(struct rtw_dev *rtwdev)
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



