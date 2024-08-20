Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DAA013C8FF
	for <patches@lists.linux.dev>; Tue, 20 Aug 2024 08:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724142615; cv=none; b=XwLktpMxsD3FEaWIL2+QgpbP8oSFMpl/PG1p2Uc1B6hvgoxbkPZPNNEFaet4FsIeQyGRykLlv/eknOArqrxl4zS/JGti/tVyH9UYVXHPyapoQXdS060GflfPzL/TbdzPrHaWD5qJh+2RIIKa+t0gojKujmcmndo9R+mpemUg46I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724142615; c=relaxed/simple;
	bh=C97kW6GO0b184jP3Z6JLzvY+X/IbBXrnJu7dwpjsKjc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rM6YgZHMYabRYzGfj6sM7y/0sWxrgN8BopOzK8/g3T7ZZ54xrrUKpCFvkKOnn6J1t2PtM/gFtlc/hOzKm7wCOlAw1nxg6jBKAmEuxOiIHTV0QXJ17bgjEoYwDOdtVc4KF845AnRnC6QuA4mGEKfrpIMsdvJJqifPxd3KYoGpc8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0GUg8zOp; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0GUg8zOp"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5bebc830406so5570a12.0
        for <patches@lists.linux.dev>; Tue, 20 Aug 2024 01:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724142611; x=1724747411; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Nmtk1HP3ErSXQsoJaqLN7JzX8v0kJjj6aEOiqGrjDL0=;
        b=0GUg8zOph7R+ndZJT6exCUxw8TCOqx1SwYSJUo1dtC1gOivSqAGJ7P2KDCyjBW7krS
         mnel+me4IR0xouQD7eZRF/jlbxLxc6URqBB8KvhBjhzvF8faCwvji0QLEpSmTBMwpJLw
         nIza7yQ3DZXY4N3G3xZv0eMThX1VddVwUlrNNYdj61F/yAiS97x53BjO4jFGSRs/pD0k
         /iMwrqahJdGCv10iEDo1e5pLCaViNBnSmX8C2qjRDRc1gM+BLSi66zOu4CVRLBhginwH
         bRVnzwmNSUt8MLiCjeAa0jj8YAFn5JCgKShtGoNxWFrlRW4TjN/cZMh/TnktFsqy4z7e
         caww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724142611; x=1724747411;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nmtk1HP3ErSXQsoJaqLN7JzX8v0kJjj6aEOiqGrjDL0=;
        b=c4fb3/3w3CdPahGkHOHgNt+3Nf5BfzbUSMByncxowDT84EUIqC6eSNnFcOq0ZuLGcq
         aX8S4+mD1OPM5NU+MjMoGVRzjAEHBp/a8WBT9p9Yi/Cl4a+RJBXR0IxF/1PV8rsi0cHK
         ccLDR+Oi6tGq68ah/QGNrMgTDgWEjJULelr61ppIuKsR930kzXq6vdn4vXnIhLY4Ycxy
         Cs0b2/xaG+RvVMnjxc4dRKLIQH63iCirI/HFv4TIJoAsPbqCYsjkdC2Bu8jWBc22s6Yb
         frL9+u5W5iJFizrCbZw1eftK2HRejZLvipotW+ACXZV0EDzleVD3x8vPvVEpc5cgMgRR
         oRIw==
X-Forwarded-Encrypted: i=1; AJvYcCXiE2IsHDljsQOZ5lnsM50mQMmuvZJDfJwLetniywmNJu7PhCWckAsxUC/6a2cJQ/+vU3YwbaE7@lists.linux.dev
X-Gm-Message-State: AOJu0YyCFABsWBcLE74bDAd7k6djenQSqkihRlZQ9KxoqxaCS071xzZ1
	rjYU92Mx+ygKRJnNcZ+xCz+BAMFWo/9rbneWp1E8S6PoCxuiSKaoozrn0dRijg==
X-Google-Smtp-Source: AGHT+IGPziUVy8HDcHfDeem3AWflQvAYWNj8eBFcuwDV7RIOne/5+5CR2e95OR/3zOh5eRn0jG6aJw==
X-Received: by 2002:a05:6402:3546:b0:5be:c28a:97cf with SMTP id 4fb4d7f45d1cf-5bf0e5a28eemr37487a12.5.1724142610293;
        Tue, 20 Aug 2024 01:30:10 -0700 (PDT)
