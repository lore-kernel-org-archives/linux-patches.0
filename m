Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829713;
	b=o8IFIeVZzeCD6AXjmdDTc+rwQul/B8dzMd1Z2RpFtCQOlfThO50lFXt5BsM5BmoIQlGY
	 nKNfA6gb4zA/T1R+E1xYsFWlRWRk/49P2EPyjmALJoywMXVsdPW2o2i+MrMI7hP1JMLBE
	 zGHrn3OBgp72HKnRZlv8Cde6fQro6Rf7auSNgI2dwsKHA5jOwk0tdalki5WZm461Qtx20
	 YSkuCU71efjLS9tBc+CHbymBjbWPNwWDlW+JgutQJVRqzf69SQWjHfPjfD+R4G3P1xY0q
	 ObM9f63FCLpKVAEjzCLhElWfbaLNqmVW59Qa6P9tla2ZIRKGZM8J5dQ3K78hBjEwJqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829713;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=koOF1gWbDHBcDfJbJawS95HV7HWjU8f7jZngz7v8+Po=;
	b=xJhzjLdctfd4X1KsU0cItR98WgOX6mqP2cccjw7s3xieH4UgjZlrDcDniB+A9vJt1NPZ
	 hV5eJy6SifN/p6Dg0zpML88KOsWPhtP+oA5geyo0niFmnKs29KR8hw1NDEy2G9f4otSfd
	 i8HLvJ/bnbjAe4qd08kHxhy/RZN8glwRsOpm9h/GDFNI9CBDrIVeCTEIUvcYU0QeYGXbq
	 RjtyYNr9GDxWUZz1Lvrw7meXIIyu1yKLFQUdzw3OmY0FyhUnjSfyODJdCNhPp2UVSptbo
	 nwF+SgeJrZFZ4ZKHZ7Ger0Y0U1yzV00jkZQtQcHjUCf3htMU2stk9xR9v6h/IEKmiMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XNRmEeI3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC795606AB3A;
	Wed,  4 Nov 2026 22:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XNRmEeI3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A4241F000C1;
	Wed,  4 Nov 2026 22:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829712;
	bh=koOF1gWbDHBcDfJbJawS95HV7HWjU8f7jZngz7v8+Po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XNRmEeI3FASv7V93RvEcq3EuKkknCKFZNke7TshUfRhQujph+8mGVphSdsI3f0lNt
	 OCm+orVz4QmD0BH1B1rALc86OlNwzT31tIvUGAeeYDVl4duCLLyDE4NRV2eOGuA4bk
	 B6W80qOygXpYemrBQkH/HCpvO7HjLInJWcihS6ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Bauer <mail@david-bauer.net>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0295/1005] wifi: mt76: mt7603: free beacon SKB on error
Date: Wed,  4 Nov 2026 16:00:28 -0500
Message-ID: <20261104211052.174786270@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Bauer <mail@david-bauer.net>

[ Upstream commit 965cbdbdfbd37a659a05ff88e49c216975bd9d2e ]

The SKB containing the generated beacon is not freed when the beacon
queue is deected stuck and scheduled for recovery.

Fixes potential memory leaks in case the beacon queue is detected stuck.

Signed-off-by: David Bauer <mail@david-bauer.net>
Link: https://patch.msgid.link/20260611215658.259324-1-mail@david-bauer.net
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c b/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
index 6457ee06bb5a1..62e8de6949d1a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
@@ -56,6 +56,7 @@ mt7603_update_beacon_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
 		FIELD_PREP(MT_DMA_FQCR0_TARGET_QID, MT_TX_HW_QUEUE_BCN));
 	if (!mt76_poll(dev, MT_DMA_FQCR0, MT_DMA_FQCR0_BUSY, 0, 5000)) {
 		dev->beacon_check = MT7603_WATCHDOG_TIMEOUT;
+		dev_kfree_skb(skb);
 		goto out;
 	}
 
@@ -63,6 +64,7 @@ mt7603_update_beacon_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
 		FIELD_PREP(MT_DMA_FQCR0_TARGET_QID, MT_TX_HW_QUEUE_BMC));
 	if (!mt76_poll(dev, MT_DMA_FQCR0, MT_DMA_FQCR0_BUSY, 0, 5000)) {
 		dev->beacon_check = MT7603_WATCHDOG_TIMEOUT;
+		dev_kfree_skb(skb);
 		goto out;
 	}
 
-- 
2.53.0



