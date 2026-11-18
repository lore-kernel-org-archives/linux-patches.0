Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019046;
	b=DtTv5R1hHCKbsLRNSJn4+ouqBHHtvu0KHdnlfYclpez+O7O7scX8xEYkQ7jQS4XPwmug
	 LINHEVN77A9nq1d0V45lW0/MMvVeYqCzNoY4pEhGWM0n5TYzCIoZmR9EA5vFrQgF9H5lE
	 1vnve3ur+k97oRQuxesOUtnjAsnYFm9GODSsrQwZFGDvdWffGygcsLfdYTk/3qthMdez+
	 GfoIJbmp7CeYucE1eyWjVq+wdWLYzMSsLj9w+njAncSMaC9ZpqmGdENRd3d/zsTxqVuWr
	 VfQCCouzwNleJ8Gz4TWPl9O3npJiRWjPcrH17CWgGCv7lO5bdcisOcPKl0OI6Wjxedg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019046;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rJSArVFYLxhxRMdr/EyYxEn2h1505rcUdyRF0tiVlks=;
	b=fPeVSTEuGUVmzqA+ijhl7FMCiLCm1QUnOHeIRb9osW0/neF5orMBvFkIRhaSQ0/7eWPw
	 ZNW5Q1NwUxP1I43sR8zPbEpMO9WWaQsuEv1e/lKEQzBDjrS3wSAycveofJu+BMVvdwKfw
	 B3288c7QzAfT/EB0w5CUJL/Klo59CbqC77v8U8RtFaaS2/dzIwZtBqZ9jAit+W13FGY/3
	 Wj+Y9KgX2OK3v3ujHLDCeViUqOqFWaBqj1bejff9PLP53ou7ntcLxI2rIzinlfVZ2pC32
	 igoKuqYT9Yli60qf0vI/1hhiPz8zc8rmloZbH2endQ/IukTWU3gZ4SK7zUCaww02Ryw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2FSptl0S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB7A606A31C;
	Wed, 18 Nov 2026 16:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2FSptl0S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E611F000C4;
	Wed, 18 Nov 2026 16:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019046;
	bh=rJSArVFYLxhxRMdr/EyYxEn2h1505rcUdyRF0tiVlks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2FSptl0SLq3vS1mOKWv4oAjTV+itzf82zrwT17fYcea1Ej7uC5b4DaxaUXjqNCI2O
	 UWDYGdvQqO3ATJsjB19SkCu81wDaYgauiO8DSJMHgFkxaqhus88HZAwJxUEcxzpFdC
	 T2kD9HqRgw7odhiR+GLci2KZVXJqnH7G/vWOsaN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Scott <gilroyscott1970@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1456/2651] wifi: mt76: mt7996: refresh the tx BA session timer on NPU devices
Date: Wed, 18 Nov 2026 15:44:56 +0100
Message-ID: <20261118150340.454011835@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Scott <gilroyscott1970@gmail.com>

[ Upstream commit 43fa49b185832a3dac6845e6d30de44c87a91f16 ]

mt7996_mac_add_txs_skb() refreshes mac80211's tx BlockAck session timer
only when a WED device is active. Airoha boards offload through the NPU
instead, so on those the condition is never true and nothing keeps the
timer alive.

NPU-forwarded frames do not traverse mac80211, and the only other places
that stamp tid_tx->last_tx are in the software tx path. When the peer
negotiates a non-zero BlockAck timeout in the ADDBA response (Intel
stations commonly do, most others answer 0) mac80211 arms
tid_tx->session_timer, which then expires in the middle of an offloaded
transfer and tears the session down with a DELBA.

The session does not come back on its own either: mt7996 restarts one
from mt7996_tx_check_aggr(), reached via mt7996_txwi_free(), and
offloaded frames carry no driver token so they never get there.
mac80211's ieee80211_aggr_check() fallback needs
RATE_CTRL_CAPA_AMPDU_TRIGGER, which mt7996 does not set. The reported
symptom is a file transfer to an Intel client dropping from line rate to
a few MB/s and staying there, with a single ping from the router - one
frame on the software path - restoring it instantly.

Extend the check with mt76_npu_device_active(). TXS reports do arrive
for NPU-forwarded frames, measured at roughly 24 per second on a busy
radio, which is far more than a seconds-scale session timer needs.

A second user who independently saw the same collapse, held off only by
a once-a-second ping from the AP, ran a patched image for 100 hours
(~175 TB of offloaded iperf3 traffic, ~4 Gbit/s) without it recurring.

Link: https://forum.openwrt.org/t/quantum-fiber-w1700k-support/222776/3900
Link: https://forum.openwrt.org/t/quantum-fiber-w1700k-support/222776/3901
Link: https://forum.openwrt.org/t/gemtek-w1700k-community-builds/249319/458
Fixes: 377aa17d2aed ("wifi: mt76: mt7996: Add NPU offload support to MT7996 driver")
Signed-off-by: Chris Scott <gilroyscott1970@gmail.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260918091659.1176350-1-gilroyscott@hotmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index a8c4f629109b8..42c0c53f10238 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1503,7 +1503,8 @@ mt7996_mac_add_txs_skb(struct mt7996_dev *dev, struct mt76_wcid *wcid,
 		}
 	}
 
-	if (mtk_wed_device_active(&dev->mt76.mmio.wed) && wcid->sta) {
+	if ((mtk_wed_device_active(&dev->mt76.mmio.wed) ||
+	     mt76_npu_device_active(&dev->mt76)) && wcid->sta) {
 		struct ieee80211_sta *sta;
 		u8 tid;
 
-- 
2.53.0



