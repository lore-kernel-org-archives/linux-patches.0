Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC891DFD99;
	Wed,  6 Nov 2024 12:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895871; cv=none; b=cq7XYChzPxARpfUfBZc923doKAV1QJvUMqe0fzFNIEZljB6Gm9alcZxpkmAmATcbEMOVr8XvuaBqe7d5xIzZaiKpW4TIZvD/J+1EXOIIa7q+CtaHo+rQjvcE2qcyVTmydnqZyORlDw2bgTmsmc/n141At/C0sqHa0ivvAesDwjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895871; c=relaxed/simple;
	bh=rN8WtbEPISfdwh9J+lVWLb873TOuWDv9lg2vOdFEIZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ht6maUtaTdMa16ltwKUqEprby01RraHDZN2O/3Oh1Ee8e/zffrS5SLy8Hwv7zuKvMXXI1bI+SqV/vPbz3jIBiTCYV8qI7/2eDkj8MKGvBrBInNkw7FKoDcQCflsZ7UMiBHRBtS0USKakcFpRbLe/woI7QlyUUMzovM1NubxOVkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kP5BJFdF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kP5BJFdF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4FDC4CECD;
	Wed,  6 Nov 2024 12:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895871;
	bh=rN8WtbEPISfdwh9J+lVWLb873TOuWDv9lg2vOdFEIZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kP5BJFdFw770OITKLnE6vylHB30UpXDkme6+nljbQB/oH6p2mhVxF1f+TAagAfTEe
	 P3wDQuI8PdFoJuKJJ/BgF5Xr7Tz2bXZqo8FWG0+FEc+GaM2OJ1zzXNE3VerR96mnch
	 aGMw4tonswsRRPoNywh7vMGOTmGIPILy9z9bDEjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marcel=20Wei=C3=9Fenbach?= <mweissenbach@ignaz.org>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 013/245] wifi: rtw89: pci: early chips only enable 36-bit DMA on specific PCI hosts
Date: Wed,  6 Nov 2024 13:01:06 +0100
Message-ID: <20241106120319.568468721@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit aa70ff0945fea2ed14046273609d04725f222616 ]

The early chips including RTL8852A, RTL8851B, RTL8852B and RTL8852BT have
interoperability problems of 36-bit DMA with some PCI hosts. Rollback
to 32-bit DMA by default, and only enable 36-bit DMA for tested platforms.

Since all Intel platforms we have can work correctly, add the vendor ID to
white list. Otherwise, list vendor/device ID of bridge we have tested.

Fixes: 1fd4b3fe52ef ("wifi: rtw89: pci: support 36-bit PCI DMA address")
Reported-by: Marcel Weißenbach <mweissenbach@ignaz.org>
Closes: https://lore.kernel.org/linux-wireless/20240918073237.Horde.VLueh0_KaiDw-9asEEcdM84@ignaz.org/T/#m07c5694df1acb173a42e1a0bab7ac22bd231a2b8
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Tested-by: Marcel Weißenbach <mweissenbach@ignaz.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20240924021633.19861-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/pci.c | 48 ++++++++++++++++++++----
 1 file changed, 41 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/pci.c b/drivers/net/wireless/realtek/rtw89/pci.c
index 02afeb3acce46..5aef7fa378788 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -3026,24 +3026,54 @@ static void rtw89_pci_declaim_device(struct rtw89_dev *rtwdev,
 	pci_disable_device(pdev);
 }
 
-static void rtw89_pci_cfg_dac(struct rtw89_dev *rtwdev)
+static bool rtw89_pci_chip_is_manual_dac(struct rtw89_dev *rtwdev)
 {
-	struct rtw89_pci *rtwpci = (struct rtw89_pci *)rtwdev->priv;
 	const struct rtw89_chip_info *chip = rtwdev->chip;
 
-	if (!rtwpci->enable_dac)
-		return;
-
 	switch (chip->chip_id) {
 	case RTL8852A:
 	case RTL8852B:
 	case RTL8851B:
 	case RTL8852BT:
-		break;
+		return true;
 	default:
-		return;
+		return false;
+	}
+}
+
+static bool rtw89_pci_is_dac_compatible_bridge(struct rtw89_dev *rtwdev)
+{
+	struct rtw89_pci *rtwpci = (struct rtw89_pci *)rtwdev->priv;
+	struct pci_dev *bridge = pci_upstream_bridge(rtwpci->pdev);
+
+	if (!rtw89_pci_chip_is_manual_dac(rtwdev))
+		return true;
+
+	if (!bridge)
+		return false;
+
+	switch (bridge->vendor) {
+	case PCI_VENDOR_ID_INTEL:
+		return true;
+	case PCI_VENDOR_ID_ASMEDIA:
+		if (bridge->device == 0x2806)
+			return true;
+		break;
 	}
 
+	return false;
+}
+
+static void rtw89_pci_cfg_dac(struct rtw89_dev *rtwdev)
+{
+	struct rtw89_pci *rtwpci = (struct rtw89_pci *)rtwdev->priv;
+
+	if (!rtwpci->enable_dac)
+		return;
+
+	if (!rtw89_pci_chip_is_manual_dac(rtwdev))
+		return;
+
 	rtw89_pci_config_byte_set(rtwdev, RTW89_PCIE_L1_CTRL, RTW89_PCIE_BIT_EN_64BITS);
 }
 
@@ -3061,6 +3091,9 @@ static int rtw89_pci_setup_mapping(struct rtw89_dev *rtwdev,
 		goto err;
 	}
 
+	if (!rtw89_pci_is_dac_compatible_bridge(rtwdev))
+		goto no_dac;
+
 	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(36));
 	if (!ret) {
 		rtwpci->enable_dac = true;
@@ -3073,6 +3106,7 @@ static int rtw89_pci_setup_mapping(struct rtw89_dev *rtwdev,
 			goto err_release_regions;
 		}
 	}
+no_dac:
 
 	resource_len = pci_resource_len(pdev, bar_id);
 	rtwpci->mmap = pci_iomap(pdev, bar_id, resource_len);
-- 
2.43.0



