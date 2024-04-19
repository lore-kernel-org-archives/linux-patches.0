Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D78426ACA
	for <patches@lists.linux.dev>; Fri, 19 Apr 2024 21:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713560561; cv=none; b=pnGHqnnMcrwCTIRnOACI5blFtC4xEwjC7uOwjs6SSigEG16uzKXyysADPXFx2F72ugKmCCDnvitdPzLvlUzdy7ZEw085XgwaM+IUTYi2MBk/2gCcz16DJrQozhk6serEBnzAvjuexb0lDTe3T8HuCLscKICywTz2wvosJUplHII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713560561; c=relaxed/simple;
	bh=j40NlzIJAjfyD+Vjko3XK1RbGScf/9u0ieCkhvjtEUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FcXuxOuPdWLxB6UtDYnoKtLSxvfQBxwj7qJ7jns6HzVGtc46l1zHdr1NiQciutUMX/5yq/PmorGWhgWg2puG/f06qbfxurnAqSarViBb7dbfSBVNsE9cXnfV510sh2psOFAfqpNSBkmh7ysFAmZWrTSwCEFTKycgl3SRqa0eorE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Yeb6p9sx; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Yeb6p9sx"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-41699bbfb91so19445e9.0
        for <patches@lists.linux.dev>; Fri, 19 Apr 2024 14:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713560557; x=1714165357; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dR/g1RqQSL1hzTLkoSRq5cGlQLUuRFkyHjupDfBTKnM=;
        b=Yeb6p9sxr9vr7LOxtCEwUl/+2Ml+lpHbU0/17V6jY0H/BqnPSTdGvBxsM/svfblhI+
         2RoUj4jiRLX9ZF67kJIm4/e7ZRigWnKFM3rRmEnB8tWWqkOVJLtsOJdUjd0/qjWn9VL9
         rR2xUayD/KQfL5PQY5MR0tJyMizJ2paHcNY/VuX1ox0du0c3QxB1j1qQgOmk+3aXd2DD
         +qIi/gXiZByJ9UwM9b1yVJBLg+N8CNPRDaVW/OBqoFLVl4xIRDwlvlFNmz4ZZQEkxYCQ
         2TiWTcWwZ292CuQqoTMg/KdNB5OtBoT8mWhPAnXoEeOqUkH4tNBzXRqj95SMN1AAyp31
         QKow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713560557; x=1714165357;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dR/g1RqQSL1hzTLkoSRq5cGlQLUuRFkyHjupDfBTKnM=;
        b=pdhaQw246cUVia5ni8YYKUXjQL2uf6y4+g/XrO60r9h1hLDpScfT5EKADGNr9bGVxg
         WSNpgnrFMoeKOMBrxl14ZbM6W1WeabrIOMWjt8iUEQGgHVelD6VRSF5y8SxzVii0OqHS
         WQvMMgo+gTOXiZTdXj8D1eo50QACpiNUBQl3x0vAPOBT23lr5v1mJQ2I3Ro6Tjvzpyqi
         272+a+b7N7FUje5Bp7e49V5kS6iFeYW157ijJFnplzyc/vfNIJgOxLxMbLNLN750rVUt
         bR/Uv48YyOoCOKYnpE1bxKLUVvvyUntnkK+JuE9BgsEf8CpEUR79udC1iyoF9zWaHja6
         4eZA==
X-Forwarded-Encrypted: i=1; AJvYcCUntxO2ByLBVKeyBkysIz4Va+fWc0+OCUkC9nYW+JRHd0h2+1I79KeqKNZXqJpE782THgcOVIPWnHEiQV12sRJ0LQUQhjeGbA==
X-Gm-Message-State: AOJu0YxIDT5ZnoXgPPJPSvpgpneCx3O0GN1MKzpGEI1KOtv//Xqf8MdD
	oVUEl9kDQwarSgmAxIUHSFIs03etamcqNu4f6e/gwzt8N4SBl+8YT/M6sQFzkg==
X-Google-Smtp-Source: AGHT+IH+oFXgzlco4PiIau9gclsgBzlVNdPzoSLK+qDWm8Qbx8JRpaFSJNWpEIKlVsfULmFD6XiWbQ==
X-Received: by 2002:a05:600c:1c1b:b0:419:d60b:dc52 with SMTP id j27-20020a05600c1c1b00b00419d60bdc52mr45671wms.2.1713560557112;
        Fri, 19 Apr 2024 14:02:37 -0700 (PDT)
Received: from google.com (180.232.140.34.bc.googleusercontent.com. [34.140.232.180])
        by smtp.gmail.com with ESMTPSA id h15-20020a05600c350f00b00418d68df226sm8516063wmq.0.2024.04.19.14.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 14:02:36 -0700 (PDT)
