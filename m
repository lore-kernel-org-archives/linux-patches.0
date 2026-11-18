Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019135;
	b=YJzcfGxgO/mHXAnF+0NvdCdkyayQFr0dWsfJxPS+T3q+5dEqqiRnqNidEmmlKvPfUOTW
	 5VwR6wVCnn+sCFjlc+p90EdKKsdD//AQzarxJ48e94Ozc8VpnyymXeG0Te6b5wwYn4hef
	 58T7N2aSoCLn3B+IluI8QvyKvKZe6uopsZ7yoBDpWGREEkLBclOJKETK8B0DASCz94+Jy
	 Eb0a52je12evX58V1usD5cs108z6IvwQEx5xSy3SiEu01dELD6xTrU3BwZJFAf3IhK4zz
	 dS2nVhWlc1PxTQvlhKBnStTA3JaxXT0h56517jBawvDbQLEHJcPzQZPJuXKL9E+HDZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019135;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wYSl3oYcm/mui5Wzzvb+i06NCL7zHyyFN40XJTsHuMM=;
	b=gn9Sn5kX26i5cMt3gbEavHejcWFRDDYfJdjmJUDrx6xLJQsZLQOKCgdWVOH0wFvNeojU
	 eeI85sbAUukke34s5QwzcJq36ZJlU9RFGl3jJbVv5PdUuQqsPCp1JxODfmsgl3DSYiR1C
	 9/BSyR3gWHdDw8rkMZOE+FIoFEnASd3GvvetmaFNN/mjC+F8MZNic/vSollLMkatS3cde
	 sRnz228rVjxJv+8BDpiZ0ebFDC7rrYc+ayPUVwCu7KScmynhdJqxbJc2TpgBMfisN+yTU
	 udgJ37ymx75BBPXq+43zXniAhiG+X9TFsIGMqaYHbZrvuaiFQ2wy5vt25skoCbyJaFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EnNRy2Ww;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09E7606A31C;
	Wed, 18 Nov 2026 16:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EnNRy2Ww
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0004A1F000C4;
	Wed, 18 Nov 2026 16:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019135;
	bh=wYSl3oYcm/mui5Wzzvb+i06NCL7zHyyFN40XJTsHuMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EnNRy2WwTCa/NRAZddwIpvsrWuawlS3j+7G3aFJ1Nnrd08xSjGUqbxDjzxHg6G+zb
	 gEHmc596Rmv91FDelT4+WpDwb0MzI29ixzZfNer5YH97wvXgSttZzB3cwq3r64RbsW
	 f6HALG91/U09juTOXolrXlkX4UTFWAUA1avKR1sE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1436/2651] wifi: mt76: mt7925: check drv_pmctrl return in the PCIe reset path
Date: Wed, 18 Nov 2026 15:44:36 +0100
Message-ID: <20261118150339.752325168@linuxfoundation.org>
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
index 8477d21abc660..280797fa0d85f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
@@ -73,7 +73,9 @@ int mt7925e_mac_reset(struct mt792x_dev *dev)
 	const struct mt792x_irq_map *irq_map = dev->irq_map;
 	int i, err;
 
-	mt792xe_mcu_drv_pmctrl(dev);
+	err = mt792xe_mcu_drv_pmctrl(dev);
+	if (err)
+		return err;
 
 	mt76_connac_free_pending_tx_skbs(&dev->pm, NULL);
 
-- 
2.53.0



