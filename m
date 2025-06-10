Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00CB25C81D;
	Tue, 10 Jun 2025 06:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749537724; cv=none; b=hEHLzQ717TaG4FYwcGMoknazPGUDYnoaPezws6pSAior8+K6r3jcOpBl3jAw9z5Kp8O6LDn8UgNbo19ddWMp73OuRRMFVvz+l0Q2Hu+S7uI5dkXv3xUbcL3a/iGutEaW7OMOlbElak/mLJRqgB5l1mEA8xinP6P41iS6ZAxWgKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749537724; c=relaxed/simple;
	bh=mlIq0rj35hHowNTMUTsIRssPhHB0i/W0bi9ky3jkku0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gk4npR/7GWwseECjFkvVuecN3pmyGOvd1N9eD9s+QkK8bjLRWrukeJ1P/Ge1SYj4vtIt9R9A8h8Fhdq8DKJ3PTwl0QRduhf3GNu90NQwGo+Bju4NNOLt4m/oB5f9Xt4jfgagzfXct8kOtBI3tHytsEhqDxXkxwb/bmPRTO9gkJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nfIZm9Lu; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nfIZm9Lu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749537723; x=1781073723;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mlIq0rj35hHowNTMUTsIRssPhHB0i/W0bi9ky3jkku0=;
  b=nfIZm9LuuvnOmDnWEq/sHk0fmjE3b4yWpLM3DoLTUwuf6n5XTkYPX3dH
   /mKDxJIPQR+ukESX8seZiWuKMkeqt7QEi1SaMIJl533ZcbcRPCjaPn1su
   GPcjRgsRHvd+WRkVARfIhEYUss1HAwrtTIRUpMPsu/Up3gNxfW6arwLRB
   1FUAvZ4S27PVQQf19dUuk6+zPC/3YXQnh8DHR4LV/vCe/Zp0zMJOrrSeR
   XNehrdM+uCyXMdQ/UJlDAxbiUbb1gPyHclRP3YF5bUlzCePRAWpkqIR55
   YHnQp2uViik+wKUIokm2B4y2GFfNJboR9+l9FvD90v4GN/VRrJOHtYJJz
   w==;
X-CSE-ConnectionGUID: CamrGX6oRW+8YtaC7TguEQ==
X-CSE-MsgGUID: Qbn56Ap+RxSi2Szkwf/8SQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="55424902"
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="55424902"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 23:42:02 -0700
X-CSE-ConnectionGUID: cKC6HGgKQBCwOQCJTnH5Zg==
X-CSE-MsgGUID: 5e2z/EglQKaLY1TKbbQUAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="147249002"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 23:42:00 -0700
Message-ID: <06566252-25a9-4b68-8deb-e1fbd8b7a3b8@linux.intel.com>
Date: Tue, 10 Jun 2025 14:41:11 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] iommu/vtd: Do not wipe out the page table NID when
 devices detach
To: Jason Gunthorpe <jgg@nvidia.com>, David Woodhouse <dwmw2@infradead.org>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev, Wei Wang <wei.w.wang@intel.com>
References: <3-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <3-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/10/25 03:58, Jason Gunthorpe wrote:
> The NID is used to control which NUMA node memory for the page table is
> allocated it from. It should be a permanent property of the page table
> when it was allocated and not change during attach/detach of devices.
> 
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>
> ---
>   drivers/iommu/intel/iommu.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index ceb960a796e2ba..72b0769c391008 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -1391,7 +1391,6 @@ void domain_detach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu)
>   	if (--info->refcnt == 0) {
>   		ida_free(&iommu->domain_ida, info->did);
>   		xa_erase(&domain->iommu_array, iommu->seq_id);
> -		domain->nid = NUMA_NO_NODE;

It appears that this is a fix. Before domain_alloc()'s retirement, no
device pointer was passed to the domain allocation callback. Thus, the
NUMA node ID could only be determined when the domain was attached to a
device. Since we have introduced domain_alloc_paging, this should be
removed. So,

Fixes: 7c204426b818 ("iommu/vt-d: Add domain_alloc_paging support")

?

Thanks,
baolu
