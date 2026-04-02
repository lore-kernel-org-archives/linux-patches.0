Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DE6A1A01BE;
	Thu,  2 Apr 2026 18:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775153485; cv=none; b=lc9Wum67FQfRPa2LNdCuRckQTbp9AQbr1gHUbGSiWsXkhmYtE0nBiKU4d4lscBPrwjK720CEKPMVZdgYQm6rX60PEeRJD3HsaNLJD4kN83T7SriOGnogNB7VVCwbBlM8DCZAqO7pUK2jBXoHP8aJotAlCHSgq6Z85CkFrb4KnfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775153485; c=relaxed/simple;
	bh=lWwySeUuucnSqrRMaEssqv+qa77TPxUWW5jml+8ovZo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aOYzszcQfBEDSDOnHAAG+nBE4NvmXa/78h3MRcuSOnB/cCbvDlFYBSjch4mI64hJP/TictWXBI56ZIvSQb/oljWTKHpodYDEooVlJSPJCaz5AB6HpbEKnkpGcepXPuAlQJykBaF2i2bz6oO6+QyXcOI8eGnmtYSDUfFjuvb9xh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nI+zbstn; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nI+zbstn"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 978AE1570;
	Thu,  2 Apr 2026 11:11:16 -0700 (PDT)
Received: from [10.57.75.194] (unknown [10.57.75.194])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0787B3F915;
	Thu,  2 Apr 2026 11:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775153482; bh=lWwySeUuucnSqrRMaEssqv+qa77TPxUWW5jml+8ovZo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nI+zbstndSHKJ/mynYHRuC64m8Z4xHAi45TXEjGH5rMJxTMtKiuXxjyjbxLarmMYn
	 hXXkhX8l35nrPiZyzp+ZgYDe4uw+iI8Bv/L+f2xWNIa+OiQyxnU8y+avrnVGEPKVGX
	 +wUG0AxZTOalhJkOHOlwae27JD/n0ccdlbnChrhg=
Message-ID: <ec51ef14-e360-43a6-ae62-44a939ec8027@arm.com>
Date: Thu, 2 Apr 2026 19:11:13 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iommu: Always fill in gather when unmapping
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Albert Ou <aou@eecs.berkeley.edu>, asahi@lists.linux.dev,
 Baolin Wang <baolin.wang@linux.alibaba.com>, iommu@lists.linux.dev,
 Janne Grunau <j@jannau.net>, Jernej Skrabec <jernej.skrabec@gmail.com>,
 Joerg Roedel <joro@8bytes.org>, Jean-Philippe Brucker <jpb@kernel.org>,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-sunxi@lists.linux.dev,
 Matthias Brugger <matthias.bgg@gmail.com>, Neal Gompa <neal@gompa.dev>,
 Orson Zhai <orsonzhai@gmail.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <pjw@kernel.org>, Samuel Holland <samuel@sholland.org>,
 Sven Peter <sven@kernel.org>, virtualization@lists.linux.dev,
 Chen-Yu Tsai <wens@kernel.org>, Will Deacon <will@kernel.org>,
 Yong Wu <yong.wu@mediatek.com>, Chunyan Zhang <zhang.lyra@gmail.com>,
 Lu Baolu <baolu.lu@linux.intel.com>,
 Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>,
 Joerg Roedel <joerg.roedel@amd.com>, Jon Hunter <jonathanh@nvidia.com>,
 patches@lists.linux.dev, Samiullah Khawaja <skhawaja@google.com>,
 stable@vger.kernel.org, Vasant Hegde <vasant.hegde@amd.com>
References: <0-v1-664d3acaabb9+78b-iommu_gather_always_jgg@nvidia.com>
 <ee2c2044-e329-4cdd-ac35-9365824d3677@arm.com>
 <20260401173650.GD310919@nvidia.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <20260401173650.GD310919@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026-04-01 6:36 pm, Jason Gunthorpe wrote:
