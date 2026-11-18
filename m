Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054183;
	b=sDYVxjwFsw65RuC7VjmRitVmW6YpG5itWso/4fH6TJIpdoCoftr6PGYpU0mFQ1BexYax
	 CvJzcSv+TTxrUhRWqCLd8+ZPcPgusa9YzkPTkq9klNdexelhLGKOvRw6YabdoFxYnNkE9
	 oagMWNGRkcRjww7gyVYV75OA39WN0SuLkisLuAJhD5q5fs2BKsB1t/KgdpeYVLq6LlCzO
	 2jiJXC4i40qWULqYVLnznmJ2wYkHttMsPNeP80bBd4ftQ7X4WoOKHUQFWVcIq3X064DhD
	 AzMiZfib5zrwCYT21dgGdvmM+zGQDtF0sJcc0vcovZBQP+TfIOw9w60GZRSpAZ87fug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054183;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xLjJLjxtn/E1cTO/v5hO2MuRTo4rA04i2C/u0rskXdA=;
	b=QeGrZxJn6CgfuTiEUGEPk70n+Itt7de8y1wn0FN3GORK7StoxQ5kT8uTkO9uv2uZQYIh
	 yDceQ0sh3Fp6js25N+FopR2ZgqdrQ8HLEt4zyFtjNdUco9B0OR0iDXHSUAcq3YDNJYpXz
	 /eZCiDwKca0S8EaTNoZJp49hYG0GYwfzQsua0elYtBWr8RslhD57GDU/1CShiQVvSBacH
	 /1JNFPmGM71CjPSo4cSboyejGxm0HaZUBMgtlpyjqVc+4ZayE5apcNW5k2V/5Y6/nAJtg
	 4gz+dxH3DQE8AqVxr4RAVbsJrNWod+IlttrJl1tX8B6NRARcwmOtqhhIXtonn5CxfNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MvhxLyPI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE900606A320;
	Thu, 19 Nov 2026 02:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MvhxLyPI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA561F000C4;
	Thu, 19 Nov 2026 02:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054183;
	bh=xLjJLjxtn/E1cTO/v5hO2MuRTo4rA04i2C/u0rskXdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MvhxLyPI2WouyUGod3AEfp+SJ24m+pbn5t0TwUQPDfeTasMvlHi9Y0cZA940AV/xo
	 mi+ev5oGrzxjbN+aeiVtDgDmoWudbaLp9pi6nXvgFNrhmy68aYk4uXH1QzIdrEezUB
	 j6qYJkfSr9ZYB7uGwaoEdpGfyyisXS2UGXG6fPM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1184/2214] ata: ahci: print the lpm policy on boot
Date: Wed, 18 Nov 2026 15:47:40 +0100
Message-ID: <20261118150059.298213548@linuxfoundation.org>
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
index f6af0683a6520..a30e17265e873 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -2594,7 +2594,7 @@ static int ahci_host_activate_multi_irqs(struct ata_host *host,
 
 		if (rc)
 			return rc;
-		ata_port_desc(host->ports[i], "irq %d", irq);
+		ata_port_desc_misc(host->ports[i], irq);
 	}
 
 	return ata_host_register(host, sht);
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index acc78416be8ee..00fafdbafe6e8 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5911,7 +5911,7 @@ int ata_host_activate(struct ata_host *host, int irq,
 		return rc;
 
 	for (i = 0; i < host->n_ports; i++)
-		ata_port_desc(host->ports[i], "irq %d", irq);
+		ata_port_desc_misc(host->ports[i], irq);
 
 	rc = ata_host_register(host, sht);
 	/* if failed, just free the IRQ and leave ports alone */
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index ab1fe23810707..5cf8086943256 100644
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
index 247c147026243..3c813246794c4 100644
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
index 3069064dc269c..e7645df2f3063 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1565,6 +1565,11 @@ void ata_port_desc(struct ata_port *ap, const char *fmt, ...);
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



