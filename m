Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621D32E3FE
	for <patches@lists.linux.dev>; Fri, 19 Apr 2024 21:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713561067; cv=none; b=RsAHSjCb/eI0T0o/iI9dqlQpA8XmEeOFSIBTXZqIUxx4Vi4/R0JXguUE4aWzbt5arCY1CfaeqD1XtHtN1nEuQONRNdPpANcUiy3TQeUAu0HPSfg3HjBdLM/zG7ElHVq511YrgIdrohqk54tkB/iOJfMNo3MO1EoV5bNpgmqL9h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713561067; c=relaxed/simple;
	bh=NSlrkOkTpC4JnHTM0oENr4Wh4NeJ35k+7dw6tsmFtz8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KpjFoHHmqtqznoiLABGJVuKsGK3XNtfNfiEb2X2e48hk81aito5VK0MxAUdhg+uClDvDQoIC+MCBAG+wYKu0i4k6BEe85ZLpjygl02/NDGHynsRCIW6AepeEDSU/5idjyqF9c2OzedEx0nyJhRlmINoPFoeRWUgxu0M99iVQABo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KxAKiKJ/; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KxAKiKJ/"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-418820e6effso19905e9.0
        for <patches@lists.linux.dev>; Fri, 19 Apr 2024 14:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713561064; x=1714165864; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=muVfYTgU0Sb3En88/8APVa67zDZWDeKTlkssyrLVhuI=;
        b=KxAKiKJ/ypFXaRqzpDeZz0UBYfIIwD3zFTZfjys6ANz60SgO0wbxj44/oiFtsOx/2B
         R7TL7DoyUz0HF07OgEAda7ax6hQ2M8RBWBS8l/bybArOHnKTf0XAUbaMd7sOOyN1fPPs
         tVzGQYV4B6TgIAa0S2C1ObFectnAaxpwPQPGYM+VrDsDbuYxlsJYK0p1LYm6XM3PzD7/
         CAXqqpBFwtJHjvi/nvHtevHMjR0qvpeDZOxhmFPcCYK+p1B8yqONlAP2tmMHn7NogaKw
         aI0ZQgpfqCQTYSwH2HhRmtyXQXcjjXAS1NSwSpilr48EYMyydoYV0uJ3UQ8LbXUej1rk
         OH+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713561064; x=1714165864;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=muVfYTgU0Sb3En88/8APVa67zDZWDeKTlkssyrLVhuI=;
        b=UY1fLNZ2XsIbA4A1oy5qC8HYx610qzRm+Y3k4cNBPYWY321MJzm2JJ+9ZWDFsQDzFF
         5awvzWTcC/Nu6cwGDLAd082AhxKwGoCgvO9RoAYoSjHg3tkG9um0fbB44CPIpDjWzZLu
         SKrqz+qZtHdm3FeHyMVvcKITzABU4an/GvOoDhdK0Jg9bCEa8KnvRKykfqGfhSuzbRkP
         SEbAGshgsc+WGIcGGtKIl//aGCkFPwNi3Uc5guzOxkhnGfccuO+XL0lCJbMT7Gou3urV
         zsQChxMuoGnzcftyawB3RbNuL54jsW8wppsyFbUBCwGZexkduUbvRP5l93VJ645oWudW
         EipQ==
X-Forwarded-Encrypted: i=1; AJvYcCVs3w6n33QJHvvVTbzADmWyBgYAYjUXszYikKLUMWw8ymD6RPqxPpzeR++nv/cBnFaSyBy/DJ7s4gTOIMjwTay5BFR7b+QTeg==
X-Gm-Message-State: AOJu0YyiZ7sQRhu7FduxOo7UjKDc8/HwonoOGKR9K8kDrO6XjO1CGgWt
	AyzaWQcBGV8r6T0vxr5RtvDZBdEHh/7t2MdTmE7utLWMuzlHzYkG8PieP3PiIw==
X-Google-Smtp-Source: AGHT+IERf468JLwiAC3I/ZFFYHTRL5+C4AlboWBc2jyXnfqoPhcptH/P0ivOf85y6pBJ9T+dzHdhUQ==
X-Received: by 2002:a05:600c:1d22:b0:419:c4f:cfce with SMTP id l34-20020a05600c1d2200b004190c4fcfcemr49777wms.4.1713561063564;
        Fri, 19 Apr 2024 14:11:03 -0700 (PDT)
