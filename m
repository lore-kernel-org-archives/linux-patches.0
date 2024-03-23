Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CBB17583
	for <patches@lists.linux.dev>; Sat, 23 Mar 2024 13:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711198944; cv=none; b=lz7IcJnWd+5Ic+tCDSXwyHrlvXeqk2dyFWZTBqvLX41/QdqKRnb+HCHs9NfB9oYo6fh7TXnQbS2excHmbKaO5q77wnCico+LDeaRtj2NF2lJPisIBamAvpMlZZSo6CWssdoFo0wUgk2Vfb07NEG/bb37S+By6ASPEbQZ47CwwTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711198944; c=relaxed/simple;
	bh=yhSJSa+l5sGdIOQS1zMd22jfMweaR89eagF4hZzlsjE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SPMYNhG/kgI1UosGBIW5smQKcYHCxl7L0f6H60kMPKqpDIOhm7iGyKcIRjCSQJjGAs3x3P4j5eCxSEg4x1K3Jt98slSLNikzAej4tTJ19QBXkgqae3xchs6pF5Lb/nKPsyKEENmj0jh3f/cokQKN4eADj08LtPf8rsOcLBlarP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fkb9+MPR; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fkb9+MPR"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4146f72e2dfso31675e9.1
        for <patches@lists.linux.dev>; Sat, 23 Mar 2024 06:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711198941; x=1711803741; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hvl4/xyhpiQHpmeH9aZe5LZQjdUEZetkXlppQA7Bt5w=;
        b=fkb9+MPRMfkAMXS2VuohY1XMW8E3CTGQ4dTHGIM1lRUD0CtU5fL6LHnfN3QwffDb8i
         9C5feIFEMdXlWKYQfLsO8F7yaxAq9D0bkGkRA7fm2jgwBr8s+/FkAmC1GOriP0yOKg6M
         PFL+3/KYzCdBSh0fnHb+/GmhC2aC1HmphSNQBV3O5amRzQzaOw4OtpSD+SoPpkGvgayE
         OeSIiNC9wHCdrHYOn98J4Ge/tyjXoPDtTWbJp1Ih1nmct6o04ndSGK9W4cfqeVZfbhwS
         +uB5AgQLuH/rO1j9XLsIpYSV3y8qnLAmefN/1bewf8kcsL4Bo3TiaZhXPnQcPloTGeGW
         4bjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711198941; x=1711803741;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hvl4/xyhpiQHpmeH9aZe5LZQjdUEZetkXlppQA7Bt5w=;
        b=dNd5LxbyeTt9ck+bSjdtoNdiC0AHEqRh0nclBn1PST8e28wAz5IkgdMvSQ7LX/sxvB
         8+mfUzK5oWIqXzOnwNcfYCJVc0vazDSa6JIzQBr/YDWDxucK9RzabY4LMIH/roli943f
         +MaeFEA/KqHTMhKoZ0Lf7hS8U8/2S3T9FhfpxHaOhI5TtA4GZTRFQRj1TJRQVEd/5RwP
         X8zdssKRz9s9CoHebCvbapOBPthAtQAq9Rsfr+rytMWlVNgtSEJ2mS2LOMpy1i4f868o
         9BQsjETmIMgJwOYEMsBKydU/Yy15RlSd7vBbPtlbbv4goizXPZ6M9nE+0JD35+o2fmLf
         G12A==
X-Forwarded-Encrypted: i=1; AJvYcCWHrJaTspcyPh/VC9VOZEYWcbVcQRdcnCJEJPkIGTht4SuinvsV2zTqOScE27PDfuTgd43I7vUEyBU6mR78QHPwstR/mMbmSg==
X-Gm-Message-State: AOJu0YwXqVHXwpDzx7rERRvLjSZRszaBSxItbfkWzxqyCjuZgm6j0cW4
	RtfoAy7WrwRvSgVBTjN/6U0GPbChfGtWoPnYor+r99bmVdUW7reE1NyUL/pZlA==
X-Google-Smtp-Source: AGHT+IE3Xkyv9/y2RDuJl7s5lZPBQuPAH71EguVlCnF5KZJEfnTvJ7ERFGfBbQLEC/1xKKUgPcI02Q==
X-Received: by 2002:a05:600c:63c5:b0:414:800f:f9b1 with SMTP id dx5-20020a05600c63c500b00414800ff9b1mr142960wmb.2.1711198940878;
        Sat, 23 Mar 2024 06:02:20 -0700 (PDT)
Received: from google.com (180.232.140.34.bc.googleusercontent.com. [34.140.232.180])
        by smtp.gmail.com with ESMTPSA id s8-20020a05600c384800b00414809efc6esm1860782wmr.8.2024.03.23.06.02.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Mar 2024 06:02:19 -0700 (PDT)
Date: Sat, 23 Mar 2024 13:02:15 +0000
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
Subject: Re: [PATCH v5 05/27] iommu/arm-smmu-v3: Make CD programming use
 arm_smmu_write_entry()
Message-ID: <Zf7S109OKJlRVXiR@google.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <5-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>

Hi Jason,

On Mon, Mar 04, 2024 at 07:43:53PM -0400, Jason Gunthorpe wrote:
> CD table entries and STE's have the same essential programming sequence,
> just with different types and sizes.
> 
> Have arm_smmu_write_ctx_desc() generate a target CD and call
> arm_smmu_write_entry() to do the programming. Due to the way the
> target CD is generated by modifying the existing CD this alone is not
> enough for the CD callers to be freed of the ordering requirements.
> 
> The following patches will make the rest of the CD flow mirror the STE
> flow with precise CD contents generated in all cases.
> 
> Currently the logic can't ensure that the CD always conforms to the used
> requirements until all the CD generation is moved to the new method. Add a
> temporary no_used_check to disable the assertions.
> 

