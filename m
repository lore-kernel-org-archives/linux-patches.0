Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052511;
	b=2YOENxl7dElNkriVDUnSKDsp+oPf700DuafLILylt8k+canpRU1YQeGeq2QOUSeYJFqC
	 l3Mgz6Xs/C1BUKX8eBT7OiWG7sMc9iYPFSYK46rTGSoUyIN2QnIX0ory0cfuV8nAeZr7o
	 NrHjodZ0744aAMQwfp76KDT8m3U7kXfJUZPO6GZrLioewUXQ/uypi2woRVCzl1DL2rFTK
	 amXBPd9aybpW2/cmiohZw2sA8AxhbVwl2bv9yBYMnRksNL7c795G3sPXMf3k2f/GsxbAa
	 aV6L8Kaw6911ss4XZkQgWX6hdMPLC+KHTXsXHyGD1yn2iwW2mM984dQY7lqCFOLqPiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052511;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oeDcQjtS1cxMpOXdlKRIH8u+TI6CFR7WIU4M1D/VHcs=;
	b=oaCQmNsawq2cRzs7JllTBJXL/JlsH78rnLPisqonijvte/Sh1r3GzFBcvue1k5IU8iOK
	 KVi0GbuDEnRP0YyUKHAg2aKQtvUHLeNDq3efOKGhqm44OhNqrUmIEXsj2juW5yi8ol9i2
	 S1lD5xNt+Q8x2sktF/f+nK0uP4nBU0RxxniPceQCMiYJ+Yjd5nj4UHOhaVfbGkavBnaU4
	 8hkiCYwTUN3i+ptENDE1nW0mgcrxbbhk+bDjc1Z/wyvFiSxs1qKFw62S3hpFyOBUAAApL
	 02d5sOxI6pjBzkjjcMB4glsGY7VOWvY7sY7gYpCnbd2gzf60A+/xsPRnbFXib9nX6HQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CdhPQrKa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C9C606A32F;
	Thu, 19 Nov 2026 01:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CdhPQrKa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ACA81F000C4;
	Thu, 19 Nov 2026 01:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052510;
	bh=oeDcQjtS1cxMpOXdlKRIH8u+TI6CFR7WIU4M1D/VHcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CdhPQrKaE7KzL4GQqBB9gTA24P9hM6KgnB1OWF490gW4hPfBDRGcE4ryfQBOQLC9n
	 dbN+V0bcV7Mwpzm1R/lcwYu0eevdCDTlfM4keMKXvuVNuaOnuXcuMhAUDynTjrWMPs
	 0w2JkC8LjoBNcPFCMBloBGr8uK6XIMp6rEhCoq8s=
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
Subject: [PATCH 5.15 0591/2214] wifi: mt76: fix memory leak in USB TX path
Date: Wed, 18 Nov 2026 15:37:47 +0100
Message-ID: <20261118150034.535885474@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e40569fc7edea..8510be7f95a98 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -904,23 +904,36 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
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
@@ -932,6 +945,14 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
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



