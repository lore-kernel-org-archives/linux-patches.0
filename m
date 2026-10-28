Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214555;
	b=lAIYKl1DVTLUXVEofcyM8H5IoODmI1wHkEzqrtxTb5J6viTlwmBKt8alqhWZZGky9Hh5
	 jny58bWfBoJdyOLBcm0byz+6gCsNa+8RyiGIRPj9c7Vb8YGSz1H8Vv3WCHKZM4XRM44Oy
	 JeWN8O2gtB0wEeWmNuj4qgsZNArm5gY48tcNl1+tDGnRo7kxdF2xTsOUtnG0wF9qal9Ut
	 a02LoEg+zsK7N7mAIEujhrUqKsMLSUT2XLxcPUMZiYaYL0NkEoAL2pzvM8b/eRsOsSQw/
	 qnB6gv1ZnD22Jcy6Dxon+XiBm4b/XBoZabiBPnWB5RXmsvKTKsaLjcnK3v3LhfS9pDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214555;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3gy9IMBPn6lBugUFbWYc5iCmzU0yCidI0p8MIe0+hqE=;
	b=nP12lL+IgwuqAhNHGS8946XGtynrXIwTuxsGAJbcLd5jjwT9vS20Ku03hzvG+oPSnqeu
	 u2tnugBQqYfctjsseqBPecCbfDcHPtfU1am/ArEwpTApbxUt8cFbQUSYlJ/fpqIhqPP95
	 mfpLHQ+0uF462hCdOKGCSJFk0dCscmvtRxhh2VbM7S7IHUQQz7dHHaKSYg7z/gga+cbRy
	 j04cFoc1dScwYwohv81ikYGrfuyCWNVv7vo38FJtsyc5RY5/gvGMQfSEDby8u73T0OpPr
	 YB2BQUAMH54k9VCExbBZwh0ua495OVtv8mxLOOipRAT2aMwlopDRmFRdMGCFluXPFDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M+VYS7EJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73360606BFB3;
	Wed, 28 Oct 2026 19:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M+VYS7EJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DC41F01825;
	Wed, 28 Oct 2026 19:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214555;
	bh=3gy9IMBPn6lBugUFbWYc5iCmzU0yCidI0p8MIe0+hqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M+VYS7EJBYdMwUMIzmoAcxlOntmcDqV/OtBOpGjrciDyOla57ayRisduWiFjB8c3h
	 0fkpLMxYTpo+gPUVrz4OpBukTPHarmASRm+SM9NyaFvPiYvJoIQrFxifdBNLYO7fGi
	 qQAjs3cqHYlC2CZF/sirJaOq8PVSv6OBSq0ABv7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	Tony Battersby <tonyb@cybernetics.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0898/1887] scsi: qla2xxx: Clear cmds after chip reset
Date: Wed, 28 Oct 2026 17:49:54 +0100
Message-ID: <20261028170519.853034788@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Tony Battersby <tonyb@cybernetics.com>

[ Upstream commit d46c69a087aa3d1513f7a78f871b80251ea0c1ae ]

Commit aefed3e5548f ("scsi: qla2xxx: target: Fix offline port handling
and host reset handling") caused two problems:

1. Commands sent to FW, after chip reset got stuck and never freed as FW
   is not going to respond to them anymore.

2. BUG_ON(cmd->sg_mapped) in qlt_free_cmd().  Commit 26f9ce53817a
   ("scsi: qla2xxx: Fix missed DMA unmap for aborted commands")
   attempted to fix this, but introduced another bug under different
   circumstances when two different CPUs were racing to call
   qlt_unmap_sg() at the same time: BUG_ON(!valid_dma_direction(dir)) in
   dma_unmap_sg_attrs().

So revert "scsi: qla2xxx: Fix missed DMA unmap for aborted commands" and
partially revert "scsi: qla2xxx: target: Fix offline port handling and
host reset handling" at __qla2x00_abort_all_cmds.

Fixes: aefed3e5548f ("scsi: qla2xxx: target: Fix offline port handling and host reset handling")
Fixes: 26f9ce53817a ("scsi: qla2xxx: Fix missed DMA unmap for aborted commands")
Co-developed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Link: https://patch.msgid.link/0e7e5d26-e7a0-42d1-8235-40eeb27f3e98@cybernetics.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c     | 20 ++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_target.c |  5 +----
 drivers/scsi/qla2xxx/qla_target.h |  1 +
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 0b21fb29a9fc5..38e2b31237025 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1883,10 +1883,26 @@ __qla2x00_abort_all_cmds(struct qla_qpair *qp, int res)
 					continue;
 				}
 				cmd = (struct qla_tgt_cmd *)sp;
-				cmd->aborted = 1;
+
+				if (cmd->sg_mapped)
+					qlt_unmap_sg(vha, cmd);
+
+				if (cmd->state == QLA_TGT_STATE_NEED_DATA) {
+					cmd->aborted = 1;
+					cmd->write_data_transferred = 0;
+					cmd->state = QLA_TGT_STATE_DATA_IN;
+					ha->tgt.tgt_ops->handle_data(cmd);
+				} else {
+					ha->tgt.tgt_ops->free_cmd(cmd);
+				}
 				break;
 			case TYPE_TGT_TMCMD:
-				/* Skip task management functions. */
+				/*
+				 * Currently, only ABTS response gets on the
+				 * outstanding_cmds[]
+				 */
+				ha->tgt.tgt_ops->free_mcmd(
+					(struct qla_tgt_mgmt_cmd *) sp);
 				break;
 			default:
 				break;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 043cfa10c7167..7136ec5ded35b 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2504,7 +2504,7 @@ static int qlt_pci_map_calc_cnt(struct qla_tgt_prm *prm)
 	return -1;
 }
 
-static void qlt_unmap_sg(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd)
+void qlt_unmap_sg(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd)
 {
 	struct qla_hw_data *ha;
 	struct qla_qpair *qpair;
@@ -3834,9 +3834,6 @@ int qlt_abort_cmd(struct qla_tgt_cmd *cmd)
 
 	spin_lock_irqsave(&cmd->cmd_lock, flags);
 	if (cmd->aborted) {
-		if (cmd->sg_mapped)
-			qlt_unmap_sg(vha, cmd);
-
 		spin_unlock_irqrestore(&cmd->cmd_lock, flags);
 		/*
 		 * It's normal to see 2 calls in this path:
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 7df86578214f1..e674a81eb527f 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -1060,6 +1060,7 @@ extern int qlt_abort_cmd(struct qla_tgt_cmd *);
 extern void qlt_xmit_tm_rsp(struct qla_tgt_mgmt_cmd *);
 extern void qlt_free_mcmd(struct qla_tgt_mgmt_cmd *);
 extern void qlt_free_cmd(struct qla_tgt_cmd *cmd);
+extern void qlt_unmap_sg(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd);
 extern void qlt_async_event(uint16_t, struct scsi_qla_host *, uint16_t *);
 extern void qlt_enable_vha(struct scsi_qla_host *);
 extern void qlt_vport_create(struct scsi_qla_host *, struct qla_hw_data *);
-- 
2.53.0



