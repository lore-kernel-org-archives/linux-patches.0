Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051339;
	b=frO9PRaoaax0+P6mwb42HQ+YP1GTc6bVyov+k/szzURkhTjRZ28+NqwaU4RBrnup7twT
	 S5FaLbWSkzcL8dA6qM2iAxq6C09QKZ7ynPgizpe09s3pFRDAUbqYwTpc/ixSZJT92nqPM
	 rKvHrNQN5ddiqGpD1JWfiMSSU0ctQNHy6SvbiAcoF/rK00aq7TByAbpiw7KxS3P4OtkWj
	 5hhTPqhSJ1VI/KfXSF6srXopiNbI5ky89vZlT3eOywflLH0HINit2/jRnW5Oox8lWYD9j
	 ezAmjVFF8QMft+qpo10dNyqtKZ3rPAvBW7sunTuvyxGJd/FIMhZqUnEvAWo9pkdY01g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051339;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SUoDpoMdjZiBqf+t73rh7uybCtCEHBK5IFJ0s7OfRiw=;
	b=ownN/kCvwtG8ZKGgREKO3MOe9EQSntsw3JYNXiKTEWceser7pgzpWXY6oeFbFbw1aydK
	 BYB8hu82iLbpZHz8eItWboKEAxtZ7xOqy8zg7CVRrNaWTcplkjtxVakZmnIm9orBLuZqo
	 wzgp8YQbi76LZc9wjV9kFzUH4YQZOtmGJ4+akLeE3+1hMp/e+2Ec9cQCH0RotZyKGbei1
	 wgTCmOKtqyzRlm/p5NY7zuC/92yWyFvu2vPFVxmUOo8aUa19Y6X+ZlSQKflZXGoBdtmdY
	 m9ZXRJua+qAZQ/MgvVZ+ecHgln/POe58tfsUn7UQVUONLyHxAcsLC/dDVa7yxgnRHGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cVHg68nF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A993606A325;
	Thu, 19 Nov 2026 01:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cVHg68nF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890CE1F000C4;
	Thu, 19 Nov 2026 01:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051339;
	bh=SUoDpoMdjZiBqf+t73rh7uybCtCEHBK5IFJ0s7OfRiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cVHg68nF+JKw6qUxdSukwa/fhVVNVUiHRdslJJa0YhqidR0GrYAAvaZ10NkMFDSWB
	 3mIbofZIVlWRSGJbD3ZKPyc9dr1d1jfqZ1UxF+BjpHX0lj7M2yQ5hj4DUVPiw2ei7W
	 BZTU4F9yuf6XjX5YtOWJki/ROtufdQ0d8JLoQdQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <briannorris@chromium.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0132/2214] PCI/portdrv: Allow probing even without child services
Date: Wed, 18 Nov 2026 15:30:08 +0100
Message-ID: <20261118150015.493156106@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/pci/pcie/portdrv_core.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index 4c57ddfd6275d..20c8d6ea19f7e 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -319,8 +319,8 @@ static int pcie_device_init(struct pci_dev *pdev, int service, int irq)
  */
 int pcie_port_device_register(struct pci_dev *dev)
 {
-	int status, capabilities, i, nr_service;
 	int irqs[PCIE_PORT_DEVICE_MAXSERVICES];
+	int status, capabilities, i;
 
 	/* Enable PCI Express port device */
 	status = pci_enable_device(dev);
@@ -344,29 +344,29 @@ int pcie_port_device_register(struct pci_dev *dev)
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



