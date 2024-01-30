Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A26379959
	for <patches@lists.linux.dev>; Tue, 30 Jan 2024 22:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706654542; cv=none; b=fTay/CQwYRsvTMpm1578q758gQwjD11D08lPrHzHA5EzsldtF7CaS71+zuipQL2TeSBwUAVK1q7kHwlXnNIRi0GcKSOCzTI9eZN4p/8FvWBil4NotOJvmF428eRXoTKUZ40vJ/AjLEEOf0/+sGRQyxSqZtNQVzobgaymLr/WfhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706654542; c=relaxed/simple;
	bh=450Q9Mu2KlzTJCQhdlxUfMbRR6g3IQWbs8T+T5NwxgU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZVx7NNkN3IABXbFsEzI5rWyAzhtW3a6bPsIuKn1w5fN74p+K//0mazyTMS/udXtiN10qN1+Gjn4Er4R+HrP7WhE3KtfrusWGA480NF9IqcrznJP8XCRtVcn6BYcsZvpNkqxxzxRG1PcvXw7nwKNK4PaLJn43QwuJoQ5eqg1NglE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=suq7TRer; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="suq7TRer"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-40e865bccb4so22465e9.0
        for <patches@lists.linux.dev>; Tue, 30 Jan 2024 14:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706654538; x=1707259338; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZHj7nyjtH2MieQvErrRhvHI9MQmB/Zr/91bGTlsri/I=;
        b=suq7TRer8M5D58L2uDFvbegL6wnfCWYdDAP6+BMX8jNkGtvpEprddbiDNH8ZSc1nDW
         4g2g+L7MFucAiVCkArnqhoCcSkDzHN0oEvf2FSXPMLJ1x68Cgjpu/cALUu1F31iTXZ3Q
         C0GCxs8TLPBHXmDVQYTUcqclhjmsHt3GCwesUBzNOFQI5rpkrF5u/h7tqwLc9mSgB+hL
         9oc7MVmnKCK1xmS1hHWa8wXhC6TxmKJTD+kR21FJcZAe6/rT7o3ztVy3SnDIcqIU0Isx
         glYDkIfsi2GkBkMnO0miLYpF8bETSlto+SM5ifCymJk8oEu0llZFcIyW3RreSixEfNy+
         pMBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706654538; x=1707259338;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZHj7nyjtH2MieQvErrRhvHI9MQmB/Zr/91bGTlsri/I=;
        b=hBksNgcyvD33Sx0JThj53f817KXOrJACQkbAjr81ePFWlrculUjdpriHo0tH0LAkZI
         4z21ySzsKZ7rTin6isKJwRONZ3Bg2BlJpu8aupiNO8McrwSF6BN//UsBpuNOj8CB6hIT
         Fos3pBRMBHnXXvACu+amEdPqJsk1kAV7U5yixdoieCyxvZRM3/zASwTr7T9qyhHi+a8v
         dF3FtCJ/c49r5wwJ116k3UZyo/0Gb3T31inGvn2vp5wD4yRn/UjzCfgQTaTu0PLu0IsK
         sYDm4XjPMJ9M7Dn4HDJG559whIeg8YRdc+Yk2K2BMnnjwODi6xw8gawcxYGoAd2yaqQj
         /tlg==
X-Gm-Message-State: AOJu0YzhScIWpHHDs6HAagQ4Ywj7q6yxAvaKOvrA+gMBemAVlhtR1n3F
	8XsEpWnsJ33/LvWfkageHY3Z707eyWT9ONMm8h3RE588fwLYUIVWAdldH89OUw==
