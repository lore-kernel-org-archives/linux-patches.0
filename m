Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFFB151988;
	Wed,  5 Feb 2025 14:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766136; cv=none; b=EC2WelNEBmIwx4/jpDLvdSewWZdNgWaBYG6+VAhd1dktVdZnmBz4gz8Y7f66zy/7ZRUzNOs5PcKsmMzLHq0YFX4UZB05CEHsIMq6E6UzJSgQhPa5a7s/khRoOWVxGCu7lnHjxir01fvCsxtRT4nkf+SA0VTwPT5irI489Jftj9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766136; c=relaxed/simple;
	bh=HOaJ7y5SaHK50TiXViDDsnldon0Stz/W6qQJ2KnTAWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qXu9aqOLY+/kEBBsGIUeBbb4mmZ3rBi7n+tR/P4yAU326BTFsmNScL0bOpYVvAAx4LvChHirfn15qo7UiC21MeYJ7mbuoDIz2vOZ6F6C7xlh/Ff+aeYo8t5csz5r7B/FLez/FZpXK8SvOJmDZCHnkW1Uxg9zlOwDNA++PbN53hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QMoPJo6x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QMoPJo6x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B298AC4CED1;
	Wed,  5 Feb 2025 14:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766136;
	bh=HOaJ7y5SaHK50TiXViDDsnldon0Stz/W6qQJ2KnTAWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QMoPJo6xkZqFYpYyBFlFwp/eFvbMv0usHINpQtnHWqF6/16QK3rHZwFMFfxa4OJRX
	 ypMtDxpKCS+HuYCqrSFhkCsu4gzx6Po/Kw1crIvDK/wxqsyv0v+jPIYzUNPQ8F3L4w
	 MIHt1QhW4HLIBcxEqRGfAwm10EZYzb92dmuo/oZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 290/590] iommu/amd: Remove unused amd_iommu_domain_update()
Date: Wed,  5 Feb 2025 14:40:45 +0100
Message-ID: <20250205134506.371503468@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>

[ Upstream commit 1a684b099fac9a37e6fe2f0e594adbb1eff5181a ]

All the callers have been removed by the below commit, remove the
implementation and prototypes.

Fixes: 322d889ae7d3 ("iommu/amd: Remove amd_iommu_domain_update() from page table freeing")
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/1-v2-9776c53c2966+1c7-amd_paging_flags_jgg@nvidia.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/amd_iommu.h | 1 -
 drivers/iommu/amd/iommu.c     | 9 ---------
 2 files changed, 10 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index 6386fa4556d9b..6fac9ee8dd3ed 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -87,7 +87,6 @@ int amd_iommu_complete_ppr(struct device *dev, u32 pasid, int status, int tag);
  */
 void amd_iommu_flush_all_caches(struct amd_iommu *iommu);
 void amd_iommu_update_and_flush_device_table(struct protection_domain *domain);
-void amd_iommu_domain_update(struct protection_domain *domain);
 void amd_iommu_domain_flush_pages(struct protection_domain *domain,
 				  u64 address, size_t size);
 void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 8364cd6fa47d0..a24a97a2c6469 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1606,15 +1606,6 @@ void amd_iommu_update_and_flush_device_table(struct protection_domain *domain)
 	domain_flush_complete(domain);
 }
 
-void amd_iommu_domain_update(struct protection_domain *domain)
-{
-	/* Update device table */
-	amd_iommu_update_and_flush_device_table(domain);
-
-	/* Flush domain TLB(s) and wait for completion */
-	amd_iommu_domain_flush_all(domain);
-}
-
 int amd_iommu_complete_ppr(struct device *dev, u32 pasid, int status, int tag)
 {
 	struct iommu_dev_data *dev_data;
-- 
2.39.5



