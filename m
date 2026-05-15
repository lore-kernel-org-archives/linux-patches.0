Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248463FD948;
	Fri, 15 May 2026 16:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861556; cv=none; b=O7AlgvSHGai6WHmWFIZtxCnjNtHiK7jNVx5pU83jY2MWqzuA51QOWwao0FLH3h99h3rvuOJ8Xwan0axZyKc6Xk/btC3XsyXGVGJmwHPzOCdFuGLpj2W0UEoNALnTA0lZ92aLAEBIf77XWwUbrYjfSK8L/B4YVM/nfIK06GNbrZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861556; c=relaxed/simple;
	bh=rc1B/pFxHjHg9SzSfc5f1v390DEliK4l4ZSqABewzzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCv6CwkFiels6T7MYX0rGSzYfImCwNi/mkOtMpb8yU2Cy6d/ULzF0Zvax4UUbx6vbLnpMdXZ4p67hoIFyABhwRadJ7CnPfYBZZtROpBT6YAJs7t2v1geAk4yLUxAJ3oHNKXLU1H2z6cTBiUxAT10pCShELEMT3HIBApZX5pGiMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0e+TAkjB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0e+TAkjB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC78C2BCC9;
	Fri, 15 May 2026 16:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861556;
	bh=rc1B/pFxHjHg9SzSfc5f1v390DEliK4l4ZSqABewzzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0e+TAkjBh0H1JfAX4vYRqJI5ScLoOKByWMrJy0ud5C0BqGoRKDETB30G+k1eRbUVQ
	 2BDVVrTA9aZYalvZq6r9V1rGb/yKZuphvDujpHpjN2SCK8OHDXLYIPXEfV8r3iudPO
	 YG+PO22NXOyy8cvm8/IA0UtkGXxpqXRLVNo1CeEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Deren Wu <deren.wu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 373/474] wifi: mt76: connac: introduce helper for mt7925 chipset
Date: Fri, 15 May 2026 17:48:02 +0200
Message-ID: <20260515154723.098476614@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deren Wu <deren.wu@mediatek.com>

[ Upstream commit 525209262f9c2999f6f5fa0c40b4519cd6acfa2e ]

Introduce is_mt7925() helper for new chipset. mt7925 runs the same
firmware download and mmio map flow as mt7921.

This is a preliminary patch to support mt7925 driver.

Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: 56154fef47d1 ("wifi: mt76: mt792x: fix mt7925u USB WFSYS reset handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac.h     |    6 ++++++
 drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c |    4 ++--
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c |    3 ++-
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h |    2 +-
 4 files changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt76_connac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac.h
@@ -172,6 +172,11 @@ struct mt76_connac_tx_free {
 
 extern const struct wiphy_wowlan_support mt76_connac_wowlan_support;
 
+static inline bool is_mt7925(struct mt76_dev *dev)
+{
+	return mt76_chip(dev) == 0x7925;
+}
+
 static inline bool is_mt7922(struct mt76_dev *dev)
 {
 	return mt76_chip(dev) == 0x7922;
@@ -245,6 +250,7 @@ static inline bool is_mt76_fw_txp(struct
 	switch (mt76_chip(dev)) {
 	case 0x7961:
 	case 0x7922:
+	case 0x7925:
 	case 0x7663:
 	case 0x7622:
 		return false;
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
@@ -170,7 +170,7 @@ void mt76_connac_write_hw_txp(struct mt7
 
 	txp->msdu_id[0] = cpu_to_le16(id | MT_MSDU_ID_VALID);
 
-	if (is_mt7663(dev) || is_mt7921(dev))
+	if (is_mt7663(dev) || is_mt7921(dev) || is_mt7925(dev))
 		last_mask = MT_TXD_LEN_LAST;
 	else
 		last_mask = MT_TXD_LEN_AMSDU_LAST |
@@ -214,7 +214,7 @@ mt76_connac_txp_skb_unmap_hw(struct mt76
 	u32 last_mask;
 	int i;
 
-	if (is_mt7663(dev) || is_mt7921(dev))
+	if (is_mt7663(dev) || is_mt7921(dev) || is_mt7925(dev))
 		last_mask = MT_TXD_LEN_LAST;
 	else
 		last_mask = MT_TXD_LEN_MSDU_LAST;
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -66,6 +66,7 @@ int mt76_connac_mcu_init_download(struct
 
 	if ((!is_connac_v1(dev) && addr == MCU_PATCH_ADDRESS) ||
 	    (is_mt7921(dev) && addr == 0x900000) ||
+	    (is_mt7925(dev) && addr == 0x900000) ||
 	    (is_mt7996(dev) && addr == 0x900000))
 		cmd = MCU_CMD(PATCH_START_REQ);
 	else
@@ -3080,7 +3081,7 @@ static u32 mt76_connac2_get_data_mode(st
 {
 	u32 mode = DL_MODE_NEED_RSP;
 
-	if (!is_mt7921(dev) || info == PATCH_SEC_NOT_SUPPORT)
+	if ((!is_mt7921(dev) && !is_mt7925(dev)) || info == PATCH_SEC_NOT_SUPPORT)
 		return mode;
 
 	switch (FIELD_GET(PATCH_SEC_ENC_TYPE_MASK, info)) {
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -1739,7 +1739,7 @@ mt76_connac_mcu_gen_dl_mode(struct mt76_
 
 	ret |= feature_set & FW_FEATURE_SET_ENCRYPT ?
 	       DL_MODE_ENCRYPT | DL_MODE_RESET_SEC_IV : 0;
-	if (is_mt7921(dev))
+	if (is_mt7921(dev) || is_mt7925(dev))
 		ret |= feature_set & FW_FEATURE_ENCRY_MODE ?
 		       DL_CONFIG_ENCRY_MODE_SEL : 0;
 	ret |= FIELD_PREP(DL_MODE_KEY_IDX,


