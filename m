Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016873;
	b=gTw1l3xenGIlP+2tODsCJrRkmyIG+4l83eaW6uZM7CqfantIUyxJzKw08nfngA2ll/kv
	 sBKqBxUA/1LS03R5mNnlVjiB5Se2q+7M9OTbmwMV5HjYuGzC+psQZe14kGpo2wqJDxnuu
	 fozjha79OsUZzcrhNB3pE5tr2xTcQavQ3tbdLF8V4FtFhLXBoZOb+KFH95prWJAvKMX7v
	 Ue11Q5gIC1pZ0WajXJPiX4eheDq1YWteJMXoSZtyRCtuVlEOc55EUVMU7Bov6DZnnZgaf
	 fwLhvtVdUjcANeZaGyZnC8fsuJ+q/FRBkymLW/tAxWGnlDT+ti0EGkRpGL+aGBUi2DQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016873;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0O43lIVIGu0y2MBhk0wmrpMTf332KI7enUibeSkZSe4=;
	b=h5YR3xy9DyeZVKbp9RNigABden28+usvVj6PbbRufTiDMrJ+5obREUiRIF3AW3v5xbL2
	 U3MlUhZagO2C9cEoVKyP88C7/2K7td05I7h7DvlQe6AyQhPobavqYvVpVuYtrvPyUueF1
	 lQAbW4ZuI4zA7aX7OU6QpbeymJMfDK51mB0DDHikJO1aiwpVzjvKTI7IYYx+bks6I8RmB
	 UpVoQXfb4kYra27gjsJ3ITqpStmaKzjyZqNjxjB81sWtIiS8amiVOGNwetRP7UgSYf217
	 jG7DQB3B3QHglYherEveOORMEFLadSbRzXqOmVLK3nVS7oAPc0xqh69fmoA3rSMKhoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K9hE2084;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242AC606A332;
	Wed, 18 Nov 2026 15:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K9hE2084
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F2D1F000C5;
	Wed, 18 Nov 2026 15:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016873;
	bh=0O43lIVIGu0y2MBhk0wmrpMTf332KI7enUibeSkZSe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K9hE2084qIZawuiC8AKVPxnEypbR7a3A63PFB/1s29f2QcNAAIj0lGifIHEkDTipR
	 DTxC0PsDbWZd2+Oz0WPIADp2mDeYBawVdXve2YcqQM9CKpl+oCEKGNkeRRBAs8ZHCr
	 34LPf+dg8QZ+1waMgLOWTX1Kgpnv9e2lDS68x7rA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kim Wooseok <5mghybrid@khu.ac.kr>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0682/2651] wifi: rtl8xxxu: preserve RX requests across recoverable transfer errors
Date: Wed, 18 Nov 2026 15:32:02 +0100
Message-ID: <20261118150312.416326682@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Kim Wooseok <5mghybrid@khu.ac.kr>

[ Upstream commit 2f77c66694108785a1f6ae6c5de06453e7f7a91f ]

rtl8xxxu resubmits completed RX requests when more than eight URBs are
waiting on the pending list. It starts with 32 URBs, but frees them on
completion errors. After enough errors, the remaining pool can no longer
reach the submission threshold. Reception then stays stopped even after
the errors end. Temporary submission failures can leave a small batch
waiting with no further work scheduled, too.

Keep the URB when a completion reports EPROTO, EILSEQ, ETIME, EOVERFLOW,
ECOMM or ENOSR. Free its receive buffer and return the request to the
same pending list used by normal completions. ENOMEM/EAGAIN from startup
or worker submission uses this path as well, so a submission failure
cannot strand a request during recovery.

Use one delayed work item to submit the pending requests. An error
queues a retry after 100 ms without moving an existing reservation back.
If a normal completion takes the pending count above eight,
mod_delayed_work(..., 0) brings the work forward. This limits repeated
retries when reception is not progressing, while allowing normal traffic
to replenish the pool promptly. The 100 ms delay is therefore not a
minimum wait for each failed URB.

Keep the shutdown check, queue insertion and scheduling under the RX
lock. Stop sets shutdown under that lock, cancels the delayed work
synchronously, then drains active and pending requests. Cancellation and
device removal continue to free their URBs.

Fixes: 26f1fad29ad9 ("New driver: rtl8xxxu (mac80211)")
Assisted-by: GPT-6 Astra
Signed-off-by: Kim Wooseok <5mghybrid@khu.ac.kr>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260921-codex-rtl-rx-v3-submit-v4-3-eeb09fe8f791@khu.ac.kr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/core.c  | 46 ++++++++++++-------
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu.h  |  2 +-
 2 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/core.c b/drivers/net/wireless/realtek/rtl8xxxu/core.c
