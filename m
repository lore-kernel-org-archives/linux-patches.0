Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005351863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:02:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752F2C433EF;
	Wed, 28 Dec 2022 15:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239777;
	bh=PKck37gJHVxIdHbiJ16u4EeMeh839mOU25rw5kbdLl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jWCijak6iENV8iqij/KMx8MhVmr1OqPYPD1kJkIkZMlMFtn13CoWBiqfLkI6zjdOE
	 +4Q80KBeApBw3bCwT+vpU9omcX8O4UoYsOOEyL5SkNf2u8XU3bL1iO80QiDPIkyzsS
	 eurlJOE9MnQXIdUpZIzSnmEkRMJD1yspe/Y/Fdh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 269/731] wifi: mt76: mt7921: fix reporting of TX AGGR histogram
Date: Wed, 28 Dec 2022 15:36:16 +0100
Message-Id: <20221228144304.364312503@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

[ Upstream commit 028b4f22b37b88821fd87b56ce47b180583c774e ]

Similar to mt7915, fix stats clash between bins [4-7] in 802.11 tx
aggregation histogram.

Fixes: 163f4d22c118d ("mt76: mt7921: add MAC support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index 426e7a32bdc8..6cf0c9b1b8b9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -1476,7 +1476,7 @@ mt7921_mac_update_mib_stats(struct mt7921_phy *phy)
 	mib->rts_retries_cnt += mt76_get_field(dev, MT_MIB_MB_BSDR1(0),
 					       MT_MIB_RTS_FAIL_COUNT_MASK);
 
-	for (i = 0, aggr1 = aggr0 + 4; i < 4; i++) {
+	for (i = 0, aggr1 = aggr0 + 8; i < 4; i++) {
 		u32 val, val2;
 
 		val = mt76_rr(dev, MT_TX_AGG_CNT(0, i));
-- 
2.35.1



