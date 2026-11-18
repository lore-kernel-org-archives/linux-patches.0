Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016870;
	b=xJRnrnvpOpxztQs/W82U473cfqyT4n+rOGzhBukW1cwno7U2iLSK18nDml9oygeN79qV
	 Km9kJGfJJC9yehy3vzXZk/Bpn5sOARNQAMUYZ5pjrZ1z5dzurdgn2r3oPBK4yKPWFTV3M
	 ZzPfFiiGORxSPfYFASisgExMQxnKvZ06zUmjGMCG9A++wBEv1kde4NOr82TQfx4TFMChs
	 xLvGZzcqA+DSWcOuhoJ3j0mujKB8s5pL3USNuz3gJKhxEbZ68379b4b1XE33EWiiR5vcx
	 yQRXTefexMDeJFjovemfE0GGbjtQn0RnC65pz4/0a6BRSqPp/+iSNg+C4WHDT5k3HJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016870;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G+GOE4sstUpu7qG46bNxRUReBy1Lp8L5C1HbwYsEuhE=;
	b=D5nDaPUKtOiJG8LUwYV2NA8ICAJB5hb8OYWzfThPT6hbUPGGxIZPV5Cn8EPCbE6ud7kT
	 658FyOrjh5yWiWQ2BggiEAgm5lJer++shzWZyH5K3gDaccUgvHKvNWf5jXHHEe+3zbbob
	 pUM32BctKq9rYClFN7CFAh7CnwgU7QLG7q5K0EhswSv8VzzJoQEX0veJaI4FnF7q5iCW7
	 CGRmq7cS67zmXcROkuM54PRumST/74TdbdYw1Y2I4aCwsQJxIwBvWE/sxz6/UxpGHwhmK
	 VwC9GChMnWcylYAGZDqxEVl6VRh9CzFS4NM17nIBvNKt+HoAI4sUwRhrcuQU7xHaFsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fVLSAvQD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCAD606A332;
	Wed, 18 Nov 2026 15:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fVLSAvQD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C3C1F000C5;
	Wed, 18 Nov 2026 15:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016870;
	bh=G+GOE4sstUpu7qG46bNxRUReBy1Lp8L5C1HbwYsEuhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fVLSAvQD1uec6h6GPbAbmMC5VKG/ncI3X7esPPB56xD/DjZDCE0+gCK0ebua/kJpx
	 +yZ8LQyUU1a/y0ETKJzszapD6/7Re4fC+K4BxFKYMnjf7CHxoUtNOxPltIOQ5r06w+
	 sCryqd/6HKu3vXlh8cMNZdCR5jFC8yb3Qv4URE58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kim Wooseok <5mghybrid@khu.ac.kr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0681/2651] wifi: rtl8xxxu: unwind incomplete receive startup
Date: Wed, 18 Nov 2026 15:32:01 +0100
Message-ID: <20261118150312.379608379@linuxfoundation.org>
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

[ Upstream commit 4c58fb8944a2cfbe5506534de0cf58646408d31a ]

rtl8xxxu_start() allocates and submits RX URBs one at a time. If a later
allocation fails, the error path frees the TX pool but leaves earlier RX
requests active. A partial TX or RX allocation failure can also leave
ret at zero, so start reports success despite the incomplete setup.

Allocate the RX pool before submitting any of it, and return ENOMEM
whenever a pool allocation fails. Pass start errors through
rtl8xxxu_stop(), including interrupt URB submission failures, so the
existing stop path cancels work and releases both active requests and
partially allocated pools.

Share the submission loop with the RX worker. Both callers keep requests
that fail with ENOMEM/EAGAIN. For a fatal error during startup, free the
rest of the unsubmitted batch and return the error so start can unwind.
In the worker, free only the failed request and continue with the rest
of the batch.

Keep the allocation loop in a small helper so the setup and error paths
in start remain easy to follow.

On an RTL8192EU, I exercised every error exit in rtl8xxxu_start()
except interrupt-URB allocation and submission failures, which this
adapter does not use.

