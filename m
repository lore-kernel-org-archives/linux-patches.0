Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33C717E90E;
	Mon, 27 May 2024 19:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836819; cv=none; b=rQzh/FXeNVTO4LVdguU3extHjgTXK5w88Zg/bkA8tACp54BFPhfFcDCgug42USZrGYXiwZC0eDkt4R/sV0J8IFx3OO76gIiL3m9Oo30pacLsEprqQPCtaDkEOCuks30ebsGMGX2Kw0G69a/f3VwdhdwowgmnDYAxpb8bNh3R3BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836819; c=relaxed/simple;
	bh=CAxeFSQGO1ODz12bPZC9EsrwzYKho1KajxqirT4b4Qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNY8b/Km/92sF5ZLlZBP7vO1ypAmrNOZpfsSdEXdI+x3kpF7znzc+5FKboSR074JYMdgBp3Y2Bp4axeyoF/ne0I3XnpLlPqqUE+Vy8tmtusa7JhuZo/fSFGr65B4q+CscfvlVItRjU4uoIoWeZj/cooSRl9DZtxdZDSmGlaXdzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rcQ8CXCY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rcQ8CXCY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8A6C2BBFC;
	Mon, 27 May 2024 19:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836819;
	bh=CAxeFSQGO1ODz12bPZC9EsrwzYKho1KajxqirT4b4Qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rcQ8CXCYQ3fj7UkPlL5C+btWI0nwx9eVQ6/XhLxQgLpS56NbEXGhLvB0NbzCFRqR3
	 +pof7HaMqjWzgzU/feYVedkeo5bzAsG0RpmM3TzksK01HibIXYXAr8TzR08QJLCQ0y
	 c+PlmEN3wge/BSI1ep99G09gQI+UA2Hk25ZUssOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chad Monroe <chad@monroe.io>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 200/427] wifi: mt76: mt7996: fix size of txpower MCU command
Date: Mon, 27 May 2024 20:54:07 +0200
Message-ID: <20240527185620.940125932@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chad Monroe <chad@monroe.io>

[ Upstream commit 66ffcb9abae68625c704b247c7d15cbbc7837391 ]

Fixes issues with scanning and low power output at some rates.

Fixes: f75e4779d215 ("wifi: mt76: mt7996: add txpower setting support")
Signed-off-by: Chad Monroe <chad@monroe.io>
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    | 7 +++++--
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h | 1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index b44abe2acc81b..cfb5a7d348eb8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -4464,7 +4464,7 @@ int mt7996_mcu_set_txpower_sku(struct mt7996_phy *phy)
 		u8 band_idx;
 	} __packed req = {
 		.tag = cpu_to_le16(UNI_TXPOWER_POWER_LIMIT_TABLE_CTRL),
-		.len = cpu_to_le16(sizeof(req) + MT7996_SKU_RATE_NUM - 4),
+		.len = cpu_to_le16(sizeof(req) + MT7996_SKU_PATH_NUM - 4),
 		.power_ctrl_id = UNI_TXPOWER_POWER_LIMIT_TABLE_CTRL,
 		.power_limit_type = TX_POWER_LIMIT_TABLE_RATE,
 		.band_idx = phy->mt76->band_idx,
@@ -4479,7 +4479,7 @@ int mt7996_mcu_set_txpower_sku(struct mt7996_phy *phy)
 	mphy->txpower_cur = tx_power;
 
 	skb = mt76_mcu_msg_alloc(&dev->mt76, NULL,
-				 sizeof(req) + MT7996_SKU_RATE_NUM);
+				 sizeof(req) + MT7996_SKU_PATH_NUM);
 	if (!skb)
 		return -ENOMEM;
 
@@ -4503,6 +4503,9 @@ int mt7996_mcu_set_txpower_sku(struct mt7996_phy *phy)
 	/* eht */
 	skb_put_data(skb, &la.eht[0], sizeof(la.eht));
 
+	/* padding */
+	skb_put_zero(skb, MT7996_SKU_PATH_NUM - MT7996_SKU_RATE_NUM);
+
 	return mt76_mcu_skb_send_msg(&dev->mt76, skb,
 				     MCU_WM_UNI_CMD(TXPOWER), true);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index 36d1f247d55aa..ddeb40d522c5a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -50,6 +50,7 @@
 #define MT7996_CFEND_RATE_11B		0x03	/* 11B LP, 11M */
 
 #define MT7996_SKU_RATE_NUM		417
+#define MT7996_SKU_PATH_NUM		494
 
 #define MT7996_MAX_TWT_AGRT		16
 #define MT7996_MAX_STA_TWT_AGRT		8
-- 
2.43.0



