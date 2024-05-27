Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F127315FCE9;
	Mon, 27 May 2024 19:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837758; cv=none; b=erQTfzWNAeYXNE/S5OtZRY9Oa6h+is/qqij+HOoDGpurPPLMzgIB5mLHEHlXIKlTquTuS9pDS7oX3cgxYrqyXOgHaBgnwRi9Tuh8dHNabBZ9W2QDj8RZi8vgUxRszl8Li0fmlfcI8wlB3repK3KGm8hZC8Qa1vRXT5lLLRYu3uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837758; c=relaxed/simple;
	bh=NcM+f1zhOT5KOulgixBMqXhfk0I1LbhbH7kvrQTqcvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9G6/oDVq4EEZjeNIU1Ae/GOJahe0+FTToqBPDAZDE1QG12cweARBEDqA93qM2EiaU7F8+jHdjNwOUMoLzSLSpNB4yrWYqMYS+szM4NJu+BeR0l2pPSXEsy7N+c3EtlfoVGynzT88HTzMIfCCVe6z5ugEp99lv4716qMqzBW0k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z6kATTkg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z6kATTkg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8848DC2BBFC;
	Mon, 27 May 2024 19:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837757;
	bh=NcM+f1zhOT5KOulgixBMqXhfk0I1LbhbH7kvrQTqcvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z6kATTkgAtJ8hoNEfIMHRwwBWqDDx1P6Q5pFytA31/VN/3IxonDfbNykGeoPSwojS
	 f11JIchNb1N9BeYF/Tbpb1Wg/xHLDSDjp8jqWy5omkKK8TnnthJ25AOKxpP9X3aGsG
	 DV46Jsj4+xO8nOcbLrUjpsXrjLfdbcu0OBfFOz20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Colberg <peter.colberg@intel.com>,
	Matthew Gerlach <matthew.gerlach@linux.intel.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 083/493] fpga: dfl-pci: add PCI subdevice ID for Intel D5005 card
Date: Mon, 27 May 2024 20:51:25 +0200
Message-ID: <20240527185632.938190159@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Colberg <peter.colberg@intel.com>

[ Upstream commit bb1dbeceb1c20cfd81271e1bd69892ebd1ee38e0 ]

Add PCI subdevice ID for the Intel D5005 Stratix 10 FPGA card as
used with the Open FPGA Stack (OFS) FPGA Interface Manager (FIM).

Unlike the Intel D5005 PAC FIM which exposed a separate PCI device ID,
the OFS FIM reuses the same device ID for all DFL-based FPGA cards
and differentiates on the subdevice ID. The subdevice ID values were
chosen as the numeric part of the FPGA card names in hexadecimal.

Signed-off-by: Peter Colberg <peter.colberg@intel.com>
Reviewed-by: Matthew Gerlach <matthew.gerlach@linux.intel.com>
Acked-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/20240422230257.1959-1-peter.colberg@intel.com
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fpga/dfl-pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/fpga/dfl-pci.c b/drivers/fpga/dfl-pci.c
index 98b8fd16183e4..80cac3a5f9767 100644
--- a/drivers/fpga/dfl-pci.c
+++ b/drivers/fpga/dfl-pci.c
@@ -78,6 +78,7 @@ static void cci_pci_free_irq(struct pci_dev *pcidev)
 #define PCIE_DEVICE_ID_SILICOM_PAC_N5011	0x1001
 #define PCIE_DEVICE_ID_INTEL_DFL		0xbcce
 /* PCI Subdevice ID for PCIE_DEVICE_ID_INTEL_DFL */
+#define PCIE_SUBDEVICE_ID_INTEL_D5005		0x138d
 #define PCIE_SUBDEVICE_ID_INTEL_N6000		0x1770
 #define PCIE_SUBDEVICE_ID_INTEL_N6001		0x1771
 #define PCIE_SUBDEVICE_ID_INTEL_C6100		0x17d4
@@ -101,6 +102,8 @@ static struct pci_device_id cci_pcie_id_tbl[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_INTEL_PAC_D5005_VF),},
 	{PCI_DEVICE(PCI_VENDOR_ID_SILICOM_DENMARK, PCIE_DEVICE_ID_SILICOM_PAC_N5010),},
 	{PCI_DEVICE(PCI_VENDOR_ID_SILICOM_DENMARK, PCIE_DEVICE_ID_SILICOM_PAC_N5011),},
+	{PCI_DEVICE_SUB(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_INTEL_DFL,
+			PCI_VENDOR_ID_INTEL, PCIE_SUBDEVICE_ID_INTEL_D5005),},
 	{PCI_DEVICE_SUB(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_INTEL_DFL,
 			PCI_VENDOR_ID_INTEL, PCIE_SUBDEVICE_ID_INTEL_N6000),},
 	{PCI_DEVICE_SUB(PCI_VENDOR_ID_INTEL, PCIE_DEVICE_ID_INTEL_DFL_VF,
-- 
2.43.0



