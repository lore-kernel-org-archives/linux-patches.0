Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0ED13E9C0C;
	Wed, 20 May 2026 16:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294580; cv=none; b=Gbgyr5RNUs1oXnOlVsl2+LVbZ/x4lUO0znRzPdBA39AfhWG7xtj+lKXwlFdk9MP6lCjq4oOmX6WsAqm/5V+c0/kHB4eK1qhHdrr9U4A4zIbsQt65VUFM5WMLwxxsrcnhziVDaK2VsAhrBCtlCNF1EFlBZsAZpMOBRlF9FsUjyZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294580; c=relaxed/simple;
	bh=WlpEztyyhc1o4Xe8QFWwGR9CbR1Nebpj4HSftX7EdUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=maejzRrfFRlKbNp+2s9niL3L1D9z+lM5S52TwWutvjV3Ty6IkKfeneDFxEjthWVQWO0Nl+NF7UfkBI9WAdPipb/Dp93vC/09y3uEwoEqCxuFbLsGhmKoAWjGoLqJB6xk6+BmKewy6EKSVeBxM8/zzsy8dUHjRkqez9c5xf5j8/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+dq4Lq5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+dq4Lq5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B071F000E9;
	Wed, 20 May 2026 16:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294579;
	bh=poWUtBPrmMRRtHX9tjf6Vv7sIh26iW0t3L7srFjvKTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z+dq4Lq5ik82dVM/VMZt9QXsIwNt+J0m2l+LDOnjOEhZ7DhP/NVPNC5ZcqtmefSsa
	 FRcmJ87iIVPg7QmEGaFYlVVWFaubTcI9oV5MeL8MutxDOfZCSjFBqxmE564cbqCa3Z
	 TOoQkmHQ6jY3V5ZTdQ1XfYIcu4NiZkDz0KHa2bzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0094/1146] wifi: mt76: mt7996: fix iface combination for different chipsets
Date: Wed, 20 May 2026 18:05:44 +0200
Message-ID: <20260520162150.477559419@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit 5ef0e8e2653b1ba325eb883ffb94073f19cb669a ]

MT7992 and MT7990 support up to 19 interfaces per band and 32 in total.

Fixes: 8df63a4bbe3d ("wifi: mt76: mt7996: adjust interface num and wtbl size for mt7992")
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20251215063728.3013365-7-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/init.c    | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index 00a8286bd1368..20d4c8d5b3e89 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -34,6 +34,20 @@ static const struct ieee80211_iface_combination if_comb_global = {
 			       BIT(NL80211_CHAN_WIDTH_40) |
 			       BIT(NL80211_CHAN_WIDTH_80) |
 			       BIT(NL80211_CHAN_WIDTH_160),
+	.beacon_int_min_gcd = 100,
+};
+
+static const struct ieee80211_iface_combination if_comb_global_7992 = {
+	.limits = &if_limits_global,
+	.n_limits = 1,
+	.max_interfaces = 32,
+	.num_different_channels = MT7996_MAX_RADIOS - 1,
+	.radar_detect_widths = BIT(NL80211_CHAN_WIDTH_20_NOHT) |
+			       BIT(NL80211_CHAN_WIDTH_20) |
+			       BIT(NL80211_CHAN_WIDTH_40) |
+			       BIT(NL80211_CHAN_WIDTH_80) |
+			       BIT(NL80211_CHAN_WIDTH_160),
+	.beacon_int_min_gcd = 100,
 };
 
 static const struct ieee80211_iface_limit if_limits[] = {
@@ -485,7 +499,8 @@ mt7996_init_wiphy(struct ieee80211_hw *hw, struct mtk_wed_device *wed)
 	hw->vif_data_size = sizeof(struct mt7996_vif);
 	hw->chanctx_data_size = sizeof(struct mt76_chanctx);
 
-	wiphy->iface_combinations = &if_comb_global;
+	wiphy->iface_combinations = is_mt7996(&dev->mt76) ? &if_comb_global :
+							    &if_comb_global_7992;
 	wiphy->n_iface_combinations = 1;
 
 	wiphy->radio = dev->radios;
-- 
2.53.0



