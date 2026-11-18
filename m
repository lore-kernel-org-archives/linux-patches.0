Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031159;
	b=lPSIHJaW9/YnKYC+k2HRArV012d0I92JzvBaobfbWwSlBjAeGsCq+UCJV4FPcrT7kQF5
	 jryYbba9zh/6oZFOf+WnUd+NEAsTtk13tUzMi5XXg9KK1bAz3tMgESONQOLgvTaEjabTg
	 mXO4nV7FkO+73iMRPjNDbUaQg44FsOox5pyAWSQF4ZGsRQzqexgto5Kz06XHC6aeRzlLG
	 TsTzSJa/ah0gb4XOUGIU4p2oT2tA/NWvoFIUFpDIFAZFyE8RI38RL99BxTS+EjXgLyaPV
	 oAzNGf2sbSgKQCE8tlpbueakhBWo8Un08straffFkKxLm7znUm87o4e4jZrU/acVP3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031159;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zgWNjxYqBaJit49B1SUogXeUIc7n5FIvu6/v7yo9/O0=;
	b=IS4x89hjqHAyxzm7jOK12Wtj7eZOMu6C5PPoDfOXAmdDZM8fVvIF6wXKJY3Dgbbiv2pN
	 Mnb/b0wocHc0+Xdw1vTyUjESuxDHswwzrTP+0VzVN4yOAs3OgzDXw8LEHOd6pIZ9BUZZJ
	 wIh0y73FeWCJH0YQNxc3qzlBJuu1xmDTthWOJKfbAv1V8yXFGi9WrIaOcGlIy1vgOaUOY
	 68xAvN2+72GU/D3AhLZEC9FaCR2DyXHdHjTB92Njs/w1uqcTlIOVcKGtOUXoHovpuRPwT
	 M1BbccMzJxMwql6u1UGJkE+Bb4FohHZ44euPl95bJf6IKDtWO7ivknIIslY0uHYFNoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BIT0M1D3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C0E606A31C;
	Wed, 18 Nov 2026 19:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BIT0M1D3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D671F000C4;
	Wed, 18 Nov 2026 19:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031159;
	bh=zgWNjxYqBaJit49B1SUogXeUIc7n5FIvu6/v7yo9/O0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BIT0M1D3s3+KNt6zmRy3AqvEZKvKgnfgORtBtRzxnhPp6t3CDzw8GrtpXevlbWIsN
	 FLTPqV6X/IF1o3M+ysxdg8XJjH0HU18IjppXXHZpKP7sWAFTyqFIFcxTRzx+sULEkc
	 p/qOw2+8kFd4e+rbSQSFRd7LvpOgsXzx1dClBiIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Mark Anthony Agarro <markanthonyagarro@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0959/1756] wifi: mt76: mt7925: honour mac80211s FIF_FCSFAIL instead of hardcoding drop_err
Date: Wed, 18 Nov 2026 15:51:26 +0100
Message-ID: <20261118150048.253730691@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7751b42f91635..2ab8b8e527086 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -808,11 +808,8 @@ static void mt7925_configure_filter(struct ieee80211_hw *hw,
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
@@ -824,6 +821,8 @@ static void mt7925_configure_filter(struct ieee80211_hw *hw,
 	MT7925_FILTER(FIF_CONTROL, CONTROL);
 	MT7925_FILTER(FIF_OTHER_BSS, OTHER_BSS);
 
+	phy->rxfilter = flags;
+
 	mt792x_mutex_acquire(dev);
 	mt7925_mcu_set_rxfilter(dev, flags, 0, 0);
 	mt792x_mutex_release(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index d6437a0fff6a2..639e6a9c0b57d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -2180,7 +2180,7 @@ int mt7925_mcu_config_sniffer(struct mt792x_vif *vif,
 			.len = cpu_to_le16(sizeof(req.tlv)),
 			.control_ch = chandef->chan->hw_value,
 			.center_ch = ieee80211_frequency_to_channel(freq1),
-			.drop_err = 1,
+			.drop_err = !(vif->phy->rxfilter & MT7925_FILTER_FCSFAIL),
 		},
 	};
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
index bc8d38782a81a..f5f6ced969d4c 100644
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
index cf1b6083cf2f0..52d2338c16c43 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -148,6 +148,7 @@ struct mt792x_phy {
 	s16 coverage_class;
 	u8 slottime;
 
+	u32 rxfilter;
 	u32 rx_ampdu_ts;
 	u32 ampdu_ref;
 
-- 
2.53.0



