Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5136B3921FB;
	Sat, 17 Oct 2026 17:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257994; cv=none; b=hvknEkQPaqi+OHk+aD2LoF0t9H00mNwVNfzZpW89PWJnC1DY6aBZy4uknQch4+h36Q1Qs9031avspQKs0MskQPQP1SplXfKr7D9mr3BqjiNGC0U8jSmTe/rLu+9X78ssKQozCAEAfL2D6aELHNLAeKbCjKdnDqRKGrUynLioQi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257994; c=relaxed/simple;
	bh=2VdgqmnU3dO/KJcyoxY3eSYkbMQkjLwirWLE59K69Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qj0CgH+r2mEcxtnNQ/u26FVmTDefgVpFVlE5CfsgVtkjGBoajhuHzbPQFBdfuZHNlnJs/rrUwtcCCCLJ0U5HRDmuRZIGufv8l2/RJsGjx12G/S+8DWeOosZ6PiR9QkLuPt+FhnBEFRhwBscWSyNu/b7fsFdD/atytfkxg7tgu3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iM1IeRjS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iM1IeRjS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87CA11F000C4;
	Sat, 17 Oct 2026 17:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257993;
	bh=H/PStm6EMGQP9rn0hAqXvRjzB7kcKywBgtEoAbBb/hM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iM1IeRjSGWYz0RrYpRRD4AMnboi8aVDrW7J562CHayqI6bCmZxkrgJVkGpajhbyrf
	 skP40QxDJvI5GPyokFw9vGjLha7z/zzaP042SSkUi7sys0Nhb4O1SZVBd1cboT82kc
	 20QqxhnOr0AOz+k8IK7bErCf/fO745NCy/UwzfmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0736/1674] scsi: mpi3mr: Debug ability improvements
Date: Sat, 17 Oct 2026 17:50:08 +0200
Message-ID: <20261017160449.993732703@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit 0a2714b787b91176e7d4f005dcef8d177efdff8a ]

Update driver to include OS type in fault/reset reason code.  MPI request
sent through ioctl now automatically dumped on timeout.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202403081903.q3Dq54zZ-lkp@intel.com/
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
Link: https://lore.kernel.org/r/20240313100746.128951-6-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: f195fc060c73 ("scsi: mpi3mr: Synchronous access b/w reset and tm thread for reply queue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr.h    | 10 +++++++---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 21 ++++++++++++++-------
 2 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 5593d119d5dfa..05ee88cc54e44 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -63,7 +63,7 @@ extern atomic64_t event_counter;
 #define MPI3MR_DRIVER_AUTHOR	"Broadcom Inc. <mpi3mr-linuxdrv.pdl@broadcom.com>"
 #define MPI3MR_DRIVER_DESC	"MPI3 Storage Controller Device Driver"
 
-#define MPI3MR_NAME_LENGTH	32
+#define MPI3MR_NAME_LENGTH	64
 #define IOCNAME			"%s: "
 
 #define MPI3MR_DEFAULT_MAX_IO_SIZE	(1 * 1024 * 1024)
@@ -288,6 +288,10 @@ enum mpi3mr_reset_reason {
 	MPI3MR_RESET_FROM_SAS_TRANSPORT_TIMEOUT = 30,
 };
 
+#define MPI3MR_RESET_REASON_OSTYPE_LINUX	1
+#define MPI3MR_RESET_REASON_OSTYPE_SHIFT	28
+#define MPI3MR_RESET_REASON_IOCNUM_SHIFT	20
+
 /* Queue type definitions */
 enum queue_type {
 	MPI3MR_DEFAULT_QUEUE = 0,
@@ -1126,7 +1130,7 @@ struct mpi3mr_ioc {
 	spinlock_t fwevt_lock;
 	struct list_head fwevt_list;
 
-	char watchdog_work_q_name[20];
+	char watchdog_work_q_name[50];
 	struct workqueue_struct *watchdog_work_q;
 	struct delayed_work watchdog_work;
 	spinlock_t watchdog_lock;
@@ -1312,7 +1316,7 @@ void mpi3mr_start_watchdog(struct mpi3mr_ioc *mrioc);
 void mpi3mr_stop_watchdog(struct mpi3mr_ioc *mrioc);
 
 int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
-			      u32 reset_reason, u8 snapdump);
+			      u16 reset_reason, u8 snapdump);
 void mpi3mr_ioc_disable_intr(struct mpi3mr_ioc *mrioc);
 void mpi3mr_ioc_enable_intr(struct mpi3mr_ioc *mrioc);
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index c29e23cce3742..d6fe3c42bd2b6 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -11,7 +11,7 @@
 #include <linux/io-64-nonatomic-lo-hi.h>
 
 static int
