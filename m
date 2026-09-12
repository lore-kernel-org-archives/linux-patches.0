Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205DD1FBEA6;
	Sat, 12 Sep 2026 19:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242684; cv=none; b=oKHGzb4jx0xgm3RO7YCy2AJI8qSl1e5nah37cCdbtNTpJkRcXeDLQdCW6XfiDziKJWbwn5l3qKN+OwVW7GbTN7nS418uv6qR2oy577cKRTuNHXFXYVViIilPkODKM4fHaZjTWfN1y7VlXvjWlonjUQ5oYBB7I+rkv4bkzk3r5k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242684; c=relaxed/simple;
	bh=CLKZTDuTw7aVFeUrxfdeFfAd5NRKslEO1eqbqGLN4cY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2cnPyCTiIN6HldGgzAPCSFqQ+mOZFSJx+e2NtThSGTYZpdG4DsKffLxXmVkvZdk43MXWBEEUsT00EkzsZCZvONSE2e15ZR+xNZRD6uS38h0YDaS6cWd7LD+/XW9U6j0yrspHAS1UTQt2r2y/akWkoURb/YGwnWMTnIEpe4iruA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gkhK9WXy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gkhK9WXy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D251F000FF;
	Sat, 12 Sep 2026 19:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242683;
	bh=sAawET8o3fZIeT3A2t2EYr2+Csw0+pNo4NNdUfxmSmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gkhK9WXya0CxUcl1+2tAvysQW48yyMV4Q+3zcHUFSQrP8s/ZhlVQAL+X3TzkxWtQ/
	 hGabOSWg+lI71RKHvvQu1KYJq7ez/ht0t0iPUilxZxTZJ1zopeFPa01Zf9tMCJFE46
	 2aMrSzX/a4C8xwtX7bHE4ShPP22afxSusoEt1ErU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 490/798] scsi: target: core: Rename transport_init_se_cmd()
Date: Sat, 12 Sep 2026 09:01:58 +0200
Message-ID: <20260912065528.370869044@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit a78b713618c02752310b2be7da465a34fb660ed9 ]

Rename transport_init_se_cmd() to __target_init_cmd() to reflect that it is
more of an internal function that drivers should normally not use and
because we are going to add a new init function in the next patches.

Link: https://lore.kernel.org/r/20210227170006.5077-4-michael.christie@oracle.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: ef63cc441703 ("RDMA/srpt: Pass the mapped task attribute to target_init_cmd()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/iscsi/iscsi_target.c    | 16 ++++++++--------
 drivers/target/target_core_transport.c | 16 ++++++++--------
 drivers/target/target_core_xcopy.c     |  8 ++++----
 drivers/usb/gadget/function/f_tcm.c    | 20 ++++++++++----------
 include/target/target_core_fabric.h    |  2 +-
 5 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index c7941130db84d..17835c878caeb 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1154,10 +1154,10 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	/*
 	 * Initialize struct se_cmd descriptor from target_core_mod infrastructure
 	 */
-	transport_init_se_cmd(&cmd->se_cmd, &iscsi_ops,
-			conn->sess->se_sess, be32_to_cpu(hdr->data_length),
-			cmd->data_direction, sam_task_attr,
-			cmd->sense_buffer + 2, scsilun_to_int(&hdr->lun));
+	__target_init_cmd(&cmd->se_cmd, &iscsi_ops,
+			 conn->sess->se_sess, be32_to_cpu(hdr->data_length),
+			 cmd->data_direction, sam_task_attr,
+			 cmd->sense_buffer + 2, scsilun_to_int(&hdr->lun));
 
 	pr_debug("Got SCSI Command, ITT: 0x%08x, CmdSN: 0x%08x,"
 		" ExpXferLen: %u, Length: %u, CID: %hu\n", hdr->itt,
@@ -2012,10 +2012,10 @@ iscsit_handle_task_mgt_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 					     buf);
 	}
 
