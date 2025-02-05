Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0B013C3F6;
	Wed,  5 Feb 2025 14:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765292; cv=none; b=Xyc4zZgr4VtLpvC/1dVSkb8plgpoXCXlAqwuYtGBXlThdivbDhtjjnQnCaWy91zwmCk0ZnvQju1QFvkZgzCLSsXaPAI+JSegsWcRaOtJ9xFqYlSmWB6Uqun3ZN4jE5jnQSUzyMd5rAzKMWMh0DX6FCUwl3UyQrsbReVhkqsfdDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765292; c=relaxed/simple;
	bh=uTcUEpavy1zIxTev0jdxOtP4YV9IhH/GRpb1xmow/uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hwXOhz4aY8ZY/9kEg1VDb54Sz4BfnfEA4GiHG8UKMj7eEuGFGBsccFrMWVxvY5yAA3y7fLGqXsEDimAmhsgAfy9rKCuTkJ2lre7gK/1T91KtH/EfM147wdxukAp3QAKRd0RqbWASU4z1WXtCawuuwAQC0qM7zjJkGBR+SU7lC70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xz9G5G89; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xz9G5G89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815B1C4CED1;
	Wed,  5 Feb 2025 14:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765292;
	bh=uTcUEpavy1zIxTev0jdxOtP4YV9IhH/GRpb1xmow/uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xz9G5G89f1qzTiCNcUyeb8RbFxlCONgPHa39GkVC/ZKVS8Lx3fI/HMlvbjM+LGHvR
	 atwxmhnlX9DXs/hGt7S+dMEW424fmVq1Ao9fShLB5wj1kFn5lreV7fNGJteACrjE8U
	 tqY6qEDJjchOslAQlXMbBQfRNNZvLNVV8LZ0nmQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shayne Chen <shayne.chen@mediatek.com>,
	Benjamin Lin <benjamin-jw.lin@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 207/590] wifi: mt76: mt7996: fix definition of tx descriptor
Date: Wed,  5 Feb 2025 14:39:22 +0100
Message-ID: <20250205134503.202625937@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



