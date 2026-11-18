Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059250;
	b=l22Af6kDkMkH+8GHJeJjc7Z26pRH41kVidfrC/1GjDs442bD0T7amSC377tsmcL0TU8W
	 Gb6nHlUK9EhdPEHeCaffBnKY4ycgwNCLwf7ii1bgrNd4TzCMOIeANd/i4t/0hZs1mE/CE
	 kC+N9RT7EZEhQxn1HA8Fbef4ThD7BTRQ+U4nAK1MnZJo4ow6cDW1GJVEhg1+QFv7CCJ0u
	 sL6nslvyCwJrQBIsGKrcUN3m9XsR+aLVEJwSSvlNZgvPkdlbEK8GqnysLoF/OGA8tPl6q
	 BUY/p4xgBOoBMJ02G5AhkKodCVtvkezIbgh42xUOzzp2IjbincXQMZUkFzEpn6cIMEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059250;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TjAhbxJI4i00fguW8ZNs4ANv5ITXmHJs638VH8FWu1o=;
	b=4Vq7UeoPr35ira40mdOKpi0VoR2b/PFRGwtNT2ZZ61pd221zIadTe++KTJ1i/6Hwh/v9
	 8bIJMISd9phBtRqeqP2k5zYtqGd+Yanvyd9FhxPP/4mkDD3t1eHrU5Ofkj//PYrJo7c0M
	 P/OKxpll+37YL/B8l4t3dYr2inwkdnwzyU4dfHts4sFASIcT+rYZ9h5FIHMNbMFQsXVU9
	 +6HxyQEd5oKESK9qKFwVDr4Pv+GNCmTB1kIh7xO1DFLI7BkVQXkJVNffPnvKLk6gWbUu/
	 ixq8nSMU+q/XceL/WxoEcehlS3N1yojrQEBWL0Q9dogK0Ac1cWBKesnchvgvc/1vMUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fDBvRn9s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A617F606A31C;
	Thu, 19 Nov 2026 03:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fDBvRn9s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025FA1F000C4;
	Thu, 19 Nov 2026 03:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059250;
	bh=TjAhbxJI4i00fguW8ZNs4ANv5ITXmHJs638VH8FWu1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fDBvRn9sTRpInkVNLOHwdAIoZEe+qy733ToDkED5ynhQBSEsIdxMKNITrCOcIvpP4
	 G3KlRDpovb0Xpky/IisbadVUncyUCfTHTpoTEd8+Dx6pYnlW1lR2gmYpb0JaDt0Vpl
	 uLgXk7ytf5A0DlGtBSj7RS4e0XrehJ/qtXL6TSDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Gongyi <zhaogongyi@bytedance.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0775/1848] ata: libata-scsi: reject data-in commands with a data-out buffer
Date: Wed, 18 Nov 2026 15:46:53 +0100
Message-ID: <20261118145948.872628838@linuxfoundation.org>
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

From: Zhao Gongyi <zhaogongyi@bytedance.com>

[ Upstream commit a4845f077415ef32fe672c841e2fc58ae9e28273 ]

SG_IO can submit a data-in SCSI command with DMA_TO_DEVICE. The
scatterlist can then contain pages pinned without write access.
ata_scsi_rbuf_fill() writes simulated replies to that scatterlist;
in the reported case, the copy tried to write the shared zero page
and faulted in the kernel.

The same mismatch can affect SG_IO commands translated by libata.
ZBC IN and GET PHYSICAL ELEMENT STATUS completion handlers can modify
the receive buffer even if the drive aborts the command. For ATAPI,
the successful INQUIRY completion also rewrites the buffer in
atapi_fixup_inquiry().

Reject these mismatched commands before the buffer is written or the
command is issued. Report ABORTED COMMAND / DATA IN BUFFER ERROR because
the CDB itself can be valid; the supplied transfer direction is wrong.

Backport notes: Use the older five-argument ata_scsi_set_sense()
interface and spell DATA IN BUFFER ERROR as ASC/ASCQ 0x4b/0x0a.
The older ata_scsi_rbuf_fill() takes struct ata_scsi_args;
get the device and command from args, and reject before copying.
In 5.10, reject before ata_scsi_rbuf_get(), since its matching
ata_scsi_rbuf_put() copies the simulated reply to the buffer.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://lore.kernel.org/r/20261104130638.37882-1-zhaogongyi@bytedance.com
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Gongyi <zhaogongyi@bytedance.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-scsi.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 77f121266b636..d3791425b9335 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1764,6 +1764,18 @@ static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cmd,
 	if (xlat_func(qc))
 		goto done;
 
+	/*
+	 * A data-out request may contain pages pinned without write access.
+	 * Reject a translated data-in command before issuing it, since its
+	 * completion handler may write to the buffer even if the device fails.
+	 */
+	if (unlikely(cmd->sc_data_direction == DMA_TO_DEVICE &&
+		     ata_is_data(qc->tf.protocol) &&
+		     !(qc->tf.flags & ATA_TFLAG_WRITE))) {
+		ata_scsi_set_sense(dev, cmd, ABORTED_COMMAND, 0x4b, 0x0a);
+		goto done;
+	}
+
 	return ata_scsi_qc_issue(ap, qc);
 
 done:
@@ -1849,6 +1861,12 @@ static void ata_scsi_rbuf_fill(struct ata_scsi_args *args,
 	struct scsi_cmnd *cmd = args->cmd;
 	unsigned long flags;
 
+	/* A data-out request may contain pages pinned without write access. */
+	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
+		ata_scsi_set_sense(args->dev, cmd, ABORTED_COMMAND, 0x4b, 0x0a);
+		return;
+	}
+
 	rbuf = ata_scsi_rbuf_get(cmd, false, &flags);
 	rc = actor(args, rbuf);
 	ata_scsi_rbuf_put(cmd, rc == 0, &flags);
@@ -2674,6 +2692,13 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 
 	qc->complete_fn = atapi_qc_complete;
 
+	/* atapi_fixup_inquiry() writes to the buffer on successful completion. */
+	if (scmd->sc_data_direction == DMA_TO_DEVICE &&
+	    scmd->cmnd[0] == INQUIRY) {
+		ata_scsi_set_sense(dev, scmd, ABORTED_COMMAND, 0x4b, 0x0a);
+		return 1;
+	}
+
 	qc->tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
 	if (scmd->sc_data_direction == DMA_TO_DEVICE) {
 		qc->tf.flags |= ATA_TFLAG_WRITE;
-- 
2.53.0