X-Google-Smtp-Source: AGHT+IHP6R8WMVEU0M4x+vz78VshfT+YKvpzOthvNRJqcOYK7zNp8fU8yueJ7vofRT8tBFh2S1/aJg==
X-Received: by 2002:a05:600c:500f:b0:40e:f8fa:1dd2 with SMTP id n15-20020a05600c500f00b0040ef8fa1dd2mr286062wmr.6.1706654537987;
        Tue, 30 Jan 2024 14:42:17 -0800 (PST)
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id d2-20020adf9c82000000b0033929310ae4sm11796652wre.73.2024.01.30.14.42.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jan 2024 14:42:17 -0800 (PST)
Date: Tue, 30 Jan 2024 22:42:13 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v4 01/16] iommu/arm-smmu-v3: Make STE programming
 independent of the callers
Message-ID: <Zbl7RQwOGPebvv_0@google.com>
References: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
 <1-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>

Hi Jason,

Beside the comment on v3 about VMID.

On Thu, Jan 25, 2024 at 07:57:11PM -0400, Jason Gunthorpe wrote:
> As the comment in arm_smmu_write_strtab_ent() explains, this routine has
> been limited to only work correctly in certain scenarios that the caller
> must ensure. Generally the caller must put the STE into ABORT or BYPASS
> before attempting to program it to something else.
> 
> The iommu core APIs would ideally expect the driver to do a hitless change
> of iommu_domain in a number of cases:
> 
>  - RESV_DIRECT support wants IDENTITY -> DMA -> IDENTITY to be hitless
>    for the RESV ranges
> 
>  - PASID upgrade has IDENTIY on the RID with no PASID then a PASID paging
>    domain installed. The RID should not be impacted
> 
>  - PASID downgrade has IDENTIY on the RID and all PASID's removed.
>    The RID should not be impacted
> 
>  - RID does PAGING -> BLOCKING with active PASID, PASID's should not be
>    impacted
> 
>  - NESTING -> NESTING for carrying all the above hitless cases in a VM
>    into the hypervisor. To comprehensively emulate the HW in a VM we should
>    assume the VM OS is running logic like this and expecting hitless updates
>    to be relayed to real HW.

From my understanding, some of these cases are not implemented (at this point).
However, from what I see, most of these cases are related to switching from/to
identity, which the current driver would have to block in between, is my
understanding correct?

As for NESTING -> NESTING,  how is that achieved? (and why?)
AFAICT, VFIO will do BLOCKING in between any transition, and that domain
should never change while the a device is assigned to a VM.

> For CD updates arm_smmu_write_ctx_desc() has a similar comment explaining
> how limited it is, and the driver does have a need for hitless CD updates:
> 
>  - SMMUv3 BTM S1 ASID re-label
> 
>  - SVA mm release should change the CD to answert not-present to all
>    requests without allowing logging (EPD0)
> 
> The next patches/series are going to start removing some of this logic
> from the callers, and add more complex state combinations than currently.
> At the end everything that can be hitless will be hitless, including all
> of the above.
> 
> Introduce arm_smmu_write_entry() which will run through the multi-qword
> programming sequence to avoid creating an incoherent 'torn' STE in the HW
> caches. It automatically detects which of two algorithms to use:
> 
> 1) The disruptive V=0 update described in the spec which disrupts the
>    entry and does three syncs to make the change:
>        - Write V=0 to QWORD 0
>        - Write the entire STE except QWORD 0
>        - Write QWORD 0
> 
> 2) A hitless update algorithm that follows the same rational that the driver
>    already uses. It is safe to change IGNORED bits that HW doesn't use:
>        - Write the target value into all currently unused bits
>        - Write a single QWORD, this makes the new STE live atomically
>        - Ensure now unused bits are 0
> 
> The detection of which path to use and the implementation of the hitless
> update rely on a "used bitmask" describing what bits the HW is actually
> using based on the V/CFG/etc bits. This flows from the spec language,
> typically indicated as IGNORED.
> 
> Knowing which bits the HW is using we can update the bits it does not use
> and then compute how many QWORDS need to be changed. If only one qword
> needs to be updated the hitless algorithm is possible.
> 
> Later patches will include CD updates in this mechanism so make the
> implementation generic using a struct arm_smmu_entry_writer and struct
> arm_smmu_entry_writer_ops to abstract the differences between STE and CD
> to be plugged in.
> 
> At this point it generates the same sequence of updates as the current
> code, except that zeroing the VMID on entry to BYPASS/ABORT will do an
> extra sync (this seems to be an existing bug).
> 
> Going forward this will use a V=0 transition instead of cycling through
> ABORT if a hitfull change is required. This seems more appropriate as ABORT
> will fail DMAs without any logging, but dropping a DMA due to transient
> V=0 is probably signaling a bug, so the C_BAD_STE is valuable.
> 
> Signed-off-by: Michael Shavit <mshavit@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 328 ++++++++++++++++----
>  1 file changed, 261 insertions(+), 67 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 0ffb1cf17e0b2e..690742e8f173eb 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -48,6 +48,22 @@ enum arm_smmu_msi_index {
>  	ARM_SMMU_MAX_MSIS,
>  };
>  
> +struct arm_smmu_entry_writer_ops;
> +struct arm_smmu_entry_writer {
> +	const struct arm_smmu_entry_writer_ops *ops;
> +	struct arm_smmu_master *master;

I see only master->smmu is used, is there a reason why we have this
struct instead?

> +};
> +
> +struct arm_smmu_entry_writer_ops {
> +	unsigned int num_entry_qwords;
> +	__le64 v_bit;
> +	void (*get_used)(struct arm_smmu_entry_writer *writer, const __le64 *entry,
> +			 __le64 *used);

*writer is not used in this series, I think it would make more sense if
it's added in the patch that introduce using it.

> +	void (*sync)(struct arm_smmu_entry_writer *writer);
> +};
> +
> +#define NUM_ENTRY_QWORDS (sizeof(struct arm_smmu_ste) / sizeof(u64))
> +

