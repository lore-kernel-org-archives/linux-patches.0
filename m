Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67DA46313F;
	Tue, 23 Jan 2024 01:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975003; cv=none; b=fwQyKCBJmdsEMj9z+VK2ejS+TfUgj0m8ckVuu0VeLrjjH3prjzrO9rOMpIuD1lkcOH/hyrogx3ZR4J40JiEHK/bh7LeUtAADByXGI6wIKEeSvmxN50HgepfGwJKkE7Zhx8Sx8rl7l6a4aGFCnqb3yKnNqCV2eEK80jRggfNXX0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975003; c=relaxed/simple;
	bh=POqX8qOvHrWJMaOIdtsJFXbW7QjP5IO8jTqTQD1/ytA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AoiXQU752dAfL405R3YBq0kk2fs01gQjFMMdcY0EUbdCtTRlmT6dpSxTy4JjS6UgdTRM0kqroHetIwXaW/dytu/DsQ8LJzyr1q/F8ufEoDn4t3nsjBpS32gLlwXsG96Jcjf8zuBKphtD6/dJpSnbUwvyIj5DmrdOSB/D7yPE2UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jde8Y4XD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jde8Y4XD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4ABC433C7;
	Tue, 23 Jan 2024 01:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975003;
	bh=POqX8qOvHrWJMaOIdtsJFXbW7QjP5IO8jTqTQD1/ytA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jde8Y4XDDvnv/TIhN46fe3MxBHCsn20Gabnl8pPQL9etGjMBh4P/tbjiqkMyQBLMe
	 eDvmezgoK4W1PTcqpK2Y84NwzWo5ZHRTrqkNO07bOzhD0BcL/iOVqO8xI/64gprxRU
	 ypqr/4MlnehgyOrN17NBgXIAr6Iaxc3R15wrBbM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 161/583] scsi: hisi_sas: Check before using pointer variables
Date: Mon, 22 Jan 2024 15:53:32 -0800
Message-ID: <20240122235816.968696344@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yihang Li <liyihang9@huawei.com>

[ Upstream commit 8dd10296be8562a45c6c6794dd492a2b7dccede8 ]

In commit 4b329abc9180 ("scsi: hisi_sas: Move slot variable definition in
hisi_sas_abort_task()"), we move the variables slot to the function head.
However, the variable slot may be NULL, we should check it in each branch.

Fixes: 4b329abc9180 ("scsi: hisi_sas: Move slot variable definition in hisi_sas_abort_task()")
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Link: https://lore.kernel.org/r/1702525516-51258-4-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 6dfa8be17ea4..b155ac800979 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1641,7 +1641,10 @@ static int hisi_sas_abort_task(struct sas_task *task)
 	task->task_state_flags |= SAS_TASK_STATE_ABORTED;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
 
-	if (slot && task->task_proto & SAS_PROTOCOL_SSP) {
+	if (!slot)
+		goto out;
+
+	if (task->task_proto & SAS_PROTOCOL_SSP) {
 		u16 tag = slot->idx;
 		int rc2;
 
@@ -1688,7 +1691,7 @@ static int hisi_sas_abort_task(struct sas_task *task)
 				rc = hisi_sas_softreset_ata_disk(device);
 			}
 		}
-	} else if (slot && task->task_proto & SAS_PROTOCOL_SMP) {
+	} else if (task->task_proto & SAS_PROTOCOL_SMP) {
 		/* SMP */
 		u32 tag = slot->idx;
 		struct hisi_sas_cq *cq = &hisi_hba->cq[slot->dlvry_queue];
-- 
2.43.0



