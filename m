Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018993;
	b=pfz4qLw4JXYXYiHfqEFsWM4JfMdJdUZrVtO4NEjNUSXcAlqqGVkNTJ0cwGIdiw7rATj4
	 pkluu91hEKJlHc3A9h/iUSNF5ZX5notmNxSMkltH12p3iMe1IV/NFs8G49ZH0cOAPGszm
	 44Danqjwqak+kx/DZcHxDmBupNNmy9wmaw/cq7lv/s/eDNaWlh44WPWYAAXqKzw8HSuGE
	 /s1xl3WDQdHv7rALV5liREqt5JtemZPu9IJV3eqC2oDncCIPFhj3f+T3JVUnEIdKRhtvr
	 a7W3spvCX1dL1F0HYsCaYmVGdz0sY7IKTGxt0TXubYDyEWIEcBJcKujnYzDvtnSnZxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018993;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zmd4qvoJUA1yBAfiYXj+BoT2xWzwUG9b8y/YUsfxuXs=;
	b=obHVJzFjMlLa/U0xwU1x09BD1dvtRLKz6YNXPvsL8uVzP7rbd3b4cI1U5F55oaee8NzM
	 q9cW9YpmJYhKF1uq8ymO98zr90lOmAzaYq7VenpU/lLYm78YVaXVNHCPPjw02Kc2z2k2r
	 tp4UW1lvEU8fYdXY5FcZ+HGzlD0ujlu6CceWVYQBcC2KTOloXDtr2u1ExMW1b1vM31/GT
	 mWFaqJSINZ0Fqhec8QsGL96BtnkPEB3efAF0ddTnl0sNbL/pdeGKEUgc6nd2EY215PdQQ
	 qtCUdvUKDsivS42MPm1R1SBTmds9hXGDzU580Lw5oDBTz/bolfoQWGhXJwrCMAk8UqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aDKAsugN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DE6606A31C;
	Wed, 18 Nov 2026 16:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aDKAsugN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FD41F000C5;
	Wed, 18 Nov 2026 16:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018993;
	bh=zmd4qvoJUA1yBAfiYXj+BoT2xWzwUG9b8y/YUsfxuXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aDKAsugN4iotx6UzvuDzt87mQ9+VlLu6tTIhMueN0EqAC+mHtGfIWore7CVW/vyRi
	 /N4Y8ZF2ZkQHDdzbsLXFCfETJ8tjKUvzTxkIYBqp5MA29EksU4i4XdeSD/D2tSW92h
	 YnOm1tPYVHL5D5LwN2FkwUkjj/eFeRB1oyRXPCdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	moosager <moosager90@gmail.com>,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1435/2651] wifi: mt76: mt7921: check drv_pmctrl return in the PCIe reset path
Date: Wed, 18 Nov 2026 15:44:35 +0100
Message-ID: <20261118150339.715413442@linuxfoundation.org>
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

[ Upstream commit 75673ab3c0e4186628e0a76b94443cddfbeca255 ]

mt7921e_mac_reset() ignores the return value of
mt792xe_mcu_drv_pmctrl(). When the driver-own handshake fails,
__mt792xe_mcu_drv_pmctrl() returns -EIO without reinitialising WPDMA or
clearing MT76_STATE_PM, and the reset carries on: it writes the
interrupt enable registers, cycles NAPI, resets WPDMA and downloads
firmware to a chip the driver does not own.

Return the error instead. The call is the first statement in the
function, before any teardown, so nothing needs unwinding.

Reported-by: moosager <moosager90@gmail.com>
Link: https://lore.kernel.org/linux-wireless/anG46qbvCqCHGF-f@fedora.fritz.box/
Fixes: dfc7743de1eb ("mt76: mt7921: refactor mcu.c to be bus independent")
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Tested-by: moosager <moosager90@gmail.com>
Link: https://patch.msgid.link/20260809012309.43657-1-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c
index 98b3469ac5976..d5c33a0d409cc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c
@@ -57,7 +57,9 @@ int mt7921e_mac_reset(struct mt792x_dev *dev)
 {
 	int i, err;
 
-	mt792xe_mcu_drv_pmctrl(dev);
+	err = mt792xe_mcu_drv_pmctrl(dev);
+	if (err)
+		return err;
 
 	mt76_connac_free_pending_tx_skbs(&dev->pm, NULL);
 
-- 
2.53.0



