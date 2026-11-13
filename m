Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585901;
	b=YehWHPRZwKr7HKh8/+NlkRE3SgKG4jOUm8XjSl1nyUWIQGgiltsVgoKuICFYis/7r/J5
	 EdfsgDEaXcY8sbPEtxykc0KGkjWekFt7vfBgHeyJn1DukPhTYc+CtiNQh0Sh/W5TncF+C
	 Cf086CMnJ68nT+iyjwwGsvRuhuNGX9EjFpdQ105HWAoPIivjGPfsfyuyzM4NCvIti2skg
	 O8aPjLwDqNrO9SF+7J1mCyIfAS+wJNDobbQ768kLSqXk9DNTjQzwx9sepI3pQ+TkV8HVS
	 W2r8Vj15oTvi6Avo/xMh6jIfQcD/n6hTAx0oEZrs76YLv2AM23EyfcDFSxioSio6UOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585901;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rk6IHlIUvq5AdTf3Nmj+U72BTkOAXIDhWW4mYhiZb/Q=;
	b=iL6E4j2sWGOC9QSfkKeO5sfuA642Caz0FOTyvfFt0NMm2Uo4BKU3/++Q9CthNnrKV8ZJ
	 9unncxR79yz9DlBxnjNxq3MT6FfNGdJyak6gIQPbeTzczdVuRCWvX8shj4m17veE8Zqjn
	 YFSTt7yJsKpEd7INNUQWNfyGFWciKcNqXFJMB7MTr584DacWhGPEHK70sj88asSjeZatX
	 ynKROSA30Sgs1yQPgs2PkdHKm9/TtcCe/itj7gt5nrLfkIM7MLAQnaO9BkWBZEfLbsQXR
	 iO8HYJhx9RA9z7xoqlXuNaw4FqHSlxquPGH1VXj3iPHf61fRuLA+lEy7MYXlzvP2UsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sx2btVu+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C452606FFE0;
	Fri, 13 Nov 2026 16:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sx2btVu+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1851F000D3;
	Fri, 13 Nov 2026 16:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585901;
	bh=rk6IHlIUvq5AdTf3Nmj+U72BTkOAXIDhWW4mYhiZb/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sx2btVu+zp/7m+CZzf8OC0R1ooY/SrdPlPaxAnU320BlyTVInq/CGJW+f9KoxiOr/
	 TRGUxHXDlfodmNhTtTXVtkzoraRXQZo05Lp+C6nxSBOLKkK0/ZoI+ncAYjozwZIVqZ
	 RtRyFhKlPX4wqGBDl7Oi1nfX3iVAM11nUEy7t7ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehmet Fide <mehmet.fide@screeningeagle.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 467/507] wifi: rtw88: usb: bound what the driver feeds the after-DTIM queue
Date: Fri, 13 Nov 2026 10:52:51 -0500
Message-ID: <20261113153812.579741912@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

[ Upstream commit 04cc8c59a3d79ef7ec2341f1c7aef1d40a0ce7df ]

Frames routed to the high queue are transmitted right after DTIM beacons
only, inside the ATIM window, while they wait in the shared TX page pool.
The driver puts no limit on how many it hands over, so as long as one
station dozes, any sustained broadcast or multicast traffic outruns the
drain and empties the pool: measured on an RTL8822BU AP with a single
client in power save and ~40 frames/s of mDNS chatter, the free page
count at 0x240 goes from 1803 to 16 in about 100 seconds and stays there
for as long as the traffic lasts. From that point every other transmit
queues behind the backlog, authentication responses arrive too late for
anyone to join, and the reserved page download fails ("error beacon
valid"). The AP keeps beaconing and only a reboot recovers.

Feed the high queue through a small budget that refills below the
measured drain rate (about 3 frames per DTIM, ~15/s at dtim_period 2 on
the default 2 TU ATIM window); whatever exceeds the budget leaves on its
access category queue right away. The high queue backlog is now bounded
by the burst size under any load, so the page pool cannot run dry, at
the price that a dozing station may miss part of a broadcast storm.

Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260910081716.769081-2-mehmet.fide@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/usb.c | 41 ++++++++++++++++++++++--
 drivers/net/wireless/realtek/rtw88/usb.h |  5 +++
 2 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index 43b9cdb4a79b0..d9c52094a6124 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -557,7 +557,37 @@ static int rtw_usb_write_data_h2c(struct rtw_dev *rtwdev, u8 *buf, u32 size)
 	return rtw_usb_write_data(rtwdev, &pkt_info, buf);
 }
 
