Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025905;
	b=CIXitAStasuTgRTYLdT7O2JZNwbe5F7eUfs1coa/5mHGl0/cpBkZY9S2he+uhQQUe+ez
	 R3Zfiq2O6i+PADZCos7aJqPVBxAfdtiyB0BHlMJU9mOO2VfNQfVAgCKbykr9t42u5PxlG
	 21Ig6ZOSM1z6tKmT6rB8HSiMekkp+ZD2u4YvteRELv9Z3Jx+0pxQyQe9uW+c6Io0kFP+T
	 rqkPIjbmN++VMHyhKR0IzqGutu/Om1MYOd5yby+bKSs5tA3k+o+39DL84xLls7/PTQ/yP
	 jknHLez636kV6u0+ZW2f+ROapKtRPcRoUE8f59aRD4b35enDJjfUxaeQCiPK5q9IVjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025905;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A5T4v5WFB3vEMDBjPYfhBTFPNbXNEDTiaoUfbJst9as=;
	b=PSLpTs0L9SqBbtueUh2Tw7bfIHXkd1TJ/qf/mwBilxg7U6ix60KBeimd5XT96JgpfKi2
	 zNiQz3zPoWSBMGSga3xMSI4urS0P2QUPMf4PHbbwG3YwldT7tn8tCaivNaqXtVg1pNQP/
	 tMmT5WLQRg0LBFwudXknaGjhe5HWo2461Z98MLzcff9PdUXnJpmvpfPw9fl6XlFIr2HBo
	 VSp5ZT4T2aaKBzNduSSWNeDKbFdDcyBnVZDC5PZA9T/TY4DYR82oKKDT47np27a5pjeDM
	 r/y792DkjQ6wMnSuD7JqBoAGFYOoI4W/Lwk6plKR958c7mqT4l1bO32ORF+j7mEtkqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aA0MwZ9Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75925606A32A;
	Wed, 18 Nov 2026 18:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aA0MwZ9Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F8F1F000C5;
	Wed, 18 Nov 2026 18:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025905;
	bh=A5T4v5WFB3vEMDBjPYfhBTFPNbXNEDTiaoUfbJst9as=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aA0MwZ9QhqqJvCkBfifxdKNFrIUrBmthmtv//f+3KdVXHLOdZJAC8vDrsdOaNl1EP
	 YD0NjoL7FR3wtmCGokTqz/20+3mr9M3/4DGUW47qA5F4MH1dW+pWkqCajZim+fHUPZ
	 uKkM8pQKH4V29b14TcSFNgCrgNdRtmgnDqaDdwf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1203/2151] wifi: mt76: mt7925: check drv_pmctrl return in the PCIe reset path
Date: Wed, 18 Nov 2026 15:48:58 +0100
Message-ID: <20261118150206.028223947@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 4578d16bf456a..0ad733e4b8902 100644
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



