Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830830;
	b=qOGoevuDSFtjZQpsklyH90311zdXhDVGkEWU6ED5oQ5PJr0shwGvZAfIjr2aUgZw9MSD
	 hhLnEziXexim+pkcwn2Z+2TZcx4U0uQMhBij79Kk33kKfT3teRlCKOgCO9QgH3ScROxlX
	 5IF7GdyXoDYew/MpRghbqvGzYpD06SL/7elIw3IveZpTyr0mnc9ERAbLeIzKD0JvcdXgU
	 Q6RBv5Qyjh/J2ZLO3C4o00bsPQli7fX4Z1+sQSD5jCJ+vV7yKlWvdK3MeuOk870rkdIdI
	 r6gjA8YNxC2DKRFNtZXGTnoVaDvvoActdPj4wMw9w35p91zIjJu0ZOyb86szdSV7p7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830830;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AEq+aNIXQJJB3nzH48binUpVDBU+MM7rp28ZKg8h57E=;
	b=4hRaLd/TOg9GKr7Qn2nfGt6IL+fXgJ+OQr1mL4EjLSgW7Cto3B7Z+BH2JEgT7ge+ReBF
	 RkI6bw8m1POkoj1zRUqsQTIz4qeAPI4o6qzSvtTb98b0nIwbzLRJPiwZurHhnzIAbIPc1
	 GVLgTYBx8ihGPgHwdDuaVpiEsH2TxOsUpRDHxukZHjcu8JJF0AP3taYz/5UqOaidvw5yb
	 BIYg9US3oXkP9Xyo75xG6UilzyecZbqFqnTWv75SlV+FPruXCBeY8PK+sy13coFUZ+62W
	 w5Lv7ErT6ub1C6gfE/8Q3g/lT1IXC3ZqwvkyV2Qs5w15xD7PWsNE3GF8wJp9s/G3hbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="o3j+/CJP";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011F6606B39F;
	Wed,  4 Nov 2026 22:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o3j+/CJP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927F01F00A02;
	Wed,  4 Nov 2026 22:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830829;
	bh=AEq+aNIXQJJB3nzH48binUpVDBU+MM7rp28ZKg8h57E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o3j+/CJP2evrk7M4iuorOX3XaFDCl3TfelNe2BBe7B1YcmoENppPZocXGqjqJKDk9
	 pp79T0MZs/GIspA8HUDUFS69GDjZIimQyw5kOUnx3kZrp7aTiJx0c8jZHWKcLYLBFr
	 SFj7JOQqMkxp4zI8FFxeSuVUcagvSi19S/tEn4GM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0307/1005] wifi: mt76: set the EOSP bit in the QoS header of the last released frame
Date: Wed,  4 Nov 2026 16:00:40 -0500
Message-ID: <20261104211052.530962966@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 0b8d2524716099ea4743fa65bc364f94b3106a31 ]

When the driver implements .release_buffered_frames, mac80211 leaves the
U-APSD signalling entirely to the driver: "In this case it is also
responsible for setting the EOSP flag in the QoS header of the frames"
(include/net/mac80211.h). Only IEEE80211_TX_STATUS_EOSP was being set,
which merely ends the service period inside mac80211, so on air the
service period was never terminated. Clients that wait for EOSP before
going back to doze keep the SP open and stop triggering, which stalls all
downlink traffic for that station.

Set the wire EOSP bit on the last frame of a U-APSD service period.
EOSP has no meaning for a PS-Poll response, so pass the release reason
down and leave those frames alone.

Link: https://patch.msgid.link/20260801145334.1166751-4-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 731caeda72b52..93275bb692fa5 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -415,16 +415,23 @@ mt76_txq_dequeue(struct mt76_phy *phy, struct mt76_txq *mtxq)
 
 static void
 mt76_queue_ps_skb(struct mt76_phy *phy, struct ieee80211_sta *sta,
-		  struct sk_buff *skb, bool last)
+		  struct sk_buff *skb, bool last,
+		  enum ieee80211_frame_release_type reason)
 {
 	struct mt76_wcid *wcid = (struct mt76_wcid *)sta->drv_priv;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 
 	info->control.flags |= IEEE80211_TX_CTRL_PS_RESPONSE;
-	if (last)
+	if (last) {
 		info->flags |= IEEE80211_TX_STATUS_EOSP |
 			       IEEE80211_TX_CTL_REQ_TX_STATUS;
 
+		if (reason == IEEE80211_FRAME_RELEASE_UAPSD &&
+		    ieee80211_is_data_qos(hdr->frame_control))
+			*ieee80211_get_qos_ctl(hdr) |= IEEE80211_QOS_CTL_EOSP;
+	}
+
 	mt76_skb_set_moredata(skb, !last);
 	__mt76_tx_queue_skb(phy, MT_TXQ_PSD, skb, wcid, sta, NULL);
 }
@@ -457,14 +464,15 @@ mt76_release_buffered_frames(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 
 			nframes--;
 			if (last_skb)
-				mt76_queue_ps_skb(phy, sta, last_skb, false);
+				mt76_queue_ps_skb(phy, sta, last_skb, false,
+						  reason);
 
 			last_skb = skb;
 		} while (nframes);
 	}
 
 	if (last_skb) {
-		mt76_queue_ps_skb(phy, sta, last_skb, true);
+		mt76_queue_ps_skb(phy, sta, last_skb, true, reason);
 		dev->queue_ops->kick(dev, hwq);
 	} else {
 		ieee80211_sta_eosp(sta);
-- 
2.53.0



