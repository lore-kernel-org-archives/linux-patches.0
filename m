Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938E710FC
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:27:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F5AC433D2;
	Wed,  7 Jun 2023 20:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169648;
	bh=PRWCD+xhEF1UZpcAgOovW3slI80wQJy3hmteQFBF7Aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=awid6ucdWqaioZDBZ7IMiJn0ZT70hfmGEEr8UEeNyt6RwIVorNmnj3yvA9AJ/qj5D
	 3ut3lNtEKj9h8IrnEGG6GOXxBuSiXJAGcNErgZw7zhdr1VQpiRkPhEpPtbMsO3bS1W
	 QpkgaRoZPBdrcyx4/vLY11QN04cm/TcG1TmVT6FE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Po-Wen Kao <powen.kao@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Stanley Chu <stanley.chu@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 159/286] scsi: ufs: core: Fix MCQ nr_hw_queues
Date: Wed,  7 Jun 2023 22:14:18 +0200
Message-ID: <20230607200928.315498988@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Po-Wen Kao <powen.kao@mediatek.com>

[ Upstream commit 72a81bb0b6fc9b759ac0fdaca3ec5884a8b2f304 ]

Since MAXQ is 0-based value, add one to obtain number of hardware queues.

Signed-off-by: Po-Wen Kao <powen.kao@mediatek.com>
Link: https://lore.kernel.org/r/20230504154454.26654-4-powen.kao@mediatek.com
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs-mcq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 937933d3f77c2..51b3c6ae781df 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -150,7 +150,8 @@ static int ufshcd_mcq_config_nr_queues(struct ufs_hba *hba)
 	u32 hba_maxq, rem, tot_queues;
 	struct Scsi_Host *host = hba->host;
 
-	hba_maxq = FIELD_GET(MAX_QUEUE_SUP, hba->mcq_capabilities);
+	/* maxq is 0 based value */
+	hba_maxq = FIELD_GET(MAX_QUEUE_SUP, hba->mcq_capabilities) + 1;
 
 	tot_queues = UFS_MCQ_NUM_DEV_CMD_QUEUES + read_queues + poll_queues +
 			rw_queues;
-- 
2.39.2



