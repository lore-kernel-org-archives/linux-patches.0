Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7AD5189B84;
	Tue, 11 Nov 2025 01:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824642; cv=none; b=YmFcks6TQ3HLJAM+SZRfpizTiUi5w4rraTEh1R40AOAd6ro0wn7B1nRhOcbxciHQZf/Pr4fdjQYDwOxCi5IfSbdiajcmL4fC4PqoyWsMfzb5ltG9Rt1gOUTKR2uHz5htQFfVgLyKTN8nLX//bQP4pZbdsh+zjqkKY9iHV8hR9Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824642; c=relaxed/simple;
	bh=bKs5AoxiPswn7w9th0uafXqXGhLkiuPejaykTH5M6I4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UsOb0sIefmkSjetyEArSHP5aoQV8g+8EVg0AA7vwAB9xNzKKLRNX9zZRYWup0UJn3Twy1dpYjhUSPCYMvEECT3iaiXyT0f+QZ6E0qg6oEO2n6GebcnaiNkF0O7LizlUC00YePKGyoIJ3z55VIAtb+EmRcoZ0DlyVKEdoJAyip9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2o2VGVVa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2o2VGVVa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569ADC4AF09;
	Tue, 11 Nov 2025 01:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824642;
	bh=bKs5AoxiPswn7w9th0uafXqXGhLkiuPejaykTH5M6I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2o2VGVVaBnKjssA7rOJaa+dh9OhaLUnkgqpIs9vpELmbffF68eh8ADyKQWGXwvHFD
	 N2RhObz6vSosbwozy5ZXHMvwxpRteTqrC41BFtAcIREJ/sZuQlpTIYGHiYgU+9yX27
	 dbbxUZ4nllwTXxK88PbTaCiVtk4l2AgfRB4wRPMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 542/849] wifi: mt76: mt76_eeprom_override to int
Date: Tue, 11 Nov 2025 09:41:52 +0900
Message-ID: <20251111004549.514397795@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 127637454c827..47c143e6a79af 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -1268,7 +1268,7 @@ void mt76_seq_puts_array(struct seq_file *file, const char *str,
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
index aae80005a3c17..3e7af3e58736c 100644
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
index c0f3402d30bb7..38dfd5de365ca 100644
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
index 3e30ca5155d20..5ea8b46e092ef 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -702,7 +702,9 @@ mt7915_register_ext_phy(struct mt7915_dev *dev, struct mt7915_phy *phy)
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
index 14e17dc902566..b9098a7331b1a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
@@ -189,7 +189,9 @@ static int __mt7921_init_hardware(struct mt792x_dev *dev)
 	if (ret)
 		goto out;
 
-	mt76_eeprom_override(&dev->mphy);
+	ret = mt76_eeprom_override(&dev->mphy);
+	if (ret)
+		goto out;
 
 	ret = mt7921_mcu_set_eeprom(dev);
 	if (ret)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/init.c b/drivers/net/wireless/mediatek/mt76/mt7925/init.c
index 4249bad83c930..d7d5afe365edd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/init.c
@@ -249,7 +249,9 @@ static int __mt7925_init_hardware(struct mt792x_dev *dev)
 	if (ret)
 		goto out;
 
-	mt76_eeprom_override(&dev->mphy);
+	ret = mt76_eeprom_override(&dev->mphy);
+	if (ret)
+		goto out;
 
 	ret = mt7925_mcu_set_eeprom(dev);
 	if (ret)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c
index 87c6192b63844..da3231c9aa119 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c
@@ -334,9 +334,8 @@ int mt7996_eeprom_init(struct mt7996_dev *dev)
 		return ret;
 
 	memcpy(dev->mphy.macaddr, dev->mt76.eeprom.data + MT_EE_MAC_ADDR, ETH_ALEN);
-	mt76_eeprom_override(&dev->mphy);
 
-	return 0;
+	return mt76_eeprom_override(&dev->mphy);
 }
 
 int mt7996_eeprom_get_target_power(struct mt7996_dev *dev,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index 5a77771e3e6d6..a75b29bada141 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -667,7 +667,9 @@ static int mt7996_register_phy(struct mt7996_dev *dev, enum mt76_band_id band)
 		if (band == MT_BAND2)
 			mphy->macaddr[0] ^= BIT(6);
 	}
-	mt76_eeprom_override(mphy);
+	ret = mt76_eeprom_override(mphy);
+	if (ret)
+		goto error;
 
 	/* init wiphy according to mphy and phy */
 	mt7996_init_wiphy_band(mphy->hw, phy);
-- 
2.51.0



