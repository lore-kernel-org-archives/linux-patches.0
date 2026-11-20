Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795196549;
	b=wcqhHnNOmDZUdFeU53CGeBjtnkrYTwhIJnfeonw6dckWWL8zQAVSXun8qK4Q68rFrcu8
	 B3K31BF0eNdqcJcu6KTqjd56MtOmSlwUjydhdEDRgL8aH0NE7nA79+cM9OuvKTWaaKYmH
	 a8GUmnIfMtQJU4rfLgQWLdjnAJwZzp1CtkRemgsyY9YNSFitPOpzG5E3X4kEcA92TXKHk
	 2lHeGnsZzXod1a8c7EUW30YEF18YGthEutpJhPjLnIrCBsVRUB//blUcv+/Ik3cIVOGKW
	 pvFH3ceVTu4vimPsvutjF9agQ0f8VaL9oebLDrmLKBa/W257GG4edyU+SqyEA0IsSLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795196549;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:In-Reply-To:References:Organization:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=IHQiyVPknCKcSZ6nudhvEAN+UH/HvXb1mXjm6my0pms=;
	b=xp7nMRlH6FU1S9Cd1tRG0JHjqJctX4cpYDY1DJvRJMENfy4DXCGyr/U7ccZy1F6LGcv1
	 KIdjHTC0cPp/d54tfh/xH2JjETOZjE0nd9aoQxPRmZajPrMJxzoMUModnfTOEfJcPVs9s
	 l0FbdsHPSrgNlDU8WjllpVvyA1wxYnIoDrUcB4lo7EjkXFm27Wzi7V3uIV5QLEy7KplGJ
	 ULpL9BBcQ0wbr/6b/caBY9Lq2vZPhLG9NTxsLc3sndYT2G2CRx8IpGYx4YOz2xxsB62lA
	 RKE13b1OFKC4wOv5d8xTMUpEes3R7giPwzhxLCSiAPe2XXTMvpwQ6qj4cTJCYPsnTPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=isXZpF1b;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CE70606A7F5;
	Fri, 20 Nov 2026 17:42:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2CE70606A7F5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=isXZpF1b
Received: from localhost (unknown [4.194.122.136])
	by linux.microsoft.com (Postfix) with ESMTPSA id 6820020B716E;
	Fri, 20 Nov 2026 09:42:10 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6820020B716E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1795196544;
	bh=IHQiyVPknCKcSZ6nudhvEAN+UH/HvXb1mXjm6my0pms=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=isXZpF1beaCi2I9ewSeS0IAXuv1A9IS/qcHY7uYwjQOy+KCRtFaCKsEbxvAu8xfJ5
	 hLtZYYjF9drBMPFqtioVreFwJnEy6HMKf42TUp8R/jonaj8fuh2+cJf7pJOWrtGlo8
	 sromy/ZBhp488b6flHykLhv7zQCzypAvp9cbo1uw=
Date: Fri, 20 Nov 2026 09:42:07 -0800
From: Jacob Pan <jacob.pan@linux.microsoft.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, Alex Williamson <alex@shazbot.org>, Alexey
 Kardashevskiy <aik@amd.com>, Bjorn Helgaas <bhelgaas@google.com>, Catalin
 Marinas <catalin.marinas@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>, Joerg
 Roedel <joro@8bytes.org>, Jonathan Cameron <jic23@kernel.org>, Jonathan
 Hunter <jonathanh@nvidia.com>, Kevin Tian <kevin.tian@intel.com>, Krishna
 Reddy <vdumpa@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Nicolin Chen
 <nicolinc@nvidia.com>, Robin Murphy <robin.murphy@arm.com>, Samuel Ortiz
 <sameo@rivosinc.com>, Shameer Kolothum
 <shameerali.kolothum.thodi@huawei.com>, Steven Price
 <steven.price@arm.com>, Suravee Suthikulpanit
 <suravee.suthikulpanit@amd.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Thierry Reding <thierry.reding@kernel.org>, Vasant Hegde
 <vasant.hegde@amd.com>, Will Deacon <will@kernel.org>, Xu Yilun
 <yilun.xu@linux.intel.com>, Ashish Kalra <ashish.kalra@amd.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, iommu@lists.linux.dev, Jonathan Cameron
 <jonathan.cameron@huawei.com>, Tom Lendacky <thomas.lendacky@amd.com>,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-pci@vger.kernel.org, linux-tegra@vger.kernel.org,
 patches@lists.linux.dev, jacob.pan@linux.microsoft.com
