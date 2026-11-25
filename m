Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618586;
	b=v1YZxnZ2EpMbdztVbevcX0Aobqp31fr8DXk+WedrTxvew4pEuxaDM6Bu4/36SYk4zlrV
	 99cqV0VL4U3YYOiXjz9N/EaiY3LeqPJYXxSsYLy1mb/vAhbG9SseESfyLbj8c3gPP2hpx
	 2d7PWJ6S7G+wvneajxYK9fWcOncXsiD+fz5gBoWq1mmeeuTOONaFmpDKE+TyfvQEWbshY
	 ShC0YUgjVT5WaOdT1z5tqnSY8vvlZnBeKoQOSA/FiiagcN95mUEx8iMUNW76BhBxTMDAH
	 hSAyuuYOI8ElQcacmRjbMUlNLCJAJaW2cQOI8lOEu/BKhu7FMjtM0ecN3AfDE84ahYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618586;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eCaFoSJAtunOua815AxX2J/cTwyx3+aXq5peWYGdXIA=;
	b=3TX1Q0x4cBpIVjwA6sHpYlCEVAdZ1W4Xq/9nSRf6pJPTolgwJOpbgvAaoVKHtkngAVmr
	 6aMpqI9AQjrDDNUuHGbcOh9GsUH+MUqHDipcLjXqPZBe0i1ASfOLGC4F/nzmxAeC3i71R
	 hGafRDHXi6ULDRpkuWboFJD4HrAXhYLJgJwRcuogETQgyBjUAXEkGXEFg2xkTpDJ1NC6l
	 wtlWiAp3YR3uOCBnW2/tptxFqr+41SBgCfYnK6YfjZwrXAqqnA4SFA/Mw3Zjyfm1kpJT/
	 ZOhzMdr6ofEunYNpYiISD9QM5hG51M3rAKWTVWKwS61LvATa6eujXRJNt757v5askIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oJ78WBXg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CE4606A321;
	Wed, 25 Nov 2026 14:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oJ78WBXg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 516BB1F000E1;
	Wed, 25 Nov 2026 14:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618585;
	bh=eCaFoSJAtunOua815AxX2J/cTwyx3+aXq5peWYGdXIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oJ78WBXgX6HD2P0NHFnKcqyb1TI+3DixusAuDyQVRMU4RYR2bwbCDE/UmyY/ytb8j
	 q5fR5tYQ8ztM/Wq6D9TAyRwH6O9Neq4vBnYSg9SGVbIVzBnDH+UzL09m1JuOi1Ai/S
	 LP7V/YYKnuI4EXVLzouddS0lTNw2Y+xUzlsDUsFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <f.fainelli@gmail.com>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0327/1005] MIPS: Cobalt: Include legacy IDE ports in the PCI I/O window
Date: Wed, 25 Nov 2026 15:27:45 +0100
Message-ID: <20261125143829.394175284@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit ff209a7294988aac52b2522b1d0d7349da4541ec ]

The Cobalt PCI I/O window starts at 0x1000, excluding the VIA IDE
controller's fixed compatibility-mode ports at 0x170, 0x1f0, 0x376 and
0x3f6. Since pcibios_enable_device() was converted to
pci_enable_resources(), these unclaimed resources cause pata_via to
fail to probe with -EINVAL.

Start the PCI I/O window at zero to cover the southbridge legacy ports,
retaining 0x1000 as the allocation minimum via PCIBIOS_MIN_IO. Register
the PCI controller from plat_mem_setup(), before the VIA reservations
and i8259 initialization, so the legacy resources do not conflict with
the host bridge window and prevent PCI bus scanning.

Keep the VIA resource reservations in plat_mem_setup() after the PCI
controller registration and use insert_resource() to nest them beneath
the PCI window. The i8259 and RTC resources are also claimed beneath it.

Boot-tested on a Qube2 with a MIPS64 kernel. All seven PCI functions
enumerate, both tulip devices bind, and pata_via initializes both ATA
hosts and detects the ST380012A 80 GB disk. All 18 boot checks pass,
including a read-only disk test and Ethernet ping.

Fixes: ae81aad5c2e1 ("MIPS: PCI: Use pci_enable_resources()")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/cobalt/pci.c                     | 11 +++++------
 arch/mips/cobalt/setup.c                   |  4 +++-
 arch/mips/include/asm/mach-cobalt/cobalt.h |  1 +
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/mips/cobalt/pci.c b/arch/mips/cobalt/pci.c
index 85ec9cc31d666..29fd052766b2a 100644
--- a/arch/mips/cobalt/pci.c
+++ b/arch/mips/cobalt/pci.c
@@ -14,6 +14,8 @@
 
 #include <asm/gt64120.h>
 
+#include <cobalt.h>
+
 extern struct pci_ops gt64xxx_pci0_ops;
 
 static struct resource cobalt_mem_resource = {
@@ -24,7 +26,7 @@ static struct resource cobalt_mem_resource = {
 };
 
 static struct resource cobalt_io_resource = {
-	.start	= 0x1000,
+	.start	= 0,
 	.end	= 0xffffffUL,
 	.name	= "PCI I/O",
 	.flags	= IORESOURCE_IO,
@@ -38,11 +40,8 @@ static struct pci_controller cobalt_pci_controller = {
 	.io_map_base	= CKSEG1ADDR(GT_DEF_PCI0_IO_BASE),
 };
 
-static int __init cobalt_pci_init(void)
+void __init cobalt_pci_init(void)
 {
+	PCIBIOS_MIN_IO = 0x1000;
 	register_pci_controller(&cobalt_pci_controller);
-
-	return 0;
 }
-
-arch_initcall(cobalt_pci_init);
diff --git a/arch/mips/cobalt/setup.c b/arch/mips/cobalt/setup.c
index 9a266bf783399..502acc92969b8 100644
--- a/arch/mips/cobalt/setup.c
+++ b/arch/mips/cobalt/setup.c
@@ -83,9 +83,11 @@ void __init plat_mem_setup(void)
 	/* I/O port resource */
 	ioport_resource.end = 0x01ffffff;
 
+	cobalt_pci_init();
+
 	/* These resources have been reserved by VIA SuperI/O chip. */
 	for (i = 0; i < ARRAY_SIZE(cobalt_reserved_resources); i++)
-		request_resource(&ioport_resource, cobalt_reserved_resources + i);
+		insert_resource(&ioport_resource, cobalt_reserved_resources + i);
 }
 
 /*
diff --git a/arch/mips/include/asm/mach-cobalt/cobalt.h b/arch/mips/include/asm/mach-cobalt/cobalt.h
index 97f9d5e9446d2..c7a8607cd651a 100644
--- a/arch/mips/include/asm/mach-cobalt/cobalt.h
+++ b/arch/mips/include/asm/mach-cobalt/cobalt.h
@@ -19,6 +19,7 @@ extern int cobalt_board_id;
 #define COBALT_BRD_ID_QUBE2    0x5
 #define COBALT_BRD_ID_RAQ2     0x6
 
+void cobalt_pci_init(void);
 void cobalt_machine_halt(void);
 void cobalt_machine_restart(char *command);
 
-- 
2.53.0



