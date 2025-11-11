Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC7C2848BA;
	Tue, 11 Nov 2025 01:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824764; cv=none; b=Icu1nPjrbEKbMQjrnXZzK1mq3aY6Yue6vX+wH7yQKWwqS13OI9/+LBZwlPgyHhT9YJ6zAIYPDMZLXg14j/uvDcUZVrLTn31ANtcy0yqUE8KmXfITMZwklUr/YoCYb66LRPtb1vJoNQm65ZCqwF/IxxlGD2DzJiHdixEegD375W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824764; c=relaxed/simple;
	bh=917ORm9kSaszTHaBQdiCtlSUA7DlnWSQhZq7cGhJBO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lOoSLfSZi/4Bd6dmx6anlX+2WGAU0qPg0YpgKl0b8G/ltYoMFz/kbfwr3krS5YsQKEb75iAVdP52Mfi+eOoVmK83VVpylnAxB+wTBKvv34oqpQB8fYpxEZRXf89BUMXnSVpGjAgLFNJlEa1Tbpj+MrWAtWh6KbUt/Wi8lttFIBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kG0l0P0T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kG0l0P0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11782C116B1;
	Tue, 11 Nov 2025 01:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824764;
	bh=917ORm9kSaszTHaBQdiCtlSUA7DlnWSQhZq7cGhJBO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kG0l0P0TpTnW8keZReXs7Bx8jLw21LhyHCKg1SPC63Itucw3cwSW5qQIU+cZgB/me
	 sf8f4zF4jtiZyfc6Qr3XCUxGAgneKRKtsGM1zomJdEjIzPcqduywSpMUfl6aqNxl4O
	 hS8E4IL8HeltGkd8NZ3khaRv+FiOfqPoEPXxfHOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bo Jiao <Bo.Jiao@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 538/849] wifi: mt76: mt7996: Fix mt7996_reverse_frag0_hdr_trans for MLO
Date: Tue, 11 Nov 2025 09:41:48 +0900
Message-ID: <20251111004549.422394833@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit a3ea1c309bf32fdb3665898c40b3ff8ca29ba6c4 ]

Update mt7996_reverse_frag0_hdr_trans routine to support MLO.

Co-developed-by: Bo Jiao <Bo.Jiao@mediatek.com>
Signed-off-by: Bo Jiao <Bo.Jiao@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250904-mt7996-mlo-more-fixes-v1-1-89d8fed67f20@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 28477702c18b3..222e720a56cf5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -229,7 +229,9 @@ static int mt7996_reverse_frag0_hdr_trans(struct sk_buff *skb, u16 hdr_gap)
 {
 	struct mt76_rx_status *status = (struct mt76_rx_status *)skb->cb;
 	struct ethhdr *eth_hdr = (struct ethhdr *)(skb->data + hdr_gap);
-	struct mt7996_sta *msta = (struct mt7996_sta *)status->wcid;
+	struct mt7996_sta_link *msta_link = (void *)status->wcid;
+	struct mt7996_sta *msta = msta_link->sta;
+	struct ieee80211_bss_conf *link_conf;
 	__le32 *rxd = (__le32 *)skb->data;
 	struct ieee80211_sta *sta;
 	struct ieee80211_vif *vif;
@@ -246,8 +248,11 @@ static int mt7996_reverse_frag0_hdr_trans(struct sk_buff *skb, u16 hdr_gap)
 	if (!msta || !msta->vif)
 		return -EINVAL;
 
-	sta = container_of((void *)msta, struct ieee80211_sta, drv_priv);
+	sta = wcid_to_sta(status->wcid);
 	vif = container_of((void *)msta->vif, struct ieee80211_vif, drv_priv);
+	link_conf = rcu_dereference(vif->link_conf[msta_link->wcid.link_id]);
+	if (!link_conf)
+		return -EINVAL;
 
 	/* store the info from RXD and ethhdr to avoid being overridden */
 	frame_control = le32_get_bits(rxd[8], MT_RXD8_FRAME_CONTROL);
@@ -260,7 +265,7 @@ static int mt7996_reverse_frag0_hdr_trans(struct sk_buff *skb, u16 hdr_gap)
 	switch (frame_control & (IEEE80211_FCTL_TODS |
 				 IEEE80211_FCTL_FROMDS)) {
 	case 0:
-		ether_addr_copy(hdr.addr3, vif->bss_conf.bssid);
+		ether_addr_copy(hdr.addr3, link_conf->bssid);
 		break;
 	case IEEE80211_FCTL_FROMDS:
 		ether_addr_copy(hdr.addr3, eth_hdr->h_source);
-- 
2.51.0