Isn't that just STRTAB_STE_DWORDS, also it makes more sense to not tie
this to the struct but with the actual hardware description that would
never change (but the struct can change)

>  static phys_addr_t arm_smmu_msi_cfg[ARM_SMMU_MAX_MSIS][3] = {
>  	[EVTQ_MSI_INDEX] = {
>  		ARM_SMMU_EVTQ_IRQ_CFG0,
> @@ -971,6 +987,140 @@ void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid)
>  	arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
>  }
>  
> +/*
> + * Figure out if we can do a hitless update of entry to become target. Returns a
> + * bit mask where 1 indicates that qword needs to be set disruptively.
> + * unused_update is an intermediate value of entry that has unused bits set to
> + * their new values.
> + */
> +static u8 arm_smmu_entry_qword_diff(struct arm_smmu_entry_writer *writer,
> +				    const __le64 *entry, const __le64 *target,
> +				    __le64 *unused_update)
> +{
> +	__le64 target_used[NUM_ENTRY_QWORDS] = {};
> +	__le64 cur_used[NUM_ENTRY_QWORDS] = {};
> +	u8 used_qword_diff = 0;
> +	unsigned int i;
> +
> +	writer->ops->get_used(writer, entry, cur_used);
> +	writer->ops->get_used(writer, target, target_used);
> +
> +	for (i = 0; i != writer->ops->num_entry_qwords; i++) {
> +		/*
> +		 * Check that masks are up to date, the make functions are not
> +		 * allowed to set a bit to 1 if the used function doesn't say it
> +		 * is used.
> +		 */
> +		WARN_ON_ONCE(target[i] & ~target_used[i]);
> +

I think this should be a BUG. As we don't know the consequence for such change,
and this should never happen in a non-development kernel.

> +		/* Bits can change because they are not currently being used */
> +		unused_update[i] = (entry[i] & cur_used[i]) |
> +				   (target[i] & ~cur_used[i]);
> +		/*
> +		 * Each bit indicates that a used bit in a qword needs to be
> +		 * changed after unused_update is applied.
> +		 */
> +		if ((unused_update[i] & target_used[i]) != target[i])
> +			used_qword_diff |= 1 << i;
> +	}
> +	return used_qword_diff;
> +}
> +
> +static bool entry_set(struct arm_smmu_entry_writer *writer, __le64 *entry,
> +		      const __le64 *target, unsigned int start,
> +		      unsigned int len)
> +{
> +	bool changed = false;
> +	unsigned int i;
> +
> +	for (i = start; len != 0; len--, i++) {
> +		if (entry[i] != target[i]) {
> +			WRITE_ONCE(entry[i], target[i]);
> +			changed = true;
> +		}
> +	}
> +
> +	if (changed)
> +		writer->ops->sync(writer);
> +	return changed;
> +}
> +
> +/*
> + * Update the STE/CD to the target configuration. The transition from the
> + * current entry to the target entry takes place over multiple steps that
> + * attempts to make the transition hitless if possible. This function takes care
> + * not to create a situation where the HW can perceive a corrupted entry. HW is
> + * only required to have a 64 bit atomicity with stores from the CPU, while
> + * entries are many 64 bit values big.
> + *
> + * The difference between the current value and the target value is analyzed to
> + * determine which of three updates are required - disruptive, hitless or no
> + * change.
> + *
> + * In the most general disruptive case we can make any update in three steps:
> + *  - Disrupting the entry (V=0)
> + *  - Fill now unused qwords, execpt qword 0 which contains V
> + *  - Make qword 0 have the final value and valid (V=1) with a single 64
> + *    bit store
> + *
> + * However this disrupts the HW while it is happening. There are several
> + * interesting cases where a STE/CD can be updated without disturbing the HW
> + * because only a small number of bits are changing (S1DSS, CONFIG, etc) or
> + * because the used bits don't intersect. We can detect this by calculating how
> + * many 64 bit values need update after adjusting the unused bits and skip the
> + * V=0 process. This relies on the IGNORED behavior described in the
> + * specification.
> + */
> +static void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer,
> +				 __le64 *entry, const __le64 *target)
> +{
> +	unsigned int num_entry_qwords = writer->ops->num_entry_qwords;
> +	__le64 unused_update[NUM_ENTRY_QWORDS];
> +	u8 used_qword_diff;
> +
> +	used_qword_diff =
> +		arm_smmu_entry_qword_diff(writer, entry, target, unused_update);
> +	if (hweight8(used_qword_diff) > 1) {
> +		/*
> +		 * At least two qwords need their inuse bits to be changed. This
> +		 * requires a breaking update, zero the V bit, write all qwords
> +		 * but 0, then set qword 0
> +		 */
> +		unused_update[0] = entry[0] & (~writer->ops->v_bit);
> +		entry_set(writer, entry, unused_update, 0, 1);
> +		entry_set(writer, entry, target, 1, num_entry_qwords - 1);
> +		entry_set(writer, entry, target, 0, 1);
> +	} else if (hweight8(used_qword_diff) == 1) {
> +		/*
> +		 * Only one qword needs its used bits to be changed. This is a
> +		 * hitless update, update all bits the current STE is ignoring
> +		 * to their new values, then update a single "critical qword" to
> +		 * change the STE and finally 0 out any bits that are now unused
> +		 * in the target configuration.
> +		 */
> +		unsigned int critical_qword_index = ffs(used_qword_diff) - 1;
> +
> +		/*
> +		 * Skip writing unused bits in the critical qword since we'll be
> +		 * writing it in the next step anyways. This can save a sync
> +		 * when the only change is in that qword.
> +		 */
> +		unused_update[critical_qword_index] =
> +			entry[critical_qword_index];
> +		entry_set(writer, entry, unused_update, 0, num_entry_qwords);
> +		entry_set(writer, entry, target, critical_qword_index, 1);
> +		entry_set(writer, entry, target, 0, num_entry_qwords);

The STE is updated in 3 steps.
1) Update all bits from target (except the changed qword)
2) Update the changed qword
3) Remove the bits that are not used by the target STE.

