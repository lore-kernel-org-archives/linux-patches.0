Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE9B1C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:02:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF05C433D2;
	Mon, 20 Mar 2023 15:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324535;
	bh=EPAj6tAL9XcSP9tF/z7nCqol0AJV74AxyaxeCqMBx50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Uzo0iHoXyafykE/uToYDD9qmF9fTmb2KVFJU5kpJvbkllo4JZCaYAutXbTIqQB5Z
	 kGQIwK35m3fIdxgzeeXzYUh6U2cCCuUtv1Cajws8XSraPSg7BiOrexCRYXXYDkIqeP
	 5VTm2MCbOQJp+oZMAtyX95vZKJMCaZ/iKr1P0sEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Chen <chenxiang66@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 13/99] scsi: core: Fix a comment in function scsi_host_dev_release()
Date: Mon, 20 Mar 2023 15:53:51 +0100
Message-Id: <20230320145443.904151235@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiang Chen <chenxiang66@hisilicon.com>

[ Upstream commit 2dde5c8d912efea43be94d6a83ac9cb74879fa12 ]

Commit 3be8828fc507 ("scsi: core: Avoid that ATA error handling can
trigger a kernel hang or oops") moved rcu to scsi_cmnd instead of
shost. Modify "shost->rcu" to "scmd->rcu" in a comment.

Link: https://lore.kernel.org/r/1620646526-193154-1-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: be03df3d4bfe ("scsi: core: Fix a procfs host directory removal regression")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hosts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index fae0323242103..0fd2487203ff5 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -325,7 +325,7 @@ static void scsi_host_dev_release(struct device *dev)
 	/* In case scsi_remove_host() has not been called. */
 	scsi_proc_hostdir_rm(shost->hostt);
 
-	/* Wait for functions invoked through call_rcu(&shost->rcu, ...) */
+	/* Wait for functions invoked through call_rcu(&scmd->rcu, ...) */
 	rcu_barrier();
 
 	if (shost->tmf_work_q)
-- 
2.39.2