Date: Fri, 19 Apr 2024 21:02:32 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 1/9] iommu/arm-smmu-v3: Add an ops indirection to the
 STE code
Message-ID: <ZiLb6K6mlNa4wwMG@google.com>
References: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <1-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>

Hi Jason,

On Tue, Apr 16, 2024 at 04:28:12PM -0300, Jason Gunthorpe wrote:
> Prepare to put the CD code into the same mechanism. Add an ops indirection
> around all the STE specific code and make the worker functions independent
> of the entry content being processed.
> 
> get_used and sync ops are provided to hook the correct code.
> 
> Signed-off-by: Michael Shavit <mshavit@google.com>
> Reviewed-by: Michael Shavit <mshavit@google.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 178 ++++++++++++--------
>  1 file changed, 106 insertions(+), 72 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 79c18e95dd293e..bf105e914d38b1 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -42,8 +42,20 @@ enum arm_smmu_msi_index {
>  	ARM_SMMU_MAX_MSIS,
>  };
>  
> -static void arm_smmu_sync_ste_for_sid(struct arm_smmu_device *smmu,
> -				      ioasid_t sid);
> +struct arm_smmu_entry_writer_ops;
> +struct arm_smmu_entry_writer {
> +	const struct arm_smmu_entry_writer_ops *ops;
> +	struct arm_smmu_master *master;
> +};
> +
> +struct arm_smmu_entry_writer_ops {
> +	__le64 v_bit;
> +	void (*get_used)(const __le64 *entry, __le64 *used);
> +	void (*sync)(struct arm_smmu_entry_writer *writer);
> +};
> +
> +#define NUM_ENTRY_QWORDS 8
> +static_assert(sizeof(struct arm_smmu_ste) == NUM_ENTRY_QWORDS * sizeof(u64));
>  
>  static phys_addr_t arm_smmu_msi_cfg[ARM_SMMU_MAX_MSIS][3] = {
>  	[EVTQ_MSI_INDEX] = {
> @@ -972,43 +984,42 @@ void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid)
>   * would be nice if this was complete according to the spec, but minimally it
>   * has to capture the bits this driver uses.
>   */
> -static void arm_smmu_get_ste_used(const struct arm_smmu_ste *ent,
> -				  struct arm_smmu_ste *used_bits)
> +static void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
>  {
> -	unsigned int cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent->data[0]));
> +	unsigned int cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent[0]));
>  
> -	used_bits->data[0] = cpu_to_le64(STRTAB_STE_0_V);
> -	if (!(ent->data[0] & cpu_to_le64(STRTAB_STE_0_V)))
> +	used_bits[0] = cpu_to_le64(STRTAB_STE_0_V);
> +	if (!(ent[0] & cpu_to_le64(STRTAB_STE_0_V)))
>  		return;
>  
> -	used_bits->data[0] |= cpu_to_le64(STRTAB_STE_0_CFG);
> +	used_bits[0] |= cpu_to_le64(STRTAB_STE_0_CFG);
>  
>  	/* S1 translates */
>  	if (cfg & BIT(0)) {
> -		used_bits->data[0] |= cpu_to_le64(STRTAB_STE_0_S1FMT |
> -						  STRTAB_STE_0_S1CTXPTR_MASK |
> -						  STRTAB_STE_0_S1CDMAX);
> -		used_bits->data[1] |=
> +		used_bits[0] |= cpu_to_le64(STRTAB_STE_0_S1FMT |
> +					    STRTAB_STE_0_S1CTXPTR_MASK |
> +					    STRTAB_STE_0_S1CDMAX);
> +		used_bits[1] |=
>  			cpu_to_le64(STRTAB_STE_1_S1DSS | STRTAB_STE_1_S1CIR |
>  				    STRTAB_STE_1_S1COR | STRTAB_STE_1_S1CSH |
>  				    STRTAB_STE_1_S1STALLD | STRTAB_STE_1_STRW |
>  				    STRTAB_STE_1_EATS);
> -		used_bits->data[2] |= cpu_to_le64(STRTAB_STE_2_S2VMID);
> +		used_bits[2] |= cpu_to_le64(STRTAB_STE_2_S2VMID);
>  	}
>  
>  	/* S2 translates */
>  	if (cfg & BIT(1)) {
> -		used_bits->data[1] |=
> +		used_bits[1] |=
>  			cpu_to_le64(STRTAB_STE_1_EATS | STRTAB_STE_1_SHCFG);
> -		used_bits->data[2] |=
> +		used_bits[2] |=
>  			cpu_to_le64(STRTAB_STE_2_S2VMID | STRTAB_STE_2_VTCR |
>  				    STRTAB_STE_2_S2AA64 | STRTAB_STE_2_S2ENDI |
>  				    STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2R);
> -		used_bits->data[3] |= cpu_to_le64(STRTAB_STE_3_S2TTB_MASK);
> +		used_bits[3] |= cpu_to_le64(STRTAB_STE_3_S2TTB_MASK);
>  	}
>  
>  	if (cfg == STRTAB_STE_0_CFG_BYPASS)
> -		used_bits->data[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
> +		used_bits[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
>  }
>  
>  /*
> @@ -1017,57 +1028,55 @@ static void arm_smmu_get_ste_used(const struct arm_smmu_ste *ent,
>   * unused_update is an intermediate value of entry that has unused bits set to
>   * their new values.
>   */
> -static u8 arm_smmu_entry_qword_diff(const struct arm_smmu_ste *entry,
> -				    const struct arm_smmu_ste *target,
> -				    struct arm_smmu_ste *unused_update)
> +static u8 arm_smmu_entry_qword_diff(struct arm_smmu_entry_writer *writer,
> +				    const __le64 *entry, const __le64 *target,
> +				    __le64 *unused_update)
>  {
> -	struct arm_smmu_ste target_used = {};
> -	struct arm_smmu_ste cur_used = {};
> +	__le64 target_used[NUM_ENTRY_QWORDS] = {};
> +	__le64 cur_used[NUM_ENTRY_QWORDS] = {};
>  	u8 used_qword_diff = 0;
>  	unsigned int i;
>  
> -	arm_smmu_get_ste_used(entry, &cur_used);
> -	arm_smmu_get_ste_used(target, &target_used);
> +	writer->ops->get_used(entry, cur_used);
> +	writer->ops->get_used(target, target_used);
>  
> -	for (i = 0; i != ARRAY_SIZE(target_used.data); i++) {
> +	for (i = 0; i != NUM_ENTRY_QWORDS; i++) {
>  		/*
>  		 * Check that masks are up to date, the make functions are not
>  		 * allowed to set a bit to 1 if the used function doesn't say it
>  		 * is used.
>  		 */
> -		WARN_ON_ONCE(target->data[i] & ~target_used.data[i]);
> +		WARN_ON_ONCE(target[i] & ~target_used[i]);
>  
>  		/* Bits can change because they are not currently being used */
> -		unused_update->data[i] = (entry->data[i] & cur_used.data[i]) |
> -					 (target->data[i] & ~cur_used.data[i]);
> +		unused_update[i] = (entry[i] & cur_used[i]) |
> +				   (target[i] & ~cur_used[i]);
>  		/*
>  		 * Each bit indicates that a used bit in a qword needs to be
>  		 * changed after unused_update is applied.
>  		 */
> -		if ((unused_update->data[i] & target_used.data[i]) !=
> -		    target->data[i])
> +		if ((unused_update[i] & target_used[i]) != target[i])
>  			used_qword_diff |= 1 << i;
>  	}
>  	return used_qword_diff;
>  }
>  
> -static bool entry_set(struct arm_smmu_device *smmu, ioasid_t sid,
> -		      struct arm_smmu_ste *entry,
> -		      const struct arm_smmu_ste *target, unsigned int start,
> +static bool entry_set(struct arm_smmu_entry_writer *writer, __le64 *entry,
> +		      const __le64 *target, unsigned int start,
>  		      unsigned int len)
>  {
>  	bool changed = false;
>  	unsigned int i;
>  
>  	for (i = start; len != 0; len--, i++) {
> -		if (entry->data[i] != target->data[i]) {
> -			WRITE_ONCE(entry->data[i], target->data[i]);
> +		if (entry[i] != target[i]) {
> +			WRITE_ONCE(entry[i], target[i]);
>  			changed = true;
>  		}
>  	}
>  
>  	if (changed)
> -		arm_smmu_sync_ste_for_sid(smmu, sid);
> +		writer->ops->sync(writer);
>  	return changed;
>  }
>  
> @@ -1097,24 +1106,21 @@ static bool entry_set(struct arm_smmu_device *smmu, ioasid_t sid,
>   * V=0 process. This relies on the IGNORED behavior described in the
>   * specification.
>   */
> -static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
> -			       struct arm_smmu_ste *entry,
> -			       const struct arm_smmu_ste *target)
> +static void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer,
> +				 __le64 *entry, const __le64 *target)
>  {
> -	unsigned int num_entry_qwords = ARRAY_SIZE(target->data);
> -	struct arm_smmu_device *smmu = master->smmu;
> -	struct arm_smmu_ste unused_update;
> +	__le64 unused_update[NUM_ENTRY_QWORDS];
>  	u8 used_qword_diff;
>  
>  	used_qword_diff =
> -		arm_smmu_entry_qword_diff(entry, target, &unused_update);
> +		arm_smmu_entry_qword_diff(writer, entry, target, unused_update);
>  	if (hweight8(used_qword_diff) == 1) {
>  		/*
>  		 * Only one qword needs its used bits to be changed. This is a
> -		 * hitless update, update all bits the current STE is ignoring
> -		 * to their new values, then update a single "critical qword" to
> -		 * change the STE and finally 0 out any bits that are now unused
> -		 * in the target configuration.
> +		 * hitless update, update all bits the current STE/CD is
> +		 * ignoring to their new values, then update a single "critical
> +		 * qword" to change the STE/CD and finally 0 out any bits that
> +		 * are now unused in the target configuration.
>  		 */
>  		unsigned int critical_qword_index = ffs(used_qword_diff) - 1;
>  
> @@ -1123,22 +1129,21 @@ static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
>  		 * writing it in the next step anyways. This can save a sync
>  		 * when the only change is in that qword.
>  		 */
> -		unused_update.data[critical_qword_index] =
> -			entry->data[critical_qword_index];
> -		entry_set(smmu, sid, entry, &unused_update, 0, num_entry_qwords);
> -		entry_set(smmu, sid, entry, target, critical_qword_index, 1);
> -		entry_set(smmu, sid, entry, target, 0, num_entry_qwords);
> +		unused_update[critical_qword_index] =
> +			entry[critical_qword_index];
> +		entry_set(writer, entry, unused_update, 0, NUM_ENTRY_QWORDS);
> +		entry_set(writer, entry, target, critical_qword_index, 1);
> +		entry_set(writer, entry, target, 0, NUM_ENTRY_QWORDS);
>  	} else if (used_qword_diff) {
>  		/*
>  		 * At least two qwords need their inuse bits to be changed. This
>  		 * requires a breaking update, zero the V bit, write all qwords
>  		 * but 0, then set qword 0
>  		 */
> -		unused_update.data[0] = entry->data[0] &
> -					cpu_to_le64(~STRTAB_STE_0_V);
> -		entry_set(smmu, sid, entry, &unused_update, 0, 1);
> -		entry_set(smmu, sid, entry, target, 1, num_entry_qwords - 1);
> -		entry_set(smmu, sid, entry, target, 0, 1);
> +		unused_update[0] = entry[0] & (~writer->ops->v_bit);

arm_smmu_write_entry() assumes that v_bit is in entry[0] and that “1” means valid
(which is true for both STE and CD) so why do we care about it, if we break the
STE/CD anyway, why not just do:

	unused_update[0] = 0;
	entry_set(writer, entry, unused_update, 0, 1);
	entry_set(writer, entry, target, 1, NUM_ENTRY_QWORDS - 1)
	entry_set(writer, entry, target, 0, 1);

That makes the code simpler by avoiding having the v_bit in
arm_smmu_entry_writer_ops.


Thanks,
Mostafa

> +		entry_set(writer, entry, unused_update, 0, 1);
> +		entry_set(writer, entry, target, 1, NUM_ENTRY_QWORDS - 1);
> +		entry_set(writer, entry, target, 0, 1);
>  	} else {
>  		/*
>  		 * No inuse bit changed. Sanity check that all unused bits are 0
> @@ -1146,18 +1151,7 @@ static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
>  		 * compute_qword_diff().
>  		 */
>  		WARN_ON_ONCE(
> -			entry_set(smmu, sid, entry, target, 0, num_entry_qwords));
> -	}
> -
> -	/* It's likely that we'll want to use the new STE soon */
> -	if (!(smmu->options & ARM_SMMU_OPT_SKIP_PREFETCH)) {
> -		struct arm_smmu_cmdq_ent
> -			prefetch_cmd = { .opcode = CMDQ_OP_PREFETCH_CFG,
> -					 .prefetch = {
> -						 .sid = sid,
> -					 } };
> -
> -		arm_smmu_cmdq_issue_cmd(smmu, &prefetch_cmd);
> +			entry_set(writer, entry, target, 0, NUM_ENTRY_QWORDS));
>  	}
>  }
>  
> @@ -1430,17 +1424,57 @@ arm_smmu_write_strtab_l1_desc(__le64 *dst, struct arm_smmu_strtab_l1_desc *desc)
>  	WRITE_ONCE(*dst, cpu_to_le64(val));
>  }
>  
> -static void arm_smmu_sync_ste_for_sid(struct arm_smmu_device *smmu, u32 sid)
> +struct arm_smmu_ste_writer {
> +	struct arm_smmu_entry_writer writer;
> +	u32 sid;
> +};
> +
> +static void arm_smmu_ste_writer_sync_entry(struct arm_smmu_entry_writer *writer)
>  {
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
>  static void arm_smmu_make_abort_ste(struct arm_smmu_ste *target)
> -- 
> 2.43.2
> 
