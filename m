Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051317;
	b=cwlR6yr6f2qh0d9J5D/aSf5Lsla1qIxqk9/kORSFYi1YY4AsNVsdnmGwlgI05kVdhevQ
	 GVM7pv9a7Qq2FMXByaFELRTMXyXDG/D87V9VO343Ft/Pmd3snEbyHqWKzza4ms60YIlz6
	 SI/NpQtDjd0wryClnCPgDmSvWBX/SNcdd4gEO01UqOWgMCHPNQtf2DwnxImYlrvaukiKL
	 FWm5P3bdRvLiZ+4Wfr64ZSNUqGvrEuTDrV+/WRmHXIoheasfEBUFBsJpD+2wEw8StGzjV
	 1AWUvUrdj6Kbk4tyxw88DwDME5JHEx+KQUldrnQJwKex/z1ShvgwzpDC6kf7iShRuQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051317;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d6eF4OcWfLNHhiBBFn1x7rwii0FFzK4UbO+AD59N4+4=;
	b=qW5oSxcJd0V12Gior1A0xbJ1Hk3YiezOhCHaQ/yHgD9JQBURSKqAHat6ga2w9XifGGVh
	 0CInOfYp6em5og7oqhN3bl5/rfqAnmlc2e0lwSTFfT1rnjBXoK3IPjQiTdTGptf5DvHZ3
	 +mITCUzkQMVQPgE7+pYtBqYZFrAkYwHDNQZtlyJNgZxlAbcTFel59dqkFXfDEIzhmBIac
	 suce8mRdjpocwbgiJLJ5bMSaDzqFYSApfzifgX462ldvEZFhofmP6DRnsZoe1w61UFI7a
	 pR8e16mFZq0MZD1kRiqf/erH7EkRjYPl/TgRIwOwMSMgWo7jLwS5z0BCOuDAwBi5y9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jQRNfZPF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8072606A31C;
	Thu, 19 Nov 2026 01:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jQRNfZPF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A161F000C4;
	Thu, 19 Nov 2026 01:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051316;
	bh=d6eF4OcWfLNHhiBBFn1x7rwii0FFzK4UbO+AD59N4+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jQRNfZPFB9kWTY2BAzY+kSlrlo6VqtVJ+lx4A3JsGCQ7iJS2fo3dSeDBzPaRPrbOR
	 MnxpH+ovEpC4NTYbcAg31sJMkn1NxOgJLrrvM/XQTYI/91qzp18H5wX3UmG3ykutbG
	 rioyuSiQIfzqOygoqBDd0x+R44D0ic+a+vXCPJ1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0164/2214] wifi: mt76: mt7603: fix U-APSD service period termination
Date: Wed, 18 Nov 2026 15:30:40 +0100
Message-ID: <20261118150016.671619965@linuxfoundation.org>
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

[ Upstream commit 697badc27a9b3b2a8d86092abeed767714f735a2 ]

Frames released from the driver PS queue were all tagged with MORE_DATA
and none of them ever carried the EOSP bit, so from the client's point of
view a U-APSD service period was started but never finished. Clients that
keep their receiver on until EOSP arrives stop sending trigger frames,
and all downlink traffic for that station stalls until they give up.
ieee80211_sta_eosp() only cleared the service period state inside
mac80211, which is why the mismatch went unnoticed.

Assign MORE_DATA per frame and set the wire EOSP bit on the last one. If
the last released frame is a bufferable MMPDU it has no QoS control field
to carry EOSP, so let mac80211 append a QoS-Null frame instead.

Also stop handing the remaining frame budget to
mt76_release_buffered_frames() once frames have been released from the PS
queue: both would signal the end of the same service period. Releasing
fewer frames than requested is allowed, and MORE_DATA tells the client to
trigger again.

Link: https://patch.msgid.link/20260801145334.1166751-5-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7603/main.c  | 74 ++++++++++++++++---
 1 file changed, 63 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/main.c b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
index 0b7b87b4cc21c..5528d0bc64f95 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
@@ -408,13 +408,33 @@ mt7603_sta_ps(struct mt76_dev *mdev, struct ieee80211_sta *sta, bool ps)
 	mt7603_ps_tx_list(dev, &list);
 }
 