In most cases we would issue a sync for 1) and 3) although the hardware ignores
the updates, that seems necessary, am I missing something?

> +	} else {
> +		/*
> +		 * No inuse bit changed. Sanity check that all unused bits are 0
> +		 * in the entry. The target was already sanity checked by
> +		 * compute_qword_diff().
> +		 */
> +		WARN_ON_ONCE(
> +			entry_set(writer, entry, target, 0, num_entry_qwords));
> +	}
> +}
> +
>  static void arm_smmu_sync_cd(struct arm_smmu_master *master,
>  			     int ssid, bool leaf)
>  {
> @@ -1238,50 +1388,123 @@ arm_smmu_write_strtab_l1_desc(__le64 *dst, struct arm_smmu_strtab_l1_desc *desc)
>  	WRITE_ONCE(*dst, cpu_to_le64(val));
>  }
>  
> -static void arm_smmu_sync_ste_for_sid(struct arm_smmu_device *smmu, u32 sid)
> +struct arm_smmu_ste_writer {
> +	struct arm_smmu_entry_writer writer;
> +	u32 sid;
> +};
> +
> +/*
> + * Based on the value of ent report which bits of the STE the HW will access. It
> + * would be nice if this was complete according to the spec, but minimally it
> + * has to capture the bits this driver uses.
> + */
> +static void arm_smmu_get_ste_used(struct arm_smmu_entry_writer *writer,
> +				  const __le64 *ent, __le64 *used_bits)
>  {
> +	used_bits[0] = cpu_to_le64(STRTAB_STE_0_V);
> +	if (!(ent[0] & cpu_to_le64(STRTAB_STE_0_V)))
> +		return;
> +
> +	/*
> +	 * If S1 is enabled S1DSS is valid, see 13.5 Summary of
> +	 * attribute/permission configuration fields for the SHCFG behavior.
> +	 */
> +	if (FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent[0])) & 1 &&
> +	    FIELD_GET(STRTAB_STE_1_S1DSS, le64_to_cpu(ent[1])) ==
> +		    STRTAB_STE_1_S1DSS_BYPASS)
> +		used_bits[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
> +
> +	used_bits[0] |= cpu_to_le64(STRTAB_STE_0_CFG);
> +	switch (FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent[0]))) {
> +	case STRTAB_STE_0_CFG_ABORT:
> +		break;
> +	case STRTAB_STE_0_CFG_BYPASS:
> +		used_bits[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
> +		break;
> +	case STRTAB_STE_0_CFG_S1_TRANS:
> +		used_bits[0] |= cpu_to_le64(STRTAB_STE_0_S1FMT |
> +					    STRTAB_STE_0_S1CTXPTR_MASK |
> +					    STRTAB_STE_0_S1CDMAX);
> +		used_bits[1] |=
> +			cpu_to_le64(STRTAB_STE_1_S1DSS | STRTAB_STE_1_S1CIR |
> +				    STRTAB_STE_1_S1COR | STRTAB_STE_1_S1CSH |
> +				    STRTAB_STE_1_S1STALLD | STRTAB_STE_1_STRW);
> +		used_bits[1] |= cpu_to_le64(STRTAB_STE_1_EATS);
> +		break;
> +	case STRTAB_STE_0_CFG_S2_TRANS:
> +		used_bits[1] |=
> +			cpu_to_le64(STRTAB_STE_1_EATS | STRTAB_STE_1_SHCFG);
> +		used_bits[2] |=
> +			cpu_to_le64(STRTAB_STE_2_S2VMID | STRTAB_STE_2_VTCR |
> +				    STRTAB_STE_2_S2AA64 | STRTAB_STE_2_S2ENDI |
> +				    STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2R);
> +		used_bits[3] |= cpu_to_le64(STRTAB_STE_3_S2TTB_MASK);
> +		break;
> +
> +	default:
> +		memset(used_bits, 0xFF, sizeof(struct arm_smmu_ste));
> +		WARN_ON(true);
> +	}
> +}
> +
> +static void arm_smmu_ste_writer_sync_entry(struct arm_smmu_entry_writer *writer)
> +{
> +	struct arm_smmu_ste_writer *ste_writer =
> +		container_of(writer, struct arm_smmu_ste_writer, writer);
>  	struct arm_smmu_cmdq_ent cmd = {
>  		.opcode	= CMDQ_OP_CFGI_STE,
>  		.cfgi	= {
> -			.sid	= sid,
> +			.sid	= ste_writer->sid,
>  			.leaf	= true,
>  		},
>  	};
>  
> -	arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
> +	arm_smmu_cmdq_issue_cmd_with_sync(writer->master->smmu, &cmd);
> +}
> +
> +static const struct arm_smmu_entry_writer_ops arm_smmu_ste_writer_ops = {
> +	.sync = arm_smmu_ste_writer_sync_entry,
> +	.get_used = arm_smmu_get_ste_used,
> +	.v_bit = cpu_to_le64(STRTAB_STE_0_V),
> +	.num_entry_qwords = sizeof(struct arm_smmu_ste) / sizeof(u64),

Same, I think that's STRTAB_STE_DWORDS.
> +};
> +
> +static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
> +			       struct arm_smmu_ste *ste,
> +			       const struct arm_smmu_ste *target)
> +{
> +	struct arm_smmu_device *smmu = master->smmu;
> +	struct arm_smmu_ste_writer ste_writer = {
> +		.writer = {
> +			.ops = &arm_smmu_ste_writer_ops,
> +			.master = master,
> +		},
> +		.sid = sid,
> +	};
> +
> +	arm_smmu_write_entry(&ste_writer.writer, ste->data, target->data);
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
>  }
>  
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
> @@ -1296,22 +1519,6 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
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
> @@ -1322,16 +1529,11 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
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
> +		arm_smmu_write_ste(master, sid, dst, &target);
>  		return;
>  	}
>  
> @@ -1339,8 +1541,7 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
>  		u64 strw = smmu->features & ARM_SMMU_FEAT_E2H ?
>  			STRTAB_STE_1_STRW_EL2 : STRTAB_STE_1_STRW_NSEL1;
>  
> -		BUG_ON(ste_live);
> -		dst->data[1] = cpu_to_le64(
> +		target.data[1] = cpu_to_le64(
>  			 FIELD_PREP(STRTAB_STE_1_S1DSS, STRTAB_STE_1_S1DSS_SSID0) |
>  			 FIELD_PREP(STRTAB_STE_1_S1CIR, STRTAB_STE_1_S1C_CACHE_WBRA) |
>  			 FIELD_PREP(STRTAB_STE_1_S1COR, STRTAB_STE_1_S1C_CACHE_WBRA) |
> @@ -1349,7 +1550,7 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
>  
>  		if (smmu->features & ARM_SMMU_FEAT_STALLS &&
>  		    !master->stall_enabled)
> -			dst->data[1] |= cpu_to_le64(STRTAB_STE_1_S1STALLD);
> +			target.data[1] |= cpu_to_le64(STRTAB_STE_1_S1STALLD);
>  
>  		val |= (cd_table->cdtab_dma & STRTAB_STE_0_S1CTXPTR_MASK) |
>  			FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S1_TRANS) |
> @@ -1358,8 +1559,7 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
>  	}
>  
>  	if (s2_cfg) {
> -		BUG_ON(ste_live);
> -		dst->data[2] = cpu_to_le64(
> +		target.data[2] = cpu_to_le64(
>  			 FIELD_PREP(STRTAB_STE_2_S2VMID, s2_cfg->vmid) |
>  			 FIELD_PREP(STRTAB_STE_2_VTCR, s2_cfg->vtcr) |
>  #ifdef __BIG_ENDIAN
> @@ -1368,23 +1568,17 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
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
> +	arm_smmu_write_ste(master, sid, dst, &target);
>  }
>  
>  static void arm_smmu_init_bypass_stes(struct arm_smmu_ste *strtab,
> -- 
> 2.43.0
>

Thanks,
Mostafa