Received: from google.com (203.75.199.104.bc.googleusercontent.com. [104.199.75.203])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429ed7945b8sm135707085e9.44.2024.08.20.01.30.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2024 01:30:09 -0700 (PDT)
Date: Tue, 20 Aug 2024 08:30:05 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: acpica-devel@lists.linux.dev,
	Alex Williamson <alex.williamson@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH 2/8] iommu/arm-smmu-v3: Use S2FWB when available
Message-ID: <ZsRUDaFLd85O8u4Z@google.com>
References: <0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <2-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>

Hi Jason,

On Tue, Aug 06, 2024 at 08:41:15PM -0300, Jason Gunthorpe wrote:
> Force Write Back (FWB) changes how the S2 IOPTE's MemAttr field
> works. When S2FWB is supported and enabled the IOPTE will force cachable
> access to IOMMU_CACHE memory and deny cachable access otherwise.
> 
> This is not especially meaningful for simple S2 domains, it apparently
> doesn't even force PCI no-snoop access to be coherent.
> 
> However, when used with a nested S1, FWB has the effect of preventing the
> guest from choosing a MemAttr that would cause ordinary DMA to bypass the
> cache. Consistent with KVM we wish to deny the guest the ability to become
> incoherent with cached memory the hypervisor believes is cachable so we
> don't have to flush it.
> 
> Turn on S2FWB whenever the SMMU supports it and use it for all S2
> mappings.

I have been looking into this recently from the KVM side as it will
use FWB for the CPU stage-2 unconditionally for guests(if supported),
however that breaks for non-coherent devices when assigned, and
limiting assigned devices to be coherent seems too restrictive.
I have been looking into ways to notify KVM from VFIO as early as
possible so it can configure the page table properly.

But for SMMUv3, S2FWB is per stream, can’t we just use it if the master
is DMA coherent?

Thanks,
Mostafa

> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  6 ++++++
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  3 +++
>  drivers/iommu/io-pgtable-arm.c              | 24 +++++++++++++++++----
>  include/linux/io-pgtable.h                  |  2 ++
>  4 files changed, 31 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 531125f231b662..7fe1e27d11586c 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -1612,6 +1612,8 @@ void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
>  		FIELD_PREP(STRTAB_STE_1_EATS,
>  			   ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
>  
> +	if (smmu->features & ARM_SMMU_FEAT_S2FWB)
> +		target->data[1] |= cpu_to_le64(STRTAB_STE_1_S2FWB);
>  	if (smmu->features & ARM_SMMU_FEAT_ATTR_TYPES_OVR)
>  		target->data[1] |= cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG,
>  							  STRTAB_STE_1_SHCFG_INCOMING));
> @@ -2400,6 +2402,8 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
>  		pgtbl_cfg.oas = smmu->oas;
>  		fmt = ARM_64_LPAE_S2;
>  		finalise_stage_fn = arm_smmu_domain_finalise_s2;
> +		if (smmu->features & ARM_SMMU_FEAT_S2FWB)
> +			pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_ARM_S2FWB;
>  		break;
>  	default:
>  		return -EINVAL;
> @@ -4189,6 +4193,8 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
>  
>  	/* IDR3 */
>  	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR3);
> +	if (FIELD_GET(IDR3_FWB, reg))
> +		smmu->features |= ARM_SMMU_FEAT_S2FWB;
>  	if (FIELD_GET(IDR3_RIL, reg))
>  		smmu->features |= ARM_SMMU_FEAT_RANGE_INV;
>  
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 8851a7abb5f0f3..7e8d2f36faebf3 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -55,6 +55,7 @@
>  #define IDR1_SIDSIZE			GENMASK(5, 0)
>  
>  #define ARM_SMMU_IDR3			0xc
> +#define IDR3_FWB			(1 << 8)
>  #define IDR3_RIL			(1 << 10)
>  
>  #define ARM_SMMU_IDR5			0x14
> @@ -258,6 +259,7 @@ static inline u32 arm_smmu_strtab_l2_idx(u32 sid)
>  #define STRTAB_STE_1_S1CSH		GENMASK_ULL(7, 6)
>  
>  #define STRTAB_STE_1_S1STALLD		(1UL << 27)
> +#define STRTAB_STE_1_S2FWB		(1UL << 25)
>  
>  #define STRTAB_STE_1_EATS		GENMASK_ULL(29, 28)
>  #define STRTAB_STE_1_EATS_ABT		0UL
> @@ -700,6 +702,7 @@ struct arm_smmu_device {
>  #define ARM_SMMU_FEAT_ATTR_TYPES_OVR	(1 << 20)
>  #define ARM_SMMU_FEAT_HA		(1 << 21)
>  #define ARM_SMMU_FEAT_HD		(1 << 22)
> +#define ARM_SMMU_FEAT_S2FWB		(1 << 23)
>  	u32				features;
>  
>  #define ARM_SMMU_OPT_SKIP_PREFETCH	(1 << 0)
> diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
> index f5d9fd1f45bf49..62bbb6037e1686 100644
> --- a/drivers/iommu/io-pgtable-arm.c
> +++ b/drivers/iommu/io-pgtable-arm.c
> @@ -106,6 +106,18 @@
>  #define ARM_LPAE_PTE_HAP_FAULT		(((arm_lpae_iopte)0) << 6)
>  #define ARM_LPAE_PTE_HAP_READ		(((arm_lpae_iopte)1) << 6)
>  #define ARM_LPAE_PTE_HAP_WRITE		(((arm_lpae_iopte)2) << 6)
> +/*
> + * For !FWB these code to:
> + *  1111 = Normal outer write back cachable / Inner Write Back Cachable
> + *         Permit S1 to override
> + *  0101 = Normal Non-cachable / Inner Non-cachable
> + *  0001 = Device / Device-nGnRE
> + * For S2FWB these code:
> + *  0110 Force Normal Write Back
> + *  0101 Normal* is forced Normal-NC, Device unchanged
> + *  0001 Force Device-nGnRE
> + */
> +#define ARM_LPAE_PTE_MEMATTR_FWB_WB	(((arm_lpae_iopte)0x6) << 2)
>  #define ARM_LPAE_PTE_MEMATTR_OIWB	(((arm_lpae_iopte)0xf) << 2)
>  #define ARM_LPAE_PTE_MEMATTR_NC		(((arm_lpae_iopte)0x5) << 2)
>  #define ARM_LPAE_PTE_MEMATTR_DEV	(((arm_lpae_iopte)0x1) << 2)
> @@ -458,12 +470,16 @@ static arm_lpae_iopte arm_lpae_prot_to_pte(struct arm_lpae_io_pgtable *data,
>  	 */
>  	if (data->iop.fmt == ARM_64_LPAE_S2 ||
>  	    data->iop.fmt == ARM_32_LPAE_S2) {
> -		if (prot & IOMMU_MMIO)
> +		if (prot & IOMMU_MMIO) {
>  			pte |= ARM_LPAE_PTE_MEMATTR_DEV;
> -		else if (prot & IOMMU_CACHE)
> -			pte |= ARM_LPAE_PTE_MEMATTR_OIWB;
> -		else
> +		} else if (prot & IOMMU_CACHE) {
> +			if (data->iop.cfg.quirks & IO_PGTABLE_QUIRK_ARM_S2FWB)
> +				pte |= ARM_LPAE_PTE_MEMATTR_FWB_WB;
> +			else
> +				pte |= ARM_LPAE_PTE_MEMATTR_OIWB;
> +		} else {
>  			pte |= ARM_LPAE_PTE_MEMATTR_NC;
> +		}
>  	} else {
>  		if (prot & IOMMU_MMIO)
>  			pte |= (ARM_LPAE_MAIR_ATTR_IDX_DEV
> diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
> index f9a81761bfceda..aff9b020b6dcc7 100644
> --- a/include/linux/io-pgtable.h
> +++ b/include/linux/io-pgtable.h
> @@ -87,6 +87,7 @@ struct io_pgtable_cfg {
>  	 *	attributes set in the TCR for a non-coherent page-table walker.
>  	 *
>  	 * IO_PGTABLE_QUIRK_ARM_HD: Enables dirty tracking in stage 1 pagetable.
> +	 * IO_PGTABLE_QUIRK_ARM_S2FWB: Use the FWB format for the MemAttrs bits
>  	 */
>  	#define IO_PGTABLE_QUIRK_ARM_NS			BIT(0)
>  	#define IO_PGTABLE_QUIRK_NO_PERMS		BIT(1)
> @@ -95,6 +96,7 @@ struct io_pgtable_cfg {
>  	#define IO_PGTABLE_QUIRK_ARM_TTBR1		BIT(5)
>  	#define IO_PGTABLE_QUIRK_ARM_OUTER_WBWA		BIT(6)
>  	#define IO_PGTABLE_QUIRK_ARM_HD			BIT(7)
> +	#define IO_PGTABLE_QUIRK_ARM_S2FWB		BIT(8)
>  	unsigned long			quirks;
>  	unsigned long			pgsize_bitmap;
>  	unsigned int			ias;
> -- 
> 2.46.0
> 
