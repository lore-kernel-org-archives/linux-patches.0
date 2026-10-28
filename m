Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214031;
	b=gc9pTx5Ro3IMvdMNmWZJvVJHXH5icYpSxm3o3IcmsgKYTdfpa+aJqBkycTKF2lBwk/QF
	 tGTT5kfRR8ggEUFetrYfjgzs49H5NV/M6TV3ceevQuaeEEMSqi0b+OzTbmHb2RuGpdFmS
	 BLCPdPEUBtFImEq134CCNUBQ2lo0Aw/jbEIqzSYyhmMa9UxAO9mr/Dxm7yDZ4QD6HUwEn
	 WIoAoItTRmN9p/eUGQXDhkpcCk+PAN1ndMDzKUfUSgqbAkPKyuj6ii0kvNCBqG3xB55qi
	 llS8twmCMUPyLRekWyGTkEUe4C2jW5tBQTu2pKQu4UXekhrZfUqPSwtmd3ArAfqpa7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214031;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kDf6pDefgK1/8Frsx1uOedQukB6Kdb8Nd3J2X5rc2Ow=;
	b=EglSWa5cANepbwazak72WHU4x0mXAxJ65yOZWgarhQYrL35Xmq2fOYIopRiIIlLKkKq8
	 z6QA30J4JtZsHx5YvrG5RR5RkGhgFkvZ7P4gfdhgUep+9/hcISxsCZH00hKsRHIrxsZlP
	 7+T1k3OQ7mSWIMsvG7X8wEb7pCttIyH2UoyN/gzJv6wEIkxPIjz8K2nRwUJzWQTs8R1O5
	 dkdLT9k6M3C0vN2xWBWfLhhV9GROi9N14RKf5V9oAEECiPjLIaSRlZc/6yE8vM+RJ4X8s
	 Gyw4vZOUYLq2Au0bWa0Mdb5lIIdwrSmqAg4m4kpiJ2of6Pu9hddqiJtDmyMuVRaGtIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cOl+6DCD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654C3606A331;
	Wed, 28 Oct 2026 19:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cOl+6DCD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B53481F01829;
	Wed, 28 Oct 2026 19:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214020;
	bh=kDf6pDefgK1/8Frsx1uOedQukB6Kdb8Nd3J2X5rc2Ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cOl+6DCD3CSwls+JDsqSvRdIWlHknAAvqR2+VjeCAAC4gpElTPe1LazLVpP5IhgE7
	 +pCzgGr/7b80m9YPEELxGUivTvxihz7PAqDvpaLSeGH8Mgc6Y0SHk4q5X1Gaj834yX
	 qB7OfGtOWY59DY3Hbu1XcGL4ZFyB8lPIvw9TStXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	John Garry <john.garry@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0709/1887] scsi: hisi_sas: Move slot variable definition in hisi_sas_abort_task()
Date: Wed, 28 Oct 2026 17:46:45 +0100
Message-ID: <20261028170515.552519090@linuxfoundation.org>
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

From: Xingui Yang <yangxingui@huawei.com>

[ Upstream commit 4b329abc91800d23941ac773e69b322a13981ecb ]

Each branch currently defines a slot variable independently, and it is
neater to move it to the function head.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Link: https://lore.kernel.org/r/1665998435-199946-3-git-send-email-john.garry@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 9f564f15f884 ("scsi: hisi_sas: Create all dump files during debugfs initialization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 290c9915fb9b2..ae7383e9e5fc1 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1574,6 +1574,7 @@ static int hisi_sas_abort_task(struct sas_task *task)
 	struct hisi_sas_internal_abort_data internal_abort_data = { false };
 	struct domain_device *device = task->dev;
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
+	struct hisi_sas_slot *slot = task->lldd_task;
 	struct hisi_hba *hisi_hba;
 	struct device *dev;
 	int rc = TMF_RESP_FUNC_FAILED;
@@ -1587,7 +1588,6 @@ static int hisi_sas_abort_task(struct sas_task *task)
 
 	spin_lock_irqsave(&task->task_state_lock, flags);
 	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
-		struct hisi_sas_slot *slot = task->lldd_task;
 		struct hisi_sas_cq *cq;
 
 		if (slot) {
@@ -1605,8 +1605,7 @@ static int hisi_sas_abort_task(struct sas_task *task)
 	task->task_state_flags |= SAS_TASK_STATE_ABORTED;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
 
-	if (task->lldd_task && task->task_proto & SAS_PROTOCOL_SSP) {
-		struct hisi_sas_slot *slot = task->lldd_task;
+	if (slot && task->task_proto & SAS_PROTOCOL_SSP) {
 		u16 tag = slot->idx;
 		int rc2;
 
@@ -1640,9 +1639,8 @@ static int hisi_sas_abort_task(struct sas_task *task)
 			hisi_sas_dereg_device(hisi_hba, device);
 			rc = hisi_sas_softreset_ata_disk(device);
 		}
-	} else if (task->lldd_task && task->task_proto & SAS_PROTOCOL_SMP) {
+	} else if (slot && task->task_proto & SAS_PROTOCOL_SMP) {
 		/* SMP */
-		struct hisi_sas_slot *slot = task->lldd_task;
 		u32 tag = slot->idx;
 		struct hisi_sas_cq *cq = &hisi_hba->cq[slot->dlvry_queue];
 
-- 
2.53.0



