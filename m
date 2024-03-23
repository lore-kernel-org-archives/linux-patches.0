Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B9D29D11
	for <patches@lists.linux.dev>; Sat, 23 Mar 2024 13:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711199517; cv=none; b=lEBAtWZ5Ex8p7mKRM0TVC1315qdJCb6znxtDtfQkRqRlD2ONSzF7lepUh5UVYgagNKYHzPSUMYouOix/PlOOSpyJmenCdLp1ZRj/dFmIJl0UAZi546qa9bpBU/x31Aa9A+eNiqE18I0bXfhyW2615uuMyf+MqqD6y9hY5qhL4FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711199517; c=relaxed/simple;
	bh=HGSqpIsw/bPLcZWAXsXw3CSzpnplzXtVZJujEZf/X2U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oAXSw1xlJ5lv0sHq0v+KHV25bXGIsMZfNtP53+u5VIAGd2A67pI/ITJuCDombqqb0WnI8fBMZEMCOL0ZmJkE+hfApJT6u1H7PsXU+pZ4pPPStfEIflCa4XWskbOmjiryskzxf2N93ggTYB3fgQP+MiPHJQTwdKCo/rOSt1OscYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GL/dFvSK; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GL/dFvSK"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-413f8c8192eso33235e9.0
        for <patches@lists.linux.dev>; Sat, 23 Mar 2024 06:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711199514; x=1711804314; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BCq+FuYyqrpG+/4PrzLIzFLw4s+IWqn9thILpVxQABI=;
        b=GL/dFvSKHUxB7mqIzBx00RKXV0oCFW5FK1qHSzZL+sX/9sHSDJfst87Pbm8A1etLHY
         CzePcu2XB+6amcd9MlDWacmXCAChujqz2irMa/ifOJzwi5Y2/WTqcnZH/KV0M0ZMA/JM
         APhIND4zg7lhaq/uCsWmhePoPd0eF9AKqrbHHcnu/7e6212wgyt0TvhdejEmaY4Cojcj
         nju/GJdhS87e//OgnzYCGRVN0pMH19Un/zlPpKmfrliCwYoGIxeRCcw6baUDbyVP72NY
         vQuBrTOCSxOtp7ZM2TC+2wcNvw8xlnWGcnWjL+NjU1tA54J+QMLge4W4xpnWTJGEW9I4
         bq/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711199514; x=1711804314;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BCq+FuYyqrpG+/4PrzLIzFLw4s+IWqn9thILpVxQABI=;
        b=IQqGbbphNoMv300sVixWH9LzBrwAkRnV+gBkuimswAApHnisZ1Z6H+FewJ5QjBduAS
         rosicsAfGvYw3QeWsyfZIIAa/bZFw1AoN/tiyfFhraFJvg+ZsINTAObc/94biKEyjZFd
         Jud/Us3DOhB8Q5e1SYu8jx9mnUx5cHotZfeVFW5lA003s2GkOOKYPzi4yzCZXTT678wB
         i3ieVXRgr+Z92LwVX1FaKT/6YNDCpKEHm1MyOg4sJ87rqu6SRuxhUKSYbleZWzli/zjv
         hcN7HUZ2XbCTBxwGC8UdU5FNCa5YBLc5hk+A7E7dIyu3XPUmmj7FJgeVs4jKqkYf+bnJ
         frBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWlbboBefzUdvZvxAnRHnRw+F6PGC4viFXpS5sx+F8NFvl1TlsS6vFZbeL8g20A2kSxDsEZjW3RjiLJtjJdAUbPn9HZHfEJog==
X-Gm-Message-State: AOJu0YzDMofdwi0HHdblzjOtM4NXEO2LBdS/JYTWIW52TpGhimB5dQdU
	Dj2aEs1tUKkYwvWN2Ga2iDpiN32cHaANi/h6xp4Zdc+DoSr6BCHdF2R6qkH/D7389eO2Y8xvQok
	Hww==
