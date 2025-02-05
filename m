Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F591459F6;
	Wed,  5 Feb 2025 14:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765541; cv=none; b=fFooOAISxVJnxWhAZYGUa43bhxhsNB6YosK4KP/F0ZU0LQ1fkEvMg8GuGuXuTFUzcSCGAxafm1zvMA0muUwRUk8XfKi+I1gAtnKlYlL5BdRwQMtiFX8Y5HGwh6rlHpnAbaUVKsruoVbB4o22IjQ0s5wzG/gCY9Kpdv0QDMk2Mhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765541; c=relaxed/simple;
	bh=JtbXPTh1/R+Rw54zxK1bRJxB1/pwSGJ24ywI5laqj10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i1RyDbeCUA3EFxVURaWwmYrunsF3tGikMdckASRA5wjC3KJemnD0P88NYSu4PwOFa/6Ec7qTJTSCP9E1GsrSuggQPF438cNoI1XlWGoBaeE8hzcquA8XMXvEuBz3ds8y0hwuyFK3z/25X3pylDnSaFxlniYvB1hAs5CsEhYaaFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Kj0izGg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Kj0izGg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F08C4CED1;
	Wed,  5 Feb 2025 14:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765541;
	bh=JtbXPTh1/R+Rw54zxK1bRJxB1/pwSGJ24ywI5laqj10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Kj0izGgkaPrq6jPbG+ZGnIPKOTZf8FWgT4dMOJJM4pwZEFAfSqK2YiXh4kFaq6gn
	 4AixCskqRJucvuBquIV6gtFxBd+DnHYJv/CcDOvQYAwNeQ8yxCl7bM+X2mBr9Cu9cg
	 Cq242cyse1V1hzCg6bwq8W17X6YTU7cZ5RCLtkKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 187/623] wifi: mt76: connac: Extend mt76_connac_mcu_uni_add_dev for MLO
Date: Wed,  5 Feb 2025 14:38:49 +0100
Message-ID: <20250205134503.392539470@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 9e4c3a007f01f567f2a8af35decd1e3c1c151c0f ]

This commit extends the `mt76_connac_mcu_uni_add_dev` function to include
support for Multi-Link Operation (MLO). Additionally, backward
compatibility for MT7921 is preserved, enabling seamless integration with
existing setups.

