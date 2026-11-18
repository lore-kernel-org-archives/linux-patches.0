Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018938;
	b=2HwrB/kK9kNAWaNv21aKx2GQnXYK15nD3SeQai4sDSjQW2bh3/rKLMAez+6YX+YLVYmt
	 4bo/GPOKNbQHbXqus+RlqLgOdqgkDL/5mC3A+l575RyJDV8RbHeRyRUUxIFQFajOUnITM
	 ayD/CfZ7/3baXLBfK6D7qcRoekIzMVSdMjm4ox/h/DBCdYdhEq84gl/MakINJIpCJfmB1
	 UHyTT/QXcxPi8TW43T+0ZuzVnm5/7882yKfjt3myeSA0fYUGhR9nmZO9Oy87v1/05ZEm7
	 0OlK6fgHdDuXvBxrCSC1M4CiRFdhckUGNe6JJwpkwKKv/q9n8tTQDQjB1R5LQiEp1GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018938;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZhsAs3pzaLon/rS1NYth7fTreJFNo/SCZWe5H2wj46A=;
	b=NzayntyPn5mb10W5L/yPsnc4J/KzaU1kAoDb/PnnsCu+Y2suYi3btn0OXWce6n6Plg67
	 kySq6VaFaWaJYHdlTjDaFFiyfC1U2ClMqhzra+bCgYxi2ueRPgpn2J4Cc9b9+uwGHmByi
	 Q/jZbWNZbGi6qmOucZBKI6m628WqT+wZFcziuqA+1EvelxULLmtI/nRxUXuN936goKpMp
	 +tVUQTQmH6ETsnCw0VrjqbRmnsFK6YCcrGj+DhCOBEn6cWz9I7wiLnvAh7cF+pUersc/y
	 CU1FO2sujjtNgjxczXkA79fudWImOVQY/Svix6MzyRNHUtZl2H3EAUekv3i5R4bKX7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nsg8sHUC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604BC606A31C;
	Wed, 18 Nov 2026 16:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nsg8sHUC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59D01F000C4;
	Wed, 18 Nov 2026 16:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018938;
	bh=ZhsAs3pzaLon/rS1NYth7fTreJFNo/SCZWe5H2wj46A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nsg8sHUC9LunvPdHEZ4SyeZBbh1q/UBkbNJmTVIsP3GoA5DAUhf3CIe5+4YKc0GCa
	 6ag2HYc2EiI89S2criVtafVEzOImimIyJq+83oRaQl1g4rAXL77QG0C6iQ90XNFou6
	 wxzk8Q8Z6Z6nAGpO/NDmA8vBtjfg3kQvbuI1L3+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Stella Liu <yu-ching.liu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1418/2651] wifi: mt76: mt7925: fix NAN NDP STA record role index
Date: Wed, 18 Nov 2026 15:44:18 +0100
Message-ID: <20261118150339.072472243@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stella Liu <yu-ching.liu@mediatek.com>

[ Upstream commit a34595a955af242372cea2abfa7604f544399286 ]

The NDP STA record role_idx must carry the NAN BSS band0 index
rather than the mac80211 BSS index, otherwise the firmware maps the
NDP peer to the wrong role. Use the fixed NAN_BSS_INDEX_BAND0 value.

While at it, drop the inline peer-schedule setup in
mt792x_nan_map_sta_rec(): the peer schedule is already driven by the
upper layer through the peer_sched_changed callback
(mt792x_nan_set_peer_schedule()), so the redundant call and the
now-unused local variables are removed.

Fixes: 0f3605e4f8de ("wifi: mt76: mt7925: wire up NAN operations")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Stella Liu <yu-ching.liu@mediatek.com>
Link: https://patch.msgid.link/20260824195227.12589-2-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7925/nan.c   | 33 +------------------
 .../net/wireless/mediatek/mt76/mt7925/nan.h   |  2 ++
 2 files changed, 3 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index d260e803d056f..2c03ad9c452cc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -984,21 +984,17 @@ int mt792x_nan_map_sta_rec(struct mt76_dev *mdev,
 	struct mt7925_nan_common_hdr *hdr;
 	struct ieee80211_sta *nmi_sta;
 	struct mt792x_sta *nmi_msta;
-	struct mt792x_vif *mvif;
 	struct mt792x_sta *msta;
 	u8 nmi_addr[ETH_ALEN];
 	struct sk_buff *skb;
 	int ndp_ctx_id = 0;
 	int ret = -ENOMEM;
-	struct mt792x_dev *dev;
 	struct tlv *tlv;
 
 	if (!mdev || !vif || !sta)
 		return -EINVAL;
 
-	dev = container_of(mdev, struct mt792x_dev, mt76);
 	msta = (struct mt792x_sta *)sta->drv_priv;
-	mvif = (struct mt792x_vif *)vif->drv_priv;
 
 	rcu_read_lock();
 	nmi_sta = rcu_dereference(sta->nmi);
@@ -1012,33 +1008,6 @@ int mt792x_nan_map_sta_rec(struct mt76_dev *mdev,
 	memcpy(nmi_addr, nmi_sta->addr, ETH_ALEN);
 	nmi_msta = (struct mt792x_sta *)nmi_sta->drv_priv;
 
-	if (!nmi_msta->nan_sched.idx_assigned) {
-		if (!nmi_sta->nan_sched) {
-			rcu_read_unlock();
-			dev_err(mdev->dev,
-				"NAN: peer schedule missing for NDI sta %pM\n",
-				sta->addr);
-			return -EAGAIN;
-		}
-
-		rcu_read_unlock();
-		ret = mt792x_nan_set_peer_schedule(dev, nmi_sta);
-		if (ret)
-			return ret;
-
-		rcu_read_lock();
-		nmi_sta = rcu_dereference(sta->nmi);
-		if (!nmi_sta) {
-			rcu_read_unlock();
-			dev_err(mdev->dev,
-				"NAN: NMI sta not found for NDI sta %pM\n",
-				sta->addr);
-			return -EINVAL;
-		}
-
-		nmi_msta = (struct mt792x_sta *)nmi_sta->drv_priv;
-	}
-
 	ndp_ctx_id = find_first_zero_bit(&nmi_msta->nan_sched.ndp_ctx_bitmap,
 					 NAN_MAX_NDP_CXT);
 	if (ndp_ctx_id >= NAN_MAX_NDP_CXT) {
@@ -1073,7 +1042,7 @@ int mt792x_nan_map_sta_rec(struct mt76_dev *mdev,
 	memcpy(map_tlv->nmi_addr, nmi_addr, ETH_ALEN);
 	map_tlv->sta_rec_idx = msta->deflink.wcid.idx;
 	map_tlv->ndp_ctx_id = ndp_ctx_id;
-	map_tlv->role_idx = cpu_to_le32(mvif->bss_conf.mt76.idx);
+	map_tlv->role_idx = cpu_to_le32(NAN_BSS_INDEX_BAND0);
 	memcpy(map_tlv->ndi_addr, vif->addr, ETH_ALEN);
 
 	ret = mt76_mcu_skb_send_msg(mdev, skb,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
index f55730e25f462..1dcc888d98f9b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
@@ -65,6 +65,8 @@
 #define UNII3_LOWER_BOUND	149
 #define UNII3_UPPER_BOUND	165
 
+#define NAN_BSS_INDEX_BAND0 0
+
 enum nan_uni_cmd_tag {
 	NAN_UNI_CMD_SET_MASTER_PREFERENCE	= 0,
 	NAN_UNI_CMD_ENABLE_REQUEST		= 7,
-- 
2.53.0



