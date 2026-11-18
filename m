Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045497;
	b=tSdS8b11t5b3TI3a+s6C6HLBZwYz+2E6qRQl7BSeiU22ugs4ci9i60O2IYixLPcsMNCL
	 bhcCUB42TE8SjTmyD1Iw2O07FKNGevq+oXPB7PEXDPnmIi2EBBiEx8xALlyOMF9mY01HV
	 LA6RH64drnkDxARY4A5oS5YjRtlpIt+Sn4O7/gNpE3z/JOKaepWJlP6hlO3Cda4MYJIwW
	 RhxF4OoGKC6yJY8p/KrHRYTkYONYPiOKv6DzT2cMSyzvVetuvvQQ8zTxTH3losBVTAfuH
	 6+J2hhvQBzfAO5WBYkP81bb8y1wFuHzDha1950I0CTCBTS8VCMaSkRsWLLObA+2pOug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045497;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=frUitSx59cE0ZWIyIzr0OgLyE/zI5OuYZJxXYwRMKzU=;
	b=JAhzuhRRzXIiHnY+yhhChE1ERC/nl0UXgJ9Kee6/glM94XQQlyLT4ep56GvnTanFvpKo
	 fSKtGUfNI3eBaVTEOug/B3j25xThJAOlyZMIyZTotLz1pzq92foINUf0eERCAKnAqoyOB
	 JhuVbC064jo98sh2QrZlfaq2J0j1py/su6KA9+OcX9WSyJJEYDIxms/DOTaR11ErbutwY
	 GCMMYA2hT7EaUtXsVYXYNz0G86ND3wOPsHt+r50GhuEeF08IwW2QomOOaDaNU+TE11rIv
	 ZgLVeoM7/9GgKBNVOT7mswx6BMxzuWQxBx/gHgoyzu1pelb3ZhprpwG+VPA4Y4jyfQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iJnjEVZ3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7EE606A32C;
	Wed, 18 Nov 2026 23:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iJnjEVZ3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E0C1F000C4;
	Wed, 18 Nov 2026 23:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045497;
	bh=frUitSx59cE0ZWIyIzr0OgLyE/zI5OuYZJxXYwRMKzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iJnjEVZ3f0+6j4stHNVooz30I3/rMK0HyiR5bPh4flHXWCuyc+yJQlTlR/6oYNjte
	 knR53nmQhEAwOLPVKoju4OGviIDvYohAYdhGSeZGg/NcC98jBMQOddQzGJa5dKEGkb
	 kcpuJT7QDYVh2XEa/f8AWHVMC+5K7CR5zJpBJCFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0895/2857] wifi: mt76: mt7615: cancel reset work during unregister
Date: Wed, 18 Nov 2026 15:32:09 +0100
Message-ID: <20261118150233.783479627@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



