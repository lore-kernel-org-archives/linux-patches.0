Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3948C3859EC
	for <patches@lists.linux.dev>; Mon,  7 Sep 2026 14:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788790914; cv=none; b=R0D9ojEr8yXbmKB+HpB/DHyZftRNTiMjD9zn6XqcR6rispCnBkyfc8uva0GcqoJ7V1FGyoDC0IuNH8rfr0MiLb7laZClVwRPVeiHN3BKFPLO1NFABORU6vajO0a1S7O+midVxAIs1cn9kUTbDPf5Owt8xCcqt6vstpSbxNh+dGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788790914; c=relaxed/simple;
	bh=7Regah+qf9wEx4AtaNocLUxqNjPHScB3MmjBW5AC9Ec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q19r1Bt2Hg2kjQYjvNcv147Ujx7VqK2siOorcEkAxftdXSjeRDW3dIQGieEzhmV+ey11eDMJmsT8i0eow9nTeMoF7d1kHHuIoE083mBwOBMf0pwXFsR+eLcEp7KeVBu8754ojmfokP2GLm8X0bYQVzNMsEXvQI9wew5F6v6yxmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ndhKfbxV; arc=none smtp.client-ip=74.125.228.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ndhKfbxV"
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a5d8fd8d88so15165a12.0
        for <patches@lists.linux.dev>; Mon, 07 Sep 2026 07:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788790910; x=1789395710; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VX/qjX8bBihd5ue2J42v1DAvcCr2XZH6u/7IYMXwpfs=;
        b=ndhKfbxVqDY4x40HlUU7VGRC6HqWCQd42GUEmF/9Pf1kzTCTjMWoUz8xVess08i3hv
         brzD7PCV/UkMTogQImzjw8vHJCJ9W1xjKXd/HdJtHFyHBUTQf2IU4V4Dwx6ixaeyF2ru
         TL/02WWfZEiR2YhTb0x0NaK8A4CtkAoUEo6cipN/PFLROGKTjUasQFyG0p9yonyWDMiX
         55Kxs3Pd7d+7ADszsi4latQih03Q8hO0/TQjIdmfA5F0pe4yoBYzVmuuAeZda6kCoc3N
         eGhChV5/GjfqI6LKrK90CFcnQqXKM7OfOxph2p4THWypTHcO3XxTRgZ8jv6kMs+e7ejb
         5a2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788790910; x=1789395710;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VX/qjX8bBihd5ue2J42v1DAvcCr2XZH6u/7IYMXwpfs=;
        b=gCIFMZhrAY6Ww1ShvwI0x/6jYCwtphpPNeJix8l/YrxHjaJczLdhFKU8vXqi4a5ZDa
         GRLUKxycpK0lBp51XdD/fwFIAribdy8TxunsWL73royH6VE7gogOtA+NmLZ3ZbBWnAHR
         UOuUHWKOCOHdjPZrVNue5Yg+Yq5aXq6BDxb04QgB7vCq33fRSIbDZ21/xYkzfiZgnUtQ
         GNDAFbbDjhEhje0V6KxCDPRapQMvdBmzpguz6CXyPv09+LgbekjQ2t2Ii1FaH6t1IK0E
         nSIt/jfARvqLDpDgoMcWafMTw9eWQ5ceibkzrO7qQ5dngiu+rBHbeigkfUwXNOVugrai
         1a6A==
X-Forwarded-Encrypted: i=1; AKwUvBzGOtIGQXhdNbTNDh7vx3gt3EsVPs9wvI5rql9rnoP+j0/MoyK3El7wi2Kc7Cv9muzsgZ3XA3G6@lists.linux.dev
X-Gm-Message-State: AFuF++k9iPPzPF8Tyt0f9HEDbtPr4iHBH+amLYLKjrAofZnT1ZjK0Wbh
	Py5VPyhWtKw7DCJMD2k8HcLVW3iPwTht3tPsvl2+cJ2HLGrE3mB12R2v/WP1kIl3jQ==
