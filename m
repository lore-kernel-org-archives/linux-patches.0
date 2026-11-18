Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043363;
	b=fySjf39H1Q4h/OIuPv13L/Xa7yGvuCm0WjmevSwLoj6T84TSwc6vBaBG/LVexbzGbV4b
	 2Jgf7k5z+sUlqBfDv0JduoW17i1d0pWBd3YNDLincF288gUcpd6krThy3D6wi59OtNt9Y
	 BD8wj3jQx+CpRWg/z3WiOQOlarnZq/tK7sMZyO/JYrZBHwDwO9MLljoYcKbZTj8jpD3Wh
	 lqzfhqWhSkRSV2tYRkKVqpEy/7dke0Gcr+dywnskZ959dP72rA0tlNZ1m5Ib3PV1dTcnP
	 wUb0SAG91GbNmAQnczUosrARFxiwje1/G8IOipJkYl0bmQROud699wB3OQv2TTo8kWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043363;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dKeC99o5A5oFY+oRSlzNvLPsjLFy6lxxcm7S6L30pbc=;
	b=GC+iWWDzZJiQJRY9s7NhiEo1a1DIBPjf4y0/bCXtDwtSf0VZtTjK+nPUmzWJ8WhNVi8n
	 ntG2UsJ0wFUF987aCAFuNMYwc2v/h2wj6OsS13eAgbR8rfk7vuqNHTuPmBNXLofl/wO0I
	 41XepKqG9bCWOMPMwil3spz4pwyl7T7Tv9Vz7ua4fT0qe8evabE70rC2iz/dEODcCbQz1
	 lGMi8LHxKhrl4lEtWWGw5tOu1E/ls6kDQ1X9Qi4KLD8I6aLeFhUnK999Xaahu1wGg+OqW
	 +cTQIU+203HB77N5Te2DTFHY/GltxGYX6h0ROpall2ghX6KdMrtt+LlrChMh/HfF6cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sZ6SEkqB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA141606A31C;
	Wed, 18 Nov 2026 23:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sZ6SEkqB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7CA1F000C4;
	Wed, 18 Nov 2026 23:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043363;
	bh=dKeC99o5A5oFY+oRSlzNvLPsjLFy6lxxcm7S6L30pbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sZ6SEkqBLcfukQKybBdEGfXvrcdzpGv3W6NtyI4fLrP8+oOwREGfd4dUD6uV/d0jt
	 mML14+Ou5ZbMMsWmGp79VQ6aaRGNZo7lr8bva/c7lPqiYrHfVTUzEVHbxYBhm6BWPZ
	 pkoQMI2e/mFV6ekHVbrShY/mrP2pc76dAMr7o4Yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0183/2857] wifi: mt76: set the EOSP bit in the QoS header of the last released frame
Date: Wed, 18 Nov 2026 15:20:17 +0100
Message-ID: <20261118150207.938548884@linuxfoundation.org>
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
index 3551a013208d3..49886cdfa31bc 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -370,16 +370,23 @@ mt76_txq_dequeue(struct mt76_phy *phy, struct mt76_txq *mtxq)
 
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
@@ -412,14 +419,15 @@ mt76_release_buffered_frames(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 
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