Fixes: 26f1fad29ad9 ("New driver: rtl8xxxu (mac80211)")
Assisted-by: GPT-6 Astra
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kim Wooseok <5mghybrid@khu.ac.kr>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260921-codex-rtl-rx-v3-submit-v4-2-eeb09fe8f791@khu.ac.kr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/core.c | 96 +++++++++++---------
 1 file changed, 54 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/core.c b/drivers/net/wireless/realtek/rtl8xxxu/core.c
index 795a5ec2f8cd4..5cd6498cc47f2 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/core.c
@@ -58,6 +58,7 @@ MODULE_PARM_DESC(dma_agg_pages, "Set DMA aggregation pages (range 1-127, 0 to di
 #define RTL8XXXU_TX_URB_LOW_WATER	25
 #define RTL8XXXU_TX_URB_HIGH_WATER	32
 
+static void rtl8xxxu_stop(struct ieee80211_hw *hw, bool suspend);
 static int rtl8xxxu_submit_rx_urb(struct rtl8xxxu_priv *priv,
 				  struct rtl8xxxu_rx_urb *rx_urb);
 
@@ -5832,6 +5833,28 @@ static void rtl8xxxu_free_rx_resources(struct rtl8xxxu_priv *priv)
 	spin_unlock_irqrestore(&priv->rx_urb_lock, flags);
 }
 