X-Gm-Gg: AYBFou319TUL42YVH6nPEsLOS3+XMNlpQ3I/yCc4YtdmqXIbOQO0R1+MrdqanTSoSEP
	93cL5YXeTDxDF0VJHCbqqtC5Rk5pJfIXgG8+2ecn44a9f4cfUxizvg4EVJhnIdFaGMoy3Su9bGQ
	Kjgn34pPhw0TnDmDyy4qhfSHqq8KCokHwuDZ0KtDQiXSmK9TuDOe3qeeeyjzWf3o7+CeduSe6Ka
	GtCjJBwQJHvX1SGRfLZYG0JUKVJpgHIFwZy57buA8uLplklfKPuENSo0kzf7X2nRJ8tgrEUmtjk
	dKvZWT7kBxqUf+NUg1Xa6KiWoG++jiicFAR9+YP+SPm9GRCaBRBfk7JerPdTMyGyqN7+OiHWcEU
	x32j6u9Dl4khUpinxljTiO1E2rtNgmNQSFytAgNgJvBzQo1NYIV87zlKnJEzXiRRKUbRpKlE2TW
	m+48E70TgsdOQ7m//dZQR0Kj9ep+5laYSVtT7DmaMcfDq+I89N6D9fa5tVOGSYLeOf8r18upR5h
	b+wrCAj6MOEOxSNCGyDykCr+Njwmg==
X-Received: by 2002:a05:6402:4602:20b0:6a6:f2a5:1b4f with SMTP id 4fb4d7f45d1cf-6a7f67ae513mr51553a12.4.1788790909668;
        Mon, 07 Sep 2026 07:21:49 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d4a98efsm490693566b.14.2026.09.07.07.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 07:21:48 -0700 (PDT)
Date: Mon, 7 Sep 2026 14:21:44 +0000
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
Subject: Re: [PATCH v5 1/9] iommu/arm-smmu-v3: Handle ARM erratum for CONT
 under invalidation with SVA
Message-ID: <ap7IeAfVPZL3Hqt_@google.com>
References: <0-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
 <1-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>

