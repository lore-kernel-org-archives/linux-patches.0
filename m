Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034101;
	b=EUgBNwrnXXUwaDdF4Vfoao5FJgrDlYHj2mR1fMPKVOBGNyh/V0no5euVqJQYUJVD115A
	 dZ7A4eEuBDkLWmypGu/G9gXyzYb+JBntyfJoU6z6X7zCBjrihqgOiQr0hL/XAj+yvW3Bz
	 Ec1VXm67fOHsk5CXqim7KJORStfrWn18JpwlJdZlEh1ADof3jS1p1H4xMESpyCXDn8N+q
	 WxnxMjAdQOBZsc7xpUegOcIgzAzTh4vNHX9k/Funz+xdqQBdGZeehFOR1XJJvqRmFam0Q
	 13EBsWBE4EYIxYezUlJBB1dToM0GMM6QPdw5YK8v+s5Ka+WiSZ8ESXpTot4v/tUz8SA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034101;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bxLgjrgpdkezTNv92w22iiUwZNavZ/p4pyWRzXehgrU=;
	b=X0P5g1X7eDCAp1gL5zfPXIo6yzi4rKLbsuVCSPDsDPPYfKff61G2ecPkYb26IYAO/YW0
	 y63l/HWPLe1WLYGtNxR00nosjC3hyRVX/Khl44fBQiAyXYaYQyePu4ZGCKJff9dREdqWC
	 e39yECZUpx3wMuQoh2B7eqbNgaWtKBcZ/35jcV0j/5Mk7d+46MudHfN9OHAjoH4/52Nuh
	 71pbCIZjlqGpf1PFMRBg+gD7usjmhw757kaWqX5d0LElYClBLW1tO5389r1mJ2Rqyqkdn
	 8QbvhxdnNpbzrGVNUeodEWvp8Sk01Lz37PzfVB6Fl6g7MD7vwPu6jXd2qPdMq8jVcwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mWpTAsxq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A380B606A320;
	Wed, 18 Nov 2026 20:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mWpTAsxq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 043831F000C4;
	Wed, 18 Nov 2026 20:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034101;
	bh=bxLgjrgpdkezTNv92w22iiUwZNavZ/p4pyWRzXehgrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mWpTAsxqJvcfvQih5VRccowWn3soPP5/Z28rXgaYOJbnhb6+Pgc2PBWCnFREDm7aF
	 14iIh4rCipfC1q0sHvMm7OQ7JTf69Zaf5AGlUeVwZ9Cr7QI/+mSjK1p73lTJ9bvewY
	 FMup7LPggLOn818ABjfXWS/kDCx9FjGAc8qRDSgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chad Monroe <chad@monroe.io>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0210/3318] wifi: mt76: mt7615: fix NULL deref in mt7615_mac_set_rates
Date: Wed, 18 Nov 2026 15:13:52 +0100
Message-ID: <20261118150321.223248796@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0052d103e276a..a830c80d5aa3a 100644
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



