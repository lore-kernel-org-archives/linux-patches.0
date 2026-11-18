Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058434;
	b=HJ1/9ujpxt5B2sg7nfEZVdCk2mc/aerdgVZbjHf9tZ8fkLrQQGXaw9NYBwG/r6WJLQc8
	 4hK6Vm4HFMdWiithHZbpGYIT9PGItmrjAqCfEA7zsY4iNQJcI/0rVOluYk9jsI8YnIRE+
	 5Bkx7CvRh6coJOIZOhWSc1OmrU+n86CNlbC4O0Lc60NCY0Qv7KCEeiQpe4ewnEcQOcaSf
	 41zHEPgdKIkydAsA21DdkitWkfYqfg2tBZtXCPDpRy4qp7p7xdAOIx8Dn/GJmGUj1PA6/
	 8Vl3QPsdKdCwNYFTd9mfjK4y2WRsmwMgYoiAPCOqa3pG1xodRUXiaSfbw1zNdfZDuzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058434;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4zCh3MPpleioUJqxblt3NIcjbb6DZWhXu94AxCBdOP4=;
	b=0vL0RPguWGhqHIxHw8xESsmFRd84uscOqvikpd8Xy+ert86UHD18IzgUDhNA/hbq4+hR
	 WLpCwoOTFAO71kdx3JfJP81oVZdK70WtfkfwvSY59rQggqphg2WAMWj9Tjen0QFMuT42r
	 N1hfnCdIzSBAgVKMymQ4EZUfkKroaGJqAkv9siq/O6ATEVkE04fmvwCCkHTAHs16pNpL6
	 Y8SHDfU9prXItkCNpA9bDXRC82ioUJTPfN8WxVA5hij4k/n+k2MVjs8b5bx1eMRnsXcTL
	 kfasQnRq7QyM2Xf7SdX80jdxm5eMpHDyYVqtZdAt9PAarm6moXl7Yw6nyLj3IiaXDsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lwyPPkNB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3839B606A31C;
	Thu, 19 Nov 2026 03:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lwyPPkNB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6CA1F000C4;
	Thu, 19 Nov 2026 03:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058434;
	bh=4zCh3MPpleioUJqxblt3NIcjbb6DZWhXu94AxCBdOP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lwyPPkNBHzmyMeqbsuWxSbFB9oWeK6xeywc0XiGN0S4Ej3oAEkNixS+ARbxRiJgZn
	 R8N/9LAkbUtw/0FpfW/k9CDComrTAaMRrrCoDKpmWeCrRIJW2VCEsKIXu1nlJs5gv0
	 1ccZH8RcaAdkE2qGYjeHAt9bGGT7IMC8A20Bx350=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0482/1848] wifi: mt76: mt7615: cancel reset work during unregister
Date: Wed, 18 Nov 2026 15:42:00 +0100
Message-ID: <20261118145934.388268057@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 726e4781d9d9f..b9330464e85cc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
@@ -158,6 +158,7 @@ void mt7615_unregister_device(struct mt7615_dev *dev)
 	mcu_running = mt7615_wait_for_mcu_init(dev);
 
 	mt7615_unregister_ext_phy(dev);
+	cancel_work_sync(&dev->reset_work);
 	mt76_unregister_device(&dev->mt76);
 	if (mcu_running)
 		mt7615_mcu_exit(dev);
-- 
2.53.0



