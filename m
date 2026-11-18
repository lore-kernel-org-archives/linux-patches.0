Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053363;
	b=paIuF0JPR19v2DebaGR/E264SB3Jk7RTBmIA87LiO8JqPOALdubmlcs7E9zFegfi+UM3
	 Yv2rzDPKiW/VoRtS1EVPYyc9fV+Q6SWsYnbP1Qv0csi9gwYmr8zr5PubnKEgMnT4WZJSh
	 dWn8orvjVICx0vEszhW1b95ur5PWm2Tsb5iTeu4e4FFi9EeVU1BvL0O5j/XTtstNBU/YE
	 bNCZTRC+Mrb2G2r7YLFIuVJ9b5pcq63byrldNykxPVpSUdZ1AgrvR4Jr+kUxMEeKGdjVS
	 m/Qgiy2BzMc+klVz9ZmcMetcY5zjiNPdueugNmqr2p+zgKnTwj2XIB0CJNOoZJKb+Lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053363;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jn9Fv+QW3kmrTQQSwuN9bR70Y7STeitfch00A6cU1W8=;
	b=V+5FGWXbYeROBqyzq9S7E4gU2jikl4oWQ8TbyZzJW8tVy5/lnYq7GmtwIjvcQ0ECX/k7
	 cDoED5N9AbDKNPuRjyJ5pTWhz1tTMFgxaY2JZX8b70yumD5aXBSuK3da6KaadWa2A39Bj
	 sjns5+K+b9gmc1t92AMk7ShSJnQbU+MbTeO3LAAjkkIXnZB+4ao8Ig9/kq6f+QBsAvVr6
	 aJIO4KYodf5WubzGRGnhu4rcaLjolWAQYiESwV0J/phVlW97StfGZNv26FBmGCjvbNRGs
	 cKZ5oUtRJVY0IxoecKtYIyjJM3MLLaIeiLV8ABSupMpIXcCUbJhXqNzn3+b0FmMyofg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=anBZZNQR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C311606A31C;
	Thu, 19 Nov 2026 01:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=anBZZNQR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33061F000C7;
	Thu, 19 Nov 2026 01:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053363;
	bh=jn9Fv+QW3kmrTQQSwuN9bR70Y7STeitfch00A6cU1W8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=anBZZNQReBQ9ukkmH4GTSZNhIF8K/tTNPCrOTDqDyefrkf5HjDAuyjGAenNLP7CdA
	 usPgch+/kkTjB3Ts/znew0NJWNOk1GSU/LKAY2/toRiO4K6F5VYFu/zvViAWXsKZgX
	 3VVhHR4NyvnIyT0pZuJrveYjxiiTbb3/iVIJVNsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0843/2214] scsi: aic7xxx: Use default settings on the SGI O2 onboard controllers
Date: Wed, 18 Nov 2026 15:41:59 +0100
Message-ID: <20261118150045.918529408@linuxfoundation.org>
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
index dab3a6d12c4d2..bea1b21481cfe 100644
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



