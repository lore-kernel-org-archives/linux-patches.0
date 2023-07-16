Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEC98F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:13:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87B9C433C8;
	Sun, 16 Jul 2023 20:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538434;
	bh=jQwJZ0AjWWaoUEth8BSH8wvlKHw2L6MboJusA8XizdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ic8TCO+1LJuQwbZIH1uqHftJVIY0O1C9X3RWOTqnS5WdNec8YYW7jCl+DJP3jGxBR
	 c+eh/DAk+TqyQZimkgHai5oi+0IOKAVpK0hIgp6G3wOLyxFMXuNqhZ9PXsQ/MOMxwj
	 yLUke0nKAjJq6484hoRQutYHSDzzcXS8LhEVJK24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Keoseong Park <keosung.park@samsung.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 449/800] scsi: ufs: Declare ufshcd_{hold,release}() once
Date: Sun, 16 Jul 2023 21:45:02 +0200
Message-ID: <20230716194959.512733208@linuxfoundation.org>
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
index d53b93c21a0c6..8f58c21693985 100644
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



