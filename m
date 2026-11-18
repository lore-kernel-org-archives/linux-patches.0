Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043336;
	b=0CDwAC46H3+8uf0w6irUncOntvNlr3JYUk9Y3ExHzJEgBxh+mhw8XPua5KUmWczHRkEF
	 oLd4raYqe5mX9Im3dW3xqdDOYqRi0enxiBab741CCLIlvaqaXJ25GinTuMNG+9qNouMDW
	 DS269sDbiRF2RIN7387p6SNrduRvryNnnuN6rl46az9686QBEZ9k6jNjeX4ht/7trOOYJ
	 +7XXehZM4WlKGN8VHxKyH97SEpdkhWhnJYJFYLUDvU2D+aCEVz/zNudtV41kP3zbtsGQ3
	 LJJqgCJk+cnPjOLTxSQ05kyuMPxdpOzKdrJj9Umc4OlIbWub0yVtvjL59g9Lp3R8KHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043336;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R2k4ofc0KhEUTwTVeQVJuQOC+cIEMW5eqB06H2R57bI=;
	b=oJNfivQBPyYekPSeRA6KZ0qdA/aJZSS7jSGXCsK4HM1UaX9uI5TOzMxj67xJbjOn8Q9W
	 i8GuAc+x6o0pRiQvso5vQPhAGwtp59Fx9x7NoG7INqJDV8VTXfUPN53C9boEjAh40plNQ
	 J+Gfk7No8jeuMw2WZj1UDkAD57jl+acDPhmT89tSlll+M7A8CjA4VtohgMAIXipw82CnR
	 GCaLC76fAVEIgg9ufsPCbLyHQC4QpSfrieJtLiVApN3f0OxiKxlHVPD8KFEebKpOh5Zt2
	 z/3F0rnGq1JsOopt73PnhG6iY7GaY71B2oI4/qW1aH69lnjkbungPi2aiFUAMGGkBQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SGs4hwcg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435C0606A31C;
	Wed, 18 Nov 2026 23:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SGs4hwcg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C15E1F000C4;
	Wed, 18 Nov 2026 23:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043336;
	bh=R2k4ofc0KhEUTwTVeQVJuQOC+cIEMW5eqB06H2R57bI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SGs4hwcgk2OIYVcxcea4mIKpzOcI4bun9gfS/cm7PmcRlnx7h6iIx6vXJ3G9HliL+
	 9EXFR+IVJ5e2qHU/k/AykTYbW+h3ub45/JK+HhC3beBLENM05L2LVDqtt4pMvJMNeK
	 apiwCuw9As4+HQc96Q6V3LJxy+PwzVPYFyEc3Y3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Bauer <mail@david-bauer.net>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0174/2857] wifi: mt76: mt7603: free beacon SKB on error
Date: Wed, 18 Nov 2026 15:20:08 +0100
Message-ID: <20261118150207.616504949@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 808466b7de472..c0fd4b7a085c7 100644
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