Received: from google.com (180.232.140.34.bc.googleusercontent.com. [34.140.232.180])
        by smtp.gmail.com with ESMTPSA id a12-20020a056000188c00b00347eb354b30sm5444463wri.84.2024.04.19.14.11.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 14:11:03 -0700 (PDT)
Date: Fri, 19 Apr 2024 21:10:59 +0000
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
Subject: Re: [PATCH v7 3/9] iommu/arm-smmu-v3: Move the CD generation for S1
 domains into a function
Message-ID: <ZiLd45atbrZ6hBtL@google.com>
References: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <3-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>

Hi Jason,

On Tue, Apr 16, 2024 at 04:28:14PM -0300, Jason Gunthorpe wrote:
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
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Reviewed-by: Michael Shavit <mshavit@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 25 +++++++-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 60 +++++++++++++------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  9 +++
>  3 files changed, 76 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index 41b44baef15e80..d159f60480935e 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -53,6 +53,29 @@ static void arm_smmu_update_ctx_desc_devices(struct arm_smmu_domain *smmu_domain
>  	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
>  }
>  
> +static void
> +arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)

nit: shouldn’t that be arm_smmu_update_sva_domain_cd_entry?
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
> +			continue;
> +
> +		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
> +		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
> +					&target_cd);

Case ARM_SMMU_DOMAIN_S1 has the some code:
  arm_smmu_get_cd_pter => arm_smmu_make_s1_cd => arm_smmu_write_cd_entry
I’d prefer if that was abstracted with the SMMUv3 driver and it provides a higher
level API rather than exposing these low-level functions in the header file.
But no strong opinion.

> +	}
> +	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
> +}
> +
>  /*
>   * Check if the CPU ASID is available on the SMMU side. If a private context
>   * descriptor is using it, try to replace it.
> @@ -96,7 +119,7 @@ arm_smmu_share_asid(struct mm_struct *mm, u16 asid)
>  	 * be some overlap between use of both ASIDs, until we invalidate the
>  	 * TLB.
>  	 */
> -	arm_smmu_update_ctx_desc_devices(smmu_domain, IOMMU_NO_PASID, cd);
> +	arm_smmu_update_s1_domain_cd_entry(smmu_domain);
>  
>  	/* Invalidate TLB entries previously associated with that context */
>  	arm_smmu_tlb_inv_asid(smmu, asid);
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 3983de90c2fa01..d24fa13a52b4e0 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1204,8 +1204,8 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
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
> @@ -1268,9 +1268,9 @@ static const struct arm_smmu_entry_writer_ops arm_smmu_cd_writer_ops = {
>  	.v_bit = cpu_to_le64(CTXDESC_CD_0_V),
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
> @@ -1283,6 +1283,32 @@ static void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
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

IMO, patches to handle CD = NULL and quiet CD should be introduced first so it is
easier to follow as now there is duplicate code in arm_smmu_write_ctx_desc() which
is dead and makes it a little harder to review, but if reordered,
arm_smmu_write_ctx_desc() can be removed in this patch so we can see how code moved.

Otherwise:
Reviewed-by: Mostafa Saleh <smostafa@google.com>

Thanks,
Mostafa
>  static void arm_smmu_clean_cd_entry(struct arm_smmu_cd *target)
>  {
>  	struct arm_smmu_cd used = {};
> @@ -2644,29 +2670,29 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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
> index 4b767e0eeeb682..bb08f087ba39e4 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -751,6 +751,15 @@ extern struct xarray arm_smmu_asid_xa;
>  extern struct mutex arm_smmu_asid_lock;
>  extern struct arm_smmu_ctx_desc quiet_cd;
>  
> +struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
> +					u32 ssid);
> +void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
> +			 struct arm_smmu_master *master,
> +			 struct arm_smmu_domain *smmu_domain);
> +void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
> +			     struct arm_smmu_cd *cdptr,
> +			     const struct arm_smmu_cd *target);
> +
>  int arm_smmu_write_ctx_desc(struct arm_smmu_master *smmu_master, int ssid,
>  			    struct arm_smmu_ctx_desc *cd);
>  void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
> -- 
> 2.43.2
> 
