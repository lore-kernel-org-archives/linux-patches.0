Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59F18BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:01:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A41C433EF;
	Tue, 28 Mar 2023 15:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015667;
	bh=F4cf46G1SzMAmP/1mVA/MZTSif0m74J5A6XC5SLL+R8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OLcb80kFODLhoebSdH1FiS7uR8ojWiVOZfUdg18yojJMBlIyBIeuqv+gvfz1Qal1z
	 YifbNCwal6g0wE9HMUF5ZI3zs/YCdpJjWfD/lHPkZG6jUGF21AX80JgmL3kAaX3se0
	 AjUQrMRRUgHhEJTI6/gTP4OQsJ6OEa5OaaK0m+G0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Chen <void0red@gmail.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 132/224] scsi: hisi_sas: Check devm_add_action() return value
Date: Tue, 28 Mar 2023 16:42:08 +0200
Message-Id: <20230328142622.878810134@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kang Chen <void0red@gmail.com>

[ Upstream commit 06d1a90de60208054cca15ef200138cfdbb642a9 ]

In case devm_add_action() fails, check it in the caller of
interrupt_preinit_v3_hw().

Link: https://lore.kernel.org/r/20230227031030.893324-1-void0red@gmail.com
Signed-off-by: Kang Chen <void0red@gmail.com>
Acked-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index d56b4bfd27678..620dcefe7b6f4 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2448,8 +2448,7 @@ static int interrupt_preinit_v3_hw(struct hisi_hba *hisi_hba)
 	hisi_hba->cq_nvecs = vectors - BASE_VECTORS_V3_HW;
 	shost->nr_hw_queues = hisi_hba->cq_nvecs;
 
-	devm_add_action(&pdev->dev, hisi_sas_v3_free_vectors, pdev);
-	return 0;
+	return devm_add_action(&pdev->dev, hisi_sas_v3_free_vectors, pdev);
 }
 
 static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
-- 
2.39.2



