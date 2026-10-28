Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214032;
	b=HDmrJZqxgLxzIOmG+Ke/OUr9cKZF9QTzc8nLMaA3ST2m4w0vt4E2bXOkp6obKQlOPRhl
	 C2vxB6wtKhuXeBJQ7B6Wxyd9p8RrU2lswKvnSNeAFq8p6myCzGiP0lxRMTuROzrV7AW0n
	 abfELjA+t5XJ0LRaCplhhl7bBqyshvGEdi1Yn67eKoeb3vonAE686c1cBjkBrm93HbWhd
	 FlP3K3MDnhC7vjoUsRwecZk5257eol2txXCZgVEPvEUbxZI4w8Z2lGz8TD97s9XNMV5Rq
	 ngJDmGWThGJnuEcDQoGvk88xO6g7VHCuv+P0ol0lZ52t95o26BIsVPBFe7jpQxsHmeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214032;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tJyZ7n7JFSFZZiKFm+aHbCfmDNzLcc9V8k5GB1tJ/Jg=;
	b=SCsySFotwruAy8sCbTy3y4mZ4JRRhfC8tSn7wWl21A1Qk25fdsrqH7Gt5zMoeltfRCMq
	 pi/Zb5+BJ+uahsJ95sVEueiMmEiGRMROxrjqnzdpSzi5GG0Xh7441xmlTJNIKHgrVbEhG
	 XsFyAz+XfRIWJQhFFKF72uDBium3CeMyZhZpuQJGPJ0nNM42xPrjD2kdAgV6ws6bWNx/Z
	 q922VkvMZ0KJNXkEmITZpX3IyjfpaKClcoI/FjwNvS9Rf2C2yjLjK/oOJUaZWqdARaB1c
	 o1DmSJ2zwLzlyql5WovyTk3ZN3XMWJKnGnP6g0D3VtCRmDPFmNyRZcj3+MRgJ3ajKqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P3IqzERW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B6B606A31C;
	Wed, 28 Oct 2026 19:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P3IqzERW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE6B1F01825;
	Wed, 28 Oct 2026 19:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214025;
	bh=tJyZ7n7JFSFZZiKFm+aHbCfmDNzLcc9V8k5GB1tJ/Jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P3IqzERWdz+vR6sflCaqevqKQzX79ytxg5WRXBPRV9lZiZOv28Wt16KJ44uccoNdb
	 gj80Z+q2KlpfIK0KG/oFBDi5tVXUueuKVayu0SgciH8S5oRrERWerXJTTydqKbObLo
	 QHvn8QIC/6abGVgxOyCtQF2VIz0N7scynzDA5B1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.garry@huawei.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0711/1887] scsi: hisi_sas: Add function complete_v3_hw()
Date: Wed, 28 Oct 2026 17:46:47 +0100
Message-ID: <20261028170515.602413892@linuxfoundation.org>
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

From: Xiang Chen <chenxiang66@hisilicon.com>

[ Upstream commit 538a60468966f47c53071d06db27bb78c2aaa81d ]

Put the work of processing cq slots in a separate function,
complete_v3_hw(), which can then be used by cq_thread_v3_hw() and other
functions when adding poll support.

Co-developed-by: John Garry <john.garry@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Link: https://lore.kernel.org/r/1678169355-76215-2-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

[ Keep the cond_resched() call at the end of cq_thread_v3_hw() after the
  split. Also pass need_lock to the hisi_sas_do_release_task() call added
  by the SATA_DISK_ERR dependency, which this tree's function requires. ]

Stable-dep-of: 9f564f15f884 ("scsi: hisi_sas: Create all dump files during debugfs initialization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 17 ++++++++++++-----
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 2f13bb9771d64..e13fa623ff5a6 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1646,7 +1646,7 @@ static int hisi_sas_abort_task(struct sas_task *task)
 			 */
 			if ((sas_dev->dev_status == HISI_SAS_DEV_NCQ_ERR) &&
 			    qc && qc->scsicmd) {
-				hisi_sas_do_release_task(hisi_hba, task, slot);
+				hisi_sas_do_release_task(hisi_hba, task, slot, true);
 				rc = TMF_RESP_FUNC_COMPLETE;
 			} else {
 				rc = hisi_sas_softreset_ata_disk(device);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 2b19c515acdeb..63db4a2ea7ba7 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2407,15 +2407,14 @@ static void slot_complete_v3_hw(struct hisi_hba *hisi_hba,
 		task->task_done(task);
 }
 
-static irqreturn_t  cq_thread_v3_hw(int irq_no, void *p)
+static void complete_v3_hw(struct hisi_sas_cq *cq)
 {
-	struct hisi_sas_cq *cq = p;
-	struct hisi_hba *hisi_hba = cq->hisi_hba;
-	struct hisi_sas_slot *slot;
 	struct hisi_sas_complete_v3_hdr *complete_queue;
-	u32 rd_point = cq->rd_point, wr_point;
+	struct hisi_hba *hisi_hba = cq->hisi_hba;
+	u32 rd_point, wr_point;
 	int queue = cq->id;
 
+	rd_point = cq->rd_point;
 	complete_queue = hisi_hba->complete_hdr[queue];
 
 	wr_point = hisi_sas_read32(hisi_hba, COMPL_Q_0_WR_PTR +
@@ -2424,6 +2423,7 @@ static irqreturn_t  cq_thread_v3_hw(int irq_no, void *p)
 	while (rd_point != wr_point) {
 		struct hisi_sas_complete_v3_hdr *complete_hdr;
 		struct device *dev = hisi_hba->dev;
+		struct hisi_sas_slot *slot;
 		u32 dw0, dw1, dw3;
 		int iptt;
 
@@ -2466,6 +2466,13 @@ static irqreturn_t  cq_thread_v3_hw(int irq_no, void *p)
 	/* update rd_point */
 	cq->rd_point = rd_point;
 	hisi_sas_write32(hisi_hba, COMPL_Q_0_RD_PTR + (0x14 * queue), rd_point);
+}
+
+static irqreturn_t cq_thread_v3_hw(int irq_no, void *p)
+{
+	struct hisi_sas_cq *cq = p;
+
+	complete_v3_hw(cq);
 	cond_resched();
 
 	return IRQ_HANDLED;
-- 
2.53.0



