Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060921;
	b=Lu9Gzr5RC6l3rDGcu5UZ7BLyxCgeG/Njun0UAGzchV0ms8+fRMk0nLnxOgC+rVqiMNf9
	 zIhQpgo9DTj6UBkb/zFxBMGiAG/beq1tXAGYadXKjDqipb4ZrMn/JOW5Hde222BE/zWNv
	 T3J8AvkadQwVyteM471JSDXC5fa+0Xs2BTCu3u68n/0JtroJd+7tpKzR7oTzqhaLmt7eR
	 3S/rSDHOXh7CPGza4v8jz5KvtB4KF2NW3BSYCnbFNgjzBkONLTjlRXkFaI758LMOefYpu
	 WUAAwtfTiAR1lppOcjjZ7fcaMY3A66HzlQ2o5wfdHEC3iI5RojpaFHdfLXuwMWktXTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060921;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d0D8rEQiaA41kiH/BPJtsUv6p/coTf5cjolRz3+02hE=;
	b=XesGiFPxUerURUknWcpCqdl3Sx7pyN8tr57kXr8yXIiW6lN/gYuFc/DhzcIdnxOW5AQV
	 kyk6RX2Lqgs4Gr0y3cno6MJv05FisQCCugJptN7/qTl1KNAgaZig7hJqu37BF+gE5Rk36
	 af4tJlrpRbhxJq4cReblE6WT4zSDLi6CJilf2cvMlixnc/Ek7NBdKEid+BudSeVUkyyTW
	 zrNe9ULZ9jiVmVqfyJCbKtL5VRChDaJXOhP5/+tCrrcheG9SIWOvIFMD4vKPt1y0ASXKk
	 edOBn4hHy7aFf/IjzdEcUoFZ2N9BaFzK6sLVwNMICOc0nAG7HjdHS15yz9cR8gIzD2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0kq/vw4W";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0F3606A33A;
	Sat,  7 Nov 2026 14:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0kq/vw4W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC191F0089F;
	Sat,  7 Nov 2026 14:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060921;
	bh=d0D8rEQiaA41kiH/BPJtsUv6p/coTf5cjolRz3+02hE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0kq/vw4WD02LUNSzwipTHmQiZZQIvJkWQ31dyWviLPtZQHgawwWW8ctcHa0xfARnu
	 IH18uZUdnGljsnn1iLpppQlc5SJT8JasBdmmJ04es7A3zNCi0owZfwIyqarHuX1XS2
	 WLZiDNY2cDdJd+fH4KqItRFfhC0oxO71FGmZZp5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chad Monroe <chad@monroe.io>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0252/1536] wifi: mt76: mt7615: fix NULL deref in mt7615_mac_set_rates
Date: Sat,  7 Nov 2026 08:37:48 -0500
Message-ID: <20261107135004.763691552@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index fbb1181c58ff3..047bb86cfff35 100644
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



