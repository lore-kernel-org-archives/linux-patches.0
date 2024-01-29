Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C8E6F07F
	for <patches@lists.linux.dev>; Mon, 29 Jan 2024 19:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706558028; cv=none; b=IHqh2QKxXXPiHDQ0Plb4OHzIJPwNhV4jxLxDYRFS4x4t1bVuJMuO9oqtcfoFBcRkkINXdTot8aFPewc0Q4fnqOxb8ne6xnBGtn1Sa7E9b1XJj805n5GCla1eBXSUUs7z6zugehQ7wY9/FcoTulxlukvzy6z4Fy3FwayKnxWX/ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706558028; c=relaxed/simple;
	bh=BFFJACDWHPyy4x3nvFGNQyxOQKAEWgkKRKsDxhpeaiE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dhxoQGISXHt+x+Dk4MF22Zwc2LGJzwpEq5b9jEEpRHDnc8fjbZSKtrZLd6LThwYKkCtp8YmAlrbBa1Tf0+JP7HgNnkbnFv8PZmywU6HqHlkQWYQxSr/e8G3tEmizKtXFf2kvWHF9UubNc8lxQrMu5AFsOv0OytgWoa88JR51FV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--moritzf.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mvGB18XD; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--moritzf.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mvGB18XD"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc22f3426aeso5862851276.1
        for <patches@lists.linux.dev>; Mon, 29 Jan 2024 11:53:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706558025; x=1707162825; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rxC1AwSFq/Jk6hZHQr9K/xwH+/VNkE+0hncV5tTt+ug=;
        b=mvGB18XDBVh0wVqBp74pPRFyaKfj/XCodiCWVsk4eKe9oPFoYj1OX/OJlD62sPDObh
         kcDbNMKCM6DzstArS+DFPQTcDuT0mQLYkO5FT51Mo44AeuygFUR95yylAYdY0khJf6ar
         ZuLAEHWN4Ot6rzNxf5NP+48qur674wdjGb52ycQ3/zB2OvlqQEg641BkrMpTxThqasJx
         mMR+tXtrb6ggSNSw/WAhRmtS5ummkY0efnuQcmmZbbG6W8vF7UtAVL2m+r+5Wl0HxtyM
         01GZ+ZenVuX273oNvjjZnJBueR62RMhe7l1rfCnS7ZGS2ZbeZOPJUjnMFL09w+kMO+4S
         LyFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706558025; x=1707162825;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rxC1AwSFq/Jk6hZHQr9K/xwH+/VNkE+0hncV5tTt+ug=;
        b=tGbsQ5MnMPpisyQ+MEP0I/oem2h5RSuXEkGokEjZZpegrIZpwELBpOwZgkNm7ZFVmo
         llC4sOXAjxafslIrL9nyAfomLgM+7q0qmivH/2IsKhpoJB6HMtXLM1bcFOM2I+XevJzr
         RFcEkqqMZ5GYPdQNOp0SWydZ07xSZ+n1UwgaasDhY1NYJKC2EZEv9I/nP4ESsmIOmH77
         /0cOVULHT2a6cbrphLppQBNih+ogfyVRkEROx7dT3kY4V0tGvAvv5Oa+WaeCU3vJCFK8
         cNgW3p8iNHNSAPGPSMwNRs8RIJ2K6TM25kaD37RJVkaimWrH3kghCGTugD5wPPwoz9EP
         iM+A==
X-Gm-Message-State: AOJu0Yz23wr2LA0FHxNyI6508T8izGyk09a86Q/+2PYO0R44zQ2+dZ1K
	jgiBtKbu0U+JzVh2xJ6n8gJE00lwXksdhC8ZhSaYOslHoYANlGwRSfrKKrk+bG/jGJoZ8/X96dk
	r3GBSBA==
X-Google-Smtp-Source: AGHT+IFdrEQ9Yflt/FZ8kF+kQhUpO0Jtf5pz4mGTvenwE9RxHNXpFZ5pxp2B1AsgWHl/NCdR7JeTTe/U0veC
X-Received: from morats.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:d9e])
 (user=moritzf job=sendgmr) by 2002:a25:3305:0:b0:dc3:6b67:9342 with SMTP id
 z5-20020a253305000000b00dc36b679342mr1977022ybz.4.1706558025500; Mon, 29 Jan
 2024 11:53:45 -0800 (PST)
Date: Mon, 29 Jan 2024 19:53:44 +0000
In-Reply-To: <1-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com> <1-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
Message-ID: <20240129195301.6jud6rwy4gre2fm2@google.com>
Subject: Re: [PATCH v4 01/16] iommu/arm-smmu-v3: Make STE programming
 independent of the callers
