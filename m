Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5708125B2;
	Fri, 28 Feb 2025 02:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740708195; cv=none; b=Vmq/KrMWVSDUYBEM/vZTehqELayhL8Bwsp16GaqkpY7v9pVT+3jhhVsTkQRyMd2AiotC0bViOtDw+cbW3mgL05vA6qhiOuKZfEqywr0D0bK8+pZkav62MUPpBO8FpnHhmJXzi2KebKRFIOgonaIR9bHFP23nPad3JaSK5FtoWX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740708195; c=relaxed/simple;
	bh=0T6aoo2qvY2WxdM4miNaYXLV2tFSlh9l306+7DiV4kw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uc6x3MjLxphX2CKEDjJw1Ms+wG+Xq6jn9sMwSmPK3JUPlvoKotKerxwNTi4r4w0NajUOQwbntSO9zpX52w0SxbIU8eQg7jafpy1oCAX67Ptib3TDIpcLk9qhut87BJMzw17ieFAyHS/E5AEIcelGpzyXO8JuKOYV5hbKkh4ZEuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NW9DlG0S; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NW9DlG0S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740708194; x=1772244194;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0T6aoo2qvY2WxdM4miNaYXLV2tFSlh9l306+7DiV4kw=;
  b=NW9DlG0StS6WnvWS4MQDkivQdTQcWssdmtjMLgShmvRcXR4s5Co5qHR/
   KbC8NmpjqBKk7jyl5CdZqApW2bKS70w5Oo0aMl4/A8g00to5gOEg+Ir1b
   ijkQBokJsaQc7q0qgppzjaaz6lRQFfaxiJFNW3VdCAfmWUkPWSts5Ypys
   ubIeie86m66CBAn+xVLwxOjPhGRWyghW058GDeuKx4xKWXg6KNj6ZGAno
   irVqcePUtHMe6/3rOxsh8e0A2A3LoQu5igH5GsW8JsfCWMdiUlZo9c1Ql
   VKraKMdW4p41hVhTk4tPpi86ms+OCD3d7x6mAh77lRsmR6lyw7Fxr8yTS
   g==;
X-CSE-ConnectionGUID: j/oKwD5nTfSu6dOX33JANQ==
X-CSE-MsgGUID: idRjVG1ETYu/JXYrOA6HTg==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="64092565"
X-IronPort-AV: E=Sophos;i="6.13,321,1732608000"; 
   d="scan'208";a="64092565"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 18:03:13 -0800
X-CSE-ConnectionGUID: Czi05ndaRMakUgVxLemY1Q==
X-CSE-MsgGUID: NJcZ0i+IQYW1EVywxPpzsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,321,1732608000"; 
   d="scan'208";a="117184811"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 18:03:11 -0800
Message-ID: <3e8c4615-7f46-44a3-91fd-74da59c5b13d@linux.intel.com>
Date: Fri, 28 Feb 2025 09:59:53 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] iommu: Add domain_alloc_identity()
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 virtualization@lists.linux.dev, Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>, patches@lists.linux.dev
References: <2-v2-a3b72fd4b99a+1b6-iommu_virtio_domains_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <2-v2-a3b72fd4b99a+1b6-iommu_virtio_domains_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/28/25 08:20, Jason Gunthorpe wrote:
> virtio-iommu has a mode where the IDENTITY domain is actually a paging
> domain with an identity mapping covering some of the system address
> space manually created.
> 
> To support this add a new domain_alloc_identity() op that accepts
> the struct device so that virtio can allocate and fully finalize a
> paging domain to return.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/iommu.c        | 20 ++++++++++++--------
>   drivers/iommu/virtio-iommu.c | 11 ++---------
>   include/linux/iommu.h        |  4 ++++
>   3 files changed, 18 insertions(+), 17 deletions(-)
> 

[...]

> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 38c65e92ecd091..6389d59178ba3f 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -557,6 +557,9 @@ iommu_copy_struct_from_full_user_array(void *kdst, size_t kdst_entry_size,
>    * @domain_alloc: allocate and return an iommu domain if success. Otherwise
>    *                NULL is returned. The domain is not fully initialized until
>    *                the caller iommu_domain_alloc() returns.
> + * @domain_alloc_identity: allocate an IDENTITY domain. Drivers should prefer to
> + *                         use identity_domain instead. This should only be used
> + *                         if dynamic logic is necessary.
>    * @domain_alloc_paging_flags: Allocate an iommu domain corresponding to the
>    *                     input parameters as defined in
>    *                     include/uapi/linux/iommufd.h. The @user_data can be
> @@ -615,6 +618,7 @@ struct iommu_ops {
>   
>   	/* Domain allocation and freeing by the iommu driver */
>   	struct iommu_domain *(*domain_alloc)(unsigned iommu_domain_type);
> +	struct iommu_domain *(*domain_alloc_identity)(struct device *dev);
>   	struct iommu_domain *(*domain_alloc_paging_flags)(
>   		struct device *dev, u32 flags,
>   		const struct iommu_user_data *user_data);

This seems to be a paging domain with identity mappings for some
specific ranges. We make it an IDENTITY domain type because it should be
static and drivers are not allowed to change the mappings once it is
created.

So perhaps naming the callback as domain_alloc_paging_identity, or
domain_alloc_paging_static?

Thanks,
baolu
