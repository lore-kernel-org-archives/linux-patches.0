Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036355;
	b=YyGWwyaheLpo3xBDENROtdX4/1fuqe5I9AOYIpmPnztTHjLjUWPs2QOvSUzPR140Nx8f
	 VLGkVSk+OWSAzM5KPgBeyuCHQTUbhgPsI4av7/oW0O8iKwzFWMikGnM0fYE9C/696hhPI
	 Wqq1NoxNC3S34UWoX9MrJQ1fDppDh+BqZ3Pl+rxLJP/t4CWKBGoYsjAa4tPozbynjvXnM
	 HdGDPGiND2nmLWMN3cDhb3BfnGeaBui9ZCqi7/bQBPcdKun6cCTTTs9tSS97C5+ks6BAo
	 5GRj38Kb2vMOBS0GZfxsuJMpkOYnJN0UavFM7aOO3Vvd7cuMETUGgCJ5z2hxI//jqyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036355;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ph0OSNby88FgcRzW9/P2z4rB63kyO6CIlXJSrOpa6mc=;
	b=v91V55pDR9SxzghP6WbbCwnN1T9dtnV/sIPHrtE7OD58K8XF4QKZlVS9/Ju6NxbForCr
	 VFMqbopXmSKYbj5/oodroSms36sfX0XR2I++7GZbNt6qPYye1VjhDp2joJFAPq2brEPBZ
	 5uXv8GS5B94zjxYhQF83S1SDjX8ZJM30YzNAU4B0jX/RDk002lT2V5abHNdeMckceBRi1
	 NUWJfYUV9vFv/Ju4xR+0Jel6b53/t1IomdFUzoMnHxU9WR6fDzOqSJDVBxwtD3hOlf/Uc
	 /2etyVyLNmU4QSqlKkHJqG/7L7czLGXfLZNjndemHm1xUw2wm8DdRuD4f3Kcxdutuhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kq4sl2ty;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DE9606A332;
	Wed, 18 Nov 2026 21:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kq4sl2ty
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304481F000C5;
	Wed, 18 Nov 2026 21:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036355;
	bh=Ph0OSNby88FgcRzW9/P2z4rB63kyO6CIlXJSrOpa6mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kq4sl2tyECuQne2aXM5zIpPLVAxwvn3XLPrlFCC3vppRf7/cGtud3hmTZSiN+Zpuo
	 YJpeiWA7CbnB5uWe9u9uiOjCT97wBtvkqKldtMfAdEurQMsOY3eWqVJ2Pv+Tmca4JR
	 5x1IN6PI0jIcexw7rfwSqnxDzTfE4zj80PXjIB7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1031/3318] wifi: mt76: mt7615: cancel reset work during unregister
Date: Wed, 18 Nov 2026 15:27:33 +0100
Message-ID: <20261118150350.819847927@linuxfoundation.org>
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