From: Moritz Fischer <moritzf@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>, 
	Will Deacon <will@kernel.org>, Moritz Fischer <mdf@kernel.org>, Michael Shavit <mshavit@google.com>, 
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev, 
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

On Thu, Jan 25, 2024 at 07:57:11PM -0400, Jason Gunthorpe wrote:
> As the comment in arm_smmu_write_strtab_ent() explains, this routine has
> been limited to only work correctly in certain scenarios that the caller
> must ensure. Generally the caller must put the STE into ABORT or BYPASS
> before attempting to program it to something else.

> The iommu core APIs would ideally expect the driver to do a hitless change
> of iommu_domain in a number of cases:

>   - RESV_DIRECT support wants IDENTITY -> DMA -> IDENTITY to be hitless
>     for the RESV ranges

>   - PASID upgrade has IDENTIY on the RID with no PASID then a PASID paging
>     domain installed. The RID should not be impacted

>   - PASID downgrade has IDENTIY on the RID and all PASID's removed.
>     The RID should not be impacted

>   - RID does PAGING -> BLOCKING with active PASID, PASID's should not be
>     impacted

>   - NESTING -> NESTING for carrying all the above hitless cases in a VM
>     into the hypervisor. To comprehensively emulate the HW in a VM we  
> should
>     assume the VM OS is running logic like this and expecting hitless  
> updates
>     to be relayed to real HW.

> For CD updates arm_smmu_write_ctx_desc() has a similar comment explaining
> how limited it is, and the driver does have a need for hitless CD updates:

>   - SMMUv3 BTM S1 ASID re-label

>   - SVA mm release should change the CD to answert not-present to all
>     requests without allowing logging (EPD0)

> The next patches/series are going to start removing some of this logic
> from the callers, and add more complex state combinations than currently.
> At the end everything that can be hitless will be hitless, including all
> of the above.

> Introduce arm_smmu_write_entry() which will run through the multi-qword
> programming sequence to avoid creating an incoherent 'torn' STE in the HW
> caches. It automatically detects which of two algorithms to use:

> 1) The disruptive V=0 update described in the spec which disrupts the
>     entry and does three syncs to make the change:
>         - Write V=0 to QWORD 0
>         - Write the entire STE except QWORD 0
>         - Write QWORD 0

> 2) A hitless update algorithm that follows the same rational that the  
> driver
>     already uses. It is safe to change IGNORED bits that HW doesn't use:
>         - Write the target value into all currently unused bits
>         - Write a single QWORD, this makes the new STE live atomically
>         - Ensure now unused bits are 0

> The detection of which path to use and the implementation of the hitless
> update rely on a "used bitmask" describing what bits the HW is actually
> using based on the V/CFG/etc bits. This flows from the spec language,
> typically indicated as IGNORED.

> Knowing which bits the HW is using we can update the bits it does not use
> and then compute how many QWORDS need to be changed. If only one qword
> needs to be updated the hitless algorithm is possible.

> Later patches will include CD updates in this mechanism so make the
> implementation generic using a struct arm_smmu_entry_writer and struct
> arm_smmu_entry_writer_ops to abstract the differences between STE and CD
> to be plugged in.

> At this point it generates the same sequence of updates as the current
> code, except that zeroing the VMID on entry to BYPASS/ABORT will do an
> extra sync (this seems to be an existing bug).

> Going forward this will use a V=0 transition instead of cycling through
> ABORT if a hitfull change is required. This seems more appropriate as  
> ABORT
> will fail DMAs without any logging, but dropping a DMA due to transient
> V=0 is probably signaling a bug, so the C_BAD_STE is valuable.

> Signed-off-by: Michael Shavit <mshavit@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 328 ++++++++++++++++----
>   1 file changed, 261 insertions(+), 67 deletions(-)

> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c  
> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 0ffb1cf17e0b2e..690742e8f173eb 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -48,6 +48,22 @@ enum arm_smmu_msi_index {
>   	ARM_SMMU_MAX_MSIS,
>   };

