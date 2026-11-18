Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025796;
	b=3yLLQIA8pYFi2F47Kd1pw2Ukb0rxMS571eG7hh/IsSwbYurOR4CyPOcNCES0nt9qVVO+
	 KXjJo0rUjVS1vWtEEU9OsF5W9deEug0h6HkK7RCq4+E2sNQzhnxFX3Bl0NtT0B5Hm19kP
	 kItIzov0AbR0LZIX50DdJ+rvfL8iuhq93au+GD74TiH+F8h3mRRx57AWRH5sB8jvIgY0o
	 wwMU07fv1OTP6irw4ay1hwSf7tvMa444Q+PdTogYGjz3YN2O2EmKxcly6/cNzAl57Oa64
	 pfIDrmJ6DkpTbgiZ4Uw4aqan30LZQAd2Bu423lYN+0qZ9vAmx0irFLmrgRmbIHVEJqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025796;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3y9kC3Vf7gnVL708kSn0+bvJv+mKEdt1SXzNClulTyk=;
	b=TpBw4TMXagzIYb14rgQhyeufkQE1Hbr3o6KztWWYwBVfvgxprdhDb9jaZA28SIvnUJY3
	 ptjcE9+WcjbOdcFfQzr6IgMNbqlhU7E3Bf2WIWACL0MzmMwySPf/TJQ/H7oyc1xAxcEQS
	 pOuouIKhaDB/FE47vTVijM+mUl0Qrx9Ank6OVTaQeTdEceU5feoXVu+FOe2t8/KCT3rRh
	 +tYxRtFdg+MlZW7+yyWtfWuxt5kmwjiCxsrHKnDIhFgLzB82TSMLlr5geMCpW6rDaiBnd
	 2YTNCD0iRYEP/9KrF2/22c7xHWyXtCEeeUJRDO0gTklCl/EAtbyV81MBp8tmbHkNmGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mPs5Ig2Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D356606A31C;
	Wed, 18 Nov 2026 18:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mPs5Ig2Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D7C91F000C4;
	Wed, 18 Nov 2026 18:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025796;
	bh=3y9kC3Vf7gnVL708kSn0+bvJv+mKEdt1SXzNClulTyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mPs5Ig2YG2XAGIGXNLuqmCY6BPfkr2tVpqg2oq2edtIxM/weNxo8j8fmg+08Pk3Lx
	 UNijEMzGQHVH//oLuA+4eggyQrLBp4zIcEC2KJUrKjz4FqTCubbRWoDaS/eIYPeMz5
	 qNBieHPvEd1uI6ssFm+NAMPwe3S/pSfqT0MGWgxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Mark Anthony Agarro <markanthonyagarro@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1207/2151] wifi: mt76: mt7925: honour mac80211s FIF_FCSFAIL instead of hardcoding drop_err
Date: Wed, 18 Nov 2026 15:49:02 +0100
Message-ID: <20261118150206.170459129@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Anthony Agarro <markanthonyagarro@gmail.com>

[ Upstream commit 31b53a9c4ada2ce49201ed0da0105819acfd86bf ]

mt7925_mcu_config_sniffer() hardcodes drop_err = 1, ignoring what
mac80211 actually requested via configure_filter(). FIF_FCSFAIL is
computed there but discarded instead of persisted.

Persist the FCSFAIL bit on the phy in mt7925_configure_filter() and
read it back in mt7925_mcu_config_sniffer() to derive drop_err, so the
firmware sniffer only passes through unfiltered/marginal frames when a
monitor listener actually requested them.

mt7925_mcu_config_sniffer() is only reached from mt7925_change_chanctx(),
which is itself only exercised on a monitor-mode chanctx, so this stays
scoped to monitor mode.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Tested-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Signed-off-by: Mark Anthony Agarro <markanthonyagarro@gmail.com>
Link: https://patch.msgid.link/20260826091757.469953-1-markanthonyagarro@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c   | 7 +++----
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c    | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h | 5 +++++
 drivers/net/wireless/mediatek/mt76/mt792x.h        | 1 +
 4 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index cd9058075a878..aab70b030c747 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -809,11 +809,8 @@ static void mt7925_configure_filter(struct ieee80211_hw *hw,
 				    unsigned int *total_flags,
 				    u64 multicast)
 {
-#define MT7925_FILTER_FCSFAIL    BIT(2)
-#define MT7925_FILTER_CONTROL    BIT(5)
-#define MT7925_FILTER_OTHER_BSS  BIT(6)
-#define MT7925_FILTER_ENABLE     BIT(31)
 	struct mt792x_dev *dev = mt792x_hw_dev(hw);
+	struct mt792x_phy *phy = mt792x_hw_phy(hw);
 	u32 flags = MT7925_FILTER_ENABLE;
 
 #define MT7925_FILTER(_fif, _type) do {			\
@@ -825,6 +822,8 @@ static void mt7925_configure_filter(struct ieee80211_hw *hw,
 	MT7925_FILTER(FIF_CONTROL, CONTROL);
 	MT7925_FILTER(FIF_OTHER_BSS, OTHER_BSS);
 
+	phy->rxfilter = flags;
+
 	mt792x_mutex_acquire(dev);
 	mt7925_mcu_set_rxfilter(dev, flags, 0, 0);
 	mt792x_mutex_release(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 75f105d224ed5..ea79bf40b5c6a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -2181,7 +2181,7 @@ int mt7925_mcu_config_sniffer(struct mt792x_vif *vif,
 			.len = cpu_to_le16(sizeof(req.tlv)),
 			.control_ch = chandef->chan->hw_value,
 			.center_ch = ieee80211_frequency_to_channel(freq1),
-			.drop_err = 1,
+			.drop_err = !(vif->phy->rxfilter & MT7925_FILTER_FCSFAIL),
 		},
 	};
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
index 7f67e0a978726..cfeaaa635c8bb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
@@ -7,6 +7,11 @@
 #include "../mt792x.h"
 #include "regs.h"
 
+#define MT7925_FILTER_FCSFAIL		BIT(2)
+#define MT7925_FILTER_CONTROL		BIT(5)
+#define MT7925_FILTER_OTHER_BSS	BIT(6)
+#define MT7925_FILTER_ENABLE		BIT(31)
+
 #define MT7925_BEACON_RATES_TBL		25
 
 #define MT7925_TX_RING_SIZE		2048
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index f2c8b9e4aa0f5..082285be95926 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -162,6 +162,7 @@ struct mt792x_phy {
 	s16 coverage_class;
 	u8 slottime;
 
+	u32 rxfilter;
 	u32 rx_ampdu_ts;
 	u32 ampdu_ref;
 
-- 
2.53.0



