Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053507;
	b=XsEIGsjNDFIR1X8DvYCWftse3aa9qfnoWrgBZkKfS+8CoUP9FBSZ0esRipVBPuZNLaSu
	 worG86IvAemDbC6mCegLwE0YCzWac7CkOCiss8DtNKLtuxE79Y53uwT7e/Qh1ddcaegxY
	 kr1K58iwNvpJf2CMjB0YRtxNQHFXVXmHxh3lsCfuJwfOIcp4O4MjBn/zo1ArHWK8YT8lD
	 xzsFQQSeK9/Pm+dDjDNS5UT+ircIpkIrKL4OG3pN/flRUQ/Vho3y/mBRrL5CpKmmaxqW6
	 XltVMFaii2rdbBewkCuJA6uujt317uuROTffR1Nm60YEnu8N9gg4GO12VD819osp4yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053507;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HaRDLiwc5iA/XaL1AG8px/gSePtCRIIxRp8eUy2ZHiQ=;
	b=X2oIHEWg52AAAV52gFIMBRFjBRnpE7YU0MVVYYMyLzn3fe62up93BhsFY4agX6bXL6nq
	 xgCgiyDcOuDCxc0thWEwAxxpJb2rXrbPpdWD1oKX2Rirqo19gTOk1tsM5OvjwG5qBQvju
	 TG0mCTmk12iTcJlMC5TXxIRTiPUY5xMRYQuCDjWZBtmMWny3TOlU7SBq5/CmwZF3xCEl2
	 Q17MGDhaXD80wnDZgU8jZiaLFQmuMGavppI2k+gsNgqzkSHkk1Q40D/g4bNIWJqw3I5wM
	 APMmV6/yqzysjYnoLLXtHmopRBOYKSJyFg5jKPxXMEsysywSM+Z3V0G1jO7g/ILa4ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TcpvBCXi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF062606A32A;
	Thu, 19 Nov 2026 01:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TcpvBCXi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F071F000C4;
	Thu, 19 Nov 2026 01:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053506;
	bh=HaRDLiwc5iA/XaL1AG8px/gSePtCRIIxRp8eUy2ZHiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TcpvBCXi0rqK3Xmni09LkTi99W0VECVmGGsBboNllAGI//IdDM3XNQampaTxnBtjF
	 Ib43VylGHHXxgRSxDr7mi3WEt51weMJDu9beeE5EKCksjEuZ3laCtG3POIGl8JO5YF
	 LLPLYy8gAuvQHIAxXesPQdsb2hs/bnLQCUDvlU08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Gongyi <zhaogongyi@bytedance.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0945/2214] ata: libata-scsi: reject data-in commands with a data-out buffer
Date: Wed, 18 Nov 2026 15:43:41 +0100
Message-ID: <20261118150050.149233390@linuxfoundation.org>
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
index 7725910eca0b6..81ed39f68c148 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1766,6 +1766,18 @@ static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cmd,
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
@@ -1802,6 +1814,12 @@ static void ata_scsi_rbuf_fill(struct ata_scsi_args *args,
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
@@ -2629,6 +2647,13 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 
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



