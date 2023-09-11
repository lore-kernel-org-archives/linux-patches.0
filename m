Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B69011705
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2976C433C7;
	Mon, 11 Sep 2023 14:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443014;
	bh=vU54qRClrFlVBzpY6Kc0RqltHjN+vYUxCEwD+xpxYuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZTYhprvZa6SENNXGDHrfseKMbtfTlb0G65+fAd+PRMDmeFDZ8sexi93j68XG+a9Is
	 B4ybmt5amgB0WfBHcCgN39iEnr/wOQkNytV/NuTzb+BnlnMHjziipRvmZN3Fa9HTZm
	 EzmJcnqAEnruQUqnv+/3q54FAnnpP5UT/LAU+sPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 227/737] wifi: rtw89: 8852b: rfk: fine tune IQK parameters to improve performance on 2GHz band
Date: Mon, 11 Sep 2023 15:41:26 +0200
Message-ID: <20230911134656.919923117@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit b3bfc4fb1edc8136396ece2d7204c2ee5cae188d ]

A few samples get bad performance on 2GHz band, so use proper IQK command
code and select another group to have wider range of calibration value.

Fixes: f2abe804e823 ("wifi: rtw89: 8852b: rfk: add IQK")
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230803110150.8457-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/rtw8852b_rfk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852b_rfk.c b/drivers/net/wireless/realtek/rtw89/rtw8852b_rfk.c
index 722ae34b09c1f..b6fccb1cb7a5c 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852b_rfk.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852b_rfk.c
@@ -846,7 +846,7 @@ static bool _iqk_one_shot(struct rtw89_dev *rtwdev, enum rtw89_phy_idx phy_idx,
 	case ID_NBTXK:
 		rtw89_phy_write32_mask(rtwdev, R_P0_RFCTM, B_P0_RFCTM_EN, 0x0);
 		rtw89_phy_write32_mask(rtwdev, R_IQK_DIF4, B_IQK_DIF4_TXT, 0x011);
-		iqk_cmd = 0x308 | (1 << (4 + path));
+		iqk_cmd = 0x408 | (1 << (4 + path));
 		break;
 	case ID_NBRXK:
 		rtw89_phy_write32_mask(rtwdev, R_P0_RFCTM, B_P0_RFCTM_EN, 0x1);
@@ -1078,7 +1078,7 @@ static bool _iqk_nbtxk(struct rtw89_dev *rtwdev, enum rtw89_phy_idx phy_idx, u8
 {
 	struct rtw89_iqk_info *iqk_info = &rtwdev->iqk;
 	bool kfail;
-	u8 gp = 0x3;
+	u8 gp = 0x2;
 
 	switch (iqk_info->iqk_band[path]) {
 	case RTW89_BAND_2G:
-- 
2.40.1



