Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564ED1A0DF2;
	Thu,  6 Jun 2024 14:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683176; cv=none; b=KcGhEny69ABXFDO6qZfCQjEOlbtcuZlL92dABZzm5xiEA9OzzHw6NUyydMtlWDNhpq8RRHZnvsSYbZI26AA+AsaPZ/Qs3Rr58w6EAry003Zq+fsTKj1bus9huz8+9S/RDWoSxEH7UWuXEZzL7EMe4epwYSS3ptGhI/xnCm2BzW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683176; c=relaxed/simple;
	bh=6g6zosU4+dIMUvNsB3MVF+X3bBxrFUYe1CxBgc/Mb3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6nK0gI0b1xXJE3DmomNK1Kawoo8PxwphJREoUfJAJNdsSDGJeeZ5chrAHTstmnN0oIL4BT7yYBE7bSDHZ8LfgohHciYXHz6duIkj4P6nfiEm0CwdSHqG2r2eC93TeXkzcbVq5f/IBo7jL6cAx5gwU01wO7h3bAb8x+8iSdccwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1wJDmYhn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1wJDmYhn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35587C32781;
	Thu,  6 Jun 2024 14:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683176;
	bh=6g6zosU4+dIMUvNsB3MVF+X3bBxrFUYe1CxBgc/Mb3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1wJDmYhntXfEuLObqMJ2KHmQKctOHgCtg/OkE1vo9JvY4ShVF8UU3FNNt7irp+1U6
	 jKDtK23UDdutzKKTLOW9lYOH6q3ne6xijoErgA0J6WkSLOkxaN9RMajWggl+uPiRUT
	 J23lrpmbPEUNBGOMZlMKZ/jQZsBIsuMy8AbrHBgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Colberg <peter.colberg@intel.com>,
	Matthew Gerlach <matthew.gerlach@linux.intel.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 051/473] fpga: dfl-pci: add PCI subdevice ID for Intel D5005 card
Date: Thu,  6 Jun 2024 15:59:40 +0200
Message-ID: <20240606131701.563165339@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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
index 0914e7328b1a5..4220ef00a555e 100644
--- a/drivers/fpga/dfl-pci.c
+++ b/drivers/fpga/dfl-pci.c
@@ -79,6 +79,7 @@ static void cci_pci_free_irq(struct pci_dev *pcidev)
 #define PCIE_DEVICE_ID_SILICOM_PAC_N5011	0x1001
 #define PCIE_DEVICE_ID_INTEL_DFL		0xbcce
 /* PCI Subdevice ID for PCIE_DEVICE_ID_INTEL_DFL */
+#define PCIE_SUBDEVICE_ID_INTEL_D5005		0x138d
 #define PCIE_SUBDEVICE_ID_INTEL_N6000		0x1770
 #define PCIE_SUBDEVICE_ID_INTEL_N6001		0x1771
 #define PCIE_SUBDEVICE_ID_INTEL_C6100		0x17d4
@@ -102,6 +103,8 @@ static struct pci_device_id cci_pcie_id_tbl[] = {
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



