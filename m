Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F219471248;
	Tue, 21 Jul 2026 17:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656482; cv=none; b=CrAvL7S70yWZma59di8AP2wyctKi2Ugkuw6Q/MXUc2vpzeDwhUNGKdzCVAUqtXS6IsAoNRzk2PtLkqBOULStx/zXQiuuQ7ncWZZ5Uhw8CZAnYk1/MJAdBYg2gkYZE8+A/29FF3+Q36vK9mAskrAnz/7XJYHgbeUHbbd5ctoYEW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656482; c=relaxed/simple;
	bh=atOFiWKQ+KFX+xMK0E1zSyNBeG9fGDE+erNc3BOYm50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTZYx9TVOnkDIVoOPCls44NcOw9UJESG9z6gFLrXluksC6b+MD57OwiRBNmux8Wg6n2Pd3wD77XofNUX4LPyjmO9WzZOcva1SAlvjVO5NXustYVNKKKRVC/Iwxsq7uA2Fu3zaG2Y/4Mp29YbISVY2IXuSKE/RRQfNLnmI+L7n1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GZ6JTc2d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GZ6JTc2d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38571F00A3A;
	Tue, 21 Jul 2026 17:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656479;
	bh=u8TOeBg0oxR9xJp6Wmoseh/SjFpf1CqrAtDmlkO9G5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GZ6JTc2d/uNrptq+CdoeKPvrG8cf8tMFxCLp3SJQRpkc4OAJ2Q3e89WDVXwJuIMc5
	 v+xFLgrE3r1rGTaZ7iBRdGDhfguYp7T6shM1qdzuv+2oACQySZsvIFtuHfRCraDnTb
	 bLMg71ZjwngtpFIHERW0l1Y9pTjbAhcfKKmzOo/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0402/1611] wifi: mt76: mt7996: add missing max_remain_on_channel_duration
Date: Tue, 21 Jul 2026 17:08:38 +0200
Message-ID: <20260721152524.277997686@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit ac41612e0044fa29cf9bc45b6808dda6d87ac2da ]

Having this unset breaks remain-on-channel and mgmt TX.
Move setting it to mt76 core to keep it in one place.

Fixes: 69d54ce7491d0 ("wifi: mt76: mt7996: switch to single multi-radio wiphy")
Link: https://patch.msgid.link/20260324154904.2555603-2-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c    | 2 ++
 drivers/net/wireless/mediatek/mt76/mt7615/init.c | 1 -
 drivers/net/wireless/mediatek/mt76/mt792x_core.c | 1 -
 3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 2d24f9fa51a505..f6a642fd29d2dd 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -449,6 +449,8 @@ mt76_phy_init(struct mt76_phy *phy, struct ieee80211_hw *hw)
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_AIRTIME_FAIRNESS);
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_AQL);
 
+	if (!wiphy->max_remain_on_channel_duration)
+		wiphy->max_remain_on_channel_duration = 5000;
 	if (!wiphy->available_antennas_tx)
 		wiphy->available_antennas_tx = phy->antenna_mask;
 	if (!wiphy->available_antennas_rx)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/init.c b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
index 3e7af3e58736cb..c4f5f6ee916aff 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
@@ -195,7 +195,6 @@ mt7615_check_offload_capability(struct mt7615_dev *dev)
 		ieee80211_hw_set(hw, SUPPORTS_DYNAMIC_PS);
 
 		wiphy->flags &= ~WIPHY_FLAG_4ADDR_STATION;
-		wiphy->max_remain_on_channel_duration = 5000;
 		wiphy->features |= NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR |
 				   NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR |
 				   WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_core.c b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
index 9cad572c34a38a..a5bdccae92c5bd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
@@ -657,7 +657,6 @@ int mt792x_init_wiphy(struct ieee80211_hw *hw)
 				 BIT(NL80211_IFTYPE_P2P_CLIENT) |
 				 BIT(NL80211_IFTYPE_P2P_GO) |
 				 BIT(NL80211_IFTYPE_P2P_DEVICE);
-	wiphy->max_remain_on_channel_duration = 5000;
 	wiphy->max_scan_ie_len = MT76_CONNAC_SCAN_IE_LEN;
 	wiphy->max_scan_ssids = 4;
 	wiphy->max_sched_scan_plan_interval =
-- 
2.53.0



