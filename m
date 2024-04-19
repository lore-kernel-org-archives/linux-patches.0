Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBC12A1D8
	for <patches@lists.linux.dev>; Fri, 19 Apr 2024 21:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713561268; cv=none; b=lptyBYPkymNde9GaL458oGSzcZ1c0XxvrJ8zNa/i8fRN3oTg3+aCS67B+45QkBj/73pBzPz2+Dk9KMzjIh2a+HBuoj8cGZWGcGHN5Mrdl2SB5qJXnnVSPbHMXgS0A9ARXcVn98aYXTZekmmUwbIEoRM52AZUnYR29xWwBJ1uy/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713561268; c=relaxed/simple;
	bh=ei3WV3eKZApVvjnxFDD/9l86kQvXZQuBIlUUHzX/AZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qGe1I7HLwPGNkRVGMkcMOefLgrqE+FUEFqjDkIMV1K1QUE3w3WB14Rd0RgOk+uLBGdC7r8459JwIVHzGQg8k8JwRrwtGj0b9Z+lvTBkF6J3gDFCUHnr5igW51JdgcCDeVhmkDuZetaPg4m07R5Uwp2SKX+7oZe8RBr3LCwJMzGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u1kWXPS1; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u1kWXPS1"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-418dc2724bbso6015e9.1
        for <patches@lists.linux.dev>; Fri, 19 Apr 2024 14:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713561265; x=1714166065; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NBshQTXstt+sMGqJKp0WLRunXAoergcq+aJYNYcSuag=;
        b=u1kWXPS138E91R5F+D71rDKLNaUN7wJKZ3u1SS6nsH2vdkTUft+mMgj8XEo3YUXmJ6
         I5Q/Svckq4LS1Cq/jD1qMv6ZOqAewjSsCP+mNvnrj94TYBLJSOkjoq47nsrr/h3OVklL
         Mj+kHuFPfaIO9V9s5OF7eEWKQooeer8xeqVc98CrzVj7qR8cFNEZOtsAEgrpnAFKIWA1
         CFhMGR+y8ydkOZiyGjG6SkR7eFHwZR9qQEwy6ccRUdHAzZYhMsTqXe5CuSIgRN7IMD3Q
         YFbje3AWmAJuxZ49DWeFyAzK/9AvFNa5ayKu2mqMju9LAerVhFSYiQONNgJLu9G/YJaX
         6PYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713561265; x=1714166065;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NBshQTXstt+sMGqJKp0WLRunXAoergcq+aJYNYcSuag=;
        b=Upd+fULCx6bvQmmzA2lr3RnMV1k45F9hZz3V0n0KK0cuk/zUY2ERKGSHoqFdXj4uR5
         Y+tsl4aoXn/LszFE8vYfWirSk/iPI/7HEVMHDGNNxvRrNyrqJSaNtE8Njyx8Hu63IB0Q
         +D92zsdE5t6yDq2u7bXFyxVpmpXY/WafIGDguByNFcBl9UKygseKDiYUeZUtPnextPoX
         wHSfQprAQdDY51JeNXCaoQ5ojR3qnZ5eAfBac4A67kSLRb7Hte7nOuAb7z4Mfu2Fv8ea
         ZhvQpzzIHs/gRLwFwTHI8HgIqnBSit+ly57eH1TmkrOBaFav0Li1At1R+DxiNXkAX+PK
         tOrQ==
X-Forwarded-Encrypted: i=1; AJvYcCV8ovUhNls3PtBFxU+gCVHapN1zMXr+BjhS/1L/+5ATWu3BOubQKu68QQCjhpKNOuOrYIbVNCCX/qn3fogvZtXfI8dyMTsPlA==
X-Gm-Message-State: AOJu0Yzzat5N8jVHknDFv4GxnH4LiM1Nam9sQ0s/5EM15en5JreJoidB
	5RlPFamQykAXRVsLhgconZaSNtv+nPSwfPL7zqreVt8MHCiMsjC7G1Ni6SGPUg==
X-Google-Smtp-Source: AGHT+IFLigvap1IyJFZX6L4BzxYOOZ93Cld6hXcotWfnlKp+57JZRX+1O7JEsAQnzJVywfRXaFaiAg==
X-Received: by 2002:a05:600c:4f87:b0:418:39a2:3820 with SMTP id n7-20020a05600c4f8700b0041839a23820mr11030wmq.5.1713561265188;
        Fri, 19 Apr 2024 14:14:25 -0700 (PDT)
Received: from google.com (180.232.140.34.bc.googleusercontent.com. [34.140.232.180])
        by smtp.gmail.com with ESMTPSA id o8-20020adfcf08000000b00345c2f84d5asm5304082wrj.10.2024.04.19.14.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 14:14:24 -0700 (PDT)
Date: Fri, 19 Apr 2024 21:14:21 +0000
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
Subject: Re: [PATCH v7 5/9] iommu/arm-smmu-v3: Make arm_smmu_alloc_cd_ptr()
Message-ID: <ZiLerRK1pXvt-HML@google.com>
References: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <5-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>

Hi Jason,