X-Google-Smtp-Source: AGHT+IG/ruIuDqS+Haj4kP8NpZcuuEqlRgVLXXoUIfqGUAJplBSozg3VhDf6aJNumV1fu8dkmsVGBA==
X-Received: by 2002:a05:600c:4f47:b0:414:6467:3471 with SMTP id m7-20020a05600c4f4700b0041464673471mr642485wmq.1.1711199513610;
        Sat, 23 Mar 2024 06:11:53 -0700 (PDT)
Received: from google.com (180.232.140.34.bc.googleusercontent.com. [34.140.232.180])
        by smtp.gmail.com with ESMTPSA id j28-20020a05600c1c1c00b004146c769c79sm2492374wms.0.2024.03.23.06.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Mar 2024 06:11:53 -0700 (PDT)
Date: Sat, 23 Mar 2024 13:11:49 +0000
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
Subject: Re: [PATCH v5 07/27] iommu/arm-smmu-v3: Move the CD generation for
 S1 domains into a function
Message-ID: <Zf7VFce6E_8NM2r8@google.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <7-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>

On Mon, Mar 04, 2024 at 07:43:55PM -0400, Jason Gunthorpe wrote:
> Introduce arm_smmu_make_s1_cd() to build the CD from the paging S1 domain,
> and reorganize all the places programming S1 domain CD table entries to
> call it.
> 
> Split arm_smmu_update_s1_domain_cd_entry() from
> arm_smmu_update_ctx_desc_devices() so that the S1 path has its own call
> chain separate from the unrelated SVA path.
> 
> arm_smmu_update_s1_domain_cd_entry() only works on S1 domains
> attached to RIDs and refreshes all their CDs.
> 
> Remove the forced clear of the CD during S1 domain attach,
> arm_smmu_write_cd_entry() will do this automatically if necessary.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 25 +++++++-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 60 +++++++++++++------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  8 +++
>  3 files changed, 75 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index bb9bb6fd7914ce..6acc65f6d00a71 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -54,6 +54,29 @@ static void arm_smmu_update_ctx_desc_devices(struct arm_smmu_domain *smmu_domain
>  	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
>  }
>  
> +static void
> +arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
> +{
> +	struct arm_smmu_master *master;
> +	struct arm_smmu_cd target_cd;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
> +	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
> +		struct arm_smmu_cd *cdptr;
> +
> +		/* S1 domains only support RID attachment right now */
> +		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
> +		if (WARN_ON(!cdptr))

This should never hit, no? Otherwise that means this path can allocate memory
with a spinlock.

> +			continue;
> +
> +		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
> +		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
> +					&target_cd);
> +	}
> +	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
> +}
> +
>  /*
>   * Check if the CPU ASID is available on the SMMU side. If a private context
>   * descriptor is using it, try to replace it.
> @@ -97,7 +120,7 @@ arm_smmu_share_asid(struct mm_struct *mm, u16 asid)
>  	 * be some overlap between use of both ASIDs, until we invalidate the
>  	 * TLB.
>  	 */
> -	arm_smmu_update_ctx_desc_devices(smmu_domain, IOMMU_NO_PASID, cd);
> +	arm_smmu_update_s1_domain_cd_entry(smmu_domain);
>  
>  	/* Invalidate TLB entries previously associated with that context */
>  	arm_smmu_tlb_inv_asid(smmu, asid);
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 3fb4a1523d1d3f..e25dbb982feeee 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1222,8 +1222,8 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
>  	WRITE_ONCE(*dst, cpu_to_le64(val));
>  }
>  
> -static struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
> -					       u32 ssid)
> +struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
> +					u32 ssid)
>  {
>  	__le64 *l1ptr;
>  	unsigned int idx;
> @@ -1288,9 +1288,9 @@ static const struct arm_smmu_entry_writer_ops arm_smmu_cd_writer_ops = {
>  	.num_entry_qwords = sizeof(struct arm_smmu_cd) / sizeof(u64),
>  };
>  
> -static void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
> -				    struct arm_smmu_cd *cdptr,
> -				    const struct arm_smmu_cd *target)
> +void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
> +			     struct arm_smmu_cd *cdptr,
> +			     const struct arm_smmu_cd *target)
>  {
>  	struct arm_smmu_cd_writer cd_writer = {
>  		.writer = {
> @@ -1303,6 +1303,32 @@ static void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
>  	arm_smmu_write_entry(&cd_writer.writer, cdptr->data, target->data);
>  }
>  
> +void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
> +			 struct arm_smmu_master *master,
> +			 struct arm_smmu_domain *smmu_domain)
> +{
> +	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
> +
> +	memset(target, 0, sizeof(*target));
> +
> +	target->data[0] = cpu_to_le64(
> +		cd->tcr |
> +#ifdef __BIG_ENDIAN
> +		CTXDESC_CD_0_ENDI |
> +#endif
> +		CTXDESC_CD_0_V |
> +		CTXDESC_CD_0_AA64 |
> +		(master->stall_enabled ? CTXDESC_CD_0_S : 0) |
> +		CTXDESC_CD_0_R |
> +		CTXDESC_CD_0_A |
> +		CTXDESC_CD_0_ASET |
> +		FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid)
> +		);
> +
> +	target->data[1] = cpu_to_le64(cd->ttbr & CTXDESC_CD_1_TTB0_MASK);
> +	target->data[3] = cpu_to_le64(cd->mair);
> +}
> +

