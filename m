Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216549;
	b=aijdqZFQGAmQo6JP0WN5OcDb12m0f1zcULUXzhTxC2UTepoToR/PCLXwgBIT1h4tsPMJ
	 MTQ/7z/lvjDc2R8pFRpeUIyg1Q8ExAWZqKpxdpq9Aa4fDutrkYHi9ea3tXat0+q4FdcyS
	 mmIoFDaOEu48USqg2+ukew6OU5Onymug7cF3om+iMd2Alid/9+AEpcQbxvl0swwa5jMSI
	 aFVvdvFrPv2ravxuCj4f+gyBJz/eoAJ6W8k2odyYnwm6JxgosfC6Zx7AeJaXrwJIxJiFC
	 Dy/vdVuG9BzXHQQ0+PCz9A0I8YXyDWutdLdl07ShANq+mADEePg0LO4R2QYt6RxlF1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216549;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gIZoAlYpOaCEJT2X2pFQuiemTkyKEPYOFZc5kRKJ0Kw=;
	b=vVXVk18P2TynXgSvTWw4JQKE5DVlDHMmZqydWwU9lOfhSMyV0QoLd94QsMsd1jJ6qDAM
	 Ck4Ub10HTuEBsHkvQ2z4kkJGWhHy77unCHaECacDliDevM71UC/RaXDkHR17XmBEcFifP
	 a0M9m0VeQCt1eyMQEc4V04fUh44rj5Kyzeb5Usc/lIJO0fHogSo1O7gM+GCp+/nT7tyi7
	 ewJkqxPcLX6CqoBDIxUBtfB4CSEOA9J3Bj0dKaoK4KurvicfGd2PcWhKwrGiC7IlVu8+C
	 1PIxGwEVZOR2TvLNOFJ+VS1jKYPlpdpOkwD5XVQOxM0AwDWG50tzsaTImVTNwcEqOBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jfpDBL5m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02104606A31C;
	Wed, 28 Oct 2026 19:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jfpDBL5m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502331F01825;
	Wed, 28 Oct 2026 19:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216548;
	bh=gIZoAlYpOaCEJT2X2pFQuiemTkyKEPYOFZc5kRKJ0Kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jfpDBL5maBGQUAr4XSRJHPe9neWab99vH8O6PNpE9htdkFsBf4Yne1kqUfB8qzTpA
	 vIwbYF6RlQqqthAt7NIyO6SA+SruvlD1+6gL7U6ZKueO7GNZnp5yXKHMX7tJD2JbAQ
	 OB5Y4mXZXdMvAVTXiwDrRNmWa6jYwYtICp9K6cZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1593/1887] wifi: mt76: mt7915: allocate vif wcid in the same range as stations
Date: Wed, 28 Oct 2026 18:01:29 +0100
Message-ID: <20261028170535.722665594@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit f3049b88b2b32326df97461813ae73e8bbc296fc ]

Reduces the amount of unnecessary WTBL bank switching, while still reserving
WTBL entries for vifs.

Link: https://patch.msgid.link/20240827093011.18621-8-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: 2fb6480c52f6 ("wifi: mt76: mt7915: unwind state on add_interface failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index 0da672a86ae1f..cee7cd4ad26d7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -236,7 +236,9 @@ static int mt7915_add_interface(struct ieee80211_hw *hw,
 	dev->mt76.vif_mask |= BIT_ULL(mvif->mt76.idx);
 	phy->omac_mask |= BIT_ULL(mvif->mt76.omac_idx);
 
-	idx = MT7915_WTBL_RESERVED - mvif->mt76.idx;
+	idx = mt76_wcid_alloc(dev->mt76.wcid_mask, mt7915_wtbl_size(dev));
+	if (idx < 0)
+		return -ENOSPC;
 
 	INIT_LIST_HEAD(&mvif->sta.rc_list);
 	INIT_LIST_HEAD(&mvif->sta.poll_list);
@@ -283,6 +285,7 @@ static void mt7915_remove_interface(struct ieee80211_hw *hw,
 
 	mt7915_mcu_add_bss_info(phy, vif, false);
 	mt7915_mcu_add_sta(dev, vif, NULL, false);
+	mt76_wcid_mask_clear(dev->mt76.wcid_mask, mvif->sta.wcid.idx);
 
 	mutex_lock(&dev->mt76.mutex);
 	mt76_testmode_reset(phy->mt76, true);
-- 
2.53.0