Subject: Re: [PATCH v9 09/13] iommufd/viommu: Select vIOMMU operations
 before allocation
Message-ID: <20261120094207.00002e89@linux.microsoft.com>
In-Reply-To: <20261116081935.85372-10-aneesh.kumar@kernel.org>
References: <20261116081935.85372-1-aneesh.kumar@kernel.org>
	<20261116081935.85372-10-aneesh.kumar@kernel.org>
Organization: LSG
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.51; x86_64-w64-mingw32)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Aneesh,

On Mon, 16 Nov 2026 13:49:31 +0530
"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> wrote:

> Physical IOMMU drivers currently provide the vIOMMU size and
> initialization callbacks through iommu_ops. The initialization
> callback then selects and installs the corresponding
> iommufd_viommu_ops.
> 
> Add iommu_ops::get_viommu_ops() to select the operations from the
> physical device and requested vIOMMU type before allocation. Move the
> size and initialization callbacks into iommufd_viommu_ops. The core
> can then validate the selected operations, allocate the driver
> structure, initialize it, and install the operations.
The patch title is slightly misleading since it does not change the
order between setting viommu_ops and allocation. IMHO, it is more like:
"Move vIOMMU ops selection into the core"

> Convert AMD, Arm SMMUv3, Tegra CMDQV, and the selftest backend to the
> new interface.
> 
> The current code requires a valid parent HWPT before calling
> viommu_init(), which selects the vIOMMU operations. A later patch adds
> an operations flag indicating that a vIOMMU type does not require a
> parent HWPT. Selecting the operations earlier allows the core to check
> that flag before deciding whether to look up and validate a parent
> HWPT.
> 
> Temporarily disable AMD vIOMMU allocation by returning NULL from
> amd_iommufd_get_viommu_ops() while the vIOMMU interfaces are being
> updated.
> 
why? if this merged, it would break AMD driver vIOMMU functionality.
And not temporary as I didn't see enabling in this set.

> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Cc: Vasant Hegde <vasant.hegde@amd.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Cc: Thierry Reding <thierry.reding@kernel.org>
> Cc: Krishna Reddy <vdumpa@nvidia.com>
> Cc: Jonathan Hunter <jonathanh@nvidia.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-tegra@vger.kernel.org
> Cc: iommu@lists.linux.dev
> Based on original patch by Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>  drivers/iommu/amd/iommu.c                     |  3 +-
>  drivers/iommu/amd/iommufd.c                   | 18 ++++++---
>  drivers/iommu/amd/iommufd.h                   | 11 ++++--
>  drivers/iommu/amd/nested.c                    |  4 +-
>  .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 37
> +++++++++++-------- drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |
> 7 ++-- drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   | 16 ++++----
>  .../iommu/arm/arm-smmu-v3/tegra241-cmdqv.c    | 24 ++++++++----
>  drivers/iommu/iommufd/selftest.c              | 31 +++++++++++-----
>  drivers/iommu/iommufd/viommu.c                | 32 ++++++++--------
>  include/linux/iommu.h                         | 20 +++-------
>  include/linux/iommufd.h                       | 14 +++++++
>  12 files changed, 129 insertions(+), 88 deletions(-)
> 
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index 41ee4ad1dcf8..2b318d8c82a0 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -3265,8 +3265,7 @@ const struct iommu_ops amd_iommu_ops = {
>  	.is_attach_deferred = amd_iommu_is_attach_deferred,
>  	.def_domain_type = amd_iommu_def_domain_type,
>  	.page_response = amd_iommu_page_response,
> -	.get_viommu_size = amd_iommufd_get_viommu_size,
> -	.viommu_init = amd_iommufd_viommu_init,
> +	.get_viommu_ops = amd_iommufd_get_viommu_ops,
>  };
>  
>  #ifdef CONFIG_IRQ_REMAP
> diff --git a/drivers/iommu/amd/iommufd.c b/drivers/iommu/amd/iommufd.c
> index 52300b867c1f..dcbe80fcb8c7 100644
> --- a/drivers/iommu/amd/iommufd.c
> +++ b/drivers/iommu/amd/iommufd.c
> @@ -32,13 +32,21 @@ void *amd_iommufd_hw_info(struct device *dev, u32
> *length, enum iommu_hw_info_ty return hwinfo;
>  }
>  
> -size_t amd_iommufd_get_viommu_size(struct device *dev, enum
> iommu_viommu_type viommu_type) +static size_t
> amd_iommufd_get_viommu_size(struct device *dev,
> +		enum iommu_viommu_type viommu_type)
Making this function static seems unrelated.

