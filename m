Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97793CF660
	for <patches@lists.linux.dev>; Mon,  7 Sep 2026 14:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788792189; cv=none; b=NXsoox8ytyt3k8TevHO5Eb2+f5lAzuhnKtmCCYpZ79wD8k9Gxj4M1ZlDllHNuzQ1K11twKncYdi2ohfcsAQ3oMIEnfG7YhQZnTQA6WjkT7iXgSk7ruAyj/TRM9r4YnUCWIkdWia5XDzDZImtgM0rNXYCcqsj3Te93k/ULwFCML4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788792189; c=relaxed/simple;
	bh=SHoh/7EhvVWvdeYRjIGfnUAamf+T8YvWghBUFk8d/aQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s2AKIFgg8qBi7NK8VvtM/tfCJ0OCI8+gVEU6Y3Pqw6dJkAQT/AiCaCQXdaQy0QNoPzNbVIm8HGndq/nZ2xgOm2VYCy+bGP9IuIbaU8mjX+09YU/7oStnKzVppo5qVwLhMRvICgZIiDFcZe8gtCUAYTr0l3FUHKaSfTTgAYuTyZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SEbQFa2E; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SEbQFa2E"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cda5e048fso76115e9.0
        for <patches@lists.linux.dev>; Mon, 07 Sep 2026 07:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788792182; x=1789396982; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nFlXstkW1CKpcWSPb1iVXZYzTogOJPn+U6nl1Js8m/A=;
        b=SEbQFa2Ecg6SbDLj1rlkXzJ1+NpSTo0wqZYLD69zYGx/3/+hkwOhRAUaXGOhZvkgqK
         bp5Hf7zUYx/7cHOkSSx/G0xXFtxEWHqABFtMN4peatEpmYODw6SkuLbl5VTROQ/hCBRt
         i8O+wB05wD6/X55hOlPfS3Wb8+FuWYpSlehs3Pnfq720z4rXNCYuYzQuot0Ku6YC5xLQ
         s3MetGfhsP2rWAapqzxDDnz9WxvSaIbf2yChVOPbe5M2wcxhBeJVREp2hHlW+zSn49Ob
         Lk3lMQ/zzpEQiEEHwOCeE3Vd6jmvN4m10G4euy7xfmsYF75wvPe1zD2F71iSJkENo/EC
         girg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788792182; x=1789396982;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nFlXstkW1CKpcWSPb1iVXZYzTogOJPn+U6nl1Js8m/A=;
        b=GDo+uEPq9Xc637MlMNjZp8SZMd6Qk8nWJiTkA0lrPzaWJ1/FNDAaIwrlgUwlg3jgUJ
         8O4i9fhu5MwY3CHBWGPcdtNS85EE7p6MKqHqWDvJRUV5nKHm14kYC/8peZG/cg74cwPF
         TtalU5+OPNsP7oujV+NqOF/EMvlvM1dzHyowEV8ZEyO4v7aND/t3HRa5dXxMTE9pQd/I
         eXhCKM/Ehn6CZdFQr/6hMn9mXKSLBlC/Fu4djopeO79pla2unL/utxpVSEqiKzibCZ+J
         e2MLkr9JGGvYJBvjW2d2dpnWQ2y4t8Hjl3iwc2pepBSZ9jCz5+h4NtUxQiHv7nhdozzM
         jsVg==
X-Forwarded-Encrypted: i=1; AKwUvBy+GtScS/KVKonIe2AHN91vKFx37sGASnPunzuHitOqqW6hMknzGANp8CSTTJpXkPVuXKM4W6Pc@lists.linux.dev
X-Gm-Message-State: AFuF++nTY86mwsPZCqtdsKwuZL67cdOtCezM4SQnVs6Tt8DE9BxCKh1U
	Tg06WBcPQs1gg6bUF1kULnJQdweYoS2neS26JvRqFOvhYtR9g+zSyZ1SNz3cZpW4nQ==
