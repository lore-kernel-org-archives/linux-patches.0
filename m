Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059850;
	b=jD1+45HOs3PfBJKf6m5iXXiF81Z1Q6iQP7QhCGC1PLo42tOVyMlC9/bm5S0OIKMdZava
	 5zZRK1m0TxP4WrVdMjsWZyUUoEJgubaeSSoN9YP+E07GXLB49MP67+2PIKgnATtY6z069
	 ppkuKIOVNNQQUBY9QegYM/JjYopkn81hUzdZQEg+RlO1Q4UID5hzOwhAe8PQpvz1UNQoW
	 2tsmBtBOCOUI5mOHLAnn3Nwp+kO3+TlG5XmDPmRK+1dCGrYcFT9oIlVFJLpYnPssBoJcd
	 FF+4jOmhKd4pSTfxn13p2iGUVFCplqJY/FW/aItnQkDQPRnKDM5zCOnKaNtT2Vf0Z7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059850;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZQseVxHrTmJTDcQcP/tONFM8sMppXhuo6wI8O0VVSU0=;
	b=gUI53da46DdSWGXbjdarmPEMvMNQB88sFL0Fg+3qCg1Ef5It6cZBMweyBSbC1E9LAEfL
	 6o6o1GlVerniJAuZuJwQlQoZaH2Nn5ZclweSz5+Z3KswjZvm/WxcXSKCEKBs7jDmODoQf
	 PqcC21EqL2OjfcgpzIeqCXi47AoCT7L2+QtbOMuOBTSgj/vQ/rnoyHb41BjcG/Sow3dOJ
	 59ha9/NRtg/hvrcngV//RVhQOf9wjGgYh7jleHa7RCyHpvrSo58MQ/LT7G0PuFb1WXrxn
	 QF52b76vatw/JVW5TH6HZDVo4eOTGMSIATeP8A33sgAlWKjLdfsKVJf0+TU6Kl9jC+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=joe84xSh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5991E606A320;
	Thu, 19 Nov 2026 03:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=joe84xSh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9460A1F000C4;
	Thu, 19 Nov 2026 03:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059850;
	bh=ZQseVxHrTmJTDcQcP/tONFM8sMppXhuo6wI8O0VVSU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=joe84xShNO7mJuLqr6h7T9FY736pFUohhiWfVK2Nbs135wRz8zPrIwM7Ha710VtpN
	 8opxxn7kfl9bZHyzL7/MOwHNx+lz8n6FmpC0TCCXYDRvR24oExVAY13qy8IUR/ZLku
	 rWQUMbuXBDq+n5pnFTwurKtTwXkrwWLQClJpXank=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0990/1848] ata: ahci: print the lpm policy on boot
Date: Wed, 18 Nov 2026 15:50:28 +0100
Message-ID: <20261118145958.334813233@linuxfoundation.org>
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

From: Niklas Cassel <niklas.cassel@wdc.com>

[ Upstream commit affccb16c117d188eb09495cbdea149cecbf00b9 ]

The target LPM policy can be set using either a Kconfig or a kernel module
parameter.

However, if the board type is set to anything but board_ahci_low_power,
then the LPM policy will overridden and set to ATA_LPM_UNKNOWN.

Additionally, if the default suspend is suspend to idle, depending on the
hardware capabilities of the HBA, ahci_update_initial_lpm_policy() might
override the LPM policy to either ATA_LPM_MIN_POWER_WITH_PARTIAL or
ATA_LPM_MIN_POWER.

All this means that it is very hard to know which LPM policy a user will
actually be using on a given system.

In order to make it easier to debug LPM related issues, print the LPM
policy on boot.

One common LPM related issue is that the device fails to link up.
Because of that, we cannot add this print to ata_dev_configure(), as that
function is only called after a successful link up. Instead, add the info
using ata_port_desc(), with the help of a new ata_port_desc_misc() helper.
The port description is printed once per port during boot.

Before changes:
ata1: SATA max UDMA/133 abar m524288@0xa5780000 port 0xa5780100 irq 170
ata2: SATA max UDMA/133 abar m524288@0xa5780000 port 0xa5780180 irq 170

