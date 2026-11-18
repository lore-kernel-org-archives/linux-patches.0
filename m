Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057435;
	b=Gg/ddSphq4+HTqmd2HAL6o59XO/i5chEMVeg6+0xXbjG9xssUsCcGzmXrXzuPul9ZpG4
	 xypwdE7iZJKTv6CCw28yogZwAhC7ybyXRNT2RFS9KUqRtl+Ezw2wq04Y3B92uU4R0eJEa
	 94X8uy8yaWQ8ZlItehJY0mBN8eyXcLp+Oh+peXwv9YPQXQ5p6NNWhyaaOHRDW0nvem+9r
	 /3OomefThAqkNSe/wnBmrqDexeTQl2loWTu5PivHRveab8agv+qbZBipkzvfL00ab3XH0
	 i4U6onUMw+A2f9RRTrVFfOKmPk2UWg7GXEdxTTweHIPTOx+P1H9wkBFLhBnupPwHpWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057435;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PkveLhscfqpE0YA2gfBccveWSa5uY1T0n7z0wPGAwsk=;
	b=Ow2ARra4vUTcNAcDeo1CDHslqaRGy4IPn7JrNt755Pr/kH4M3XAR1da2Aafqy/n0Rbj8
	 tOaTE6y0nYx0Dh9ZmnOMA8rkP2j1UdifX+PTH7iOEt4yg/nEpxvYF4cOu5ojs6erKNNgJ
	 7LLxsQHoFKylSZZb/LqMgZF3rpXtll1yAHeefUvyB65CYPdbC18f8RPZ3X5zGzQafr/pt
	 GLujYGVe0MidCQN+jNNNi2LOYIy7vJsmKrfNJR6vjoJtKSeSFIEhBv/3evf2IGunbNQbe
	 u6zwpjbe9kB6Gn6uvNNUkSz1JFXlfqDtcccfgFdYyI6zhVGZknojHwN7w9tYH4DXJcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LnfjcyfJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1AC60A2609;
	Thu, 19 Nov 2026 03:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LnfjcyfJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C821F000C4;
	Thu, 19 Nov 2026 03:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057435;
	bh=PkveLhscfqpE0YA2gfBccveWSa5uY1T0n7z0wPGAwsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LnfjcyfJ6YfKn6dAX6pClpeAKpx7muYsgYEHJ5fLCdJ2+EryxJOln8VMxFhzSpbz5
	 i7gSr4QvpQC5FtZ0gv1VWphGNokYdRPO9KCJb3IqaZKCu+1eEMSaxhn40nalWZfo2t
	 /xarrM9cxrEBER79/oXrcGxAhIP4hpRsXS1jU7bM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0128/1848] ata: ata_generic: Dont store pci_device_id
Date: Wed, 18 Nov 2026 15:36:06 +0100
Message-ID: <20261118145916.486439243@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9ff545ce8da3e..ca6cef5203695 100644
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



