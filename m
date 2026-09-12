Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AD9429000;
	Sat, 12 Sep 2026 12:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216756; cv=none; b=hIWnaLEhz8rfheFfYmzRtOmZ3vfQ5Pyw1wujwhkwuBlX0nxW8pfljrq1w/L+ewZLJYdO+1itiQeA1Zy4zzg7gOsUMBzZFn3d1L8ZjMhz6YiUm8JQsjPMado41AplkDpjRtn1SrAhUX8w1Fm9Dd/ZoLtXRKgxji4FlbHQbG+VBc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216756; c=relaxed/simple;
	bh=0GWnhWJQ71FmTYUL3SYZ6BdvuvRTcM1861JNvCzeDhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/DcB99FXgPCRsCj7bDLI+pUu7qpjQ1gD3HlEpc4PsR9LUafZpAaQ5zWrbZDcKrPASTLc0zqN1E5v3fV6RE521djFXvlABW+H//PO+nLmO+WnhclAoMrVUKYNIT71jJupsM3vB8IBpaO/7WUA/D5PhQQJo+ENOXUfidEz15M+9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H9wKjP6G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H9wKjP6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55E51F000FF;
	Sat, 12 Sep 2026 12:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216754;
	bh=kgVklsgsmBWaXerrdNRk3z1OX+kv3CNgG4g8DAqGOAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H9wKjP6GmvLiRRfsHdfV2qHZnzXRkbIofoZT+y/yOBCove63yxmetbSAzw7Sh18Y4
	 smcGnv0MtEKEOs5tzqkksz6Y5ECfr6KETZziVqrPaG2IOCrgOd9aFd+3+CAoOYwRMn
	 p2LEgk4rY4g27fwLo4Y4PiZU+rhGOX7TrTd5xvBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stella Liu <yu-ching.liu@mediatek.com>,
	Jeremy Yu <chengwei.yu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0802/1376] wifi: mt76: add init_wiphy callback
Date: Sat, 12 Sep 2026 08:53:48 +0200
Message-ID: <20260912065625.408238993@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e538bb36a7309..e1856664ca5d1 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -644,6 +644,7 @@ mt76_alloc_device(struct device *pdev, unsigned int size,
 	dev = hw->priv;
 	dev->hw = hw;
 	dev->dev = pdev;
+	dev->init_wiphy = NULL;
 	dev->drv = drv_ops;
 	dev->dma_dev = pdev;
 
@@ -740,6 +741,12 @@ int mt76_register_device(struct mt76_dev *dev, bool vht,
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
index e7ebae0584f55..daa78f52c15ea 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -845,6 +845,9 @@ struct mt76_dev {
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



