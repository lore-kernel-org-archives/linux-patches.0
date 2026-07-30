Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C861B43C7A2;
	Thu, 30 Jul 2026 14:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422006; cv=none; b=V8U1I+ZF216Tw/oX531vY1VeDl94CrDhE2RiY9l5YWsWAwUz5IMuKtl/ex3Ra6Kw1OiFjvUYUVamQIgmAR8eipEPO/Mcu6FKUzFUsYBUlNh9ytGGBYXMLFkVkzHRYrYpfFSn2Fb/wenLED24YHeR2Hbb8QGF26W3cWtd19BCSxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422006; c=relaxed/simple;
	bh=C1EOQHRBgQcpycMTlW0tvqGcRAiajvBqX4esfYrHmfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m1/li1W+vLDk7DgTEWZrdaB0tY5majPNVMKhlFDlI6bTThvaqbp/4mWgV9mlZ42oq1E2vHnBBbxURPIz9nC03S7oTnp/++EubAzAzqJ3hQ/5uvf3TxeAwdcgCaSUMqmAHfMiODUXY4eUKETtc+i8+1goc2srPPbDC1N/C5Gazhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0bUb+7KJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0bUb+7KJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6871F00A3A;
	Thu, 30 Jul 2026 14:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422005;
	bh=mxP/f87U2ha8aQIjjFBfitFRjk+ymY/u1VAYfbL9G9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0bUb+7KJ5Z1Kgaf/AFVjK4ljKu1nTIZPTqZUgCD0NA6YHkriz91zSZuc6wqdlABcd
	 QTVoFgCxiQElvy5C5Ud0mL5MsYvQEwJtJaFEbSLy7UjA5lHOa7gxhBjlO1762AFhQz
	 /8Pu15qlSnK1zmmttivmqch2CYoWQmtyq5fftCtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 293/744] wifi: mt76: mt7996: check pointer returned by mt76_connac_get_he_phy_cap()
Date: Thu, 30 Jul 2026 16:09:26 +0200
Message-ID: <20260730141450.519545167@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit e858cf6bf99880343348ff1e8c942aaff1d9d592 ]

mt76_connac_get_he_phy_cap routine can theoretically return NULL so
check cap pointer before dereferencing it.

Fixes: 98686cd21624c ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260621-mt76_connac_get_he_phy_cap-fix-v1-3-ed4ccf7a0363@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 2748bfeb479744..a6a21ddd17a2a0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -935,6 +935,8 @@ mt7996_mcu_bss_he_tlv(struct sk_buff *skb, struct ieee80211_vif *vif,
 	struct tlv *tlv;
 
 	cap = mt76_connac_get_he_phy_cap(phy->mt76, vif);
+	if (!cap)
+		return;
 
 	tlv = mt7996_mcu_add_uni_tlv(skb, UNI_BSS_INFO_HE_BASIC, sizeof(*he));
 
@@ -1851,17 +1853,18 @@ mt7996_mcu_sta_bfer_he(struct ieee80211_link_sta *link_sta,
 {
 	struct ieee80211_sta_he_cap *pc = &link_sta->he_cap;
 	struct ieee80211_he_cap_elem *pe = &pc->he_cap_elem;
-	const struct ieee80211_sta_he_cap *vc =
-		mt76_connac_get_he_phy_cap(phy->mt76, vif);
-	const struct ieee80211_he_cap_elem *ve = &vc->he_cap_elem;
 	u16 mcs_map = le16_to_cpu(pc->he_mcs_nss_supp.rx_mcs_80);
 	u8 nss_mcs = mt7996_mcu_get_sta_nss(mcs_map);
+	const struct ieee80211_he_cap_elem *ve;
+	const struct ieee80211_sta_he_cap *vc;
 	u8 snd_dim, sts;
 
+	vc = mt76_connac_get_he_phy_cap(phy->mt76, vif);
 	if (!vc)
 		return;
 
 	bf->tx_mode = MT_PHY_TYPE_HE_SU;
+	ve = &vc->he_cap_elem;
 
 	mt7996_mcu_sta_sounding_rate(bf, phy);
 
-- 
2.53.0



