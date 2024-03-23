Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B09633C5
	for <patches@lists.linux.dev>; Sat, 23 Mar 2024 13:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711201092; cv=none; b=n/C9AJnZRA4oocuIx/ZjydbVNZMp3Z9EQ/Q9obB4mfK1GgtpYXutAfL4ixs3LvECJSAC7OEZhTx1KBKWDspnb+CL4Y3RVQV/CX3aBcS4RiMD98FLxfrxRkAWqMhjqc6NJa+//3zxYtZf+D2kGXNmm0VZqC36rNAeASEh93s7NNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711201092; c=relaxed/simple;
	bh=Jzbk+C2s5wxMp72wmVe/UdYj7O3NNOwtIgGdoLPoaT8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PUMbEi4fpWBHGPfwcZfrpz8IvWBd3Y0viX7IpK+hd8B21pABZAiWyoWrzLvGSeNHxXGqyDIWZJoJWStIswDvERw3fElRc90I1bNBS0ypzkqT4nLSXvAikSWik2nZvDPHJcAcyiC5XrrWdnS9n8kABZJWOdBVJr4rsrNlL/w6naY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZNixfBO+; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZNixfBO+"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4140eed8a4fso31835e9.0
        for <patches@lists.linux.dev>; Sat, 23 Mar 2024 06:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711201089; x=1711805889; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X2lObstm1ERvlU1Nkp+L7+Kxf3ZnfKU4Wltlmi3CA3w=;
        b=ZNixfBO+LRE4sV7miHZZoKvPk+tFzlQaNRbALLEvOWY3i+Wmy/vOJu+Bex+9DLlcYk
         F4gCY9Ly8xtPdZ906LTzMnd3vMMJ4FVHUnw31R9HK6gu02UGX3jELHypu6zzAO2Uxp/E
         caW9REdoDKAYw1dkC22Sp4b9ZDt0xVSFCygwwv4WV9LefPsrGd09DNfrq2HZeYdgh9sF
         3DFoeiIVrJz4LXZgt4huQeVsBOXNgbVKmEAKZ7QYy9iRNZuvoRMALUH7esmJywEugruW
         vJJQ/Xj2QgpuUuD1F+74eFzhvpf6LlQ6pJ8M9mNuTvv6niQKUT3Jf1Yj04W9MKb0KMnZ
         x6SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711201089; x=1711805889;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X2lObstm1ERvlU1Nkp+L7+Kxf3ZnfKU4Wltlmi3CA3w=;
        b=LC1yYCTsD2m+T0cG4UzYhzl1ltjaUgFZwG6v1S7a7HcdstM0kmbcnHQJAwUijflTCH
         EZ5Xpin5Y5K/61qVYT3USsbv0ECag61c6fwUUOPf7yiu3iClUlRnQevjqJ9+WNeRMYlN
         FdsB1pZnovNfIH+a/N9UQSep9ul+2bLRNt7NBxZVoQ+6ocqAN3cwLk2cwpPlovU3GAen
         D38jjUNRaAbOM6fVH0AzCnJhyAp8DNRbjjIkBsjX7rCLMjpalu+jhzFKYZyCtOcRguue
         fBW7LkyUV/G/Tp7iN/CVtEIQJUuFVqIajfQuPLipRMRySsl6dwuW1zdLc0Jui3REmpYE
         S7jQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZTtY0r06+91X7XszO5ZmV/LwW6Rie62OlcFjFqPHbAB3SyVO7XFJXRaV9FMwcVdDUe2taI6tJav2i0vqtUqpLoQVv7iohnQ==
X-Gm-Message-State: AOJu0YxbGagUqMBlhK5o/uBEawpuLxndbL16IyUnl3ILUZ8WLBonasvq
	5mPkPERZq6nOE+R5LLEw+r3LUXkqNHr3D89dNmnA9K+lE2ntroZFSjKDv9JgQA==
