Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C916332ED5C;
	Thu, 28 May 2026 07:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779954171; cv=none; b=oqKVur59PviJNssipFshLcOc3+g6eg7pCuVbL0tNEa+WxSluNQvG40C0GQM+V3etD+8rzVFcQaXUksJAkeHyllToFzmog/kin4+thvpNpC45wha5JqAcBXWilwxqfiqEZa2nBNdAMJhOgvnFjbYL/i/wm3pvtBHjSjSOJFchtTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779954171; c=relaxed/simple;
	bh=FAyZJyYClSxqjP+4F+we/fuRIGc9vFvefgSYkJQt4fA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KgCxU9kN8oNsf9OxfefD72dC7zo/Da2umVVAmC4mopJgurZZsxtZMsJvuAsk4HrGInXUpPf/SovIZrTHKw4gvea+l6Ysfe/Knm0JWTYJfcPUSrqdzsNmGJO7BaZePud+wPnr+kD6M8YxCWPBv5XtlT0v0XvWz4SsG+PKP+Krp2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from 8bytes.org (p200300f6af4fc5001a5b4667a2accba1.dip0.t-ipconnect.de [IPv6:2003:f6:af4f:c500:1a5b:4667:a2ac:cba1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id BF7211C59BB;
	Thu, 28 May 2026 09:42:48 +0200 (CEST)
Date: Thu, 28 May 2026 09:42:47 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>, Vasant Hegde <vasant.hegde@amd.com>
Cc: iommu@lists.linux.dev, Robin Murphy <robin.murphy@arm.com>, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Will Deacon <will@kernel.org>, patches@lists.linux.dev, 
	Wei Wang <wei.w.wang@hotmail.com>
Subject: Re: [PATCH v3 0/5] Improve the invalidation path in AMD
Message-ID: <ahfx0OEnEEcYAxjc@8bytes.org>
References: <0-v3-233e3af938b7+f1-iommupt_inv_amd_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v3-233e3af938b7+f1-iommupt_inv_amd_jgg@nvidia.com>

On Wed, May 13, 2026 at 09:11:15PM -0300, Jason Gunthorpe wrote:
> Jason Gunthorpe (5):
>   iommu/amd: Simplify build_inv_address()
>   iommu/amd: Pass last in through to build_inv_address()
>   iommu/amd: Have amd_iommu_domain_flush_pages() use last
>   iommu/amd: Make CMD_INV_IOMMU_ALL_PAGES_ADDRESS match the spec
>   iommu/amd: Control INVALIDATE_IOMMU_PAGES PDE from the gather
> 
>  drivers/iommu/amd/amd_iommu.h       |   4 +-
>  drivers/iommu/amd/amd_iommu_types.h |   2 +-
>  drivers/iommu/amd/iommu.c           | 176 +++++++++++++---------------
>  drivers/iommu/amd/pasid.c           |   2 +-
>  4 files changed, 87 insertions(+), 97 deletions(-)

Vasant, can you please help reviewing these changes?

Thanks,

	Joerg
