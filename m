Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6694E1C729E;
	Mon, 14 Oct 2024 15:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919780; cv=none; b=TOc+YQF7p2o1YiLM/ib7KtBzSCQpaVzpYYZF6Mxhsxhk2mO6d1Vctek3+xkWoFZ2IfSFDgjTLPkkz3mT8gkucq8z7Lw9p7yn+d15lgkuSmd2690HfBmPVdNM4nVgsIlzZRj2fvI2Wew2KM+CQXXBZhRtl0c9PkQLormFq1bCCe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919780; c=relaxed/simple;
	bh=iuQswb5u+R6omW/wqo1hHeaE85h/cAwK40KshFuQwBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2n6SLRzJ2DpKrcZ5DHGZRrCGeIBd1f864wNihJulzT5PQgZS/KZuYakt86qQHsykc+8VqTiCkP+R6x8ZswWecqh0Q+a8BlCR5zHN4Ucga2gtjA9rBeaIPi8qO2HhGUEhgmavyB06SCzLl1LQqYip2Z7GXN4cGhP1oSV84pomuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sS3W1aES; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sS3W1aES"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 700A0C4CEC3;
	Mon, 14 Oct 2024 15:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919779;
	bh=iuQswb5u+R6omW/wqo1hHeaE85h/cAwK40KshFuQwBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sS3W1aESA8HiYZU/8/h2xf4ftC/ONnBlO1Wl/Jak+jxcu8/iNHsXWB6Th5J0y5wr5
	 4Gx9dBWtM9C7RZwVNnzkw138E81gW9Ilo9GteCb/2xmU0lx3yMXmwtUI5vqJF/8EXa
	 0eXL/gjbOKCBOScWUoTyssrpjkilaxh5EoLoqtc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SiyuLi <siyuli@glenfly.com>,
	WangYuli <wangyuli@uniontech.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 697/798] PCI: Add function 0 DMA alias quirk for Glenfly Arise chip
Date: Mon, 14 Oct 2024 16:20:51 +0200
Message-ID: <20241014141245.451620357@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 56dce858a6934..7ebce76778f71 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4144,6 +4144,10 @@ static void quirk_dma_func0_alias(struct pci_dev *dev)
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
index f680897794fa2..69b8c46a42ea7 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2638,6 +2638,8 @@
 #define PCI_DEVICE_ID_DCI_PCCOM8	0x0002
 #define PCI_DEVICE_ID_DCI_PCCOM2	0x0004
 
+#define PCI_VENDOR_ID_GLENFLY		0x6766
+
 #define PCI_VENDOR_ID_INTEL		0x8086
 #define PCI_DEVICE_ID_INTEL_EESSC	0x0008
 #define PCI_DEVICE_ID_INTEL_PXHD_0	0x0320
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index a26f2a2d44cf2..b8d769b2d0f9a 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2748,7 +2748,7 @@ static const struct pci_device_id azx_ids[] = {
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



