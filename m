Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051267;
	b=sLqX7k09Qyxeb6yxI5bGLvsQEwSYIw7QWeQPhJEB2vTDIqoOHODtuZw+dtoQ60GDzXYj
	 jEB97oneV/+FRZSJXtve/s6Xt+KmZSsXkjsDxjR29Y055c5sLSZMV8C08CGEPSPmuHAc9
	 I+NViOqf4fh0P312KMosaweRhaETDeWEHFaY4rWg3ChPKaGjN6JUZlU2JXVzQpr+hezSt
	 m+yB3whU/nvln5sgCFhq2fbtR42jF8GntlfSoLihd13kFeXHDcgAi1vDP2ZNq0br4iSED
	 vHdxzWDuvpNym5UiWSJwgF/7W/T0arvj183D505/zd22lZ+lliSDp4TpzkTp6CiVEhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051267;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x36dCKXYoeYm1t05Zam89/Ww2tKvkqyQScjo/+pW7d8=;
	b=CgaA5OEUfTmUNyXSJNQ4xCc7K4wkMwQuc8lWwMEEvy3StfWqZnKnuPRxOPtycbPnje/S
	 N8+RVUjlhclpwzwBl3Gs6rQFjBehtowTvEqgrFcfQ/jowAa2q6lraxqXVhJ7VAioRs/2q
	 LF0DubDiKSrY7uSsrkCMC4PdYewxN6Rcmrrp6Otr7P41PkpSE3MDYSoyuKh9ax2c0OPgX
	 Dvl/TJk999MON3OpzZrNUryPUjBAXzQZ0bp6e8env3eCdE7mAcQGcfQ2EVQKmKwI0JHN1
	 W7e/vEc/LiSq8HR1vDxbJ5b9N+wrCB2npTrl5MWDZ3iFyE9tqKfXEzcIauqjoPLRmYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tTbv6K8q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6056E606A325;
	Thu, 19 Nov 2026 01:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tTbv6K8q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE55B1F000C5;
	Thu, 19 Nov 2026 01:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051267;
	bh=x36dCKXYoeYm1t05Zam89/Ww2tKvkqyQScjo/+pW7d8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tTbv6K8q8hGc8keJzgjqQTtKEqow5hPH3nV6m/cQwHNP0mgFqWnrKVpnahF+yOKPP
	 KMALehXrpps5MWUZ5m0ORclZrdvneWZgOqx/guPDKjNLkBMEhphHVJj3DW0GUBMUmS
	 MMZFV3cqixg2erzUJel687co1wu9KJUMceYTSAec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0148/2214] ata: ata_generic: Dont store pci_device_id
Date: Wed, 18 Nov 2026 15:30:24 +0100
Message-ID: <20261118150016.089260290@linuxfoundation.org>
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
index 20a32e4d501d3..177c902b2988b 100644
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