>  {
>  	return VIOMMU_STRUCT_SIZE(struct amd_iommu_viommu, core);
>  }
>  
> -int amd_iommufd_viommu_init(struct iommufd_viommu *viommu, struct
> iommu_domain *parent,
> -			    const struct iommu_user_data *user_data)
> +const struct iommufd_viommu_ops *
> +amd_iommufd_get_viommu_ops(struct device *dev, enum
> iommu_viommu_type viommu_type) +{
> +	return NULL;
> +}
> +
> +int amd_iommufd_viommu_init(struct iommufd_viommu *viommu,
> +		struct device *dev, struct iommu_domain *parent,
> +		const struct iommu_user_data *user_data)
>  {
>  	unsigned long flags;
>  	struct protection_domain *pdom = to_pdomain(parent);
> @@ -47,8 +55,6 @@ int amd_iommufd_viommu_init(struct iommufd_viommu
> *viommu, struct iommu_domain * xa_init_flags(&aviommu->gdomid_array,
> XA_FLAGS_ALLOC1); aviommu->parent = pdom;
>  
> -	viommu->ops = &amd_viommu_ops;
> -
>  	spin_lock_irqsave(&pdom->lock, flags);
>  	list_add(&aviommu->pdom_list, &pdom->viommu_list);
>  	spin_unlock_irqrestore(&pdom->lock, flags);
> @@ -73,5 +79,7 @@ static void amd_iommufd_viommu_destroy(struct
> iommufd_viommu *viommu)
>   * struct iommufd_viommu_ops - vIOMMU specific operations
>   */
>  static const struct iommufd_viommu_ops amd_viommu_ops = {
> +	.get_viommu_size = amd_iommufd_get_viommu_size,
> +	.viommu_init = amd_iommufd_viommu_init,
>  	.destroy = amd_iommufd_viommu_destroy,
>  };
> diff --git a/drivers/iommu/amd/iommufd.h b/drivers/iommu/amd/iommufd.h
> index 62e9e1bebfbe..0d8e7c0902cf 100644
> --- a/drivers/iommu/amd/iommufd.h
> +++ b/drivers/iommu/amd/iommufd.h
> @@ -8,13 +8,16 @@
>  
>  #if IS_ENABLED(CONFIG_AMD_IOMMU_IOMMUFD)
>  void *amd_iommufd_hw_info(struct device *dev, u32 *length, enum
> iommu_hw_info_type *type); -size_t amd_iommufd_get_viommu_size(struct
> device *dev, enum iommu_viommu_type viommu_type); -int
> amd_iommufd_viommu_init(struct iommufd_viommu *viommu, struct
> iommu_domain *parent,
> -			    const struct iommu_user_data *user_data);
> +const struct iommufd_viommu_ops *
> +amd_iommufd_get_viommu_ops(struct device *dev,
> +		enum iommu_viommu_type viommu_type);
> +int amd_iommufd_viommu_init(struct iommufd_viommu *viommu,
> +		struct device *dev, struct iommu_domain *parent,
> +		const struct iommu_user_data *user_data);
>  #else
>  #define amd_iommufd_hw_info NULL
>  #define amd_iommufd_viommu_init NULL
> -#define amd_iommufd_get_viommu_size NULL
> +#define amd_iommufd_get_viommu_ops NULL
>  #endif /* CONFIG_AMD_IOMMU_IOMMUFD */
>  
>  #endif /* AMD_IOMMUFD_H */
> diff --git a/drivers/iommu/amd/nested.c b/drivers/iommu/amd/nested.c
> index f1c7987fc585..a4d856689e57 100644
> --- a/drivers/iommu/amd/nested.c
> +++ b/drivers/iommu/amd/nested.c
> @@ -90,7 +90,7 @@ static void *gdom_info_load_or_alloc_locked(struct
> xarray *xa, 
>  /*
>   * This function is assigned to struct
> iommufd_viommu_ops.alloc_domain_nested()
> - * during the call to struct iommu_ops.viommu_init().
> + * during the call to struct iommufd_viommu_ops.viommu_init().
>   */
>  struct iommu_domain *
>  amd_iommu_alloc_domain_nested(struct iommufd_viommu *viommu, u32
> flags, @@ -198,7 +198,7 @@ static void set_dte_nested(struct
> amd_iommu *iommu, struct iommu_domain *dom, 
>  	/*
>  	 * The nest parent domain is attached during the call to the
> -	 * struct iommu_ops.viommu_init(), which will be stored as
> part
> +	 * struct iommufd_viommu_ops.viommu_init(), which will be
> stored as part
>  	 * of the struct amd_iommu_viommu.parent.
>  	 */
>  	if (WARN_ON(!ndom->viommu || !ndom->viommu->parent))
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c index
> e68b46485095..d8c837df9f47 100644 ---
> a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c +++
> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c @@ -533,20
> +533,29 @@ int arm_vsmmu_cache_invalidate(struct iommufd_viommu
> *viommu, return ret; }
>  
> +static size_t arm_vsmmu_get_size(struct device *dev,
> +				 enum iommu_viommu_type viommu_type)
> +{
> +	return VIOMMU_STRUCT_SIZE(struct arm_vsmmu, core);
> +}
> +
>  static const struct iommufd_viommu_ops arm_vsmmu_ops = {
> +	.get_viommu_size = arm_vsmmu_get_size,
> +	.viommu_init = arm_vsmmu_init,
>  	.alloc_domain_nested = arm_vsmmu_alloc_domain_nested,
>  	.cache_invalidate = arm_vsmmu_cache_invalidate,
>  	.vdevice_init = arm_vsmmu_vdevice_init,
>  };
>  
> -size_t arm_smmu_get_viommu_size(struct device *dev,
> -				enum iommu_viommu_type viommu_type)
> +const struct iommufd_viommu_ops *
> +arm_smmu_get_viommu_ops(struct device *dev,
> +		enum iommu_viommu_type viommu_type)
>  {
>  	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
>  	struct arm_smmu_device *smmu = master->smmu;
>  
>  	if (!(smmu->features & ARM_SMMU_FEAT_NESTING))
> -		return 0;
> +		return NULL;
>  
>  	/*
>  	 * FORCE_SYNC is not set with FEAT_NESTING. Some study of
> the exact HW @@ -554,7 +563,7 @@ size_t
> arm_smmu_get_viommu_size(struct device *dev,
>  	 * any change to remove this.
>  	 */
>  	if (WARN_ON(smmu->options & ARM_SMMU_OPT_CMDQ_FORCE_SYNC))
> -		return 0;
> +		return NULL;
>  
>  	/*
>  	 * Must support some way to prevent the VM from bypassing
> the cache @@ -566,19 +575,19 @@ size_t
> arm_smmu_get_viommu_size(struct device *dev, */
>  	if (!arm_smmu_master_canwbs(master) &&
>  	    !(smmu->features & ARM_SMMU_FEAT_S2FWB))
> -		return 0;
> +		return NULL;
>  
>  	if (viommu_type == IOMMU_VIOMMU_TYPE_ARM_SMMUV3)
> -		return VIOMMU_STRUCT_SIZE(struct arm_vsmmu, core);
> +		return &arm_vsmmu_ops;
>  
> -	if (!smmu->impl_ops || !smmu->impl_ops->get_viommu_size)
> -		return 0;
> -	return smmu->impl_ops->get_viommu_size(viommu_type);
> +	if (!smmu->impl_ops || !smmu->impl_ops->get_viommu_ops)
> +		return NULL;
> +	return smmu->impl_ops->get_viommu_ops(viommu_type);
>  }
>  
> -int arm_vsmmu_init(struct iommufd_viommu *viommu,
> -		   struct iommu_domain *parent_domain,
> -		   const struct iommu_user_data *user_data)
> +int arm_vsmmu_init(struct iommufd_viommu *viommu, struct device *dev,
> +		struct iommu_domain *parent_domain,
> +		const struct iommu_user_data *user_data)
>  {
>  	struct arm_vsmmu *vsmmu = container_of(viommu, struct
> arm_vsmmu, core); struct arm_smmu_device *smmu =
> @@ -593,10 +602,8 @@ int arm_vsmmu_init(struct iommufd_viommu *viommu,
>  	/* FIXME Move VMID allocation from the S2 domain allocation
> to here */ vsmmu->vmid = s2_parent->s2_cfg.vmid;
>  
> -	if (viommu->type == IOMMU_VIOMMU_TYPE_ARM_SMMUV3) {
> -		viommu->ops = &arm_vsmmu_ops;
> +	if (viommu->type == IOMMU_VIOMMU_TYPE_ARM_SMMUV3)
>  		return 0;
> -	}
>  
>  	return smmu->impl_ops->vsmmu_init(vsmmu, user_data);
>  }
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c index
> 100b34f07032..62dd769f1f6c 100644 ---
> a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c +++
> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c @@ -4597,8 +4597,7 @@
> static const struct iommu_ops arm_smmu_ops = {
> .get_resv_regions	= arm_smmu_get_resv_regions,
> .page_response		= arm_smmu_page_response,
> .def_domain_type	= arm_smmu_def_domain_type,
> -	.get_viommu_size	= arm_smmu_get_viommu_size,
> -	.viommu_init		= arm_vsmmu_init,
> +	.get_viommu_ops	= arm_smmu_get_viommu_ops,
>  	.user_pasid_table	= 1,
>  	.owner			= THIS_MODULE,
>  	.default_domain_ops = &(const struct iommu_domain_ops) {
> @@ -5761,8 +5760,8 @@ static struct arm_smmu_device
> *arm_smmu_impl_probe(struct arm_smmu_device *smmu) 
>  	ops = new_smmu->impl_ops;
>  	if (ops) {
> -		/* get_viommu_size and vsmmu_init ops must be paired
> */
> -		if (WARN_ON(!ops->get_viommu_size !=
> !ops->vsmmu_init)) {
> +		/* get_viommu_ops and vsmmu_init ops must be paired
> */
> +		if (WARN_ON(!ops->get_viommu_ops !=
> !ops->vsmmu_init)) { ret = -EINVAL;
>  			goto err_remove;
>  		}
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h index
> bb048e08d613..d93388e8eefb 100644 ---
> a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h +++
> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h @@ -931,7 +931,8 @@
> struct arm_smmu_impl_ops { */
>  	void *(*hw_info)(struct arm_smmu_device *smmu, u32 *length,
>  			 enum iommu_hw_info_type *type);
> -	size_t (*get_viommu_size)(enum iommu_viommu_type
> viommu_type);
> +	const struct iommufd_viommu_ops *(*get_viommu_ops)(
> +		enum iommu_viommu_type viommu_type);
>  	int (*vsmmu_init)(struct arm_vsmmu *vsmmu,
>  			  const struct iommu_user_data *user_data);
>  };
> @@ -1321,11 +1322,12 @@ struct arm_vsmmu {
>  #if IS_ENABLED(CONFIG_ARM_SMMU_V3_IOMMUFD)
>  void *arm_smmu_hw_info(struct device *dev, u32 *length,
>  		       enum iommu_hw_info_type *type);
> -size_t arm_smmu_get_viommu_size(struct device *dev,
> -				enum iommu_viommu_type viommu_type);
> -int arm_vsmmu_init(struct iommufd_viommu *viommu,
> -		   struct iommu_domain *parent_domain,
> -		   const struct iommu_user_data *user_data);
> +const struct iommufd_viommu_ops *
> +arm_smmu_get_viommu_ops(struct device *dev,
> +		enum iommu_viommu_type viommu_type);
> +int arm_vsmmu_init(struct iommufd_viommu *viommu, struct device *dev,
> +		struct iommu_domain *parent_domain,
> +		const struct iommu_user_data *user_data);
>  int arm_smmu_attach_prepare_vmaster(struct arm_smmu_attach_state
> *state, struct arm_smmu_nested_domain *nested_domain);
>  void arm_smmu_attach_commit_vmaster(struct arm_smmu_attach_state
> *state); @@ -1337,7 +1339,7 @@ arm_vsmmu_alloc_domain_nested(struct
> iommufd_viommu *viommu, u32 flags, int
> arm_vsmmu_cache_invalidate(struct iommufd_viommu *viommu, struct
> iommu_user_data_array *array); #else
> -#define arm_smmu_get_viommu_size NULL
> +#define arm_smmu_get_viommu_ops NULL
>  #define arm_smmu_hw_info NULL
>  #define arm_vsmmu_init NULL
>  #define arm_vsmmu_alloc_domain_nested NULL
> diff --git a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
> b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c index
> 710a4c694b94..b48306b67ac2 100644 ---
> a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c +++
> b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c @@ -892,11 +892,14
> @@ static void *tegra241_cmdqv_hw_info(struct arm_smmu_device *smmu,
> u32 *length, return info; }
>  
> -static size_t tegra241_cmdqv_get_vintf_size(enum iommu_viommu_type
> viommu_type) +static const struct iommufd_viommu_ops
> tegra241_cmdqv_viommu_ops; +
> +static const struct iommufd_viommu_ops *
> +tegra241_cmdqv_get_viommu_ops(enum iommu_viommu_type viommu_type)
>  {
>  	if (viommu_type != IOMMU_VIOMMU_TYPE_TEGRA241_CMDQV)
> -		return 0;
> -	return VIOMMU_STRUCT_SIZE(struct tegra241_vintf, vsmmu.core);
> +		return NULL;
> +	return &tegra241_cmdqv_viommu_ops;
>  }
>  
>  static struct arm_smmu_impl_ops tegra241_cmdqv_impl_ops = {
> @@ -907,7 +910,7 @@ static struct arm_smmu_impl_ops
> tegra241_cmdqv_impl_ops = { .device_remove = tegra241_cmdqv_remove,
>  	/* For user-space use */
>  	.hw_info = tegra241_cmdqv_hw_info,
> -	.get_viommu_size = tegra241_cmdqv_get_vintf_size,
> +	.get_viommu_ops = tegra241_cmdqv_get_viommu_ops,
>  	.vsmmu_init = tegra241_cmdqv_init_vintf_user,
>  };
>  
> @@ -1289,7 +1292,15 @@ static int tegra241_vintf_init_vsid(struct
> iommufd_vdevice *vdev) return 0;
>  }
>  
> -static struct iommufd_viommu_ops tegra241_cmdqv_viommu_ops = {
> +static size_t tegra241_cmdqv_get_vintf_size(struct device *dev,
> +					    enum iommu_viommu_type
> viommu_type) +{
> +	return VIOMMU_STRUCT_SIZE(struct tegra241_vintf, vsmmu.core);
> +}
> +
> +static const struct iommufd_viommu_ops tegra241_cmdqv_viommu_ops = {
> +	.get_viommu_size = tegra241_cmdqv_get_vintf_size,
> +	.viommu_init = arm_vsmmu_init,
>  	.destroy = tegra241_cmdqv_destroy_vintf_user,
>  	.alloc_domain_nested = arm_vsmmu_alloc_domain_nested,
>  	/* Non-accelerated commands will be still handled by the
> kernel */ @@ -1312,7 +1323,7 @@ tegra241_cmdqv_init_vintf_user(struct
> arm_vsmmu *vsmmu, int ret;
>  
>  	/*
> -	 * Unsupported type should be rejected by
> tegra241_cmdqv_get_vintf_size.
> +	 * Unsupported type should be rejected by
> tegra241_cmdqv_get_viommu_ops.
>  	 * Seeing one here indicates a kernel bug or some data
> corruption. */
>  	if (WARN_ON(vsmmu->core.type !=
> IOMMU_VIOMMU_TYPE_TEGRA241_CMDQV)) @@ -1364,7 +1375,6 @@
> tegra241_cmdqv_init_vintf_user(struct arm_vsmmu *vsmmu,
> dev_dbg(cmdqv->dev, "VINTF%u: allocated with vmid (%d)\n",
> vintf->idx, vintf->vsmmu.vmid); 
> -	vsmmu->core.ops = &tegra241_cmdqv_viommu_ops;
>  	return 0;
>  
>  free_mmap:
> diff --git a/drivers/iommu/iommufd/selftest.c
> b/drivers/iommu/iommufd/selftest.c index b17cca7096b6..09d1b0f8f1da
> 100644 --- a/drivers/iommu/iommufd/selftest.c
> +++ b/drivers/iommu/iommufd/selftest.c
> @@ -767,7 +767,19 @@ static int mock_hw_queue_init_phys(struct
> iommufd_hw_queue *hw_queue, u32 index, return rc;
>  }
>  
> -static struct iommufd_viommu_ops mock_viommu_ops = {
> +static int mock_viommu_init(struct iommufd_viommu *viommu, struct
> device *dev,
> +		struct iommu_domain *parent_domain,
> +		const struct iommu_user_data *user_data);
> +
> +static size_t mock_get_viommu_size(struct device *dev,
> +				   enum iommu_viommu_type
> viommu_type) +{
> +	return VIOMMU_STRUCT_SIZE(struct mock_viommu, core);
> +}
> +
> +static const struct iommufd_viommu_ops mock_viommu_ops = {
> +	.get_viommu_size = mock_get_viommu_size,
> +	.viommu_init = mock_viommu_init,
>  	.destroy = mock_viommu_destroy,
>  	.alloc_domain_nested = mock_viommu_alloc_domain_nested,
>  	.cache_invalidate = mock_viommu_cache_invalidate,
> @@ -775,17 +787,18 @@ static struct iommufd_viommu_ops
> mock_viommu_ops = { .hw_queue_init_phys = mock_hw_queue_init_phys,
>  };
>  
> -static size_t mock_get_viommu_size(struct device *dev,
> -				   enum iommu_viommu_type
> viommu_type) +static const struct iommufd_viommu_ops *
> +mock_get_viommu_ops(struct device *dev,
> +		enum iommu_viommu_type viommu_type)
>  {
>  	if (viommu_type != IOMMU_VIOMMU_TYPE_SELFTEST)
> -		return 0;
> -	return VIOMMU_STRUCT_SIZE(struct mock_viommu, core);
> +		return NULL;
> +	return &mock_viommu_ops;
>  }
>  
>  static int mock_viommu_init(struct iommufd_viommu *viommu,
> -			    struct iommu_domain *parent_domain,
> -			    const struct iommu_user_data *user_data)
> +		struct device *dev, struct iommu_domain
> *parent_domain,
> +		const struct iommu_user_data *user_data)
>  {
>  	struct mock_iommu_device *mock_iommu = container_of(
>  		viommu->iommu_dev, struct mock_iommu_device,
> iommu_dev); @@ -827,7 +840,6 @@ static int mock_viommu_init(struct
> iommufd_viommu *viommu, mutex_init(&mock_viommu->queue_mutex);
>  	mock_viommu->s2_parent = to_mock_domain(parent_domain);
>  
> -	viommu->ops = &mock_viommu_ops;
>  	return 0;
>  
>  err_destroy_mmap:
> @@ -854,8 +866,7 @@ static const struct iommu_ops mock_ops = {
>  	.probe_device = mock_probe_device,
>  	.page_response = mock_domain_page_response,
>  	.user_pasid_table = true,
> -	.get_viommu_size = mock_get_viommu_size,
> -	.viommu_init = mock_viommu_init,
> +	.get_viommu_ops = mock_get_viommu_ops,
>  };
>  
>  static void mock_domain_free_nested(struct iommu_domain *domain)
> diff --git a/drivers/iommu/iommufd/viommu.c
> b/drivers/iommu/iommufd/viommu.c index 0d162a3fdc98..2eba1562a704
> 100644 --- a/drivers/iommu/iommufd/viommu.c
> +++ b/drivers/iommu/iommufd/viommu.c
> @@ -33,7 +33,7 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd
> *ucmd) struct iommufd_viommu *viommu;
>  	struct iommufd_device *idev;
>  	struct iommu_device *iommu_dev;
> -	const struct iommu_ops *ops;
> +	const struct iommufd_viommu_ops *ops;
>  	size_t viommu_size;
>  	int rc;
>  
> @@ -49,23 +49,25 @@ int iommufd_viommu_alloc_ioctl(struct
> iommufd_ucmd *ucmd) rc = -EOPNOTSUPP;
>  		goto out_put_idev;
>  	}
> -	ops = iommu_dev->ops;
> -	if (!ops->get_viommu_size || !ops->viommu_init) {
> +	if (!iommu_dev->ops->get_viommu_ops) {
>  		rc = -EOPNOTSUPP;
>  		goto out_put_idev;
>  	}
> -
> -	viommu_size = ops->get_viommu_size(idev->dev, cmd->type);
> -	if (!viommu_size) {
> +	ops = iommu_dev->ops->get_viommu_ops(idev->dev, cmd->type);
> +	if (!ops) {
>  		rc = -EOPNOTSUPP;
>  		goto out_put_idev;
>  	}
> -
>  	/*
> -	 * It is a driver bug for providing a viommu_size smaller
> than the core
> -	 * vIOMMU structure size
> +	 * It is a driver bug to omit the required operations or
> provide a size
> +	 * smaller than the core vIOMMU structure.
>  	 */
> -	if (WARN_ON_ONCE(viommu_size < sizeof(*viommu))) {
> +	if (WARN_ON_ONCE(!ops->get_viommu_size ||
> !ops->viommu_init)) {
> +		rc = -EOPNOTSUPP;
> +		goto out_put_idev;
> +	}
> +	viommu_size = ops->get_viommu_size(idev->dev, cmd->type);
> +	if (!viommu_size || WARN_ON_ONCE(viommu_size <
> sizeof(*viommu))) { rc = -EOPNOTSUPP;
>  		goto out_put_idev;
>  	}
> @@ -104,16 +106,12 @@ int iommufd_viommu_alloc_ioctl(struct
> iommufd_ucmd *ucmd) */
>  	viommu->iommu_dev = iommu_dev;
>  
> -	rc = ops->viommu_init(viommu, hwpt_paging->common.domain,
> +	rc = ops->viommu_init(viommu, idev->dev,
> +			      hwpt_paging->common.domain,
>  			      user_data.len ? &user_data : NULL);
>  	if (rc)
>  		goto out_put_hwpt;
> -
> -	/* It is a driver bug that viommu->ops isn't filled */
> -	if (WARN_ON_ONCE(!viommu->ops)) {
> -		rc = -EOPNOTSUPP;
> -		goto out_put_hwpt;
> -	}
> +	viommu->ops = ops;
>  
>  	cmd->out_viommu_id = viommu->obj.id;
>  	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index ef5043752a36..f27064917df7 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -46,6 +46,7 @@ struct iommu_dma_msi_cookie;
>  struct iommu_fault_param;
>  struct iommufd_ctx;
>  struct iommufd_viommu;
> +struct iommufd_viommu_ops;
>  struct msi_desc;
>  struct msi_msg;
>  
> @@ -669,16 +670,8 @@ __iommu_copy_struct_to_user(const struct
> iommu_user_data *dst_data,
>   *		- IOMMU_DOMAIN_DMA: must use a dma domain
>   *		- 0: use the default setting
>   * @default_domain_ops: the default ops for domains
> - * @get_viommu_size: Get the size of a driver-level vIOMMU structure
> for a given
> - *                   @dev corresponding to @viommu_type. Driver
> should return 0
> - *                   if vIOMMU isn't supported accordingly. It is
> required for
> - *                   driver to use the VIOMMU_STRUCT_SIZE macro to
> sanitize the
> - *                   driver-level vIOMMU structure related to the
> core one
> - * @viommu_init: Init the driver-level struct of an iommufd_viommu
> on a physical
> - *               IOMMU instance @viommu->iommu_dev, as the set of
> virtualization
> - *               resources shared/passed to user space IOMMU
> instance. Associate
> - *               it with a nesting @parent_domain. It is required
> for driver to
> - *               set @viommu->ops pointing to its own viommu_ops
> + * @get_viommu_ops: Return the vIOMMU operations supported by @dev
> for a type.
> + *                  Return NULL if the type is unsupported.
>   * @owner: Driver module providing these ops
>   * @identity_domain: An always available, always attachable identity
>   *                   translation.
> @@ -729,11 +722,8 @@ struct iommu_ops {
>  
>  	int (*def_domain_type)(struct device *dev);
>  
> -	size_t (*get_viommu_size)(struct device *dev,
> -				  enum iommu_viommu_type
> viommu_type);
> -	int (*viommu_init)(struct iommufd_viommu *viommu,
> -			   struct iommu_domain *parent_domain,
> -			   const struct iommu_user_data *user_data);
> +	const struct iommufd_viommu_ops *(*get_viommu_ops)(
> +		struct device *dev, enum iommu_viommu_type
> viommu_type); 
>  	const struct iommu_domain_ops *default_domain_ops;
>  	struct module *owner;
> diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
> index d1fd7888fc91..5f5c67b24134 100644
> --- a/include/linux/iommufd.h
> +++ b/include/linux/iommufd.h
> @@ -148,6 +148,15 @@ struct iommufd_hw_queue {
>  
>  /**
>   * struct iommufd_viommu_ops - vIOMMU specific operations
> + * @get_viommu_size: Get the size of a driver-level vIOMMU structure
> for a given
> + *                   @dev corresponding to @viommu_type. Driver
> should return 0
> + *                   if vIOMMU isn't supported accordingly. It is
> required for
> + *                   driver to use the VIOMMU_STRUCT_SIZE macro to
> sanitize the
> + *                   driver-level vIOMMU structure related to the
> core one
> + * @viommu_init: Init the driver-level struct of an iommufd_viommu
> on a physical
> + *               IOMMU instance @viommu->iommu_dev, as the set of
> virtualization
> + *               resources shared/passed to user space IOMMU
> instance. Associate
> + *               it with a nesting @parent_domain.
>   * @destroy: Clean up all driver-specific parts of an
> iommufd_viommu. The memory
>   *           of the vIOMMU will be free-ed by iommufd core after
> calling this op
>   * @alloc_domain_nested: Allocate a IOMMU_DOMAIN_NESTED on a vIOMMU
> that holds a @@ -190,6 +199,11 @@ struct iommufd_hw_queue {
>   *                      does, it should set it to the
> @hw_queue->destroy pointer */
>  struct iommufd_viommu_ops {
> +	size_t (*get_viommu_size)(struct device *dev,
> +		enum iommu_viommu_type type);
> +	int (*viommu_init)(struct iommufd_viommu *viommu, struct
> device *dev,
> +		struct iommu_domain *parent_domain,
> +		const struct iommu_user_data *user_data);
>  	void (*destroy)(struct iommufd_viommu *viommu);
>  	struct iommu_domain *(*alloc_domain_nested)(
>  		struct iommufd_viommu *viommu, u32 flags,

