Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064519;
	b=bIt0nysNuJrvRLxnhl7iS6ro85hrEtPyUjHVHZTqha4BNZHT0t7SJhUFvILDGhZsTxK1
	 4LoyqfL4yIN3Vu9C6MhYCo/+6pd+5JvzL14wgYjsiV/B3Zd4vW0ZrPQtA5p7UzP9r9sth
	 MPQog7pTNKsJD67RMalIVonJ0zjrGpni0q9XlbFjhfiKHGYrqhU0Z9ie3/BtaP32hdLAF
	 iItdpjveTwrbsYlP1BRittnNkZHpQFbQRC1Lqpf87S6/hkusT24KwTioMFB3LfRdEV7mp
	 V9oFhuaIM6BJhFzDt0pPY/v4mcQMtnSmXfW/l6TdpNJrzyLO3oF6T3JwAqHajYFvyWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064519;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p6w39Z+gynt7C4DzX02EyskaTMoCdL+JSv1Ve2j+YZI=;
	b=bXUXeXB8zzR4c1auet8cwtGDVKDZSishnAognCvLsUNka/aJJzzmDi1WDglCXELhPS+u
	 KmUJ5yVopB3kRePKdtpHGnS9kHucHbLS7p6RmVvG5DBWFpb5RIuHQCMD0nXztsc0Sa2op
	 gUM11+sHRfhiRbLs+xUD/0SwWbysazWQYc+BxKSmGMX/qWpY6tefKOy8TXNB5DFsq5/rU
	 Ew9/xsZfX/kfpKnxSCcZykz07aOI5a3Q2qQ1RA+grYXIy2VDjKCgl3/qxj0VO3ICHDNaZ
	 nN2PTZtP2e3dChD9ENlls98BSZ5v1qcr+lERgu/RQmINWDLlViTntT++QGgZscgDwxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PQRPIVoF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92596606A32F;
	Sat,  7 Nov 2026 15:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PQRPIVoF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4198C1F0089F;
	Sat,  7 Nov 2026 15:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064519;
	bh=p6w39Z+gynt7C4DzX02EyskaTMoCdL+JSv1Ve2j+YZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PQRPIVoFjBBCVWsUlpF7Jd3bdlNMG/sD40Q3UMlfQYflav8hDny94wLeb2ey4xXUu
	 YIWLNfo3aAPF0QGSsf3aoYMlG0cN7LRwrvOua90c+7aTRww5Nd+J0HY2MFaVZAfddJ
	 lRu0EvWsP7qS9Hu5k+30HOQIg3cs3p1QRqWfsm5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0543/1257] wifi: mt76: mt7615: cancel reset work during unregister
Date: Sat,  7 Nov 2026 08:47:19 -0500
Message-ID: <20261107134954.396305256@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 5b779c63fb1e20e6729d3241b78be7502759296d ]

The MCU error interrupt handler queues reset_work on the device workqueue.
Device removal can reach mt76_unregister_device() while that work is still
pending, since the workqueue is not destroyed until mt76_free_device().

If reset_work runs in this window, it operates on an unregistered hw and
can requeue mac_work after ieee80211_unregister_hw() has torn the device
down. Cancel it before unregistering the device so it cannot outlive the
registered hw.

Fixes: 61c4fa721968 ("mt76: mt7615: implement hardware reset support")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260927101041.957362-1-yaojiale02@163.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
index a9178e077fd6d..7d8580720cd88 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
@@ -116,6 +116,7 @@ void mt7615_unregister_device(struct mt7615_dev *dev)
 	mcu_running = mt7615_wait_for_mcu_init(dev);
 
 	mt7615_unregister_ext_phy(dev);
+	cancel_work_sync(&dev->reset_work);
 	mt76_unregister_device(&dev->mt76);
 	if (mcu_running)
 		mt7615_mcu_exit(dev);
-- 
2.53.0



