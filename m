Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033882;
	b=zWt+S89uvRk5qP9uml/E8rIOerN8O9kVdKCUWdYvjAPoRvPDBjUE8ibrLwPw7cvjXqg4
	 0IVhBmt5pv4+Ttxu5R1Vij9wrSbXjtJ3nL/YWzhhNubhdIBIjfwhMknqpPv2rZ1sNLK0U
	 40g6rXJ8GsdoGN6Fc1B/Jm3sQFYuTbM8sv8X4E/1n/iMwubdPhL2IXHRgE3NP5vZkQAZ9
	 maKZocabLNj962qPav5IjpJUtSNqDFVcexURYAJ5WxP7OSIzLlRcLeWTN62eDwYTTiXq/
	 0PKmbA8D8iMCBIauX8dvooB5p5gtiJShvKvuBPeZcmCVrp+NC3Kv7Mu8SpQh3JEqeZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033882;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XGz+7qlBFyX64Hux60SwIjbhpFtFftHPmBz7jlv4akE=;
	b=yYGxeLGwmQFh8Jr25JHViHmz8A/9huxzMUHXo5ARvebetCRasvT4ds3qB1tNXBnmwD7b
	 PH7pTBR02XT9MxjsAQ7yWACr0K5yh9s+j54w0Mkg3cG3rJ5WArn2dMW0zZaIAt7fcJmDK
	 Hy+/9zRiBQOMzemPvQyCwYbRCSvvEkwjoHsLteIpqVpdoV9cGCDBrlYIQaf0qnXQac61h
	 3cLzah6C+efx/MzBo08bF15jBi77sEG0GJa9kYOn0kRpVud/WW+Ll1FOcYQzL1lux3tAX
	 QjzIPA9cyDW3A7u9/slmHsBx+4CXtHEnrBTFuUq2QzqIHR8DjI2Cknnj3Yf5aFAn4NA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YMm9tt3N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8E7606A31C;
	Wed, 18 Nov 2026 20:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YMm9tt3N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76D91F000C4;
	Wed, 18 Nov 2026 20:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033881;
	bh=XGz+7qlBFyX64Hux60SwIjbhpFtFftHPmBz7jlv4akE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YMm9tt3Nke8LoC4wM9KwayAQfI+D7oLZu71H8p2Jm7Wal0PBtdhiaHFNcPYnbmEmj
	 HQ00Z/3+IyV6jxv49wF0i7QJwRjkFcdIcfWpEJqgdRhVMU+wL9ORue4ajTLRTUU4Tj
	 vWO4XHwMsrDlr2S+jNNswxaVKNtiFBApToco/6Zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <briannorris@chromium.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0173/3318] PCI/portdrv: Allow probing even without child services
Date: Wed, 18 Nov 2026 15:13:15 +0100
Message-ID: <20261118150319.859885350@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index dac3ba1b2552f..49b598f32984b 100644
--- a/drivers/pci/pcie/portdrv.c
+++ b/drivers/pci/pcie/portdrv.c
@@ -327,8 +327,8 @@ static int pcie_device_init(struct pci_dev *pdev, int service, int irq)
  */
 static int pcie_port_device_register(struct pci_dev *dev)
 {
-	int status, capabilities, i, nr_service;
 	int irqs[PCIE_PORT_DEVICE_MAXSERVICES];
+	int status, capabilities, i;
 
 	/* Enable PCI Express port device */
 	status = pci_enable_device(dev);
@@ -352,29 +352,29 @@ static int pcie_port_device_register(struct pci_dev *dev)
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



