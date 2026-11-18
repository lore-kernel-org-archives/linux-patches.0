Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025902;
	b=EHYQYiXy88mALOKctHnhmKsWXWLHeOfyNaztmwlPHAfvGDqO2wxgKZ1EV+XXfpbx6PiK
	 2199lC6BHNI3gn1OfqIzpOZ2f2cZoRHqqSvTfJmOTvv83U7h4NKVSHPDZFFLO/c303rAv
	 Ot6zxSDPiEQIvjp1dlYHGsn0Zw2wsirk2uXJOHPnTeeVGW1ilnEA1w+mHRqeNdPbBUOYG
	 NNr/2Z/sq0lUFPB71TIiQf4eWfIshNd9NXulQfcAncNcymlfikthRsMw1kkTrmnEsmyHi
	 skom4xN11yJGOB7Pk6tYmTaQ89q9qNxonWclyYRD2MduZ+Tn3gSQndDgQpbImwJEFlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025902;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wAbyib5YQZGt1J0vCnvTi8pHNwNV+f9FpaixJoiadLc=;
	b=LeB4MKGszMvJ3bUlcr9FUdkwoLaEbul233PK++Mrt8HJMThoJAwFxFC/8Fhef+Rq4401
	 0kh6lRtsm1OSZQ5sSvtnAkv+DiEt+7xkvTtckH5aAY8YW+sw6+l32qwYgP++66Ew1yHDE
	 E6fVf7M9wEkD7p+ZlAuMJlPdBLx4IUSgsWxT5gfnK0lDsqK9Lc0/INfo4OsreNkkDM6gU
	 IExm+A/eOXw90likxdc8VwPOYDyMpFst9mOQpB0oZFLErcqrc0fcTxZ1NBCvY8C9fshAk
	 RQoMJNJWlIbDRcMjkCgacdqkyvb+RekiRy6yTeBu5PMcXMggtQYSZyLoMnzB6k9U5YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="2MAuiEQ/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2B8606A31C;
	Wed, 18 Nov 2026 18:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2MAuiEQ/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25B71F000C5;
	Wed, 18 Nov 2026 18:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025902;
	bh=wAbyib5YQZGt1J0vCnvTi8pHNwNV+f9FpaixJoiadLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2MAuiEQ/rSzEMjDjoE4Mh/w66MgsxhfdPS2wX9TxBiU606M1P//wA18nELM+dy92a
	 80z2nzH4KlAKgW2YJpQ6ImZGpu9Jt1B5L1M6Vk2PDb2kshPBO/30KIIpqBuEoY/X8Y
	 WsIaX1ZwhCWxEMvbxOh5sQwBpvMaA/Md0ef3HIEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	moosager <moosager90@gmail.com>,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1202/2151] wifi: mt76: mt7921: check drv_pmctrl return in the PCIe reset path
Date: Wed, 18 Nov 2026 15:48:57 +0100
Message-ID: <20261118150205.993296381@linuxfoundation.org>
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
index 881812ba03ffa..49a03544b3bb0 100644
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



