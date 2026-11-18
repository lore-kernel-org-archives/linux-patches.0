Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031207;
	b=S5TbKpnkMKQA2BvtJmhLEbzm/MjyFsexv2wOOmuEOBwe9qTMbuPPgZMlmwyU1Q23Le2u
	 BLYtcCLK9yKN6FhLhV/NDclX92dU391Vu7PNAsMjk2YnVEXr+jS0f6qOjiNROnXM321h5
	 4pZf68ULWRHg6BSc8P11eA14YQ22J3CdxI1RAwSlG0+C63rpn2PUqidRmPGV6lN7dEpHY
	 RND/64m0oQ4jPy2r+AD/h5VyqDjtybWliACAI7JrYSkN5yM8kaxWu/scpTTP3tnQ/vi5s
	 lY5s1pj1oddTTCfk/w8CS2JCP6gIWFbmQWCr9LaYo+BnIZt4a1AROVzJI/UVzD4/W8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031207;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nxoPtc0P+mVj3o/8CxeH6izQZ3rSWbIKlBgN3o6GyxU=;
	b=nl5G1V5JgpH1VAScwiQsjRQ1C4qFASliTEYv7r5RW1yVBOjEZZJI0jfkXt2n0AjzZ25f
	 ksXs2BtpkUc239xypnGIvZqZquJ2KLpEJ5TUtpAbyq/ubR/72987TWvaPH85nhl/YhhTb
	 OamZ7zK0nvMFV3sIDcZdyj05gR5KGYLwYC4iInp54wG7Tn1lj6/tW6d/QqtIntnGTrr7q
	 ocfl9RxvgheRiFnz0X2sFbEFhZoso027IWbwW+WDyxrKcva/GN9cOTgHSZbjr9KBSI41h
	 +4eKzcQIl+p1pZBg2TsTH22hj8SFAIRM6/qtgfvdGi7Mb0964T0L+I/dD9igC7UheKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ThKTeEBO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B0F606A32A;
	Wed, 18 Nov 2026 19:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ThKTeEBO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2BBA1F000C5;
	Wed, 18 Nov 2026 19:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031207;
	bh=nxoPtc0P+mVj3o/8CxeH6izQZ3rSWbIKlBgN3o6GyxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ThKTeEBOYurP+ISKck53maVM5thnjAtciHoj31hyve2sepBaJDtHjClqs45SoolYj
	 wkTbVaXQucZHZ/7eFijoN9JFnh66pS98hA23QJljtlqzWYgU8qMnSXpLMADZ/HXW6X
	 5V8jztD7GQF9AJXz25EygnKr6/Cl6f9yA7zxAnUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0978/1756] wifi: mt76: mt792x: compute the assoc RSSI from the chain signals
Date: Wed, 18 Nov 2026 15:51:45 +0100
Message-ID: <20261118150049.089994696@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 2d12f56631ef307e58651b560ccda1f324a059f9 ]

mt792x_mac_rssi_iter() adds status->signal of auth and assoc response
frames to the BSS RSSI average, which mt7921_mcu_sta_update() and
mt7925_mcu_sta_update() send to the firmware as the station RCPI.
mt7925 never sets status->signal, since mt76_rx_convert() computes it
from the chain values later. The average is thus fed 0 dBm on mt7925.

Compute the signal from the chain values, as mt76_rx_convert() and
mt76_check_sta() do, and skip a frame without a valid chain signal. On
mt7921, the average now follows the combined value instead of the
strongest chain.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Link: https://patch.msgid.link/20261007112419.1277594-4-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt792x_mac.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_mac.c b/drivers/net/wireless/mediatek/mt76/mt792x_mac.c
index 05978d9c7b916..d559b8a008c0f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_mac.c
@@ -168,14 +168,16 @@ mt792x_mac_rssi_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
 	struct mt76_rx_status *status = (struct mt76_rx_status *)skb->cb;
 	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
 	struct ieee80211_hdr *hdr = mt76_skb_get_hdr(skb);
+	int signal;
 
-	if (status->signal > 0)
+	signal = mt76_rx_signal(status->chains, status->chain_signal);
+	if (signal > 0 || signal <= -128)
 		return;
 
 	if (!ether_addr_equal(vif->addr, hdr->addr1))
 		return;
 
-	ewma_rssi_add(&mvif->bss_conf.rssi, -status->signal);
+	ewma_rssi_add(&mvif->bss_conf.rssi, -signal);
 }
 
 void mt792x_mac_assoc_rssi(struct mt792x_dev *dev, struct sk_buff *skb)
-- 
2.53.0



