Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CDEC280318;
	Thu,  2 Apr 2026 15:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775145580; cv=none; b=RLv28Sz2pFVDzK0v1xd2kLdo+Bg30H+SBV+d3HU+naLGBF9pnhHKuZIGVsulhSpPYUj/OreLU3SxxBcsYT8Oe3V6KaE2jdb0c7SUtL9co9sBlOBMJwlv0W1b2H/i6sfeai33vnfmWZ6Ls5i9vzzu7srC2C9AkRE3cyoqHNN/X3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775145580; c=relaxed/simple;
	bh=i132jaYTi+ixjxc06WKFSsZBQkYSpy9Al36njUn136A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ECPiMfCdFzEuueACVu6j/dNmEdKXnvw8/wxmGgyiql59Kvp65uwwkaM/VXoOJ3mtO2y4FKDyS77s+IGIKNFlySmRzOxf1PVEpw2xOEw7edw8RUkjFRI1thdwGlLEdiuWCtrTXGN0f/AF1ow3UGjMrE43a7xRX962/tdCTpcb5P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=X1fFpyjZ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="X1fFpyjZ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AF68119F6;
	Thu,  2 Apr 2026 08:59:31 -0700 (PDT)
Received: from [10.57.75.194] (unknown [10.57.75.194])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CE0733F7D8;
	Thu,  2 Apr 2026 08:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775145577; bh=i132jaYTi+ixjxc06WKFSsZBQkYSpy9Al36njUn136A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=X1fFpyjZioXy4emzPkjym3elHmat0r+NzfnNyuFOL1OkZZkHFO799zWiDOc+QsG89
	 RvckoTATbUkXYGvBcdbyyGatOV5TQ8U7m5+c3/BHSMv29HSpGqfCfDH9T1FFCyGT6l
	 ixQ85owst4jhClEz/N9TGMke5/DtJjAEVGacLBjw=
Message-ID: <70a128f9-d6f0-41b6-8fef-e249c0507149@arm.com>
Date: Thu, 2 Apr 2026 16:59:29 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] iommu: Always fill in gather when unmapping
To: Jason Gunthorpe <jgg@nvidia.com>, Alexandre Ghiti <alex@ghiti.fr>,
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
 Yong Wu <yong.wu@mediatek.com>, Chunyan Zhang <zhang.lyra@gmail.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
 Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>,
 Joerg Roedel <joerg.roedel@amd.com>, Jon Hunter <jonathanh@nvidia.com>,
 patches@lists.linux.dev, Pranjal Shrivastava <praan@google.com>,
 Samiullah Khawaja <skhawaja@google.com>, stable@vger.kernel.org,
 Vasant Hegde <vasant.hegde@amd.com>
