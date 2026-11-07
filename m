Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060835;
	b=uokArDf+c0IkqbPCEHR36QVeowlsXQemFmKNvD3qKNox8xOYaAK/83P2bsqJP0Wf2xl1
	 ilOjDMmRym1k3EofIaxbpSxPYHgBWjCHM73yQ45sAbxUSyGL7ufc6GpVZn5JkYK1S/uVG
	 37U1eOCMDBleF3kGKz1QZKREvcbkNWavRKpC/9ZSywkE3DaALS/Ic4ZGhxHXGJYEfdoBD
	 mhUPLowKwOkY6o/SPi9eiR10GwbVmVW+T0pLA7uw1QTkA3ToM02PEUzvWA6RCvuwMKqAm
	 Qv7tXs+eP0llN6SkLvbQ7NvO042m41ur3KwXcuyfnLXCS10tPhpIwjgS0Domexivk5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060835;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jJFfgFgpKt7DuN6+/JH6QzB2nT3lShWMb/0rv3V9I0A=;
	b=ww92S/9CLE/KBQ1RwzM8SwEMjmdqolBx95XldMQWqZVCbWIrX62EYlmJSSu+8fbjPhvD
	 TNGMkgHYyMM1Y1GSXii/eUmpx0BmiHnxtPhiED6TdlRqzkDu2ZCE1/ISF9OO65ldZ0vvv
	 LlKsiRSiVcnJyCGzKTdCZJKHFtoi3FPQ/2ZN+8aBm+tB6F8lDjeh1Rgb/6THm8Anbwifi
	 LvXXI73/H9BGwCE3nfsM9a1ED86KkZSJyMhFNh2bXV3Seyygv0FOVBEbffwQd85t9hhgE
	 5hscINe3L+i2kBRVN67I8goTDRmScysSDtWo6SXAnwTxTbdETDcdv90xKe/FvnfPnDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LgT50YHq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F83606A33E;
	Sat,  7 Nov 2026 14:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LgT50YHq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F691F008A1;
	Sat,  7 Nov 2026 14:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060834;
	bh=jJFfgFgpKt7DuN6+/JH6QzB2nT3lShWMb/0rv3V9I0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LgT50YHqiw+gMl44TULYbVnknfYYvdkQ09dVjo5Sj+LUzW8LRfMQYZtZyaTqZdktK
	 F4cuVTy0qAOrD2XETvfQGbbNuWunRLVWE1LHnHG4McNbNwv25kYjIWJrH8694mUNvs
	 xqTwMqxKr1ZAw2njEcx2JsyigjnaktErd1OFm3HE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0226/1536] ata: ata_generic: Dont store pci_device_id
Date: Sat,  7 Nov 2026 08:37:22 -0500
Message-ID: <20261107135004.016712637@linuxfoundation.org>
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