After changes:
ata1: SATA max UDMA/133 abar m524288@0xa5780000 port 0xa5780100 irq 170 lpm-pol 4
ata2: SATA max UDMA/133 abar m524288@0xa5780000 port 0xa5780180 irq 170 lpm-pol 4

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Stable-dep-of: 34a4a34431ed ("ata: libahci: Free the IRQs when activating a multi-IRQ host fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libahci.c     |  2 +-
 drivers/ata/libata-core.c |  2 +-
 drivers/ata/libata-sff.c  | 10 +++++-----
 drivers/ata/pata_cs5520.c |  2 +-
 include/linux/libata.h    |  5 +++++
 5 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 75ccd7872b7e8..32ebcfcb7914c 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -2578,7 +2578,7 @@ static int ahci_host_activate_multi_irqs(struct ata_host *host,
 
 		if (rc)
 			return rc;
-		ata_port_desc(host->ports[i], "irq %d", irq);
+		ata_port_desc_misc(host->ports[i], irq);
 	}
 
 	return ata_host_register(host, sht);
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 9be577e7c357c..2ff092c27d1f3 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5886,7 +5886,7 @@ int ata_host_activate(struct ata_host *host, int irq,
 		return rc;
 
 	for (i = 0; i < host->n_ports; i++)
-		ata_port_desc(host->ports[i], "irq %d", irq);
+		ata_port_desc_misc(host->ports[i], irq);
 
 	rc = ata_host_register(host, sht);
 	/* if failed, just free the IRQ and leave ports alone */
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 88bce10775afb..c6e91f06c751e 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -2405,7 +2405,7 @@ int ata_pci_sff_activate_host(struct ata_host *host,
 		for (i = 0; i < 2; i++) {
 			if (ata_port_is_dummy(host->ports[i]))
 				continue;
-			ata_port_desc(host->ports[i], "irq %d", pdev->irq);
+			ata_port_desc_misc(host->ports[i], pdev->irq);
 		}
 	} else if (legacy_mode) {
 		if (!ata_port_is_dummy(host->ports[0])) {
@@ -2415,8 +2415,8 @@ int ata_pci_sff_activate_host(struct ata_host *host,
 			if (rc)
 				goto out;
 
-			ata_port_desc(host->ports[0], "irq %d",
-				      ATA_PRIMARY_IRQ(pdev));
+			ata_port_desc_misc(host->ports[0],
+					   ATA_PRIMARY_IRQ(pdev));
 		}
 
 		if (!ata_port_is_dummy(host->ports[1])) {
@@ -2426,8 +2426,8 @@ int ata_pci_sff_activate_host(struct ata_host *host,
 			if (rc)
 				goto out;
 
-			ata_port_desc(host->ports[1], "irq %d",
-				      ATA_SECONDARY_IRQ(pdev));
+			ata_port_desc_misc(host->ports[1],
+					   ATA_SECONDARY_IRQ(pdev));
 		}
 	}
 
diff --git a/drivers/ata/pata_cs5520.c b/drivers/ata/pata_cs5520.c
index 9052148b306d9..a78efb3f96f92 100644
--- a/drivers/ata/pata_cs5520.c
+++ b/drivers/ata/pata_cs5520.c
@@ -210,7 +210,7 @@ static int cs5520_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		if (rc)
 			return rc;
 
-		ata_port_desc(ap, "irq %d", irq[i]);
+		ata_port_desc_misc(ap, irq[i]);
 	}
 
 	return ata_host_register(host, &cs5520_sht);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 1ceec830d5f74..12c43f39cd29b 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1541,6 +1541,11 @@ void ata_port_desc(struct ata_port *ap, const char *fmt, ...);
 extern void ata_port_pbar_desc(struct ata_port *ap, int bar, ssize_t offset,
 			       const char *name);
 #endif
+static inline void ata_port_desc_misc(struct ata_port *ap, int irq)
+{
+	ata_port_desc(ap, "irq %d", irq);
+	ata_port_desc(ap, "lpm-pol %d", ap->target_lpm_policy);
+}
 
 static inline bool ata_tag_internal(unsigned int tag)
 {
-- 
2.53.0



