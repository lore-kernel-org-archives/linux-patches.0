Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045489;
	b=l09is9CvLYAd9tPAOoBHE2KH6CdTmBVDORjwaMxiVt+BXl9Mh0CTbTELydbNFS4/pXCB
	 uHvqgM5L/H8lt3VokIDrLGvq5RJyr90Ta5PvAYhPjOjA3zF+7gWw++gsxs8G6GwzxtQiA
	 CU0mi6/dXVTN7yfdFsW2nXk1Nd9UoKqnGyI3J+EGlEcEQAN/Kf0OWr4nmqrzzSVvUJaPq
	 hn56d4P088Gt3HG5l4EdzheMG0AnDiQOFHoDiR2iDdNvsq/Mhk3Vy+WhXXKTFzmfIuPV7
	 Js9vQvZwsdUttFze1dz2PYe3IY9yP5CKHkV9hwyCDdnIDknuXJ1xeqXvlUfepJiMQfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045489;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VEPanzYuV2U4cYjOiGjI3qndbUgwRDOpLEJXdZjdlaY=;
	b=y4NK+dsGJhpv9FrwNpeLk1iL+k9YCxhsXkF3Wsjbd6kXwU/WtVgp7hI3+TnkJFtNd8ZA
	 VXfGal0Nl7qz33wPjORhbtISeuUCoeAo8lW2wqBlDTepqQdF0Y6PjRQIcO+ankzF3bWrm
	 MfYOQ1o7wLTIcqqOT6m6WL6+rR6uEkkEYmFNnypTrS5GzkQHEuOrvlAvAfZlWxDvrDOAn
	 sYIge/m3jnuAg/UgWpvgOPWpyz1De5zbwUS6UKxZbXrbRjPtCKyafe/FGSybD46jjCZsx
	 0rG8JcZxhzrnA9WBNM9AsOx0TXrzC+pa+eudsWTccxINpNPvifDfunia+7Hmxh094Pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0gwpXGQt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA28606A31C;
	Wed, 18 Nov 2026 23:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0gwpXGQt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946171F000C4;
	Wed, 18 Nov 2026 23:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045489;
	bh=VEPanzYuV2U4cYjOiGjI3qndbUgwRDOpLEJXdZjdlaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0gwpXGQtyiX1yPik3fDtSp1TQsQmD1S0Z0BD5VuM8BrF3/3vPDJXbOmn+TE3Feb+b
	 lmhdLG8otJDC4zXjhfDUskZmtGXRxVfAb4/OJrHR/SxwXLZ/0L/Xx6v1o5TxzwrQgq
	 2TRM3Q924wMycYG3e+fLAhGkrLt3VnD5uQKPBxT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Eason Lai <eason.lai@mediatek.com>,
	Hans Buchheim <hbuchheim@gmail.com>,
	Sergei Melnichenko <sergei.melnichenko@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0894/2857] wifi: mt76: fix memory leak in USB TX path
Date: Wed, 18 Nov 2026 15:32:08 +0100
Message-ID: <20261118150233.747548685@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eason Lai <eason.lai@mediatek.com>

[ Upstream commit 82856da2d3b6a30011f4db6ea5f34c13484e0ef8 ]

When errors occur in mt76u_tx_queue_skb(), the skb is not properly
freed, leading to memory leaks. This happens when:
- The queue is full
- tx_prepare_skb() drops zero-length frames (such as WMM NULL frames)
  to prevent hardware TX hangs
- Buffer setup fails

Fix by properly releasing the skb with ieee80211_tx_status_ext() when
the queue is full or tx_prepare_skb() fails, and using
mt76_tx_complete_skb() when mt76u_tx_setup_buffers() fails (since
tx_prepare_skb() has already succeeded and may have allocated resources
that need cleanup)

Fixes: b40b15e1521f ("mt76: add usb support to mt76 layer")
Cc: stable@vger.kernel.org
Tested-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Closes: https://github.com/morrownr/mt76/issues/83
Signed-off-by: Eason Lai <eason.lai@mediatek.com>
Tested-by: Hans Buchheim <hbuchheim@gmail.com>
Reported-by: Sergei Melnichenko <sergei.melnichenko@gmail.com>
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20260914021920.32246-3-eason.lai@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 31 ++++++++++++++++++++----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 1e2133670291c..82d20e052d19a 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -856,23 +856,36 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 		   enum mt76_txq_id qid, struct sk_buff *skb,
 		   struct mt76_wcid *wcid, struct ieee80211_sta *sta)
 {
+	struct ieee80211_tx_status status = {
+		.sta = sta,
+	};
 	struct mt76_tx_info tx_info = {
 		.skb = skb,
 	};
 	u16 idx = q->head;
 	int err;
 
-	if (q->queued == q->ndesc)
-		return -ENOSPC;
+	if (q->queued == q->ndesc) {
+		err = -ENOSPC;
+		goto err_free_skb;
+	}
 
 	skb->prev = skb->next = NULL;
 	err = dev->drv->tx_prepare_skb(dev, NULL, qid, wcid, sta, &tx_info);
 	if (err < 0)
-		return err;
+		goto err_free_skb;
 
 	err = mt76u_tx_setup_buffers(dev, tx_info.skb, q->entry[idx].urb);
-	if (err < 0)
-		return err;
+	if (err < 0) {
+		/*
+		 * mt76_tx_status_skb_get() walks the idr and dereferences
+		 * a freed skb. This SKB is not counted in non-AQL counter
+		 * due to error return, so using 0xffff as wcid to keep
+		 * balanced.
+		 */
+		mt76_tx_complete_skb(dev, 0xffff, tx_info.skb);
+		goto err_ret;
+	}
 
 	mt76u_fill_bulk_urb(dev, USB_DIR_OUT, q2ep(q->hw_idx),
 			    q->entry[idx].urb, mt76u_complete_tx,
@@ -884,6 +897,14 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 	q->queued++;
 
 	return idx;
+
+err_free_skb:
+	status.skb = tx_info.skb;
+	spin_lock_bh(&dev->rx_lock);
+	ieee80211_tx_status_ext(dev->hw, &status);
+	spin_unlock_bh(&dev->rx_lock);
+err_ret:
+	return err;
 }
 
 static void mt76u_tx_kick(struct mt76_dev *dev, struct mt76_queue *q)
-- 
2.53.0