> On Wed, Apr 01, 2026 at 05:33:28PM +0100, Robin Murphy wrote:
>>> io-pgtable might have intended to allow the driver to choose between
>>> gather or immediate flush because it passed gather to
>>> ops->tlb_add_page(), however no driver does anything with it.
>>
>> Apart from arm-smmu-v3...
> 
> Bah, I did my research on the wrong tree and missed this.
> 
>>> mtk uses io-pgtable-arm-v7s but added the range to the gather in the
>>> unmap callback. Move this into the io-pgtable-arm unmap itself. That
>>> will fix all the armv7 using drivers (arm-smmu, qcom_iommu,
>>> ipmmu-vmsa).
>>
>> io-pgtable-arm-v7s != io-pgtable-arm. You're *breaking* MTK (and failing
>> to fix the other v7s user, which is MSM).
> 
> I was very confused what you were talking about, but I see now that
> the hunk adding iommu_iotlb_gather_add_range() to v7 got lost somehow!
> 
> @@ -596,6 +596,9 @@ static size_t __arm_v7s_unmap(struct arm_v7s_io_pgtable *data,
>   
>                  __arm_v7s_set_pte(ptep, 0, num_entries, &iop->cfg);
>   
> +               if (!iommu_iotlb_gather_queued(gather))
> +                       iommu_iotlb_gather_add_range(gather, iova, size);
> +
>                  for (i = 0; i < num_entries; i++) {
>                          if (ARM_V7S_PTE_IS_TABLE(pte[i], lvl)) {
>                                  /* Also flush any partial walks */
> 
>>> arm-smmu uses both ARM_V7S and ARM LPAE formats. The LPAE formats
>>> already have the gather population because SMMUv3 requires it, so it
>>> becomes consistent.
>>
>> Huh? arm-smmu-v3 invokes iommu_iotlb_gather_add_page() itself, because
>> arm-smmu-v3 uses gathers
> 
> Yeah, I missed this whole bit, it needs some changes.
> 
>> Invoking add range before add_page will end up defeating the
>> iommu_iotlb_gather_is_disjoint() check and making SMMUv3
>> overinvalidate between disjoint ranges.
> 
> Right, that flow needs fixing.
> 
>> I guess now I remember why we weren't validating gathers in core code
>> before :(
> 
> My point is not filling the gather is a micro-optimization that
> benefits a few drivers. I think it is so small compared to an IOTLB
> flush that it isn't worth worrying about.

It's hardly a "micro-optimisation" for drivers to just not touch an 
optional mechanism which offers no benefit to them, especially when in 
many cases said mechanism is newer than the code that isn't using it 
anyway. The only required semantic of .iotlb_sync is to ensure that any 
previous .unmap_pages calls are complete and their associated 
translations invalidated. The entire concept of gathering and deferred 
invalidation is irrelevant to many IOMMU designs where it would only 
stand to make overall invalidation performance worse.

I'm starting to wish I'd been able to page all this context back in 
before reviewing the first patch, as I too only really had Intel and 
SMMUv3 in mind at the time... :(

> So, I'd like to make everything the same and populate the gather
> correctly in all flows. I'll fix the SMMUv3 thing and lets look again,
> this patch is not so scary to make me think we shouldn't do that.
> 
>> @@ -2714,6 +2714,10 @@ static size_t __iommu_unmap(struct iommu_domain *domain,
>>   		pr_debug("unmapped: iova 0x%lx size 0x%zx\n",
>>   			 iova, unmapped_page);
>> +		/* If the driver itself isn't using the gather, mark it used */
>> +		if (iotlb_gather->end <= iotlb_gather->start)
>> +			iommu_iotlb_gather_add_range(&iotlb_gather, iova, unmapped_page);
> 
> The gathers can be joined across unmaps and now we are inviting subtly
> ill-formed gathers as only the first unmap will get included.

Ill-formed? It's a perfectly valid range for the purposes of any 
subsequent generic check - which couldn't realistically be anything 
beyond empty vs. non-empty anyway - and it's only being set at all in 
the case where we know the driver doesn't care, because if the driver 
*was* going to look at gather->start or gather->end in its .iotlb_sync 
then it must have already set them to meaningful values in the prior 
successful .unmap_pages call. I think we can safely consider it invalid 
for a driver to suddenly decide to start using a gather mid-way through 
an unmap (or indeed to use start/end in any intentionally non-obvious 
manner either).

> We do have error cases where the gather is legitimately empty, and
> this would squash that, it probably needs to check unmapped_page for 0
> too, at least.

Maybe try looking at the rest of the code around these lines...

Thanks,
Robin.
