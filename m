Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051300;
	b=Zq43HDaCXDgjsVIwbSmDniBSaxUe++bPXtsMdBdv9JpyAIFkP7okeDuJT7jdlLsoaUUD
	 blKPIoE0XqROb+PLb+pB10cFeAoxkzRNGVOt4xBGzBxjxJvJGRxSOfFJTg7xa/g+IMnvc
	 NBZVmM6j7mcUkiLxsUYQJvQWaZohTeTgTtOlo9fKhtW+QL7tfZxWY3vcOGlruy9yqLmvF
	 YroqgJ7muCkbIbEmAtGBbnbYgo65mPQ7qIJnpH9NrkKHEZ+8u5XyG4KwmuNbkzhFiB1+Y
	 Zt5U6xKvTQl0OMXcQ4oj26y9CgybPt727lQwOJyYTa8aiemnNo6t8RdzKsWoFH0NXww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051300;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CpQIMzCNV4s1sK8ircGIIWWFL570J1ahjWXa+e3BdU4=;
	b=S+sNNNAzqmFQM/7iwDfM7YOl94mX6491kMqRKwLMTH0X7V9vEvJkvugkVBUMGaWPgXio
	 YdXIl9ydVB/w01fib4UyLJaWfZfckx6RoSmo/adJ4gtnFUlAmzEc2U3QhghzcTu7ObTU2
	 kwpUiinG5yZdRb3eonncc/hq8cpRqC2J0yWSmjadGOPiPmChunnZlB+QwsIubrbMgsaQ3
	 Sph6YmmJD5L/+T62Kk4vJWFBKndzG6kKP6Dn1ImabruESnJFsgmuImvsPpvfITaZd++OK
	 F58/7qbWIwbrtACIyph1Op8oIbnEBavqUfKgMk5m2QZoYBAFjfV8fTwegelcKY0rfOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qWo6TKJZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E32A606A31C;
	Thu, 19 Nov 2026 01:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qWo6TKJZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733641F000C4;
	Thu, 19 Nov 2026 01:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051300;
	bh=CpQIMzCNV4s1sK8ircGIIWWFL570J1ahjWXa+e3BdU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qWo6TKJZN10AI2SBuKgZStv77D52G2yrPyi1Rmh5XtmM2gm9lKIh6DlCSV/xgRlhf
	 guG2YDZwjP4IOvQNkccBb0AvuJenwEBiXawpZy5YrETB37FCqDj+jBBEfk3ikDQYcM
	 LeUbtY4Rk3hUpHefjhyw55Bsb4hqPAjx+QfTOb08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Bauer <mail@david-bauer.net>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0158/2214] wifi: mt76: mt7603: free beacon SKB on error
Date: Wed, 18 Nov 2026 15:30:34 +0100
Message-ID: <20261118150016.452205860@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7fa6b0ed9d478..86a7e402393ee 100644
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



