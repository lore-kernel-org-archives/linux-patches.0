Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591479;
	b=GvDgnHbbGT5/6rupTkka5mxaBM70Js4hf/Tl3K/zHlgRNU3jOLKrCLzsvTUjL6+a4ML0
	 0bzzn1IHVuoBP0yRgTNtzttbnoe846BjMVG2ym7QHboBZjK8j/9hwDgmo/qt5a/hcF0KG
	 N3J2QepHrQ6oLO6L4M9U1/NE2rVcm9njk3x8aX0Zz/X7CyeMYOIsTe7fYY2Pt250r5MrK
	 6Fap39hNJT2CoU86kPt0Ejz5qGEARuZ3xkIEO+OY/84L5uD1NoIESYpFpyKS1g4qel+Hr
	 cvV2gKiBM2GBYMh9ZgoJKrTPCKnEQt6S0QUmd4H/HprQxiyAj0W+xkKmVbsHD6QJjWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591479;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ArcAqzuDT1vvm1CeJHCapP37o08v+3DMgxqtL56iKz0=;
	b=Qjui4z/2TRy3BuNJlpIUbJFgDKwzeJcJv7NDB+vTrqquJg/iEbNIgK/L4dJ539ZZYx/+
	 QCqpvGHWTYwVC7fwRDsCH6r26KSmThWCsr4s8F6Je5l7kkwj0s0b9xCrgaSgd39l2WwVp
	 xUhDx/rOENUQkQFzIKotKgpLp9QdBZzYCEDXcc5ECU44nTD65aqmFOSEDJtZiy8n1nX0K
	 NRd0X3h0KUefQ5PEMxPAVsphU6q0Ojjiu0nLg9KfU3lyd8xx5unw8ojKT/EcPVAyHTdRw
	 PAvL4jmDWJMSRO5+9SRo1jfCc73D6XB2ULn9BUKwbD8j4dejEHNgcEw5iT+JPHL665w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EX04jwzo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77478607D2E5;
	Fri, 13 Nov 2026 17:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EX04jwzo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 225341F000C4;
	Fri, 13 Nov 2026 17:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591479;
	bh=ArcAqzuDT1vvm1CeJHCapP37o08v+3DMgxqtL56iKz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EX04jwzoj4S/ngraRf0iAJhHRaGPiS73FelQljZevsiWZA3emRDJfnW25y33Mnl86
	 sZLIh3wR3po6FGOo9p/Z3Q2S1Gjv0Ws28MOLIXG8PdxCV/+ZA3kRh40b2UWxfVgJ2t
	 eyID9b8QE82IgvNY63+QwB8XAQZxzIFr6QRh9hS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 520/670] ata: libata-eh: Remove ata_do_eh()
Date: Fri, 13 Nov 2026 10:51:24 -0500
Message-ID: <20261113153829.555196424@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit df6f9a918ea856fc288b9001b0414c5be136d7d0 ]

The only reason for ata_do_eh() to exist is that the two caller sites,
ata_std_error_handler() and ata_sff_error_handler() may pass it a
NULL hardreset operation so that the built-in (generic) hardreset
operation for a driver is ignored if the adapter SCR access is not
available.

However, ata_std_error_handler() and ata_sff_error_handler()
modifications of the hardreset port operation can easily be combined as
they are mutually exclusive. That is, a driver using sata_std_hardreset()
as its hardreset operation cannot use sata_sff_hardreset() and
vice-versa.

With this observation, ata_do_eh() can be removed and its code moved to
ata_std_error_handler(). The condition used to ignore the built-in
hardreset port operation is modified to be the one that was used in
ata_sff_error_handler(). This requires defining a stub for the function
sata_sff_hardreset() to avoid compilation errors when CONFIG_ATA_SFF is
not enabled. Furthermore, instead of modifying the local hardreset
operation definition, set the ATA_LFLAG_NO_HRST link flag to prevent
the use of built-in hardreset methods for ports without a valid scr_read
function. This flag is checked in ata_eh_reset() and if set, the
hardreset method is ignored.

This change simplifies ata_sff_error_handler() as this function now only
needs to call ata_std_error_handler().

No functional changes.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Link: https://lore.kernel.org/r/20250716020315.235457-2-dlemoal@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Stable-dep-of: 96fdeb7e3fd8 ("ata: sata_inic162x: remove dangerous broken driver")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-eh.c  | 48 ++++++++++++----------------------------
 drivers/ata/libata-sff.c | 10 +--------
 include/linux/libata.h   |  9 +++++---
 3 files changed, 21 insertions(+), 46 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 1cf737f17d0a3..a7525c8e97bf3 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -4040,59 +4040,39 @@ void ata_eh_finish(struct ata_port *ap)
 }
 
 /**
- *	ata_do_eh - do standard error handling
+ *	ata_std_error_handler - standard error handler
  *	@ap: host port to handle error for
  *
- *	@prereset: prereset method (can be NULL)
- *	@softreset: softreset method (can be NULL)
- *	@hardreset: hardreset method (can be NULL)
- *	@postreset: postreset method (can be NULL)
- *
  *	Perform standard error handling sequence.
  *
  *	LOCKING:
  *	Kernel thread context (may sleep).
  */
