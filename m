Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046578;
	b=NqSZCtkjhWE02WF8tIOxSAA6w0y+3ty4eh2NYNTfRN+A6IKM7PVmWMaxg2UuPwIKO2pc
	 61Q+pGt0EDO5JP8tOcV+znEi1VnMDL1deMyKCa4cat6Xne5SVBDjqn9aDfIX/MIjLhE2q
	 EuTfHR8AIkOonOQy6CvXzRLGSKnDq0gIcT6l2VV4FbQppDkUvKXAI1pOS3H/2mPctdXZP
	 +Vb5VcT30jyRctnDima0xnu+nlsH2I35qt6k3VnEftDn8+S5ZLqURlzvMWQjMYOmf8exG
	 NAMu08wq4q7SbjOL512zoVcTfPU2zqNzIlPIwh4IHdmTWFi8a1FSyDC85GomWx6MM3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046578;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=REoydpm47hQvNN4jz++njiZk4OsiWgX9cxlBsOHGSVg=;
	b=dFD+e2g4Lerudpt1tv6SvdbCgP2JPBuAmba0EFuHZqqtnDx/2f0lEJUVpQ103TOqcA9m
	 oUp81WLf2V18DGmdG+NngY3Tt6idiQX2EDM+SH+yrCZRk6YqBjyoCnbMs1iyjWFw4uS97
	 PtxnahTqr1VZ1JzrfExK9wSNo1YSnGtWp3zV4JWxrQaTEjtP4r0DWPhiuGzqpZAjG5Mjv
	 +bwbbuwbm5aXhd8plzEH+ziRRxAnJDuuAD6oKD0B6ipyZAP+wuCCjMmChbcY5msF8j9JY
	 IE4SeCtS8T2oTtb7WUHSRgrCGm0SRAaGbnizUbr4WTz8VOFxh2YdD+DaeG0gfFFXQIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V8DcyU8V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E871606A325;
	Thu, 19 Nov 2026 00:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V8DcyU8V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FD41F000C4;
	Thu, 19 Nov 2026 00:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046578;
	bh=REoydpm47hQvNN4jz++njiZk4OsiWgX9cxlBsOHGSVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V8DcyU8V7tIWFjigkAoK+qXIwkQDr0DQfCa/YJ5mDN4glLNQAk5MBaiX4Ox86BBMy
	 q5lkMFzAu1fBOLfairQYiPmpNOHZAxAzuP3VXIrGNx9e0cU3HoLtmKl5Tg53CVSqsd
	 OuslWIfXkmdpomBmeXLqM7B9zRe5OGbv/eJeQyEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Gongyi <zhaogongyi@bytedance.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1329/2857] ata: libata-scsi: reject data-in commands with a data-out buffer
Date: Wed, 18 Nov 2026 15:39:23 +0100
Message-ID: <20261118150249.290374458@linuxfoundation.org>
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
index ed15d11cf9fcd..87ef473d22791 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1911,6 +1911,18 @@ static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cmd,
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
@@ -1947,6 +1959,12 @@ static void ata_scsi_rbuf_fill(struct ata_scsi_args *args,
 	struct scsi_cmnd *cmd = args->cmd;
 	unsigned long flags;
 
+	/* A data-out request may contain pages pinned without write access. */
+	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
+		ata_scsi_set_sense(args->dev, cmd, ABORTED_COMMAND, 0x4b, 0x0a);
+		return;
+	}
+
 	spin_lock_irqsave(&ata_scsi_rbuf_lock, flags);
 
 	memset(ata_scsi_rbuf, 0, ATA_SCSI_RBUF_SIZE);
@@ -2772,6 +2790,13 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 
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



