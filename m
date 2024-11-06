Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A9F1E0B84;
	Wed,  6 Nov 2024 13:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898790; cv=none; b=iQT+Fp8lSc8Q59zTrIdzVMU6aUYh2IOQKQjGUjPznhhKXTbObr8zy/3xEv7LqnsQi0C6FJgOyhq8qF5cPSjNmiRqqRUFySMLE6fid3ULJIuWEHdAmlbQRXa6Wee4mOJThTMkAtkT5lrb9AcVyCTI8ECL7SOZUuMI4EXYL7FpJlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898790; c=relaxed/simple;
	bh=K+BqUetWhsJlxmwQeSQAWQPwwxgTdA/NgeHm6pxQrG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebUIicCT52+NLarmCMkSKmdETC++gU2bDRTdFUaWctmouBroal1ABelwbxU637uPKHJpyOS8VCA+u6crFfW07ewSD57QllMSXsJmVTvRriZcEfhhBAXCrmIWkcsi8ZOCZ7jKHuNZotpffgnUXU7pOw1G8yalEDJuxInqbK43tfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uaEJB8w8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uaEJB8w8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D08C4CECD;
	Wed,  6 Nov 2024 13:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898790;
	bh=K+BqUetWhsJlxmwQeSQAWQPwwxgTdA/NgeHm6pxQrG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uaEJB8w888j8R3bB7Dj1HHnewS78U36zRUAyrl0ROra7cndOfTMmhn6+MgMe4Tn9R
	 EYFmnSSMwbRBXWOzq0tYtfCuN3J9OokdwHBysFOpUKtWS4fVK4KXti/MTkI9Gj6JRU
	 nxd7sO6S5fxnNgEWkMOMd4UZqyahylYjaKoE0y4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SiyuLi <siyuli@glenfly.com>,
	WangYuli <wangyuli@uniontech.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 357/462] PCI: Add function 0 DMA alias quirk for Glenfly Arise chip
Date: Wed,  6 Nov 2024 13:04:10 +0100
Message-ID: <20241106120340.349225403@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WangYuli <wangyuli@uniontech.com>

commit 9246b487ab3c3b5993aae7552b7a4c541cc14a49 upstream.

Add DMA support for audio function of Glenfly Arise chip, which uses
Requester ID of function 0.

Link: https://lore.kernel.org/r/CA2BBD087345B6D1+20240823095708.3237375-1-wangyuli@uniontech.com
Signed-off-by: SiyuLi <siyuli@glenfly.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
[bhelgaas: lower-case hex to match local code, drop unused Device IDs]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c    |    4 ++++
 include/linux/pci_ids.h |    2 ++
 2 files changed, 6 insertions(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4138,6 +4138,10 @@ static void quirk_dma_func0_alias(struct
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_RICOH, 0xe832, quirk_dma_func0_alias);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_RICOH, 0xe476, quirk_dma_func0_alias);
 
+/* Some Glenfly chips use function 0 as the PCIe Requester ID for DMA */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_GLENFLY, 0x3d40, quirk_dma_func0_alias);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_GLENFLY, 0x3d41, quirk_dma_func0_alias);
+
 static void quirk_dma_func1_alias(struct pci_dev *dev)
 {
 	if (PCI_FUNC(dev->devfn) != 1)
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2654,6 +2654,8 @@
 #define PCI_DEVICE_ID_DCI_PCCOM8	0x0002
 #define PCI_DEVICE_ID_DCI_PCCOM2	0x0004
 
+#define PCI_VENDOR_ID_GLENFLY		0x6766
+
 #define PCI_VENDOR_ID_INTEL		0x8086
 #define PCI_DEVICE_ID_INTEL_EESSC	0x0008
 #define PCI_DEVICE_ID_INTEL_PXHD_0	0x0320