I am still going through the patches, but is it possible to
reorder/squash to avoid that, so it is easier to review?

> Signed-off-by: Michael Shavit <mshavit@google.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 101 ++++++++++++++------
>  1 file changed, 74 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index b7f947e36f596f..237fd6d92c880b 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -57,11 +57,14 @@ struct arm_smmu_entry_writer {
>  struct arm_smmu_entry_writer_ops {
>  	unsigned int num_entry_qwords;
>  	__le64 v_bit;
> +	bool no_used_check;
>  	void (*get_used)(const __le64 *entry, __le64 *used);
>  	void (*sync)(struct arm_smmu_entry_writer *writer);
>  };
>  
> -#define NUM_ENTRY_QWORDS (sizeof(struct arm_smmu_ste) / sizeof(u64))
> +#define NUM_ENTRY_QWORDS                                                \
> +	(max(sizeof(struct arm_smmu_ste), sizeof(struct arm_smmu_cd)) / \
> +	 sizeof(u64))
>  
>  static phys_addr_t arm_smmu_msi_cfg[ARM_SMMU_MAX_MSIS][3] = {
>  	[EVTQ_MSI_INDEX] = {
> @@ -1056,7 +1059,8 @@ static u8 arm_smmu_entry_qword_diff(struct arm_smmu_entry_writer *writer,
>  		 * allowed to set a bit to 1 if the used function doesn't say it
>  		 * is used.
>  		 */
> -		WARN_ON_ONCE(target[i] & ~target_used[i]);
> +		if (!writer->ops->no_used_check)
> +			WARN_ON_ONCE(target[i] & ~target_used[i]);
>  
>  		/* Bits can change because they are not currently being used */
>  		unused_update[i] = (entry[i] & cur_used[i]) |
> @@ -1065,7 +1069,8 @@ static u8 arm_smmu_entry_qword_diff(struct arm_smmu_entry_writer *writer,
>  		 * Each bit indicates that a used bit in a qword needs to be
>  		 * changed after unused_update is applied.
>  		 */
> -		if ((unused_update[i] & target_used[i]) != target[i])
> +		if ((unused_update[i] & target_used[i]) !=
> +		    (target[i] & target_used[i]))
>  			used_qword_diff |= 1 << i;
>  	}
>  	return used_qword_diff;
> @@ -1161,8 +1166,11 @@ static void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer,
>  		 * in the entry. The target was already sanity checked by
>  		 * compute_qword_diff().
>  		 */
> -		WARN_ON_ONCE(
> -			entry_set(writer, entry, target, 0, num_entry_qwords));
> +		if (writer->ops->no_used_check)
> +			entry_set(writer, entry, target, 0, num_entry_qwords);
> +		else
> +			WARN_ON_ONCE(entry_set(writer, entry, target, 0,
> +					       num_entry_qwords));
>  	}
>  }
>  
> @@ -1242,6 +1250,59 @@ static struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
>  	return &l1_desc->l2ptr[idx];
>  }
>  
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

This is a slightly different approach than what the driver does for STEs,
where it explicitly sets the used bits. Is there a reason for that?

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

We should add a comment about EPD1 maybe?
> +
> +static void arm_smmu_cd_writer_sync_entry(struct arm_smmu_entry_writer *writer)
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
> +static void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
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
>  int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
>  			    struct arm_smmu_ctx_desc *cd)
>  {
> @@ -1258,17 +1319,20 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
>  	 */
>  	u64 val;
>  	bool cd_live;
> -	struct arm_smmu_cd *cdptr;
> +	struct arm_smmu_cd target;
> +	struct arm_smmu_cd *cdptr = &target;
> +	struct arm_smmu_cd *cd_table_entry;
>  	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
>  	struct arm_smmu_device *smmu = master->smmu;
>  
>  	if (WARN_ON(ssid >= (1 << cd_table->s1cdmax)))
>  		return -E2BIG;
>  
> -	cdptr = arm_smmu_get_cd_ptr(master, ssid);
> -	if (!cdptr)
> +	cd_table_entry = arm_smmu_get_cd_ptr(master, ssid);
> +	if (!cd_table_entry)
>  		return -ENOMEM;
>  
> +	target = *cd_table_entry;
>  	val = le64_to_cpu(cdptr->data[0]);
>  	cd_live = !!(val & CTXDESC_CD_0_V);
>  
> @@ -1290,13 +1354,6 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
>  		cdptr->data[2] = 0;
>  		cdptr->data[3] = cpu_to_le64(cd->mair);
>  
> -		/*
> -		 * STE may be live, and the SMMU might read dwords of this CD in any
> -		 * order. Ensure that it observes valid values before reading
> -		 * V=1.
> -		 */
> -		arm_smmu_sync_cd(master, ssid, true);
> -
>  		val = cd->tcr |
>  #ifdef __BIG_ENDIAN
>  			CTXDESC_CD_0_ENDI |
> @@ -1310,18 +1367,8 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
>  		if (cd_table->stall_enabled)
>  			val |= CTXDESC_CD_0_S;
>	}
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
>  	return 0;
>  }
>  
> -- 
> 2.43.2 

Thanks,
Mostafa
