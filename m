Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B111A76AC;
	Mon, 14 Oct 2024 14:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916020; cv=none; b=fq/vYgJV2s1j3qvbUOt2tMDo0Kv3/PaaRjvDK8K/+gHBBbCzWPNT3MtMflMEhh3VYhTKVyQp1CnVPqMyHdrUuAXGXVt6V8SIIdnXfsdbkSi5skqihn8ZbO6kNAgzfzlSs6hxbfnyMvmtRt+ZWO67oWoiWywbeW/1cX8tcteB1IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916020; c=relaxed/simple;
	bh=W4bSkz29ZSI98doBeIRnQWf0/8jDyp6+Ka6UbKfPimw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OH/5F28udCAF9VA9dbrn/FwIA5bydqY/Xbk35H1w+AxDpCdc/A3Fc6KfhTQlfV10RdzeM+AjE5LpNnAPA7l7V/Ofi9PmOh3pYQkd9iSj9q9ZIb2oIZnDgubBs3z8M1cJ/1EbVyP8062FpZBv/IM1UFfPDXEEZ0h8G0WKyTLIgVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F7rmKtdB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F7rmKtdB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C8DC4CEC3;
	Mon, 14 Oct 2024 14:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916020;
	bh=W4bSkz29ZSI98doBeIRnQWf0/8jDyp6+Ka6UbKfPimw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F7rmKtdBE0nZW/3kWLy1v9Y2ul+PMZlwAGVD19tumNMDuO4dFuyU0s8h4KfFXK0Jy
	 EshmlYMtDmOzVJdeP3KRZjrVxdoWGz0fueePMv5DapATs5IzWyBCLZaHTNq3VvP35g
	 Z2Nj7TVNBMoMYqoRYnfRnemEPA9POsxVvab6+IT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SiyuLi <siyuli@glenfly.com>,
	WangYuli <wangyuli@uniontech.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 031/214] PCI: Add function 0 DMA alias quirk for Glenfly Arise chip
Date: Mon, 14 Oct 2024 16:18:14 +0200
Message-ID: <20241014141046.204169528@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WangYuli <wangyuli@uniontech.com>

[ Upstream commit 9246b487ab3c3b5993aae7552b7a4c541cc14a49 ]

Add DMA support for audio function of Glenfly Arise chip, which uses
Requester ID of function 0.

Link: https://lore.kernel.org/r/CA2BBD087345B6D1+20240823095708.3237375-1-wangyuli@uniontech.com
Signed-off-by: SiyuLi <siyuli@glenfly.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
[bhelgaas: lower-case hex to match local code, drop unused Device IDs]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c      | 4 ++++
 include/linux/pci_ids.h   | 2 ++
 sound/pci/hda/hda_intel.c | 2 +-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 5d57ea27dbc42..979901a0e1f97 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4259,6 +4259,10 @@ static void quirk_dma_func0_alias(struct pci_dev *dev)
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_RICOH, 0xe832, quirk_dma_func0_alias);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_RICOH, 0xe476, quirk_dma_func0_alias);
 
+/* Some Glenfly chips use function 0 as the PCIe Requester ID for DMA */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_GLENFLY, 0x3d40, quirk_dma_func0_alias);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_GLENFLY, 0x3d41, quirk_dma_func0_alias);
+
 static void quirk_dma_func1_alias(struct pci_dev *dev)
 {
 	if (PCI_FUNC(dev->devfn) != 1)
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index e388c8b1cbc27..2c94d4004dd50 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2661,6 +2661,8 @@
 #define PCI_DEVICE_ID_DCI_PCCOM8	0x0002
 #define PCI_DEVICE_ID_DCI_PCCOM2	0x0004
 
+#define PCI_VENDOR_ID_GLENFLY		0x6766
+
 #define PCI_VENDOR_ID_INTEL		0x8086
 #define PCI_DEVICE_ID_INTEL_EESSC	0x0008
 #define PCI_DEVICE_ID_INTEL_HDA_CML_LP	0x02c8
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index b33602e64d174..e8958a4646476 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2671,7 +2671,7 @@ static const struct pci_device_id azx_ids[] = {
 	  .driver_data = AZX_DRIVER_ATIHDMI_NS | AZX_DCAPS_PRESET_ATI_HDMI_NS |
 	  AZX_DCAPS_PM_RUNTIME },
 	/* GLENFLY */
-	{ PCI_DEVICE(0x6766, PCI_ANY_ID),
+	{ PCI_DEVICE(PCI_VENDOR_ID_GLENFLY, PCI_ANY_ID),
 	  .class = PCI_CLASS_MULTIMEDIA_HD_AUDIO << 8,
 	  .class_mask = 0xffffff,
 	  .driver_data = AZX_DRIVER_GFHDMI | AZX_DCAPS_POSFIX_LPIB |
-- 
2.43.0



