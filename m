Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018968;
	b=i6ZM40Im43RFhMmc2vQl6IDYX2zHgvSVGj1mT8zKGvFwyVsXuIU70NmIKiFTcmR7c2+c
	 ZAbnJfF2Ene5FVneqZuHbZMgrpnido6EvT/fIlpGG3UC+/kach5gVUWyqVpzXNQ9pI3R5
	 G3o8woZHSvx/eMXu12sD6hRfh/IX6eL58zsKNIvC5NiZoxxHHH7OuwGPgZdT9XmRvQTK0
	 lj50wldHmHFsp2YhToyj+0DUbJ5aJPg4Ikw2t/VPKW8jnnx4qMoWJDq/tnXNgTPO4r+PC
	 sqnkaiZSXhI2wdkQT+pJGIxez5g4GVt0v4w+OBCuPRiqAF+uGeRMylJjQzn2BH8cNAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018968;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9mUgfS+rGrclPFtQkcoFpFLUSEBqJanSk+v0GGhiXLc=;
	b=zz2L7ilu/laujtsIty4RjK08i7G/E7lBW0U2ggAIwh/q5H1NdLKon9A82O9eBO2gy2jz
	 D/Re5UzwA3tXfAu4CJWNWCnSnMX52VhcXXkk/i9O7vXokCtH1KFiSiKRUx9TuSeM8J/4d
	 gmkrk6vpbigONVYe+ir9p1i+WQgidZM7VZqdQFWDTlY9zZngZ5BLCqW97FzU5WMkII9yk
	 ni6y/yaSy0tvNLwFvg6ZZ8M9oN0OBHNEf/6UKPMtyhIQgK6YgY8kCl5mQc0SFDMR9h9N8
	 dj3sKP2vcUVLpDEuXReq0ghihuekL0yk3KOIeOIrIDs/FENqVRbkpLgEht5awWLTK3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gwfc55kX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E412E606A325;
	Wed, 18 Nov 2026 16:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gwfc55kX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBA11F000C8;
	Wed, 18 Nov 2026 16:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018967;
	bh=9mUgfS+rGrclPFtQkcoFpFLUSEBqJanSk+v0GGhiXLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gwfc55kXTrrs0AJ0hrA2Ux8oa7s8glDF5+2DXpwR8L5kIQlobt/QouqchYalslT9X
	 wHYEfPTn3kPtLcCQUAVDQRh7Pd9iPRQdw8DqJ3/TStT9b591g3Et2BSTq1wxA5FP6l
	 sViv3M95N72fNLH9EdlnURwXHZNvzjGvEASrThEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Stella Liu <yu-ching.liu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1427/2651] wifi: mt76: mt7925: fill all DW intervals in NAN avail_map
Date: Wed, 18 Nov 2026 15:44:27 +0100
Message-ID: <20261118150339.424482675@linuxfoundation.org>
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

[ Upstream commit 4489c66f64289cdf07a396f5edc7487af584b2db ]

Fill avail_map for all DW intervals instead of only DW index 0.
FW requires the bitmap to be set across all 16 DW intervals for
correct NAN scheduling. Without this, NDP ping latency is extremely
high (~200ms) because FW only schedules data in the first DW interval.

Also set ch_type = 1 for new channel entries to indicate
channel-based (non-band) availability.