X-Google-Smtp-Source: AGHT+IH0YEkJX+tjrjcL88W6+N0EJawA09q6e87WEWXzxMNv3w8fp9nad4+db5XgANVhctp+gnzw1g==
X-Received: by 2002:a05:600c:4856:b0:414:1400:a776 with SMTP id j22-20020a05600c485600b004141400a776mr641509wmo.5.1711201089204;
        Sat, 23 Mar 2024 06:38:09 -0700 (PDT)
Received: from google.com (180.232.140.34.bc.googleusercontent.com. [34.140.232.180])
        by smtp.gmail.com with ESMTPSA id n14-20020a5d51ce000000b0033e9fca1e49sm4446933wrv.60.2024.03.23.06.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Mar 2024 06:38:08 -0700 (PDT)
Date: Sat, 23 Mar 2024 13:38:04 +0000
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
Subject: Re: [PATCH v5 00/27] Update SMMUv3 to the modern iommu API (part 2/3)
Message-ID: <Zf7bPOtRg9tLSOKT@google.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>

Hi Jason,

On Mon, Mar 04, 2024 at 07:43:48PM -0400, Jason Gunthorpe wrote:
> Continuing the work of part 1 this focuses on the CD, PASID and SVA
> components:
> 
>  - attach_dev failure does not change the HW configuration.
> 
>  - Full PASID API support including:
>     - S1/SVA domains attached to PASIDs

I am still going through the series, but I see at the end the main SMMUv3
driver has set_dev_pasid operation, are there any in-tree drivers that
use that? (and how can I test it).

>     - IDENTITY/BLOCKED/S1 attached to RID
>     - Change of the RID domain while PASIDs are attached
> 
>  - Streamlined SVA support using the core infrastructure
> 
>  - Hitless, whenever possible, change between two domains