index 5cd6498cc47f2..3d0c22db30a80 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/core.c
@@ -54,6 +54,7 @@ MODULE_PARM_DESC(dma_agg_pages, "Set DMA aggregation pages (range 1-127, 0 to di
 #define USB_VENDOR_ID_REALTEK		0x0bda
 #define RTL8XXXU_RX_URBS		32
 #define RTL8XXXU_RX_URB_PENDING_WATER	8
+#define RTL8XXXU_RX_URB_RETRY_DELAY_MS	100
 #define RTL8XXXU_TX_URBS		64
 #define RTL8XXXU_TX_URB_LOW_WATER	25
 #define RTL8XXXU_TX_URB_HIGH_WATER	32
@@ -5856,9 +5857,8 @@ static int rtl8xxxu_alloc_rx_urbs(struct rtl8xxxu_priv *priv)
 }
 
 static void rtl8xxxu_queue_rx_urb(struct rtl8xxxu_priv *priv,
-				  struct rtl8xxxu_rx_urb *rx_urb)
+				  struct rtl8xxxu_rx_urb *rx_urb, bool defer_schedule)
 {
-	struct sk_buff *skb;
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->rx_urb_lock, flags);
@@ -5866,16 +5866,13 @@ static void rtl8xxxu_queue_rx_urb(struct rtl8xxxu_priv *priv,
 	if (!priv->shutdown) {
 		list_add_tail(&rx_urb->list, &priv->rx_urb_pending_list);
 		priv->rx_urb_pending_count++;
-		/*
-		 * Arm the worker under rx_urb_lock so this is atomic with the
-		 * shutdown check: moving it out of the lock would let a
-		 * completion arm the work after rtl8xxxu_stop() canceled it.
-		 */
-		if (priv->rx_urb_pending_count > RTL8XXXU_RX_URB_PENDING_WATER)
-			schedule_work(&priv->rx_urb_wq);
+		/* Serialize scheduling with the shutdown check and cancellation. */
+		if (defer_schedule)
+			schedule_delayed_work(&priv->rx_urb_wq,
+					      msecs_to_jiffies(RTL8XXXU_RX_URB_RETRY_DELAY_MS));
+		else if (priv->rx_urb_pending_count > RTL8XXXU_RX_URB_PENDING_WATER)
+			mod_delayed_work(system_percpu_wq, &priv->rx_urb_wq, 0);
 	} else {
-		skb = (struct sk_buff *)rx_urb->urb.context;
-		dev_kfree_skb_irq(skb);
 		usb_free_urb(&rx_urb->urb);
 	}
 
@@ -5902,7 +5899,7 @@ static int rtl8xxxu_submit_rx_urbs(struct rtl8xxxu_priv *priv, bool startup)
 			break;
 		case -ENOMEM:
 		case -EAGAIN:
-			rtl8xxxu_queue_rx_urb(priv, rx_urb);
+			rtl8xxxu_queue_rx_urb(priv, rx_urb, true);
 			break;
 		default:
 			usb_free_urb(&rx_urb->urb);
@@ -5925,7 +5922,8 @@ static int rtl8xxxu_submit_rx_urbs(struct rtl8xxxu_priv *priv, bool startup)
 
 static void rtl8xxxu_rx_urb_work(struct work_struct *work)
 {
-	struct rtl8xxxu_priv *priv = container_of(work, struct rtl8xxxu_priv, rx_urb_wq);
+	struct rtl8xxxu_priv *priv = container_of(to_delayed_work(work),
+					       struct rtl8xxxu_priv, rx_urb_wq);
 
 	rtl8xxxu_submit_rx_urbs(priv, false);
 }
@@ -6585,10 +6583,24 @@ static void rtl8xxxu_rx_complete(struct urb *urb)
 
 		skb = NULL;
 		rx_urb->urb.context = NULL;
-		rtl8xxxu_queue_rx_urb(priv, rx_urb);
+		rtl8xxxu_queue_rx_urb(priv, rx_urb, false);
 	} else {
 		dev_dbg(dev, "%s: status %i\n",	__func__, urb->status);
-		goto cleanup;
+
+		switch (urb->status) {
+		case -EPROTO:
+		case -EILSEQ:
+		case -ETIME:
+		case -EOVERFLOW:
+		case -ECOMM:
+		case -ENOSR:
+			dev_kfree_skb(skb);
+			urb->context = NULL;
+			rtl8xxxu_queue_rx_urb(priv, rx_urb, true);
+			return;
+		default:
+			goto cleanup;
+		}
 	}
 	return;
 
@@ -7519,7 +7531,7 @@ static void rtl8xxxu_stop(struct ieee80211_hw *hw, bool suspend)
 	 * it drained via rtl8xxxu_submit_rx_urb(), so a worker still running
 	 * after the kill could submit a URB that escapes it.
 	 */
-	cancel_work_sync(&priv->rx_urb_wq);
+	cancel_delayed_work_sync(&priv->rx_urb_wq);
 
 	usb_kill_anchored_urbs(&priv->rx_anchor);
 	usb_kill_anchored_urbs(&priv->tx_anchor);
@@ -7832,7 +7844,7 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
 	spin_lock_init(&priv->tx_urb_lock);
 	INIT_LIST_HEAD(&priv->rx_urb_pending_list);
 	spin_lock_init(&priv->rx_urb_lock);
-	INIT_WORK(&priv->rx_urb_wq, rtl8xxxu_rx_urb_work);
+	INIT_DELAYED_WORK(&priv->rx_urb_wq, rtl8xxxu_rx_urb_work);
 	INIT_DELAYED_WORK(&priv->ra_watchdog, rtl8xxxu_watchdog_callback);
 	INIT_DELAYED_WORK(&priv->update_beacon_work, rtl8xxxu_update_beacon_work_callback);
 	skb_queue_head_init(&priv->c2hcmd_queue);
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index eeb18eb0e4c0f..c6953051d9c40 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1809,7 +1809,7 @@ struct rtl8xxxu_priv {
 	struct list_head rx_urb_pending_list;
 	int rx_urb_pending_count;
 	bool shutdown;
-	struct work_struct rx_urb_wq;
+	struct delayed_work rx_urb_wq;
 
 	u8 mac_addr[ETH_ALEN];
 	char chip_name[8];
-- 
2.53.0



