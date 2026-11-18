Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019104;
	b=rhbtXzF6Xkhipha3OMsHJBvxuUlID4K9LkB6C/YtGDejKIFK9edLJA7yMBDpk5os5WzS
	 yZprjScNrTuJhsyFrWCL2UBbJKi0tYqrBf/qEHN19F4Bc2TIlkNgk8UGAUAdfNBywFba0
	 +OxNAxZB0+pTFUc3NfQ3QZzr3D8sD6FosWNk4V1+Uo+v+0yGEshh2Sf9caZUg9YEskEkI
	 XiUuT6/8jTt3hf0mL5hg1Uk37gmpNfeM4KifiPI2idJ6wxM99pIVcFgvp0I90R+CMVG0R
	 jN3HZx4SRwj5HqvY3/MMKb4zY/pgzSuLiCQcktkcyQ3t5EepRk3rtGH5FUIwK9PqA9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D1064iEg/gghqkW/YYn1el3R5zZY3swgl43o6QJ+F8o=;
	b=BCEy8y1U1TIifEI4fBf/Vn3YG8RAfdDy8in825IHvhZ2hQdvT2fdd/rQC6ja7X6ZZpiC
	 USLAnFkC/5ygvvjsZXflX12s+9fTIE9/jXYrDSwmMid1kuRrM+/PJQyEwXbMIFzFzHyhH
	 uXjnuWmqIRy/KxsOWHV622oMrbq5IcDVeKiITNGC851f92BMMst5cbH/DqTpP4ZdYdrSu
	 jVUFOcdudHD3xZe1jH8jlP9Ee8b46JcCdws9nBfrvs6HtsEeW1afykIVdu+Ca86LNC5qL
	 Lu50+/iBZiSnjWFjV/OKVe1XLW63aqhwCLVT6fUm7Au00/DpGSLonC2SXXMZmahIhsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gatRcOTH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38AB60A260B;
	Wed, 18 Nov 2026 16:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gatRcOTH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1635A1F000C7;
	Wed, 18 Nov 2026 16:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019104;
	bh=D1064iEg/gghqkW/YYn1el3R5zZY3swgl43o6QJ+F8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gatRcOTHQINee2N9Gt78zHsDQYypwRc6VPb6hzgvhV8uPEUNStcecwJkKbgCrM+Wd
	 tQxRMydkzMyT+QLG+/J8D/ERQa0IHeIDdHicVIVrgjOJLxZFM2vXl0RCbxnHQ9tfAj
	 3caVV1q8QQEfyNRBmQtO6pH4duwPbZIIrE8mfQMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Mark Anthony Agarro <markanthonyagarro@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1440/2651] wifi: mt76: mt7925: honour mac80211s FIF_FCSFAIL instead of hardcoding drop_err
Date: Wed, 18 Nov 2026 15:44:40 +0100
Message-ID: <20261118150339.885462788@linuxfoundation.org>
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
index 4381e8c7559bd..0308bfc403d2e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -856,11 +856,8 @@ static void mt7925_configure_filter(struct ieee80211_hw *hw,
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
@@ -872,6 +869,8 @@ static void mt7925_configure_filter(struct ieee80211_hw *hw,
 	MT7925_FILTER(FIF_CONTROL, CONTROL);
 	MT7925_FILTER(FIF_OTHER_BSS, OTHER_BSS);
 
+	phy->rxfilter = flags;
+
 	mt792x_mutex_acquire(dev);
 	mt7925_mcu_set_rxfilter(dev, flags, 0, 0);
 	mt792x_mutex_release(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 1cfc209f9be5c..5b9c9d8d3b2cc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -2356,7 +2356,7 @@ int mt7925_mcu_config_sniffer(struct mt792x_vif *vif,
 			.len = cpu_to_le16(sizeof(req.tlv)),
 			.control_ch = chandef->chan->hw_value,
 			.center_ch = ieee80211_frequency_to_channel(freq1),
-			.drop_err = 1,
+			.drop_err = !(vif->phy->rxfilter & MT7925_FILTER_FCSFAIL),
 		},
 	};
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
index 33782d9ba9ed4..cc4270863ebd4 100644
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
index 9722d840c1af9..49c7b69584800 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -214,6 +214,7 @@ struct mt792x_phy {
 	s16 coverage_class;
 	u8 slottime;
 
+	u32 rxfilter;
 	u32 rx_ampdu_ts;
 	u32 ampdu_ref;
 
-- 
2.53.0



