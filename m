Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCB71BDD5
	for <patches@lists.linux.dev>; Sat, 16 Mar 2024 18:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710612870; cv=none; b=YQ4OtjZA3axTx2aiIuh+tBQn1yh7kyBZlVdcOLMRqZu8CwmrdjZVEqnt6gIPwV8lz74vx2fJIRW0ufgaJmNhtPGjljahi43EwjzTnyYXVmt1SpqMsoGIOiVGlcESmgnyM9tljL271tU5AKXAbD+kb9zHA7wdaOtU36hQDioveRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710612870; c=relaxed/simple;
	bh=WhHXEGUkaMjiRKtQh/cvFQ05SmZHv6U1Z6egt4JjF70=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EOAPhTAoc+iGiEqBBuKhitAPOZJliMEuxby75qtvaq5gPPjTWinU2f7XAq/yDQRbDg44XKAgIvdWdtgeNcfz2AUkL926rpOmABmmf2Eikx8RoPHimQrxmt2pRB9ZY8nofjHPGT16HFBjuRKXs96p79ZCPLHwFN59LVBZ+MzGeyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--moritzf.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EHA2917S; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--moritzf.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EHA2917S"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60a20c33f06so48513067b3.2
        for <patches@lists.linux.dev>; Sat, 16 Mar 2024 11:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710612867; x=1711217667; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=d3pAU9RdV7Cu2TdYjNrZ/NSoKiAwpqPwjat/S164y6U=;
        b=EHA2917SqhAWORtAr2e94w3Jx19lURhN4mY4JRft/q0oBYwoCpDtUltRe9UzpoL75Z
         eu0btLS5tmtgW0xvBivZg4YUtPjeGvrSU+ZR8t8GeRRsYXbjuuR0h66flZlKSGUJWv5J
         hPpVXz3EeP7RjqeW29f0N4zlbsM/D8+sTq9a30PDhUG28F/LBgHqEiEX47dJQnBasaCS
         QKc4zAEkJTeNOXj0lAB2jt5HazE3rZf0lBUvWdeNNqhTJUI6EQ5M5W1Ainmjey2er+Xb
         h3gvJb7l0y4YND83t2DLEkr1IORZ9WSUgjnwE0LDy0Wrq8HjIZfo/BT2M6GM6lg9HKf5
         ZM/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710612867; x=1711217667;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d3pAU9RdV7Cu2TdYjNrZ/NSoKiAwpqPwjat/S164y6U=;
        b=v9gr+E1aL8nZ+vUWc1n/+IjQvD9JJFIHqTmTkzBvGGwgGk5KXrFoEyI/t1WuQY7c9F
         7clOrG7QyN4MU83Zn1GndvvfCa17nnQOUnEKNC0xHmKY49CQM24daMFOKDEo2jdNHHuf
         8O04vj9dcBHUDnoh03kpnnWQuLOK1tNbm+tiVo9RRk6Y9ArRqFMXaSThb7lUpuOTDX+7
         VdIZDKdixuBvwNwWsSI7d5yNckVIm1prtE9QG86GKhSvG3Dq8lqfFOwTosv2ebp3JeUl
         KvjtPF9uq18nXRcPMyfSXKVxl68/65npwrlqRhSyHIwrEPXfEiJk8mczME08J8pJftDG
         55cg==
X-Forwarded-Encrypted: i=1; AJvYcCU0HgQaa48Ya0t7Gyq0I3wwA20x/5CudRwh/Pz4QMAWXlZ0JLg4cUlF+IkZkrzP2MZMLWAsntfMAV8MHHgAShcYMiLKsic5zw==
X-Gm-Message-State: AOJu0Yx5PSqYO+wXbPOzKuWZafCX2vhFeQDI4jofDPzBDmf/ETIUZfIH
	YuY8d5qkZJPxkCePrmR6lBG6OgUcy+Y6kjkhS8Nl4KcXJpvuw+FNuhFIDM5OTJVVIfh5MFzRyFx
	LfUfL1Q==
X-Google-Smtp-Source: AGHT+IFKB61aLf4bS/hjmIhFbVH53Gbw/F8QdRnjW7BBmAEcs541XAUDGJOq80pnG90ZWLTJnPBPuYTkI+ZD
X-Received: from morats.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:d9e])
 (user=moritzf job=sendgmr) by 2002:a81:a042:0:b0:60a:3487:6f7c with SMTP id
 x63-20020a81a042000000b0060a34876f7cmr1442778ywg.9.1710612867356; Sat, 16 Mar
 2024 11:14:27 -0700 (PDT)
