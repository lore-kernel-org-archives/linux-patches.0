Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034104;
	b=bZvLCIT/xSDlyaGelg0CANB4b2rcELmSGFuDMv02WkEgsTX95+ripyNJnzQB62dnOy0V
	 WtHbF6NC64NfJmWf09LV8/H/Wdq5xVqYKvxBVRp7q1+F6MjC9ahr802NTmZeJunlJeS5N
	 w87EFiCQ/Q0swnxDlMML0NhRsCY0Ss8GmvCE+Nv4VtSjKhgv67kVeknUxky9Tg+o9eHr5
	 UowcyfY2PsnHUU0JE1s3AWupQZwi0QAIES8C/sfBc7cOiY6DxztKcQXziirIKNSVVylmB
	 lcmeSgR2Bt7PxWnu4l2NBzryg9ExtSQSYoR1sPGXlMWRLJWp0j6uZLUyxeT4YVRKYTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dxV0CxgmxIKnlrCB7eggC8AUmGPj/72XpsxIKKTTnVk=;
	b=q7r2uORKK7EhB3UX8xMxBqKm8a4e9gexmJNRtBMVubr+Nqb+9AZvNaEbI8yCRxmPFA+j
	 T6KPY+9/xgk2TWFe5dNzkGJinkhn3hTnZ6a1OJpZyaQW2BEJQAAox/bfJfyN1tVytHm8q
	 KuvIUeRKxr9UWOZ0Kz/FMDvA+Gmr8WFIVmywx0/awWHZPqGrePrmUBJ6h4Tein9ZaMbo3
	 fKsp4foDRBAzFKC9aIPltsFqXGpep6ZnZOKo79HbjUg8HlJurJ35h7gDYFF1laQmd1+qh
	 lXy5ZNHX61Q0bGMqcmzjtfXW9Lbwae+Rj6yZ1wJCLlKOAHELWjkz1E1pEl2fvER7zGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wj84S9w1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A70606A31C;
	Wed, 18 Nov 2026 20:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wj84S9w1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DD11F000C4;
	Wed, 18 Nov 2026 20:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034104;
	bh=dxV0CxgmxIKnlrCB7eggC8AUmGPj/72XpsxIKKTTnVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wj84S9w1/2M12Q/t42Ic2NWOWrs1T+Ec3AHqvO5EJWpyai+ehAU28sCD4XQ6wAGLg
	 Fgf1tn6xWqSGDXeiIf6HDJLBMY5y2uxk8AKgI7Gkv9XrASfX4Lekp7kcZ8ozoNWIvw
	 YXbrb3xST9YuryoKJgrx50gUniKiAPmLlMQ/POCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0211/3318] wifi: mt76: set the EOSP bit in the QoS header of the last released frame
Date: Wed, 18 Nov 2026 15:13:53 +0100
Message-ID: <20261118150321.260542441@linuxfoundation.org>
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
index c1353ee158a3b..28005f861f030 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -377,16 +377,23 @@ mt76_txq_dequeue(struct mt76_phy *phy, struct mt76_txq *mtxq)
 
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
@@ -419,14 +426,15 @@ mt76_release_buffered_frames(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 
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