That seems to duplicate some logic from arm_smmu_write_ctx_desc(),
can that be consolidated?

>  void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid)
>  {
>  	struct arm_smmu_cd target = {};
> @@ -2689,29 +2715,29 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
>  	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
>  
>  	switch (smmu_domain->stage) {
> -	case ARM_SMMU_DOMAIN_S1:
> +	case ARM_SMMU_DOMAIN_S1: {
> +		struct arm_smmu_cd target_cd;
> +		struct arm_smmu_cd *cdptr;
> +
>  		if (!master->cd_table.cdtab) {
>  			ret = arm_smmu_alloc_cd_tables(master);
>  			if (ret)
>  				goto out_list_del;
> -		} else {
> -			/*
> -			 * arm_smmu_write_ctx_desc() relies on the entry being
> -			 * invalid to work, clear any existing entry.
> -			 */
> -			ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
> -						      NULL);
> -			if (ret)
> -				goto out_list_del;
>  		}
>  
> -		ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, &smmu_domain->cd);
> -		if (ret)
> +		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
> +		if (!cdptr) {
> +			ret = -ENOMEM;
>  			goto out_list_del;
> +		}
>  
> +		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
> +		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
> +					&target_cd);
>  		arm_smmu_make_cdtable_ste(&target, master);
>  		arm_smmu_install_ste_for_dev(master, &target);
>  		break;
> +	}
>  	case ARM_SMMU_DOMAIN_S2:
>  		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
>  		arm_smmu_install_ste_for_dev(master, &target);
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 87a7b57f566fbc..d32da11058aab6 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -750,6 +750,14 @@ extern struct mutex arm_smmu_asid_lock;
>  extern struct arm_smmu_ctx_desc quiet_cd;
>  
>  void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid);
> +struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
> +					u32 ssid);
> +void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
> +			 struct arm_smmu_master *master,
> +			 struct arm_smmu_domain *smmu_domain);
> +void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
> +			     struct arm_smmu_cd *cdptr,
> +			     const struct arm_smmu_cd *target);
>  
>  int arm_smmu_write_ctx_desc(struct arm_smmu_master *smmu_master, int ssid,
>  			    struct arm_smmu_ctx_desc *cd);
> -- 
> 2.43.2
>
Thanks,
Mostafa

