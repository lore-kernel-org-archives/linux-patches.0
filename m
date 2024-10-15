Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354C01FC7C8;
	Tue, 15 Oct 2024 13:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998366; cv=none; b=cqzdl5jf1jXeOKDj3BdbQxd/TMRQcnLa1fcQI2JzBUvJjXwab/AQz3Inko8piDQPAwPgd0xcBEx/Ut8MDDXBWjIl7GnTNTbk7JThuc5rQ+5Ksv2Dq2s0rl47kGK7ag/S5uqbnIx0UxZOuRm5yMg7LPCjFSWI8lK5Xa4+nNWw/WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998366; c=relaxed/simple;
	bh=EmYzvp9dz5UpyayDYKn7BWs3yFsH/HW0wtvutsMDzbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMPOLmbfdo7N+CtU1yHkDEZEgbEDSMg+UGjIAi7md5ZYSzaE2opEhncI6fSvslw/3wZnv5PrEitbMEf8UvRLp0scwVOmukHmf53dmoaClOOCjbMDmFbZ+BXBQXM1LoZkIBchpuyfRSpGdSrAjlomPn27Vte8gkHhJY4fuqbUKL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UNvLSTxg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNvLSTxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E39C4CEC6;
	Tue, 15 Oct 2024 13:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998366;
	bh=EmYzvp9dz5UpyayDYKn7BWs3yFsH/HW0wtvutsMDzbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UNvLSTxgMRG1GWlNKQ+inQ7gJ5qapR3vrbLKKxpTHxwiT5fjpVzOizrkbJIMM2Dd/
	 asWiauvo3/KcXGDMQqLbuZtD7pl0jFV3wcG2Ey27hF1k2E+NgTOtKnsIz1WLT6vp7V
	 Ya72XOPW4eTmuCTLmOR2ZDa1D3M9oB9b14Xoq1tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SiyuLi <siyuli@glenfly.com>,
	WangYuli <wangyuli@uniontech.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 456/518] PCI: Add function 0 DMA alias quirk for Glenfly Arise chip
Date: Tue, 15 Oct 2024 14:46:00 +0200
Message-ID: <20241015123934.606332540@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 60a469bdc7e3e..6f782734bb6e6 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4092,6 +4092,10 @@ static void quirk_dma_func0_alias(struct pci_dev *dev)
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
index b2418bfda4a98..c4ad85bf9897f 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2657,6 +2657,8 @@
 #define PCI_DEVICE_ID_DCI_PCCOM8	0x0002
 #define PCI_DEVICE_ID_DCI_PCCOM2	0x0004
 
+#define PCI_VENDOR_ID_GLENFLY		0x6766
+
 #define PCI_VENDOR_ID_INTEL		0x8086
 #define PCI_DEVICE_ID_INTEL_EESSC	0x0008
 #define PCI_DEVICE_ID_INTEL_PXHD_0	0x0320
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index a3c6a5eeba3a4..b92095bb28c32 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2777,7 +2777,7 @@ static const struct pci_device_id azx_ids[] = {
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



