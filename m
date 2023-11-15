Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE57433B4
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="towghQi/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A3BC433CA;
	Wed, 15 Nov 2023 19:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077092;
	bh=MRZPBm9SnFwiareoiMb0wYC7ra5XJuhEBt4ikAa3Gg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=towghQi/0hWM6Uk35/mDk/UZsyIFCPjf8IN3nwHGL3bQ8wDGHW5ymtWb7Fhiximop
	 OUmbzCeBMi1beYcbPg9uOoIBobaIPSTB5dyR8OBPvLHVGB40HR5Q8yaxfjOq8SB04O
	 gYSYwfGaLbDhzf2aUn17T0oF64Sk6P4uE9gIYk0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 121/603] wifi: rtw88: Remove duplicate NULL check before calling usb_kill/free_urb()
Date: Wed, 15 Nov 2023 14:11:06 -0500
Message-ID: <20231115191621.608100422@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit de8dd096949820ce5656d41ce409a67603e79327 ]

Both usb_kill_urb() and usb_free_urb() do the NULL check itself, so there
is no need to duplicate it prior to calling.

Fixes: a82dfd33d123 ("wifi: rtw88: Add common USB chip support")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20231008025852.1239450-1-ruanjinjie@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/usb.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index d879d7e3dc81f..e6ab1ac6d7093 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -611,8 +611,7 @@ static void rtw_usb_cancel_rx_bufs(struct rtw_usb *rtwusb)
 
 	for (i = 0; i < RTW_USB_RXCB_NUM; i++) {
 		rxcb = &rtwusb->rx_cb[i];
-		if (rxcb->rx_urb)
-			usb_kill_urb(rxcb->rx_urb);
+		usb_kill_urb(rxcb->rx_urb);
 	}
 }
 
@@ -623,10 +622,8 @@ static void rtw_usb_free_rx_bufs(struct rtw_usb *rtwusb)
 
 	for (i = 0; i < RTW_USB_RXCB_NUM; i++) {
 		rxcb = &rtwusb->rx_cb[i];
-		if (rxcb->rx_urb) {
-			usb_kill_urb(rxcb->rx_urb);
-			usb_free_urb(rxcb->rx_urb);
-		}
+		usb_kill_urb(rxcb->rx_urb);
+		usb_free_urb(rxcb->rx_urb);
 	}
 }
 
-- 
2.42.0



