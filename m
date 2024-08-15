Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898061A00CF;
	Thu, 15 Aug 2024 14:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732883; cv=none; b=TVFinskV6pCtnLFAqBRl2IANidzs1efMt53c/6cmvQ0O6f5QicCnz2ybmoBxNuVMZz27MRL/U04xYTQLYs89+oR5wrG9ILZNEsD1BCf+CSATjzpZEu344yFD3nPapdyklrQjVpMV5qrnXO64szO92cKwn6OgR2Wp+LmY/N5JlqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732883; c=relaxed/simple;
	bh=kAg/+b1pqdJIprs1Sy7HkwjLFU0nQyTyOKhoWyz4vEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rH+OXA+PAd7gBO5npeuVdFg8DUQJGLkQ0pQU7hjxlDnyOkP/7G7mFSLeECCVoMR+WbAyYqiIwJVHFr1lRbpehR1r+3+QE22agg7K7Mjy4QSS8dywatd1K3QaU0LBoVDyRLoh25+UOmRUjdbFs8sPw5c1s4vcefrOMbAYJ1cLH9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zm9qmJ20; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zm9qmJ20"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B32C32786;
	Thu, 15 Aug 2024 14:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732883;
	bh=kAg/+b1pqdJIprs1Sy7HkwjLFU0nQyTyOKhoWyz4vEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zm9qmJ20h4AevWUJWNcJk9ctbL/dQICRhAVpZvto4Tp7V5BOkhGIjmPTi5LqW1fPU
	 ZPTjYvW/r5QggLvpzcW6Bud6UvLHrB2COVR+GCLeRU+7jew/LtwfKB8bUcXF7rarDh
	 MVWdKWSF1vsr6Y7m+YJRM0LO7WFr/Hl3ACcWyWGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 314/352] scsi: mpt3sas: Remove scsi_dma_map() error messages
Date: Thu, 15 Aug 2024 15:26:20 +0200
Message-ID: <20240815131931.594081168@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit 0c25422d34b4726b2707d5f38560943155a91b80 ]

When scsi_dma_map() fails by returning a sges_left value less than zero,
the amount of logging produced can be extremely high.  In a recent end-user
environment, 1200 messages per second were being sent to the log buffer.
This eventually overwhelmed the system and it stalled.

These error messages are not needed. Remove them.

Link: https://lore.kernel.org/r/20220303140203.12642-1-sreekanth.reddy@broadcom.com
Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 82dbb57ac8d0 ("scsi: mpt3sas: Avoid IOMMU page faults on REPORT ZONES")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 2803b475dae6a..de4ec552799dd 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2431,12 +2431,8 @@ _base_check_pcie_native_sgl(struct MPT3SAS_ADAPTER *ioc,
 
 	/* Get the SG list pointer and info. */
 	sges_left = scsi_dma_map(scmd);
-	if (sges_left < 0) {
-		sdev_printk(KERN_ERR, scmd->device,
-			"scsi_dma_map failed: request for %d bytes!\n",
-			scsi_bufflen(scmd));
+	if (sges_left < 0)
 		return 1;
-	}
 
 	/* Check if we need to build a native SG list. */
 	if (base_is_prp_possible(ioc, pcie_device,
@@ -2543,12 +2539,8 @@ _base_build_sg_scmd(struct MPT3SAS_ADAPTER *ioc,
 
 	sg_scmd = scsi_sglist(scmd);
 	sges_left = scsi_dma_map(scmd);
-	if (sges_left < 0) {
-		sdev_printk(KERN_ERR, scmd->device,
-		 "scsi_dma_map failed: request for %d bytes!\n",
-		 scsi_bufflen(scmd));
+	if (sges_left < 0)
 		return -ENOMEM;
-	}
 
 	sg_local = &mpi_request->SGL;
 	sges_in_segment = ioc->max_sges_in_main_message;
@@ -2691,12 +2683,8 @@ _base_build_sg_scmd_ieee(struct MPT3SAS_ADAPTER *ioc,
 
 	sg_scmd = scsi_sglist(scmd);
 	sges_left = scsi_dma_map(scmd);
-	if (sges_left < 0) {
-		sdev_printk(KERN_ERR, scmd->device,
-			"scsi_dma_map failed: request for %d bytes!\n",
-			scsi_bufflen(scmd));
+	if (sges_left < 0)
 		return -ENOMEM;
-	}
 
 	sg_local = &mpi_request->SGL;
 	sges_in_segment = (ioc->request_sz -
-- 
2.43.0



