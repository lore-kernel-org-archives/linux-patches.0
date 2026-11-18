Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038757;
	b=NkJOZVeqMxW5ZbNzTDvALOWAfDHG4jxzNrGjz0NIUmNjGgeinCchSjGHNbw4ySqToYqK
	 hRj7QebicRIxvLTZid33mhvJMJXxYb1CxAGNMmRVCBZB7s8FKrmwTaq+HthSpC8pDMPil
	 0XdnmA9vsTbCGd5m5T9kUARsVPtbjPRqfN9gLfxpZ1BBRw72wDhC2EHUYgd1WoXm7w8WN
	 foV76bixUWAJNbBNhF0HosliYS9TzYBqPXV+AxkgSTrqA8uP1IQRRJInuOoMZIIkcTJP6
	 Ro3UjI48Tt8K9Re7CiGxqqf5KHXZOVs2tYkFG5eN0y8fRvUnOGhSzrE1mlWMmE3XYUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038757;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vuNh3LgoTRlOSNyHb4NTeypgVRsZAVearfarY9zvcbk=;
	b=FtNquaZ6LNbnqROugYgPWcUM8Gba6s3EqLE9JzwpE5S9CvHgLVx+Fmpl1638qKamKJRL
	 O2nXQEheNZRwlGZsrux7Xj7TL/ztqXJfSw3x5X8EuuEMF3VRjwApnl1g4Sekq2uhQTbKC
	 xV3tAuOvsYmXLFERJCkIcpBAahARskAWo2l31i7Ml5acOh252tOOvafeFH+oAnPu2bWsa
	 vPxGSikznSc29uf6DJ4cXDRa33zsN5dmmWPXB0MrF92qutZp6JQDQ+qqseALLG/CVkxzz
	 HmD3HXPfoFGgLfgwHcyDnw5WlkllltPoo0OaH+JaTCHQQK2F0HiOAIOJjGBlV2xXVEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1gnP43lk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCDE606A320;
	Wed, 18 Nov 2026 21:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1gnP43lk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE531F000C4;
	Wed, 18 Nov 2026 21:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038756;
	bh=vuNh3LgoTRlOSNyHb4NTeypgVRsZAVearfarY9zvcbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1gnP43lknh0avdxFJiu72+gXZqKauNV6MMh06wSb9d+3Y36sLHUgsMNyv13c//aci
	 m3ysOJv60+uPkcVyDr8CectbPOr9UnQjZi5+HJZaVd+HqA6r7Ri+MN1xP8zLQFvh2q
	 1K2OzSXMDBoOAyJWVKTYsCiBS1UCjJHyRhGyYnvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1829/3318] ata: ahci: print the lpm policy on boot
Date: Wed, 18 Nov 2026 15:40:51 +0100
Message-ID: <20261118150416.732095155@linuxfoundation.org>
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
index 52016b6a6d779..1056d536a60cb 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -2736,7 +2736,7 @@ static int ahci_host_activate_multi_irqs(struct ata_host *host,
 
 		if (rc)
 			return rc;
-		ata_port_desc(host->ports[i], "irq %d", irq);
+		ata_port_desc_misc(host->ports[i], irq);
 	}
 
 	return ata_host_register(host, sht);
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 3992a12b90a2a..97f07d7b3ce76 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6134,7 +6134,7 @@ int ata_host_activate(struct ata_host *host, int irq,
 		return rc;
 
 	for (i = 0; i < host->n_ports; i++)
-		ata_port_desc(host->ports[i], "irq %d", irq);
+		ata_port_desc_misc(host->ports[i], irq);
 
 	rc = ata_host_register(host, sht);
 	/* if failed, just free the IRQ and leave ports alone */
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 9b6529f2dfcbd..ab4bd43bd2cbd 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -2318,7 +2318,7 @@ int ata_pci_sff_activate_host(struct ata_host *host,
 		for (i = 0; i < 2; i++) {
 			if (ata_port_is_dummy(host->ports[i]))
 				continue;
-			ata_port_desc(host->ports[i], "irq %d", pdev->irq);
+			ata_port_desc_misc(host->ports[i], pdev->irq);
 		}
 	} else if (legacy_mode) {
 		if (!ata_port_is_dummy(host->ports[0])) {
@@ -2328,8 +2328,8 @@ int ata_pci_sff_activate_host(struct ata_host *host,
 			if (rc)
 				goto out;
 
-			ata_port_desc(host->ports[0], "irq %d",
-				      ATA_PRIMARY_IRQ(pdev));
+			ata_port_desc_misc(host->ports[0],
+					   ATA_PRIMARY_IRQ(pdev));
 		}
 
 		if (!ata_port_is_dummy(host->ports[1])) {
@@ -2339,8 +2339,8 @@ int ata_pci_sff_activate_host(struct ata_host *host,
 			if (rc)
 				goto out;
 
-			ata_port_desc(host->ports[1], "irq %d",
-				      ATA_SECONDARY_IRQ(pdev));
+			ata_port_desc_misc(host->ports[1],
+					   ATA_SECONDARY_IRQ(pdev));
 		}
 	}
 
diff --git a/drivers/ata/pata_cs5520.c b/drivers/ata/pata_cs5520.c
index 422d42761a1d7..38795508c2e94 100644
--- a/drivers/ata/pata_cs5520.c
+++ b/drivers/ata/pata_cs5520.c
@@ -212,7 +212,7 @@ static int cs5520_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		if (rc)
 			return rc;
 
-		ata_port_desc(ap, "irq %d", irq[i]);
+		ata_port_desc_misc(ap, irq[i]);
 	}
 
 	return ata_host_register(host, &cs5520_sht);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index ed2dbec700f5e..eb9646b959fbc 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1562,6 +1562,11 @@ void ata_port_desc(struct ata_port *ap, const char *fmt, ...);
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



