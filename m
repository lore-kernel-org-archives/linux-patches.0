Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB5E171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:53:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D44C4339B;
	Mon, 22 May 2023 19:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684785211;
	bh=ys4Shg1rSjlTllpR8QDpMQyD4SrMTksqSvS0GyBivhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mN+MN55CMolMevn/ePDCVYT1mzYHh8dhzC9kHiKh+5z0ui8txkQcUl4M8EBKJCO7L
	 8g/K5y6jqEHdll4xHg7TGvkZTO8gCKNuL+w+PTj+pc6t3wO7H3xfFqB9jiTamKRs3V
	 jkYXN/0k43+lGj8/LrUwD+DAeCLFHWsnK/9jWdy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.3 318/364] wifi: rtw88: correct qsel_to_ep[] type as int
Date: Mon, 22 May 2023 20:10:23 +0100
Message-Id: <20230522190420.725341090@linuxfoundation.org>
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

From: Ping-Ke Shih <pkshih@realtek.com>

commit 8e4942db5f5ed7b7d9690d93235b3ca49c5c59ce upstream.

qsel_to_ep[] can be assigned negative value, so change type from 'u8' to
'int'. Otherwise, Smatch static checker warns:
  drivers/net/wireless/realtek/rtw88/usb.c:219 rtw_usb_parse() warn:
  assigning (-22) to unsigned variable 'rtwusb->qsel_to_ep[8]'

Cc: stable@vger.kernel.org
Fixes: a6f187f92bcc ("wifi: rtw88: usb: fix priority queue to endpoint mapping")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/linux-wireless/c3f70197-829d-48ed-ae15-66a9de80fa90@kili.mountain/
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230508085539.46795-1-pkshih@realtek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/usb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/usb.h b/drivers/net/wireless/realtek/rtw88/usb.h
index 30647f0dd61c..ad1d7955c6a5 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.h
+++ b/drivers/net/wireless/realtek/rtw88/usb.h
@@ -78,7 +78,7 @@ struct rtw_usb {
 	u8 pipe_interrupt;
 	u8 pipe_in;
 	u8 out_ep[RTW_USB_EP_MAX];
-	u8 qsel_to_ep[TX_DESC_QSEL_MAX];
+	int qsel_to_ep[TX_DESC_QSEL_MAX];
 	u8 usb_txagg_num;
 
 	struct workqueue_struct *txwq, *rxwq;
-- 
2.40.1



