Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF5839FFD;
	Fri, 24 Nov 2023 18:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M54vEV99"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F42FC433C7;
	Fri, 24 Nov 2023 18:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849569;
	bh=kh+lA0s4g5DTBk0ZyXdndng5y8k483xKbMApU1ub1kA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M54vEV99hT7kuEsESuFG32LHeoNO9baXBNccOGLKDJCvf9+wt96MvvZ/nqE9FdNRw
	 fY6pYdb1ffhHPy5Jzzl6pK1cM8r783MAvb7C009ySb2ANsUnATEoyLX6GOch5NGHNh
	 P47bQubvOIc/lPreKgJcgI3qDULuShtZXEwihEuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naomi Chu <naomi.chu@mediatek.com>,
	Stanley Chu <stanley.chu@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Chun-Hung <chun-hung.wu@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 233/530] scsi: ufs: core: Expand MCQ queue slot to DeviceQueueDepth + 1
Date: Fri, 24 Nov 2023 17:46:39 +0000
Message-ID: <20231124172035.145250058@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Naomi Chu <naomi.chu@mediatek.com>

[ Upstream commit defde5a50d91c74e1ce71a7f0bce7fb1ae311d84 ]

The UFSHCI 4.0 specification mandates that there should always be at least
one empty slot in each queue for distinguishing between full and empty
states. Enlarge 'hwq->max_entries' to 'DeviceQueueDepth + 1' to allow
UFSHCI 4.0 controllers to fully utilize MCQ queue slots.

Fixes: 4682abfae2eb ("scsi: ufs: core: mcq: Allocate memory for MCQ mode")
Signed-off-by: Naomi Chu <naomi.chu@mediatek.com>
Link: https://lore.kernel.org/r/20231102052426.12006-2-naomi.chu@mediatek.com
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Chun-Hung <chun-hung.wu@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs-mcq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 2ba8ec254dcee..5c75ab9d6bb50 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -436,7 +436,7 @@ int ufshcd_mcq_init(struct ufs_hba *hba)
 
 	for (i = 0; i < hba->nr_hw_queues; i++) {
 		hwq = &hba->uhq[i];
-		hwq->max_entries = hba->nutrs;
+		hwq->max_entries = hba->nutrs + 1;
 		spin_lock_init(&hwq->sq_lock);
 		spin_lock_init(&hwq->cq_lock);
 		mutex_init(&hwq->sq_mutex);
-- 
2.42.0



