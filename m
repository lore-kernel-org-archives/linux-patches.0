Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051314;
	b=x/JTZIiTFqv2Z0lMffGpAIt+f2b9RkMQ71UQTnvyIq3pTj9iPj3j+QC/9D/ubT2KU183
	 fCejDjm/po1cb/t3F5gOsF63qnjxpL//eLoSg7eXVTK1Xmf269SkORPHYu7Z/Rz/tuvxy
	 /J7k1MEZTHmqiXXdU0F22BT3Wu0XPrQyWyrsRl3ublVUQv69rjwr7R5UWip/v8i2eXehI
	 cOD2KHO4WLEFwrR3QsB4ARdji5tPqUpIad7CYsumni4INPAKY4+xvqOUtk+H+NIJoQW+/
	 3w1VJ/wXNm7C05Gvv2UppdBRBt/uI8qw2Uk6jPtnPs+LvDqzLqdl/JHfIrukPSm5bGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051314;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R59CHNzasqQoabYW1i5zdZHk2jTEkqs0pHPHhL4O3mc=;
	b=XGbLacpheSwkzg2gJCjEodkbIrQ/ENbmeWRVonr445O6NhUwmuVXNPdkKqEcngkvsDzb
	 4Xy/gDe6JYS0fZuH3kOJ4PvC2iMMl9fWhkUGP2/e5kuSs9ehhhYqqy1bgCDtdNkZf+rvy
	 ImU4fmPiuAlN/xmyoXBXwUSfZRzkmUeaE7/uxpnnqecagxASA74nrmqn2l7oB67ryxUG+
	 Fq7Yekz1W5T/+S6C7xs39ca3ft2yujf4onGEVPlMujtRnJOIx6TyxpjWgkpitEQjEQj9D
	 pMiYQu0gasI2ewfMYBjsZPigRQqJ8WtRIqkIjF28eeILL3SMWuqLiFUp71Nmvap5XKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="aeZqs/pz";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB44606A320;
	Thu, 19 Nov 2026 01:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aeZqs/pz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708DC1F000C4;
	Thu, 19 Nov 2026 01:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051314;
	bh=R59CHNzasqQoabYW1i5zdZHk2jTEkqs0pHPHhL4O3mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aeZqs/pz5zG7s5i+LUHfClrb4Cynaty8tHPmhvQK/OXctx13n/J3DX8y8r8dC80zo
	 1yvy0P45cw5z4N6/gcp0ScgIIUhaA4wn0kDftjejcKvXkFV5UrqljLQmTjLiR936SP
	 vUBO1oHKi93lX44yMPqVuSZpq7zB1fT2goLJkFtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0163/2214] wifi: mt76: set the EOSP bit in the QoS header of the last released frame
Date: Wed, 18 Nov 2026 15:30:39 +0100
Message-ID: <20261118150016.631324082@linuxfoundation.org>
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
index 3fbf0153d13ca..c9697dca579c9 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -343,16 +343,23 @@ mt76_txq_dequeue(struct mt76_phy *phy, struct mt76_txq *mtxq)
 
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
@@ -385,14 +392,15 @@ mt76_release_buffered_frames(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 
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



