Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F0D333721;
	Tue, 11 Nov 2025 01:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823956; cv=none; b=tPvaxI6R4QLTdTQNW9epPvACdMqm7a0yUOSktEvGvQiFq5cqYzRj82JBV8VPkvb8D47pmxSWGL2YRANPViEkDJzZzdHZkWRphFLzYrVJ2yQQYFietQQIs+cInTsruoPY4fVMgjk6mfzHZovixM1GHJd8pS9+UE7mV+UuXy5QtrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823956; c=relaxed/simple;
	bh=5qrQg1wDeLCg8qQan49Ado5S/0PVi2HvHsrdrOj6g0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oL1DQjKRN81gquXPBXr9HaukFIqaJYUw92ja/t/hrosl7lUHwDdUNzm45l2Gst74UclS10EYZaMUM9eng3GnMuHoJhrjOwQaZZ8uD4arovrvdztukAoSPYdp6py5KxZiK//hXkB+AynBWuwZTrnFqSKZTn/c6Y+nS7mLF8e0wkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JdezTBWG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JdezTBWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207F1C4CEF5;
	Tue, 11 Nov 2025 01:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823956;
	bh=5qrQg1wDeLCg8qQan49Ado5S/0PVi2HvHsrdrOj6g0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JdezTBWGQPT0fWfe9+nhBpztf252nmR5LwC9oqoAAx1qa48NZPi+LkLNBfi6jxInC
	 9JeKpOXccqoVAVgtVN2OJq+tTQY99Ft0rDnF/n04KSEkcSsXWj/QDTQ7E/GbvEVVZM
	 0tFebKeM9xOGhdp7ZgTVIUN7GQsH8Pct96N8bQAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 357/565] wifi: mt76: mt76_eeprom_override to int
Date: Tue, 11 Nov 2025 09:43:33 +0900
Message-ID: <20251111004534.902095553@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit c7c682100cec97b699fe24b26d89278fd459cc84 ]

mt76_eeprom_override has of_get_mac_address, which can return
-EPROBE_DEFER if the nvmem driver gets loaded after mt76 for some
reason.

Make sure this gets passed to probe so that nvmem mac overrides always
work.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://patch.msgid.link/20250911221619.16035-1-rosenp@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/eeprom.c        | 9 +++++++--
 drivers/net/wireless/mediatek/mt76/mt76.h          | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c | 3 +--
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c | 4 +---
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   | 5 ++++-
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c | 6 +++++-
 drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c | 4 +++-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c | 4 +---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   | 4 +++-
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   | 4 +++-
 drivers/net/wireless/mediatek/mt76/mt7925/init.c   | 4 +++-
 drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c | 3 +--
 drivers/net/wireless/mediatek/mt76/mt7996/init.c   | 4 +++-
 13 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/eeprom.c b/drivers/net/wireless/mediatek/mt76/eeprom.c
index 443517d06c9fa..a987c5e4eff6c 100644
--- a/drivers/net/wireless/mediatek/mt76/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/eeprom.c
@@ -163,13 +163,16 @@ static int mt76_get_of_eeprom(struct mt76_dev *dev, void *eep, int len)
 	return mt76_get_of_data_from_nvmem(dev, eep, "eeprom", len);
 }
 
-void
+int
 mt76_eeprom_override(struct mt76_phy *phy)
 {
 	struct mt76_dev *dev = phy->dev;
 	struct device_node *np = dev->dev->of_node;
+	int err;
 
-	of_get_mac_address(np, phy->macaddr);
+	err = of_get_mac_address(np, phy->macaddr);
+	if (err == -EPROBE_DEFER)
+		return err;
 
 	if (!is_valid_ether_addr(phy->macaddr)) {
 		eth_random_addr(phy->macaddr);
@@ -177,6 +180,8 @@ mt76_eeprom_override(struct mt76_phy *phy)
 			 "Invalid MAC address, using random address %pM\n",
 			 phy->macaddr);
 	}
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(mt76_eeprom_override);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index a6ac8e5512eba..e7ebae0584f55 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -1185,7 +1185,7 @@ void mt76_seq_puts_array(struct seq_file *file, const char *str,
 			 s8 *val, int len);
 
 int mt76_eeprom_init(struct mt76_dev *dev, int len);
-void mt76_eeprom_override(struct mt76_phy *phy);
+int mt76_eeprom_override(struct mt76_phy *phy);
 int mt76_get_of_data_from_mtd(struct mt76_dev *dev, void *eep, int offset, int len);
 int mt76_get_of_data_from_nvmem(struct mt76_dev *dev, void *eep,
 				const char *cell_name, int len);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c
index f5a6b03bc61d0..88382b537a33b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c
@@ -182,7 +182,6 @@ int mt7603_eeprom_init(struct mt7603_dev *dev)
 		dev->mphy.antenna_mask = 1;
 
 	dev->mphy.chainmask = dev->mphy.antenna_mask;
-	mt76_eeprom_override(&dev->mphy);
 
-	return 0;
+	return mt76_eeprom_override(&dev->mphy);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
index ccedea7e8a50d..d4bc7e11e772b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
@@ -351,8 +351,6 @@ int mt7615_eeprom_init(struct mt7615_dev *dev, u32 addr)
 	memcpy(dev->mphy.macaddr, dev->mt76.eeprom.data + MT_EE_MAC_ADDR,
 	       ETH_ALEN);
 
