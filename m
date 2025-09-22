Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E629475;
	Mon, 22 Sep 2025 02:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758508493; cv=none; b=aWkPdCTK1Yvex8gD//t2aRVgR/89W97r/zWgoOhSuQ7GaRYz3ps7SQ2ZJlkU/lejb5KqsmTSbHuO1MLKbeLU87NK7amvqHCjrOEiBMU/sn5+LuEbAGLgiyAK4HdAS4jUilRIFAARwVUIThQFNSDj4yXars1HIE8eqDELCJz3E8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758508493; c=relaxed/simple;
	bh=wkboUVcjZV+wPCCAmyscZJ148qbyWn9Ptf3UraYhegg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=riuZpyBudt4+JB9/JwTdAF6UJlxlUDDxBpajYb0Ge5EDU8b61VsfT+epN901FYrAMYvAkiRE4OGpj7b+mBINeT4NaBcv2xO5n6bnnbQX/Y+zH4vrn/6qCu0i8u/agOo7WXcYw3WaPDMCSxSsJWqKuGlIRBRXvqXmLWCtSHVmQ10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lBdfxogI; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lBdfxogI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758508492; x=1790044492;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wkboUVcjZV+wPCCAmyscZJ148qbyWn9Ptf3UraYhegg=;
  b=lBdfxogIlfZb44CxpVtHdCJzpypzHmkxI+UzDOf5zRtPg6sm4sq+5D87
   7+c24S8310JhAhixxd9jzbieu6iFlW95QXTtJyZAAT+HAJym1ITxmiy+T
   NmX3/IqiaGF1KkPKF52meDp67abiAjtjBwNrFKAGHWGdDgCSrg1kRIWEr
   FWy8zJekTdOuWiuSAwJcdW19xUrwhclVq4yGNjxFha2cwNVwZ7OCyhn3D
   EZY2+h6nE2iJZwHvjKjhqZIAAI2YDEaTV84jqoR+67DsarIbBHpFeXmNy
   7Itw10uHRrJ1n2fa+jWc1JgPG2H1AB3+XPU/VRXpeoVB21rQeHAl6IBRG
   A==;
X-CSE-ConnectionGUID: fCRdQk9mSc2GLteeofQcjw==
X-CSE-MsgGUID: HgTxEb8wSqyePUpvIHpotQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11560"; a="60925238"
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="60925238"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2025 19:34:51 -0700
X-CSE-ConnectionGUID: onhjmhx6T+2qjLyTvwK2qw==
X-CSE-MsgGUID: BJaNWodNTzigb+06Rj5rcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="175959915"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2025 19:34:48 -0700
Message-ID: <00a3fff5-bf1e-461b-9673-14725e3cd6e4@linux.intel.com>
Date: Mon, 22 Sep 2025 10:31:49 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/10] iommupt: Flush the CPU cache after any writes to
 the page table
To: Jason Gunthorpe <jgg@nvidia.com>, David Woodhouse <dwmw2@infradead.org>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>
Cc: Kevin Tian <kevin.tian@intel.com>, patches@lists.linux.dev,
 Tina Zhang <tina.zhang@intel.com>, Wei Wang <wei.w.wang@intel.com>
References: <4-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <4-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/27/25 01:26, Jason Gunthorpe wrote:
> @@ -585,6 +635,7 @@ static __always_inline int __do_map_single_page(struct pt_range *range,
>   			return -EADDRINUSE;
>   		pt_install_leaf_entry(&pts, map->oa, PAGE_SHIFT,
>   				      &map->attrs);
> +		/* No flush, not used when incoherent */
>   		map->oa += PAGE_SIZE;
>   		return 0;
>   	}
> @@ -811,7 +862,8 @@ int DOMAIN_NS(map_pages)(struct iommu_domain *domain, unsigned long iova,
>   	PT_WARN_ON(map.leaf_level > range.top_level);
>   
>   	do {
> -		if (single_page) {
> +		if (single_page &&
> +		    !pt_feature(common, PT_FEAT_DMA_INCOHERENT)) {
>   			ret = pt_walk_range(&range, __map_single_page, &map);
>   			if (ret != -EAGAIN)
>   				break;

I don't follow the single_page logic here. Why is single_page exclusive
with PT_FEAT_DMA_INCOHERENT? To my understanding, PT_FEAT_DMA_INCOHERENT
has no relationship with how the page table is organized. Could you
elaborate a bit?

Thanks,
baolu
