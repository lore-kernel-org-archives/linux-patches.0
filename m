Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0BC522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:33:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E42C433C8;
	Sun,  9 Jul 2023 11:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902380;
	bh=KaBdmezEirM5E/AlwI+05jXjpZl32zrBW1iYAOdwpE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JDRVm6aHUe/QK0U4TCFdloscnTIFRadUQ4yNkIN40XyPF7d9vohu4pFOFnkh6sUV7
	 XIQYpXpo5Ee/qAH21/c+m78/5ZKvduhMzlrBci0pFu60WWwXdSMwrmB8VC7kmguOSS
	 4p/KrZznmSRBcFkXLGuHv/wAasnPWOMx33kFTcUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Keoseong Park <keosung.park@samsung.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 355/431] scsi: ufs: Declare ufshcd_{hold,release}() once
Date: Sun,  9 Jul 2023 13:15:03 +0200
Message-ID: <20230709111459.489013113@linuxfoundation.org>
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

[ Upstream commit 4b68b7f9c46d90c541d39c8b397a86ac0ca4c765 ]

ufshcd_hold() and ufshcd_release are declared twice: once in
drivers/ufs/core/ufshcd-priv.h and a second time in include/ufs/ufshcd.h.
Remove the declarations from ufshcd-priv.h.

Fixes: dd11376b9f1b ("scsi: ufs: Split the drivers/scsi/ufs directory")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20230529202640.11883-5-bvanassche@acm.org
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Keoseong Park <keosung.park@samsung.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd-priv.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index 529f8507a5e4c..7d8ff743a1b28 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -84,9 +84,6 @@ unsigned long ufshcd_mcq_poll_cqe_lock(struct ufs_hba *hba,
 int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
 			    u8 **buf, bool ascii);
 
-int ufshcd_hold(struct ufs_hba *hba, bool async);
-void ufshcd_release(struct ufs_hba *hba);
-
 int ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd);
 
 int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
-- 
2.39.2



