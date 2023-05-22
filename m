Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF89171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F137C433D2;
	Mon, 22 May 2023 19:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784486;
	bh=LPKFGFwNpYR6Q6d+j4k4p64ZsgAzGdvac2iYO0pcWJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jdl7kWyQogADraxrP+pG005NqmMyeRtz+PJKwLPfqgFPIck5esKPe3tiN3Mqh2uZP
	 zwyXqE29oTaZix2yRNVQ/3/3podZ+9BIM1utBbH5jpcC06Nca43FCqrYSUpsZEywO6
	 eI9ODTXmg/kHInSEIkG1AEi79ADh27aj12TZsiFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 098/364] wifi: rtw88: fix memory leak in rtw_usb_probe()
Date: Mon, 22 May 2023 20:06:43 +0100
Message-Id: <20230522190415.200071648@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dongliang Mu <dzm91@hust.edu.cn>

[ Upstream commit 48181d285623198c33bb9698992502687b258efa ]

drivers/net/wireless/realtek/rtw88/usb.c:876 rtw_usb_probe()
warn: 'hw' from ieee80211_alloc_hw() not released on lines: 811

Fix this by modifying return to a goto statement.

Signed-off-by: Dongliang Mu <dzm91@hust.edu.cn>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230309021636.528601-1-dzm91@hust.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index a10d6fef4ffaf..8e2c99f9c3662 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -832,7 +832,7 @@ int rtw_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 
 	ret = rtw_usb_alloc_rx_bufs(rtwusb);
 	if (ret)
-		return ret;
+		goto err_release_hw;
 
 	ret = rtw_core_init(rtwdev);
 	if (ret)
-- 
2.39.2