On Tue, Sep 01, 2026 at 02:49:50PM -0300, Jason Gunthorpe wrote:
> The erratum (MMU-700: #3777127, S3: #3673557) deals with under
> invalidation of a CONT PTE grouping in the SMMU. The recommended work
> around is to use a Range Invalidate (RIL) that spans the entire CONT. The
> only user of CONT in the kernel right now is through SVA sharing a CPU
> page table that contains a CONT created by the mm.
> 
> Previously it was thought that this errata was dealt with because the
> driver always uses RIL. However, there is a subtle detail in the errata
> that the RIL range must fully enclose the entire CONT for it to work.
> 
> It seems that two sequential RILs, with a split point falling inside a
> CONT grouping, will not prevent the errata.
> 
> The SMMU's RIL generation algorithm does not produce a single RIL for a
> single SVA invalidation request, nor does the mm carefully align the SVA
> invalidation ranges to accommodate the RIL splitting.
> 
> Thus, when processing a SVA invalidation, the RIL splitting routine can
> generate a RIL that is split in the middle of the CONT and risk under
> invalidation from this errata. This condition could be triggered by a
> malicious userspace manipulating the TLB gathers via mmap/mprotect/munmap.
> 
> Update the errata list to the include the S3 variation, detect the IOMMUs
> that have it, and then have SVA invalidations use a simplified version of
> the over invalidation algorithm from the tlbi rework series. This ensures
> that a single RIL is issued for a single MMU notifier callback and now the
> RIL is guarenteed to cover any posible CONT.
> 
> Future work to add CONT to iommu_domain page tables should either use this
> one-invalidate/one-RIL algorithm or disable CONT support in the
> iommu_domain.
> 
> Cc: stable@vger.kernel.org
> Fixes: 3f1ce8e85ee0 ("iommu/arm-smmu-v3: Share process page tables")
> Cc: Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  Documentation/arch/arm64/silicon-errata.rst   |  3 +-
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  7 ++
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 87 +++++++++++++++----
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  2 +
>  4 files changed, 81 insertions(+), 18 deletions(-)
> 
> diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
> index ac3248b9f2f3bb..68018bf75b7910 100644
> --- a/Documentation/arch/arm64/silicon-errata.rst
> +++ b/Documentation/arch/arm64/silicon-errata.rst
> @@ -271,7 +271,8 @@ stable kernels.
>  +----------------+-----------------+-----------------+-----------------------------+
>  | ARM            | MMU L1          | #3878312        | N/A                         |
>  +----------------+-----------------+-----------------+-----------------------------+
> -| ARM            | MMU S3          | #3995052        | N/A                         |
> +| ARM            | MMU S3          | #3995052,       | N/A                         |
> +|                |                 | #3673557        |                             |
>  +----------------+-----------------+-----------------+-----------------------------+
>  | ARM            | GIC-700         | #2941627        | ARM64_ERRATUM_2941627       |
>  +----------------+-----------------+-----------------+-----------------------------+
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index 0a429c64fbf3e7..a0c9078646fb55 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -215,6 +215,13 @@ bool arm_smmu_sva_supported(struct arm_smmu_device *smmu)
>  	if (system_supports_haft())
>  		feat_mask |= ARM_SMMU_FEAT_HAFT;
>  
> +	/*
> +	 * The workaround for ARM_SMMU_OPT_FULL_CONT_RIL requires range
> +	 * invalidation support.
> +	 */
> +	if (smmu->options & ARM_SMMU_OPT_FULL_CONT_RIL)
> +		feat_mask |= ARM_SMMU_FEAT_RANGE_INV;
> +
>  	if ((smmu->features & feat_mask) != feat_mask)
>  		return false;
>  
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 5732f3ba0122d6..d6896e25b6632a 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2538,6 +2538,36 @@ static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
>  	}
>  }
>  
> +/*
> + * Generate a RIL for ARM_SMMU_OPT_FULL_CONT_RIL by ensuring the entire SVA
> + * requested range is covered with a single RIL command. The scale is adjusted
> + * so that the RIL may extend past the end of the requested range. This ensures
> + * that any CONT the MM is invalidating is covered by a single RIL. TTL and LEAF
> + * are always 0 because this is only used by SVA.
> + */
> +static bool arm_smmu_cmdq_batch_add_ril(struct arm_smmu_device *smmu,
> +					struct arm_smmu_cmdq_batch *cmds,
> +					struct arm_smmu_cmd *cmd,
> +					unsigned long iova, size_t size,
> +					u8 tgsz_lg2)
> +{
> +	u64 cur_tg = iova >> tgsz_lg2;

Nit: tg suffix is a bit confusing, I guess pfn is more accurate, but
no strong opinion.

Reviewed-by: Mostafa Saleh <smostafa@google.com>

Thanks,
Mostafa

> +	u64 num_tg = ((iova + size - 1) >> tgsz_lg2) - cur_tg + 1;
> +	unsigned int scale = fls64((num_tg - 1) / 32);
> +
> +	if (scale > 31)
> +		return false;
> +
> +	cmd->data[0] |=
> +		FIELD_PREP(CMDQ_TLBI_0_NUM,
> +			   DIV_ROUND_UP_ULL(num_tg, 1ULL << scale) - 1) |
> +		FIELD_PREP(CMDQ_TLBI_0_SCALE, scale);
> +	cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_TG, (tgsz_lg2 - 10) / 2) |
> +		       (cur_tg << tgsz_lg2);
> +	arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, cmd);
> +	return true;
> +}
> +
>  static bool arm_smmu_inv_size_too_big(struct arm_smmu_device *smmu, size_t size,
>  				      size_t granule)
>  {
> @@ -2565,21 +2595,30 @@ static bool arm_smmu_inv_size_too_big(struct arm_smmu_device *smmu, size_t size,
>  static void arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
>  				       struct arm_smmu_cmdq_batch *cmds,
>  				       struct arm_smmu_cmd *cmd,
> -				       bool leaf,
> +				       bool single_ril, bool leaf,
>  				       unsigned long iova, size_t size,
>  				       unsigned int granule)
>  {
> -	if (arm_smmu_inv_size_too_big(inv->smmu, size, granule)) {
> -		struct arm_smmu_cmd nsize_cmd = *cmd;
> +	struct arm_smmu_cmd nsize_cmd;
>  
> -		u64p_replace_bits(&nsize_cmd.data[0], inv->nsize_opcode,
> -				  CMDQ_0_OP);
> -		arm_smmu_cmdq_batch_add_cmd_p(inv->smmu, cmds, &nsize_cmd);
> +	if (arm_smmu_inv_size_too_big(inv->smmu, size, granule))
> +		goto full_inv;
> +
> +	if (single_ril && size > granule) {
> +		if (!arm_smmu_cmdq_batch_add_ril(inv->smmu, cmds, cmd, iova,
> +						 size, inv->pgsize))
> +			goto full_inv;
>  		return;
>  	}
>  
> -	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, leaf,
> -				      iova, size, granule, inv->pgsize);
> +	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, leaf, iova, size,
> +				      granule, inv->pgsize);
> +	return;
> +
> +full_inv:
> +	nsize_cmd = *cmd;
> +	u64p_replace_bits(&nsize_cmd.data[0], inv->nsize_opcode, CMDQ_0_OP);
> +	arm_smmu_cmdq_batch_add_cmd_p(inv->smmu, cmds, &nsize_cmd);
>  }
>  
>  static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
> @@ -2600,7 +2639,8 @@ static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
>  
>  static void __arm_smmu_domain_inv_range(struct arm_smmu_invs *invs,
>  					unsigned long iova, size_t size,
> -					unsigned int granule, bool leaf)
> +					unsigned int granule, bool single_ril,
> +					bool leaf)
>  {
>  	struct arm_smmu_cmdq_batch cmds = {};
>  	struct arm_smmu_inv *cur;
> @@ -2630,14 +2670,14 @@ static void __arm_smmu_domain_inv_range(struct arm_smmu_invs *invs,
>  		case INV_TYPE_S1_ASID:
>  			cmd = arm_smmu_make_cmd_tlbi(cur->size_opcode,
>  						     cur->id, 0);
> -			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, leaf,
> -						   iova, size, granule);
> +			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, single_ril,
> +						   leaf, iova, size, granule);
>  			break;
>  		case INV_TYPE_S2_VMID:
>  			cmd = arm_smmu_make_cmd_tlbi(cur->size_opcode,
>  						     0, cur->id);
> -			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, leaf,
> -						   iova, size, granule);
> +			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, single_ril,
> +						   leaf, iova, size, granule);
>  			break;
>  		case INV_TYPE_S2_VMID_S1_CLEAR:
>  			/* CMDQ_OP_TLBI_S12_VMALL already flushed S1 entries */
> @@ -2684,6 +2724,9 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
>  			       unsigned int granule, bool leaf)
>  {
>  	struct arm_smmu_invs *invs;
> +	bool single_ril =
> +		smmu_domain->stage == ARM_SMMU_DOMAIN_SVA &&
> +		(smmu_domain->smmu->options & ARM_SMMU_OPT_FULL_CONT_RIL);
>  
>  	/*
>  	 * An invalidation request must follow some IOPTE change and then load
> @@ -2723,10 +2766,12 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
>  		unsigned long flags;
>  
>  		read_lock_irqsave(&invs->rwlock, flags);
> -		__arm_smmu_domain_inv_range(invs, iova, size, granule, leaf);
> +		__arm_smmu_domain_inv_range(invs, iova, size, granule,
> +					    single_ril, leaf);
>  		read_unlock_irqrestore(&invs->rwlock, flags);
>  	} else {
> -		__arm_smmu_domain_inv_range(invs, iova, size, granule, leaf);
> +		__arm_smmu_domain_inv_range(invs, iova, size, granule,
> +					    single_ril, leaf);
>  	}
>  
>  	rcu_read_unlock();
> @@ -5009,12 +5054,20 @@ static void arm_smmu_device_iidr_probe(struct arm_smmu_device *smmu)
>  				/* Arm errata 2268618, 2812531 */
>  				smmu->features &= ~ARM_SMMU_FEAT_NESTING;
>  			}
> +			/* Arm errata 3777127 */
> +			smmu->options |= ARM_SMMU_OPT_FULL_CONT_RIL;
>  			break;
>  		case IIDR_PRODUCTID_ARM_MMU_L1:
> -		case IIDR_PRODUCTID_ARM_MMU_S3:
> -			/* Arm errata 3878312/3995052 */
> +			/* Arm errata 3878312 */
>  			smmu->features &= ~ARM_SMMU_FEAT_BTM;
>  			break;
> +		case IIDR_PRODUCTID_ARM_MMU_S3:
> +			/* Arm errata 3995052 */
> +			smmu->features &= ~ARM_SMMU_FEAT_BTM;
> +			/* Arm errata 3673557 */
> +			if (variant < 1 || (variant == 1 && revision < 1))
> +				smmu->options |= ARM_SMMU_OPT_FULL_CONT_RIL;
> +			break;
>  		}
>  		break;
>  	}
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 50f8321e979cef..065d76eb148119 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -934,6 +934,8 @@ struct arm_smmu_device {
>  #define ARM_SMMU_OPT_MSIPOLL		(1 << 2)
>  #define ARM_SMMU_OPT_CMDQ_FORCE_SYNC	(1 << 3)
>  #define ARM_SMMU_OPT_TEGRA241_CMDQV	(1 << 4)
> +/* RANGE_INV is mandatory and one RIL must fully span an invalidated CONT */
> +#define ARM_SMMU_OPT_FULL_CONT_RIL	(1 << 5)
>  	u32				options;
>  
>  	struct arm_smmu_cmdq		cmdq;
> -- 
> 2.43.0
> 
