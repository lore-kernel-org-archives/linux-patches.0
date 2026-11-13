Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590043;
	b=h0sN2K9ozICUIPQHR/YHijw47Px18obZnIJZn1BWKGaNNUD2t4SiH/wJq+d/m/BJhVgs
	 VyQdbkU6NjWK/9C2ifqSfXJ2cmwASAdhbcLTJPnyGTVnO6WmNeljMMJUo/CWLguXrqxgk
	 MQfncMuSpMG2PzrKFhk1ikQUiXQwO5UtGtwFQCzEds/mc7ioFmUxEr25P0D3lOcR14JYT
	 jlelUHXSfRvEcfh3Gm+YPXDg4oitsdvc8BgAeJYZNixU81CjjZGpZCISVJhxzNXujWSe6
	 32d2OTLyjy+7YFnaxwH0OQdprIU1HBCWIhqhHXsVazW85qTCGeGGNrc+gHFUJXUE6Vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590043;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TOjE7O6U1f5QpySA5wSxqV0i2UpHQhVpZOazyxYvjB8=;
	b=1W6tGwwhSvJ4dYNTW7JdlJBh76IYC8xsZ/5KJ9EKgWvMZX4okr1hZ8nCH768jPM1cxpL
	 NsU2b84YD2blzNBYkTTYWA6OcPq6t2QCUni6NB3odRBOXdI5URjuhBgfd1KW2M0AdIb6D
	 IvfJUk7uNxpbPoj+xHMUg2YcyEL0uulDp9AECxh/D/Jns4QT/CIlRktQE2I+JxaJWGe0C
	 7ArtGPymJlhENl0SKD3LCC7u9hxKA4qu3myFAssjG/M24Ja4cuBzgufXqPhLG38PQm/WY
	 utjkxPHFrr3G8we1xfLGbOqHX9GDs4JRqrHXxTCYM9NjY8+D1e6+YsshSWf9ZL4/sfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mUo7qxZU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAD4606A89C;
	Fri, 13 Nov 2026 17:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mUo7qxZU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491F71F000C4;
	Fri, 13 Nov 2026 17:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590043;
	bh=TOjE7O6U1f5QpySA5wSxqV0i2UpHQhVpZOazyxYvjB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mUo7qxZUo/AkA5hf0vwnW7SnK+Wmg1JUfaba0AO7EYOfpdXJiuufd+0K2sB5H5rYn
	 rEyv70qq/sHSnn42h4NeZJEsDWe8oFlB6YgAtRtRrQdr5rr2n0RvzKrxOs1qN4U+CF
	 i9DkVpmDJl5SlyoTOYCyodd+Gc2JlNf8lNBczrjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Luka Gejak <luka.gejak@linux.dev>,
	Josef Schlehofer <pepe.schlehofer@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 078/686] wifi: rtw88: TX report with long timeout for non-PCIE devices
Date: Fri, 13 Nov 2026 10:43:31 -0500
Message-ID: <20261113153823.536386187@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 7cde94dab0e74434ccc0a387d7ad373fb3becda0 ]

Many USB and SDIO devices can't report TX status within 500 ms, and
extending to 2500 ms as tested USB/SDIO devices can fix the problem [1].
To avoid adding chip ID one by one, and this change looks harmless.
Keep PCIE using short timeout, and others use long timeout.

[1] https://lore.kernel.org/linux-wireless/20260921165343.8131-1-pepe.schlehofer@gmail.com/

Cc: stable@vger.kernel.org
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
Tested-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
Link: https://patch.msgid.link/20260924004637.9958-1-pkshih@realtek.com
[ Adjust the removed condition. This tree has no RTL8723BS support and
  lacks commit 4d688f22ebbf ("wifi: rtw88: tx: extend the TX report purge
  timeout to RTL8723BS"), so the old check has no rtw_is_8723bs() part.
  The resulting code is the same as upstream. ]
Signed-off-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/tx.c | 9 +++++----
 drivers/net/wireless/realtek/rtw88/tx.h | 3 ++-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/tx.c b/drivers/net/wireless/realtek/rtw88/tx.c
index e73c06b268cfa..b46f4fc8384cb 100644
--- a/drivers/net/wireless/realtek/rtw88/tx.c
+++ b/drivers/net/wireless/realtek/rtw88/tx.c
@@ -196,7 +196,7 @@ void rtw_tx_report_purge_timer(struct timer_list *t)
 void rtw_tx_report_enqueue(struct rtw_dev *rtwdev, struct sk_buff *skb, u8 sn)
 {
 	struct rtw_tx_report *tx_report = &rtwdev->tx_report;
-	unsigned long timeout = RTW_TX_PROBE_TIMEOUT;
+	unsigned long timeout;
 	unsigned long flags;
 	u8 *drv_data;
 
@@ -208,9 +208,10 @@ void rtw_tx_report_enqueue(struct rtw_dev *rtwdev, struct sk_buff *skb, u8 sn)
 	__skb_queue_tail(&tx_report->queue, skb);
 	spin_unlock_irqrestore(&tx_report->q_lock, flags);
 
-	if (rtwdev->chip->id == RTW_CHIP_TYPE_8723D &&
-	    rtwdev->hci.type == RTW_HCI_TYPE_USB)
-		timeout = msecs_to_jiffies(2500);
+	if (rtwdev->hci.type == RTW_HCI_TYPE_PCIE)
+		timeout = RTW_TX_PROBE_TIMEOUT_SHORT;
+	else
+		timeout = RTW_TX_PROBE_TIMEOUT_LONG;
 
 	mod_timer(&tx_report->purge_timer, jiffies + timeout);
 }
diff --git a/drivers/net/wireless/realtek/rtw88/tx.h b/drivers/net/wireless/realtek/rtw88/tx.h
index d34cdeca16f19..168f48e87853d 100644
--- a/drivers/net/wireless/realtek/rtw88/tx.h
+++ b/drivers/net/wireless/realtek/rtw88/tx.h
@@ -7,7 +7,8 @@
 
 #define RTK_TX_MAX_AGG_NUM_MASK		0x1f
 
-#define RTW_TX_PROBE_TIMEOUT		msecs_to_jiffies(500)
+#define RTW_TX_PROBE_TIMEOUT_SHORT	msecs_to_jiffies(500)
+#define RTW_TX_PROBE_TIMEOUT_LONG	msecs_to_jiffies(2500)
 
 struct rtw_tx_desc {
 	__le32 w0;
-- 
2.53.0



