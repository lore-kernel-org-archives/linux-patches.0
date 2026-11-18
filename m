Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019071;
	b=v8g47x7WK0YBWlx5t3PiGFApmezNhBw4spHdrs1liBIc4NVz+bPSIT81jIijq6fz9zPL
	 FxdSFY3s5e0Sy4LNQUjhYy+mLWPX8MH3BEjNwbWRGcHY3r9crulM4SDFcrBZu9aAfeEAH
	 VX5Ssi2UmCT+B65tfOOXztRqPKK5eprawQBceM4fW98FjHoEonXmrQGNo/tx8tb/8Nwvo
	 g2B9tAEey1lmyl0OJsJzLHr7kpNMUi5nwmqTcux7cGSnek6zTZd3xIIuMhek9tzRFyPfI
	 IIT3LwuhDUYEf8qEzyyJo3rYEqWtPH6q/ceLB+7dS5FphLyIy7Y95uOhBT9YLgymeNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019071;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=10ZikdcjMmaicGHU7V78fSL0cy5eJ8H1gJZ4pv2c2Gk=;
	b=kI3jSlrsmWfsBzC5Vrdpnl9RmAziFFqxOFaaZwrOK7w04h5TIe3REnf3xUN0xa+Hd0vC
	 07b2Jcu0uEkRiKfB0W98CqsKridueQoBAW2UbJZCS4XWI5ySpgIfcHN6zeJRvjblOXsiI
	 L445wxhAVWZRAA55SJGaN8u3i+TYcAvrBP6Ve5luVd3MiXMgxuQ3Yq7Ts+eKTGXAjdjUn
	 gKxDmm4UJcnM7ZQ2eoYcvtsqO0ByaJQ9Nqz7U6vStt7dIZm2adza9+c6Doby+waaoWuEJ
	 GBUTUNk8YeL/PrPpIWq4JAlFVvLkwHGqrZkAbhSgx4k51mYYZgcxnRjs0SXEDJmM6Qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="S4TdzEr/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BF360A3809;
	Wed, 18 Nov 2026 16:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S4TdzEr/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B51701F000CA;
	Wed, 18 Nov 2026 16:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019071;
	bh=10ZikdcjMmaicGHU7V78fSL0cy5eJ8H1gJZ4pv2c2Gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S4TdzEr/w4WskoalMxWAYu5E+lKnCDSr+12pSg8P5RbjuV5Mec/ZUwLVo/qdgdaTU
	 YvDSf779o19ov/V8QmPqspdO9ajhHfUTPu0zLwWv9uBqpO85c844PTL9P4EE/vDydO
	 oEySUswMfDAfLm1hVlq9AvbHK+7fzioW3ggRZyjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Eason Lai <eason.lai@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1465/2651] wifi: mt76: mt7925: Fix MCU command timeouts during module unload
Date: Wed, 18 Nov 2026 15:45:05 +0100
Message-ID: <20261118150340.778274935@linuxfoundation.org>
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

From: Eason Lai <eason.lai@mediatek.com>

[ Upstream commit 79941e85f4b3b1385b545cf18998fda6e1176919 ]

Move MT76_REMOVED flag setting from mt7925_pci_remove() to after
mt76_unregister_device() completes. Setting it too early causes
mt792x_irq_handler() to drop MCU completion interrupts, timing out
teardown commands (scan abort, BSS_INFO_UPDATE, etc).

The flag must still be set before napi_disable() to prevent reset_work
from re-enabling NAPI and causing deadlock. Also guard mt792x_reset()
to skip queuing work when device is removed.

With nothing associated it still costs 9 to 10 seconds, so a bare rmmod
does reach this, just small enough there to read as normal teardown.

Fixes: eb628006a2c6 ("wifi: mt76: mt7925: Fix unregister deadlock")
Tested-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Signed-off-by: Eason Lai <eason.lai@mediatek.com>
Link: https://patch.msgid.link/20260817052840.99478-1-eason.lai@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/pci.c | 4 ++--
 drivers/net/wireless/mediatek/mt76/mt792x_mac.c | 3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
index 76d8f8ea19ecd..12c1f7868d915 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
@@ -47,9 +47,10 @@ static void mt7925e_unregister_device(struct mt792x_dev *dev)
 	if (dev->phy.chip_cap & MT792x_CHIP_CAP_WF_RF_PIN_CTRL_EVT_EN)
 		wiphy_rfkill_stop_polling(hw->wiphy);
 
-	cancel_work_sync(&dev->reset_work);
 	cancel_work_sync(&dev->init_work);
 	mt76_unregister_device(&dev->mt76);
+	set_bit(MT76_REMOVED, &dev->mphy.state);
+	cancel_work_sync(&dev->reset_work);
 	mt76_for_each_q_rx(&dev->mt76, i)
 		napi_disable(&dev->mt76.napi[i]);
 	cancel_delayed_work_sync(&pm->ps_work);
@@ -725,7 +726,6 @@ static void mt7925_pci_remove(struct pci_dev *pdev)
 	struct mt76_dev *mdev = pci_get_drvdata(pdev);
 	struct mt792x_dev *dev = container_of(mdev, struct mt792x_dev, mt76);
 
-	set_bit(MT76_REMOVED, &mdev->phy.state);
 	mt7925e_unregister_device(dev);
 	devm_free_irq(&pdev->dev, pdev->irq, dev);
 	mt76_free_device(&dev->mt76);
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_mac.c b/drivers/net/wireless/mediatek/mt76/mt792x_mac.c
index 888e5a5056731..1e20b333cc612 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_mac.c
@@ -278,6 +278,9 @@ void mt792x_reset(struct mt76_dev *mdev)
 	if (pm->suspended)
 		return;
 
+	if (test_bit(MT76_REMOVED, &mdev->phy.state))
+		return;
+
 	queue_work(dev->mt76.wq, &dev->reset_work);
 }
 EXPORT_SYMBOL_GPL(mt792x_reset);
-- 
2.53.0



