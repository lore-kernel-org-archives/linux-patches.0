Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC041863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:36:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA98C43392;
	Wed, 28 Dec 2022 15:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241769;
	bh=p3hXWRPPoNXR2E4sAcA79WuzPSZuZfPAYqk43Ikyg1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kEBvPM0OH9zilJBji1Fn6oCIJdbB0luiWiz9vjUpkDNb/5nVpX9Cf67SGtTEp68Oq
	 PCBhjt7b4MR5MpozDOJVfZzStTdxZVDEycTE10ZMm8KBVNixIO441uz9tZhqTQYKsO
	 Vh38slUfQq3KjuNfr/QpX6gRzP2XUx6TVnRJ/lcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0325/1073] wifi: rtw89: Fix some error handling path in rtw89_core_sta_assoc()
Date: Wed, 28 Dec 2022 15:31:53 +0100
Message-Id: <20221228144336.835358121@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index 8b338e5ce364..732015228bd3 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -2500,7 +2500,7 @@ int rtw89_core_sta_assoc(struct rtw89_dev *rtwdev,
 	}
 
 	/* update cam aid mac_id net_type */
-	rtw89_fw_h2c_cam(rtwdev, rtwvif, rtwsta, NULL);
+	ret = rtw89_fw_h2c_cam(rtwdev, rtwvif, rtwsta, NULL);
 	if (ret) {
 		rtw89_warn(rtwdev, "failed to send h2c cam\n");
 		return ret;
-- 
2.35.1



