Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2111FC7C2;
	Wed,  5 Feb 2025 14:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766831; cv=none; b=oCMVrUTgKNfwb8v9tXw3KDzHTwNYSPZlDGz8OtRtc090x85EapR4ubnD3i+QYKwdOtuVjcaFlboBezv1AoUNzpTWFQs/yZQ++VeydE1d3FXBu20YFFMyl5C4YTWFw43RV5PfOZIsCqxK4By6R3HCabl88g9HHDfIfG3hpLN/vTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766831; c=relaxed/simple;
	bh=IPOUgjUwndzaIDBbu6j4ae/bC794uBxYXl34gRa815U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qijcnyMJug2qz2UuySCZ9UXR9aLPQYEJLnfEvYYB8EUo9zcH3zgwxWTAJ+6q6I9PkkUlBOrBLLBvSLl5oHKG2ius2/aG43GIPhmC6/Hicw2ycMoQFDS/YEsGFTwezISZ5Kcg5l+vN8PK/O9IYa6ofzVAIYsYApdsQWVoXJAMivQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o6Pl67f8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o6Pl67f8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E5DCC4CED1;
	Wed,  5 Feb 2025 14:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766830;
	bh=IPOUgjUwndzaIDBbu6j4ae/bC794uBxYXl34gRa815U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o6Pl67f8KxeMpMsU/F/x69oPTUq9qaANJMFx+tIsow7wAm/tRG6E7t45s9RDuoDct
	 IN0kIh6k3UXE5U0k09idQKqC/8I8IgO2XsQ5tY1V0lGLW4edSt6QUnOT9/a6FMUBfa
	 pMVcrUhjQCHzqXKDKZGuyULV0ELCFS87T2G4sIO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 314/623] iommu/amd: Remove unused amd_iommu_domain_update()
Date: Wed,  5 Feb 2025 14:40:56 +0100
Message-ID: <20250205134508.236020163@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 1bef5d55b2f9d..c38e02510cf73 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -89,7 +89,6 @@ int amd_iommu_complete_ppr(struct device *dev, u32 pasid, int status, int tag);
  */
 void amd_iommu_flush_all_caches(struct amd_iommu *iommu);
 void amd_iommu_update_and_flush_device_table(struct protection_domain *domain);
-void amd_iommu_domain_update(struct protection_domain *domain);
 void amd_iommu_domain_flush_pages(struct protection_domain *domain,
 				  u64 address, size_t size);
 void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 16f40b8000d79..7e7246c49006a 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1603,15 +1603,6 @@ void amd_iommu_update_and_flush_device_table(struct protection_domain *domain)
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



