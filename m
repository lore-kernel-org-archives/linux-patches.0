Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF166BB29;
	Thu, 11 Apr 2024 10:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832563; cv=none; b=i5nD229r7A9YIw97RRlq/7R06Klni3XjvzNSCarRX7fdZRSJm/fgDtVyxP9zzrtwkuBx02OoBJ36ORbukYsIZdSXFvwsfhrzR8AJ7wH0Wx4qWSgNpijtJOAWfSSRh8rFL+T+GPd5wARE6XBBhkR6aWVK3iVoPr5I4WAuQr6uqpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832563; c=relaxed/simple;
	bh=Ak23/Z3uD5U5Xe+38VIea8bf1iipNBqFQTlIw6O1b3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dGwA0+7CTct5W9I+JZq+acVNDGmprdqQJClKomg+89kWy3keLs7iph3cYgydmzkt4vAF8aAQr479Fh6EZ+6lw9X0KVPY6glb5zysaTTd3IxvOVqZaDgd9fR5Gnc69kXYVCzO8dlczmnocXSqqzfKkVcOAehDXfQfR21K8PXp5x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lXC5B1OP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lXC5B1OP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43714C433C7;
	Thu, 11 Apr 2024 10:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832563;
	bh=Ak23/Z3uD5U5Xe+38VIea8bf1iipNBqFQTlIw6O1b3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lXC5B1OPlT1Obrr0kp+eiYtsgkjjOX2Gk79ZjT7xQGpQQSW2jo1t67m8hKxcO2nME
	 askVCKmOBd9RFJUREV53drUdmLhAZMB63QAeWbpiV6Ezx+AVktbsAnc54M4LAGUk3e
	 NkyAuKU8vmQOnBpbZvSQxOYZhJJnS1NjxDs4z3wg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tasos Sahanidis <tasos@tasossah.com>,
	"Ewan D. Milne" <emilne@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	James Bottomley <jejb@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>,
	John David Anglin <dave.anglin@bell.net>,
	Cyril Brulebois <kibi@debian.org>
Subject: [PATCH 6.1 75/83] Revert "scsi: core: Add struct for args to execution functions"
Date: Thu, 11 Apr 2024 11:57:47 +0200
Message-ID: <20240411095414.945859117@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit cf33e6ca12d814e1be2263cb76960d0019d7fb94 which is
commit d0949565811f0896c1c7e781ab2ad99d34273fdf upstream.

It is known to cause problems and has asked to be dropped.

Link: https://lore.kernel.org/r/yq1frvvpymp.fsf@ca-mkp.ca.oracle.com
Cc: Tasos Sahanidis <tasos@tasossah.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Tasos Sahanidis <tasos@tasossah.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: James Bottomley <jejb@linux.ibm.com>
Cc: Sasha Levin <sashal@kernel.org>
Reported-by: John David Anglin <dave.anglin@bell.net>
Reported-by: Cyril Brulebois <kibi@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_lib.c    |   52 +++++++++++++++++++++++----------------------
 include/scsi/scsi_device.h |   51 ++++++++++++--------------------------------
 2 files changed, 41 insertions(+), 62 deletions(-)

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -185,37 +185,39 @@ void scsi_queue_insert(struct scsi_cmnd
 	__scsi_queue_insert(cmd, reason, true);
 }
 
+
 /**
- * scsi_execute_cmd - insert request and wait for the result
- * @sdev:	scsi_device
+ * __scsi_execute - insert request and wait for the result
+ * @sdev:	scsi device
  * @cmd:	scsi command
- * @opf:	block layer request cmd_flags
+ * @data_direction: data direction
  * @buffer:	data buffer
  * @bufflen:	len of buffer
+ * @sense:	optional sense buffer
+ * @sshdr:	optional decoded sense header
  * @timeout:	request timeout in HZ
  * @retries:	number of times to retry request
- * @args:	Optional args. See struct definition for field descriptions
+ * @flags:	flags for ->cmd_flags
+ * @rq_flags:	flags for ->rq_flags
+ * @resid:	optional residual length
  *
  * Returns the scsi_cmnd result field if a command was executed, or a negative
  * Linux error code if we didn't get that far.
  */