-	transport_init_se_cmd(&cmd->se_cmd, &iscsi_ops,
-			      conn->sess->se_sess, 0, DMA_NONE,
-			      TCM_SIMPLE_TAG, cmd->sense_buffer + 2,
-			      scsilun_to_int(&hdr->lun));
+	__target_init_cmd(&cmd->se_cmd, &iscsi_ops,
+			  conn->sess->se_sess, 0, DMA_NONE,
+			  TCM_SIMPLE_TAG, cmd->sense_buffer + 2,
+			  scsilun_to_int(&hdr->lun));
 
 	target_get_sess_cmd(&cmd->se_cmd, true);
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 57b6a94981cdc..b382ad9cebed3 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1295,7 +1295,7 @@ target_check_max_data_sg_nents(struct se_cmd *cmd, struct se_device *dev,
  * Compare the data buffer size from the CDB with the data buffer limit from the transport
  * header. Set @cmd->residual_count and SCF_OVERFLOW_BIT or SCF_UNDERFLOW_BIT if necessary.
  *
- * Note: target drivers set @cmd->data_length by calling transport_init_se_cmd().
+ * Note: target drivers set @cmd->data_length by calling __target_init_cmd().
  *
  * Return: TCM_NO_SENSE
  */
@@ -1367,7 +1367,7 @@ target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
  *
  * Preserves the value of @cmd->tag.
  */
-void transport_init_se_cmd(
+void __target_init_cmd(
 	struct se_cmd *cmd,
 	const struct target_core_fabric_ops *tfo,
 	struct se_session *se_sess,
@@ -1400,7 +1400,7 @@ void transport_init_se_cmd(
 
 	cmd->state_active = false;
 }
-EXPORT_SYMBOL(transport_init_se_cmd);
+EXPORT_SYMBOL(__target_init_cmd);
 
 static sense_reason_t
 transport_check_alloc_task_attr(struct se_cmd *cmd)
@@ -1625,9 +1625,9 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 	 * exceptions are handled by sending exception status via
 	 * target_core_fabric_ops->queue_status() callback
 	 */
-	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
-				data_length, data_dir, task_attr, sense,
-				unpacked_lun);
+	__target_init_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
+			  data_length, data_dir, task_attr, sense,
+			  unpacked_lun);
 
 	if (flags & TARGET_SCF_UNKNOWN_SIZE)
 		se_cmd->unknown_data_length = 1;
@@ -1800,8 +1800,8 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 	se_tpg = se_sess->se_tpg;
 	BUG_ON(!se_tpg);
 
-	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
-			      0, DMA_NONE, TCM_SIMPLE_TAG, sense, unpacked_lun);
+	__target_init_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
+			  0, DMA_NONE, TCM_SIMPLE_TAG, sense, unpacked_lun);
 	/*
 	 * FIXME: Currently expect caller to handle se_cmd->se_tmr_req
 	 * allocation failure.
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 66d6f1d06f219..e86cc61355870 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -615,8 +615,8 @@ static int target_xcopy_read_source(
 	pr_debug("XCOPY: Built READ_16: LBA: %llu Sectors: %u Length: %u\n",
 		(unsigned long long)src_lba, src_sectors, length);
 
-	transport_init_se_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, length,
-			      DMA_FROM_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0);
+	__target_init_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, length,
+			  DMA_FROM_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0);
 
 	rc = target_xcopy_setup_pt_cmd(&xpt_cmd, xop, src_dev, &cdb[0],
 				remote_port);
@@ -660,8 +660,8 @@ static int target_xcopy_write_destination(
 	pr_debug("XCOPY: Built WRITE_16: LBA: %llu Sectors: %u Length: %u\n",
 		(unsigned long long)dst_lba, dst_sectors, length);
 
-	transport_init_se_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, length,
-			      DMA_TO_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0);
+	__target_init_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, length,
+			  DMA_TO_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0);
 
 	rc = target_xcopy_setup_pt_cmd(&xpt_cmd, xop, dst_dev, &cdb[0],
 				remote_port);
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 6c805bf8888e7..b8f6c15218807 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1041,11 +1041,11 @@ static void usbg_cmd_work(struct work_struct *work)
 
 	dir = get_cmd_dir(cmd->cmd_buf);
 	if (dir < 0) {
-		transport_init_se_cmd(se_cmd,
-				tv_nexus->tvn_se_sess->se_tpg->se_tpg_tfo,
-				tv_nexus->tvn_se_sess, cmd->data_len, DMA_NONE,
-				cmd->prio_attr, cmd->sense_iu.sense,
-				cmd->unpacked_lun);
+		__target_init_cmd(se_cmd,
+				  tv_nexus->tvn_se_sess->se_tpg->se_tpg_tfo,
+				  tv_nexus->tvn_se_sess, cmd->data_len, DMA_NONE,
+				  cmd->prio_attr, cmd->sense_iu.sense,
+				  cmd->unpacked_lun);
 		goto out;
 	}
 
@@ -1178,11 +1178,11 @@ static void bot_cmd_work(struct work_struct *work)
 
 	dir = get_cmd_dir(cmd->cmd_buf);
 	if (dir < 0) {
-		transport_init_se_cmd(se_cmd,
-				tv_nexus->tvn_se_sess->se_tpg->se_tpg_tfo,
-				tv_nexus->tvn_se_sess, cmd->data_len, DMA_NONE,
-				cmd->prio_attr, cmd->sense_iu.sense,
-				cmd->unpacked_lun);
+		__target_init_cmd(se_cmd,
+				  tv_nexus->tvn_se_sess->se_tpg->se_tpg_tfo,
+				  tv_nexus->tvn_se_sess, cmd->data_len, DMA_NONE,
+				  cmd->prio_attr, cmd->sense_iu.sense,
+				  cmd->unpacked_lun);
 		goto out;
 	}
 
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 8a490a0b2b66e..f9a3f4c8c480f 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -150,7 +150,7 @@ void	transport_deregister_session_configfs(struct se_session *);
 void	transport_deregister_session(struct se_session *);
 
 
-void	transport_init_se_cmd(struct se_cmd *,
+void	__target_init_cmd(struct se_cmd *,
 		const struct target_core_fabric_ops *,
 		struct se_session *, u32, int, int, unsigned char *, u64);
 sense_reason_t transport_lookup_cmd_lun(struct se_cmd *);
-- 
2.53.0



