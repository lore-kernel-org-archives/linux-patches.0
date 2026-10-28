Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214201;
	b=WNzGl2zYACvjtiuy/sgA9YyTZrTAB3vt+i6VVr6mpX2YzxaKsIjErdW6+atvgraWUUW0
	 xkLR6sOXRvFKMBPI/E9avjkhksmYQIBeWpd2y+ZYR67y6KvAoy3HpBH1bs+9ZeuRKf5SW
	 OfuZWdC87YfgCxMrOcodh5Iij+4wfkOMcFDdKven+eptxBHijUc2cKu9FRTDo/HjF6uef
	 /p05/IaAf3kU1uaTXqudLxx6cYIj0nW3bj5bytErn+o6w3LDwllAtjD0cgUYE6/0hYulk
	 LtZPAhNoNaSj/8lr25jref9EMm+SbyqqOwn6J7P+vJxrELGX8t51CdcFfrxfQeUgaRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214201;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lyRNi7TaaUGXcYfm9u6Ia/j6yxcg9L8OtjXOky084Sk=;
	b=dCa3dV/FiEGF/cV9lx2OqJ7Qj7Eq01rRHByh8SygBjRJooeEbe70Z1qY23dzUM7M6DYP
	 Qngo6HvaXuQu0hZhWo0w++Y+6lCo9Fc5PCFRhbY+AHJRDQgt+j0ynz8cujt6gNg5kVZgh
	 R0A5mr33CVEOhM4lLD2anWa4xomt4UA8pXjpwUSoZ0mORiuZgi8i3U+Y77pBes5Kqo7Om
	 SqbvwB0dUTes/N7ZJZ6jEIk6PNFgEH0y/HzrHwsp9gLrdX7ts7B5N4zUpWvzIocFabJXX
	 qOjKBDZ1H+zXVo1rF4jUq/qHABdM5SXN2enK4vNUsbTSR3Zy/kPgdvrBFJXXTzO17Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aDvo8Dms;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CBF606BF8F;
	Wed, 28 Oct 2026 19:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aDvo8Dms
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87181F013C1;
	Wed, 28 Oct 2026 19:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214201;
	bh=lyRNi7TaaUGXcYfm9u6Ia/j6yxcg9L8OtjXOky084Sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aDvo8DmsZ3jGuJTIzwhTL34RQU0liqbPtT0jE3zosipeaGMOMyJJ36WxuN6lq+D/x
	 uHq8zr9V0IiyOlUdhanuVfTV58VxFqb/fg6EaKu4KFqUgizL3Z89vTL+zKnqiuyLln
	 Sf09tFTfDZBF+vpce9lWtMMXL9j2c+6QAM34oiCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0776/1887] scsi: mpi3mr: Synchronous access b/w reset and tm thread for reply queue
Date: Wed, 28 Oct 2026 17:47:52 +0100
Message-ID: <20261028170517.097276740@linuxfoundation.org>
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

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit f195fc060c738d303a21fae146dbf85e1595fb4c ]

When the task management thread processes reply queues while the reset
thread resets them, the task management thread accesses an invalid queue ID
(0xFFFF), set by the reset thread, which points to unallocated memory,
causing a crash.

