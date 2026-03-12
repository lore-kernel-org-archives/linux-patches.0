Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5566F3FFABE;
	Thu, 12 Mar 2026 20:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346500; cv=none; b=u2uRjWGImBgsuAdvYwA78ooIAXdxfjV+kLiGihOefgHPJTRjdGVMkBS+AwQqqHNASr+cNLzySfAf2DGmoFvvgENHHP7K/elm2PcPLBDUEDZivGMxaFmUOjvG3qqTnH+qIvcc4DLIV9DBtK7q+QXZiK8/OVfgHj7X8IhX7YFkU+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346500; c=relaxed/simple;
	bh=d38/I7j/qgY3iK8awpho3NnTIYL11B0uzJb4EHcq95s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gmBRHU0TV7QdEftpgVZsxhQbDpPruuk6TUsTAS5Su0R5oYLFcS6gTixujvJjzKBG5dhatlk2UcDJrftkgZ6yFmRK+yFrPAEzmzj1bjvTcS59eZ5CMtXEXetGulSwWokRdXNM100j9OBau1FDWnIgvOx2x006O4dCXQGeWYADWmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cS8L5nMv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cS8L5nMv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988D4C4CEF7;
	Thu, 12 Mar 2026 20:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346500;
	bh=d38/I7j/qgY3iK8awpho3NnTIYL11B0uzJb4EHcq95s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cS8L5nMvWEFB+/X6TJlL6ekGSxUlsRkiTDlSHKhAR/JksLbgtrayamxi3tkMSXxkT
	 Hp8aS5Jt/XKQEDEpBZLhCgcw9uPf1+s8xn1rClWXKZD9wk3oGwiS/TLUg0wePutpei
	 +2yrr41LRI5Y7Pb7QgqlBwZlBrg4oEbD6eQYSVd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 058/265] ata: libata-scsi: Document all VPD page inquiry actors
Date: Thu, 12 Mar 2026 21:07:25 +0100
Message-ID: <20260312201020.307485648@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit 47000e84b3d0630d7d86eeb115894205be68035d ]

Add the missing kdoc comments for the ata_scsiop_inq_XX functions used
to emulate access to VPD pages.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20241022024537.251905-5-dlemoal@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Stable-dep-of: 0ea84089dbf6 ("ata: libata-scsi: avoid Non-NCQ command starvation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 54 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index c214f0832714c..a38d912a0497b 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2086,6 +2086,16 @@ static unsigned int ata_scsiop_inq_89(struct ata_scsi_args *args, u8 *rbuf)
 	return 0;
 }
 
+/**
+ *	ata_scsiop_inq_b0 - Simulate INQUIRY VPD page B0, Block Limits
+ *	@args: device IDENTIFY data / SCSI command of interest.
+ *	@rbuf: Response buffer, to which simulated SCSI cmd output is sent.
+ *
+ *	Return data for the VPD page B0h (Block Limits).
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
 static unsigned int ata_scsiop_inq_b0(struct ata_scsi_args *args, u8 *rbuf)
 {
 	struct ata_device *dev = args->dev;
@@ -2126,6 +2136,17 @@ static unsigned int ata_scsiop_inq_b0(struct ata_scsi_args *args, u8 *rbuf)
 	return 0;
 }
 
+/**
+ *	ata_scsiop_inq_b1 - Simulate INQUIRY VPD page B1, Block Device
+ *			    Characteristics
+ *	@args: device IDENTIFY data / SCSI command of interest.
+ *	@rbuf: Response buffer, to which simulated SCSI cmd output is sent.
+ *
+ *	Return data for the VPD page B1h (Block Device Characteristics).
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
 static unsigned int ata_scsiop_inq_b1(struct ata_scsi_args *args, u8 *rbuf)
 {
 	int form_factor = ata_id_form_factor(args->id);
@@ -2143,6 +2164,17 @@ static unsigned int ata_scsiop_inq_b1(struct ata_scsi_args *args, u8 *rbuf)
 	return 0;
 }
 
+/**
+ *	ata_scsiop_inq_b2 - Simulate INQUIRY VPD page B2, Logical Block
+ *			    Provisioning
+ *	@args: device IDENTIFY data / SCSI command of interest.
+ *	@rbuf: Response buffer, to which simulated SCSI cmd output is sent.
+ *
+ *	Return data for the VPD page B2h (Logical Block Provisioning).
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
 static unsigned int ata_scsiop_inq_b2(struct ata_scsi_args *args, u8 *rbuf)
 {
 	/* SCSI Thin Provisioning VPD page: SBC-3 rev 22 or later */
@@ -2153,6 +2185,17 @@ static unsigned int ata_scsiop_inq_b2(struct ata_scsi_args *args, u8 *rbuf)
 	return 0;
 }
 
+/**
+ *	ata_scsiop_inq_b6 - Simulate INQUIRY VPD page B6, Zoned Block Device
+ *			    Characteristics
+ *	@args: device IDENTIFY data / SCSI command of interest.
+ *	@rbuf: Response buffer, to which simulated SCSI cmd output is sent.
+ *
+ *	Return data for the VPD page B2h (Zoned Block Device Characteristics).
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
 static unsigned int ata_scsiop_inq_b6(struct ata_scsi_args *args, u8 *rbuf)
 {
 	if (!(args->dev->flags & ATA_DFLAG_ZAC)) {
@@ -2178,6 +2221,17 @@ static unsigned int ata_scsiop_inq_b6(struct ata_scsi_args *args, u8 *rbuf)
 	return 0;
 }
 
+/**
+ *	ata_scsiop_inq_b9 - Simulate INQUIRY VPD page B9, Concurrent Positioning
+ *			    Ranges
+ *	@args: device IDENTIFY data / SCSI command of interest.
+ *	@rbuf: Response buffer, to which simulated SCSI cmd output is sent.
+ *
+ *	Return data for the VPD page B9h (Concurrent Positioning Ranges).
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
 static unsigned int ata_scsiop_inq_b9(struct ata_scsi_args *args, u8 *rbuf)
 {
 	struct ata_cpr_log *cpr_log = args->dev->cpr_log;
-- 
2.51.0



