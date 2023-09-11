Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16924C8A
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:51:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE20C433C9;
	Mon, 11 Sep 2023 14:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443892;
	bh=R0fB4VDqhwvCcxCr4SEGbbBQKUALlXKURUuBTZZG+lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FO9T8gb3f+O7WnXdyyi/0GJ6XdXps/gvu6zrlTGUbzafnpAT0OF+FmC1rPP2pQMxJ
	 CtIS522hzS4/iMeaFiHLjOXRM0yVwakVvGiqa2TjoLHcZ5kCgV3dQgHdwSm1RXlGml
	 HaDMQxBufYFAr1P4d2+gwyREP7kkex6RzpdgCi4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Wang <wangzhu9@huawei.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 537/737] iommu: Remove kernel-doc warnings
Date: Mon, 11 Sep 2023 15:46:36 +0200
Message-ID: <20230911134705.565872079@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Wang <wangzhu9@huawei.com>

[ Upstream commit 6b7867b5b8a6b14c487bf04a693ab424c7a8718d ]

Remove kernel-doc warnings:

drivers/iommu/iommu.c:3261: warning: Function parameter or member 'group'
not described in 'iommu_group_release_dma_owner'
drivers/iommu/iommu.c:3261: warning: Excess function parameter 'dev'
description in 'iommu_group_release_dma_owner'
drivers/iommu/iommu.c:3275: warning: Function parameter or member 'dev'
not described in 'iommu_device_release_dma_owner'
drivers/iommu/iommu.c:3275: warning: Excess function parameter 'group'
description in 'iommu_device_release_dma_owner'

Signed-off-by: Zhu Wang <wangzhu9@huawei.com>
Fixes: 89395ccedbc1 ("iommu: Add device-centric DMA ownership interfaces")
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20230731112758.214775-1-wangzhu9@huawei.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index f1dcfa3f1a1b4..88e7154f846d3 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3196,7 +3196,7 @@ static void __iommu_release_dma_ownership(struct iommu_group *group)
 
 /**
  * iommu_group_release_dma_owner() - Release DMA ownership of a group
- * @dev: The device
+ * @group: The group
  *
  * Release the DMA ownership claimed by iommu_group_claim_dma_owner().
  */
@@ -3210,7 +3210,7 @@ EXPORT_SYMBOL_GPL(iommu_group_release_dma_owner);
 
 /**
  * iommu_device_release_dma_owner() - Release DMA ownership of a device
- * @group: The device.
+ * @dev: The device.
  *
  * Release the DMA ownership claimed by iommu_device_claim_dma_owner().
  */
-- 
2.40.1



