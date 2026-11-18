Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031148;
	b=ZHaJekzTxAtG4w8cm0NNdnArCe/Pe3f1p3fH8as6fSMlwdRicw7OvQ+q/tvGVJ0vGwl6
	 PEHF5DHKu0HJZIosPsQiW+w0+CbuJvhWEbLdxKQyhI4O5UJbGO/iSXHGjg5y83veT4Foz
	 MFLHH4bhOwdEcSRU6Mgi7DLLYPeenlRR5E9dscdJu4Zw8qbdtugUJsdyteKBU7S/wBGdk
	 Pubo/DqlFIVP0rVsz0rmm5xzbqIBHO+9lB8/ifH9R50K5rMYl6MojHhrpjAHimOw2SUkD
	 fcmIkJnUPStuNslbI7QjCTTvqLGZrQaCJ5SZLcmdgC6Z09X+H5tBx5MgSnj4wKkuDqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031148;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pwzUjjLgccKbpVxMZi/cdXjBPQPRWtxBmNoHNQ9vzt0=;
	b=ZkdwdPicIa4LPZDzblwsJbiP78UThWKhJvNqhxWC/0hqUKGNVmWkzys685GIlG6k+rfl
	 H2kCTOuaQVxCDhvjm5wixOVvtQFzDzK4mT2Wa4RDV9G0C6ZduK5LGnBijtCHoXZARrtYX
	 4m1WBEt/XJmdZFWlpHSJcm7Rr6yoJs4sygvoK40qtbxaRoedMHJbMriyD5Ei/fYJOiLgI
	 6NtX5aJGnyjIVNVOMCr0G1Oi8UUF8tkln7K5v/9fu/55PbRnHQrK2KgcpnlrZKGKWpJFH
	 ZZxCHLMXfFg0hK63MSWC39jhKT5BcEC9NSSVacbJR5ebdklNAYTPwDO0YbfpMA7a0zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HboDqcZC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34E7606A337;
	Wed, 18 Nov 2026 19:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HboDqcZC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B23C1F000D4;
	Wed, 18 Nov 2026 19:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031148;
	bh=pwzUjjLgccKbpVxMZi/cdXjBPQPRWtxBmNoHNQ9vzt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HboDqcZCoZGbBJbIBippHFy3YjcX7S8xqt5e2Xmp8lb1IORyC+n8OKxgRnoQn/CDQ
	 cYfd951wjIGcf9MQ9C0dVVw0jT+8Prpe8FUrICS/Vq83vW1LTZQ/9LFLEswdYSYw15
	 txMMAlI5sSPvtxdIK2iPClockloVcueUI5+B9ubU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0955/1756] wifi: mt76: mt7925: check drv_pmctrl return in the PCIe reset path
Date: Wed, 18 Nov 2026 15:51:22 +0100
Message-ID: <20261118150048.093004600@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devin Wittmayer <lucid_duck@justthetip.ca>

[ Upstream commit d12a54be2604ecd23a1e9ac863583e34034aadde ]

mt7925e_mac_reset() ignores the return value of
mt792xe_mcu_drv_pmctrl(), unlike the two pmctrl calls later in the same
function. When the driver-own handshake fails,
__mt792xe_mcu_drv_pmctrl() returns -EIO without reinitialising WPDMA or
clearing MT76_STATE_PM, and the reset carries on: it writes the
interrupt enable registers, cycles NAPI, resets WPDMA and calls
mt7925_run_firmware() on a chip the driver does not own.

Return the error instead. The call is the first statement in the
function, before MT76_RESET is set and before the TX worker and NAPI
are disabled, so nothing needs unwinding.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20260809205559.32116-1-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
index faedbf766d1a0..4587bf849a354 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
@@ -72,7 +72,9 @@ int mt7925e_mac_reset(struct mt792x_dev *dev)
 	const struct mt792x_irq_map *irq_map = dev->irq_map;
 	int i, err;
 
-	mt792xe_mcu_drv_pmctrl(dev);
+	err = mt792xe_mcu_drv_pmctrl(dev);
+	if (err)
+		return err;
 
 	mt76_connac_free_pending_tx_skbs(&dev->pm, NULL);
 
-- 
2.53.0



