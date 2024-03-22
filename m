Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779A663101
	for <patches@lists.linux.dev>; Fri, 22 Mar 2024 18:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711131273; cv=none; b=miMOWaFpwyhVqD2iEUSU3EzWId3nUX+tBAdUlGHz5NZC7zqflxCUZIdsoIa2wFWs6QMf3/dPP93lIRSFycCUUNZbdmigFnPZk/CmDFuKttKeMjKyRRbgDij0pgFFkvlE+9MZXSiyXG40wYcJUS2gibOla94EHeCoBOluZmoNqFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711131273; c=relaxed/simple;
	bh=Ulh2+U57NPF9A35k/OArrt2i9+CAkPAY0qErvvEfms0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CwhUg3KkTQZQh/x/eyug/PyfBRBMw1Ng9Nslpjgmryp3VhKZcZ5ct/mLNZQ7vHq5fylKq6lsz/TpcZqzFbaJLifXsi32yWnKPmQY87RT9axlMXLt3MgYGGnJAXnUFUKCi2Pjp9CtIeU3NNFxhtQ8FstB+ki+k3M6ihZZDjTaQ3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EFeWjj0I; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EFeWjj0I"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4140eed8a4fso10585e9.0
        for <patches@lists.linux.dev>; Fri, 22 Mar 2024 11:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711131270; x=1711736070; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Tg7FK1adNy9kVBWtxm5M01gQDSSIPZ6QTtS5XJqEjTE=;
        b=EFeWjj0If7kIswmNJwDm6+QcuJt3KRnUQ5BLi2IoFT/E8Eu40TkErAA5ZgEf5kEvZx
         UtIQU+4vZr3gWS/aalVWAdi6/AlTxEM5NM9rX676gyBRQPPCJ/qEbloYLqWRrYTPwoBa
         2xdujWEeOzGVoNi+cyf7tHpKWdiqDC/N+bfeFptTyoFgMMCdYLeNwSmlXlcKkV+/Rwgz
         6OAedA3n6tj3ndpBj2q2/biDN82cz7zQ7x0N331NNXJvqALkWqATkAaSjmi/1NbRCNFp
         VANzVLwucErXhrmnUl4q1r+k5YcdEqf2YWXQ6vIkVdonjbfsjXv4GXyIv62o8RG3Ixkd
         8y5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711131270; x=1711736070;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tg7FK1adNy9kVBWtxm5M01gQDSSIPZ6QTtS5XJqEjTE=;
        b=R5/pBIBnRTfl0HOp6nwa+fbEUSUQj6x3DDxlizJt2Ygk+53M+jjvjPBpFAoyKwh7LO
         Y6WmILBawQOzp+KfrvHhI4XqtMSiaHHKc/BwQFr57PIvkZ/C89vEsHSBSquXmAfJdLXp
         EjMU7j3xeT/xxmGTBhfoQ+WP5DiMtqRlIL6Az98+pFYufQo2iE7ARrLelHvXUFrF1XL4
         WFsQPoXMatRE9gxQphgpFb0DTbdYzOMloYcra+E317zzXM1wRUnhXt9bCt4Y1W4Edy70
         LO2PEkENzjn1f+pUhsxU+gSxZWAoNbEeW8dH/4/+nrKvSzGPaeeDP+bW2CZcLwJ0HRt9
         EMRQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0lrt/Rk298jxv56WRj7pqLighs/cX8fRKTDd4MJyeIdkv7WmAtFa2tb2e9XEHlYLkuSkkUWyffkTTaAVu9bdTe3kYDVQabg==
X-Gm-Message-State: AOJu0YwjCHWC4kXxZ5jCfyrkWuCAAOg2D+N5j0Iynav/33t0+VsCB7Kc
	dKkGs+kWwZPUwxdRpjqkAjh5Z/ODsPptEWAmN29jfRKRLJl/+mY1P+PPJdv7Tg==
X-Google-Smtp-Source: AGHT+IFlAz1VWtABt9QEIqbX69Q4NML8xtukhkG+yMimaYpYIEIBbyT8vCbvi1HwwGOkvRDTRZqDFQ==
X-Received: by 2002:a05:600c:1c8d:b0:414:800f:f992 with SMTP id k13-20020a05600c1c8d00b00414800ff992mr10631wms.2.1711131269544;
        Fri, 22 Mar 2024 11:14:29 -0700 (PDT)
Received: from google.com (180.232.140.34.bc.googleusercontent.com. [34.140.232.180])
        by smtp.gmail.com with ESMTPSA id n14-20020a5d51ce000000b0033e9fca1e49sm2573790wrv.60.2024.03.22.11.14.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Mar 2024 11:14:28 -0700 (PDT)
