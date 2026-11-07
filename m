Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060806;
	b=vo7jcrc3YEX8/caoGWDai5VzkfgrftFBZADqk+INkagsKr2O1fnnKckZBStn5QaL0hX/
	 KkUeNqaR9ymx7F4/UbG9Ay6HmA2FXJmrPiuje8nZgk80trDxfSRtmgaVT/9DsQFKnVbQL
	 z6PML6YPCJdZxOpVgU5gquSc1k0VlMtOXpsI9rvnhAzDFGhd7yyH1t9n7HOZLKc3bM4ut
	 aL8WCFaSDprvDhLqxYc3Pdq74AatmmSLUAKiUmJ6NOBOHhzCXzW1j34XSdG9mVM12G7yY
	 Vp03cYu/4sIfU6+rXGacgt/W/+B0zQZzXrXBcpti5Cec8OU/4G0LWeUwMfVK+Iu3maA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060806;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IjwjjGNPd2NBmfFLMV2Bzay49exrJNvxhspFcMw419Y=;
	b=YHyubnPwpJtECCK2UiAUT1A3bCg2iDFbacdebNuwcYiph2ip7dIcy8zrGEUXPXSmpejY
	 8tTE23cfTvejtoKUZL/acEQvHw6cirSDxllP/Ny/Y4AF4xHd6Tcm9iv1hYOR1MSPfsaLL
	 tzFzZd+pbAiP0Htuj2LrQO4bDzZARHZWgJcUlwsEtSNzvwRB8tpj/7I27AuOddmNTNZa6
	 9ZCVl+jcbZ1RrZsSvxci1hNf7g5ZpXfmQWWgtuPzUg9bpHXG4X/479jpM1SzTOb4bV4oE
	 Y4fVw+kGKsCGcbehMjkZG65JLNlUoIYTCuBoCZuxMcgh68ZHx4B0bwohe799+bsta7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nl9Ntygm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA11E606A326;
	Sat,  7 Nov 2026 14:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nl9Ntygm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574AE1F0089F;
	Sat,  7 Nov 2026 14:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060805;
	bh=IjwjjGNPd2NBmfFLMV2Bzay49exrJNvxhspFcMw419Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nl9NtygmxwkbmnYNMw37qxLd966zjY3bFjNITvkDn6ByH4tDr4+VdscvehzvY/HF0
	 7syLfjfVLrcZoMsGj4qFmcFHxOSKibK+Ux4pFR40sDp0BK1IXkrjLmq3VYT4apPpA1
	 vSQC1M59H1MnV1INIKSh5L0cB6WESfiwZh4jHJmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <briannorris@chromium.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0203/1536] PCI/portdrv: Allow probing even without child services
Date: Sat,  7 Nov 2026 08:36:59 -0500
Message-ID: <20261107135003.358474185@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit 834171efeefffb1a0f2136f32e76669bbc11db86 ]

The PCIe port driver fails to probe if it finds no child services,
presumably under the assumption that the driver is not useful in that case.
However, the driver *can* still be useful for power management support --
namely, it still configures the port for runtime PM / D3, which may be
important for allowing a bridge to enter low power modes.

Thus, allow probe to succeed even if no IRQs and no child services are
available. This also mirrors existing behavior for ports that don't support
any portdrv services (PCIe hotplug, AER, DPC, PME, bwctrl), where we'd also
probe successfully.

This change is a bit more important after commit f5cd8a929c82 ("PCI: dwc:
Remove MSI/MSIX capability for Root Port if iMSI-RX is used as MSI
controller"), because it's common for some DWC-based systems to:

  1. have only the "aer" and "pcie_pme" port services available and

  2. not define legacy INTx interrupts properly in their device tree.

After commit f5cd8a929c82, such systems may fail pcie_init_service_irqs()
and so exit with -ENODEV.

Link: https://lore.kernel.org/all/nyada24tqwlkzdceyoxbzitzygvp4elvj5oajnqdwb33xkcdwk@76vnrx45fsfd/
Signed-off-by: Brian Norris <briannorris@chromium.org>
[bhelgaas: reorder pcie_port_device_register() decls per Lukas]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Link: https://patch.msgid.link/20260722160942.v4.1.I5fd5d83f518681b3949d8ab2f16ba8244fd3e774@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/portdrv.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/pcie/portdrv.c b/drivers/pci/pcie/portdrv.c
index 75068c5029b01..2800a67b98b67 100644
--- a/drivers/pci/pcie/portdrv.c
+++ b/drivers/pci/pcie/portdrv.c
@@ -328,8 +328,8 @@ static int pcie_device_init(struct pci_dev *pdev, int service, int irq)
  */
 static int pcie_port_device_register(struct pci_dev *dev)
 {
-	int status, capabilities, i, nr_service;
 	int irqs[PCIE_PORT_DEVICE_MAXSERVICES];
+	int status, capabilities, i;
 
 	/* Enable PCI Express port device */
 	status = pci_enable_device(dev);
@@ -353,29 +353,29 @@ static int pcie_port_device_register(struct pci_dev *dev)
 	if (status) {
 		capabilities &= PCIE_PORT_SERVICE_HP;
 		if (!capabilities)
-			goto error_disable;
+			goto out;
 	}
 
 	/* Allocate child services if any */
-	status = -ENODEV;
-	nr_service = 0;
 	for (i = 0; i < PCIE_PORT_DEVICE_MAXSERVICES; i++) {
 		int service = 1 << i;
 		if (!(capabilities & service))
 			continue;
-		if (!pcie_device_init(dev, service, irqs[i]))
-			nr_service++;
+		if (pcie_device_init(dev, service, irqs[i]))
+			capabilities &= ~service;
 	}
-	if (!nr_service)
-		goto error_cleanup_irqs;
 
-	return 0;
+out:
+	/*
+	 * With no child services, we shouldn't need bus mastering or any IRQ
+	 * vectors we allocated.
+	 */
+	if (!capabilities) {
+		pci_free_irq_vectors(dev);
+		pci_clear_master(dev);
+	}
 
-error_cleanup_irqs:
-	pci_free_irq_vectors(dev);
-error_disable:
-	pci_disable_device(dev);
-	return status;
+	return 0;
 }
 
 typedef int (*pcie_callback_t)(struct pcie_device *);
-- 
2.53.0



