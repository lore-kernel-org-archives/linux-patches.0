Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052513;
	b=gYlibhIyp6Py0+H/KQjsIKYup+ikKb/UZY3KLbsBYHUUBDmGkGqjasqE0fWGgPeT7XLo
	 lTp1r1M8v4HccEBJoUBCFAL797e4/9dZ3NysW8dfplMAxLgSL0zy3QFqfpEPHE4f8qGNW
	 LQFjSAns6nFtthA8/2l/Mx85zaSKaniOZHtfuVMg3/gK2oLFdVpf7/UsrLKo0LSN9gcSN
	 2tS1diy57dchbsxqWLGNzd83DB5FECgF2FEj+7A/3g18bWtrViToNguKD5Hc/1Lq4ZzDm
	 9dWmVwfRV0JuxUlR3EhEXmQiggxCbF885QfV8PxDKiXyfBaALpQ5Okzwfb8gSgNTVIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052513;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LKnSuev52vo37BCXkMTkuzWJsb2g7O1gQbIc4ScR2pg=;
	b=3t0/ryKmBJq1KSLJZDPssuyxTlWb+kyzSSBHIXiXfvMA0k6QBcXJXueTMTYL8DcrYgIh
	 nzLkioIzAzV7MzWKkVMB5W/qzvDrvWEwL2WFCGkh74hefndITW42TZRJ1a9AQa1MP7Gtm
	 0yC0XIuWrQ7Y1JFM3vdWTngtK1ZebZMfpxMhJv7pxb//vzZmzRwXXfPCbpOuAu/aexmF8
	 WuM4CXfLwDG543NRNlCdnn7W9cc8SPBFxQmBQB1ojxvbnWHuhv9na3iqJQb1SsgArt21B
	 Ogm+ThgZoHMyly06AtM9b+mbN4qOzTsaZNyA5AB9W+JaTDdY/7XM8GP6YO2KjxfxwvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wrv3J4xJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3CC606A325;
	Thu, 19 Nov 2026 01:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wrv3J4xJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170A11F000C4;
	Thu, 19 Nov 2026 01:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052513;
	bh=LKnSuev52vo37BCXkMTkuzWJsb2g7O1gQbIc4ScR2pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wrv3J4xJHi8T5FG+mdGueqpv047AjsfFwzoirUXNQyAXIRm9IUVgn7Z5/h0BLa5/a
	 w38m7AXUU2FMwAnDhxGCJWi33BQdjT3evDragdJWpnBoKEN5qkcCCkR9i7kpMGadns
	 KkC02e6syXvIznYocHwjttdwZwIyqtV69lIUggRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0592/2214] wifi: mt76: mt7615: cancel reset work during unregister
Date: Wed, 18 Nov 2026 15:37:48 +0100
Message-ID: <20261118150034.575221131@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 87b4aa52ee0f9..d8cb621cad241 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
@@ -174,6 +174,7 @@ void mt7615_unregister_device(struct mt7615_dev *dev)
 	mcu_running = mt7615_wait_for_mcu_init(dev);
 
 	mt7615_unregister_ext_phy(dev);
+	cancel_work_sync(&dev->reset_work);
 	mt76_unregister_device(&dev->mt76);
 	if (mcu_running)
 		mt7615_mcu_exit(dev);
-- 
2.53.0



