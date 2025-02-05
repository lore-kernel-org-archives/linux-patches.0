Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C824A28;
	Wed,  5 Feb 2025 14:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764952; cv=none; b=RdDL3Gk+SanGMjxzQiSf1BRHI29VbQX9ECz3l095XMQvzOPGJMXp0MMmGsqjaicPRmuH9Gfo+RDDe5eNIVdPLVC9Enjl+bMMFEJz+hXrKJvRLmrCjIl21vK4nMl6Ox3KCAyyLPFHAvfmiuA7ZL0Yts/ymb1lODHVj+IKBHlhDqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764952; c=relaxed/simple;
	bh=WqE3o7djqdkxUu0acwbdZ8nc8nTX/E/OG+MOSumW5Go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=roeW6grKpZGl6VpJcZFGdoQ5s+OQ7GG0LcA4WUtACxyEe/qQdk7F91WYAVYSZVjay0jxIAfHSx+rxDYdE8FyMj2aNWeyoBlg3o6ALL73YM+Mm1+uvs2y1cg1WOZggpi7ETN1UbDxLTPhdVd0faZtj5laJ3qUUB+4DXlE+UnaVJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MOUNvHQx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MOUNvHQx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27B2C4CEDD;
	Wed,  5 Feb 2025 14:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764952;
	bh=WqE3o7djqdkxUu0acwbdZ8nc8nTX/E/OG+MOSumW5Go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MOUNvHQxCEv8xqgvhcN1eh73RHfCybh2aIVJj9Ge2r7zHpaH9nMmZx7yMoiPGWmxr
	 xkZF/JcVr62R/8UbaeBVgpiCZ0Z6MVb0Sy4nyt4QnT6vbruBx42hXLZ2zJVXmlcZeu
	 2OwgeWyIjBeyTwRV1cQj4aZuq7kksMQeqXxKwlaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric-SY Chang <eric-sy.chang@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 176/590] wifi: mt76: mt7925: fix wrong band_idx setting when enable sniffer mode
Date: Wed,  5 Feb 2025 14:38:51 +0100
Message-ID: <20250205134502.015528993@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric-SY Chang <eric-sy.chang@mediatek.com>

[ Upstream commit 85bb7c10c1a013ab29d4be07559105dd843c6f7d ]

Currently, sniffer mode does not support band auto,
so set band_idx to the default 0.

Fixes: 0cb349d742d1 ("wifi: mt76: mt7925: update mt7925_mac_link_bss_add for MLO")
Signed-off-by: Eric-SY Chang <eric-sy.chang@mediatek.com>
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20241101074340.26176-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 0c2a2337c313d..a78883d4d6df0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -1976,8 +1976,6 @@ int mt7925_get_txpwr_info(struct mt792x_dev *dev, u8 band_idx, struct mt7925_txp
 int mt7925_mcu_set_sniffer(struct mt792x_dev *dev, struct ieee80211_vif *vif,
 			   bool enable)
 {
-	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
-
 	struct {
 		struct {
 			u8 band_idx;
@@ -1991,7 +1989,7 @@ int mt7925_mcu_set_sniffer(struct mt792x_dev *dev, struct ieee80211_vif *vif,
 		} __packed enable;
 	} __packed req = {
 		.hdr = {
-			.band_idx = mvif->bss_conf.mt76.band_idx,
+			.band_idx = 0,
 		},
 		.enable = {
 			.tag = cpu_to_le16(UNI_SNIFFER_ENABLE),
@@ -2050,7 +2048,7 @@ int mt7925_mcu_config_sniffer(struct mt792x_vif *vif,
 		} __packed tlv;
 	} __packed req = {
 		.hdr = {
-			.band_idx = vif->bss_conf.mt76.band_idx,
+			.band_idx = 0,
 		},
 		.tlv = {
 			.tag = cpu_to_le16(UNI_SNIFFER_CONFIG),
-- 
2.39.5



