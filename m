Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585F7522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:34:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC444C433C8;
	Sun,  9 Jul 2023 11:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902464;
	bh=cnKWeIKTj6r865bXkmKB3uxUizWw8IXkRUXUT6I2jCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FxuQphHei42pjePwLqnwgpeVXMLi2abQ9ZeRXGQPWwh1PLJbM6Te1drXgbJM8sbQ5
	 ZO52Kyt+ty8XbNzHzzXCLLJtTcdTN7CJu4JkloG0UQLIN4ggH6nQcO+aq1esc8l+J9
	 FEV2yJaC955GNEBqaLVI1ZVuq2KqC0dIO+/i1eow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>,
	Bean Huo <beanhuo@micron.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 385/431] scsi: ufs: core: Remove a ufshcd_add_command_trace() call
Date: Sun,  9 Jul 2023 13:15:33 +0200
Message-ID: <20230709111500.191039125@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
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
index dc63bd60db77d..b788bd0053330 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5420,7 +5420,6 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
 		   lrbp->command_type == UTP_CMD_TYPE_UFS_STORAGE) {
 		if (hba->dev_cmd.complete) {
 			hba->dev_cmd.cqe = cqe;
-			ufshcd_add_command_trace(hba, task_tag, UFS_DEV_COMP);
 			complete(hba->dev_cmd.complete);
 			ufshcd_clk_scaling_update_busy(hba);
 		}
-- 
2.39.2



