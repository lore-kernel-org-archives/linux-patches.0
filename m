Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064506;
	b=kMUCZx85/L3mpyRcePhlqFIj8qn/nGUPrUY5ZUYZDzs3GlJ+kKOz7GJkMy3Ibc9aZQkS
	 JjxwYxWUZty81uEyIV8uLuKlHoRH/O8BP9adwE4Q0xwM8d0kGNYkPAvQmOtYmPKPo0W4w
	 7fGXArgauOydWZ4XvlfAeCTIUs2MZmTOlmX26hKHALGHidzDv2/+zU3HOadey7T6wTska
	 65u8/zqZGIhKlAJDdSHAzYh+bIs13SOADK3CH1hq5wtXGNsnhVML344trl+1yY2qUlmAl
	 NYYPsjH+9F+eMxA9O7KHw6zkJs9FdNf+s/FVaBQkQqPghwTc4A5Pq2no4ZkHyydV9IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064506;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x2l3EynidRlULUOi7yei87qn6uyYejWDxbtMGgfOasc=;
	b=y+puNADQqOhpqkOLlY1lIxzj/6mHDtj2V3ybsgUWut8dUU/ETNN+4sthZLJHbmr10VkG
	 50vvzI3SVIrhsXIR08RdY3Saoh7ztq5paY1Bl/iQlaj/3OUSu73mrf53xpaXshtECQ+eu
	 /wKSxY18tUIKiOIxD9CgSaRQipHjlxYVgsRRdmt/U/bRPDexSpKamXdZZ+64wBC3/NpOU
	 J2i3lrMR3HX3246yPLXtZFlVO9x2blHz/zRForPyq5qICFIdo4KnwOHPFAiPPIZJuYRm5
	 a5jUHeOaOGNy5kDjoglYSYzdJf4bmv5pkZ8nipAbRCTO5wskhGF5BkrggrP6LodwpaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sJnTbUMv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8648C606CE4F;
	Sat,  7 Nov 2026 15:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sJnTbUMv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F791F008A2;
	Sat,  7 Nov 2026 15:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064506;
	bh=x2l3EynidRlULUOi7yei87qn6uyYejWDxbtMGgfOasc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sJnTbUMvY3jZmCnoy/dmEkNPvhzNhKpex1uHx1t2MFaS73kGvT6faxJ+yzmu+xY/D
	 KW32rf8qSG+E4Ly+hKrOra7LT01Q6EAI+ZQY4Y3ibxaZaxJux+7ZVCGwSSSdjXhkdy
	 xUG0mOEswezNZ1p8M4FhXgh5lUNS1+MNNZujqoCM=
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
Subject: [PATCH 7.3 0538/1257] wifi: mt76: fix memory leak in USB TX path
Date: Sat,  7 Nov 2026 08:47:14 -0500
Message-ID: <20261107134954.263379969@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index a9af3aa6b80a9..dfc12f6944a74 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -893,6 +893,9 @@ mt76u_tx_queue_skb(struct mt76_phy *phy, struct mt76_queue *q,
 		   enum mt76_txq_id qid, struct sk_buff *skb,
 		   struct mt76_wcid *wcid, struct ieee80211_sta *sta)
 {
+	struct ieee80211_tx_status status = {
+		.sta = sta,
+	};
 	struct mt76_tx_info tx_info = {
 		.skb = skb,
 	};
@@ -900,17 +903,27 @@ mt76u_tx_queue_skb(struct mt76_phy *phy, struct mt76_queue *q,
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
 
 	mt76u_fill_bulk_urb(dev, USB_DIR_OUT, q->ep, q->entry[idx].urb,
 			    mt76u_complete_tx, &q->entry[idx]);
@@ -921,6 +934,14 @@ mt76u_tx_queue_skb(struct mt76_phy *phy, struct mt76_queue *q,
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