-void ata_do_eh(struct ata_port *ap, ata_prereset_fn_t prereset,
-	       ata_reset_fn_t softreset, ata_reset_fn_t hardreset,
-	       ata_postreset_fn_t postreset)
+void ata_std_error_handler(struct ata_port *ap)
 {
-	struct ata_device *dev;
+	struct ata_port_operations *ops = ap->ops;
+	struct ata_link *link = &ap->link;
 	int rc;
 
+	/* Ignore built-in hardresets if SCR access is not available */
+	if ((ops->hardreset == sata_std_hardreset ||
+	     ops->hardreset == sata_sff_hardreset) && !sata_scr_valid(link))
+		link->flags |= ATA_LFLAG_NO_HRST;
+
 	ata_eh_autopsy(ap);
 	ata_eh_report(ap);
 
-	rc = ata_eh_recover(ap, prereset, softreset, hardreset, postreset,
-			    NULL);
+	rc = ata_eh_recover(ap, ops->prereset, ops->softreset,
+			    ops->hardreset, ops->postreset, NULL);
 	if (rc) {
-		ata_for_each_dev(dev, &ap->link, ALL)
+		struct ata_device *dev;
+
+		ata_for_each_dev(dev, link, ALL)
 			ata_dev_disable(dev);
 	}
 
 	ata_eh_finish(ap);
 }
-
-/**
- *	ata_std_error_handler - standard error handler
- *	@ap: host port to handle error for
- *
- *	Standard error handler
- *
- *	LOCKING:
- *	Kernel thread context (may sleep).
- */
-void ata_std_error_handler(struct ata_port *ap)
-{
-	struct ata_port_operations *ops = ap->ops;
-	ata_reset_fn_t hardreset = ops->hardreset;
-
-	/* ignore built-in hardreset if SCR access is not available */
-	if (hardreset == sata_std_hardreset && !sata_scr_valid(&ap->link))
-		hardreset = NULL;
-
-	ata_do_eh(ap, ops->prereset, ops->softreset, hardreset, ops->postreset);
-}
 EXPORT_SYMBOL_GPL(ata_std_error_handler);
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 83cb44ca5a97e..13aec8ce4458f 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -2054,8 +2054,6 @@ EXPORT_SYMBOL_GPL(ata_sff_drain_fifo);
  */
 void ata_sff_error_handler(struct ata_port *ap)
 {
-	ata_reset_fn_t softreset = ap->ops->softreset;
-	ata_reset_fn_t hardreset = ap->ops->hardreset;
 	struct ata_queued_cmd *qc;
 	unsigned long flags;
 
@@ -2077,13 +2075,7 @@ void ata_sff_error_handler(struct ata_port *ap)
 
 	spin_unlock_irqrestore(ap->lock, flags);
 
-	/* ignore built-in hardresets if SCR access is not available */
-	if ((hardreset == sata_std_hardreset ||
-	     hardreset == sata_sff_hardreset) && !sata_scr_valid(&ap->link))
-		hardreset = NULL;
-
-	ata_do_eh(ap, ap->ops->prereset, softreset, hardreset,
-		  ap->ops->postreset);
+	ata_std_error_handler(ap);
 }
 EXPORT_SYMBOL_GPL(ata_sff_error_handler);
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index e5e098279803b..511dad024708a 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1418,9 +1418,6 @@ extern void ata_eh_thaw_port(struct ata_port *ap);
 extern void ata_eh_qc_complete(struct ata_queued_cmd *qc);
 extern void ata_eh_qc_retry(struct ata_queued_cmd *qc);
 
-extern void ata_do_eh(struct ata_port *ap, ata_prereset_fn_t prereset,
-		      ata_reset_fn_t softreset, ata_reset_fn_t hardreset,
-		      ata_postreset_fn_t postreset);
 extern void ata_std_error_handler(struct ata_port *ap);
 extern void ata_std_sched_eh(struct ata_port *ap);
 extern void ata_std_end_eh(struct ata_port *ap);
@@ -2153,6 +2150,12 @@ static inline u8 ata_wait_idle(struct ata_port *ap)
 
 	return status;
 }
+#else /* CONFIG_ATA_SFF */
+static inline int sata_sff_hardreset(struct ata_link *link, unsigned int *class,
+				     unsigned long deadline)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* CONFIG_ATA_SFF */
 
 #endif /* __LINUX_LIBATA_H__ */
-- 
2.53.0



