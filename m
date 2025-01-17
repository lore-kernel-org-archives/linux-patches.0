Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69C87149DF4;
	Fri, 17 Jan 2025 07:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737100797; cv=none; b=GdYg8keraAmGiNp/YWQQEEySjqf+hjqh5CMoaK5rbDU1jZdnLs93LQ2veQgT+Eifmj+f5k9RvUiKTCR7HfuBx4ynveZnzUOJM3ynesixojAYRd9cQYKn7JuKCHCBz8shIXoEpuM+VGQoei5K8+++aT8NwwKwBKwYK/94hn3j30w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737100797; c=relaxed/simple;
	bh=MB2EX8MdMm15KohCyfbPTvNU0OewUAL+L/T7eu+J6PA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=caIGImjVu83qxaQ14yhWCz2Gn++6f87vGMvoIgJM4+X428axS4sAR331IH/OBi7IPxOLEDP2duAGfvF5B43rjsXN/kn/dNWuIkFQ9wOc5nKQIFMSu31Al3iwvzCsoB9nyFGLDMefF38dMQFxwKkFXqkdT0LiIjhxLveJ/EbPcQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=NvPFUvvS; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="NvPFUvvS"
Received: from 8bytes.org (p54921e31.dip0.t-ipconnect.de [84.146.30.49])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 39BF72E002E;
	Fri, 17 Jan 2025 08:59:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1737100795;
	bh=MB2EX8MdMm15KohCyfbPTvNU0OewUAL+L/T7eu+J6PA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NvPFUvvSjYCrYHoWgeQNZ8k8f7TyCFQOdr+ajZuZ5Ga78ak12Mphn8BxMHFlgPRf1
	 FVEh8ZOoyiE2t1OjgC0ABUcr3RccV9W1TSbBsvai36JbEz0F0OWtCY3la3IQQ/WmHi
	 LH3JkTTp/W54w8UQbUdVtlNTooadtDUEbkeIYsqvIIf9MTPj3G8f6UeKejYfEG/jDp
	 pNYXVfr0xe8jK5Z856gtjjLJEgaRLEuT9cR7uRuxqEfbj1h3a51HydF3c1RlkuPGcx
	 LZoGKKwW9F9vAiVn5OWurF1luz3CEVgD/XXMspkKm/ezVPmqUGePA5TLtsKeY6S7hy
	 jKS2UywJrICdg==
Date: Fri, 17 Jan 2025 08:59:54 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev, Vasant Hegde <vasant.hegde@amd.com>
Subject: Re: [PATCH v2 0/7] iommu/amd: Cleanup some of the
 domain_alloc_paging path
Message-ID: <Z4oN-qjcKN-89yuq@8bytes.org>
References: <0-v2-9776c53c2966+1c7-amd_paging_flags_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v2-9776c53c2966+1c7-amd_paging_flags_jgg@nvidia.com>

On Fri, Jan 10, 2025 at 12:34:58PM -0400, Jason Gunthorpe wrote:
> This is a small collection of cleanups
>  - Remove amd_iommu_domain_update() (dead code)
>  - Remove domain_alloc()
>  - Remove now obsolete NULL checks
>  - Remove obsolete domain types in the domain_alloc_paging_flags() flow
>  - Use PD_MODE consistently instead of mixing with io_pgtable stuff
> 
> v2:
>  - Remove bitmasking from switch in amd_iommu_domain_alloc_paging_flags()
>  - Update commit messages with comments
> v1: https://patch.msgid.link/r/0-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com
> 
> Alejandro Jimenez (1):
>   iommu/amd: Remove unused amd_iommu_domain_update()
> 
> Jason Gunthorpe (6):
>   iommu/amd: Remove domain_alloc()
>   iommu/amd: Remove dev == NULL checks
>   iommu/amd: Remove type argument from do_iommu_domain_alloc() and
>     related
>   iommu/amd: Change amd_iommu_pgtable to use enum protection_domain_mode
>   iommu/amd: Move the nid to pdom_setup_pgtable()
>   iommu/amd: Fully decode all combinations of alloc_paging_flags
> 
>  drivers/iommu/amd/amd_iommu.h |   5 +-
>  drivers/iommu/amd/init.c      |  14 ++--
>  drivers/iommu/amd/iommu.c     | 144 ++++++++++------------------------
>  drivers/iommu/amd/pasid.c     |   3 +-
>  4 files changed, 54 insertions(+), 112 deletions(-)

Applied, thanks.
