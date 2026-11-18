Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018958;
	b=pMSveKKHSKroNTQ7OyanHU85m6xp/J86adUv4IoX++tZrbGQfqHiM90RKlerSflZFfcp
	 iGOcvZ679MHIDGMiWuD86CkQ7xOXee/7kv84G2tu8VXh49pOOqKQalZsQDfjn9iqcXfjF
	 lh4rTeLbCAZ85eRbqg7uzoAkwTuL5oOkb7D/qMy4vuFR10W6lgQE/0XzxiAVjdal/RbjM
	 dsi8EdZlw9X0lZbOYogxuRlbfrbIh0wiMqyaN49uxaf+oXcZ9jkXBGsC/aAOLqNABGlUS
	 BLco+7CDxyjN/A6R2aJaQ+telA2ilinvuHAm2EVVEllBfMDbo+G/jHkRo7hC7WFKQag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018958;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/6W70Buf3kN21YUoCIQ6wEwu3T4cBgscQq4ymYS3098=;
	b=Nn1iHwlnT9ZF3icDfu8n0QVqzyYgRLAHc6q5Cv6IX2333rqlkS5GUAgmY1p9gWeMiEsU
	 p3FTGHG40fLnlz/fR0ZnBVxRikJhSOwgRgSysM/nLNVhp+88WyLV+4kaesTA90+7Wblij
	 GZc+/P/yCvS/t4uEbMvOCQusllXISy4/FUhDVtu+V8SZ5HUfTFnQESppQRbbqqLdXhkT1
	 n+MxgvPJ1hQ7JXWUvdwhZh7YZSetyvUx80Zadw4hpgxoLYwjJ/glU35Mn5t3B5EipAdKy
	 dne+i/Vt+MJTv6S0PpMvaBe7/k5o7vreXWuC5xvrS5UzUZddJBIJHmGGw9zpgNl5N8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xvmIFrME;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA38606A31C;
	Wed, 18 Nov 2026 16:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xvmIFrME
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA2C1F000C8;
	Wed, 18 Nov 2026 16:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018958;
	bh=/6W70Buf3kN21YUoCIQ6wEwu3T4cBgscQq4ymYS3098=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xvmIFrMECL4tH4GPMiRvi/ERtM9Yq6ShaJXVJhNpX92ddu44gYQcPaABTtHMXKH5i
	 VZrmkCoB1daqG9sPSnz8ifg32hoHlMleFala0aERWfHbcUU1nkLxV7ElUSyAYslCm7
	 hTpaIAKS4pRRpye2dHv7l1zuYsZbuNCfIBqetdRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Stella Liu <yu-ching.liu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1424/2651] wifi: mt76: mt7925: use OFDM-only PHY mode for NAN STA records
Date: Wed, 18 Nov 2026 15:44:24 +0100
Message-ID: <20261118150339.313656916@linuxfoundation.org>
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

[ Upstream commit b757f5b8c346d02d69c88e4520537ecbb4cfef90 ]

NAN operates with OFDM and does not support CCK, so the phy, rate
control and BSS rate TLVs must not fall back to 2.4 GHz. Borrow the
5 GHz band lookup to keep the STA records OFDM-only.

Fixes: 9824fb4edbf3 ("wifi: mt76: mt7925: add NAN MCU handling")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Stella Liu <yu-ching.liu@mediatek.com>
Link: https://patch.msgid.link/20260824195227.12589-8-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index fa29c486a4553..1cfc209f9be5c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -1914,11 +1914,9 @@ mt7925_mcu_sta_phy_tlv(struct sk_buff *skb,
 	phy = (struct sta_rec_phy *)tlv;
 
 	if (mt7925_vif_is_nan(vif)) {
-		enum nl80211_band band = chandef->chan ? chandef->chan->band
-						       : NL80211_BAND_2GHZ;
 		phy->phy_type = PHY_TYPE_BIT_OFDM | PHY_TYPE_BIT_ERP;
 		phy->phy_type |= mt76_connac_get_phy_mode_v2(mvif->phy->mt76, vif,
-							     band,
+							     NL80211_BAND_5GHZ,
 							     link_sta);
 	} else {
 		phy->phy_type = mt76_connac_get_phy_mode_v2(mvif->phy->mt76, vif,
@@ -2003,7 +2001,11 @@ mt7925_mcu_sta_rate_ctrl_tlv(struct sk_buff *skb,
 	ra_info = (struct sta_rec_ra_info *)tlv;
 
 	if (mt7925_vif_is_nan(vif))
-		band = chandef->chan ? chandef->chan->band : NL80211_BAND_2GHZ;
+		/* NAN is OFDM-only per spec; borrow the 5 GHz band lookup to
+		 * avoid PHY_TYPE_BIT_HR_DSSS/CCK bits being added to phy_type.
+		 * NAN interfaces have no chanctx, so chandef->chan is always NULL.
+		 */
+		band = NL80211_BAND_5GHZ;
 	else
 		band = chandef->chan->band;
 
@@ -2847,7 +2849,7 @@ mt7925_mcu_bss_bmc_tlv(struct sk_buff *skb, struct mt792x_phy *phy,
 	bmc = (struct bss_rate_tlv *)tlv;
 
 	if (mt7925_vif_is_nan(vif))
-		band = chandef->chan ? chandef->chan->band : NL80211_BAND_2GHZ;
+		band = NL80211_BAND_5GHZ;
 	else
 		band = chandef->chan->band;
 
-- 
2.53.0



