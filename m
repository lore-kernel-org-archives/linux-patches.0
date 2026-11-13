Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585404;
	b=QL1d5MdIUDu0WitG6m4ls1rg7TJ4yJVg5ys0H18yL5lc9cmtV1NHyg7Ta/ZQp6Mz09Uq
	 wO3+nYygyHrAbgNCKknZxqQPs/liZv4N92fkagi1gT4KLVHAD+pzmAX5lfEG35Ab1aR2O
	 Q6pTFWXsUpZbI4LoxcScu6dMpa7QY8Nx1JohStxJobtdv33jPHbU4AX/u1eAjJ9f0B9C3
	 x65b77yoV12Qs2PR5iRYw5VTwINuAF6LV1M+1PUejNWW2dp+nqfDbWvyYmTQzH5BpJe07
	 +RAhztT9HuzIaeLATWsqGik753zmjfJfeB0qGBKXkte87z/rHfARepdWoSkmb9tnl4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585404;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1DB/f9F/AnbkcbqkNIGyzQ1RTZBzeEnA0o7mvvNM23Q=;
	b=ikbTUXnCyn374zT1OMMMc4q8zbDCk1yyTnHNTJeOwIQZ/EgaxtMfIY/6Dk+LzQFLz/Ro
	 VgpfGlOMGNpHP4DYiw43e7ehN5QCcje+rcNBwkdslkqNB96jTh3RWaU8RK7WIjLvBZiGe
	 3BFEBbTtMBcahFL6vxfR0w6PdQ7WiUvKPUP+aTO9IAL+aOc6Hs41Rk6rU0aSqUUATSxNe
	 eNr1LN7sqPFmrnx7FlXhSBSXAhufRjhy2Z7/JM1vCOx59d0QUgfE2gKKt7AGTYONqA9/N
	 P9h+rKql67aW+57mSQ0eB52nm/hkJpoA8T0XbPzntgam9mMW0OrurbLL8NCTNmAJWcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hS0lWh74;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F4E60A2636;
	Fri, 13 Nov 2026 15:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hS0lWh74
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70FCE1F000C7;
	Fri, 13 Nov 2026 15:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585404;
	bh=1DB/f9F/AnbkcbqkNIGyzQ1RTZBzeEnA0o7mvvNM23Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hS0lWh74FBEDWVoY2xXAIwMGco1r+I4kYkov1HT8UST/UXBtFsn0V8Xv4oiRE8L60
	 YHBcxdH2DiIO45fLqPk7/4NP4J09z3YveMU89hbG9zWRDZWm8ItQHaVis/ojuAxcNa
	 +/23hel5b6c2rJRBcxIEfsZFElkYA5gRUu+w0dJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 073/507] scsi: aic7xxx: Use default settings on the SGI O2 onboard controllers
Date: Fri, 13 Nov 2026 10:46:17 -0500
Message-ID: <20261113153756.058777846@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index b9761f9f0bbc8..8ad82171e925d 100644
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