+static struct ieee80211_hdr *
+mt7603_ps_skb_hdr(struct sk_buff *skb)
+{
+	return (struct ieee80211_hdr *)&skb->data[MT_TXD_SIZE];
+}
+
+/*
+ * Buffered frames can be recycled into the PS queue by mt7603_filter_tx(), so
+ * both bits have to be assigned, not just set.
+ */
 static void
-mt7603_ps_set_more_data(struct sk_buff *skb)
+mt7603_ps_set_flags(struct sk_buff *skb, bool more_data, bool eosp)
 {
-	struct ieee80211_hdr *hdr;
+	struct ieee80211_hdr *hdr = mt7603_ps_skb_hdr(skb);
+
+	if (more_data)
+		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREDATA);
+	else
+		hdr->frame_control &= ~cpu_to_le16(IEEE80211_FCTL_MOREDATA);
+
+	if (!ieee80211_is_data_qos(hdr->frame_control))
+		return;
 
-	hdr = (struct ieee80211_hdr *)&skb->data[MT_TXD_SIZE];
-	hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREDATA);
+	if (eosp)
+		*ieee80211_get_qos_ctl(hdr) |= IEEE80211_QOS_CTL_EOSP;
+	else
+		*ieee80211_get_qos_ctl(hdr) &= ~IEEE80211_QOS_CTL_EOSP;
 }
 
 static void
@@ -427,7 +447,10 @@ mt7603_release_buffered_frames(struct ieee80211_hw *hw,
 	struct mt7603_dev *dev = hw->priv;
 	struct mt7603_sta *msta = (struct mt7603_sta *)sta->drv_priv;
 	struct sk_buff_head list;
-	struct sk_buff *skb, *tmp;
+	struct sk_buff *skb, *tmp, *last;
+	bool eosp_null, uapsd;
+	u16 pending = 0;
+	u8 last_tid;
 
 	__skb_queue_head_init(&list);
 
@@ -443,20 +466,49 @@ mt7603_release_buffered_frames(struct ieee80211_hw *hw,
 
 		skb_set_queue_mapping(skb, MT_TXQ_PSD);
 		__skb_unlink(skb, &msta->psq);
-		mt7603_ps_set_more_data(skb);
 		__skb_queue_tail(&list, skb);
 		nframes--;
 	}
+
+	skb_queue_walk(&msta->psq, skb)
+		pending |= BIT(skb->priority);
 	spin_unlock_bh(&dev->ps_lock);
 
-	if (!skb_queue_empty(&list))
-		ieee80211_sta_eosp(sta);
+	last = skb_peek_tail(&list);
+	if (!last) {
+		mt76_release_buffered_frames(hw, sta, tids, nframes, reason,
+					     more_data);
+		return;
+	}
+
+	/*
+	 * End the service period here instead of passing the remaining frame
+	 * budget on to mt76_release_buffered_frames(), which would signal the
+	 * end of the same service period a second time.
+	 */
+	uapsd = reason == IEEE80211_FRAME_RELEASE_UAPSD;
+	more_data |= !!(pending & tids);
+
+	skb_queue_walk(&list, skb)
+		mt7603_ps_set_flags(skb, skb != last || more_data,
+				    skb == last && uapsd);
+
+	/*
+	 * EOSP lives in the QoS control field, so a bufferable MMPDU cannot
+	 * terminate a U-APSD service period on its own. In that case mac80211
+	 * has to append a QoS-Null frame, which ends the SP through its tx
+	 * status.
+	 */
+	eosp_null = uapsd &&
+		    !ieee80211_is_data_qos(mt7603_ps_skb_hdr(last)->frame_control);
+	last_tid = __fls(tids);
 
 	mt7603_ps_tx_list(dev, &list);
 
-	if (nframes)
-		mt76_release_buffered_frames(hw, sta, tids, nframes, reason,
-					     more_data);
+	if (eosp_null)
+		ieee80211_send_eosp_nullfunc(sta, last_tid);
+	else
+		ieee80211_sta_eosp(sta);
 }
 
 static int
-- 
2.53.0