-	mt76_eeprom_override(&dev->mphy);
-
-	return 0;
+	return mt76_eeprom_override(&dev->mphy);
 }
 EXPORT_SYMBOL_GPL(mt7615_eeprom_init);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/init.c b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
index 66ba3be273434..d0d880f8c0aa4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
@@ -570,7 +570,10 @@ int mt7615_register_ext_phy(struct mt7615_dev *dev)
 	       ETH_ALEN);
 	mphy->macaddr[0] |= 2;
 	mphy->macaddr[0] ^= BIT(7);
-	mt76_eeprom_override(mphy);
+
+	ret = mt76_eeprom_override(mphy);
+	if (ret)
+		return ret;
 
 	/* second phy can only handle 5 GHz */
 	mphy->cap.has_5ghz = true;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index 4de45a56812d6..d4506b8b46fa5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -332,7 +332,11 @@ int mt76x0_eeprom_init(struct mt76x02_dev *dev)
 
 	memcpy(dev->mphy.macaddr, (u8 *)dev->mt76.eeprom.data + MT_EE_MAC_ADDR,
 	       ETH_ALEN);
-	mt76_eeprom_override(&dev->mphy);
+
+	err = mt76_eeprom_override(&dev->mphy);
+	if (err)
+		return err;
+
 	mt76x02_mac_setaddr(dev, dev->mphy.macaddr);
 
 	mt76x0_set_chip_cap(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c
index 156b16c17b2b4..221805deb42fa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c
@@ -499,7 +499,9 @@ int mt76x2_eeprom_init(struct mt76x02_dev *dev)
 
 	mt76x02_eeprom_parse_hw_cap(dev);
 	mt76x2_eeprom_get_macaddr(dev);
-	mt76_eeprom_override(&dev->mphy);
+	ret = mt76_eeprom_override(&dev->mphy);
+	if (ret)
+		return ret;
 	dev->mphy.macaddr[0] &= ~BIT(1);
 
 	return 0;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
index 928e0b07a9bf1..b038568e0be91 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
@@ -284,9 +284,7 @@ int mt7915_eeprom_init(struct mt7915_dev *dev)
 	memcpy(dev->mphy.macaddr, dev->mt76.eeprom.data + MT_EE_MAC_ADDR,
 	       ETH_ALEN);
 
-	mt76_eeprom_override(&dev->mphy);
-
-	return 0;
+	return mt76_eeprom_override(&dev->mphy);
 }
 
 int mt7915_eeprom_get_target_power(struct mt7915_dev *dev,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index bc983ab10b0c7..83f062fb95d5a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -689,7 +689,9 @@ mt7915_register_ext_phy(struct mt7915_dev *dev, struct mt7915_phy *phy)
 		mphy->macaddr[0] |= 2;
 		mphy->macaddr[0] ^= BIT(7);
 	}
-	mt76_eeprom_override(mphy);
+	ret = mt76_eeprom_override(mphy);
+	if (ret)
+		return ret;
 
 	/* init wiphy according to mphy and phy */
 	mt7915_init_wiphy(phy);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/init.c b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
index d1d64fa7d35d0..4bd533c4ba9a1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
@@ -182,7 +182,9 @@ static int __mt7921_init_hardware(struct mt792x_dev *dev)
 	if (ret)
 		goto out;
 
-	mt76_eeprom_override(&dev->mphy);
+	ret = mt76_eeprom_override(&dev->mphy);
+	if (ret)
+		goto out;
 
 	ret = mt7921_mcu_set_eeprom(dev);
 	if (ret)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/init.c b/drivers/net/wireless/mediatek/mt76/mt7925/init.c
index 02899320da5c1..5123a720413ff 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/init.c
@@ -132,7 +132,9 @@ static int __mt7925_init_hardware(struct mt792x_dev *dev)
 	if (ret)
 		goto out;
 
-	mt76_eeprom_override(&dev->mphy);
+	ret = mt76_eeprom_override(&dev->mphy);
+	if (ret)
+		goto out;
 
 	ret = mt7925_mcu_set_eeprom(dev);
 	if (ret)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c
index 4a82371182873..4c4ab0d4065d2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c
@@ -235,9 +235,8 @@ int mt7996_eeprom_init(struct mt7996_dev *dev)
 		return ret;
 
 	memcpy(dev->mphy.macaddr, dev->mt76.eeprom.data + MT_EE_MAC_ADDR, ETH_ALEN);
-	mt76_eeprom_override(&dev->mphy);
 
-	return 0;
+	return mt76_eeprom_override(&dev->mphy);
 }
 
 int mt7996_eeprom_get_target_power(struct mt7996_dev *dev,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index 65bd9c32d42c1..5cd2fb7d9835c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -601,7 +601,9 @@ static int mt7996_register_phy(struct mt7996_dev *dev, struct mt7996_phy *phy,
 		if (band == MT_BAND2)
 			mphy->macaddr[0] ^= BIT(6);
 	}
-	mt76_eeprom_override(mphy);
+	ret = mt76_eeprom_override(mphy);
+	if (ret)
+		goto error;
 
 	/* init wiphy according to mphy and phy */
 	mt7996_init_wiphy(mphy->hw, wed);
-- 
2.51.0