X-Gm-Gg: AYBFou1E1NZC/rQ4lOGoYtRHlZBAFfsBSOwGYRt0f0uUnyRIVcCQhvVel7DnOqki6yW
	nI+ts7e/4ZCssuJDpXEBwXuVpck1SyDGVyFd2pVoT6f07nHmyO9JFFZ4lG9qQESZPsClc72Q6P6
	wN2kx4/VgJbyl9TdZk2vXjECABajTW7GcdyEo284dPzAckMPke9asQ8UpB4tMyzuT0ZlABKO+RJ
	izbW0l70q4CkMBB5oXGQZNw+8yrW8bwZMFmd7+QVetWwaWL9D/Lj6or3TWSEWXCgFWoBxxtj0ak
	pP5/Tr6Iy+6czksDPnrYSIGBO3MYKu+lr46PIQZ7kDrzW4Y7cD6GTXj3rCoTYWxshWc+qPWjQDq
	YULKPQYcFoGe3FbdBsaKwHou8DYH0PrjqK5E2VAibfAanBi2Lq+SUxZWSxmYbHaEK68QbLlsYYL
	k5n98AJ4DNNtVFSXHaXLzQ4lQt21JpEtaF6wVPeshXnZDq/gRD7UoYpK5JzyvSZ25LZ3onlQOZE
	wdARJl1ww8MLZDg8mbnjvQRuyZ02Q==
X-Received: by 2002:a05:600d:8495:10b0:48a:623c:8859 with SMTP id 5b1f17b1804b1-49d01dd5cbbmr1505105e9.7.1788792181844;
        Mon, 07 Sep 2026 07:43:01 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee6024a8sm415716815e9.6.2026.09.07.07.43.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 07:43:00 -0700 (PDT)
Date: Mon, 7 Sep 2026 14:42:57 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>, David Matlack <dmatlack@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>, stable@vger.kernel.org,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: Re: [PATCH v5 8/9] iommu/arm-smmu-v3: Change how the tlbi describes
 the invalidation
Message-ID: <ap7NcebXzWC38VVo@google.com>
References: <0-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
 <8-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>

On Tue, Sep 01, 2026 at 02:49:57PM -0300, Jason Gunthorpe wrote:
> The RIL logic has long had a FIXME that there is not enough
> information to properly compute the RIL. There is also subtly not
> enough information to properly compute the single stride either.
> 
> Change tlbi to use the information format that iommupt is going to
> use for ARM. This prepares the invalidation code to support iommupt
> and fixes two small limitations with the current code.
> 
> iommupt is designed to accumulate all invalidation into a single
> gather, then the iommu driver should issue a small number of commands
> to execute the gather to control invalidation latency. This is in
> contrast to io-pgtable-arm.c which generates many gather flushes and
> direct walk cache flushes as it progresses.
> 
> To accommodate this the gather will accumulate "damage" in bitmaps,
> one for leaf changes and one for table changes. This is enough
> information for SMMUv3 to compute the proper stride for single
> invalidation and to generate ideal hints for range invalidation.

I am not sure I understand that, in what situation the leaf_bitmap
would be used instead of a single page size?
Would iommupt combine different page sizes in a single invalidation?

And then I see in this patch it has:
if (!is_power_of_2(leaf_bitmap))
	return 0;

Would that actually be better for performance than using 2 sets of
RILs, one for each page size?
As I'd imagine the HW will spend more effort on the TTL=0 case
otherwise it wouldn't require it.

