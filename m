Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829731;
	b=lTEQnrekA+eVo3FwXfStoKn1x98OQonx8bDrO808TLYoijvBePyVQREKs7BZ7H0qaTa1
	 KJyukrPCYFs1on9WrqGZSY/qJY5Bl80xKgAruqxS8SxMY0cjdYCcQ5XnmN6P9HGe+n4PU
	 brMzVBysnjPugYXqwk0d6OM13vQcwtmTy7Lfc+pryS3OxwJoleno5/v/63Icaki9Cz+XK
	 ogYQimvm+2syRJJwFVZSV4fIvyLL3mKSo4U9J0ik9Ayrd2NWibljWY0Q/8auTrLzzr8CZ
	 JHudP6oE8Qv2wEwPod0SrrPWrYbgdYuw6CSQqSyzNOsIGymF5sFrVcNoF2601OgPVQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829731;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EDVAQ9bfAxEX54l2EmS6iHjN4Ri/t8o7fXU1JjOmTyg=;
	b=VKYcSKgM+7BkxhdBS2lGcsxopo5F2uSIBGLeQFCBcX7jdaV4j4XWhulRjiavHsFxqKxg
	 Irw061S9HfoPUfrbKhqFOd83cN4ipHcb1uCiG+eKrlE+ncaDuVc+d2O8YgDXg319NOWLo
	 1LcvDASH9CTtLoNLlKqwWCT82HKXSKIIKVPQjLaOIp4i05wRdopnR96hNRV/Rzsd0ydNC
	 mjIX9BpSarS4uqlNbYqZkiwFZg8AB8w6x5BONg2QseH3WDOlTj2aVgQfSR8l97tXNmajP
	 Lst0RvAG8yIL+m0SOw8DTTvM0NHDcVKqapmkChGUR3NzM+/gzJKGV/vdplFHT8tp00g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=09vKpkBc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B01606C90F;
	Wed,  4 Nov 2026 22:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=09vKpkBc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F8D1F00A17;
	Wed,  4 Nov 2026 22:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829731;
	bh=EDVAQ9bfAxEX54l2EmS6iHjN4Ri/t8o7fXU1JjOmTyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=09vKpkBc7xnJQqdGj1/pqFTRzRxFhhoLv/AF41sq5cu2mZxCbr+w2ULJChc4tUD5t
	 WQPmBIND/w/mrMs9ZlZwPeY9zGqW4K/kJJkYmnf5IcuKel7/umA0OpGTbaYj/4PX41
	 81gh5/qlyv7D4oR3ohHFwtnDyaK2DAzFi81FNrq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0268/1005] ata: ata_generic: Dont store pci_device_id
Date: Wed,  4 Nov 2026 16:00:01 -0500
Message-ID: <20261104211051.382050019@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e70b6c089cf17..18ea740ca5829 100644
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
 
 static const struct pci_device_id ata_generic[] = {
-- 
2.53.0



