Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018970;
	b=cdc7dVc51GWp+PsM4xcrxybk6+DI7tO1bmRhy1/49IzI0Teu/9X2O1rwZQRK5xndSPlT
	 fzwDC5MZnsPQbiyQSL1tP1iPiJpsAw1YMJhlZsWaXMENhFVbteeOZ4aEhthTnjsheWOlE
	 Y8tW4MBHpqc5dRg/LWuKbKQJoLP9qWchtPp1sbDY6iqP1qBVQFQTS460RWdlBU+FmnnDl
	 oy1k46iPyPOUAWO2z1ZMeWVwLTmlIdWzse87BoPW/JM5L0IkV6QYsCCfMO5926SeTLoRR
	 PmKro/WMQ3KypQ8IdipH5II2gVHCwHSo0CGH/2nF4XlSThthr4CGgr4IRhrAcaKbyUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018970;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qPryGyIGdw57ucl4yAtPbwZukF32HrNZh4USMt9LV+A=;
	b=GTnvL8335mnlMVFQh+60FyJRhMTbwrW5/gENuS/j1E729GkE1dgwZpmZInOru3kEau2J
	 /EYOkooq0nUAOBa+Rzr07VMihFebGLVDfkq1snlyzZjOwpsPMwFpaegLyTpi0jVzFEbZM
	 Tp5x6p2mGHQysfsE5O5GwNR6MVpZ6g0FYELPsuLp2frcIgO3hB3bv7d/RfxjI/muOqq4A
	 MHE7n4nxMGLmvDsaQu/XBozFMI+7gmI6WOC58FCtZiGvd6rdpvgK3yoDeQQTef7bo0l8c
	 0rDPXM0uRJhzpH+RR4n0UxOVue4aTssVjLitZAguj41DlfdhCrw77JCEFmyvCY+HiCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mMZaNccj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFD7606A320;
	Wed, 18 Nov 2026 16:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mMZaNccj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CCAF1F000C4;
	Wed, 18 Nov 2026 16:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018970;
	bh=qPryGyIGdw57ucl4yAtPbwZukF32HrNZh4USMt9LV+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mMZaNccjg0jfAXJmg8uoVTmC4Kp1D8jOoIy+Z2Fo4NB2/qHKj4HlaaVW/ObcRKfh9
	 uCP3457DWzUedfjOWyrCLW4oSgk4H8Nc0DaweWw9KEK09S8O85iNCqWcMQ0Xz3g/CM
	 DhyBTNMi1oS32Ux4ikgJqrAL7szJ+2LttfPFGqg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Stella Liu <yu-ching.liu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1428/2651] wifi: mt76: mt7925: clear CRB before deactivating NAN peer record
Date: Wed, 18 Nov 2026 15:44:28 +0100
Message-ID: <20261118150339.457171039@linuxfoundation.org>
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

[ Upstream commit f0793ef2f7d48fa32d11e1b0915d9989ceb1de9a ]

Send a zero avail_map CRB TLV before the peer record deactivation
command. This ensures FW clears the committed schedule slots for
the departing peer, preventing stale CRB entries from affecting
subsequent NDP connections.

Fixes: a5487a682406 ("wifi: mt76: mt7925: add NAN MCU helpers")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Stella Liu <yu-ching.liu@mediatek.com>
Link: https://patch.msgid.link/20260824195227.12589-12-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7925/nan.c   | 25 ++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index 79e57bae566d7..16f3e40c75e7a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -809,18 +809,18 @@ int mt792x_nan_set_peer_schedule(struct mt792x_dev *dev,
 int mt792x_nan_set_peer_rec(struct mt76_dev *mdev,
 			    struct ieee80211_sta *sta)
 {
+	struct mt7925_nan_sched_update_crb_tlv *crb_tlv;
 	struct mt7925_nan_common_hdr *hdr;
 	struct mt792x_sta *msta;
 	struct mt792x_nan *nan;
 	struct sk_buff *skb;
+	struct tlv *tlv;
 	int ret;
 
 	if (!mdev || !sta)
 		return -EINVAL;
 
-	skb = mt76_mcu_msg_alloc(mdev, NULL,
-				 sizeof(struct mt7925_nan_common_hdr) +
-				 sizeof(struct mt7925_nan_sched_manage_peer_rec_tlv));
+	skb = mt76_mcu_msg_alloc(mdev, NULL, MT7925_NAN_PEER_MAX_SIZE);
 	if (!skb)
 		return -ENOMEM;
 
@@ -835,6 +835,25 @@ int mt792x_nan_set_peer_rec(struct mt76_dev *mdev,
 		return 0;
 	}
 
+	/* Send a zero-avail_map CRB TLV before deactivating the peer record so
+	 * firmware clears the committed schedule slots for this peer.  Without
+	 * this, stale CRB entries linger and cause scheduling conflicts for
+	 * subsequent NDP connections that reuse the same sch_idx.
+	 */
+	tlv = mt76_connac_mcu_add_tlv(skb, NAN_UNI_CMD_UPDATE_CRB,
+				      sizeof(struct mt7925_nan_sched_update_crb_tlv));
+	if (!tlv) {
+		dev_kfree_skb(skb);
+		return -ENOMEM;
+	}
+	crb_tlv = (struct mt7925_nan_sched_update_crb_tlv *)tlv;
+	crb_tlv->sch_idx = cpu_to_le32(msta->nan_sched.sch_idx);
+	crb_tlv->flags = NAN_CRB_USE_DATA_PATH;
+	crb_tlv->is_use_ranging = false;
+	crb_tlv->comm_ndc_ctrl.is_valid = false;
+	/* avail_map is zero-initialised by mt76_connac_mcu_add_tlv */
+
+	/* Deactivate peer record and release connection index */
 	if (mt7925_nan_peer_rec_tlv(skb, sta, msta, false)) {
 		dev_kfree_skb(skb);
 		return -ENOMEM;
-- 
2.53.0