-int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
-		     blk_opf_t opf, void *buffer, unsigned int bufflen,
-		     int timeout, int retries,
-		     const struct scsi_exec_args *args)
+int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
+		 int data_direction, void *buffer, unsigned bufflen,
+		 unsigned char *sense, struct scsi_sense_hdr *sshdr,
+		 int timeout, int retries, blk_opf_t flags,
+		 req_flags_t rq_flags, int *resid)
 {
-	static const struct scsi_exec_args default_args;
 	struct request *req;
 	struct scsi_cmnd *scmd;
 	int ret;
 
-	if (!args)
-		args = &default_args;
-	else if (WARN_ON_ONCE(args->sense &&
-			      args->sense_len != SCSI_SENSE_BUFFERSIZE))
-		return -EINVAL;
-
-	req = scsi_alloc_request(sdev->request_queue, opf, args->req_flags);
+	req = scsi_alloc_request(sdev->request_queue,
+			data_direction == DMA_TO_DEVICE ?
+			REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
+			rq_flags & RQF_PM ? BLK_MQ_REQ_PM : 0);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
@@ -230,7 +232,8 @@ int scsi_execute_cmd(struct scsi_device
 	memcpy(scmd->cmnd, cmd, scmd->cmd_len);
 	scmd->allowed = retries;
 	req->timeout = timeout;
-	req->rq_flags |= RQF_QUIET;
+	req->cmd_flags |= flags;
+	req->rq_flags |= rq_flags | RQF_QUIET;
 
 	/*
 	 * head injection *required* here otherwise quiesce won't work
@@ -246,21 +249,20 @@ int scsi_execute_cmd(struct scsi_device
 	if (unlikely(scmd->resid_len > 0 && scmd->resid_len <= bufflen))
 		memset(buffer + bufflen - scmd->resid_len, 0, scmd->resid_len);
 
-	if (args->resid)
-		*args->resid = scmd->resid_len;
-	if (args->sense)
-		memcpy(args->sense, scmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
-	if (args->sshdr)
+	if (resid)
+		*resid = scmd->resid_len;
+	if (sense && scmd->sense_len)
+		memcpy(sense, scmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
+	if (sshdr)
 		scsi_normalize_sense(scmd->sense_buffer, scmd->sense_len,
-				     args->sshdr);
-
+				     sshdr);
 	ret = scmd->result;
  out:
 	blk_mq_free_request(req);
 
 	return ret;
 }
-EXPORT_SYMBOL(scsi_execute_cmd);
+EXPORT_SYMBOL(__scsi_execute);
 
 /*
  * Wake up the error handler if necessary. Avoid as follows that the error
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -479,51 +479,28 @@ extern const char *scsi_device_state_nam
 extern int scsi_is_sdev_device(const struct device *);
 extern int scsi_is_target_device(const struct device *);
 extern void scsi_sanitize_inquiry_string(unsigned char *s, int len);
-
-/* Optional arguments to scsi_execute_cmd */
-struct scsi_exec_args {
-	unsigned char *sense;		/* sense buffer */
-	unsigned int sense_len;		/* sense buffer len */
-	struct scsi_sense_hdr *sshdr;	/* decoded sense header */
-	blk_mq_req_flags_t req_flags;	/* BLK_MQ_REQ flags */
-	int *resid;			/* residual length */
-};
-
-int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
-		     blk_opf_t opf, void *buffer, unsigned int bufflen,
-		     int timeout, int retries,
-		     const struct scsi_exec_args *args);
-
+extern int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
+			int data_direction, void *buffer, unsigned bufflen,
+			unsigned char *sense, struct scsi_sense_hdr *sshdr,
+			int timeout, int retries, blk_opf_t flags,
+			req_flags_t rq_flags, int *resid);
 /* Make sure any sense buffer is the correct size. */
-#define scsi_execute(_sdev, _cmd, _data_dir, _buffer, _bufflen, _sense,	\
-		     _sshdr, _timeout, _retries, _flags, _rq_flags,	\
-		     _resid)						\
+#define scsi_execute(sdev, cmd, data_direction, buffer, bufflen, sense,	\
+		     sshdr, timeout, retries, flags, rq_flags, resid)	\
 ({									\
-	scsi_execute_cmd(_sdev, _cmd, (_data_dir == DMA_TO_DEVICE ?	\
-			 REQ_OP_DRV_OUT : REQ_OP_DRV_IN) | _flags,	\
-			 _buffer, _bufflen, _timeout, _retries,	\
-			 &(struct scsi_exec_args) {			\
-				.sense = _sense,			\
-				.sshdr = _sshdr,			\
-				.req_flags = _rq_flags & RQF_PM  ?	\
-						BLK_MQ_REQ_PM : 0,	\
-				.resid = _resid,			\
-			 });						\
+	BUILD_BUG_ON((sense) != NULL &&					\
+		     sizeof(sense) != SCSI_SENSE_BUFFERSIZE);		\
+	__scsi_execute(sdev, cmd, data_direction, buffer, bufflen,	\
+		       sense, sshdr, timeout, retries, flags, rq_flags,	\
+		       resid);						\
 })
-
 static inline int scsi_execute_req(struct scsi_device *sdev,
 	const unsigned char *cmd, int data_direction, void *buffer,
 	unsigned bufflen, struct scsi_sense_hdr *sshdr, int timeout,
 	int retries, int *resid)
 {
-	return scsi_execute_cmd(sdev, cmd,
-				data_direction == DMA_TO_DEVICE ?
-				REQ_OP_DRV_OUT : REQ_OP_DRV_IN, buffer,
-				bufflen, timeout, retries,
-				&(struct scsi_exec_args) {
-					.sshdr = sshdr,
-					.resid = resid,
-				});
+	return scsi_execute(sdev, cmd, data_direction, buffer,
+		bufflen, NULL, sshdr, timeout, retries,  0, 0, resid);
 }
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);


