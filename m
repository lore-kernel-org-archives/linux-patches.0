Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626D776C85
	for <patches@lists.linux.dev>; Mon, 29 Jan 2024 19:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706555456; cv=none; b=hNEI5OJdXGujXs/nj0SRFvhyLgTTCyy0JaDRVWZEM9FXsUtHixLpqA7d3wYDEnJpJraqbaDfCsWt47o8eo09dRovT4jHOFyOw+Jn6s16gc2awXCLyfgYsE0p/c9AIoDmeANg6NIOk884BzGgIicHOkHHi+5oDEWvi8Waev6dzgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706555456; c=relaxed/simple;
	bh=4uPdPIh+BSYrwh1ae3IlzCJs09fYGE+36cbcghzaq2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GUy9khwE5rZgkA6IWYSJgK4GtlIeFGH9ahMr62vqE+lYNIpCIMB5l74wvT4xOSdQpFiROLAxSHbreQPMBvwUQVVvzUbcNkEbwt728/ve9U2U9ANBMN8zsOLj/bJY+h5+mZxc2FsCePmRjU50nVo3SMeIkO1RTdEkGYC8srS7qUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eiHlDs9s; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eiHlDs9s"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-40e865bccb4so8235e9.0
        for <patches@lists.linux.dev>; Mon, 29 Jan 2024 11:10:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706555451; x=1707160251; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=AU6TkVc95eaOBFVMWV9z5un7MhQ7aknCzqqEszCri9k=;
        b=eiHlDs9spebdudw0YRqoec6GYDdtlozcCj/3OL7qKSmdppPGGLlVg2hmDoROhVz6ZQ
         PHmvYcVY66iC4YS+eYi0WtmIntxIjB0J0uelr4kp2GMhMh5xqHCbqAIsDgtV1yvv0E9D
         ZCu2pzTLkE0dvY0ZTWe/3PKDlaPK+Pc44OJLia4eQJT8YBTqOt3Pyhq5Hx+HmAQx3WYp
         smREaHnX6NeB/SoZAjJs0TLut8gI8YMw5DWdNN2Jje4Fj3yN0GP5ppigVUBXND6FxeoI
         c/nBsIO2w4zaGvy8ncCUxWYoq4+dPVuTigXTjsFyhLX8jmrC/zUNVJp5F6k89cXVTtA2
         q+zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706555451; x=1707160251;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AU6TkVc95eaOBFVMWV9z5un7MhQ7aknCzqqEszCri9k=;
        b=BzfbraIlcY6drcjVYgHnFSq2DF6aNcxmIsn29jppGTwRWOUX1NNRV1ldJ9ArpJ6Vs8
         3hctJKtmSPXKxl+wey6Hr5HUQs/c37CGqfXX4/mDgXY91bUwCe74eMt/nnqUCDt5H3gJ
         mJSOLheKgXDGuYFbcFma1JpsfVVFxXNT0YmTvQ7buVhLxdLJoMz3Bt5hapx7pDUVKm2k
         zSRQAnaM7SqY6OczaD29IxdR/9Mu9vcO01uh1sFufQX4Cz2k4EAqHaUhg5LIaLwLe4xy
         9qcF0+DFBGi7jiesIwJcaD9g/xt8PXfJpXZ73u2GIssTKx8RBY2k4gcMWpDzxxd+s3TG
         QPPw==
X-Gm-Message-State: AOJu0YwdASRwlffNujvPkOPc3o7gnznz51uHHlMLiZ+JRiRx0GHisGZ7
	dwtfatmjDWE6dvLzPtQrm4xs98Ef3u2DV0SmpWBsp8B+1oOtExB/4LHfoR+WWQ==