Date: Fri, 22 Mar 2024 18:14:24 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 04/27] iommu/arm-smmu-v3: Add an ops indirection to
 the STE code
Message-ID: <Zf3KgGj4Tfc8ytgi@google.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <4-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>

Hi Jason,

On Mon, Mar 04, 2024 at 07:43:52PM -0400, Jason Gunthorpe wrote:
> Prepare to put the CD code into the same mechanism. Add an ops indirection
> around all the STE specific code and make the worker functions independent
> of the entry content being processed.
> 
> get_used and sync ops are provided to hook the correct code.
> 
> Signed-off-by: Michael Shavit <mshavit@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 172 ++++++++++++--------
>  1 file changed, 104 insertions(+), 68 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index c60b067c1f553e..b7f947e36f596f 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -48,8 +48,20 @@ enum arm_smmu_msi_index {
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
> +	unsigned int num_entry_qwords;
> +	__le64 v_bit;
> +	void (*get_used)(const __le64 *entry, __le64 *used);
> +	void (*sync)(struct arm_smmu_entry_writer *writer);
> +};
> +
> +#define NUM_ENTRY_QWORDS (sizeof(struct arm_smmu_ste) / sizeof(u64))
>
>  static phys_addr_t arm_smmu_msi_cfg[ARM_SMMU_MAX_MSIS][3] = {
>  	[EVTQ_MSI_INDEX] = {
> @@ -982,43 +994,42 @@ void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid)
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
> @@ -1027,57 +1038,55 @@ static void arm_smmu_get_ste_used(const struct arm_smmu_ste *ent,
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
This is confusing to me, the function was modified to be generic, so its has
args are __le64 * instead of struct arm_smmu_ste *.
But NUM_ENTRY_QWORDS is defined as “(sizeof(struct arm_smmu_ste) / sizeof(u64))”
and in the same function writer->ops->num_entry_qwords is used nterchangeably,
I understand that this not a constant and the compiler would complain.
But since for any other num_entry_qwords larger than NUM_ENTRY_QWORDS it fails,
and we know STEs and CDs both have the same size, we simplify the code and make
it a constant everywhere.

I see in the next patch, that this is redefined to be the max between STE and
CD, but again, this hardware and it never changes, so my opinion is to simplify
the code, as there is no need to generalize this part.

>  	u8 used_qword_diff = 0;
>  	unsigned int i;
>  
> -	arm_smmu_get_ste_used(entry, &cur_used);
> -	arm_smmu_get_ste_used(target, &target_used);
> +	writer->ops->get_used(entry, cur_used);
> +	writer->ops->get_used(target, target_used);
>  
> -	for (i = 0; i != ARRAY_SIZE(target_used.data); i++) {
> +	for (i = 0; i != writer->ops->num_entry_qwords; i++) {
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
> @@ -1107,17 +1116,15 @@ static bool entry_set(struct arm_smmu_device *smmu, ioasid_t sid,
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
> +	unsigned int num_entry_qwords = writer->ops->num_entry_qwords;
> +	__le64 unused_update[NUM_ENTRY_QWORDS];
>  	u8 used_qword_diff;
>  
>  	used_qword_diff =
> -		arm_smmu_entry_qword_diff(entry, target, &unused_update);
> +		arm_smmu_entry_qword_diff(writer, entry, target, unused_update);
>  	if (hweight8(used_qword_diff) == 1) {
>  		/*
>  		 * Only one qword needs its used bits to be changed. This is a
> @@ -1133,22 +1140,21 @@ static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
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
> +		entry_set(writer, entry, unused_update, 0, num_entry_qwords);
> +		entry_set(writer, entry, target, critical_qword_index, 1);
> +		entry_set(writer, entry, target, 0, num_entry_qwords);
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
> +		entry_set(writer, entry, unused_update, 0, 1);
> +		entry_set(writer, entry, target, 1, num_entry_qwords - 1);
> +		entry_set(writer, entry, target, 0, 1);
>  	} else {
>  		/*
>  		 * No inuse bit changed. Sanity check that all unused bits are 0
> @@ -1156,18 +1162,7 @@ static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
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
> +			entry_set(writer, entry, target, 0, num_entry_qwords));
>  	}
>  }
>  
> @@ -1440,17 +1435,58 @@ arm_smmu_write_strtab_l1_desc(__le64 *dst, struct arm_smmu_strtab_l1_desc *desc)
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
>  }
>  
>  static void arm_smmu_make_abort_ste(struct arm_smmu_ste *target)
> -- 
> 2.43.2
>
Thanks,
Mostafa
