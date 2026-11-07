Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063186;
	b=GzjB3SBf7ccRpwzHdUNMVRqkncW/py8kIqHvlYzyQ0xH26Lk8fgUjdJKIYlpiHTuuv3n
	 Izk2jXZGwE2omyCAdkSAbLaxGSRnpn4a40iz8UpP/w0AOmkqQdeVMZ/48/ywfHOmgdUnO
	 F4WrcAFXay3WlcOIadjNCZpvGz+Cma9bCFp2zqQCLuQ59ahA3PiDuQb25EAytmGm/5d1N
	 GoxaueiomTxpWy+uxiIdfZG7Jf+99sK5Sdwh/i1wIfe7gHqVFJIStaSuIE2KDo9xfbaNt
	 wdTdNzredb0QqqBoCw+/gBez3OpwLtOyVjp0sbe8lsR4yqPyalmhsS6hytJ41H9UeRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063186;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eTGtqTZMoWfvIx02fpb8EuJuPm52cMN5NllatlQAfm8=;
	b=ETPFalst4slf/LdRAth4UnD/aQRQVUOh7OFt/OuR19cPjZou/uBWJoLr+WjXhHgZjmIJ
	 6/TMTy1521zAHF2vnYZnvqY3HHxYzhXEo2FRiwMw+jW8jk7FcwBwNg1VykRsH4iwyojWi
	 cNA1lsxGL97PW64oiAx3IUHtyZG2JL5UovAOOQZ4ywVXqPzs+X2QHEBhUJKNIkk4iLcu0
	 hOYHrzPwMAtO65Vw5p8wopiVWzxShyqdx5+vD3Fs6Cht2ClYx4uXBgvfyT8+OoDxRiiRw
	 5cPQ0EGRubO72b69JG7MtmsoCl1A4nK/ysCm1wytcEVnTSEh0qRKlSUJPROR+L8fX3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sS5+CWfh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D422606A330;
	Sat,  7 Nov 2026 14:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sS5+CWfh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12EDA1F0089F;
	Sat,  7 Nov 2026 14:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063186;
	bh=eTGtqTZMoWfvIx02fpb8EuJuPm52cMN5NllatlQAfm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sS5+CWfhRIPCk6Ky85zdYGvq+ECOip0QJju7N+rTuo+utZUhTd+x0sop1+1cXIxHf
	 V0+tEXt3o9JEAa+TsFOFQmJIUfi9KdJjmmurOe9/aNojQUmGN232qX0kyz5jRZ5Mqx
	 q9T7ql7Oa/+x7W/U9wmn5qqXnHE7Fi7r/EzWiV4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 403/869] wifi: mt76: mt7615: cancel reset work during unregister
Date: Sat,  7 Nov 2026 08:51:25 -0500
Message-ID: <20261107134907.041552248@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index f607eee3fb479..5e09f43926e02 100644
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



