Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D2A1D5ABA;
	Wed, 25 Feb 2026 01:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983165; cv=none; b=RmlO7hXKJFMzVhYvXyJORNtUEZi4xQqjKJXl/xAWMnRD/RkJpK7Yv9zOW7FJmWBBnKk58J0gelFLj/kX5pD2uXPJolb6vex64G7xhZrfRk8IH3Ut7SrCUd1a0DrIelrWSkefv07it81QmSB7DUo9p7PmUgNZdDmQENR6UyvmMuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983165; c=relaxed/simple;
	bh=gEzWElSKBZ6BTQWwUgkTSDw3rdoJ2EJsBTvNOn9yUYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gOK200xGXDdB6m5+65lRmfHbAhIY2ocYDLdyxwKdmHffzbeF21nlc/jv8m2CpCM3MIIWzaxa6pFv+4M0VmP9rRQ1dZo+Ikb0Q/GlpnsZZGbZvMwI0ENiCYuWCXcinA1mr2HPt5xWmdxz2mfs7ZXtLVY9CmE+2pmybfhjW9T9QhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ise1AvLv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ise1AvLv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A60C116D0;
	Wed, 25 Feb 2026 01:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983165;
	bh=gEzWElSKBZ6BTQWwUgkTSDw3rdoJ2EJsBTvNOn9yUYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ise1AvLvCKVdDW38xjGQdItW8GQ9iQrrN49ca7rOTxwfWjX5hD229vZ/j6ZWHFQ9z
	 lgjsWSLeTYZIh6l4VqECZzGU0yUa9MuxvA8DBlpvYY0RGhZjQ6OC+NK4SHID7fozEx
	 YypqL0r2B2S6lgi+UrYOj4ZKa/3fMKO6Ir+53jZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baruch Siach <baruch@tkos.co.il>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 318/781] Documentation: PCI: endpoint: Fix ntb/vntb copy & paste errors
Date: Tue, 24 Feb 2026 17:17:07 -0800
Message-ID: <20260225012407.498827674@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 9a7a2f0a68498..3679f5c302549 100644
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
@@ -111,13 +111,13 @@ A sample configuration for virtual NTB driver for virtual PCI bus::
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
@@ -139,7 +139,7 @@ lspci Output at Host side
 -------------------------
 
 Note that the devices listed here correspond to the values populated in
-"Creating pci-epf-ntb Device" section above::
+"Creating pci-epf-vntb Device" section above::
 
 	# lspci
         00:00.0 PCI bridge: Freescale Semiconductor Inc Device 0000 (rev 01)
@@ -152,7 +152,7 @@ lspci Output at EP Side / Virtual PCI bus
 -----------------------------------------
 
 Note that the devices listed here correspond to the values populated in
-"Creating pci-epf-ntb Device" section above::
+"Creating pci-epf-vntb Device" section above::
 
         # lspci
         10:00.0 Unassigned class [ffff]: Dawicontrol Computersysteme GmbH Device 1234 (rev ff)
-- 
2.51.0