Date: Sat, 16 Mar 2024 18:14:26 +0000
In-Reply-To: <5-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com> <5-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
Message-ID: <pkmfe7esiqbpxopy44ovwslrzwvy63n22qfwcnroykxmmordkc@shdu7w65v264>
Subject: Re: [PATCH v5 05/27] iommu/arm-smmu-v3: Make CD programming use arm_smmu_write_entry()
From: Moritz Fischer <moritzf@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>, 
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer <mdf@kernel.org>, 
	Michael Shavit <mshavit@google.com>, Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev, 
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

On Mon, Mar 04, 2024 at 07:43:53PM -0400, Jason Gunthorpe wrote:
> CD table entries and STE's have the same essential programming sequence,
> just with different types and sizes.

> Have arm_smmu_write_ctx_desc() generate a target CD and call
> arm_smmu_write_entry() to do the programming. Due to the way the
> target CD is generated by modifying the existing CD this alone is not
> enough for the CD callers to be freed of the ordering requirements.

> The following patches will make the rest of the CD flow mirror the STE
> flow with precise CD contents generated in all cases.

> Currently the logic can't ensure that the CD always conforms to the used
> requirements until all the CD generation is moved to the new method. Add a
> temporary no_used_check to disable the assertions.

> Signed-off-by: Michael Shavit <mshavit@google.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 101 ++++++++++++++------
>   1 file changed, 74 insertions(+), 27 deletions(-)

> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c  
> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index b7f947e36f596f..237fd6d92c880b 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -57,11 +57,14 @@ struct arm_smmu_entry_writer {
>   struct arm_smmu_entry_writer_ops {
>   	unsigned int num_entry_qwords;
>   	__le64 v_bit;
> +	bool no_used_check;
>   	void (*get_used)(const __le64 *entry, __le64 *used);
>   	void (*sync)(struct arm_smmu_entry_writer *writer);
>   };

> -#define NUM_ENTRY_QWORDS (sizeof(struct arm_smmu_ste) / sizeof(u64))
> +#define NUM_ENTRY_QWORDS                                                \
> +	(max(sizeof(struct arm_smmu_ste), sizeof(struct arm_smmu_cd)) / \
> +	 sizeof(u64))

>   static phys_addr_t arm_smmu_msi_cfg[ARM_SMMU_MAX_MSIS][3] = {
>   	[EVTQ_MSI_INDEX] = {
> @@ -1056,7 +1059,8 @@ static u8 arm_smmu_entry_qword_diff(struct  
> arm_smmu_entry_writer *writer,
>   		 * allowed to set a bit to 1 if the used function doesn't say it
>   		 * is used.
>   		 */
> -		WARN_ON_ONCE(target[i] & ~target_used[i]);
> +		if (!writer->ops->no_used_check)
> +			WARN_ON_ONCE(target[i] & ~target_used[i]);

>   		/* Bits can change because they are not currently being used */
>   		unused_update[i] = (entry[i] & cur_used[i]) |
> @@ -1065,7 +1069,8 @@ static u8 arm_smmu_entry_qword_diff(struct  
> arm_smmu_entry_writer *writer,
>   		 * Each bit indicates that a used bit in a qword needs to be
>   		 * changed after unused_update is applied.
>   		 */
> -		if ((unused_update[i] & target_used[i]) != target[i])
> +		if ((unused_update[i] & target_used[i]) !=
> +		    (target[i] & target_used[i]))
>   			used_qword_diff |= 1 << i;
>   	}
>   	return used_qword_diff;
> @@ -1161,8 +1166,11 @@ static void arm_smmu_write_entry(struct  
> arm_smmu_entry_writer *writer,
>   		 * in the entry. The target was already sanity checked by
>   		 * compute_qword_diff().
>   		 */
> -		WARN_ON_ONCE(
> -			entry_set(writer, entry, target, 0, num_entry_qwords));
> +		if (writer->ops->no_used_check)
> +			entry_set(writer, entry, target, 0, num_entry_qwords);
> +		else
> +			WARN_ON_ONCE(entry_set(writer, entry, target, 0,
> +					       num_entry_qwords));
>   	}
>   }

> @@ -1242,6 +1250,59 @@ static struct arm_smmu_cd  
> *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
>   	return &l1_desc->l2ptr[idx];
>   }

> +struct arm_smmu_cd_writer {
> +	struct arm_smmu_entry_writer writer;
> +	unsigned int ssid;
> +};
> +
> +static void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits)
> +{
> +	used_bits[0] = cpu_to_le64(CTXDESC_CD_0_V);
> +	if (!(ent[0] & cpu_to_le64(CTXDESC_CD_0_V)))
> +		return;
> +	memset(used_bits, 0xFF, sizeof(struct arm_smmu_cd));
> +
> +	/* EPD0 means T0SZ/TG0/IR0/OR0/SH0/TTB0 are IGNORED */
> +	if (ent[0] & cpu_to_le64(CTXDESC_CD_0_TCR_EPD0)) {
> +		used_bits[0] &= ~cpu_to_le64(
> +			CTXDESC_CD_0_TCR_T0SZ | CTXDESC_CD_0_TCR_TG0 |
> +			CTXDESC_CD_0_TCR_IRGN0 | CTXDESC_CD_0_TCR_ORGN0 |
> +			CTXDESC_CD_0_TCR_SH0);
> +		used_bits[1] &= ~cpu_to_le64(CTXDESC_CD_1_TTB0_MASK);
> +	}
> +}
> +
> +static void arm_smmu_cd_writer_sync_entry(struct arm_smmu_entry_writer  
> *writer)
> +{
> +	struct arm_smmu_cd_writer *cd_writer =
> +		container_of(writer, struct arm_smmu_cd_writer, writer);
> +
> +	arm_smmu_sync_cd(writer->master, cd_writer->ssid, true);
> +}
> +
> +static const struct arm_smmu_entry_writer_ops arm_smmu_cd_writer_ops = {
> +	.sync = arm_smmu_cd_writer_sync_entry,
> +	.get_used = arm_smmu_get_cd_used,
> +	.v_bit = cpu_to_le64(CTXDESC_CD_0_V),
> +	.no_used_check = true,
> +	.num_entry_qwords = sizeof(struct arm_smmu_cd) / sizeof(u64),
> +};
> +
> +static void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int  
> ssid,
> +				    struct arm_smmu_cd *cdptr,
> +				    const struct arm_smmu_cd *target)
> +{
> +	struct arm_smmu_cd_writer cd_writer = {
> +		.writer = {
> +			.ops = &arm_smmu_cd_writer_ops,
> +			.master = master,
> +		},
> +		.ssid = ssid,
> +	};
> +
> +	arm_smmu_write_entry(&cd_writer.writer, cdptr->data, target->data);
> +}
> +
>   int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
>   			    struct arm_smmu_ctx_desc *cd)
>   {
> @@ -1258,17 +1319,20 @@ int arm_smmu_write_ctx_desc(struct  
> arm_smmu_master *master, int ssid,
>   	 */
>   	u64 val;
>   	bool cd_live;
> -	struct arm_smmu_cd *cdptr;
> +	struct arm_smmu_cd target;
> +	struct arm_smmu_cd *cdptr = &target;
> +	struct arm_smmu_cd *cd_table_entry;
>   	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
>   	struct arm_smmu_device *smmu = master->smmu;

>   	if (WARN_ON(ssid >= (1 << cd_table->s1cdmax)))
>   		return -E2BIG;

> -	cdptr = arm_smmu_get_cd_ptr(master, ssid);
> -	if (!cdptr)
> +	cd_table_entry = arm_smmu_get_cd_ptr(master, ssid);
> +	if (!cd_table_entry)
>   		return -ENOMEM;

> +	target = *cd_table_entry;
>   	val = le64_to_cpu(cdptr->data[0]);
>   	cd_live = !!(val & CTXDESC_CD_0_V);

> @@ -1290,13 +1354,6 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master  
> *master, int ssid,
>   		cdptr->data[2] = 0;
>   		cdptr->data[3] = cpu_to_le64(cd->mair);

> -		/*
> -		 * STE may be live, and the SMMU might read dwords of this CD in any
> -		 * order. Ensure that it observes valid values before reading
> -		 * V=1.
> -		 */
> -		arm_smmu_sync_cd(master, ssid, true);
> -
>   		val = cd->tcr |
>   #ifdef __BIG_ENDIAN
>   			CTXDESC_CD_0_ENDI |
> @@ -1310,18 +1367,8 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master  
> *master, int ssid,
>   		if (cd_table->stall_enabled)
>   			val |= CTXDESC_CD_0_S;
>   	}
> -
> -	/*
> -	 * The SMMU accesses 64-bit values atomically. See IHI0070Ca 3.21.3
> -	 * "Configuration structures and configuration invalidation completion"
> -	 *
> -	 *   The size of single-copy atomic reads made by the SMMU is
> -	 *   IMPLEMENTATION DEFINED but must be at least 64 bits. Any single
> -	 *   field within an aligned 64-bit span of a structure can be altered
> -	 *   without first making the structure invalid.
> -	 */
> -	WRITE_ONCE(cdptr->data[0], cpu_to_le64(val));
> -	arm_smmu_sync_cd(master, ssid, true);
> +	cdptr->data[0] = cpu_to_le64(val);
> +	arm_smmu_write_cd_entry(master, ssid, cd_table_entry, &target);
>   	return 0;
>   }

> --
> 2.43.2

Reviewed-by: Moritz Fischer <moritzf@google.com>
