Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064561;
	b=iP+fqScacC7VrpBpQt0iBKgUp9ehhOeSUsZWWM4mrBNfSiXgjBL1hH014EDEWFZEqVbu
	 2Q+UwFq65m7aEsEswniI0m7qX+H+j5rYSHVTCVYle6703sSj58mb8YCqMGxVKsGtsefo+
	 BUQb6aGg5F5yN04vaOfVL+Cpr47gDvzUlrMAZ40S21s5aoQnalR0zo2SizesqXiXWyV8u
	 QDgRsg7t1T+bB6B413Q804VT1mMlsy9joejY+p2tlxbyOAIjfbhqc1oz/ZsP0kv42MNlT
	 L+z9P29bhduamTFO+wQLJ9H7VU57NHNbs/SnnD/pHm5n2YRyd/3T1lhRqTVy2xHqsAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064561;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/OxtmUffmO+miIur8OdqJXAQAuOwPYBcMNTMJzG/Vgc=;
	b=aHOM6cvacunWzQwC6ICNI1+Q5JYQtPSdJHz/uE5uycDOy0rYDESwhm6fSfXl69DfLXk0
	 5nV0oj7nD9C17jnypvHeQI6oqxXKqQgwyOykqgzizF95uesMCNE3QXxGu1OnDMEjSEGsn
	 Vi/eLCRYOTw18nJnWEwbYeeS9EY6XxZQkNJZEmGNgfFznY0XQro6KO6og5kWOMEUQahJt
	 wrhPZaQE0pGU2ttghjkIWES3AAbXTC/UHeQKCcdC3kfDC3oygZTTpbdiNTFX/pAL/cbkK
	 iDDQ9UNVr2cQodkRRXAwp+nyE3pwaTK8oBcY8HDoo7cAZbJzbCiWaUsAk58Ngy3Ki5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="UFU/0P2S";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261EB606A32D;
	Sat,  7 Nov 2026 15:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UFU/0P2S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89F81F0089F;
	Sat,  7 Nov 2026 15:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064561;
	bh=/OxtmUffmO+miIur8OdqJXAQAuOwPYBcMNTMJzG/Vgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UFU/0P2SWZ5X7OgufyeLJP8GhzIVbl6NfqzZtQwdE/fJmgE8/WPr77YGFQ4g8iY9x
	 ImKdpg+qlBrq6yw1hJGcF8dm5/e+t9xa6ueTpyf7CoaG91lIpGX4tBWMfXD4kqixS+
	 BSaJjEpBs94ZSMcEyv1O8hVNpFtpNy7oIdsUwBsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linlin Yang <yanglinlin@kylinos.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0546/1257] wifi: mt76: mt7996: fix PCI device reference leak in mt7996_pci_init_hif2()
Date: Sat,  7 Nov 2026 08:47:22 -0500
Message-ID: <20261107134954.477957240@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Linlin Yang <yanglinlin@kylinos.cn>

[ Upstream commit d92bac6b6af2602516ee82ae112709c71af27cf6 ]

pci_get_device() increments the reference count on the returned
struct pci_dev. In mt7996_pci_init_hif2(), three pci_get_device()
calls are made but their return values are only checked for NULL
and then discarded. pci_dev_put() is never called, causing a PCI
device reference count leak.

Fix this by storing the return value and calling pci_dev_put()
before returning, following the same pattern already used in the
sibling driver mt7915/pci.c.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Cc: stable@vger.kernel.org
Signed-off-by: Linlin Yang <yanglinlin@kylinos.cn>
Link: https://patch.msgid.link/20260824092937.683240-1-yanglinlin@kylinos.cn
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/pci.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/pci.c b/drivers/net/wireless/mediatek/mt76/mt7996/pci.c
index b7d9193e042f4..a7c23b33dde0b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/pci.c
@@ -63,12 +63,18 @@ static void mt7996_put_hif2(struct mt7996_hif *hif)
 
 static struct mt7996_hif *mt7996_pci_init_hif2(struct pci_dev *pdev)
 {
+	struct pci_dev *tmp_pdev;
+
 	hif_idx++;
 
-	if (!pci_get_device(PCI_VENDOR_ID_MEDIATEK, MT7996_DEVICE_ID_2, NULL) &&
-	    !pci_get_device(PCI_VENDOR_ID_MEDIATEK, MT7992_DEVICE_ID_2, NULL) &&
-	    !pci_get_device(PCI_VENDOR_ID_MEDIATEK, MT7990_DEVICE_ID_2, NULL))
+	tmp_pdev = pci_get_device(PCI_VENDOR_ID_MEDIATEK, MT7996_DEVICE_ID_2, NULL);
+	if (!tmp_pdev)
+		tmp_pdev = pci_get_device(PCI_VENDOR_ID_MEDIATEK, MT7992_DEVICE_ID_2, NULL);
+	if (!tmp_pdev)
+		tmp_pdev = pci_get_device(PCI_VENDOR_ID_MEDIATEK, MT7990_DEVICE_ID_2, NULL);
+	if (!tmp_pdev)
 		return NULL;
+	pci_dev_put(tmp_pdev);
 
 	writel(hif_idx | MT_PCIE_RECOG_ID_SEM,
 	       pcim_iomap_table(pdev)[0] + MT_PCIE_RECOG_ID);
-- 
2.53.0



