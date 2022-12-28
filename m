Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD76D1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3487BC433EF;
	Wed, 28 Dec 2022 15:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242469;
	bh=mENYC5g2HqOxzqqvRtFT3mgeP8kUvIJdOJhIm/iwziE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bRdLnbL1KBatp9+0Bba2nPK6LMgpWWmkbi91srEcUxfxi8t9CO54QPFagLrvwgAJL
	 uKEtEuZqaj0wsy4J7jBYi45oZlD5JrZdKhOrVx2hh8M8rMd3EYBfQvFQ/PK8X2W0b0
	 EdgbN7z6VzZATT03SxX3aJicQo+LS6R5ufa/WYqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zong-Zhe Yang <kevin_yang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0373/1146] wifi: rtw89: fix physts IE page check
Date: Wed, 28 Dec 2022 15:31:52 +0100
Message-Id: <20221228144340.294370748@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zong-Zhe Yang <kevin_yang@realtek.com>

[ Upstream commit 9e2f177de1bfb7d891bf38140bda54831ecef30d ]

The index RTW89_PHYSTS_BITMAP_NUM is not a valid physts IE page.
So, fix the check condition.

Fixes: eb4e52b3f38d ("rtw89: fix incorrect channel info during scan")
Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221118042322.26794-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/phy.c b/drivers/net/wireless/realtek/rtw89/phy.c
index 6a6bdc652e09..c894a2b614eb 100644
--- a/drivers/net/wireless/realtek/rtw89/phy.c
+++ b/drivers/net/wireless/realtek/rtw89/phy.c
@@ -3139,7 +3139,7 @@ void rtw89_phy_env_monitor_track(struct rtw89_dev *rtwdev)
 
 static bool rtw89_physts_ie_page_valid(enum rtw89_phy_status_bitmap *ie_page)
 {
-	if (*ie_page > RTW89_PHYSTS_BITMAP_NUM ||
+	if (*ie_page >= RTW89_PHYSTS_BITMAP_NUM ||
 	    *ie_page == RTW89_RSVD_9)
 		return false;
 	else if (*ie_page > RTW89_RSVD_9)
-- 
2.35.1