On Tue, Apr 16, 2024 at 04:28:16PM -0300, Jason Gunthorpe wrote:
> Only the attach callers can perform an allocation for the CD table entry,
> the other callers must not do so, they do not have the correct locking and
> they cannot sleep. Split up the functions so this is clear.
> 
> arm_smmu_get_cd_ptr() will return pointer to a CD table entry without
> doing any kind of allocation.
> 
> arm_smmu_alloc_cd_ptr() will allocate the table and any required
> leaf.
> 
> A following patch will add lockdep assertions to arm_smmu_alloc_cd_ptr()
> once the restructuring is completed and arm_smmu_alloc_cd_ptr() is never
> called in the wrong context.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 61 +++++++++++++--------
>  1 file changed, 39 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index f3df1ec8d258dc..a0d1237272936f 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -98,6 +98,7 @@ static struct arm_smmu_option_prop arm_smmu_options[] = {
>  
>  static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
>  				    struct arm_smmu_device *smmu);
> +static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master);
>  
>  static void parse_driver_options(struct arm_smmu_device *smmu)
>  {
> @@ -1207,29 +1208,51 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
>  struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
>  					u32 ssid)
>  {
> -	__le64 *l1ptr;
> -	unsigned int idx;
>  	struct arm_smmu_l1_ctx_desc *l1_desc;
> -	struct arm_smmu_device *smmu = master->smmu;
>  	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
>  
> +	if (!cd_table->cdtab)
> +		return NULL;
> +
>  	if (cd_table->s1fmt == STRTAB_STE_0_S1FMT_LINEAR)
>  		return (struct arm_smmu_cd *)(cd_table->cdtab +
>  					      ssid * CTXDESC_CD_DWORDS);
>  
> -	idx = ssid >> CTXDESC_SPLIT;
> -	l1_desc = &cd_table->l1_desc[idx];
> -	if (!l1_desc->l2ptr) {
> -		if (arm_smmu_alloc_cd_leaf_table(smmu, l1_desc))
> -			return NULL;
> +	l1_desc = &cd_table->l1_desc[ssid / CTXDESC_L2_ENTRIES];

These operations used to be shift and bit masking which made sense as it does
what hardware does, is there any reason you changed it to division and modulo?
I checked the disassembly and gcc does the right thing as constants are power
of 2, but I am just curious.

> +	if (!l1_desc->l2ptr)
> +		return NULL;
> +	return &l1_desc->l2ptr[ssid % CTXDESC_L2_ENTRIES];
> +}
>  
> -		l1ptr = cd_table->cdtab + idx * CTXDESC_L1_DESC_DWORDS;
> -		arm_smmu_write_cd_l1_desc(l1ptr, l1_desc);
> -		/* An invalid L1CD can be cached */
> -		arm_smmu_sync_cd(master, ssid, false);
> +static struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
> +						 u32 ssid)
> +{
> +	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
> +	struct arm_smmu_device *smmu = master->smmu;
> +
> +	if (!cd_table->cdtab) {
> +		if (arm_smmu_alloc_cd_tables(master))
> +			return NULL;
>  	}
> -	idx = ssid & (CTXDESC_L2_ENTRIES - 1);
> -	return &l1_desc->l2ptr[idx];
> +
> +	if (cd_table->s1fmt == STRTAB_STE_0_S1FMT_64K_L2) {
> +		unsigned int idx = ssid >> CTXDESC_SPLIT;

Ok, now it’s a shift, I think we should be consistent with how we
calculate the index.

> +		struct arm_smmu_l1_ctx_desc *l1_desc;
> +
> +		l1_desc = &cd_table->l1_desc[idx];
> +		if (!l1_desc->l2ptr) {
> +			__le64 *l1ptr;
> +
> +			if (arm_smmu_alloc_cd_leaf_table(smmu, l1_desc))
> +				return NULL;
> +
> +			l1ptr = cd_table->cdtab + idx * CTXDESC_L1_DESC_DWORDS;
> +			arm_smmu_write_cd_l1_desc(l1ptr, l1_desc);
> +			/* An invalid L1CD can be cached */
> +			arm_smmu_sync_cd(master, ssid, false);
> +		}
> +	}
> +	return arm_smmu_get_cd_ptr(master, ssid);
>  }
>  
>  struct arm_smmu_cd_writer {
> @@ -1357,7 +1380,7 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
>  	if (WARN_ON(ssid >= (1 << cd_table->s1cdmax)))
>  		return -E2BIG;
>  
> -	cd_table_entry = arm_smmu_get_cd_ptr(master, ssid);
> +	cd_table_entry = arm_smmu_alloc_cd_ptr(master, ssid);

The only path allocates the main table is “arm_smmu_attach_dev”, I guess
it would be more robust to leave that as is and have 2 versions of get_cd,
one that allocates leaf and one that is not allocating, what do you think?

Thanks,
Mostafa



>  	if (!cd_table_entry)
>  		return -ENOMEM;
>  
> @@ -2687,13 +2710,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
>  		struct arm_smmu_cd target_cd;
>  		struct arm_smmu_cd *cdptr;
>  
> -		if (!master->cd_table.cdtab) {
> -			ret = arm_smmu_alloc_cd_tables(master);
> -			if (ret)
> -				goto out_list_del;
> -		}
> -
> -		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
> +		cdptr = arm_smmu_alloc_cd_ptr(master, IOMMU_NO_PASID);
>  		if (!cdptr) {
>  			ret = -ENOMEM;
>  			goto out_list_del;
> -- 
> 2.43.2
> 
