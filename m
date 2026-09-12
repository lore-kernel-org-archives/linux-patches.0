Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE1F37E304;
	Sat, 12 Sep 2026 08:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200841; cv=none; b=TugMAzLLsONWcvPoOHFsc1dZVkWW1suJNK5u94fisaet/aRmmUDY+xi+Ncih9ydbY8Cg2MeWye1oZPgrU+HzYDeSNJDKNvhBBYahGpXmd2RMxA/m4sGP+7dU8Elt5fPRh4DaZFgYrnMUKDpR4qRCZQkj8S2Tfm+CNtKzY15TmRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200841; c=relaxed/simple;
	bh=ZWN0xheg4BWYMMzGP/V4mL3/39EljUJxUpBMRx3BTQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AEEZv96ZzgIwVQJ1OKoNAMlVkCs7rpxJXbgjLdu0F25pPyQAE/emwgIdMHz+kHKs5lQVhLqRljIhjYhYi8d+DU7GnI5inyw3Go2qlzkcksoJKxMiJttDKEtimv9UY+0P7eZ74p21+aN4sheubdAUMtaxYdwlFG1817e88dumdn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2C3XFBuD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2C3XFBuD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279FC1F000FF;
	Sat, 12 Sep 2026 08:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200840;
	bh=eYz1x58i02Pa/jEOE7YHPGFS8fEjS3lbNZAjJ1MGg2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2C3XFBuDpRWcDUV6U44AUBqW+WBZU7hNCMaarrMq9XJiP+DJ64Vwtd9P1ndM02Ar1
	 OWuR+M9z/6BLeeMN0oVJuuawuC7na6kBpmQ4srXvGHQ2WqRl6WoZsyzMgm8VyvLoh4
	 KpKuAXiu737mdtUVfNFjToXOONA7zNqGlNKzyVQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stella Liu <yu-ching.liu@mediatek.com>,
	Jeremy Yu <chengwei.yu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0866/1815] wifi: mt76: add init_wiphy callback
Date: Sat, 12 Sep 2026 08:43:36 +0200
Message-ID: <20260912065709.253320810@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 4ee3d2a5f2cd5b6d0ba0d997913c1b763ef4d5c5 ]

Add an optional callback for drivers to finalize wiphy state after mt76
has initialized the supported bands and before registration.

Co-developed-by: Stella Liu <yu-ching.liu@mediatek.com>
Signed-off-by: Stella Liu <yu-ching.liu@mediatek.com>
Co-developed-by: Jeremy Yu <chengwei.yu@mediatek.com>
Signed-off-by: Jeremy Yu <chengwei.yu@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Link: https://patch.msgid.link/20260625001834.475094-7-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: 217f9e7bb025 ("wifi: mt76: mt792x: fix use-after-free in mt76_rx_poll_complete")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 7 +++++++
 drivers/net/wireless/mediatek/mt76/mt76.h     | 3 +++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 13c4e8abe2819..c4cbf7195b805 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -681,6 +681,7 @@ mt76_alloc_device(struct device *pdev, unsigned int size,
 	dev = hw->priv;
 	dev->hw = hw;
 	dev->dev = pdev;
+	dev->init_wiphy = NULL;
 	dev->drv = drv_ops;
 	dev->dma_dev = pdev;
 
@@ -779,6 +780,12 @@ int mt76_register_device(struct mt76_dev *dev, bool vht,
 	mt76_check_sband(&dev->phy, &phy->sband_5g, NL80211_BAND_5GHZ);
 	mt76_check_sband(&dev->phy, &phy->sband_6g, NL80211_BAND_6GHZ);
 
+	if (dev->init_wiphy) {
+		ret = dev->init_wiphy(dev);
+		if (ret)
+			return ret;
+	}
+
 	if (IS_ENABLED(CONFIG_MT76_LEDS)) {
 		ret = mt76_led_init(phy);
 		if (ret)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 0ecc5b0bff870..640061276d762 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -941,6 +941,9 @@ struct mt76_dev {
 	const struct mt76_bus_ops *bus;
 	const struct mt76_driver_ops *drv;
 	const struct mt76_mcu_ops *mcu_ops;
+
+	/* Optional callback to finalize wiphy state before registration. */
+	int (*init_wiphy)(struct mt76_dev *dev);
 	struct device *dev;
 	struct device *dma_dev;
 
-- 
2.53.0



