Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4363A1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:42:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1CCC433D2;
	Wed, 28 Dec 2022 15:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242146;
	bh=VfFYS3P/YwmDM0aWfN8kmbrIPtkCvXK+TmZw2A0TAnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AkZXJA/pQDQWehcnpmpWJarGXEmTPnHwcCGKhkeXo12TWuMsCIwmhNClvFF8ZhdWp
	 fBREy4mqS4fL1GU8gBOxHwy9DMtN/kqOe8gJZ0NXaFIEPM0elefLR+A9y0yTQgY65m
	 gvoDqSvcMX5ml3dvHEfQY+LJyqsWsyHF/RpoLeN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0334/1146] wifi: rtw89: Fix some error handling path in rtw89_core_sta_assoc()
Date: Wed, 28 Dec 2022 15:31:13 +0100
Message-Id: <20221228144339.233463537@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 81c0b8928437ddfe87b0024c5bd817bc331d8524 ]

'ret' is not updated after a function call in rtw89_core_sta_assoc().
This prevent error handling from working.

Add the missing assignment.

Fixes: e3ec7017f6a2 ("rtw89: add Realtek 802.11ax driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/7b1d82594635e4406d3438f33d8da29eaa056c5a.1668354547.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index bc2994865372..ad420d7ec8af 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -2527,7 +2527,7 @@ int rtw89_core_sta_assoc(struct rtw89_dev *rtwdev,
 	}
 
 	/* update cam aid mac_id net_type */
-	rtw89_fw_h2c_cam(rtwdev, rtwvif, rtwsta, NULL);
+	ret = rtw89_fw_h2c_cam(rtwdev, rtwvif, rtwsta, NULL);
 	if (ret) {
 		rtw89_warn(rtwdev, "failed to send h2c cam\n");
 		return ret;
-- 
2.35.1



