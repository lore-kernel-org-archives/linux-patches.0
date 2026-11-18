Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046220;
	b=pRDh5pfxAhgfMPNKj/PWcfge/wmUWfnnT8R+sSQCRLPfimGi+FinWQp4Z6lpADqWnTGA
	 2O0FdWE3oRywgQOCGnDr6JaRAlN2E+KXd4O0koJaacjZcK9P2kDU3IqgjRJfHe86k0ZpB
	 W/3mMMyHNWq2TKPKctKQGBxSlnuY+Id4lmmRkfX6QGR5e14uT1qA+Yijebkvh39S/nRnt
	 d3lXiXRtV31k2E53+vTCXXjQ2NKEvVd7eza1PdhXx1DL43QxDjFt6uhzNBRMlD5z9Ikh7
	 nQ1NLiPZIsyWg21q/K8vmzWpv0FcrjrkfwpWjEG8kqUyE4jrtoNw08mxl01c1MIMx5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046220;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/ct7k5dd+odrdNsyKbJ+bzIHKZJixXJgDnr3n2u0z2g=;
	b=UcQFE7hA36UbmRuXJ78SxmDwhccIGH0K+brJXqeExhFcDfZLbkYnGoZCNvMssTG6kqg5
	 WqQ16i/RHg5TX86jZbUP64nQorlYKPjkcp4sR/DKYL751Sp0VjkW+KOdm4l4D91WKHCHP
	 9X6r3+Lp9/KtbsMM9JDRbPGg62wgmNyB3x1xzrtGWnnhfeDAAU04Wh9nqLZERcdNhCaIP
	 shzCZjrfqddH2ZEmxy570R+phWCkdBaqPsNqEUKj1oYHRE/6zZy4CNgBYyCjPZy9RY50C
	 VJaHCjWwBAIjqe4tQ9Nb7T17AosPe24eSajOA8F2xJNtaV+0mNng3kSNqpR0wGvpiWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pb9Jal0o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC47606A32A;
	Wed, 18 Nov 2026 23:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pb9Jal0o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4E51F000C4;
	Wed, 18 Nov 2026 23:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046220;
	bh=/ct7k5dd+odrdNsyKbJ+bzIHKZJixXJgDnr3n2u0z2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pb9Jal0onSh7OLiR/zT6TyunVVkp5k+aJ8MSWZ3o5AB5vuM77ZpMfRn1UZH0W/1XB
	 E78T8vaFxp8otsEw3urYirHkbtVFLS5PbjbzJcmnC5qJS0YKZLbohNH8Qr7ee6yn3j
	 Le/RKiZAW6HudtoKh//+4GOai5Ey1nN23Qu4rRC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1201/2857] scsi: aic7xxx: Use default settings on the SGI O2 onboard controllers
Date: Wed, 18 Nov 2026 15:37:15 +0100
Message-ID: <20261118150244.852144263@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/aic7xxx/aic7xxx_core.c |  8 ++++++--
 drivers/scsi/aic7xxx/aic7xxx_pci.c  | 20 +++++++++++++++++++-
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index a396f048a031e..d747d0b72a13a 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -5266,9 +5266,13 @@ ahc_init(struct ahc_softc *ahc)
 
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
index 2d4c85426dc3e..5a04c7d55e4b5 100644
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



