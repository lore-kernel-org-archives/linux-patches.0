Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025908;
	b=lkw+WT5ch0JefdkoapYnsDeIq8fALSbVtf0r3Yg/ASQ5+I7/tU8eU0B2wHL5Zi297knv
	 5Cwjl1BfkPcfDUx9YVf3da/NQ3sEaWdRehHVB7HbQDdOmasEmgAJz4Ixzp62O+/a4rbxx
	 MWYjofY6VrmqKYrB7wmo+R7GGXJ8pTGkPuEnMxP7dZdMZqcFoRu2WFJhzjUkOlHvWIBzE
	 XxCS1ceDCg5LfyLernvFaRUJDIXTkDabJuTNeBuz2eQAi6utDxOdczs7uZ0nk6x2AOQnu
	 NOWiqrm7m8DFElbP+1wYHZur1IAP/Imgz1YsG6bY5tkwAkQaeqyAxhbB9xiHydo2jNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025908;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q0YljxBKsJuBE8syuVy82q4iQGlQLMum4NXCS4Zwmus=;
	b=M+6DBf8odMFzujpbzahtNyV7cXPSzSsK14CvZHpwh2DTptdtT5bzeErHa6QjO7tubP3p
	 hlFWLy8h+2zaziO1SAomEFg2V0WqPTA/iouaF/Pf3u5fwU5qVNyR6sWLrGuarOMQf5f3a
	 9YCdd4kbdIubdl0dY8y/Mb703bKT8qNbZylTAN+8gb4ixRXG7JGmfF88QNzZmKzjgYsFf
	 /dB0pU16wnurcmqyh2Yob3oAKiwtY657umrNO8cuU1WGp/3HHZaA717cmtk0DN0tPDN7i
	 NQXJE0Vciytdo1HMtZZEltYSZ2T/WnMQreFWWZYXE9UHZTUDXg3xzenUI428yUEHK3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N1aAmlAk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067AE606A31C;
	Wed, 18 Nov 2026 18:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N1aAmlAk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54EB31F000C4;
	Wed, 18 Nov 2026 18:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025907;
	bh=q0YljxBKsJuBE8syuVy82q4iQGlQLMum4NXCS4Zwmus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N1aAmlAk5eHbxrBlXvyvxJkCZt16JrjHDtdcsgEFutUhmoPhM9g+3icC4k2xp/FJB
	 GWD1MCfpcN4A7hJyFdFvYXioJCC/hVOyujNUpwgLbE2E2v83zd1LnqpT/WLNE3h/WJ
	 lhIfJRdtcXRur9l+MXXZV5TWfesFcXu5f7c/o8sw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1204/2151] wifi: mt76: mt7925: restore the reset state when fw_pmctrl fails
Date: Wed, 18 Nov 2026 15:48:59 +0100
Message-ID: <20261118150206.062562936@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 8d2f5990cd429a2fe5fff05f7acf84d6799d4324 ]

mt7925e_mac_reset() returns directly when mt792xe_mcu_fw_pmctrl()
fails, leaving MT76_RESET set and the TX worker parked. Every other
error path jumps to out, which clears both. mt7925_mac_reset_work()
clears neither, so once every reset attempt fails there, TX stays
blocked until another reset succeeds.

Jump to out instead.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Link: https://patch.msgid.link/20260827162115.1449757-1-nbd@nbd.name
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
index 0ad733e4b8902..3266542b1711c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
@@ -125,7 +125,7 @@ int mt7925e_mac_reset(struct mt792x_dev *dev)
 
 	err = mt792xe_mcu_fw_pmctrl(dev);
 	if (err)
-		return err;
+		goto out;
 
 	err = __mt792xe_mcu_drv_pmctrl(dev);
 	if (err)
-- 
2.53.0



