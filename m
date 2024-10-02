Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C611D1728;
	Wed,  2 Oct 2024 14:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877727; cv=none; b=ZfImJpdPxQe9WBnQxzhuiSnRS0GvcJitPGHI7nHDZd4m1v/oMNx7k1XadakPMTV8dLecB9HpWCYdvKYZGvMJDXxxTYOA39+e3vE/ezQPelWC1U3Lfo2+0X2NYCPdmTzyhOLdPyr7KJtE6Fu/BldVkdJRTmvZFPUW114jPI98FZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877727; c=relaxed/simple;
	bh=EJoRk00ZcCSzZmWI0u1xuOD22LQ3GJKlGaWVxUs9hzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSb2KdDSI/IWLCy6qLYRv3fkI9d7Z54zfkmBJjhw3+XccYM5WgpHFn+RK2kb0kdTxtjHjU5n7MyefyOdYvu9jwIrutc46On3tD9FPz0I6WMpgV7Fe8EvwBAPdrf/3Qivu/n5x4rKk1ul4zq6vs7iE551m6KBZ030dkMqC6QSXuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DpKmG0DV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DpKmG0DV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6143C4CEC2;
	Wed,  2 Oct 2024 14:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877727;
	bh=EJoRk00ZcCSzZmWI0u1xuOD22LQ3GJKlGaWVxUs9hzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DpKmG0DVjwZ0ZXeUdf82jQzdNoDuJPcbnbverxLTGavdyrQQ+w6Lmfrk1q53x2T2H
	 h1hu9gIsqYdL5Cy9H6f0vqPPTxyRdy8Q9g7UDvO3XvYe5rhGT/cVbFJmmmqmFHS6Lb
	 N0GFdgPyF8lDUGcZcFw8Q7XIGR3JJ9PUB7g7tit8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 166/634] iommu/amd: Convert comma to semicolon
Date: Wed,  2 Oct 2024 14:54:26 +0200
Message-ID: <20241002125817.663222958@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 86c5eac3c4c4a2ee124d202af9a141bd0457ee68 ]

Replace a comma between expression statements by a semicolon.

Fixes: c9b258c6be09 ("iommu/amd: Prepare for generic IO page table framework")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Link: https://lore.kernel.org/r/20240716072545.968690-1-nichen@iscas.ac.cn
Signed-off-by: Will Deacon <will@kernel.org>
Stable-dep-of: 7a41dcb52f9d ("iommu/amd: Set the pgsize_bitmap correctly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/io_pgtable.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index 9d9a7fde59e75..1074ee25064d0 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -588,9 +588,9 @@ static struct io_pgtable *v1_alloc_pgtable(struct io_pgtable_cfg *cfg, void *coo
 {
 	struct amd_io_pgtable *pgtable = io_pgtable_cfg_to_data(cfg);
 
-	cfg->pgsize_bitmap  = AMD_IOMMU_PGSIZES,
-	cfg->ias            = IOMMU_IN_ADDR_BIT_SIZE,
-	cfg->oas            = IOMMU_OUT_ADDR_BIT_SIZE,
+	cfg->pgsize_bitmap  = AMD_IOMMU_PGSIZES;
+	cfg->ias            = IOMMU_IN_ADDR_BIT_SIZE;
+	cfg->oas            = IOMMU_OUT_ADDR_BIT_SIZE;
 	cfg->tlb            = &v1_flush_ops;
 
 	pgtable->iop.ops.map_pages    = iommu_v1_map_pages;
-- 
2.43.0