-static u8 rtw_usb_tx_queue_mapping_to_qsel(struct sk_buff *skb)
+#define RTW_USB_HIQ_REFILL_INTERVAL	(HZ / 10)	/* one unit of budget per 100 ms */
+#define RTW_USB_HIQ_BUDGET_MAX		16
+
+static bool rtw_usb_hiq_take_budget(struct rtw_usb *rtwusb)
+{
+	unsigned long flags, elapsed, add;
+	bool ok;
+
+	spin_lock_irqsave(&rtwusb->hiq_lock, flags);
+
+	elapsed = jiffies - rtwusb->hiq_refill;
+	add = elapsed / RTW_USB_HIQ_REFILL_INTERVAL;
+	if (add) {
+		rtwusb->hiq_budget = min_t(unsigned long, rtwusb->hiq_budget + add,
+					   RTW_USB_HIQ_BUDGET_MAX);
+
+		/* keep the unfinished part of the interval for the next unit */
+		rtwusb->hiq_refill = jiffies - elapsed % RTW_USB_HIQ_REFILL_INTERVAL;
+	}
+
+	ok = rtwusb->hiq_budget > 0;
+	if (ok)
+		rtwusb->hiq_budget--;
+
+	spin_unlock_irqrestore(&rtwusb->hiq_lock, flags);
+
+	return ok;
+}
+
+static u8 rtw_usb_tx_queue_mapping_to_qsel(struct rtw_usb *rtwusb,
+					   struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -568,7 +598,8 @@ static u8 rtw_usb_tx_queue_mapping_to_qsel(struct sk_buff *skb)
 		qsel = TX_DESC_QSEL_MGMT;
 	else if (is_broadcast_ether_addr(hdr->addr1) ||
 		 is_multicast_ether_addr(hdr->addr1))
-		qsel = (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) ?
+		qsel = (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) &&
+		       rtw_usb_hiq_take_budget(rtwusb) ?
 		       TX_DESC_QSEL_HIGH : skb->priority;
 	else if (skb_get_queue_mapping(skb) <= IEEE80211_AC_BK)
 		qsel = skb->priority;
@@ -588,7 +619,7 @@ static int rtw_usb_tx_write(struct rtw_dev *rtwdev,
 	u8 *pkt_desc;
 	int ep;
 
-	pkt_info->qsel = rtw_usb_tx_queue_mapping_to_qsel(skb);
+	pkt_info->qsel = rtw_usb_tx_queue_mapping_to_qsel(rtwusb, skb);
 	pkt_desc = skb_push(skb, chip->tx_pkt_desc_sz);
 	memset(pkt_desc, 0, chip->tx_pkt_desc_sz);
 	ep = qsel_to_ep(rtwusb, pkt_info->qsel);
@@ -1029,6 +1060,10 @@ static int rtw_usb_init_tx(struct rtw_dev *rtwdev)
 	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
 	int i;
 
+	spin_lock_init(&rtwusb->hiq_lock);
+	rtwusb->hiq_budget = RTW_USB_HIQ_BUDGET_MAX;
+	rtwusb->hiq_refill = jiffies;
+
 	rtwusb->txwq = create_singlethread_workqueue("rtw88_usb: tx wq");
 	if (!rtwusb->txwq) {
 		rtw_err(rtwdev, "failed to create TX work queue\n");
diff --git a/drivers/net/wireless/realtek/rtw88/usb.h b/drivers/net/wireless/realtek/rtw88/usb.h
index 9b695b688b242..94ff21dd08463 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.h
+++ b/drivers/net/wireless/realtek/rtw88/usb.h
@@ -75,6 +75,11 @@ struct rtw_usb {
 	u8 out_ep[RTW_USB_EP_MAX];
 	int qsel_to_ep[TX_DESC_QSEL_MAX];
 
+	/* protects hiq_budget and hiq_refill */
+	spinlock_t hiq_lock;
+	u32 hiq_budget;
+	unsigned long hiq_refill;
+
 	struct workqueue_struct *txwq, *rxwq;
 
 	struct sk_buff_head tx_queue[RTW_USB_EP_MAX];
-- 
2.53.0



