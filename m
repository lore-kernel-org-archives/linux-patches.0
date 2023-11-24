Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C712633E9;
	Fri, 24 Nov 2023 18:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OLGs26S0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B7DC433C8;
	Fri, 24 Nov 2023 18:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850928;
	bh=MkaR2df5HHN/zDuQFvz8Rxa7LV7iIq5F9B9/8/MFjm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OLGs26S0uhcFD/WviuH8V36j99/dtO3woLQmxD7LsgHxaTH08+hebT+wp1ffa/caB
	 tTAktFvSSKHB0oy5xAKSKzfPborovUfaaZNOPGE25iyVFpGyJB9qcy1fQdYRx4e3dZ
	 hDPo8JBVcrg7ETqeXXA3V6ORnNFEUDmcVQPe5kio=
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
Subject: [PATCH 6.5 220/491] scsi: ufs: core: Expand MCQ queue slot to DeviceQueueDepth + 1
Date: Fri, 24 Nov 2023 17:47:36 +0000
Message-ID: <20231124172031.164146060@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index 386674ead7f0d..4ecbd30c07827 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -433,7 +433,7 @@ int ufshcd_mcq_init(struct ufs_hba *hba)
 
 	for (i = 0; i < hba->nr_hw_queues; i++) {
 		hwq = &hba->uhq[i];
-		hwq->max_entries = hba->nutrs;
+		hwq->max_entries = hba->nutrs + 1;
 		spin_lock_init(&hwq->sq_lock);
 		spin_lock_init(&hwq->cq_lock);
 		mutex_init(&hwq->sq_mutex);
-- 
2.42.0



