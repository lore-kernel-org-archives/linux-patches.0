Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4328821D594;
	Tue, 10 Jun 2025 07:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749539619; cv=none; b=c0hyclru70ubQ8v6X2beJh0kQ7calKaGhiaLKCzWsSo2AntMeAQPEA1KoxpR9B98+g4ulc4rO1vmLyXmPtnv0694sE5C4zm4lpH/C/vGJ1bg1KXa5Jw9BGLsjk24suw2BAlMGUPehEbQ1PF4jRMKQkZTt7OU6b8wVOTTn6PAoSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749539619; c=relaxed/simple;
	bh=r2x5LeEtlYx8MECf8oW5WFH0h9jiFbPXfyHstvEq8dM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R7LLCt8/+Q/U5jGJy1MjlbzsONoiuI9Ndy4GdVZEuMmhBWu4BPXpgS9XlmUphwWLaeWPJl6Qj1NbKbXuzBf6l13autbOWRSuhd5FOziGeaOXeJuUhx5RiMUQoVMxVHIaqq2e440HGAS2MH0oCTk79jbHvHnN18PBvgIZx+X43pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GtF/oqPR; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GtF/oqPR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749539617; x=1781075617;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=r2x5LeEtlYx8MECf8oW5WFH0h9jiFbPXfyHstvEq8dM=;
  b=GtF/oqPRClxITSlFe2ibe1M+jVAvfNUab+3PkUQhxDIG62QEDyA+UWAn
   Kq33a4U03nEvqDYT0Y0HHsTJJm1LofZSNkJL5/Ilxd5jbbvE2zUZboz2h
   Qn2R/880231uXiT8S9ZwtM5qlcM5KnvhVKrWc8ielYUdVJLhZ8cui0EV8
   VTJafiOcCXTa93F2hLoTs7b7mK1V8H/n0EKhqJ23HUJVGwKM1EBFCjGNZ
   l8FtlVe/cCoV+CwEr4H9nqheU9mGz9OuPEQkd3QO+4GqD+GoS3a0myDfA
   fA4vOqFSyVk7uGMp6qllrAJYUTdDOKYjE+Vy/I7XVPPb04SCDEwk9m+RX
   A==;
X-CSE-ConnectionGUID: 0//Ok76fSPiXMGLw/Yz2Mg==
X-CSE-MsgGUID: UYtX8nwkTq+ZdWKad9x25g==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="39256082"
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="39256082"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 00:13:35 -0700
X-CSE-ConnectionGUID: mjbqwKKyQp+VCTn9xroZYw==
X-CSE-MsgGUID: wmQtb+7hQcSAcQbZQJ40SQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="152002052"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 00:13:33 -0700
Message-ID: <39400661-9f18-4ba3-8cb8-d56ef548c9b0@linux.intel.com>
Date: Tue, 10 Jun 2025 15:12:43 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] iommu/vtd: Split paging_domain_compatible()
To: Jason Gunthorpe <jgg@nvidia.com>, David Woodhouse <dwmw2@infradead.org>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev, Wei Wang <wei.w.wang@intel.com>
References: <7-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <7-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/10/25 03:58, Jason Gunthorpe wrote:
> Make First/Second stage specific functions that follow the same pattern in
> intel_iommu_domain_alloc_first/second_stage() for computing
> EOPNOTSUPP. This makes the code easier to understand as if we couldn't
> create a domain with the parameters for this IOMMU instance then we
> certainly are not compatible with it.
> 
> Check superpage support directly against the per-stage cap bits and the
> pgsize_bitmap.
> 
> Add a note that the force_snooping is read without locking. The locking
> needs to cover the compatible check and the add of the device to the list.
> 
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>
> ---
>   drivers/iommu/intel/iommu.c | 66 ++++++++++++++++++++++++++++++-------
>   1 file changed, 54 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index ab2e9fef75293c..a482d1b77d1203 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -3416,33 +3416,75 @@ static void intel_iommu_domain_free(struct iommu_domain *domain)
>   	kfree(dmar_domain);
>   }
>   
> +static int paging_domain_compatible_first_stage(struct dmar_domain *dmar_domain,
> +						struct intel_iommu *iommu)
> +{
> +	if (WARN_ON(dmar_domain->domain.dirty_ops ||
> +		    dmar_domain->nested_parent))
> +		return -EINVAL;
> +
> +	/* Only SL is available in legacy mode */
> +	if (!sm_supported(iommu) || !ecap_flts(iommu->ecap))
> +		return -EINVAL;
> +
> +	/* Same page size support */
> +	if (!cap_fl1gp_support(iommu->cap) &&
> +	    (dmar_domain->domain.pgsize_bitmap & SZ_1G))
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +static int
> +paging_domain_compatible_second_stage(struct dmar_domain *dmar_domain,
> +				      struct intel_iommu *iommu)
> +{
> +	unsigned int sslps = cap_super_page_val(iommu->cap);
> +
> +	if (dmar_domain->domain.dirty_ops && !ssads_supported(iommu))
> +		return -EINVAL;
> +	if (dmar_domain->nested_parent && !nested_supported(iommu))
> +		return -EINVAL;
> +
> +	/* Legacy mode always supports second stage */
> +	if (sm_supported(iommu) && !ecap_slts(iommu->ecap))
> +		return -EINVAL;
> +
> +	/* Same page size support */
> +	if (!(sslps & BIT(0)) && (dmar_domain->domain.pgsize_bitmap & SZ_2M))
> +		return -EINVAL;
> +	if (!(sslps & BIT(1)) && (dmar_domain->domain.pgsize_bitmap & SZ_1G))
> +		return -EINVAL;
> +	return 0;
> +}
> +
>   int paging_domain_compatible(struct iommu_domain *domain, struct device *dev)
>   {
>   	struct device_domain_info *info = dev_iommu_priv_get(dev);
>   	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
>   	struct intel_iommu *iommu = info->iommu;
> +	int ret = -EINVAL;
>   	int addr_width;
>   
> -	if (WARN_ON_ONCE(!(domain->type & __IOMMU_DOMAIN_PAGING)))
> -		return -EPERM;
> +	if (domain->ops == &intel_fs_paging_domain_ops)
> +		ret = paging_domain_compatible_first_stage(dmar_domain, iommu);
> +	else if (domain->ops == &intel_ss_paging_domain_ops)
> +		ret = paging_domain_compatible_second_stage(dmar_domain, iommu);
> +	else if (WARN_ON(true))
> +		ret = -EINVAL;
> +	if (ret)
> +		return ret;
>   
> +	/*
> +	 * FIXME this is locked wrong, it needs to be under the
> +	 * dmar_domain->lock
> +	 */
>   	if (dmar_domain->force_snooping && !ecap_sc_support(iommu->ecap))
>   		return -EINVAL;

Perhaps we can use group->mutex to fix this in the future?

paging_domain_compatible() is in the domain attaching path, which is
already synchronized by group->mutex. We can further expose an iommu
interface for cache coherency enforcement, which would also apply group-
 >mutex.

Thanks,
baolu
