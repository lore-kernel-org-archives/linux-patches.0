Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1948978F32;
	Tue, 22 Jul 2025 05:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753161605; cv=none; b=EIz6RsYpW8nc6g5DxW8Ht8YjT2o0z9SRKHebM7esgZba3IWh6noYbcap0Ho3d5ViE5s8vmNRw22z0GNoGhfM0jH1AuS8is1VBBa7GxppKRZWQ5xb0vQHRIcC8wrpaQHK184GkoVYXlNHzJKMbucHJ9jf3P+W6loB6N2j78AYemY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753161605; c=relaxed/simple;
	bh=Dq607I8+TmFXPI8DmtNEV2Iwt1khzz5gL6Ql7pGMx84=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pLqTerZfLUflsMHcht2dBKAjBOtf5g79z6s9bLNDi8pNyaS5lclJgRaDOlFXV/RqXjMg4rgPYARhmSsAkjU1OHp6qaDstA/aGhLP28C7MllBxiA3mebD0gt44HJt4OdwUks6oCivCI+geNm3plPWvWd9b2ayVtajE1DSu+oA35g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NuFCXXvj; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NuFCXXvj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753161604; x=1784697604;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Dq607I8+TmFXPI8DmtNEV2Iwt1khzz5gL6Ql7pGMx84=;
  b=NuFCXXvjR3niVFRwGb6ebGZkSzlaReMbi7xMwuzsflmN8tA3BmY+kQ8w
   iW9RDzblkseQ/EFmGAbUeWmTRFM7K8Iykx6pIh9+78w98bouCZP0fxewl
   rTyB5RX4J3eT253CSEei/5k4zAYf/UNM2cnqkg11PNqOQz25FHBoExAu5
   4Je7qfx4cIcG7u5NoZ+7CLFY8veOsA6EZ3i3oma8p0n51WdZ8kRMzFhTw
   rc6aL/tgZsq7akVApZA/bWPR5QQ71GHpMST0jrgZk5BpGcQax6RHRY4XW
   m7g4Y1Yku2WXHLAAT80Z1kr23LRHGe+5tRASD05uRc6C2JxK/dXdGFXkn
   A==;
X-CSE-ConnectionGUID: PdMA9T72SS6JEAOO/TVLbw==
X-CSE-MsgGUID: ++Hud8dUTxWRhOrIFwOiWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11499"; a="66739965"
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="66739965"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 22:20:03 -0700
X-CSE-ConnectionGUID: 99yeqcaeT+evCr9eoblOiw==
X-CSE-MsgGUID: d60c7TEaTVuuurymKyR0sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="158688984"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 22:20:01 -0700
Message-ID: <158774a0-824f-42a7-93c9-fb1e0d258cc7@linux.intel.com>
Date: Tue, 22 Jul 2025 13:17:59 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/9] iommupt/x86: Support SW bits and permit
 PT_FEAT_DMA_INCOHERENT
To: Jason Gunthorpe <jgg@nvidia.com>, David Woodhouse <dwmw2@infradead.org>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>
Cc: Kevin Tian <kevin.tian@intel.com>, patches@lists.linux.dev,
 Tina Zhang <tina.zhang@intel.com>, Wei Wang <wei.w.wang@intel.com>
References: <7-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <7-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/17/25 03:57, Jason Gunthorpe wrote:
> VT-D requires PT_FEAT_DMA_INCOHERENT for the x86 page table as well,
> implement the required SW bits and enable the feature.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/generic_pt/fmt/iommu_x86_64.c |  2 +-
>   drivers/iommu/generic_pt/fmt/x86_64.h       | 27 +++++++++++++++++++++
>   2 files changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/generic_pt/fmt/iommu_x86_64.c b/drivers/iommu/generic_pt/fmt/iommu_x86_64.c
> index 5c5960d871a32f..5472660c2d7156 100644
> --- a/drivers/iommu/generic_pt/fmt/iommu_x86_64.c
> +++ b/drivers/iommu/generic_pt/fmt/iommu_x86_64.c
> @@ -6,6 +6,6 @@
>   #define PT_SUPPORTED_FEATURES                                  \
>   	(BIT(PT_FEAT_SIGN_EXTEND) | BIT(PT_FEAT_FLUSH_RANGE) | \
>   	 BIT(PT_FEAT_FLUSH_RANGE_NO_GAPS) |                    \
> -	 BIT(PT_FEAT_X86_64_AMD_ENCRYPT_TABLES))
> +	 BIT(PT_FEAT_X86_64_AMD_ENCRYPT_TABLES) | BIT(PT_FEAT_DMA_INCOHERENT))
>   
>   #include "iommu_template.h"
> diff --git a/drivers/iommu/generic_pt/fmt/x86_64.h b/drivers/iommu/generic_pt/fmt/x86_64.h
> index 60f8bd6b164b54..1b691f7cbf82d8 100644
> --- a/drivers/iommu/generic_pt/fmt/x86_64.h
> +++ b/drivers/iommu/generic_pt/fmt/x86_64.h
> @@ -160,6 +160,33 @@ static inline void x86_64_pt_attr_from_entry(const struct pt_state *pts,
>   }
>   #define pt_attr_from_entry x86_64_pt_attr_from_entry
>   
> +static inline unsigned int x86_64_pt_max_sw_bit(struct pt_common *common)
> +{
> +	return 12;
> +}
> +#define pt_max_sw_bit x86_64_pt_max_sw_bit
> +
> +static inline u64 x86_64_pt_sw_bit(unsigned int bitnr)
> +{
> +	/* Bits marked Ignored/AVL in the specification */
> +	switch (bitnr) {
> +	case 0:
> +		return BIT(9);
> +	case 1:
> +		return BIT(11);
> +	case 2 ... 12:
> +		return BIT_ULL((bitnr - 2) + 52);

Just out of curiosity, why bit 63 can't be used as the sw bit?

> +	/* Remaing bits 9-8,6,4,3  are only available in some entries */
> +	default:
> +		if (__builtin_constant_p(bitnr))
> +			BUILD_BUG();
> +		else
> +			PT_WARN_ON(true);
> +		return 0;
> +	}
> +}
> +#define pt_sw_bit x86_64_pt_sw_bit
> +
>   /* --- iommu */
>   #include <linux/generic_pt/iommu.h>
>   #include <linux/iommu.h>

Looks good to me.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

Thanks,
baolu
