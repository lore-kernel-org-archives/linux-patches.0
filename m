Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018946;
	b=HtnWoiwJgE3/GPJUH786NZ5nJVFW4FCZUgqC1KraW8r+L+SbChd3AUQ0vDo3TJkD7TOj
	 +NOQIzNZOHiUs9Kk3PuU6k8kQdq20PViT2Dsq4vOMNAaiovC8yLkYzbj4/47DeaVzpsIE
	 F4klodLcspSWEVqT58Yj/ghOD5vZqh4YDYLCD7gCu/JYuZVBWsqU3XlIA8g4cqtGbin+b
	 0BD6qophXc0EIpb0HiR1mymRFam/bx1gvLQxPdh8PzXYMPZfsvtbMthGycPxBFgBYA+VP
	 E5xlkuJhfUH7nurw6nVgux9pZ8/D//uL1WX8oN6yJgL632y7xdvZGrqrYzeimSwCXMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018946;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a0JQalTj7RZoZ2VtDeiz1kTmhtiC4u40vIjCSVwewZM=;
	b=xbVQBJuzA3y0NiByG8gje7dBjXfzLMfonO0dI1nLxZ1u7iviLNjpivOlJnSl+bOpZ2XJ
	 d0JhQ3rzPkFG7sAs3qMyy7mn6Qza7MIGksJNHMNpfUNngnao0rmu9JdtnEBA075gVVCm/
	 YpXwj2q1t63qKrf/O1oWV2V7ZtICleQXJ/oUKAyZ3WO/5NSSjnO/HoxNrljVW7baGyBi0
	 jBSY13qun7L+e4LwYRJ5aQa7lWP9hE6abCftwwH9q7s8ZQ8ryzvuRrYVqYbYFt5jkzl+O
	 nXzxbei4+JbBgva4Z8qKiiGpy9p19vHKgxTAtBbsvwX5wPyxczQeJgCdbAjCb+ygB+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rc0np+kY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD838606A31C;
	Wed, 18 Nov 2026 16:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rc0np+kY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D47F1F000C4;
	Wed, 18 Nov 2026 16:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018946;
	bh=a0JQalTj7RZoZ2VtDeiz1kTmhtiC4u40vIjCSVwewZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rc0np+kYU5/D1HKx9MQ91WNoA5+jvy3Mt+7fV9aJaGpLkjJKUIZXX7Gy2YQyR0sBL
	 cWZT+nal9N6eB/yFRUzF5N5Cv0T59kaQvhuZiYAYt8+adoSAezplzMMDy4yHAFqVa8
	 78qTM8GNHL3S/I1vYesyUyHv/8RfqCLA+vYvMYf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Stella Liu <yu-ching.liu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1421/2651] wifi: mt76: mt7925: report only 2.4 GHz NAN supported band
Date: Wed, 18 Nov 2026 15:44:21 +0100
Message-ID: <20261118150339.210272601@linuxfoundation.org>
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

From: Stella Liu <yu-ching.liu@mediatek.com>

[ Upstream commit 4d57010abf701cb08d7216b30143c696a8c2405b ]

The firmware only checks the 2.4 GHz bit of the local device capability
supported_bands field, so set it directly and drop the unused helper.

Fixes: 0f3605e4f8de ("wifi: mt76: mt7925: wire up NAN operations")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Stella Liu <yu-ching.liu@mediatek.com>
Link: https://patch.msgid.link/20260824195227.12589-5-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7925/nan.c   | 20 +------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index 81a1563b1408a..36de42193190e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -680,23 +680,6 @@ static int mt7925_nan_peer_rec_tlv(struct sk_buff *skb,
 	return 0;
 }
 
-static u8 mt7925_nan_get_supported_bands(struct mt792x_vif *mvif)
-{
-	struct wiphy *wiphy;
-	u8 bands = 0;
-
-	if (!mvif || !mvif->phy)
-		return BIT(NAN_SUPPORTED_BAND_ID_2P4G);
-
-	wiphy = mvif->phy->mt76->hw->wiphy;
-	if (wiphy->nan_supported_bands & BIT(NL80211_BAND_2GHZ))
-		bands |= BIT(NAN_SUPPORTED_BAND_ID_2P4G);
-	if (wiphy->nan_supported_bands & BIT(NL80211_BAND_5GHZ))
-		bands |= BIT(NAN_SUPPORTED_BAND_ID_5G);
-
-	return bands ?: BIT(NAN_SUPPORTED_BAND_ID_2P4G);
-}
-
 static int mt7925_nan_peer_cap_tlv(struct sk_buff *skb,
 				   struct ieee80211_sta *sta,
 				   struct mt792x_sta *msta)
@@ -723,8 +706,7 @@ static int mt7925_nan_peer_cap_tlv(struct sk_buff *skb,
 
 	peer_cap_tlv = (struct mt7925_nan_sched_update_peer_cap_tlv *)tlv;
 	peer_cap_tlv->sch_idx = cpu_to_le32(msta->nan_sched.sch_idx);
-	peer_cap_tlv->supported_bands =
-		mt7925_nan_get_supported_bands(msta->vif);
+	peer_cap_tlv->supported_bands = BIT(NAN_SUPPORTED_BAND_ID_2P4G);
 	peer_cap_tlv->max_chnl_switch_time = cpu_to_le16(sched->max_chan_switch);
 
 	for (i = 0; i < sched->n_channels; i++) {
-- 
2.53.0



