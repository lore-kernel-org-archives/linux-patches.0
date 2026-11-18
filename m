Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038243;
	b=kxhZOBgxDd5ajzlk6obdS9pISH7N5PIvngQgCt3vMLOLZ3KiFxLyZpKuCzF5AAL8zzur
	 J9j6w3l20Bsvj1laLU9qjo5cL9wJEdZ7GcLDnQFItfD/Vacl7DrLdySW2iHUVcBoXfQPG
	 F5i12/MThQarLrgFZC423XxBmK2sKDJ6k+KTuJpqugAAxtOqd5kARkfO7Y9wLO3mB9glF
	 oBjtepFeP0Kpt0jCP4G9Zm6A/IUxUCiD8wness8kzl7OjzvZhkZeiIgI1XA3KuSAT6noq
	 bdsw7x6Samh48KaMIsFLat5LlSBqHnx587cykduhFYL8vKGFIpwrvL6OJtAUbQaIBAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038243;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8NBHSFeZJuj08sKk1UVXOnz0EqZbqwln+QNDcjae0yU=;
	b=jcsxpAcsRDtUc9ASEqJ8SvcwmRSLnJrPsBtvh1xyK7340yNUIUoXSbP8YNNwMLyUaTpE
	 wMHcgfo8fr4JStOjiI8DKXQzItuX/2gEM1KQH1hbRy4b5vmo6/WELkWCF68PREnkMuZAO
	 C25EyeXJAPdVpBku/oc5D2+LazPz1LJle5AOk0vhi4HFZPKTHgsskmYGgQDlmS6mW7yP6
	 yEIgpF0awxxtAxOM0zAkhM8KhWE3MhbC5A5E0CCAlwmzf6CNnUevuxYbajHQ702s5jJ/I
	 hZO2nXJsEAwpngF9Ag+Ehmf9eiGMRnBIMT0vC8ZBtPSbnwYCf9BM/geZ+9RUptC4IIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XLn2Ih8x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF553606A330;
	Wed, 18 Nov 2026 21:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XLn2Ih8x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 137411F000C5;
	Wed, 18 Nov 2026 21:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038243;
	bh=8NBHSFeZJuj08sKk1UVXOnz0EqZbqwln+QNDcjae0yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XLn2Ih8xx5f6pswe62XKTLs00UzKY13djlViYLjQcoYKY2KKBfJZLrRNyitnaK0QV
	 OSaoYclyGrC2JUcTVB4Udi8cy1u0P9FXaac9/1SH9SbJMI94m0g9hkkmTbQBCBkikh
	 1Seu9vE3SSAh1x+vPz5JQYwqQFe6rFHbje5i7p8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehmet Fide <mehmet.fide@screeningeagle.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1676/3318] wifi: rtw88: usb: bound what the driver feeds the after-DTIM queue
Date: Wed, 18 Nov 2026 15:38:18 +0100
Message-ID: <20261118150412.083893937@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c19689b13383a..117bcb2659dc6 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -496,7 +496,37 @@ static int rtw_usb_write_data_h2c(struct rtw_dev *rtwdev, u8 *buf, u32 size)
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
@@ -507,7 +537,8 @@ static u8 rtw_usb_tx_queue_mapping_to_qsel(struct sk_buff *skb)
 		qsel = TX_DESC_QSEL_MGMT;
 	else if (is_broadcast_ether_addr(hdr->addr1) ||
 		 is_multicast_ether_addr(hdr->addr1))
-		qsel = (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) ?
+		qsel = (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) &&
+		       rtw_usb_hiq_take_budget(rtwusb) ?
 		       TX_DESC_QSEL_HIGH : skb->priority;
 	else if (skb_get_queue_mapping(skb) <= IEEE80211_AC_BK)
 		qsel = skb->priority;
@@ -527,7 +558,7 @@ static int rtw_usb_tx_write(struct rtw_dev *rtwdev,
 	u8 *pkt_desc;
 	int ep;
 
-	pkt_info->qsel = rtw_usb_tx_queue_mapping_to_qsel(skb);
+	pkt_info->qsel = rtw_usb_tx_queue_mapping_to_qsel(rtwusb, skb);
 	pkt_desc = skb_push(skb, chip->tx_pkt_desc_sz);
 	memset(pkt_desc, 0, chip->tx_pkt_desc_sz);
 	ep = qsel_to_ep(rtwusb, pkt_info->qsel);
@@ -795,6 +826,10 @@ static int rtw_usb_init_tx(struct rtw_dev *rtwdev)
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
index 86697a5c0103a..36a57a0e0df61 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.h
+++ b/drivers/net/wireless/realtek/rtw88/usb.h
@@ -74,6 +74,11 @@ struct rtw_usb {
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



