Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830828;
	b=vtSzcyyur0BghQY3ShyAq2rA58iWSPZx8Liiv3lOcBt+Cq1j1JAHBiThdrXtpvuEpiKj
	 x0dit4CgXadonlusAPKu3s2IOflpcPwT4Ehru7NCOMX9i1ziIziIM+qQdiPbkNajfWx6e
	 B8hOUUGAi4EIDGOeoIgtbRY0YGpmAok/mtA1tCmrZ+mll1j2+LUdT9W0FaAj/SUEBPy2v
	 Gb3sATlE/gVsZ242Xc1WI9kpR/TRzI0vtT2LpmNiXbzlpPmM7qfu82IXT21Q6cdNTIu0c
	 azJCyJG+WDMt6WShHUklSJeb8yN1y9bkaQDwW7q5NvSjRW6UorLrSGP//VShBT8IlJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830828;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SRwHYPndnofFUJA9S2wJA3cOQzt6Q/bffdm5VRUnN4g=;
	b=l+ng/QDDsU53Kh3vfvjP9cS86Lt0RrcP6SZRoaxF3qqPs0hFNucFgbzggaw4u8l1LdGd
	 YcNk6GrzY38L24g6RM97GdVaTki8c4HzK6jlzTYWM/kzqxEbC3Yj4RBtUTwbZge03u023
	 Urd7HfMhYGsDLiIwDlsTR3//TPCauSXmLx0xqnYhkQzzO5nhqGhFxkKRhTa+a/N/MSOm0
	 tJcnCuUbzgQYd47b1h85YtBBC63w10KDlJ+l4W7g8Yu0I6ipmFahO8zxVYP8zFq7Ch03W
	 sFTIMsmJRhoYntppSbSO5CHwyEefmxfNptwFh/3tRxO1gMIVjp8UYa654i/7HD7wLrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y6wwHL0v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89030606B2F5;
	Wed,  4 Nov 2026 22:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y6wwHL0v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5AB1F00A1C;
	Wed,  4 Nov 2026 22:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830828;
	bh=SRwHYPndnofFUJA9S2wJA3cOQzt6Q/bffdm5VRUnN4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y6wwHL0vUWLv/GDop6jVNTRgRuf39XgYnD0vkF+DXDZfnO80ufcV5Kgut2PcLwtUg
	 vVm46rPyBJWDaTq6OAABEdsTjd5Bvm9PmN1CNRnrqdnY7VypBPgGcYY+yboBaZTv/g
	 jlY06+3nYFnlcaLDT0sspA+WxrLKVLQZaARoncrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chad Monroe <chad@monroe.io>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0306/1005] wifi: mt76: mt7615: fix NULL deref in mt7615_mac_set_rates
Date: Wed,  4 Nov 2026 16:00:39 -0500
Message-ID: <20261104211052.497977292@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 98aff74779da9f417386c589c36848e9c568f0f9 ]

mt7615_tx() falls back to the vif BSS wcid when mac80211 hands a frame
over without a station, e.g. while a station is being torn down, and to
the global wcid when there is no vif either. Both tx_prepare_skb
implementations derive a mt7615_sta from that wcid unconditionally and,
if the rate control probe flag is set, pass it to mt7615_mac_set_rates(),
which dereferences the NULL vif backpointer of the per-vif embedded sta:

  Unable to handle kernel read from unreadable memory at virtual
  address 0000000000000002
  ...
  pc : mt7615_mac_set_rates
  lr : mt7615_tx_prepare_skb

Neither entry is rate controlled by mac80211: the embedded sta has an
empty rate set, and for the global wcid the container_of does not yield a
valid mt7615_sta at all. Only resolve the sta for wcids that belong to a
station.

Reported-by: Chad Monroe <chad@monroe.io>
Link: https://patch.msgid.link/20260724124813.3961474-23-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/pci_mac.c  | 5 +++--
 drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/pci_mac.c
index b795d11d943d0..61efdf59133f5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/pci_mac.c
@@ -68,10 +68,11 @@ int mt7615_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	int pid, id;
 	u8 *txwi = (u8 *)txwi_ptr;
 	struct mt76_txwi_cache *t;
-	struct mt7615_sta *msta;
+	struct mt7615_sta *msta = NULL;
 	void *txp;
 
-	msta = wcid ? container_of(wcid, struct mt7615_sta, wcid) : NULL;
+	if (wcid && wcid->sta)
+		msta = container_of(wcid, struct mt7615_sta, wcid);
 	if (!wcid)
 		wcid = &dev->mt76.global_wcid;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c b/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c
index 820b395900275..01e79f37649c1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c
@@ -187,10 +187,11 @@ int mt7663_usb_sdio_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	struct sk_buff *skb = tx_info->skb;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_key_conf *key = info->control.hw_key;
-	struct mt7615_sta *msta;
+	struct mt7615_sta *msta = NULL;
 	int pad, err, pktid;
 
-	msta = wcid ? container_of(wcid, struct mt7615_sta, wcid) : NULL;
+	if (wcid && wcid->sta)
+		msta = container_of(wcid, struct mt7615_sta, wcid);
 	if (!wcid)
 		wcid = &dev->mt76.global_wcid;
 
-- 
2.53.0