Add flag 'io_admin_reset_sync' to synchronize access between the reset,
I/O, and admin threads. Before a reset, the reset handler sets this flag to
block I/O and admin processing threads. If any thread bypasses the initial
check, the reset thread waits up to 10 seconds for processing to finish. If
the wait exceeds 10 seconds, the controller is marked as unrecoverable.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://lore.kernel.org/r/20250129100850.25430-4-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  2 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 67 +++++++++++++++++++++++++++++++--
 2 files changed, 66 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 982629a0ec803..422cb50b3577e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -969,6 +969,7 @@ struct scmd_priv {
  * @ts_update_counter: Timestamp update counter
  * @reset_in_progress: Reset in progress flag
  * @unrecoverable: Controller unrecoverable flag
+ * @io_admin_reset_sync: Manage state of I/O ops during an admin reset process
  * @prev_reset_result: Result of previous reset
  * @reset_mutex: Controller reset mutex
  * @reset_waitq: Controller reset  wait queue
@@ -1141,6 +1142,7 @@ struct mpi3mr_ioc {
 	u32 ts_update_counter;
 	u8 reset_in_progress;
 	u8 unrecoverable;
+	u8 io_admin_reset_sync;
 	int prev_reset_result;
 	struct mutex reset_mutex;
 	wait_queue_head_t reset_waitq;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index c14bee07f8c10..8cdbb593c8e59 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -17,7 +17,7 @@ static void mpi3mr_process_factsdata(struct mpi3mr_ioc *mrioc,
 	struct mpi3_ioc_facts_data *facts_data);
 static void mpi3mr_pel_wait_complete(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_drv_cmd *drv_cmd);
-
+static int mpi3mr_check_op_admin_proc(struct mpi3mr_ioc *mrioc);
 static int poll_queues;
 module_param(poll_queues, int, 0444);
 MODULE_PARM_DESC(poll_queues, "Number of queues for io_uring poll mode. (Range 1 - 126)");
@@ -449,7 +449,7 @@ int mpi3mr_process_admin_reply_q(struct mpi3mr_ioc *mrioc)
 	}
 
 	do {
-		if (mrioc->unrecoverable)
+		if (mrioc->unrecoverable || mrioc->io_admin_reset_sync)
 			break;
 
 		mrioc->admin_req_ci = le16_to_cpu(reply_desc->request_queue_ci);
@@ -538,7 +538,7 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 	}
 
 	do {
-		if (mrioc->unrecoverable)
+		if (mrioc->unrecoverable || mrioc->io_admin_reset_sync)
 			break;
 
 		req_q_idx = le16_to_cpu(reply_desc->request_queue_id) - 1;
@@ -3990,6 +3990,7 @@ int mpi3mr_reinit_ioc(struct mpi3mr_ioc *mrioc, u8 is_resume)
 		goto out_failed_noretry;
 	}
 
+	mrioc->io_admin_reset_sync = 0;
 	if (is_resume) {
 		dprint_reset(mrioc, "setting up single ISR\n");
 		retval = mpi3mr_setup_isr(mrioc, 1);
@@ -4824,6 +4825,55 @@ void mpi3mr_pel_get_seqnum_complete(struct mpi3mr_ioc *mrioc,
 	drv_cmd->retry_count = 0;
 }
 
+/**
+ * mpi3mr_check_op_admin_proc -
+ * @mrioc: Adapter instance reference
+ *
+ * Check if any of the operation reply queues
+ * or the admin reply queue are currently in use.
+ * If any queue is in use, this function waits for
+ * a maximum of 10 seconds for them to become available.
+ *
+ * Return: 0 on success, non-zero on failure.
+ */
+static int mpi3mr_check_op_admin_proc(struct mpi3mr_ioc *mrioc)
+{
+
+	u16 timeout = 10 * 10;
+	u16 elapsed_time = 0;
+	bool op_admin_in_use = false;
+
+	do {
+		op_admin_in_use = false;
+
+		/* Check admin_reply queue first to exit early */
+		if (atomic_read(&mrioc->admin_reply_q_in_use) == 1)
+			op_admin_in_use = true;
+		else {
+			/* Check op_reply queues */
+			int i;
+
+			for (i = 0; i < mrioc->num_queues; i++) {
+				if (atomic_read(&mrioc->op_reply_qinfo[i].in_use) == 1) {
+					op_admin_in_use = true;
+					break;
+				}
+			}
+		}
+
+		if (!op_admin_in_use)
+			break;
+
+		msleep(100);
+
+	} while (++elapsed_time < timeout);
+
+	if (op_admin_in_use)
+		return 1;
+
+	return 0;
+}
+
 /**
  * mpi3mr_soft_reset_handler - Reset the controller
  * @mrioc: Adapter instance reference
@@ -4897,6 +4947,7 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 	mpi3mr_wait_for_host_io(mrioc, MPI3MR_RESET_HOST_IOWAIT_TIMEOUT);
 
 	mpi3mr_ioc_disable_intr(mrioc);
+	mrioc->io_admin_reset_sync = 1;
 
 	if (snapdump) {
 		mpi3mr_set_diagsave(mrioc);
@@ -4920,6 +4971,16 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 		ioc_err(mrioc, "Failed to issue soft reset to the ioc\n");
 		goto out;
 	}
+
+	retval = mpi3mr_check_op_admin_proc(mrioc);
+	if (retval) {
+		ioc_err(mrioc, "Soft reset failed due to an Admin or I/O queue polling\n"
+				"thread still processing replies even after a 10 second\n"
+				"timeout. Marking the controller as unrecoverable!\n");
+
+		goto out;
+	}
+
 	if (mrioc->num_io_throttle_group !=
 	    mrioc->facts.max_io_throttle_group) {
 		ioc_err(mrioc,
-- 
2.53.0



