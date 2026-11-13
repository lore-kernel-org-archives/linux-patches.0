Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590626;
	b=A7M7zHhXsNtc9yeXa2FZQRmDWnbFTAbesoR+sgG+1cOXj+8xlpLRNBFtyDjUAXrFtW4o
	 VDq3t/PjoE3kaflFApDlqRjEOTpGghs9s+wI3t19i9pKjYE2ywzhGSj8NFKtX4bngxav5
	 t/1bcgwfg9Pu1yEJeqXfCTn3CNk+zK0ejmA4yAVUddvcOAFbaLZjmn+nwFE08mGtCDUXu
	 pIrOnjYPkgVsmFG6gsaqrZXlmmjj3CYa1QPge0+vEx8A89nst5F2blElCQ6Nccvinw7WR
	 MpoPjLAY3gEZ6fWVh/8DGvLKvM7D0oBe0fp2N9qJQMtq8LGT/Ks8To3lphNWKVAj0mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590626;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J8mHFTVeN11mB4KiVQHm7xav+4isZo0eDtZHL3R6A0A=;
	b=vCUePaXyyfSmOVcMYW/r6EOpO3OzLE4jX5n3xGv3MPvzVhY5zcn06OHNq8ruQl+oChWL
	 pq9hEFlWXGozZLlEy5J5y27w0rq04jEGa1SNvumSYgqlrew77UMR0vSKJWPxRS6jxjvQR
	 j6cRMsA9vTUhx9daJWXmnN2uZpo3ee3tLZNLBz3sq9wwPuaiZyV2p9rnO00ZzmtH0RaeN
	 1FhMHSshr15fuFLJdXJaQutZ8jg+Rs/D6Y65Bmlx6QxsaTwuLPQBKmLzOT+VQWMISN7VQ
	 mQL1viVArsfPb2I142udosOrJQ/9sO7l/wDFxh+MbpsXVARc1Wk1LTVELJXOaM9qfHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z9Pm9JWg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3889F6075E1A;
	Fri, 13 Nov 2026 17:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z9Pm9JWg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91C21F000C4;
	Fri, 13 Nov 2026 17:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590626;
	bh=J8mHFTVeN11mB4KiVQHm7xav+4isZo0eDtZHL3R6A0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z9Pm9JWgfCtyiVfUqnKsylZ/m3UBP78RekFMQlFrbO6yrUYvMNOzpLkI33G8MLTs3
	 ctgJapoWJEYDbWkZ/r5VYXzsboUcTHFAeGxmLQwpWw+wJ08OimLvClndStEdOZ11AL
	 bqzpdD0XWA9+7kIvH9jaY7Fqke+k9qdbjKsCake4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehmet Fide <mehmet.fide@screeningeagle.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 548/686] wifi: rtw88: usb: bound what the driver feeds the after-DTIM queue
Date: Fri, 13 Nov 2026 10:51:21 -0500
Message-ID: <20261113153840.135896381@linuxfoundation.org>
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
index 355c607202381..c60413fd5c6d7 100644
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
@@ -1025,6 +1056,10 @@ static int rtw_usb_init_tx(struct rtw_dev *rtwdev)
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



