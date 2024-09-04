Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72D5E1CCEF6;
	Wed,  4 Sep 2024 09:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725442788; cv=none; b=rCfFKVaWW/ZMyyfhGsoUY4dMfbetAP7GWJ+zfldojKI+n4iLHUEDpY9mimTE+GLKvuREmYmjvwqohy2plQ3PFpW0Gf/KWRnFmgb/DkqlIndR5tW9xrEVaAX+NOb1Oa3n+dxMAGqS4XDnabsQcZ0qO4KlzmjpeuNLyjE59RXPvr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725442788; c=relaxed/simple;
	bh=CddvKxH3zQWkoMFnZXITl8R2jYedP+QqRmTlXxvygh0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jIxPxqJncGFx17ernGS7jgHM/tLscP5eUqgeNuqyGuuvUZXhzbbAJ0cmKaydKe6rEDf8sD6lIr1FjBx/5yolVNBxevfova0H48fNaY2caDrEo4vHO8eZ98PLnjfpCQQ/kwbqQ6P8iMV9KSr9zNwahMgArpMiNigF58YnN9L7evk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=CWyhRG2y; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="CWyhRG2y"
Received: from 8bytes.org (p4ffe1f47.dip0.t-ipconnect.de [79.254.31.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 4E710285A43;
	Wed,  4 Sep 2024 11:39:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1725442785;
	bh=CddvKxH3zQWkoMFnZXITl8R2jYedP+QqRmTlXxvygh0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CWyhRG2yGf8eDOTbnhYB/bZZ8wR2XnS+yQGMCc0YO/mKKCTZtadmAMw8jsFkpsiQ/
	 /vWxuIDawEs1g8AKy2YogHNiXWZ+Ww2P1+OUESUP59f4hrTxbN8Yyw/6QOYuqWWGBU
	 T0DWz50XD+stOY7c4ttYwdwE+Qd9dOYm+5tJbR6pCSa4tZCc9wd3OkAo+s3BcAlq3N
	 ECxC7tF+HEueUZ7xpUaeqS1tACbm5Ra4S/DDOiHjm0fHuWjnJq71y1nEi5GYQR5T8m
	 P76IzG081cFVd1moVSb4vFNkwk7uP79I+ejQMS7cYCVTafPgQ8JAdKv/9nQoSdo4mI
	 OJG/snhtbvYTg==
Date: Wed, 4 Sep 2024 11:39:44 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Joerg Roedel <jroedel@suse.de>, patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: Re: [PATCH v2 00/14] Minor fixups and refactorings for AMD's
 io-pgtable code
Message-ID: <Ztgq4Kl4SmcxrjlY@8bytes.org>
References: <0-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>

On Thu, Aug 29, 2024 at 09:06:09PM -0300, Jason Gunthorpe wrote:
> Jason Gunthorpe (14):
>   iommu/amd: Move allocation of the top table into v1_alloc_pgtable
>   iommu/amd: Allocate the page table root using GFP_KERNEL
>   iommu/amd: Set the pgsize_bitmap correctly
>   iommu/amd: Remove amd_iommu_domain_update() from page table freeing
>   iommu/amd: Remove the amd_iommu_domain_set_pt_root() and related
>   iommu/amd: Rename struct amd_io_pgtable iopt to pgtbl
>   iommu/amd: Remove amd_io_pgtable::pgtbl_cfg
>   iommu/amd: Store the nid in io_pgtable_cfg instead of the domain
>   iommu/amd: Narrow the use of struct protection_domain to invalidation
>   iommu/amd: Remove conditions from domain free paths
>   iommu/amd: Fix typo of , instead of ;
>   iommu/amd: Remove the confusing dummy iommu_flush_ops tlb ops
>   iommu/amd: Correct the reported page sizes from the V1 table
>   iommu/amd: Do not set the D bit on AMD v2 table entries

Applied, thanks.
