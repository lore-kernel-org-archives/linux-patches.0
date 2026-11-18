Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033931;
	b=RYZdHjzQ/eyVHnBxAOGSfJ4H4BsFgDy7wsQLXe5Uoc7loya/80JgQIeG4W2Y4GotFHdg
	 Z3ABkO7QbAa87lUBsS6kbhWiZ1TwREojR3Gg1L19UWuM/LC7NF6SIsm8K79o2C3P6cv3p
	 bQo7k5MhnNP4QJNixpn8exPyxDY79kuAWju9qeCosrxgp1pZW0+EVN40gXMib1ThmHhJD
	 jNhOgdQ5Fyqsam5CuOXX+ukHcC57HKQq3Th0RVfkLIara4iyQWrMRm3kPY0SJ8nptt6am
	 RYfl58Exe+6U4fTz7cBwDhqq1Tzov3QyETtrTLlFEQ7MZGk2jgYelO50tv+5VEK8X/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033931;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nTaSFPl6dw0DGGmfPOFVlWMs9FPKb4/q1alBY5JKImo=;
	b=o/CToqHqYQPitYfJn5tbF6C9nxkz/tR10fbloBh+UJk1/dW17iqZTFpKwqMX3ugUPSBN
	 D9h3r1RqHfkjYnaaH5qGaciIXmo3x0HHWHg6A8psh1WSphDM+FUUG3fwwlMO19UX4ham5
	 lSfnBkX/DERipxHwDIrbHzVXtEq42uAxw/lJGULStXQmK0qV6ZNkTgkVuuGVyh2aJD0Kl
	 TDhXOH32ReYElF4n3BZJo8Ezno4iPygZNfzVtZM2zT8uR4pc1rl1/hbV7U2ama6ugSKOi
	 ZG8Bxuu48Nx0yehvxhv+P/xkk8AEP4ztLogIkbQEuFoQijgSpOdnHs/aB9Sqd7AvIkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1lZDH2X2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B913606A31C;
	Wed, 18 Nov 2026 20:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1lZDH2X2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4791F000C4;
	Wed, 18 Nov 2026 20:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033931;
	bh=nTaSFPl6dw0DGGmfPOFVlWMs9FPKb4/q1alBY5JKImo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1lZDH2X2D8H6jnSQT/Dp4EzuAz0W+YdxkpTyMb/GRgdeIuNWmFA/FBgorIJc+//Bq
	 sVlM4lGDBW0GJt6FU6r0N74z4g9L1HN6TIKMMek9zX65jdXAhjKOJ/gTT770GeZynz
	 Et63L03tCJID006kK1mNJebveKBd5Ab+7/TGkvXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0189/3318] ata: ata_generic: Dont store pci_device_id
Date: Wed, 18 Nov 2026 15:13:31 +0100
Message-ID: <20261118150320.449824776@linuxfoundation.org>
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

From: Gary Guo <gary@garyguo.net>

[ Upstream commit 4f3075f629077a8cb3d3455c794a1f4a8fc8b43e ]

pci_device_id is not guaranteed to live longer than probe due to presence
of dynamic ID. All information apart from driver_data can be easily
retrieved from pci_dev, so just store driver_data.

Signed-off-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Acked-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://patch.msgid.link/20260723-pci_id_fix-v4-1-3580726844e1@garyguo.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/ata_generic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index 2f57ec00ab821..ef5e817e96b26 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -51,11 +51,11 @@ enum {
 static int generic_set_mode(struct ata_link *link, struct ata_device **unused)
 {
 	struct ata_port *ap = link->ap;
-	const struct pci_device_id *id = ap->host->private_data;
+	unsigned long driver_data = (unsigned long)ap->host->private_data;
 	int dma_enabled = 0;
 	struct ata_device *dev;
 
-	if (id->driver_data & ATA_GEN_FORCE_DMA) {
+	if (driver_data & ATA_GEN_FORCE_DMA) {
 		dma_enabled = 0xff;
 	} else if (ap->ioaddr.bmdma_addr) {
 		/* Bits 5 and 6 indicate if DMA is active on master/slave */
@@ -206,7 +206,7 @@ static int ata_generic_init_one(struct pci_dev *dev, const struct pci_device_id
 			return rc;
 		pcim_pin_device(dev);
 	}
-	return ata_pci_bmdma_init_one(dev, ppi, &generic_sht, (void *)id, 0);
+	return ata_pci_bmdma_init_one(dev, ppi, &generic_sht, (void *)id->driver_data, 0);
 }
 
 static struct pci_device_id ata_generic[] = {
-- 
2.53.0



