Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F72F9D7;
	Sat,  3 Feb 2024 04:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933352; cv=none; b=X9clM/gAfCGKSlJvnaSLyWjnqcSouUN0yvDsqau87FcvOzynTEuBovD0iHF72fbeAo6CM0bHPOenkj4o1XZDYzL+2zvq/VjcDfZlw8M7mdPbIGKKy+XARSnwur0J/dUD3HZz0ARG8C3/C6REMgAa4Mlh2DaujhpDk+anNpmeEVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933352; c=relaxed/simple;
	bh=p7AZ315qwMczIEPDmnWMICId6LQNNvXOPBLjz0oxxTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XVdOG4fXMz1pFruxAuyAULuMHhu1Rk6SByiYbQnXeq34TuAiFhms2IrQ/cVEpL6eqxUdFUYnNEqEIgE5mOTF9nfKfZFVGwk7iIl3pYhCcYu6PpeQnJ2PTPwXJXCf0i8dLaL0K30z9K1cIERpaLZlYhOO0OGqg+gbnZFPA/WrghI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yyYiZvx2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yyYiZvx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4870C43399;
	Sat,  3 Feb 2024 04:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933352;
	bh=p7AZ315qwMczIEPDmnWMICId6LQNNvXOPBLjz0oxxTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yyYiZvx215kr6V0KcHBiiMIjpXDDEnsb2FHKTGPpxmdNrOMe8MnS2Zx3vRhLFToVo
	 VaTkG1apJx6n0vKnyyLvjCLFXkZcGs3mYEAGjjQNZXoSWM3u4/EcvEVI6dFFsaagi1
	 HMIypTFG+e7s1pSBnfMdJatuR7J+q6gY+Zy/sdxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/219] scsi: mpi3mr: Add PCI checks where SAS5116 diverges from SAS4116
Date: Fri,  2 Feb 2024 20:03:49 -0800
Message-ID: <20240203035324.902425937@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

From: Sumit Saxena <sumit.saxena@broadcom.com>

[ Upstream commit c9260ff28ee561fca5f96425c9328a9698e8427b ]

Add PCI IDs checks for the cases where SAS5116 diverges from SAS4116 in
behavior.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Link: https://lore.kernel.org/r/20231123160132.4155-3-sumit.saxena@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 3 ++-
 drivers/scsi/mpi3mr/mpi3mr_os.c | 5 ++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index d2c7de804b99..41636c4c43af 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1886,7 +1886,8 @@ static int mpi3mr_create_op_reply_q(struct mpi3mr_ioc *mrioc, u16 qidx)
 
 	reply_qid = qidx + 1;
 	op_reply_q->num_replies = MPI3MR_OP_REP_Q_QD;
-	if (!mrioc->pdev->revision)
+	if ((mrioc->pdev->device == MPI3_MFGPAGE_DEVID_SAS4116) &&
+		!mrioc->pdev->revision)
 		op_reply_q->num_replies = MPI3MR_OP_REP_Q_QD4K;
 	op_reply_q->ci = 0;
 	op_reply_q->ephase = 1;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 85f5b349c7e4..7a6b006e70c8 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -4963,7 +4963,10 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		mpi3mr_init_drv_cmd(&mrioc->evtack_cmds[i],
 				    MPI3MR_HOSTTAG_EVTACKCMD_MIN + i);
 
-	if (pdev->revision)
+	if ((pdev->device == MPI3_MFGPAGE_DEVID_SAS4116) &&
+		!pdev->revision)
+		mrioc->enable_segqueue = false;
+	else
 		mrioc->enable_segqueue = true;
 
 	init_waitqueue_head(&mrioc->reset_waitq);
-- 
2.43.0



