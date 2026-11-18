Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060178;
	b=S7N2FlDeWunBZy1/MpaRrYHUwxNT4eh26JWFThkWv7QF3tDN4d3uttIGO3fLoX5NaUC8
	 XGbT1zHmRErCN8PLSz8aZFMXX5cnxgUEMMjTQ15s9WEP+GiZKrIZkna+P0ejomi8B/juT
	 2Rx3vhLXa4xHL12QZpWwKSzmglVB+d14cq0LDd3/SEVxhT4o2U7DpLZ4I6QNLeVGjg4/P
	 01l8M5NAT5gX3E+/1RUTvsTXdwmSJ6VJXG+zapJw9fHqqbgBKGjJobqSZQkhQ8wfHiqUq
	 gcte+XbatB3AX91RUfHTi6w6kRonn4eS8Rw0bYVMpv7VDOxYe4hhCqDo3qVcaNJODMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060178;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HntHc9YU10PFSOi2ZZ7ZQHX7d9NEQSNWsrshO1kwvqA=;
	b=TjHIOEaO0KvFZUGdcFrVmVkFddDBQ7lXOZMTXcA5gFKEcdVWOKkOtI42Ei2KwsH7rJQd
	 x87P3uCpwP2l8xDmvPxnwrJjx93yt6g9A1DVDq9yrd2fX/GBuoB7H8dAHtgI/Ih1OI1hL
	 TWv+dM48Y0AZvBUPEKLqmFvQefDqOcxxctFVhM4Jvk9T5JjAjVl0REE55/ivDjz/fI2fp
	 Er+Hrsu3OVNPtML2e/BYwB49zHvrsBHabku/kdijQPhpu7OE+sKjqRDnvuUJIN4yIUZN0
	 tSvbLouCdesTN1aaYVT5XnTh3l4H0xLktHA3hG3QjIN+DFqZjscBj0+LvZr0H6GsSWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kiapXUkg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56613606A325;
	Thu, 19 Nov 2026 03:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kiapXUkg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA431F000C4;
	Thu, 19 Nov 2026 03:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060178;
	bh=HntHc9YU10PFSOi2ZZ7ZQHX7d9NEQSNWsrshO1kwvqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kiapXUkgOBC/namBbcDFJAvlvx2RzI2p3DKTbEpWww9gmcnvBZT4KySmT7Z2wFRxF
	 o7ZzdAtI3oNdS0++HDVoUkeAxOWkNEqjF+uEmfp/7KNFrHqXWwVZvuR71GEOxqgqL1
	 jHQyl+PVCIu02kgn7rsahF4UfOKpHP9XExXoQG3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1104/1848] scsi: aic7xxx: Use default settings on the SGI O2 onboard controllers
Date: Wed, 18 Nov 2026 15:52:22 +0100
Message-ID: <20261118150005.484953691@linuxfoundation.org>
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

From: Imre Kaloz <kaloz@kernel.org>

[ Upstream commit 696bdfc58975fbc70d2e2347a74e0b562e7e2494 ]

The SGI O2 firmware runs its onboard aic7880s without the Adaptec BIOS, so
scratch RAM holds no settings. The left over BIOS path reads uninitialised
bytes, and bad parity panics the boot.

Use the defaults there with host ID 0. ahc_init() keeps the default host ID
ahc_pci_config() chose, 7 on other PCI controllers, so only the O2 changes.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Imre Kaloz <kaloz@kernel.org>
Link: https://patch.msgid.link/20261026131432.26065-1-kaloz@kernel.org
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
[ sashal: Adjusted context in ahc_init() to preserve an existing tab on the blank line after the host-ID assignment. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/aic7xxx/aic7xxx_core.c |  8 ++++++--
 drivers/scsi/aic7xxx/aic7xxx_pci.c  | 20 +++++++++++++++++++-
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 12fed15dec66f..a6b18547df7d7 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -5267,9 +5267,13 @@ ahc_init(struct ahc_softc *ahc)
 
 	/*
 	 * Assume we have a board at this stage and it has been reset.
+	 * PCI controllers keep the host ID ahc_pci_config() chose.
 	 */
-	if ((ahc->flags & AHC_USEDEFAULTS) != 0)
-		ahc->our_id = ahc->our_id_b = 7;
+	if ((ahc->flags & AHC_USEDEFAULTS) != 0) {
+		if ((ahc->chip & AHC_PCI) == 0)
+			ahc->our_id = 7;
+		ahc->our_id_b = 7;
+	}
 	
 	/*
 	 * Default to allowing initiator operations.
diff --git a/drivers/scsi/aic7xxx/aic7xxx_pci.c b/drivers/scsi/aic7xxx/aic7xxx_pci.c
index 656f680c78024..7db8e20aff5c4 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_pci.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_pci.c
@@ -701,6 +701,21 @@ ahc_find_pci_device(ahc_dev_softc_t pci)
 	return (NULL);
 }
 
+/*
+ * The SGI O2 firmware runs its onboard controllers, in slots 1 and 2 of the
+ * root bus, without the Adaptec BIOS and at host ID 0.  It leaves no settings
+ * in scratch RAM, which may still hold power-on contents with bad parity.
+ */
+static bool
+ahc_pci_sgi_o2_onboard(struct ahc_softc *ahc)
+{
+	int slot = ahc_get_pci_slot(ahc->dev_softc);
+
+	return IS_ENABLED(CONFIG_SGI_IP32) &&
+	       ahc_get_pci_bus(ahc->dev_softc) == 0 &&
+	       (slot == 1 || slot == 2);
+}
+
 int
 ahc_pci_config(struct ahc_softc *ahc, const struct ahc_pci_identity *entry)
 {
@@ -782,6 +797,9 @@ ahc_pci_config(struct ahc_softc *ahc, const struct ahc_pci_identity *entry)
 	ahc->bus_intr = ahc_pci_intr;
 	ahc->bus_chip_init = ahc_pci_chip_init;
 
+	if (ahc_pci_sgi_o2_onboard(ahc))
+		ahc->flags |= AHC_NO_BIOS_INIT;
+
 	/* Remember how the card was setup in case there is no SEEPROM */
 	if ((ahc_inb(ahc, HCNTRL) & POWRDN) == 0) {
 		ahc_pause(ahc);
@@ -898,7 +916,7 @@ ahc_pci_config(struct ahc_softc *ahc, const struct ahc_pci_identity *entry)
 			 * Assume only one connector and always turn
 			 * on termination.
 			 */
- 			our_id = 0x07;
+			our_id = ahc_pci_sgi_o2_onboard(ahc) ? 0 : 0x07;
 			sxfrctl1 = STPWEN;
 		}
 		ahc_outb(ahc, SCSICONF, our_id|ENSPCHK|RESET_SCSI);
-- 
2.53.0



