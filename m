Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585867;
	b=ftKHqI+ieBMT3RWf1Vh+ZLf4nc1N0QAvo7BOnz8DwU/v0UWQEYW6iIQXBPTqMZriXzPq
	 hw1Fm3p9n4GGzH2G1AwhBw9JOqMVMDwwRslXY9W6nk7y4Pz/D+lwa0G50MF7nw1X3Glr0
	 63WhGI1Xq0f+EQHEJiqeoRLaQPOkTblt5+7kx5VF/5Gubq9lUAmi5+LrcLaiZHSW2ucsT
	 xxeGVIwtWzh0Tfj1DKmi3qdYyKMAs7Gbz6C8rdRzqoXKIQjf7fGkwEcKocSl1U9WtC10l
	 ItUbiDd+JNVTBUXd3ARP2CP2RAa1+6+S2W0XEQLMpJVJeJ2tQgdVZMkfLCO41hWsT0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585867;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8liOu5mEdUuION2PNajMeeViXr0CCi02uf+h9+4X6uE=;
	b=GDt7je56n1slGDddJ2fhf4DHXDvgsBQkTXE62IFRJTeYagqC/UddQhH1L100Gl5N02be
	 j9c3EKrFtT3GwNkJqiH7TfZ0byPSZlBEiTjrdmdOIj6zi9N9PBvaLsr74wZZTY01rkutW
	 dCEiMR+/MwTy4j44YGyDoI6MYBpfY0l6EmZf/APzVFmpEDtl9TqWWHQ8+P8kD8PTx6mhJ
	 Gxt1h4CCLdZkJO3AeQ/2kIGKqIiaE/A629yt4uf0tCDyPs+wGT+3o08QIW/BRu43lLjkO
	 L1X/ChXfOgP22ztNUFY+apXXggGhlS+3SHPp1oPs+vVPNm2GoAtQi2dbp7tfrNesjvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wUhAQkWA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AE5606BAB8;
	Fri, 13 Nov 2026 16:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wUhAQkWA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435261F000C4;
	Fri, 13 Nov 2026 16:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585867;
	bh=8liOu5mEdUuION2PNajMeeViXr0CCi02uf+h9+4X6uE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wUhAQkWA0ntsT/ipOJrgM9BPvILMbz15xnjEip0zNirZZPiIV67y3YYh64XOikjll
	 r5Lr1xo702TYGXb1KFmaowpt/exFTPpRwHDahB7QRcTpfwz09k15oD35cX8aD/BtBj
	 1dW8X0x8EtDYeL1NkvV0TNij/bcliFDPIWTJFvnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Gongyi <zhaogongyi@bytedance.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 440/507] ata: libata-scsi: reject data-in commands with a data-out buffer
Date: Fri, 13 Nov 2026 10:52:24 -0500
Message-ID: <20261113153811.650813679@linuxfoundation.org>
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
index b86ac50f16b9e..023de0e633b71 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1984,6 +1984,18 @@ static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cmd,
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
@@ -2015,6 +2027,12 @@ static void ata_scsi_rbuf_fill(struct ata_device *dev, struct scsi_cmnd *cmd,
 	unsigned long flags;
 	unsigned int len;
 
+	/* A data-out request may contain pages pinned without write access. */
+	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
+		ata_scsi_set_sense(dev, cmd, ABORTED_COMMAND, 0x4b, 0x0a);
+		return;
+	}
+
 	spin_lock_irqsave(&ata_scsi_rbuf_lock, flags);
 
 	memset(ata_scsi_rbuf, 0, ATA_SCSI_RBUF_SIZE);
@@ -3108,6 +3126,13 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 
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