Fixes: 86c051f2c418 ("wifi: mt76: mt7925: enabling MLO when the firmware supports it")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Link: https://patch.msgid.link/20241211011926.5002-1-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c      | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h | 1 +
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c      | 1 +
 drivers/net/wireless/mediatek/mt76/mt7921/main.c     | 1 +
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c      | 4 +++-
 drivers/net/wireless/mediatek/mt76/mt7925/main.c     | 2 +-
 drivers/net/wireless/mediatek/mt76/mt792x_core.c     | 3 ++-
 8 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 96e34277fece9..1cc8fc8fefe74 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -1113,7 +1113,7 @@ mt7615_mcu_uni_add_dev(struct mt7615_phy *phy, struct ieee80211_vif *vif,
 {
 	struct mt7615_vif *mvif = (struct mt7615_vif *)vif->drv_priv;
 
-	return mt76_connac_mcu_uni_add_dev(phy->mt76, &vif->bss_conf,
+	return mt76_connac_mcu_uni_add_dev(phy->mt76, &vif->bss_conf, &mvif->mt76,
 					   &mvif->sta.wcid, enable);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 864246f940889..7d07e720e4ec1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -1137,10 +1137,10 @@ EXPORT_SYMBOL_GPL(mt76_connac_mcu_wtbl_ba_tlv);
 
 int mt76_connac_mcu_uni_add_dev(struct mt76_phy *phy,
 				struct ieee80211_bss_conf *bss_conf,
+				struct mt76_vif *mvif,
 				struct mt76_wcid *wcid,
 				bool enable)
 {
-	struct mt76_vif *mvif = (struct mt76_vif *)bss_conf->vif->drv_priv;
 	struct mt76_dev *dev = phy->dev;
 	struct {
 		struct {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index 1b0e80dfc346b..57a8340fa7009 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -1938,6 +1938,7 @@ void mt76_connac_mcu_sta_ba_tlv(struct sk_buff *skb,
 				bool enable, bool tx);
 int mt76_connac_mcu_uni_add_dev(struct mt76_phy *phy,
 				struct ieee80211_bss_conf *bss_conf,
+				struct mt76_vif *mvif,
 				struct mt76_wcid *wcid,
 				bool enable);
 int mt76_connac_mcu_sta_ba(struct mt76_dev *dev, struct mt76_vif *mvif,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index 047106b65d2bc..bd1455698ebe5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -647,6 +647,7 @@ mt7921_vif_connect_iter(void *priv, u8 *mac,
 		ieee80211_disconnect(vif, true);
 
 	mt76_connac_mcu_uni_add_dev(&dev->mphy, &vif->bss_conf,
+				    &mvif->bss_conf.mt76,
 				    &mvif->sta.deflink.wcid, true);
 	mt7921_mcu_set_tx(dev, vif);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 0641538968e6f..e2dfd3670c4c9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -308,6 +308,7 @@ mt7921_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	mvif->bss_conf.mt76.wmm_idx = mvif->bss_conf.mt76.idx % MT76_CONNAC_MAX_WMM_SETS;
 
 	ret = mt76_connac_mcu_uni_add_dev(&dev->mphy, &vif->bss_conf,
+					  &mvif->bss_conf.mt76,
 					  &mvif->sta.deflink.wcid, true);
 	if (ret)
 		goto out;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
index 634c42bbf23f6..ddd406969061e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -1271,6 +1271,7 @@ mt7925_vif_connect_iter(void *priv, u8 *mac,
 	struct mt792x_dev *dev = mvif->phy->dev;
 	struct ieee80211_hw *hw = mt76_hw(dev);
 	struct ieee80211_bss_conf *bss_conf;
+	struct mt792x_bss_conf *mconf;
 	int i;
 
 	if (vif->type == NL80211_IFTYPE_STATION)
@@ -1278,8 +1279,9 @@ mt7925_vif_connect_iter(void *priv, u8 *mac,
 
 	for_each_set_bit(i, &valid, IEEE80211_MLD_MAX_NUM_LINKS) {
 		bss_conf = mt792x_vif_to_bss_conf(vif, i);
+		mconf = mt792x_vif_to_link(mvif, i);
 
-		mt76_connac_mcu_uni_add_dev(&dev->mphy, bss_conf,
+		mt76_connac_mcu_uni_add_dev(&dev->mphy, bss_conf, &mconf->mt76,
 					    &mvif->sta.deflink.wcid, true);
 		mt7925_mcu_set_tx(dev, bss_conf);
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index a5110f8485e52..c45396b17a8af 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -372,7 +372,7 @@ static int mt7925_mac_link_bss_add(struct mt792x_dev *dev,
 	else
 		mconf->mt76.basic_rates_idx = MT792x_BASIC_RATES_TBL;
 
-	ret = mt76_connac_mcu_uni_add_dev(&dev->mphy, link_conf,
+	ret = mt76_connac_mcu_uni_add_dev(&dev->mphy, link_conf, &mconf->mt76,
 					  &mlink->wcid, true);
 	if (ret)
 		goto out;
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_core.c b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
index 78fe37c2e07b5..b87eed4d168df 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_core.c
@@ -147,7 +147,8 @@ void mt792x_mac_link_bss_remove(struct mt792x_dev *dev,
 	link_conf = mt792x_vif_to_bss_conf(vif, mconf->link_id);
 
 	mt76_connac_free_pending_tx_skbs(&dev->pm, &mlink->wcid);
-	mt76_connac_mcu_uni_add_dev(&dev->mphy, link_conf, &mlink->wcid, false);
+	mt76_connac_mcu_uni_add_dev(&dev->mphy, link_conf, &mconf->mt76,
+				    &mlink->wcid, false);
 
 	rcu_assign_pointer(dev->mt76.wcid[idx], NULL);
 
-- 
2.39.5