Can you please clarify what cases are expected to be hitless?
From what I see if ASID and TTB0 changes that would break the CD.
> 
> Making the CD programming work like the new STE programming allows
> untangling some of the confusing SVA flows. From there the focus is on
> building out the core infrastructure for dealing with PASID and CD
> entries, then keeping track of unique SSID's for ATS invalidation.
> 
> The ATS ordering is generalized so that the PASID flow can use it and put
> into a form where it is fully hitless, whenever possible. Care is taken to
> ensure that ATC flushes are present after any change in translation.
> 
> Finally we simply kill the entire outdated SVA mmu_notifier implementation
> in one shot and switch it over to the newly created generic PASID & CD
> code. This avoids the messy and confusing approach of trying to
> incrementally untangle this in place. The new code is small and simple
> enough this is much better than trying to figure out smaller steps.
> 
> Once SVA is resting on the right CD code it is straightforward to make the
> PASID interface functionally complete.
> 
> It achieves the same goals as the several series from Michael and the S1DSS
> series from Nicolin that were trying to improve portions of the API.
> 
> This is on github:
> https://github.com/jgunthorpe/linux/commits/smmuv3_newapi
> 
> v5:
>  - Rebase on v6.8-rc7 & Will's tree
>  - Accomdate the SVA rc patch removing the master list iteration
>  - Move the kfree(to_smmu_domain(domain)) hunk to the right patch
>  - Move S1DSS get_used hunk to "Allow IDENTITY/BLOCKED to be set while
>    PASID is used"
> v4: https://lore.kernel.org/r/0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com
>  - Rebase on v6.8-rc1, adjust to use mm_get_enqcmd_pasid() and eventually
>    remove all references from ARM. Move the new ARM_SMMU_FEAT_STALL_FORCE
>    stuff to arm_smmu_make_sva_cd()
>  - Adjust to use the new shared STE/CD writer logic. Disable some of the
>    sanity checks for the interior of the series
>  - Return ERR_PTR from domain_alloc functions
>  - Move the ATS disablement flow into arm_smmu_attach_prepare()/commit()
>    which lets all the STE update flows use the same sequence. This is
>    needed for nesting in part 3
>  - Put ssid in attach_state
>  - Replace to_smmu_domain_safe() with to_smmu_domain_devices()
> v3: https://lore.kernel.org/r/0-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com
>  - Rebase on the latest part 1
>  - update comments and commit messages
>  - Fix error exit in arm_smmu_set_pasid()
>  - Fix inverted logic for btm_invalidation
>  - Add missing ATC invalidation on mm release
>  - Add a big comment explaining that BTM is not enabled and what is
>    missing to enable it.
> v2: https://lore.kernel.org/r/0-v2-16665a652079+5947-smmuv3_newapi_p2_jgg@nvidia.com
>  - Rebased on iommmufd + Joerg's tree
>  - Use sid_smmu_domain consistently to refer to the domain attached to the
>    device (eg the PCIe RID)
>  - Rework how arm_smmu_attach_*() and callers flow to be more careful
>    about ordering around ATC invalidation. The ATC must be invalidated
>    after it is impossible to establish stale entires.
>  - ATS disable is now entirely part of arm_smmu_attach_dev_ste(), which is
>    the only STE type that ever disables ATS.
>  - Remove the 'existing_master_domain' optimization, the code is
>    functionally fine without it.
>  - Whitespace, spelling, and checkpatch related items
>  - Fixed wrong value stored in the xa for the BTM flows
>  - Use pasid more consistently instead of id
> v1: https://lore.kernel.org/r/0-v1-afbb86647bbd+5-smmuv3_newapi_p2_jgg@nvidia.com
> 
> Jason Gunthorpe (27):
>   iommu/arm-smmu-v3: Do not allow a SVA domain to be set on the wrong
>     PASID
>   iommu/arm-smmu-v3: Do not ATC invalidate the entire domain
>   iommu/arm-smmu-v3: Add a type for the CD entry
>   iommu/arm-smmu-v3: Add an ops indirection to the STE code
>   iommu/arm-smmu-v3: Make CD programming use arm_smmu_write_entry()
>   iommu/arm-smmu-v3: Consolidate clearing a CD table entry
>   iommu/arm-smmu-v3: Move the CD generation for S1 domains into a
>     function
>   iommu/arm-smmu-v3: Move allocation of the cdtable into
>     arm_smmu_get_cd_ptr()
>   iommu/arm-smmu-v3: Allocate the CD table entry in advance
>   iommu/arm-smmu-v3: Move the CD generation for SVA into a function
>   iommu/arm-smmu-v3: Build the whole CD in arm_smmu_make_s1_cd()
>   iommu/arm-smmu-v3: Start building a generic PASID layer
>   iommu/arm-smmu-v3: Make smmu_domain->devices into an allocated list
>   iommu/arm-smmu-v3: Make changing domains be hitless for ATS
>   iommu/arm-smmu-v3: Add ssid to struct arm_smmu_master_domain
>   iommu/arm-smmu-v3: Keep track of valid CD entries in the cd_table
>   iommu/arm-smmu-v3: Thread SSID through the arm_smmu_attach_*()
>     interface
>   iommu/arm-smmu-v3: Make SVA allocate a normal arm_smmu_domain
>   iommu/arm-smmu-v3: Keep track of arm_smmu_master_domain for SVA
>   iommu: Add ops->domain_alloc_sva()
>   iommu/arm-smmu-v3: Put the SVA mmu notifier in the smmu_domain
>   iommu/arm-smmu-v3: Consolidate freeing the ASID/VMID
>   iommu/arm-smmu-v3: Move the arm_smmu_asid_xa to per-smmu like vmid
>   iommu/arm-smmu-v3: Bring back SVA BTM support
>   iommu/arm-smmu-v3: Allow IDENTITY/BLOCKED to be set while PASID is
>     used
>   iommu/arm-smmu-v3: Allow a PASID to be set when RID is
>     IDENTITY/BLOCKED
>   iommu/arm-smmu-v3: Allow setting a S1 domain to a PASID
> 
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  639 +++++-----
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 1036 +++++++++++------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   79 +-
>  drivers/iommu/iommu-sva.c                     |    4 +-
>  drivers/iommu/iommu.c                         |   12 +-
>  include/linux/iommu.h                         |    3 +
>  6 files changed, 1024 insertions(+), 749 deletions(-)
> 
> 
> base-commit: 98b23ebb0c84657a135957d727eedebd1280cbbf
> -- 
> 2.43.2
> 

Thansks,
Mostafa