Fixes: a5487a682406 ("wifi: mt76: mt7925: add NAN MCU helpers")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Stella Liu <yu-ching.liu@mediatek.com>
Link: https://patch.msgid.link/20260824195227.12589-11-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7925/nan.c   | 27 ++++++++++++++-----
 .../net/wireless/mediatek/mt76/mt7925/nan.h   |  3 +++
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index 8194e7678131c..79e57bae566d7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -491,9 +491,14 @@ static u32 mt7925_nan_slot_to_bitmap(struct ieee80211_vif *vif,
 
 			if (FIELD_GET(NAN_CH_CTRL_PRIMARY_CH, raw) ==
 			    slot_chan->chan->hw_value) {
-				u32 map = le32_to_cpu(ch_list[j].avail_map[0]);
+				u32 dw;
 
-				ch_list[j].avail_map[0] = cpu_to_le32(map | BIT(i));
+				for (dw = 0; dw < NAN_TOTAL_DW; dw++) {
+					u32 map = le32_to_cpu(ch_list[j].avail_map[dw]);
+
+					ch_list[j].avail_map[dw] =
+						cpu_to_le32(map | BIT(i));
+				}
 				le32_add_cpu(&ch_list[j].num, 1);
 				is_found = true;
 				break;
@@ -501,12 +506,18 @@ static u32 mt7925_nan_slot_to_bitmap(struct ieee80211_vif *vif,
 		}
 
 		if (!is_found && num_channels < NAN_TIMELINE_MGMT_CHNL_LIST_NUM) {
+			u32 dw;
+
 			ch_list[num_channels].ch_info =
-				cpu_to_le32(FIELD_PREP(NAN_CH_CTRL_OP_CLASS,
+				cpu_to_le32(FIELD_PREP(NAN_CH_CTRL_CH_TYPE,
+						       NAN_BAND_CHANNEL_ENTRY_LIST_TYPE_CHANNEL) |
+					    FIELD_PREP(NAN_CH_CTRL_OP_CLASS,
 						       slot->channel_entry[0]) |
 					    FIELD_PREP(NAN_CH_CTRL_PRIMARY_CH,
 						       slot_chan->chan->hw_value));
-			ch_list[num_channels].avail_map[0] = cpu_to_le32(BIT(i));
+			for (dw = 0; dw < NAN_TOTAL_DW; dw++)
+				ch_list[num_channels].avail_map[dw] =
+					cpu_to_le32(BIT(i));
 			le32_add_cpu(&ch_list[num_channels].num, 1);
 			ch_list[num_channels].is_valid++;
 			num_channels++;
@@ -681,17 +692,19 @@ mt7925_nan_fill_crb_committed(struct mt7925_nan_sched_update_crb_tlv *crb_tlv,
 
 		/*
 		 * Convert peer schedule slots to FW avail_map bitmap.
-		 * Each bit in avail_map[0] represents one time slot where
-		 * the peer has committed availability.
+		 * Each bit represents one time slot where the peer has
+		 * committed availability. Fill all DW intervals the same.
 		 */
 		for (slot = 0; slot < CFG80211_NAN_SCHED_NUM_TIME_SLOTS;
 		     slot++) {
 			struct ieee80211_nan_channel *ch = map->slots[slot];
+			u32 dw;
 
 			if (!ch || !ch->chanctx_conf)
 				continue;
 
-			tl->avail_map[0] |= cpu_to_le32(BIT(slot));
+			for (dw = 0; dw < NAN_TOTAL_DW; dw++)
+				tl->avail_map[dw] |= cpu_to_le32(BIT(slot));
 		}
 	}
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
index 4b424e0ece527..eadb07e34b3eb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
@@ -118,12 +118,15 @@ enum nan_peer_supported_bands {
 	NAN_SUPPORTED_BN_NUM
 };
 
+#define NAN_CH_CTRL_CH_TYPE		BIT(0)
 #define NAN_CH_CTRL_OP_CLASS		GENMASK(15, 8)
 #define NAN_CH_CTRL_PRIMARY_CH		GENMASK(23, 16)
 
 #define NAN_CRB_USE_DATA_PATH		BIT(0)
 #define NAN_CRB_AVAIL_6G_FORMAT		GENMASK(2, 1)
 
+#define NAN_BAND_CHANNEL_ENTRY_LIST_TYPE_CHANNEL	1
+
 struct mt7925_nan_social_ch_scan_params {
 	u8 dwell_time[NAN_MAX_SOCIAL_CHANNELS];
 	__le16 scan_period[NAN_MAX_SOCIAL_CHANNELS];
-- 
2.53.0



