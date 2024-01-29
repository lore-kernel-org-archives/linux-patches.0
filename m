Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930FA44369
	for <patches@lists.linux.dev>; Mon, 29 Jan 2024 19:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706555601; cv=none; b=lAij4fgfM5XHY9AA5c+YAfxmFM/2HFMrScIAdQXKqxLoWRnPtSduWXziwqBk0oU/AhynwpDZeoFOr0Jt91CJMvyeTJRMpkS38MX63UPpEZLrMrd7McuFOV9Y2rpY7DfpGjVBo/hVwrY55/WJf0+PveiwCZlMMwi0unmZIgL7EGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706555601; c=relaxed/simple;
	bh=k+rFaP2hx6Dhtbm5NmnswHdaELq6UccwTB1MNQilwlo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LncKq538kN/J4QWSgjRxxY2cJxk9Ql2V1TcK+H1pmsG1aN8YVsJ137xDTy+iS4+1iMBY0tSnYmXskZt6mGOVSPEvKovw+MGUG6njxLf9QdzIHDRgYAV8Qc5FJlVfg0kOfhKmr/qlGQ9t/0NAvqn1ZdyMtuxMik4C7cKmzhhcBGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R2cjUdKe; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R2cjUdKe"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-40ef9382752so9115e9.0
        for <patches@lists.linux.dev>; Mon, 29 Jan 2024 11:13:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706555598; x=1707160398; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8BI/hrl4gqaMRwJZbaZdSazD5aJZfh2xP9rdDosVdXM=;
        b=R2cjUdKeM0d6p6TSm+UrdzlUMlzpTpIE7k/rWzh4xshERR+jaWADnm1xSbPeTXyAvQ
         mbRVSgqUmrO/gayPmTujFhygm+pSpKMJFtZx0j7uz2Rtd9Ezj++iAd7PXX34gzRD+OfH
         7LKEPy1Zr4nMPKX5diC0eER87/AX/r0zN4Rs9sFM0gy1hylPRaLd0+0UEWuDMf/chV9/
         63s9yBwjyp1nSFk7RzGOR6PM461YxQZg0H4DdE+gvlJR6ZNI6hcHLpAt0VdRDaXI00f4
         OeaJkaRjX3gYYIhbG+proXs8vMnsMEw9+U7pfsB2um51L+Y2Hliv17KURLOlFdoLX8c5
         BrRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706555598; x=1707160398;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8BI/hrl4gqaMRwJZbaZdSazD5aJZfh2xP9rdDosVdXM=;
        b=iAdBttcfvJkuM9va135AY7BP/wAc0owsBTmfvWEE7S4QzRzg25gdGxaL7PM7SySQly
         bsb5v9B6xR+PMiLhEFeA7n6bD0jg+I5SYvFL9UcyMCp0rya7CV0hontJ22iAm6SkHqR1
         hE7/CKuqBduEtkCFO+iQPoPjlJuxy59KON6+l/gbKAJjDjkgMj94Q0V27HBWX9OxgD1T
         vqDI2uUL+qDkRZHaOA6EbcNoTf0BBaY33HKHuLUz+41K4lnWna1JA3Ikynkpx4Y1wreq
         jkGXcXEJK/Z7rSJKqdsrq/6uTnJOZ+EFbqR/Hm6Hl+pkv8d/kNuV3u+JNGaXw6ovPif+
         uHJw==
X-Gm-Message-State: AOJu0YzGVwvj4S+yEmduSMPrs7POWK4jLTZ5sG3Yq1MnHNYH6XJHESgN
	fTG/F/RiZm/IjswDoRphWtT+GhD7Uvt45368AFTaaK2jKc4RvLyJ1Og+AZJWAZRrBsAsnd8mx1c
	IXg==
X-Google-Smtp-Source: AGHT+IH+hlBD7FN2bCsw/rzLuOPSHSMxINUDaY8nxAT10J4O4msNXPrRQpqMAB1wNW9m55yczjCuDA==
X-Received: by 2002:a05:600c:6020:b0:40e:5274:e2ba with SMTP id az32-20020a05600c602000b0040e5274e2bamr17162wmb.4.1706555597705;
        Mon, 29 Jan 2024 11:13:17 -0800 (PST)
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id i3-20020a05600c354300b0040efcec0a6asm477834wmq.42.2024.01.29.11.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jan 2024 11:13:17 -0800 (PST)
Date: Mon, 29 Jan 2024 19:13:13 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v3 00/19] Update SMMUv3 to the modern iommu API (part 1/3)
Message-ID: <Zbf4ySDT0bAMXXwO@google.com>
References: <0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>

Hi Jason,