> +struct arm_smmu_entry_writer_ops;
> +struct arm_smmu_entry_writer {
> +	const struct arm_smmu_entry_writer_ops *ops;
> +	struct arm_smmu_master *master;
> +};
> +
> +struct arm_smmu_entry_writer_ops {
> +	unsigned int num_entry_qwords;
> +	__le64 v_bit;
> +	void (*get_used)(struct arm_smmu_entry_writer *writer, const __le64  
> *entry,
> +			 __le64 *used);
> +	void (*sync)(struct arm_smmu_entry_writer *writer);
> +};
> +
> +#define NUM_ENTRY_QWORDS (sizeof(struct arm_smmu_ste) / sizeof(u64))
> +
>   static phys_addr_t arm_smmu_msi_cfg[ARM_SMMU_MAX_MSIS][3] = {
>   	[EVTQ_MSI_INDEX] = {
>   		ARM_SMMU_EVTQ_IRQ_CFG0,
> @@ -971,6 +987,140 @@ void arm_smmu_tlb_inv_asid(struct arm_smmu_device  
> *smmu, u16 asid)
>   	arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
>   }

> +/*
> + * Figure out if we can do a hitless update of entry to become target.  
> Returns a
> + * bit mask where 1 indicates that qword needs to be set disruptively.
> + * unused_update is an intermediate value of entry that has unused bits  
> set to
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
> +static bool entry_set(struct arm_smmu_entry_writer *writer, __le64  
> *entry,
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
> + * attempts to make the transition hitless if possible. This function  
> takes care
> + * not to create a situation where the HW can perceive a corrupted  
> entry. HW is
> + * only required to have a 64 bit atomicity with stores from the CPU,  
> while
> + * entries are many 64 bit values big.
> + *
> + * The difference between the current value and the target value is  
> analyzed to
> + * determine which of three updates are required - disruptive, hitless  
> or no
> + * change.
> + *
> + * In the most general disruptive case we can make any update in three  
> steps:
> + *  - Disrupting the entry (V=0)
> + *  - Fill now unused qwords, execpt qword 0 which contains V
> + *  - Make qword 0 have the final value and valid (V=1) with a single 64
> + *    bit store
> + *
> + * However this disrupts the HW while it is happening. There are several
> + * interesting cases where a STE/CD can be updated without disturbing  
> the HW
> + * because only a small number of bits are changing (S1DSS, CONFIG, etc)  
> or
> + * because the used bits don't intersect. We can detect this by  
> calculating how
> + * many 64 bit values need update after adjusting the unused bits and  
> skip the
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
>   static void arm_smmu_sync_cd(struct arm_smmu_master *master,
>   			     int ssid, bool leaf)
>   {
> @@ -1238,50 +1388,123 @@ arm_smmu_write_strtab_l1_desc(__le64 *dst,  
> struct arm_smmu_strtab_l1_desc *desc)
>   	WRITE_ONCE(*dst, cpu_to_le64(val));
>   }

> -static void arm_smmu_sync_ste_for_sid(struct arm_smmu_device *smmu, u32  
> sid)
> +struct arm_smmu_ste_writer {
> +	struct arm_smmu_entry_writer writer;
> +	u32 sid;
> +};
> +
> +/*
> + * Based on the value of ent report which bits of the STE the HW will  
> access. It
> + * would be nice if this was complete according to the spec, but  
> minimally it
> + * has to capture the bits this driver uses.
> + */
> +static void arm_smmu_get_ste_used(struct arm_smmu_entry_writer *writer,
> +				  const __le64 *ent, __le64 *used_bits)
>   {
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
> +static void arm_smmu_ste_writer_sync_entry(struct arm_smmu_entry_writer  
> *writer)
> +{
> +	struct arm_smmu_ste_writer *ste_writer =
> +		container_of(writer, struct arm_smmu_ste_writer, writer);
>   	struct arm_smmu_cmdq_ent cmd = {
>   		.opcode	= CMDQ_OP_CFGI_STE,
>   		.cfgi	= {
> -			.sid	= sid,
> +			.sid	= ste_writer->sid,
>   			.leaf	= true,
>   		},
>   	};

> -	arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
> +	arm_smmu_cmdq_issue_cmd_with_sync(writer->master->smmu, &cmd);
> +}
> +
> +static const struct arm_smmu_entry_writer_ops arm_smmu_ste_writer_ops = {
> +	.sync = arm_smmu_ste_writer_sync_entry,
> +	.get_used = arm_smmu_get_ste_used,
> +	.v_bit = cpu_to_le64(STRTAB_STE_0_V),
> +	.num_entry_qwords = sizeof(struct arm_smmu_ste) / sizeof(u64),
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
>   }

>   static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master,  
> u32 sid,
>   				      struct arm_smmu_ste *dst)
>   {
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
>   	struct arm_smmu_device *smmu = master->smmu;
>   	struct arm_smmu_ctx_desc_cfg *cd_table = NULL;
>   	struct arm_smmu_s2_cfg *s2_cfg = NULL;
>   	struct arm_smmu_domain *smmu_domain = master->domain;
> -	struct arm_smmu_cmdq_ent prefetch_cmd = {
> -		.opcode		= CMDQ_OP_PREFETCH_CFG,
> -		.prefetch	= {
> -			.sid	= sid,
> -		},
> -	};
> +	struct arm_smmu_ste target = {};

>   	if (smmu_domain) {
>   		switch (smmu_domain->stage) {
> @@ -1296,22 +1519,6 @@ static void arm_smmu_write_strtab_ent(struct  
> arm_smmu_master *master, u32 sid,
>   		}
>   	}

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
>   	/* Nuke the existing STE_0 value, as we're going to rewrite it */
>   	val = STRTAB_STE_0_V;

> @@ -1322,16 +1529,11 @@ static void arm_smmu_write_strtab_ent(struct  
> arm_smmu_master *master, u32 sid,
>   		else
>   			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS);

> -		dst->data[0] = cpu_to_le64(val);
> -		dst->data[1] = cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG,
> +		target.data[0] = cpu_to_le64(val);
> +		target.data[1] = cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG,
>   						STRTAB_STE_1_SHCFG_INCOMING));
> -		dst->data[2] = 0; /* Nuke the VMID */
> -		/*
> -		 * The SMMU can perform negative caching, so we must sync
> -		 * the STE regardless of whether the old value was live.
> -		 */
> -		if (smmu)
> -			arm_smmu_sync_ste_for_sid(smmu, sid);
> +		target.data[2] = 0; /* Nuke the VMID */
> +		arm_smmu_write_ste(master, sid, dst, &target);
>   		return;
>   	}