> 
> Change the inner workings of the tlbi process to directly use this
> new-style gather description with the idea that the iommupt
> conversion will just direct assign the gather fields to the tlbi.
> 
> Rework the three places creating the tlbi to express their needs in
> terms of the new bitmaps.
> 
> 1) Simple iotlb invalidation always gets a single range of leaf
>    levels, so it can set a single leaf bit
> 
> 2) Walk invalidation is expected to clear the table and all the leaves it
>    could contain. Set a single table bit and all the leaf bits.
> 
>    There is a weakness in the existing io-pgtable where it double
>    invalidates the leaves, once through the arm_smmu_tlb_inv_walk() then
>    again through the gather. Since these are separate operations they are
>    not capped by the invalidation count limits and a single unmap may end
>    up doing thousands of tlbi commands. Eventually converting to iommupt's
>    gather only approach will correct this.
> 
> 3) SVA invalidation has no idea what the MM did, so it will set all
>    the bits in the bitmaps.
> 
>    This corrects another weakness where the RIL invalidation logic
>    was generating hints assuming the #2 rules which isn't correct
>    for SVA.
> 
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  29 ++-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 176 +++++++++++++-----
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  24 ++-
>  3 files changed, 177 insertions(+), 52 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index 47eba08bd1161f..07ba4e7910ab84 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -140,17 +140,34 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
>  {
>  	struct arm_smmu_domain *smmu_domain =
>  		container_of(mn, struct arm_smmu_domain, mmu_notifier);
> +	u8 tgsz_lg2 = smmu_domain->tgsz_lg2;
>  	struct arm_smmu_tlbi tlbi = {
>  		.tgsz_lg2 = smmu_domain->tgsz_lg2,
> -		.iova = start,
> +		.start = start,
> +		.last = end - 1,
>  		/*
> -		 * The mm_types defines vm_end as the first byte after the end
> -		 * address, different from IOMMU subsystem using the last
> -		 * address of an address range.
> +		 * No information comes from the mm, assume the worst case that
> +		 * it changed every table level. The way this is hooked into the
> +		 * mm is tricky, the range won't be expanded to include an
> +		 * entire table level if one was removed like the iommu gather
> +		 * does. Thus even if this is a 4k invalidation it may be
> +		 * including any table level too.
>  		 */
> -		.size = end - start,
> -		.iopte_size = PAGE_SIZE,
> +		.table_levels_bitmap = 0xfe,

What does that mean, won't arm have a max of 4 levels?

>  	};
> +	u8 pmd_lg2sz = (tgsz_lg2 - 3) * 1 + tgsz_lg2;
> +
> +	/*
> +	 * If the size is small then we can infer the invalidation is PTE only
> +	 * and set the PTE level only. Otherwise it could be some other
> +	 * combination so just set them all. This allows RIL to use TTL=3 in
> +	 * cases of PTE only changes. The mm must not try to partially
> +	 * invalidate pmd/etc.
> +	 */

How does that work with splitting blocks?  I imagine that might be
ossible with userspace.

> +	if (end - start < BIT_U64(pmd_lg2sz))
> +		tlbi.leaf_levels_bitmap = 1;
> +	else
> +		tlbi.leaf_levels_bitmap = 0xff;
>  
>  	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
>  }
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index b9efba3404c68b..b99229a5bbacca 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2397,8 +2397,8 @@ static struct arm_smmu_cmd arm_smmu_atc_inv_to_cmd(u32 sid, int ssid,
>  	 * This has the unpleasant side-effect of invalidating all PASID-tagged
>  	 * ATC entries within the address range.
>  	 */
> -	page_start = tlbi->iova >> inval_grain_shift;
> -	page_end = (tlbi->iova + tlbi->size - 1) >> inval_grain_shift;
> +	page_start = tlbi->start >> inval_grain_shift;
> +	page_end = tlbi->last >> inval_grain_shift;
>  
>  	/*
>  	 * In an ATS Invalidate Request, the address must be aligned on the
> @@ -2512,16 +2512,11 @@ static void arm_smmu_tlbi_add_range_cmd(struct arm_smmu_tlbi *tlbi,
>  {
>  	struct arm_smmu_cmd *cmd =
>  		&tlbi->range.cmds[tlbi->range.num_cmds++];
> -	unsigned int tgsz_lg2 = tg_enc * 2 + 10;
> -	u64 iova = ril->start_tg << tgsz_lg2;
> +	u64 iova = ril->start_tg << tlbi->tgsz_lg2;
>  	unsigned int num = ril->num - 1;
>  
> -	/* 16K granule TTL=1 is reserved (Section 4.4.1) */
> -	if (WARN_ON(tgsz_lg2 == 14 && ttl == 1))
> -		ttl = 0;
> -
>  	/* Verify address alignment for the TTL hint */
> -	if (ttl && !arm_smmu_ttl_addr_aligned(iova, tgsz_lg2, ttl))
> +	if (ttl && !arm_smmu_ttl_addr_aligned(iova, tlbi->tgsz_lg2, ttl))
>  		ttl = 0;
>  
>  	/*
> @@ -2529,9 +2524,8 @@ static void arm_smmu_tlbi_add_range_cmd(struct arm_smmu_tlbi *tlbi,
>  	 * and causes CERROR_ILL. Single tg uses NUM=0, SCALE=0 with a TTL hint
>  	 * to target only the exact leaf entry.
>  	 *
> -	 * For a single tg invalidation a 0 TTL can come from places like the
> -	 * SVA path that don't have enough information to get a TTL, or as a
> -	 * side of effect of the splitting.
> +	 * For a single tg invalidation a 0 TTL can come as a side of effect of
> +	 * the splitting.
>  	 *
>  	 * A single-TG invalidation cannot reach this point if it is part of a
>  	 * CONT group, so it is safe to transform it into a single invalidation.
> @@ -2542,14 +2536,83 @@ static void arm_smmu_tlbi_add_range_cmd(struct arm_smmu_tlbi *tlbi,
>  
>  	cmd->data[0] = FIELD_PREP(CMDQ_TLBI_0_NUM, num) |
>  		       FIELD_PREP(CMDQ_TLBI_0_SCALE, ril->scale);
> -	cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
> +	cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF,
> +				  !tlbi->table_levels_bitmap) |
>  		       FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
>  		       FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) | iova;
>  }
>  
> +static int arm_smmu_bitmap_to_level(u8 bitmap)
> +{
> +	return 3 - (int)__ffs(bitmap);
> +}
> +
>  /*
> - * Generate up to two range TLBI command payloads covering [iova, iova+size).
> - * Sets use_full_inv if the range is too large to represent.
> + * Compute the TTL hint from leaf/table level bitmaps. 0 ttl means no hint
> + * invalidate all levels.
> + */
> +static unsigned int arm_smmu_compute_ttl(u8 leaf_bitmap, u8 table_bitmap,
> +					 u8 tgsz_lg2)
> +{
> +	int ttl;
> +
> +	if (leaf_bitmap) {
> +		/* If TTL is used then only leaves at the TTL are invalidated */
> +		if (!is_power_of_2(leaf_bitmap))
> +			return 0;
> +
> +		ttl = arm_smmu_bitmap_to_level(leaf_bitmap);
> +		if (table_bitmap) {
> +			int table_ttl = arm_smmu_bitmap_to_level(table_bitmap) + 1;
> +
> +			/*
> +			 * A RIL invalidation with !leaf_only clears out all
> +			 * table levels above the leaf level ttl only.
> +			 */
> +			if (table_ttl > ttl)
> +				return 0;
> +		}
> +	} else if (table_bitmap) {
> +		/*
> +		 * Table-only invalidation. Spec says:
> +		 *  For operations with Leaf=0, invalidation of cached Table
> +		 *  descriptors for the address and scope additionally occurs at
> +		 *  levels between the start of the walk and the level before
> +		 *  the last level given by TTL.
> +		 * Choose a TTL hint that covers the only target table
> +		 * descriptor levels.
> +		 */
> +		ttl = arm_smmu_bitmap_to_level(table_bitmap) + 1;
> +
> +		/*
> +		 * 16K granule, ARM TTL=1 is reserved (SMMUv3 H.a Section
> +		 * 4.4.1.1) if DS=0, avoid it always for table invalidations
> +		 * since we don't know what instance this will be applied to
> +		 * yet.
> +		 */
> +		if (tgsz_lg2 == 14 && ttl == 1)
> +			return 0;
> +	} else {
> +		/* Both bitmaps zero is not allowed */
> +		WARN_ON(true);
> +		return 0;
> +	}
> +
> +	/*
> +	 * Assumes the page table is formed properly and does not trigger the
> +	 * 16k TTL=1 condition for leaf-only unless DS is enabled.
> +	 *
> +	 * ARM level -1 never has a leaf so something has gone wrong. ARM Level
> +	 * 0 cannot be hinted because ttl=0 means no-hint.
> +	 */
> +	if (WARN_ON(ttl < 0))
> +		return 0;
> +	return ttl;
> +}
> +
> +/*
> + * Generate up to two range TLBI command payloads covering [start, last]. Sets
> + * use_full_inv if the range is too large to represent.
>   *
>   * Normally the first RIL is the largest representable span which does not
>   * exceed the requested range. If necessary, the second RIL is the smallest
> @@ -2565,21 +2628,14 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
>  				     bool single_ril)
>  {
>  	u8 tgsz_lg2 = tlbi->tgsz_lg2;
> -	struct arm_smmu_ril_range first = { .start_tg = tlbi->iova >>
> +	unsigned int ttl = arm_smmu_compute_ttl(
> +		tlbi->leaf_levels_bitmap, tlbi->table_levels_bitmap, tgsz_lg2);
> +	struct arm_smmu_ril_range first = { .start_tg = tlbi->start >>
>  							tgsz_lg2 };
> -	u64 last_tg = (tlbi->iova + tlbi->size - 1) >> tgsz_lg2;
> +	u64 last_tg = tlbi->last >> tgsz_lg2;
>  	u64 num_tg = last_tg - first.start_tg + 1;
>  	u8 tg_enc = (tgsz_lg2 - 10) / 2;
>  	struct arm_smmu_ril_range trail;
> -	u8 ttl = 0;
> -
> -	/*
> -	 * Determine what level the granule is at. For non-leaf, both
> -	 * io-pgtable and SVA pass a nominal last-level granule because they
> -	 * don't know what level(s) actually apply, so leave TTL=0.
> -	 */
> -	if (tlbi->leaf_only)
> -		ttl = 4 - ((ilog2(tlbi->iopte_size) - 3) / (tgsz_lg2 - 3));
>  
>  	/*
>  	 * The spec defines the invalidated range as:
> @@ -2620,20 +2676,44 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
>  }
>  
>  /*
> - * One TLBI command per IOTLB entry, assuming the entries are all at least
> - * iopte_granule sized. Sets use_full_inv if too many commands would be needed
> - * which indicates too high a latency. The threshold is similar to MAX_DVM_OPS
> - * in arch/arm64/include/asm/tlbflush.h for the 4k PAGE_SIZE.
> + * Compute the stride for non-RIL single-page invalidation. Returns the log2
> + * stride of the lowest affected level. Single invalidation removes all IOPTEs
> + * that contain the IOVA invalidated, and we can reliably assume that the
> + * architected page size and table sizes (not contiguous!) are reflected in the
> + * IOTLB. Thus if there is a 2M leaf entry we only need to issue a single IOTLB
> + * invalidation within that 2M IOVA.
> + */
> +static u8 arm_smmu_tlbi_calc_stride(struct arm_smmu_tlbi *tlbi)
> +{
> +	u8 combined = tlbi->table_levels_bitmap | tlbi->leaf_levels_bitmap;
> +	u8 tg_szlg2 = tlbi->tgsz_lg2;
> +
> +	if (WARN_ON(!combined))
> +		return U8_MAX;

When can that happen?

> +	return (tg_szlg2 - 3) * __ffs(combined) + tg_szlg2;
> +}
> +
> +/*
> + * One TLBI command per stride-sized entry. Sets use_full_inv if too many
> + * commands would be needed. The threshold is similar to MAX_DVM_OPS in
> + * arch/arm64/include/asm/tlbflush.h.
>   */
>  static void arm_smmu_tlbi_calc_single(struct arm_smmu_tlbi *tlbi)
>  {
> -	unsigned long num_ops = tlbi->size / tlbi->iopte_size;
> +	u8 stride_lg2 = arm_smmu_tlbi_calc_stride(tlbi);
> +	unsigned long num_ops;
>  
> +	if (stride_lg2 == U8_MAX) {
> +		tlbi->single.use_full_inv = true;
> +		return;
> +	}
> +	num_ops = (tlbi->last - tlbi->start + 1) >> stride_lg2;
>  	if (!num_ops || num_ops > 512) {
>  		tlbi->single.use_full_inv = true;
>  		return;
>  	}
>  	tlbi->single.num = num_ops;
> +	tlbi->single.stride_lg2 = stride_lg2;
>  }
>  
>  static void arm_smmu_inv_all_cmd(struct arm_smmu_inv *inv,
> @@ -2653,7 +2733,7 @@ static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
>  				       struct arm_smmu_cmd *cmd,
>  				       struct arm_smmu_tlbi *tlbi)
>  {
> -	u64 iova = tlbi->iova;
> +	u64 iova = tlbi->start;
>  	unsigned int i;
>  
>  	if (inv->smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
> @@ -2678,9 +2758,10 @@ static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
>  	}
>  
>  	for (i = 0; i < tlbi->single.num; i++) {
> -		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
> +		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF,
> +					  !tlbi->table_levels_bitmap) |
>  			       (iova & ~GENMASK_U64(11, 0));
> -		iova += tlbi->iopte_size;
> +		iova += BIT_U64(tlbi->single.stride_lg2);
>  		arm_smmu_cmdq_batch_add_cmd_p(inv->smmu, cmds, cmd);
>  	}
>  	return false;
> @@ -2876,12 +2957,16 @@ static void arm_smmu_tlb_inv_walk(unsigned long iova, size_t size,
>  				  size_t granule, void *cookie)
>  {
>  	struct arm_smmu_domain *smmu_domain = cookie;
> +	u8 tgsz_lg2 = smmu_domain->tgsz_lg2;
>  	struct arm_smmu_tlbi tlbi = {
>  		.tgsz_lg2 = smmu_domain->tgsz_lg2,
> -		.iova = iova,
> -		.size = size,
> -		.iopte_size = 1 << smmu_domain->tgsz_lg2,
> +		.start = iova,
> +		.last = iova + size - 1,
>  	};
> +	u8 table_levels = BIT((ilog2(size) - tgsz_lg2) / (tgsz_lg2 - 3));
> +
> +	tlbi.table_levels_bitmap = table_levels;
> +	tlbi.leaf_levels_bitmap = table_levels - 1;
>  
>  	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
>  }
> @@ -4152,21 +4237,28 @@ static void arm_smmu_flush_iotlb_all(struct iommu_domain *domain)
>  		arm_smmu_tlb_inv_context(smmu_domain);
>  }
>  
> +/*
> + * Called by io-pgtable-arm.c for each run of same pgsize leaf only

I believe that it is called from dma-iommu.c, io-pgtable-arm.c will
call the tlb_add_page which builds the gather though.

> + * invalidation. If it has to change to a different leaf level then it flushes
> + * the gather and starts a fresh one. Thus this always targets only a single
> + * leaf level.
> + */
>  static void arm_smmu_iotlb_sync(struct iommu_domain *domain,
>  				struct iommu_iotlb_gather *gather)
>  {
>  	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
> +	unsigned int tg = smmu_domain->tgsz_lg2;
>  	struct arm_smmu_tlbi tlbi = {
>  		.tgsz_lg2 = smmu_domain->tgsz_lg2,
> -		.iova = gather->start,
> -		.size = gather->end - gather->start + 1,
> -		.iopte_size = gather->pgsize,
> -		.leaf_only = true,
> +		.start = gather->start,
> +		.last = gather->end,
>  	};
>  
> -	if (!gather->pgsize)
> +	if (WARN_ON(gather->pgsize < BIT(tg)))
>  		return;
>  
> +	tlbi.leaf_levels_bitmap = BIT((ilog2(gather->pgsize) - tg) / (tg - 3));

Having some page table macros would be helpful (and in other places in
this patch)

Thanks,
Mostafa

> +
>  	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
>  }
>  
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 09befe7b284fed..6582203eb7425f 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -809,17 +809,31 @@ static inline struct arm_smmu_invs *arm_smmu_invs_alloc(size_t num_invs)
>  }
>  
>  struct arm_smmu_tlbi {
> -	unsigned long iova;
> -	size_t size;
> -	/* page or block size of the leaf iopte */
> -	unsigned int iopte_size;
> +	unsigned long start;
> +	unsigned long last;
>  	/* Base Translation Granule of the page table */
>  	u8 tgsz_lg2;
>  	bool leaf_only;
> +	/*
> +	 * Level bitmaps use iommupt numbering: bit 0 is the leaf-only level
> +	 * (ARM level 3), bit 1 is the next level up (ARM level 2), etc. These
> +	 * match the iommu_iotlb_gather.pt fields. Each set bit indicates a
> +	 * change at that level. The contiguous hint has no effect on
> +	 * invalidation processing because HW can ignore the hint.
> +	 *
> +	 * The pair selects the invalidation scope:
> +	 *   table!=0, leaf==0 : walk cache only
> +	 *   table==0, leaf!=0 : leaves only
> +	 *   table!=0, leaf!=0 : walk cache + all leaves
> +	 *   table==0, leaf==0 : illegal
> +	 */
> +	u8 leaf_levels_bitmap;
> +	u8 table_levels_bitmap;
>  
>  	struct {
>  		bool use_full_inv;
>  		u16 num;
> +		u8 stride_lg2;
>  	} single;
>  
>  	struct {
> @@ -1188,6 +1202,8 @@ static inline void arm_smmu_domain_inv(struct arm_smmu_domain *smmu_domain)
>  {
>  	/* Prefilled for invalidate all */
>  	struct arm_smmu_tlbi tlbi = {
> +		.start = 0,
> +		.last = ULONG_MAX,
>  		.tgsz_lg2 = smmu_domain->tgsz_lg2,
>  		.single.use_full_inv = true,
>  		.range.use_full_inv = true,
> -- 
> 2.43.0
> 
