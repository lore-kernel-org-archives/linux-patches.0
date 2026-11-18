Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018944;
	b=l/XAPtMctMVVlg1O6AxN/TW4xlGD+UV5LYuBAHCoZXp01MWtd8PgEZ6BREUC4V/HAJ59
	 WuF0RGov866/Ni3Q9do8L6Agv/Ue+76GsohUc/k3tGY6y0LPXa/GYyHXWmBAi3eQl6JaX
	 0DfGanDmkDynH2paAa5JE0NoIgBspd0XmtrAqCd1B+Mk6s4ZHTPoWkYpatorDnoDiQIXG
	 91S7QTCKGQuRzGOYbrvMGBE/G4jTrSjKem8YL17t/lPLDTHXjNpOQGBg3M78/VqMgWMmU
	 34wKftH+wdSA7Cl615yzB20gLlbTcVcewUmB7e2PJkQxMKUU+b4eB9S/TjXOC0Mmm+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018944;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T87Cmfk4Qv3YBnujobfG8/h8P24az1KrIrjOTvSps0w=;
	b=pbSsTRHBjDcIl2PV5bZRJP9XnBiOkMN4asGjmZ+aICq+WAjdFeeL20dUHENUcVVWdsfy
	 IUlAyCmEr5ybQmi3gj1rwxe96oQV6UoPlHpg2Foxk+4cRwdOzJbIUTVF2l6dF2HxCM3ZR
	 k5rnyu719ziNWw46Odx1Kd0U4DyM2goI0N3MLr13hTPgONCbizdge9rKscExE5aumyQ6e
	 l+pVgdLOTBYkFbB93t7xQbyz+5ar9VVHfZKxihIuOFqVR0jZYvBYyTJwFIJ4P1ZU2anj5
	 aw8ZYvNYaJ+KPEZ1U3IKt+sFxZk72rgv7sWSvv+t84CrYwhZ17qZ2AWUBomHxO9urzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eViiZxG+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05FDE606A31C;
	Wed, 18 Nov 2026 16:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eViiZxG+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568DA1F000C4;
	Wed, 18 Nov 2026 16:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018943;
	bh=T87Cmfk4Qv3YBnujobfG8/h8P24az1KrIrjOTvSps0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eViiZxG+OS4BOwqp1+wV64OPE/1+fbmyamhcKp8NWPrFQ0ROwl5tecx65GovuvTuy
	 T33Q6uUxzwbMIvPfsY+hlCiVByZR3SZSG97q4Jht9gyquOLZ48q4Pq8xpvPZLTlmb0
	 u8JISDbrQoJ98aS/LtmbM3uhexYezvM18JUn4HmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Stella Liu <yu-ching.liu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1420/2651] wifi: mt76: mt7925: fix NAN committed CRB timeline layout
Date: Wed, 18 Nov 2026 15:44:20 +0100
Message-ID: <20261118150339.167583479@linuxfoundation.org>
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

[ Upstream commit d7e818693cca1e8e474a4df33cffce0583e02880 ]

The committed CRB timeline carried a local_map_id byte that does not
exist in the firmware NAN_SCHEDULE_TIMELINE_T layout (map id plus 3
reserved bytes), shifting the availability bitmap. Drop it and match
the firmware structure.

The common-slot check is also dropped as redundant: mac80211 already
tracks common slots, so avail_map is built directly from the peer
schedule.

Fixes: 0f3605e4f8de ("wifi: mt76: mt7925: wire up NAN operations")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Stella Liu <yu-ching.liu@mediatek.com>
Link: https://patch.msgid.link/20260824195227.12589-4-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7925/nan.c   | 37 ++++++-------------
 .../net/wireless/mediatek/mt76/mt7925/nan.h   |  3 +-
 2 files changed, 12 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index 51aab5cad4bde..81a1563b1408a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -753,52 +753,38 @@ static int mt7925_nan_peer_cap_tlv(struct sk_buff *skb,
 
 static void
 mt7925_nan_fill_crb_committed(struct mt7925_nan_sched_update_crb_tlv *crb_tlv,
-			      struct ieee80211_vif *vif,
 			      struct ieee80211_nan_peer_sched *sched)
 {
-	struct ieee80211_nan_sched_cfg *local_sched;
-	u8 local_map_id;
 	u32 m, slot;
 
-	if (!vif || !sched)
+	if (!sched)
 		return;
 
-	local_sched = &vif->cfg.nan_sched;
-	local_map_id = mt7925_nan_avail_attr_ctrl(local_sched) &
-		       NAN_AVAIL_CTRL_MAPID;
-
 	for (m = 0; m < CFG80211_NAN_MAX_PEER_MAPS &&
 	     m < NAN_TIMELINE_MGMT_SIZE; m++) {
+		struct ieee80211_nan_peer_map *map = &sched->maps[m];
 		struct mt7925_nan_sched_timeline *tl =
 			&crb_tlv->comm_faw_timeline[m];
-		struct ieee80211_nan_peer_map *map = &sched->maps[m];
-		u32 avail_map = 0;
 
 		if (map->map_id == CFG80211_NAN_INVALID_MAP_ID)
 			continue;
 
 		tl->map_id = map->map_id;
-		tl->local_map_id = local_map_id;
 
+		/*
+		 * Convert peer schedule slots to FW avail_map bitmap.
+		 * Each bit in avail_map[0] represents one time slot where
+		 * the peer has committed availability.
+		 */
 		for (slot = 0; slot < CFG80211_NAN_SCHED_NUM_TIME_SLOTS;
 		     slot++) {
-			struct ieee80211_nan_channel *local_ch;
-			struct ieee80211_nan_channel *peer_ch;
+			struct ieee80211_nan_channel *ch = map->slots[slot];
 
-			local_ch = local_sched->schedule[slot];
-			peer_ch = map->slots[slot];
-
-			if (!local_ch || !local_ch->chanctx_conf ||
-			    !peer_ch || !peer_ch->chanctx_conf)
-				continue;
-
-			if (local_ch->chanctx_conf != peer_ch->chanctx_conf)
+			if (!ch || !ch->chanctx_conf)
 				continue;
 
-			avail_map |= BIT(slot);
+			tl->avail_map[0] |= cpu_to_le32(BIT(slot));
 		}
-
-		tl->avail_map[0] = cpu_to_le32(avail_map);
 	}
 }
 
@@ -824,8 +810,7 @@ static int mt7925_nan_update_crb_tlv(struct sk_buff *skb,
 	crb_tlv->is_use_ranging = false;
 	crb_tlv->comm_ndc_ctrl.is_valid = false;
 
-	mt7925_nan_fill_crb_committed(crb_tlv, msta->vif->phy->dev->nan_vif,
-				      sta->nan_sched);
+	mt7925_nan_fill_crb_committed(crb_tlv, sta->nan_sched);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
index 91f4e999711e6..fab10b829eaac 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
@@ -348,8 +348,7 @@ struct mt7925_nan_sched_update_peer_cap_tlv {
 
 struct mt7925_nan_sched_timeline {
 	u8 map_id;
-	u8 local_map_id;
-	u8 reserved[2];
+	u8 reserved[3];
 	union {
 		__le32 avail_map[NAN_TOTAL_DW];
 		u8 avail_block[NAN_TOTAL_DW * 4];
-- 
2.53.0