References: <0-v2-b24668f107b2+11bbe-iommu_gather_always_jgg@nvidia.com>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <0-v2-b24668f107b2+11bbe-iommu_gather_always_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026-04-02 3:25 pm, Jason Gunthorpe wrote:
> The fixed commit assumed that the gather would always be populated if an
> iotlb_sync was required.
> 
> arm-smmu-v3, amd, VT-d, riscv, s390, and mtk all use information from the
> gather during their iotlb_sync() and this approach works for them.
> 
> However, arm-smmu, qcom_iommu, ipmmu-vmsa, sun50i, sprd, virtio, and
> apple-dart all ignore the gather during their iotlb_sync(). They mostly
> issue a full flush.
> 
> Unfortunately the latter set of drivers often don't bother to add anything
> to the gather since they don't intend on using it. Since the core code now
> blocks gathers that were never filled, this caused those drivers to stop
> getting their iotlb_sync() calls and breaks them.
> 
> Since it is impossible to tell the difference between gathers that are
> empty because there is nothing to do and gathers that are empty because
> they are not used, fill in the gathers for the missing cases.
> 
> mtk uses io-pgtable-arm-v7s but added the range to the gather in the unmap
> callback. Move this into the io-pgtable-arm-v7s unmap itself. That will
> fix all the armv7 using drivers (arm-smmu, qcom_iommu, ipmmu-vmsa).
> 
> io-pgtable-arm needs to accommodate drivers like arm-smmu that don't want
> to use the gather by just adding a simple range, and drivers like SMMUv3
> that need to use gather->pgsize and also have a disjoint check. Move
> SMMUv3 to a new tlb_add_range() op which replaces calling
> iommu_iotlb_gather_add_page() in a loop with a single call to update the
> gather with the range and required pgsize.
> 
> iommu_iotlb_gather_add_page() is repurposed since nothing but SMMUv3 uses it
> now that amd, VT-d and riscv are using iommupt.
> 
> Add a trivial gather population to io-pgtable-dart.
> 
> Add trivial populations to sprd, sun50i and virtio-iommu in their unmap
> functions.
> 
> Fixes: 90c5def10bea ("iommu: Do not call drivers for empty gathers")
> Reported-by: Jon Hunter <jonathanh@nvidia.com>
> Closes: https://lore.kernel.org/r/8800a38b-8515-4bbe-af15-0dae81274bf7@nvidia.com
> Tested-by: Jon Hunter <jonathanh@nvidia.com>
> Acked-by: Pranjal Shrivastava <praan@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 11 ++++++-----
>   drivers/iommu/io-pgtable-arm-v7s.c          |  4 ++++
>   drivers/iommu/io-pgtable-arm.c              | 19 ++++++++++++++++---
>   drivers/iommu/io-pgtable-dart.c             |  3 +++
>   drivers/iommu/mtk_iommu.c                   |  1 -
>   drivers/iommu/sprd-iommu.c                  |  1 +
>   drivers/iommu/sun50i-iommu.c                |  1 +
>   drivers/iommu/virtio-iommu.c                |  2 ++
>   include/linux/io-pgtable.h                  |  3 +++
>   include/linux/iommu.h                       | 19 ++++++++++---------
>   10 files changed, 46 insertions(+), 18 deletions(-)
> 
> v2:
>   - Add missed hunk for io-pgtable-armv7
>   - Revise the commit message to fix the miss about smmuv3's gather flow
>   - Make smmuv3 push its gather with a range instead of per-page
> v1: https://patch.msgid.link/r/0-v1-664d3acaabb9+78b-iommu_gather_always_jgg@nvidia.com
> 
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index e8d7dbe495f030..97e78a351cf35b 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2775,14 +2775,15 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
>   	rcu_read_unlock();
>   }
>   
> -static void arm_smmu_tlb_inv_page_nosync(struct iommu_iotlb_gather *gather,
> -					 unsigned long iova, size_t granule,
> -					 void *cookie)
> +static void arm_smmu_tlb_inv_range_nosync(struct iommu_iotlb_gather *gather,
> +					  unsigned long iova, size_t size,
> +					  size_t granule, void *cookie)
>   {
>   	struct arm_smmu_domain *smmu_domain = cookie;
>   	struct iommu_domain *domain = &smmu_domain->domain;
>   
> -	iommu_iotlb_gather_add_page(domain, gather, iova, granule);
> +	iommu_iotlb_gather_add_range_pgsize(domain, gather, iova, size,
> +					    granule);
>   }
>   
>   static void arm_smmu_tlb_inv_walk(unsigned long iova, size_t size,
> @@ -2796,7 +2797,7 @@ static void arm_smmu_tlb_inv_walk(unsigned long iova, size_t size,
>   static const struct iommu_flush_ops arm_smmu_flush_ops = {
>   	.tlb_flush_all	= arm_smmu_tlb_inv_context,
>   	.tlb_flush_walk = arm_smmu_tlb_inv_walk,
> -	.tlb_add_page	= arm_smmu_tlb_inv_page_nosync,
> +	.tlb_add_range	= arm_smmu_tlb_inv_range_nosync,
>   };
>   
>   static bool arm_smmu_dbm_capable(struct arm_smmu_device *smmu)
> diff --git a/drivers/iommu/io-pgtable-arm-v7s.c b/drivers/iommu/io-pgtable-arm-v7s.c
> index 40e33257d3c2c5..87292a7f094687 100644
> --- a/drivers/iommu/io-pgtable-arm-v7s.c
> +++ b/drivers/iommu/io-pgtable-arm-v7s.c
> @@ -596,6 +596,10 @@ static size_t __arm_v7s_unmap(struct arm_v7s_io_pgtable *data,
>   
>   		__arm_v7s_set_pte(ptep, 0, num_entries, &iop->cfg);
>   
> +		if (!iommu_iotlb_gather_queued(gather))
> +			iommu_iotlb_gather_add_range(gather, iova,
> +						     num_entries * blk_size);
> +
>   		for (i = 0; i < num_entries; i++) {
>   			if (ARM_V7S_PTE_IS_TABLE(pte[i], lvl)) {
>   				/* Also flush any partial walks */
> diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
> index 0208e5897c299a..d51531330f8dea 100644
> --- a/drivers/iommu/io-pgtable-arm.c
> +++ b/drivers/iommu/io-pgtable-arm.c
> @@ -666,9 +666,22 @@ static size_t __arm_lpae_unmap(struct arm_lpae_io_pgtable *data,
>   		/* Clear the remaining entries */
>   		__arm_lpae_clear_pte(ptep, &iop->cfg, i);
>   
> -		if (gather && !iommu_iotlb_gather_queued(gather))
> -			for (int j = 0; j < i; j++)
> -				io_pgtable_tlb_add_page(iop, gather, iova + j * size, size);
> +		if (gather && !iommu_iotlb_gather_queued(gather)) {
> +			if (iop->cfg.tlb && iop->cfg.tlb->tlb_add_range) {
> +				iop->cfg.tlb->tlb_add_range(gather, iova,
> +							    i * size, size,
> +							    iop->cookie);
> +
> +			} else {
> +				iommu_iotlb_gather_add_range(gather, iova,
> +							     i * size);
> +
> +				for (int j = 0; j < i; j++)
> +					io_pgtable_tlb_add_page(iop, gather,
> +								iova + j * size,
> +								size);
> +			}
> +		}

NAK, this is insane.

If you'd rather make gathers mandatory for all drivers than fix it in 
the core code, then for goodness' sake just add the trivial one-liner to 
the handful of .unamp_pages implementations which need it, consistenly 
with those which already exist, plus the ones you're also adding here 
anyway. The entire diff should still be smaller than this absurd hunk 
alone...

Thanks,
Robin.

>   		return i * size;
>   	} else if (iopte_leaf(pte, lvl, iop->fmt)) {
> diff --git a/drivers/iommu/io-pgtable-dart.c b/drivers/iommu/io-pgtable-dart.c
> index cbc5d6aa2daa23..75d699dc28e7b0 100644
> --- a/drivers/iommu/io-pgtable-dart.c
> +++ b/drivers/iommu/io-pgtable-dart.c
> @@ -330,6 +330,9 @@ static size_t dart_unmap_pages(struct io_pgtable_ops *ops, unsigned long iova,
>   		i++;
>   	}
>   
> +	if (i && !iommu_iotlb_gather_queued(gather))
> +		iommu_iotlb_gather_add_range(gather, iova, i * pgsize);
> +
>   	return i * pgsize;
>   }
>   
> diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
> index 2be990c108de2b..a2f80a92f51f2c 100644
> --- a/drivers/iommu/mtk_iommu.c
> +++ b/drivers/iommu/mtk_iommu.c
> @@ -828,7 +828,6 @@ static size_t mtk_iommu_unmap(struct iommu_domain *domain,
>   {
>   	struct mtk_iommu_domain *dom = to_mtk_domain(domain);
>   
> -	iommu_iotlb_gather_add_range(gather, iova, pgsize * pgcount);
>   	return dom->iop->unmap_pages(dom->iop, iova, pgsize, pgcount, gather);
>   }
>   
> diff --git a/drivers/iommu/sprd-iommu.c b/drivers/iommu/sprd-iommu.c
> index c1a34445d244fb..893ea67d322644 100644
> --- a/drivers/iommu/sprd-iommu.c
> +++ b/drivers/iommu/sprd-iommu.c
> @@ -340,6 +340,7 @@ static size_t sprd_iommu_unmap(struct iommu_domain *domain, unsigned long iova,
>   	spin_lock_irqsave(&dom->pgtlock, flags);
>   	memset(pgt_base_iova, 0, pgcount * sizeof(u32));
>   	spin_unlock_irqrestore(&dom->pgtlock, flags);
> +	iommu_iotlb_gather_add_range(iotlb_gather, iova, size);
>   
>   	return size;
>   }
> diff --git a/drivers/iommu/sun50i-iommu.c b/drivers/iommu/sun50i-iommu.c
> index be3f1ce696ba29..b9aa4bbc82acad 100644
> --- a/drivers/iommu/sun50i-iommu.c
> +++ b/drivers/iommu/sun50i-iommu.c
> @@ -655,6 +655,7 @@ static size_t sun50i_iommu_unmap(struct iommu_domain *domain, unsigned long iova
>   
>   	memset(pte_addr, 0, sizeof(*pte_addr));
>   	sun50i_table_flush(sun50i_domain, pte_addr, 1);
> +	iommu_iotlb_gather_add_range(gather, iova, SZ_4K);
>   
>   	return SZ_4K;
>   }
> diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
> index 587fc13197f122..5865b8f6c6e67a 100644
> --- a/drivers/iommu/virtio-iommu.c
> +++ b/drivers/iommu/virtio-iommu.c
> @@ -897,6 +897,8 @@ static size_t viommu_unmap_pages(struct iommu_domain *domain, unsigned long iova
>   	if (unmapped < size)
>   		return 0;
>   
> +	iommu_iotlb_gather_add_range(gather, iova, unmapped);
> +
>   	/* Device already removed all mappings after detach. */
>   	if (!vdomain->nr_endpoints)
>   		return unmapped;
> diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
> index e19872e37e067f..b109c95b5ff53d 100644
> --- a/include/linux/io-pgtable.h
> +++ b/include/linux/io-pgtable.h
> @@ -42,6 +42,9 @@ struct iommu_flush_ops {
>   			       void *cookie);
>   	void (*tlb_add_page)(struct iommu_iotlb_gather *gather,
>   			     unsigned long iova, size_t granule, void *cookie);
> +	void (*tlb_add_range)(struct iommu_iotlb_gather *gather,
> +			      unsigned long iova, size_t size, size_t granule,
> +			      void *cookie);
>   };
>   
>   /**
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index e587d4ac4d3310..d8fcdb61e44c42 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -1034,30 +1034,31 @@ static inline void iommu_iotlb_gather_add_range(struct iommu_iotlb_gather *gathe
>   }
>   
>   /**
> - * iommu_iotlb_gather_add_page - Gather for page-based TLB invalidation
> + * iommu_iotlb_gather_add_range_pgsize - Include pgsize in the gather
>    * @domain: IOMMU domain to be invalidated
>    * @gather: TLB gather data
>    * @iova: start of page to invalidate
>    * @size: size of page to invalidate
> + * @pgsize: page granularity of the invalidation
>    *
> - * Helper for IOMMU drivers to build invalidation commands based on individual
> - * pages, or with page size/table level hints which cannot be gathered if they
> - * differ.
> + * Helper for IOMMU drivers to build invalidation commands when using the pgsize
> + * hint. Unlike iommu_iotlb_gather_add_range() this also flushes if the range is
> + * disjoint.
>    */
> -static inline void iommu_iotlb_gather_add_page(struct iommu_domain *domain,
> -					       struct iommu_iotlb_gather *gather,
> -					       unsigned long iova, size_t size)
> +static inline void iommu_iotlb_gather_add_range_pgsize(
> +	struct iommu_domain *domain, struct iommu_iotlb_gather *gather,
> +	unsigned long iova, size_t size, size_t pgsize)
>   {
>   	/*
>   	 * If the new page is disjoint from the current range or is mapped at
>   	 * a different granularity, then sync the TLB so that the gather
>   	 * structure can be rewritten.
>   	 */
> -	if ((gather->pgsize && gather->pgsize != size) ||
> +	if ((gather->pgsize && gather->pgsize != pgsize) ||
>   	    iommu_iotlb_gather_is_disjoint(gather, iova, size))
>   		iommu_iotlb_sync(domain, gather);
>   
> -	gather->pgsize = size;
> +	gather->pgsize = pgsize;
>   	iommu_iotlb_gather_add_range(gather, iova, size);
>   }
>   
> 
> base-commit: 23f3682fd3605da81b90738ad3d2a30f18c46e98