X-Google-Smtp-Source: AGHT+IGY0nwY27Z3YiRnoNH5L+IOds2289s9k0tIhdtMpJL6OK9PrRhAyVjpH8X+7Xfu0te8qf5I5A==
X-Received: by 2002:a05:600c:4a96:b0:40e:61cf:af91 with SMTP id b22-20020a05600c4a9600b0040e61cfaf91mr11411wmp.7.1706555451279;
        Mon, 29 Jan 2024 11:10:51 -0800 (PST)
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id l29-20020a05600c1d1d00b0040ef8aa4822sm2990990wms.38.2024.01.29.11.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jan 2024 11:10:50 -0800 (PST)
Date: Mon, 29 Jan 2024 19:10:47 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v3 04/19] iommu/arm-smmu-v3: Make STE programming
 independent of the callers
Message-ID: <Zbf4NyiZtmjslDFf@google.com>
References: <0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
 <4-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>

Hi Jason,

On Tue, Dec 05, 2023 at 03:14:36PM -0400, Jason Gunthorpe wrote:
> As the comment in arm_smmu_write_strtab_ent() explains, this routine has
> been limited to only work correctly in certain scenarios that the caller
> must ensure. Generally the caller must put the STE into ABORT or BYPASS
> before attempting to program it to something else.
> 
> The next patches/series are going to start removing some of this logic
> from the callers, and add more complex state combinations than currently.
> 
> Thus, consolidate all the complexity here. Callers do not have to care
> about what STE transition they are doing, this function will handle
> everything optimally.
> 
> Revise arm_smmu_write_strtab_ent() so it algorithmically computes the
> required programming sequence to avoid creating an incoherent 'torn' STE
> in the HW caches. The update algorithm follows the same design that the
> driver already uses: it is safe to change bits that HW doesn't currently
> use and then do a single 64 bit update, with sync's in between.
> 
> The basic idea is to express in a bitmask what bits the HW is actually
> using based on the V and CFG bits. Based on that mask we know what STE
> changes are safe and which are disruptive. We can count how many 64 bit
> QWORDS need a disruptive update and know if a step with V=0 is required.
> 
> This gives two basic flows through the algorithm.
> 
> If only a single 64 bit quantity needs disruptive replacement:
>  - Write the target value into all currently unused bits
>  - Write the single 64 bit quantity
>  - Zero the remaining different bits
> 
> If multiple 64 bit quantities need disruptive replacement then do:
>  - Write V=0 to QWORD 0
>  - Write the entire STE except QWORD 0
>  - Write QWORD 0
> 
> With HW flushes at each step, that can be skipped if the STE didn't change
> in that step.
> 
> At this point it generates the same sequence of updates as the current
> code, except that zeroing the VMID on entry to BYPASS/ABORT will do an
> extra sync (this seems to be an existing bug).
> 
> Going forward this will use a V=0 transition instead of cycling through
> ABORT if a hitfull change is required. This seems more appropriate as ABORT
> will fail DMAs without any logging, but dropping a DMA due to transient
> V=0 is probably signaling a bug, so the C_BAD_STE is valuable.
Would the driver do anything in that case, or would just print the log message?

> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 272 +++++++++++++++-----
>  1 file changed, 208 insertions(+), 64 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index b120d836681c1c..0934f882b94e94 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -971,6 +971,101 @@ void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid)
>  	arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
>  }
>  
> +/*
> + * This algorithm updates any STE/CD to any value without creating a situation
> + * where the HW can percieve a corrupted entry. HW is only required to have a 64
> + * bit atomicity with stores from the CPU, while entries are many 64 bit values
> + * big.
> + *
> + * The algorithm works by evolving the entry toward the target in a series of
> + * steps. Each step synchronizes with the HW so that the HW can not see an entry
> + * torn across two steps. Upon each call cur/cur_used reflect the current
> + * synchronized value seen by the HW.
> + *
> + * During each step the HW can observe a torn entry that has any combination of
> + * the step's old/new 64 bit words. The algorithm objective is for the HW
> + * behavior to always be one of current behavior, V=0, or new behavior, during
> + * each step, and across all steps.
> + *
> + * At each step one of three actions is chosen to evolve cur to target:
> + *  - Update all unused bits with their target values.
> + *    This relies on the IGNORED behavior described in the specification
> + *  - Update a single 64-bit value
> + *  - Update all unused bits and set V=0
> + *
> + * The last two actions will cause cur_used to change, which will then allow the
> + * first action on the next step.
> + *
> + * In the most general case we can make any update in three steps:
> + *  - Disrupting the entry (V=0)
> + *  - Fill now unused bits, all bits except V
> + *  - Make valid (V=1), single 64 bit store
> + *
> + * However this disrupts the HW while it is happening. There are several
> + * interesting cases where a STE/CD can be updated without disturbing the HW
> + * because only a small number of bits are changing (S1DSS, CONFIG, etc) or
> + * because the used bits don't intersect. We can detect this by calculating how
> + * many 64 bit values need update after adjusting the unused bits and skip the
> + * V=0 process.
> + */
> +static bool arm_smmu_write_entry_step(__le64 *cur, const __le64 *cur_used,
> +				      const __le64 *target,
> +				      const __le64 *target_used, __le64 *step,
> +				      __le64 v_bit,
I think this is confusing here, I believe we have this as an argument as this
function would be used for CD later, however for this series it is unnecessary,
IMHO, this should be removed and added in another patch for the CD rework.

> +				      unsigned int len)
> +{
> +	u8 step_used_diff = 0;
> +	u8 step_change = 0;
> +	unsigned int i;
> +
> +	/*
> +	 * Compute a step that has all the bits currently unused by HW set to
> +	 * their target values.
> +	 */
> +	for (i = 0; i != len; i++) {
> +		step[i] = (cur[i] & cur_used[i]) | (target[i] & ~cur_used[i]);
> +		if (cur[i] != step[i])
> +			step_change |= 1 << i;
> +		/*
> +		 * Each bit indicates if the step is incorrect compared to the
> +		 * target, considering only the used bits in the target
> +		 */
> +		if ((step[i] & target_used[i]) != (target[i] & target_used[i]))
> +			step_used_diff |= 1 << i;
> +	}
> +
> +	if (hweight8(step_used_diff) > 1) {
> +		/*
> +		 * More than 1 qword is mismatched, this cannot be done without
> +		 * a break. Clear the V bit and go again.
> +		 */
> +		step[0] &= ~v_bit;
> +	} else if (!step_change && step_used_diff) {
> +		/*
> +		 * Have exactly one critical qword, all the other qwords are set
> +		 * correctly, so we can set this qword now.
> +		 */
> +		i = ffs(step_used_diff) - 1;
> +		step[i] = target[i];
> +	} else if (!step_change) {
> +		/* cur == target, so all done */
> +		if (memcmp(cur, target, len * sizeof(*cur)) == 0)
> +			return true;
> +
> +		/*
> +		 * All the used HW bits match, but unused bits are different.
> +		 * Set them as well. Technically this isn't necessary but it
> +		 * brings the entry to the full target state, so if there are
> +		 * bugs in the mask calculation this will obscure them.
> +		 */
> +		memcpy(step, target, len * sizeof(*step));
> +	}
> +
> +	for (i = 0; i != len; i++)
> +		WRITE_ONCE(cur[i], step[i]);
> +	return false;
> +}
> +
>  static void arm_smmu_sync_cd(struct arm_smmu_master *master,
>  			     int ssid, bool leaf)
>  {
> @@ -1248,37 +1343,115 @@ static void arm_smmu_sync_ste_for_sid(struct arm_smmu_device *smmu, u32 sid)
>  	arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
>  }
>  
> +/*
> + * Based on the value of ent report which bits of the STE the HW will access. It
> + * would be nice if this was complete according to the spec, but minimally it
> + * has to capture the bits this driver uses.
> + */
> +static void arm_smmu_get_ste_used(const struct arm_smmu_ste *ent,
> +				  struct arm_smmu_ste *used_bits)
> +{
> +	memset(used_bits, 0, sizeof(*used_bits));
> +
> +	used_bits->data[0] = cpu_to_le64(STRTAB_STE_0_V);
> +	if (!(ent->data[0] & cpu_to_le64(STRTAB_STE_0_V)))
> +		return;
> +
> +	/*
> +	 * If S1 is enabled S1DSS is valid, see 13.5 Summary of
> +	 * attribute/permission configuration fields for the SHCFG behavior.
> +	 */
> +	if (FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent->data[0])) & 1 &&
> +	    FIELD_GET(STRTAB_STE_1_S1DSS, le64_to_cpu(ent->data[1])) ==
> +		    STRTAB_STE_1_S1DSS_BYPASS)
> +		used_bits->data[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
> +
> +	used_bits->data[0] |= cpu_to_le64(STRTAB_STE_0_CFG);
> +	switch (FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent->data[0]))) {
> +	case STRTAB_STE_0_CFG_ABORT:
> +		break;
> +	case STRTAB_STE_0_CFG_BYPASS:
> +		used_bits->data[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
> +		break;
> +	case STRTAB_STE_0_CFG_S1_TRANS:
> +		used_bits->data[0] |= cpu_to_le64(STRTAB_STE_0_S1FMT |
> +						  STRTAB_STE_0_S1CTXPTR_MASK |
> +						  STRTAB_STE_0_S1CDMAX);
> +		used_bits->data[1] |=
> +			cpu_to_le64(STRTAB_STE_1_S1DSS | STRTAB_STE_1_S1CIR |
> +				    STRTAB_STE_1_S1COR | STRTAB_STE_1_S1CSH |
> +				    STRTAB_STE_1_S1STALLD | STRTAB_STE_1_STRW);
> +		used_bits->data[1] |= cpu_to_le64(STRTAB_STE_1_EATS);
> +		break;
AFAIU, this is missing something like (while passing smmu->features)
	used_bits->data[2] |= features & ARM_SMMU_FEAT_NESTING ?
			      cpu_to_le64(STRTAB_STE_2_S2VMID) : 0;

As the SMMUv3 manual says:
“ For a Non-secure STE when stage 2 is implemented (SMMU_IDR0.S2P == 1)
  translations resulting from a StreamWorld == NS-EL1 configuration are
  VMID-tagged with S2VMID when either of stage 1 (Config[0] == 1) or stage 2
  (Config[1] == 1) provide translation.“

Which means in case of S1=>S2 switch or vice versa this algorithm will ignore
VMID while it is used.

> +	case STRTAB_STE_0_CFG_S2_TRANS:
> +		used_bits->data[1] |=
> +			cpu_to_le64(STRTAB_STE_1_EATS | STRTAB_STE_1_SHCFG);
> +		used_bits->data[2] |=
> +			cpu_to_le64(STRTAB_STE_2_S2VMID | STRTAB_STE_2_VTCR |
> +				    STRTAB_STE_2_S2AA64 | STRTAB_STE_2_S2ENDI |
> +				    STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2R);
> +		used_bits->data[3] |= cpu_to_le64(STRTAB_STE_3_S2TTB_MASK);
> +		break;
> +
> +	default:
> +		memset(used_bits, 0xFF, sizeof(*used_bits));
> +		WARN_ON(true);
> +	}
> +}
> +
> +static bool arm_smmu_write_ste_step(struct arm_smmu_ste *cur,
> +				    const struct arm_smmu_ste *target,
> +				    const struct arm_smmu_ste *target_used)
> +{
> +	struct arm_smmu_ste cur_used;
> +	struct arm_smmu_ste step;
> +
> +	arm_smmu_get_ste_used(cur, &cur_used);
> +	return arm_smmu_write_entry_step(cur->data, cur_used.data, target->data,
> +					 target_used->data, step.data,
> +					 cpu_to_le64(STRTAB_STE_0_V),
> +					 ARRAY_SIZE(cur->data));
> +}
> +
> +static void arm_smmu_write_ste(struct arm_smmu_device *smmu, u32 sid,
> +			       struct arm_smmu_ste *ste,
> +			       const struct arm_smmu_ste *target)
> +{
> +	struct arm_smmu_ste target_used;
> +	int i;
> +
> +	arm_smmu_get_ste_used(target, &target_used);
> +	/* Masks in arm_smmu_get_ste_used() are up to date */
> +	for (i = 0; i != ARRAY_SIZE(target->data); i++)
> +		WARN_ON_ONCE(target->data[i] & ~target_used.data[i]);
In what situation this would be triggered, is that for future proofing,
maybe we can move it to arm_smmu_get_ste_used()?

> +
> +	while (true) {
> +		if (arm_smmu_write_ste_step(ste, target, &target_used))
> +			break;
> +		arm_smmu_sync_ste_for_sid(smmu, sid);
> +	}
> +
> +	/* It's likely that we'll want to use the new STE soon */
> +	if (!(smmu->options & ARM_SMMU_OPT_SKIP_PREFETCH)) {
> +		struct arm_smmu_cmdq_ent
> +			prefetch_cmd = { .opcode = CMDQ_OP_PREFETCH_CFG,
> +					 .prefetch = {
> +						 .sid = sid,
> +					 } };
> +
> +		arm_smmu_cmdq_issue_cmd(smmu, &prefetch_cmd);
> +	}
> +}
> +
>  static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
>  				      struct arm_smmu_ste *dst)
>  {
> -	/*
> -	 * This is hideously complicated, but we only really care about
> -	 * three cases at the moment:
> -	 *
> -	 * 1. Invalid (all zero) -> bypass/fault (init)
> -	 * 2. Bypass/fault -> translation/bypass (attach)
> -	 * 3. Translation/bypass -> bypass/fault (detach)
> -	 *
> -	 * Given that we can't update the STE atomically and the SMMU
> -	 * doesn't read the thing in a defined order, that leaves us
> -	 * with the following maintenance requirements:
> -	 *
> -	 * 1. Update Config, return (init time STEs aren't live)
> -	 * 2. Write everything apart from dword 0, sync, write dword 0, sync
> -	 * 3. Update Config, sync
> -	 */
> -	u64 val = le64_to_cpu(dst->data[0]);
> -	bool ste_live = false;
> +	u64 val;
>  	struct arm_smmu_device *smmu = master->smmu;
>  	struct arm_smmu_ctx_desc_cfg *cd_table = NULL;
>  	struct arm_smmu_s2_cfg *s2_cfg = NULL;
>  	struct arm_smmu_domain *smmu_domain = master->domain;
> -	struct arm_smmu_cmdq_ent prefetch_cmd = {
> -		.opcode		= CMDQ_OP_PREFETCH_CFG,
> -		.prefetch	= {
> -			.sid	= sid,
> -		},
> -	};
> +	struct arm_smmu_ste target = {};
>  
>  	if (smmu_domain) {
>  		switch (smmu_domain->stage) {
> @@ -1293,22 +1466,6 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
>  		}
>  	}
>  
> -	if (val & STRTAB_STE_0_V) {
> -		switch (FIELD_GET(STRTAB_STE_0_CFG, val)) {
> -		case STRTAB_STE_0_CFG_BYPASS:
> -			break;
> -		case STRTAB_STE_0_CFG_S1_TRANS:
> -		case STRTAB_STE_0_CFG_S2_TRANS:
> -			ste_live = true;
> -			break;
> -		case STRTAB_STE_0_CFG_ABORT:
> -			BUG_ON(!disable_bypass);
> -			break;
> -		default:
> -			BUG(); /* STE corruption */
> -		}
> -	}
> -
>  	/* Nuke the existing STE_0 value, as we're going to rewrite it */
>  	val = STRTAB_STE_0_V;
>  
> @@ -1319,16 +1476,11 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
>  		else
>  			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS);
>  
> -		dst->data[0] = cpu_to_le64(val);
> -		dst->data[1] = cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG,
> +		target.data[0] = cpu_to_le64(val);
> +		target.data[1] = cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG,
>  						STRTAB_STE_1_SHCFG_INCOMING));
> -		dst->data[2] = 0; /* Nuke the VMID */
> -		/*
> -		 * The SMMU can perform negative caching, so we must sync
> -		 * the STE regardless of whether the old value was live.
> -		 */
> -		if (smmu)
> -			arm_smmu_sync_ste_for_sid(smmu, sid);
> +		target.data[2] = 0; /* Nuke the VMID */
> +		arm_smmu_write_ste(smmu, sid, dst, &target);
>  		return;
>  	}
>  
> @@ -1336,8 +1488,7 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
>  		u64 strw = smmu->features & ARM_SMMU_FEAT_E2H ?
>  			STRTAB_STE_1_STRW_EL2 : STRTAB_STE_1_STRW_NSEL1;
>  
> -		BUG_ON(ste_live);
> -		dst->data[1] = cpu_to_le64(
> +		target.data[1] = cpu_to_le64(
>  			 FIELD_PREP(STRTAB_STE_1_S1DSS, STRTAB_STE_1_S1DSS_SSID0) |
>  			 FIELD_PREP(STRTAB_STE_1_S1CIR, STRTAB_STE_1_S1C_CACHE_WBRA) |
>  			 FIELD_PREP(STRTAB_STE_1_S1COR, STRTAB_STE_1_S1C_CACHE_WBRA) |
> @@ -1346,7 +1497,7 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
>  
>  		if (smmu->features & ARM_SMMU_FEAT_STALLS &&
>  		    !master->stall_enabled)
> -			dst->data[1] |= cpu_to_le64(STRTAB_STE_1_S1STALLD);
> +			target.data[1] |= cpu_to_le64(STRTAB_STE_1_S1STALLD);
>  
>  		val |= (cd_table->cdtab_dma & STRTAB_STE_0_S1CTXPTR_MASK) |
>  			FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S1_TRANS) |
> @@ -1355,8 +1506,7 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
>  	}
>  
>  	if (s2_cfg) {
> -		BUG_ON(ste_live);
> -		dst->data[2] = cpu_to_le64(
> +		target.data[2] = cpu_to_le64(
>  			 FIELD_PREP(STRTAB_STE_2_S2VMID, s2_cfg->vmid) |
>  			 FIELD_PREP(STRTAB_STE_2_VTCR, s2_cfg->vtcr) |
>  #ifdef __BIG_ENDIAN
> @@ -1365,23 +1515,17 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
>  			 STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2AA64 |
>  			 STRTAB_STE_2_S2R);
>  
> -		dst->data[3] = cpu_to_le64(s2_cfg->vttbr & STRTAB_STE_3_S2TTB_MASK);
> +		target.data[3] = cpu_to_le64(s2_cfg->vttbr & STRTAB_STE_3_S2TTB_MASK);
>  
>  		val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S2_TRANS);
>  	}
>  
>  	if (master->ats_enabled)
> -		dst->data[1] |= cpu_to_le64(FIELD_PREP(STRTAB_STE_1_EATS,
> +		target.data[1] |= cpu_to_le64(FIELD_PREP(STRTAB_STE_1_EATS,
>  						 STRTAB_STE_1_EATS_TRANS));
>  
> -	arm_smmu_sync_ste_for_sid(smmu, sid);
> -	/* See comment in arm_smmu_write_ctx_desc() */
> -	WRITE_ONCE(dst->data[0], cpu_to_le64(val));
> -	arm_smmu_sync_ste_for_sid(smmu, sid);
> -
> -	/* It's likely that we'll want to use the new STE soon */
> -	if (!(smmu->options & ARM_SMMU_OPT_SKIP_PREFETCH))
> -		arm_smmu_cmdq_issue_cmd(smmu, &prefetch_cmd);
> +	target.data[0] = cpu_to_le64(val);
> +	arm_smmu_write_ste(smmu, sid, dst, &target);
>  }
>  
>  static void arm_smmu_init_bypass_stes(struct arm_smmu_ste *strtab,
> -- 
> 2.43.0
>
Thanks,
Mostafa
