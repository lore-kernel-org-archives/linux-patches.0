Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5573FE2D;
	Mon,  1 Apr 2024 16:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987770; cv=none; b=NiZhdgT6Vi0u3Kb+fktzb1etVV3kzlITrnRK06xrvvJpYgMumOvvNkJ0Wb+YXYlibiu9yRx6YWELIo5BxOi4j/870Bs/kBG2TJChGpnidplUaQqTM1cwU18/oNlmnJ2iOStlfmiv4gzlpwtJTXMz/m55oH96lU2CJ9eOvxky+ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987770; c=relaxed/simple;
	bh=zU/kVcYKRiRoEqCQMrtrDegs0NTkmTLleuJrHeP1xWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvC5zMfLTRSBoqWFxmwJElXofXT6KZY0qkEOUCiTnjWPIK83NWwqeRI88BCoEEUgqFmXkEWSdEVfxj+T4/bUWx0CWhh5u8Tntzm9xWoj8nnFw19EafK8WR1nTQeSFTY5VdQkI4q5TD83idf7IQ9JB1bMBhemjV6d9buJMOdUcJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nhzfgjLP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nhzfgjLP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801F2C433F1;
	Mon,  1 Apr 2024 16:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987770;
	bh=zU/kVcYKRiRoEqCQMrtrDegs0NTkmTLleuJrHeP1xWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nhzfgjLPBRXh4FDmMU63l6JWiJtfq4M4ITvWZIBG83HjtymIoHXbKc5eQgcdcf2tX
	 Phvx1JtEaW7qkcJRFgbcLlXnsJQyIaghLO2Tzq3jVHehr+OULMXcHpw9trNbBn+zyV
	 CyqddmLKNzLmOXb2SVfUoaLX4bhIB85jvUuFagEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.8 385/399] scsi: qla2xxx: Change debug message during driver unload
Date: Mon,  1 Apr 2024 17:45:51 +0200
Message-ID: <20240401152600.666326589@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saurav Kashyap <skashyap@marvell.com>

commit b5a30840727a3e41d12a336d19f6c0716b299161 upstream.

Upon driver unload, purge_mbox flag is set and the heartbeat monitor thread
detects this flag and does not send the mailbox command down to FW with a
debug message "Error detected: purge[1] eeh[0] cmd=0x0, Exiting".  This
being not a real error, change the debug message.

Cc: stable@vger.kernel.org
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20240227164127.36465-10-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -194,7 +194,7 @@ qla2x00_mailbox_command(scsi_qla_host_t
 	if (ha->flags.purge_mbox || chip_reset != ha->chip_reset ||
 	    ha->flags.eeh_busy) {
 		ql_log(ql_log_warn, vha, 0xd035,
-		       "Error detected: purge[%d] eeh[%d] cmd=0x%x, Exiting.\n",
+		       "Purge mbox: purge[%d] eeh[%d] cmd=0x%x, Exiting.\n",
 		       ha->flags.purge_mbox, ha->flags.eeh_busy, mcp->mb[0]);
 		rval = QLA_ABORTED;
 		goto premature_exit;


