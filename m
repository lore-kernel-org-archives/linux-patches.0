Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D3A155CBD;
	Wed,  5 Feb 2025 14:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765787; cv=none; b=OFdu6S+rxroiBk5Cutelj1V4MPB98bvnMCGJnKwjpXf4L5rOOfRgXxlLkJqzhUaMu4m++48wBsnbU6FNUfOO1dx22M5izJyTKFJuoAX5jXCl73MAi1XXlnnSMN2BzXn9EwU4Gf0l6lv5ZpY173y4Fl5S4i+zIG1KgyLOxDaeMKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765787; c=relaxed/simple;
	bh=tGQHNy/anzwCWYclpploCr0N5mMhDsoIHXmiaf5MGus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cwjRA3uOviM0Fb7WhBndFK8Chw6YutweMCjgw2OG/+2ZajAW8ibkM0jcTrz0fnhcVN4ZGlER7o3pWxClWjg3e3A1rP8iL+0Hy1bFEC+qd0RcER/oZ6+cSP/MgYXSyt0IpunjcKujPTMHa2H2VLhvsB+i37V97xeIctzBMYTq1o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TtfvjAJH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TtfvjAJH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D51C4CED1;
	Wed,  5 Feb 2025 14:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765787;
	bh=tGQHNy/anzwCWYclpploCr0N5mMhDsoIHXmiaf5MGus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TtfvjAJH8CB048HynCtGe9QQLJTGd8tHVR+yRvES44++Gc3P0LyJrGtNn3nx0PrMN
	 GIL+UXzpNAuYwNfT7Zin1W2OtuX/GBBE1roY72Qzd3x3HdQhLh2B39wiWz0BKcQU8J
	 ZXkb7yNv0wKusuBYcDvWMhVwBunUPzM5JRdVF2/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shayne Chen <shayne.chen@mediatek.com>,
	Benjamin Lin <benjamin-jw.lin@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 213/623] wifi: mt76: mt7996: fix definition of tx descriptor
Date: Wed,  5 Feb 2025 14:39:15 +0100
Message-ID: <20250205134504.377284055@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Lin <benjamin-jw.lin@mediatek.com>

[ Upstream commit 14749fe2ed360c92c1a2a76dac0b77f759234981 ]

For mt7992 chipsets, the definition of TXD.DW6.BIT10~15 has different
interpretations on different frame types. Driver only needs to fill
MSDU_CNT for non-management frames.

Fixes: 408566db8cad ("wifi: mt76: connac: add new definition of tx descriptor")
Co-developed-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Benjamin Lin <benjamin-jw.lin@mediatek.com>
Link: https://patch.msgid.link/20250114101026.3587702-6-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 0d21414e2c884..f590902fdeea3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -819,6 +819,7 @@ void mt7996_mac_write_txwi(struct mt7996_dev *dev, __le32 *txwi,
 			   struct ieee80211_key_conf *key, int pid,
 			   enum mt76_txq_id qid, u32 changed)
 {
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_vif *vif = info->control.vif;
 	u8 band_idx = (info->hw_queue & MT_TX_HW_QUEUE_PHY) >> 2;
@@ -886,8 +887,9 @@ void mt7996_mac_write_txwi(struct mt7996_dev *dev, __le32 *txwi,
 	val = MT_TXD6_DIS_MAT | MT_TXD6_DAS;
 	if (is_mt7996(&dev->mt76))
 		val |= FIELD_PREP(MT_TXD6_MSDU_CNT, 1);
-	else
+	else if (is_8023 || !ieee80211_is_mgmt(hdr->frame_control))
 		val |= FIELD_PREP(MT_TXD6_MSDU_CNT_V2, 1);
+
 	txwi[6] = cpu_to_le32(val);
 	txwi[7] = 0;
 
@@ -897,7 +899,6 @@ void mt7996_mac_write_txwi(struct mt7996_dev *dev, __le32 *txwi,
 		mt7996_mac_write_txwi_80211(dev, txwi, skb, key);
 
 	if (txwi[1] & cpu_to_le32(MT_TXD1_FIXED_RATE)) {
-		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 		bool mcast = ieee80211_is_data(hdr->frame_control) &&
 			     is_multicast_ether_addr(hdr->addr1);
 		u8 idx = MT7996_BASIC_RATES_TBL;
-- 
2.39.5



