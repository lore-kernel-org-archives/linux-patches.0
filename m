Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D4019FA8D;
	Thu, 15 Aug 2024 14:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731789; cv=none; b=pj95ctae0gUNLS2LZ6FLCuBDOSiR3qYyFoKovoAOXXQi1SaIrVD0I4pTCfLdx3B/5mECsagmntLmz7xHG+8CgVXgl4CuJ4t80hz2Sbu1AJjJwD5XoCLa5FuA89oAW6q0YC3amLT3pIDDx+BCM0sYQ/FO9xuq8rpto57DqNzZ0eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731789; c=relaxed/simple;
	bh=TjdMwtqE1Q7P7vwzT0GWjyRSUTts0NWBn61UyI7slCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kiPoyqrrNiQdpRQ9cZR0EJtAVFoYQmgCont8gxwxMa6k9bwYZSkVWedzOZ4Lxr5eC6c0CAilMZmpsgFYBXXQ8x1yphfVQnWZW78F6JMqp4EedZp98130RZevx2LjIa2jgQTeTmUi/bYPq8lxYzNFXC3AAuk6vf5DRX/f91ro/Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XY8HiVUT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XY8HiVUT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F643C32786;
	Thu, 15 Aug 2024 14:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731788;
	bh=TjdMwtqE1Q7P7vwzT0GWjyRSUTts0NWBn61UyI7slCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XY8HiVUTFsJo4iZaNwMBAb7c0ysbd+2XMeCViRUjrjKKdK3mzOa1zhrVyQAgVNYkE
	 /TYxcHa3QHglW3aYAdXaNm0WXJq0uYW8u1vxVeKJQM4nqycgKM/ZX5yjqKlz6e5w9g
	 YQIZEBL9UmonifFEqhkY1WvHIiXepfiY7B+DXpzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 239/259] scsi: mpt3sas: Remove scsi_dma_map() error messages
Date: Thu, 15 Aug 2024 15:26:12 +0200
Message-ID: <20240815131912.001929951@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 35c97bc660bd8..8d161d6075b78 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2310,12 +2310,8 @@ _base_check_pcie_native_sgl(struct MPT3SAS_ADAPTER *ioc,
 
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
@@ -2422,12 +2418,8 @@ _base_build_sg_scmd(struct MPT3SAS_ADAPTER *ioc,
 
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
@@ -2570,12 +2562,8 @@ _base_build_sg_scmd_ieee(struct MPT3SAS_ADAPTER *ioc,
 
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



