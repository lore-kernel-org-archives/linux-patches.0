Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060924;
	b=kN0sRF+7bnC9eX5M7Yp3XHXdAnzfW7mNvHZR4pXpysHg9umM8WJfgvoLhGMyCkP6M/Xe
	 AytosuihKlWnurWInEPkeF9boHHum/aQAyuGlbaWjUgMNgWmbGxTb/6guLcRlBo5jjtlW
	 ReAtLhkkCRNNRfyeA4ThpqOLV8slhg6Lj7l1EABDlXFPGoIGITbYEVQeXxDmIrttfyi9a
	 MBXhtYRAcHuW7pXPR2p5eNvx32tUcvIjFGmjdlndd7ApJF+sFp7Ne8vJMOePLn1/kg1ja
	 eubf08W8YWEJUMgqh02U78BNVE4Shz1eNf6RiomJbDnfwEMc8CfZFD9H3OHEQoRH6qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060924;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xK8okgpdhbFJjy6kBGYlkBKWYTiXLsThApAnLW6syZo=;
	b=Om7GluwZzdBlMvgA9l5ZiiPEYLw93cG0JejwhePvUBpufu3P7OzPHXN0XbE+IItomdL0
	 QLkAA95KhiCkUta1CFNqOj2S1NpLLFdAwXjC7eX8inga2d5UEp9OKMhioV51D3jUqFJaH
	 HRejEFPHrVo5Eex5FWqFi6usPtI1UE9OABDNrvJm/BxDa5z1hdx005/+kMfIX/SMq07m0
	 pAGmv5RluFktEKjhCkOt7j/IDNqOsRvPIQ9ohjZqz/KiN9YonPpEq+Ns917/4PjoQieI0
	 fGbUfZQ55x+HQo5OP4QmVIKpwkUMT6hGz9vEmPXhvr6zWWdaHiK0YQyuZ+TB9KtJ93g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="2hNzAl/W";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3194D606D812;
	Sat,  7 Nov 2026 14:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2hNzAl/W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66B31F0089F;
	Sat,  7 Nov 2026 14:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060924;
	bh=xK8okgpdhbFJjy6kBGYlkBKWYTiXLsThApAnLW6syZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2hNzAl/WgRxlS3IM4lrytOvrvDHv1G8Aa5Tlf1Y6kjfUfiphXgCl5oNtaqP+J5qIg
	 zQ5fj0Qlh/p+oUOqYhu7HmEXeYDEo5l1XGH3yDnhSCuqqiHHjYV1TJUek+mMQ1j8av
	 skvEGsislgBqScJAhlMub9yUfHXbZLrkPtuW9qT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0253/1536] wifi: mt76: set the EOSP bit in the QoS header of the last released frame
Date: Sat,  7 Nov 2026 08:37:49 -0500
Message-ID: <20261107135004.793926605@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1a5acb2bcfb3e..9cb00055ce302 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -386,16 +386,23 @@ mt76_txq_dequeue(struct mt76_phy *phy, struct mt76_txq *mtxq)
 
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
@@ -428,14 +435,15 @@ mt76_release_buffered_frames(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 
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



