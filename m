Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037486;
	b=3vjpwf5WZCMXR+FULs40m4E6S/vDFACnu39S/rM71vJOZM0ueGMPKubJWfM/Y1bSAZy0
	 ECbORYTlUCABhrwT/+Q8frFdyqAXGms2ldM0nFvcZ3RxGxc3smMlAfKWgkGGy4l94bDa0
	 pKhUs52MEhxu95b3WuJgaPqjSKU71YH0fLSaAtjcoNXGCdhbyuu2jKvx644DQ3k6QMoCb
	 SoL+6tXbUOS+awsPrfkDf6m0q04tUOn/YgFkI4Mh26SI2jz5JheWckRFlazcrF4Zx6PBb
	 SHv7JK/BbHPE9bnuki+uz08Rl+xilgC06pyLwd6YOGEWCkbSk8lRtHFDNr+9irA9HsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037486;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0d9K77X/uPc85yE/kUW17fGGYKi8ejJHuYsQcKL9r70=;
	b=3MLXogsb1vjlXGng4QjxrWnqH1ixmgr6InAzW9FZ+1uU4yUgBFCThOzYhBGVwab+6w17
	 KjEieM1J/Tbtowq6p/6yTeHIPyPaJigTDZBK5MjaO4V7f3v0e6pwTKfBMt06bwr4Ruszo
	 i1MBW88EGc949ulpM2WHy7THgjXL+J1dype2mP7GyKkqEzLQjfrlXZCQ97p8shQwepjfU
	 qdvEzMGVMhquzqmSHPqIo9nvkBWSDMVKSw656HdQHR7J/oIakl380bxI29UdygDqL/03s
	 vpS5L6+YVvjOq4wFbxqKqp4T0XTqeXFWm+XgksQ4W/0zXtMvOIT9LA06trg2W1F3rzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ryObyvIg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDE1606A32C;
	Wed, 18 Nov 2026 21:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ryObyvIg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7691F000C4;
	Wed, 18 Nov 2026 21:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037486;
	bh=0d9K77X/uPc85yE/kUW17fGGYKi8ejJHuYsQcKL9r70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ryObyvIgrL+czPaDiwsAmLdtSUyG6eQSXiT0oV6sc7ZjqcDrqN50RBNFXJtkjya/R
	 5wEUw0XzcdzbAZDpgMNzCKjfek5vgSD6kVLI9+ZkhQlXm135Gsr/2u2FyRsGX0l186
	 JciPoBaWjCDtt0b3+KB6+Mgm20ZpNomAy+Qq/W8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1413/3318] scsi: aic7xxx: Use default settings on the SGI O2 onboard controllers
Date: Wed, 18 Nov 2026 15:33:55 +0100
Message-ID: <20261118150403.054381007@linuxfoundation.org>
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