+static int rtl8xxxu_alloc_rx_urbs(struct rtl8xxxu_priv *priv)
+{
+	struct rtl8xxxu_rx_urb *rx_urb;
+	int i;
+
+	/* No RX work is active until the complete pool has been allocated. */
+	for (i = 0; i < RTL8XXXU_RX_URBS; i++) {
+		rx_urb = kmalloc_obj(struct rtl8xxxu_rx_urb);
+		if (!rx_urb)
+			return -ENOMEM;
+
+		usb_init_urb(&rx_urb->urb);
+		INIT_LIST_HEAD(&rx_urb->list);
+		rx_urb->hw = priv->hw;
+
+		list_add_tail(&rx_urb->list, &priv->rx_urb_pending_list);
+		priv->rx_urb_pending_count++;
+	}
+
+	return 0;
+}
+
 static void rtl8xxxu_queue_rx_urb(struct rtl8xxxu_priv *priv,
 				  struct rtl8xxxu_rx_urb *rx_urb)
 {
@@ -5859,32 +5882,21 @@ static void rtl8xxxu_queue_rx_urb(struct rtl8xxxu_priv *priv,
 	spin_unlock_irqrestore(&priv->rx_urb_lock, flags);
 }
 
-static void rtl8xxxu_rx_urb_work(struct work_struct *work)
+static int rtl8xxxu_submit_rx_urbs(struct rtl8xxxu_priv *priv, bool startup)
 {
-	struct rtl8xxxu_priv *priv;
 	struct rtl8xxxu_rx_urb *rx_urb, *tmp;
-	struct list_head local;
 	unsigned long flags;
+	LIST_HEAD(local);
 	int ret;
 
-	priv = container_of(work, struct rtl8xxxu_priv, rx_urb_wq);
-	INIT_LIST_HEAD(&local);
-
 	spin_lock_irqsave(&priv->rx_urb_lock, flags);
-
 	list_splice_init(&priv->rx_urb_pending_list, &local);
 	priv->rx_urb_pending_count = 0;
-
 	spin_unlock_irqrestore(&priv->rx_urb_lock, flags);
 
 	list_for_each_entry_safe(rx_urb, tmp, &local, list) {
 		list_del_init(&rx_urb->list);
 		ret = rtl8xxxu_submit_rx_urb(priv, rx_urb);
-		/*
-		 * If out of memory or temporary error, put it back on the
-		 * queue and try again. Otherwise the device is dead/gone
-		 * and we should drop it.
-		 */
 		switch (ret) {
 		case 0:
 			break;
@@ -5893,11 +5905,29 @@ static void rtl8xxxu_rx_urb_work(struct work_struct *work)
 			rtl8xxxu_queue_rx_urb(priv, rx_urb);
 			break;
 		default:
+			usb_free_urb(&rx_urb->urb);
+			if (startup)
+				goto free_remaining;
 			dev_warn(&priv->udev->dev,
 				 "failed to requeue urb with error %i\n", ret);
-			usb_free_urb(&rx_urb->urb);
 		}
 	}
+
+	return 0;
+
+free_remaining:
+	list_for_each_entry_safe(rx_urb, tmp, &local, list) {
+		list_del(&rx_urb->list);
+		usb_free_urb(&rx_urb->urb);
+	}
+	return ret;
+}
+
+static void rtl8xxxu_rx_urb_work(struct work_struct *work)
+{
+	struct rtl8xxxu_priv *priv = container_of(work, struct rtl8xxxu_priv, rx_urb_wq);
+
+	rtl8xxxu_submit_rx_urbs(priv, false);
 }
 
 /*
@@ -7408,7 +7438,6 @@ static void rtl8xxxu_watchdog_callback(struct work_struct *work)
 static int rtl8xxxu_start(struct ieee80211_hw *hw)
 {
 	struct rtl8xxxu_priv *priv = hw->priv;
-	struct rtl8xxxu_rx_urb *rx_urb;
 	struct rtl8xxxu_tx_urb *tx_urb;
 	unsigned long flags;
 	int ret, i;
@@ -7423,14 +7452,13 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
 	if (priv->usb_interrupts) {
 		ret = rtl8xxxu_submit_int_urb(hw);
 		if (ret)
-			goto exit;
+			goto error_out;
 	}
 
 	for (i = 0; i < RTL8XXXU_TX_URBS; i++) {
 		tx_urb = kmalloc_obj(struct rtl8xxxu_tx_urb);
 		if (!tx_urb) {
-			if (!i)
-				ret = -ENOMEM;
+			ret = -ENOMEM;
 
 			goto error_out;
 		}
@@ -7441,31 +7469,21 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
 		priv->tx_urb_free_count++;
 	}
 
+	ret = rtl8xxxu_alloc_rx_urbs(priv);
+	if (ret)
+		goto error_out;
+
 	priv->tx_stopped = false;
 
 	spin_lock_irqsave(&priv->rx_urb_lock, flags);
 	priv->shutdown = false;
 	spin_unlock_irqrestore(&priv->rx_urb_lock, flags);
 
-	for (i = 0; i < RTL8XXXU_RX_URBS; i++) {
-		rx_urb = kmalloc_obj(struct rtl8xxxu_rx_urb);
-		if (!rx_urb) {
-			if (!i)
-				ret = -ENOMEM;
-
-			goto error_out;
-		}
-		usb_init_urb(&rx_urb->urb);
-		INIT_LIST_HEAD(&rx_urb->list);
-		rx_urb->hw = hw;
-
-		ret = rtl8xxxu_submit_rx_urb(priv, rx_urb);
-		if (ret)
-			rtl8xxxu_queue_rx_urb(priv, rx_urb);
-	}
+	ret = rtl8xxxu_submit_rx_urbs(priv, true);
+	if (ret)
+		goto error_out;
 
 	schedule_delayed_work(&priv->ra_watchdog, 2 * HZ);
-exit:
 	/*
 	 * Accept all data and mgmt frames
 	 */
@@ -7478,13 +7496,7 @@ static int rtl8xxxu_start(struct ieee80211_hw *hw)
 	return ret;
 
 error_out:
-	rtl8xxxu_free_tx_resources(priv);
-	/*
-	 * Disable all data and mgmt frames
-	 */
-	rtl8xxxu_write16(priv, REG_RXFLTMAP2, 0x0000);
-	rtl8xxxu_write16(priv, REG_RXFLTMAP0, 0x0000);
-
+	rtl8xxxu_stop(hw, false);
 	return ret;
 }
 
-- 
2.53.0



