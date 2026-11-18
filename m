Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031146;
	b=lYly7OkuWNWmnCUPSaRvcpvGVGlQFl7qRh+TH+zm6qK2YRPfWm4urx6DXkqDPHJIuYcG
	 18X9Nf93FKkbkoTk0HXnj2RQgO4DCWURO4v4owYuj2pvji3YaZIw8I8LTvKIB9KIq73un
	 YgX2SyfjFSTQ2cJ555vjQmL+gXPIJ2BQckQWqDTFESKzoKjKVDAgmQQVEpsWfht7iCiK0
	 aneXtcvF7lxa6lWrYNe6JocwGHY/9vGCC9zC8OHEqg7lsGeq2oQdPTPrNLdh2KQpc43fG
	 l9aqjxPcKcf5bpHCYlIuVu/W1O/ZtPcoQmgGpXjks3wKH/NBXYUT8wCvM3ipGCzMzug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031146;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WkNmdEU/n4CQVzhl8DN2Ew1fJtvOr1ZUOV1x+lLJxKo=;
	b=jJUPJ/Y9B914oYO/Q0y0oYUsJkJumotOTIh5aBQW0DXRjnDBBIfu9uHdbIj69+zwO9z9
	 FAXTAFO4O8qK2BsnMJkUyKspUM4wQ0C7kwUOwMSFBdsPuk7liN7ifVw+mNUzRZs+Iejjp
	 5R5AR0JJ7TSE9ydTcuS0cvVIbxi4xSM45hfou1M1dLYNvVYYOCW4pLV9VZQjHWYOI9kHn
	 xojfevTpn36T32cwNdDTVnkhbQpf/f66ZsF2IeO+c0dmnQmvq4C8QAACkBm+wUGAEn4/L
	 IS7JzLne1AngxzT/jyEgmWFly03GnsWrr4G10TdzivLTZ4Y8qDu9n+suIDUGWdRZxag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wY0WuLcv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A26606A32A;
	Wed, 18 Nov 2026 19:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wY0WuLcv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70FFB1F000C4;
	Wed, 18 Nov 2026 19:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031146;
	bh=WkNmdEU/n4CQVzhl8DN2Ew1fJtvOr1ZUOV1x+lLJxKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wY0WuLcvs5n8EkYOeHhIrXLdpaHMANXF1go1w/flcJD9TYLc79aKdgacWrivVEznI
	 gSYvn0Y/E54wGbTxdjCBoVVmYvNq8ILD04K64eovhoOdhZ7G8JsRsfug5t3new9nWk
	 FIl3wekZ7bybBv7tq0BHv7jLlUH/ft7jwdnkHWwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	moosager <moosager90@gmail.com>,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0954/1756] wifi: mt76: mt7921: check drv_pmctrl return in the PCIe reset path
Date: Wed, 18 Nov 2026 15:51:21 +0100
Message-ID: <20261118150048.059289785@linuxfoundation.org>
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
index 2452b1a2d1187..d38cc0d90d2d7 100644
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



