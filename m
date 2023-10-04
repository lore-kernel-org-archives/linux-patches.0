Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D251D523
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:05:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C138C433C7;
	Wed,  4 Oct 2023 18:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442718;
	bh=jI35XbPERICaY4jWwm+569zLLIT3ngPsray/Z0Gq39w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wls0+OxGr7Qp18NOTjFPWpzlmOPJzyeH837CbjRXvqedgqLk1Jw217V1QOF1cNIYm
	 Br+1BnDP4lxZ/FuRicfIjY09AK1XrGkIykxjwZf7Knz+6QuJ5BxScbfH5SPcCZEh9k
	 nJpG7uFXH2sWQCUSXFYVCQIvf5aj9I/7jRqJ/D+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 084/183] ata: libata: Rename link flag ATA_LFLAG_NO_DB_DELAY
Date: Wed,  4 Oct 2023 19:55:15 +0200
Message-ID: <20231004175207.378252779@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Menzel <pmenzel@molgen.mpg.de>

[ Upstream commit b9ba367c513dbc165dd6c01266a59db4be2a3564 ]

Rename the link flag ATA_LFLAG_NO_DB_DELAY to
ATA_LFLAG_NO_DEBOUNCE_DELAY. The new name is longer, but clearer.

Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Stable-dep-of: 2a2df98ec592 ("ata: ahci: Add Elkhart Lake AHCI controller")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/ahci_brcm.c   | 2 +-
 drivers/ata/libata-sata.c | 2 +-
 include/linux/libata.h    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/ahci_brcm.c b/drivers/ata/ahci_brcm.c
index 6e9c5ade4c2ea..649815c196ed0 100644
--- a/drivers/ata/ahci_brcm.c
+++ b/drivers/ata/ahci_brcm.c
@@ -333,7 +333,7 @@ static struct ata_port_operations ahci_brcm_platform_ops = {
 
 static const struct ata_port_info ahci_brcm_port_info = {
 	.flags		= AHCI_FLAG_COMMON | ATA_FLAG_NO_DIPM,
-	.link_flags	= ATA_LFLAG_NO_DB_DELAY,
+	.link_flags	= ATA_LFLAG_NO_DEBOUNCE_DELAY,
 	.pio_mask	= ATA_PIO4,
 	.udma_mask	= ATA_UDMA6,
 	.port_ops	= &ahci_brcm_platform_ops,
diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index cb9395a3ad8e8..04bdd53abf20b 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -317,7 +317,7 @@ int sata_link_resume(struct ata_link *link, const unsigned long *params,
 		 * immediately after resuming.  Delay 200ms before
 		 * debouncing.
 		 */
-		if (!(link->flags & ATA_LFLAG_NO_DB_DELAY))
+		if (!(link->flags & ATA_LFLAG_NO_DEBOUNCE_DELAY))
 			ata_msleep(link->ap, 200);
 
 		/* is SControl restored correctly? */
diff --git a/include/linux/libata.h b/include/linux/libata.h
index fa568d35bcbfa..7508c68756e95 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -191,7 +191,7 @@ enum {
 	ATA_LFLAG_NO_LPM	= (1 << 8), /* disable LPM on this link */
 	ATA_LFLAG_RST_ONCE	= (1 << 9), /* limit recovery to one reset */
 	ATA_LFLAG_CHANGED	= (1 << 10), /* LPM state changed on this link */
-	ATA_LFLAG_NO_DB_DELAY	= (1 << 11), /* no debounce delay on link resume */
+	ATA_LFLAG_NO_DEBOUNCE_DELAY = (1 << 11), /* no debounce delay on link resume */
 
 	/* struct ata_port flags */
 	ATA_FLAG_SLAVE_POSS	= (1 << 0), /* host supports slave dev */
-- 
2.40.1