-mpi3mr_issue_reset(struct mpi3mr_ioc *mrioc, u16 reset_type, u32 reset_reason);
+mpi3mr_issue_reset(struct mpi3mr_ioc *mrioc, u16 reset_type, u16 reset_reason);
 static int mpi3mr_setup_admin_qpair(struct mpi3mr_ioc *mrioc);
 static void mpi3mr_process_factsdata(struct mpi3mr_ioc *mrioc,
 	struct mpi3_ioc_facts_data *facts_data);
@@ -1097,7 +1097,7 @@ static inline void mpi3mr_clear_reset_history(struct mpi3mr_ioc *mrioc)
 static int mpi3mr_issue_and_process_mur(struct mpi3mr_ioc *mrioc,
 	u32 reset_reason)
 {
-	u32 ioc_config, timeout, ioc_status;
+	u32 ioc_config, timeout, ioc_status, scratch_pad0;
 	int retval = -1;
 
 	ioc_info(mrioc, "Issuing Message unit Reset(MUR)\n");
@@ -1106,7 +1106,11 @@ static int mpi3mr_issue_and_process_mur(struct mpi3mr_ioc *mrioc,
 		return retval;
 	}
 	mpi3mr_clear_reset_history(mrioc);
-	writel(reset_reason, &mrioc->sysif_regs->scratchpad[0]);
+	scratch_pad0 = ((MPI3MR_RESET_REASON_OSTYPE_LINUX <<
+			 MPI3MR_RESET_REASON_OSTYPE_SHIFT) |
+			(mrioc->facts.ioc_num <<
+			 MPI3MR_RESET_REASON_IOCNUM_SHIFT) | reset_reason);
+	writel(scratch_pad0, &mrioc->sysif_regs->scratchpad[0]);
 	ioc_config = readl(&mrioc->sysif_regs->ioc_configuration);
 	ioc_config &= ~MPI3_SYSIF_IOC_CONFIG_ENABLE_IOC;
 	writel(ioc_config, &mrioc->sysif_regs->ioc_configuration);
@@ -1422,11 +1426,11 @@ static inline void mpi3mr_set_diagsave(struct mpi3mr_ioc *mrioc)
  * Return: 0 on success, non-zero on failure.
  */
 static int mpi3mr_issue_reset(struct mpi3mr_ioc *mrioc, u16 reset_type,
-	u32 reset_reason)
+	u16 reset_reason)
 {
 	int retval = -1;
 	u8 unlock_retry_count = 0;
-	u32 host_diagnostic, ioc_status, ioc_config;
+	u32 host_diagnostic, ioc_status, ioc_config, scratch_pad0;
 	u32 timeout = MPI3MR_RESET_ACK_TIMEOUT * 10;
 
 	if ((reset_type != MPI3_SYSIF_HOST_DIAG_RESET_ACTION_SOFT_RESET) &&
@@ -1478,6 +1482,9 @@ static int mpi3mr_issue_reset(struct mpi3mr_ioc *mrioc, u16 reset_type,
 		    unlock_retry_count, host_diagnostic);
 	} while (!(host_diagnostic & MPI3_SYSIF_HOST_DIAG_DIAG_WRITE_ENABLE));
 
+	scratch_pad0 = ((MPI3MR_RESET_REASON_OSTYPE_LINUX <<
+	    MPI3MR_RESET_REASON_OSTYPE_SHIFT) | (mrioc->facts.ioc_num <<
+	    MPI3MR_RESET_REASON_IOCNUM_SHIFT) | reset_reason);
 	writel(reset_reason, &mrioc->sysif_regs->scratchpad[0]);
 	writel(host_diagnostic | reset_type,
 	    &mrioc->sysif_regs->host_diagnostic);
@@ -2493,7 +2500,7 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
 	unsigned long flags;
 	enum mpi3mr_iocstate ioc_state;
 	u32 fault, host_diagnostic, ioc_status;
-	u32 reset_reason = MPI3MR_RESET_FROM_FAULT_WATCH;
+	u16 reset_reason = MPI3MR_RESET_FROM_FAULT_WATCH;
 
 	if (mrioc->reset_in_progress)
 		return;
@@ -4862,7 +4869,7 @@ void mpi3mr_pel_get_seqnum_complete(struct mpi3mr_ioc *mrioc,
  * Return: 0 on success, non-zero on failure.
  */
 int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
-	u32 reset_reason, u8 snapdump)
+	u16 reset_reason, u8 snapdump)
 {
 	int retval = 0, i;
 	unsigned long flags;
-- 
2.53.0



