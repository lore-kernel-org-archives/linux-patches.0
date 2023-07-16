Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F48C8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:15:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA85C433C9;
	Sun, 16 Jul 2023 20:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538526;
	bh=wKk65Xx5bxwxBXHIKSkLE2150R30Uk3WwBv7IhxsWnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t4+R+3nl5Meef/pIM2Lrqro4VwKdKkH+Gzq2xOHk+3zON/cczfWKBq7DE21MkrCoC
	 L/wGgmedMvOSErnkjeBy8UDtyETMrKyQPsKG1J7a3zTwbQclLItQ1iuD4wEU7LmgBa
	 7PnAaupY4VxaKHfR/8sSvO/Wdzk5ffQOmSB7/w2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>,
	Bean Huo <beanhuo@micron.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 482/800] scsi: ufs: core: Remove a ufshcd_add_command_trace() call
Date: Sun, 16 Jul 2023 21:45:35 +0200
Message-ID: <20230716195000.274398335@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 72554035b9797e00e68cd866e6cefa7f0b2c6f76 ]

ufshcd_add_command_trace() traces SCSI commands. Remove a
ufshcd_add_command_trace() call from a code path that is not related to
SCSI commands.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20230531224050.25554-1-bvanassche@acm.org
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 0fef6bb730c4 ("scsi: ufs: core: mcq: Fix the incorrect OCS value for the device command")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7c133852dc8a4..41f383b588865 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5451,7 +5451,6 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
 		   lrbp->command_type == UTP_CMD_TYPE_UFS_STORAGE) {
 		if (hba->dev_cmd.complete) {
 			hba->dev_cmd.cqe = cqe;
-			ufshcd_add_command_trace(hba, task_tag, UFS_DEV_COMP);
 			complete(hba->dev_cmd.complete);
 			ufshcd_clk_scaling_update_busy(hba);
 		}
-- 
2.39.2



