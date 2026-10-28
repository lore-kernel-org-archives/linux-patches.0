Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214032;
	b=KfXbLS7Ft8eykBBM5s+/OsmItYteCNJeOkxDGsB7O+nFarx0BZpL4X+QtcDi3KA4fCPQ
	 vcMFo3te+6SeQ625gmVpMVfzMRVG0fpXZPGxnGrSGq37PBQ8zD+eg7maj2wwcINlCrNqA
	 L5ZNcHjns0FwBTel3SP4csC81LIZvNP05ms1mfBre3VkHieLiLhosuPtv0Cn5ig0OquY1
	 pG5fm7zJNix7FzpwvtM+OqxenHp06wLE8sooRZ+wJoZ/QGmqN39sPeWBKEhIAN+bvYByo
	 zxZ9ifmUawweLmQpuf6PYwfBX1fWkIvI9qG9EIvEf3Fdvv3t7QMn7I77xPna1VUbLGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214032;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PyiSRrPqlqYxcTwbN4SHix78AipFYkcW0f0u8Ji2vbc=;
	b=weO+Ht/7ter51mnViZixZZ5WGe4bWumNo/VrXu+Uh0gJPLDYKNLHkPMnafvOEvbT64EI
	 5+aXFvArxHEVPjwQMzktDHNqSi1sHY3wbFq6Wh1igmqL+KGK7z6thNgDV5NiRGNY2dS92
	 Vc77titzwYxuXFXiVwA7tWSL/3C16QiYMKtQmb5HDVWHz+7IpBCycTn6m+Spg/bUj2pDK
	 QV4wxbWcCGqtDauueGhp+Anjj3ZDsKG2b3siBJV6RbVCqsBxi9uwZ9RCosobyJextaW/f
	 DkXc+LfIiDGQzCnYdukufyuTnsH6VhJkhIdqYMiTBrIpfX0O4jGRHKnU1hg//Ptvntw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GX8REde6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B533560A2604;
	Wed, 28 Oct 2026 19:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GX8REde6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349151F031E9;
	Wed, 28 Oct 2026 19:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214028;
	bh=PyiSRrPqlqYxcTwbN4SHix78AipFYkcW0f0u8Ji2vbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GX8REde6dTZcRw1hnbR+4296pr0WpmAGm0gz+BF75R2jnMufAr3zYfSMvpT/bN555
	 FP/eOfkZwrr0grwr+/aIuhml4T39BU62zErUduRxO7OmVU9/7OPp7ZD2+5nNzYguQ0
	 dObkm91HIP6H72wd+KZR7S2+A1HJR/TtiOl6Mgng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0712/1887] scsi: hisi_sas: Directly call register snapshot instead of using workqueue
Date: Wed, 28 Oct 2026 17:46:48 +0100
Message-ID: <20261028170515.626139040@linuxfoundation.org>
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

From: Yihang Li <liyihang9@huawei.com>

[ Upstream commit 2ff07b5c6fe9173e7a7de3b23f300d71ad4d8fde ]

Currently, register information dump is performed via workqueue, regardless
of the trigger mode (automatic or manual). There is a delay in dumping
register through workqueue, the exact register information at trigger time
cannot be obtained.

Call register snapshot directly instead of through a workqueue.

Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Link: https://lore.kernel.org/r/1694571327-78697-3-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 9f564f15f884 ("scsi: hisi_sas: Create all dump files during debugfs initialization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  1 -
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  7 +++++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 14 +++-----------
 3 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 423af1dc36487..2885ea87fd1eb 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -450,7 +450,6 @@ struct hisi_hba {
 	const struct hisi_sas_hw *hw;	/* Low level hw interface */
 	unsigned long sata_dev_bitmap[BITS_TO_LONGS(HISI_SAS_MAX_DEVICES)];
 	struct work_struct rst_work;
-	struct work_struct debugfs_work;
 	u32 phy_state;
 	u32 intr_coal_ticks;	/* Time of interrupt coalesce in us */
 	u32 intr_coal_count;	/* Interrupt count to coalesce */
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index e13fa623ff5a6..85d544e016a61 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1907,8 +1907,11 @@ static bool hisi_sas_internal_abort_timeout(struct sas_task *task,
 	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
 	struct hisi_sas_internal_abort_data *timeout = data;
 
-	if (hisi_sas_debugfs_enable && hisi_hba->debugfs_itct[0].itct)
-		queue_work(hisi_hba->wq, &hisi_hba->debugfs_work);
+	if (hisi_sas_debugfs_enable && hisi_hba->debugfs_itct[0].itct) {
+		down(&hisi_hba->sem);
+		hisi_hba->hw->debugfs_snapshot_regs(hisi_hba);
+		up(&hisi_hba->sem);
+	}
 
 	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
 		pr_err("Internal abort: timeout %016llx\n",
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 63db4a2ea7ba7..13019517e8469 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -554,7 +554,6 @@ static int prot_mask;
 module_param(prot_mask, int, 0444);
 MODULE_PARM_DESC(prot_mask, " host protection capabilities mask, def=0x0 ");
 
-static void debugfs_work_handler_v3_hw(struct work_struct *work);
 static void debugfs_snapshot_regs_v3_hw(struct hisi_hba *hisi_hba);
 
 static u32 hisi_sas_read32(struct hisi_hba *hisi_hba, u32 off)
@@ -3311,7 +3310,6 @@ hisi_sas_shost_alloc_pci(struct pci_dev *pdev)
 	hisi_hba = shost_priv(shost);
 
 	INIT_WORK(&hisi_hba->rst_work, hisi_sas_rst_work_handler);
-	INIT_WORK(&hisi_hba->debugfs_work, debugfs_work_handler_v3_hw);
 	hisi_hba->hw = &hisi_sas_v3_hw;
 	hisi_hba->pci_dev = pdev;
 	hisi_hba->dev = dev;
@@ -3826,7 +3824,9 @@ static ssize_t debugfs_trigger_dump_v3_hw_write(struct file *file,
 	if (buf[0] != '1')
 		return -EFAULT;
 
-	queue_work(hisi_hba->wq, &hisi_hba->debugfs_work);
+	down(&hisi_hba->sem);
+	debugfs_snapshot_regs_v3_hw(hisi_hba);
+	up(&hisi_hba->sem);
 
 	return count;
 }
@@ -4577,14 +4577,6 @@ static void debugfs_fifo_init_v3_hw(struct hisi_hba *hisi_hba)
 	}
 }
 
-static void debugfs_work_handler_v3_hw(struct work_struct *work)
-{
-	struct hisi_hba *hisi_hba =
-		container_of(work, struct hisi_hba, debugfs_work);
-
-	debugfs_snapshot_regs_v3_hw(hisi_hba);
-}
-
 static void debugfs_release_v3_hw(struct hisi_hba *hisi_hba, int dump_index)
 {
 	struct device *dev = hisi_hba->dev;
-- 
2.53.0



