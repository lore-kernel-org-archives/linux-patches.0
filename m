Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707FA1875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC527C433D2;
	Wed, 28 Dec 2022 15:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242697;
	bh=ZxRj5IFNMGrWrL20z3jb98kRIRO9/7nnKdPu9SmzXcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JZEgjYfT6eGZTWM0I/2v4do/QdxkciZ+iGL7/9P5bbLoHbUTh2d6JICVDYh+RcpRI
	 xl/WuDQdBn2rrVdnwmYoMV3YCOz5yb8i1w1j3ThhuoA4RWnCrIRMfa4Od98odiTSmR
	 EagA0jDuVZ08jiWcCRnKBCwYFTrTk6+7ZMf2J1jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0441/1073] wifi: mt76: mt7915: fix reporting of TX AGGR histogram
Date: Wed, 28 Dec 2022 15:33:49 +0100
Message-Id: <20221228144340.006257975@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 528d13e7f033b54d50e0077922dd52f005d648cf ]

Fix stats clash between bins [4-7] in 802.11 tx aggregation histogram.

Fixes: e57b7901469fc ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index 68e1cf5a1044..853d857b1757 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1604,7 +1604,7 @@ void mt7915_mac_update_stats(struct mt7915_phy *phy)
 
 	aggr0 = phy->band_idx ? ARRAY_SIZE(dev->mt76.aggr_stats) / 2 : 0;
 	if (is_mt7915(&dev->mt76)) {
-		for (i = 0, aggr1 = aggr0 + 4; i < 4; i++) {
+		for (i = 0, aggr1 = aggr0 + 8; i < 4; i++) {
 			val = mt76_rr(dev, MT_MIB_MB_SDR1(phy->band_idx, (i << 4)));
 			mib->ba_miss_cnt +=
 				FIELD_GET(MT_MIB_BA_MISS_COUNT_MASK, val);
-- 
2.35.1



