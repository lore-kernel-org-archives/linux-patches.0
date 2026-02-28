Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F283446B0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302113; cv=none; b=kf11dLtvHrOhANSen994Ir4kvQH9fOC0e8V+ZcW+BLJLJk6ygT8ej1kI5+3V8XF7ZAxG4Tb/qGP+NL7JH9uIeEPetvRkr5dg8K1SwuJJAeWRzxI/PTuVxT+DGLRXKeDWrCNWetbjU/l+oIGVlLg6sY1fGE/zOQUGjxSaZ/T7/tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302113; c=relaxed/simple;
	bh=upUxefAx9M2FmuJTpNBZXyRbOVveWh18PS6aFNYgo6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FymY1sFgmu96QTvXzyuALGvjs6Twef3lW/KgpuCaiksLtGGe9XfCEXbU0yVsBKIcVZopxBp/Yh+sh71N/PGk8wDyJMLU/9d6Pk+ISvmHOVj3FIba3IPqsbCsvC8Nl3mT69xbXjGYWprhKdcV7R3ZZhYJZAkkeWkHwcT36hMC1cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tESrSR2t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tESrSR2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB359C116D0;
	Sat, 28 Feb 2026 18:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302113;
	bh=upUxefAx9M2FmuJTpNBZXyRbOVveWh18PS6aFNYgo6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tESrSR2tjDd6I0tTCPjRaHIUDNFM1njxpdHNeFh/IECG7LDLCaQWA+crr2w9puMOl
	 AdD/Em6OueNbv36RF1pzSC2vhbcSrHZa9upJYtCVtBYTrz+B31gUl7ICuTNOciqTS9
	 PZCrITtnXGuJx8u7QJmW8aBGtAi9kbK51hYTVOiV2FdMSjeb4TKdB9Ao+Kz9Z3l98A
	 xJLlS0yM3mo2cdGTT+scfI/vCzHgYx7vMYAbOai/jNFXpdKWVmsn8G7VmwP+wtJPk+
	 7AH+v8oiQBKpN+WKK/qKuBC0LrGx9p7QbLYuMLlpoEwmtLtTrun+cJcZ7cgq6UaOfy
	 Fbr8vgqkzRcQQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Baruch Siach <baruch@tkos.co.il>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 102/283] Documentation: PCI: endpoint: Fix ntb/vntb copy & paste errors
Date: Sat, 28 Feb 2026 13:04:04 -0500
Message-ID: <20260228180709.1583486-102-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Baruch Siach <baruch@tkos.co.il>

[ Upstream commit ad0c6da5be901f5c181490f683d22b416059bccb ]

Fix copy & paste errors by changing the references from 'ntb' to 'vntb'.

Fixes: 4ac8c8e52cd9 ("Documentation: PCI: Add specification for the PCI vNTB function device")
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
[mani: squashed the patches and fixed more errors]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/b51c2a69ffdbfa2c359f5cf33f3ad2acc3db87e4.1762154911.git.baruch@tkos.co.il
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/PCI/endpoint/pci-vntb-howto.rst | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/PCI/endpoint/pci-vntb-howto.rst b/Documentation/PCI/endpoint/pci-vntb-howto.rst
index 70d3bc90893f3..949c0d35694c2 100644
--- a/Documentation/PCI/endpoint/pci-vntb-howto.rst
+++ b/Documentation/PCI/endpoint/pci-vntb-howto.rst
@@ -52,14 +52,14 @@ pci-epf-vntb device, the following commands can be used::
 	# cd /sys/kernel/config/pci_ep/
 	# mkdir functions/pci_epf_vntb/func1
 
-The "mkdir func1" above creates the pci-epf-ntb function device that will
+The "mkdir func1" above creates the pci-epf-vntb function device that will
 be probed by pci_epf_vntb driver.
 
 The PCI endpoint framework populates the directory with the following
 configurable fields::
 
-	# ls functions/pci_epf_ntb/func1
-	baseclass_code    deviceid          msi_interrupts    pci-epf-ntb.0
+	# ls functions/pci_epf_vntb/func1
+	baseclass_code    deviceid          msi_interrupts    pci-epf-vntb.0
 	progif_code       secondary         subsys_id         vendorid
 	cache_line_size   interrupt_pin     msix_interrupts   primary
 	revid             subclass_code     subsys_vendor_id
@@ -106,13 +106,13 @@ A sample configuration for virtual NTB driver for virtual PCI bus::
 	# echo 0x080A > functions/pci_epf_vntb/func1/pci_epf_vntb.0/vntb_pid
 	# echo 0x10 > functions/pci_epf_vntb/func1/pci_epf_vntb.0/vbus_number
 
-Binding pci-epf-ntb Device to EP Controller
+Binding pci-epf-vntb Device to EP Controller
 --------------------------------------------
 
 NTB function device should be attached to PCI endpoint controllers
 connected to the host.
 
-	# ln -s controllers/5f010000.pcie_ep functions/pci-epf-ntb/func1/primary
+	# ln -s controllers/5f010000.pcie_ep functions/pci_epf_vntb/func1/primary
 
 Once the above step is completed, the PCI endpoint controllers are ready to
 establish a link with the host.
@@ -134,7 +134,7 @@ lspci Output at Host side
 -------------------------
 
 Note that the devices listed here correspond to the values populated in
-"Creating pci-epf-ntb Device" section above::
+"Creating pci-epf-vntb Device" section above::
 
 	# lspci
         00:00.0 PCI bridge: Freescale Semiconductor Inc Device 0000 (rev 01)
@@ -147,7 +147,7 @@ lspci Output at EP Side / Virtual PCI bus
 -----------------------------------------
 
 Note that the devices listed here correspond to the values populated in
-"Creating pci-epf-ntb Device" section above::
+"Creating pci-epf-vntb Device" section above::
 
         # lspci
         10:00.0 Unassigned class [ffff]: Dawicontrol Computersysteme GmbH Device 1234 (rev ff)
-- 
2.51.0