> @@ -1339,8 +1541,7 @@ static void arm_smmu_write_strtab_ent(struct  
> arm_smmu_master *master, u32 sid,
>   		u64 strw = smmu->features & ARM_SMMU_FEAT_E2H ?
>   			STRTAB_STE_1_STRW_EL2 : STRTAB_STE_1_STRW_NSEL1;

> -		BUG_ON(ste_live);
> -		dst->data[1] = cpu_to_le64(
> +		target.data[1] = cpu_to_le64(
>   			 FIELD_PREP(STRTAB_STE_1_S1DSS, STRTAB_STE_1_S1DSS_SSID0) |
>   			 FIELD_PREP(STRTAB_STE_1_S1CIR, STRTAB_STE_1_S1C_CACHE_WBRA) |
>   			 FIELD_PREP(STRTAB_STE_1_S1COR, STRTAB_STE_1_S1C_CACHE_WBRA) |
> @@ -1349,7 +1550,7 @@ static void arm_smmu_write_strtab_ent(struct  
> arm_smmu_master *master, u32 sid,

>   		if (smmu->features & ARM_SMMU_FEAT_STALLS &&
>   		    !master->stall_enabled)
> -			dst->data[1] |= cpu_to_le64(STRTAB_STE_1_S1STALLD);
> +			target.data[1] |= cpu_to_le64(STRTAB_STE_1_S1STALLD);

>   		val |= (cd_table->cdtab_dma & STRTAB_STE_0_S1CTXPTR_MASK) |
>   			FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S1_TRANS) |
> @@ -1358,8 +1559,7 @@ static void arm_smmu_write_strtab_ent(struct  
> arm_smmu_master *master, u32 sid,
>   	}

>   	if (s2_cfg) {
> -		BUG_ON(ste_live);
> -		dst->data[2] = cpu_to_le64(
> +		target.data[2] = cpu_to_le64(
>   			 FIELD_PREP(STRTAB_STE_2_S2VMID, s2_cfg->vmid) |
>   			 FIELD_PREP(STRTAB_STE_2_VTCR, s2_cfg->vtcr) |
>   #ifdef __BIG_ENDIAN
> @@ -1368,23 +1568,17 @@ static void arm_smmu_write_strtab_ent(struct  
> arm_smmu_master *master, u32 sid,
>   			 STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2AA64 |
>   			 STRTAB_STE_2_S2R);

> -		dst->data[3] = cpu_to_le64(s2_cfg->vttbr & STRTAB_STE_3_S2TTB_MASK);
> +		target.data[3] = cpu_to_le64(s2_cfg->vttbr & STRTAB_STE_3_S2TTB_MASK);

>   		val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S2_TRANS);
>   	}

>   	if (master->ats_enabled)
> -		dst->data[1] |= cpu_to_le64(FIELD_PREP(STRTAB_STE_1_EATS,
> +		target.data[1] |= cpu_to_le64(FIELD_PREP(STRTAB_STE_1_EATS,
>   						 STRTAB_STE_1_EATS_TRANS));

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
>   }

>   static void arm_smmu_init_bypass_stes(struct arm_smmu_ste *strtab,
> --
> 2.43.0

Reviewed-by: Moritz Fischer <moritzf@google.com>