On Tue, Dec 05, 2023 at 03:14:32PM -0400, Jason Gunthorpe wrote:
> The SMMUv3 driver was originally written in 2015 when the iommu driver
> facing API looked quite different. The API has evolved, especially lately,
> and the driver has fallen behind.
> 
> This work aims to bring make the SMMUv3 driver the best IOMMU driver with
> the most comprehensive implementation of the API. After all parts it
> addresses:
> 
>  - Global static BLOCKED and IDENTITY domains with 'never fail' attach
>    semantics. BLOCKED is desired for efficient VFIO.
> 
>  - Support map before attach for PAGING iommu_domains.
> 
>  - attach_dev failure does not change the HW configuration.
> 
>  - Fully hitless transitions between IDENTITY -> DMA -> IDENTITY.
>    The API has IOMMU_RESV_DIRECT which is expected to be
>    continuously translating.
> 
>  - Safe transitions between PAGING -> BLOCKED, do not ever temporarily
>    do IDENTITY. This is required for iommufd security.
> 
>  - Full PASID API support including:
>     - S1/SVA domains attached to PASIDs
>     - IDENTITY/BLOCKED/S1 attached to RID
>     - Change of the RID domain while PASIDs are attached
> 
>  - Streamlined SVA support using the core infrastructure
> 
>  - Hitless, whenever possible, change between two domains
> 
>  - iommufd IOMMU_GET_HW_INFO, IOMMU_HWPT_ALLOC_NEST_PARENT, and
>    IOMMU_DOMAIN_NESTED support
> 
> Over all these things are going to become more accessible to iommufd, and
> exposed to VMs, so it is important for the driver to have a robust
> implementation of the API.
> 
> The work is split into three parts, with this part largely focusing on the
> STE and building up to the BLOCKED & IDENTITY global static domains.
> 
> The second part largely focuses on the CD and builds up to having a common
> PASID infrastructure that SVA and S1 domains equally use.
> 
> The third part has some random cleanups and the iommufd related parts.
> 
> Overall this takes the approach of turning the STE/CD programming upside
> down where the CD/STE value is computed right at a driver callback
> function and then pushed down into programming logic. The programming
> logic hides the details of the required CD/STE tear-less update. This
> makes the CD/STE functions independent of the arm_smmu_domain which makes
> it fairly straightforward to untangle all the different call chains, and
> add news ones.
> 
> Further, this frees the arm_smmu_domain related logic from keeping track
> of what state the STE/CD is currently in so it can carefully sequence the
> correct update. There are many new update pairs that are subtly introduced
> as the work progresses.
> 
> The locking to support BTM via arm_smmu_asid_lock is a bit subtle right
> now and patches throughout this work adjust and tighten this so that it is
> clearer and doesn't get broken.
> 
> Once the lower STE layers no longer need to touch arm_smmu_domain we can
> isolate struct arm_smmu_domain to be only used for PAGING domains, audit
> all the to_smmu_domain() calls to be only in PAGING domain ops, and
> introduce the normal global static BLOCKED/IDENTITY domains using the new
> STE infrastructure. Part 2 will ultimately migrate SVA over to use
> arm_smmu_domain as well.
> 
> All parts are on github:
> 
>  https://github.com/jgunthorpe/linux/commits/smmuv3_newapi
I added some comments/questions for this series, but didn’t review it
thoroughly as I see the code on github is quite different from these patches,
and it seems to be targeted for v4. Do you have any plans to send it soon?

> 
> v3:
>  - Use some local variables in arm_smmu_get_step_for_sid() for clarity
>  - White space and spelling changes
>  - Commit message updates
>  - Keep master->domain_head initialized to avoid a list_del corruption
> v2: https://lore.kernel.org/r/0-v2-de8b10590bf5+400-smmuv3_newapi_p1_jgg@nvidia.com
>  - Rebased on v6.7-rc1
>  - Improve the comment for arm_smmu_write_entry_step()
>  - Fix the botched memcmp
>  - Document the spec justification for the SHCFG exclusion in used
>  - Include STRTAB_STE_1_SHCFG for STRTAB_STE_0_CFG_S2_TRANS in used
>  - WARN_ON for unknown STEs in used
>  - Fix error unwind in arm_smmu_attach_dev()
>  - Whitespace, spelling, and checkpatch related items
> v1: https://lore.kernel.org/r/0-v1-e289ca9121be+2be-smmuv3_newapi_p1_jgg@nvidia.com
> 
> Jason Gunthorpe (19):
>   iommu/arm-smmu-v3: Add a type for the STE
>   iommu/arm-smmu-v3: Master cannot be NULL in
>     arm_smmu_write_strtab_ent()
>   iommu/arm-smmu-v3: Remove ARM_SMMU_DOMAIN_NESTED
>   iommu/arm-smmu-v3: Make STE programming independent of the callers
>   iommu/arm-smmu-v3: Consolidate the STE generation for abort/bypass
>   iommu/arm-smmu-v3: Move arm_smmu_rmr_install_bypass_ste()
>   iommu/arm-smmu-v3: Move the STE generation for S1 and S2 domains into
>     functions
>   iommu/arm-smmu-v3: Build the whole STE in
>     arm_smmu_make_s2_domain_ste()
>   iommu/arm-smmu-v3: Hold arm_smmu_asid_lock during all of attach_dev
>   iommu/arm-smmu-v3: Compute the STE only once for each master
>   iommu/arm-smmu-v3: Do not change the STE twice during
>     arm_smmu_attach_dev()
>   iommu/arm-smmu-v3: Put writing the context descriptor in the right
>     order
>   iommu/arm-smmu-v3: Pass smmu_domain to arm_enable/disable_ats()
>   iommu/arm-smmu-v3: Remove arm_smmu_master->domain
>   iommu/arm-smmu-v3: Add a global static IDENTITY domain
>   iommu/arm-smmu-v3: Add a global static BLOCKED domain
>   iommu/arm-smmu-v3: Use the identity/blocked domain during release
>   iommu/arm-smmu-v3: Pass arm_smmu_domain and arm_smmu_device to
>     finalize
>   iommu/arm-smmu-v3: Convert to domain_alloc_paging()
> 
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 729 +++++++++++++-------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  12 +-
>  2 files changed, 477 insertions(+), 264 deletions(-)
> 
> 
> base-commit: ca7fcaff577c92d85f0e05cc7be79759155fe328
> -- 
> 2.43.0
>
Thanks,
Mostafa
