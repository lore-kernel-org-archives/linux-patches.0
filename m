Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795117860;
	b=bnLvQLPIpkurSR6AsGl4DF0/t8A699tPO2JyZ9YW9B1teYDNKrFJGRKsc/1ULJXyRoxE
	 m5Sb8FLUNfs6JLdoQVYPdZkkSUTFTFKUBYAVNv6PCFr01rQub95v7+8zm6MJG4E6uJRl1
	 Tpdqgrh9un0+h6l4J0MEgSVdiseqyD3Ud+TTVWvmB9ShN9idp4rTgzFWlVvywcL1cErXr
	 8nL2+TGlPGEK1MNzEcUYobuC+gX9o9pJw3x8IQdjggz6x7OWKu4rTB9/4yg4OIw5Gofsp
	 FZsK3wmGB3VQpLZ48jOWLHoyS3bpeeb6CE52Ii55NrcflCz8Ekwe8Px9GAPG/sGbWYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795117860;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:In-Reply-To:References:Organization:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=TzPHAIt7G9f+FpKmfm1zo12EV1nvo35s0k9nQGlDh38=;
	b=mQXZdI+zXepLez+uZPPDSgb0e2LXRyWEyeDXlxMHBRMgwpGd43sLcg5ZgTKqBxr8ORhb
	 qIQOBNB77zSLBSGZUdZt8U1ZiUgAHcUMtdMihzI78N1QqWqg+l1lwZVjA/ymsqgBLE5K1
	 0D+Up9yWvZEb6f26BKCvBmae9k+TgrHHqlxd0WdC1lqv4d1ga2FqOI7a8GR8ehWcKjuil
	 Fa1aJt7ZQxcX204WfwIUNjPJArEeQSEG13A+dhZxIrsnuJCTTddZismMzALmLq7NYJ338
	 rNEm4rbqtvbeLyhqkCx70ktLF5XEYJimdXFADam6P293C0GBZRpNzWMYinLeBACkx/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=lezu00V8;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23C19606A331;
	Thu, 19 Nov 2026 19:51:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23C19606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=lezu00V8
Received: from localhost (unknown [4.194.122.170])
	by linux.microsoft.com (Postfix) with ESMTPSA id B05A720B7166;
	Thu, 19 Nov 2026 11:50:44 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B05A720B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1795117857;
	bh=TzPHAIt7G9f+FpKmfm1zo12EV1nvo35s0k9nQGlDh38=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=lezu00V8AX0KS8edVg+tWvDvdbLFzEAt0p2MIZEeobg6bgTiqM6svd+xkQrzwEz9J
	 qsN5+IyRULTA/PqNSTtGWNxaKVTe5ERmTVPeYJ+R4+fvRAhesFfV2Kzwr1UVqC4uTy
	 hBI7zCH6TnQ9X994l9o2Cu683jOlx8PWvSe0RWdY=
Date: Thu, 19 Nov 2026 11:50:41 -0800
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
Subject: Re: [PATCH v9 10/13] iommufd/viommu: Allow PCI TSM backends to
 provide vIOMMU operations
Message-ID: <20261119115041.00007215@linux.microsoft.com>
In-Reply-To: <20261116081935.85372-11-aneesh.kumar@kernel.org>
References: <20261116081935.85372-1-aneesh.kumar@kernel.org>
	<20261116081935.85372-11-aneesh.kumar@kernel.org>
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

On Mon, 16 Nov 2026 13:49:32 +0530
"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> wrote:

> In confidential-computing configurations, a vIOMMU may be implemented
> by a TSM driver rather than by the physical IOMMU driver. Such an
> implementation also needs the TSM identity when creating and
> validating vdevices.
> 
> Allow VIOMMU_ALLOC to first query the TSM associated with the target
> PCI device for vIOMMU operations. Fall back to the physical IOMMU
> driver when the TSM does not provide operations for the requested
> vIOMMU type.
> 
> Resolve the PCI TSM association under pci_tsm_rwsem, take a TSM device
> reference, and pin the module providing the operations. Store the TSM
> device in the vIOMMU. Release the device reference and module pin on
> allocation failure, fallback to the physical IOMMU driver, or vIOMMU
> destruction. Drop the device reference before releasing the module
> pin, since the final put may call into the backend module.
> 
> The device reference preserves the TSM allocation. Backends providing
> vIOMMU operations must not unregister their TSM while the module is
> pinned, since the reference does not prevent backend resource
> teardown.
> 
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Will Deacon <will@kernel.org>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Alexey Kardashevskiy <aik@amd.com>
> Cc: Lukas Wunner <lukas@wunner.de>
> Cc: Xu Yilun <yilun.xu@linux.intel.com>
> Cc: iommu@lists.linux.dev
> Cc: linux-pci@vger.kernel.org
> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> ---
>  drivers/iommu/iommufd/viommu.c | 35 +++++++++++++++++++++++++++-----
>  drivers/pci/tsm/core.c         | 22 ++++++++++++++++++++
>  drivers/virt/coco/tsm-core.c   | 37
> ++++++++++++++++++++++++++++++++++ include/linux/iommufd.h        |
> 2 ++ include/linux/pci-tsm.h        | 24 ++++++++++++++++++++++
>  include/linux/tsm.h            | 25 +++++++++++++++++++++++
>  6 files changed, 140 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/iommu/iommufd/viommu.c
> b/drivers/iommu/iommufd/viommu.c index 2eba1562a704..7e74d3992ae4
> 100644 --- a/drivers/iommu/iommufd/viommu.c
> +++ b/drivers/iommu/iommufd/viommu.c
> @@ -15,6 +15,8 @@ void iommufd_viommu_destroy(struct iommufd_object
> *obj) 
>  	if (viommu->ops && viommu->ops->destroy)
>  		viommu->ops->destroy(viommu);
> +	if (viommu->tsm_dev)
> +		tsm_put_device(viommu->tsm_dev);
>  	refcount_dec(&viommu->hwpt->common.obj.users);
>  	if (viommu->kvm_file)
>  		fput(viommu->kvm_file);
> @@ -30,6 +32,7 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd
> *ucmd) .len = cmd->data_len,
>  	};
>  	struct iommufd_hwpt_paging *hwpt_paging;
> +	struct tsm_dev *tsm_dev = NULL;
>  	struct iommufd_viommu *viommu;
>  	struct iommufd_device *idev;
>  	struct iommu_device *iommu_dev;
> @@ -49,15 +52,33 @@ int iommufd_viommu_alloc_ioctl(struct
> iommufd_ucmd *ucmd) rc = -EOPNOTSUPP;
>  		goto out_put_idev;
>  	}
> -	if (!iommu_dev->ops->get_viommu_ops) {
> -		rc = -EOPNOTSUPP;
> +	tsm_dev = tsm_get_device(idev->dev);
> +	if (IS_ERR(tsm_dev)) {
> +		rc = PTR_ERR(tsm_dev);
> +		tsm_dev = NULL;
>  		goto out_put_idev;
>  	}
> -	ops = iommu_dev->ops->get_viommu_ops(idev->dev, cmd->type);
> -	if (!ops) {
> -		rc = -EOPNOTSUPP;
> +	ops = tsm_dev ? tsm_viommu_get_ops(tsm_dev, idev->dev,
> cmd->type) : NULL;
> +	if (IS_ERR(ops)) {
> +		rc = PTR_ERR(ops);
>  		goto out_put_idev;
>  	}
> +	if (!ops) {
> +		if (tsm_dev) {
> +			tsm_put_device(tsm_dev);
nit: Since tsm_get_device() may legitimately return NULL, maybe you can
make tsm_put_device NULL safe, then you can avoid this check and other
places.

> +			tsm_dev = NULL;
nit: maybe a candidate for cleanup helper? if tsm_put_device is null
safe. then:
           tsm_put_device(no_free_ptr(tsm_dev));

> +		}
> +		if (!iommu_dev->ops->get_viommu_ops) {
> +			rc = -EOPNOTSUPP;
> +			goto out_put_idev;
> +		}
> +		ops = iommu_dev->ops->get_viommu_ops(idev->dev,
> cmd->type);
> +		if (!ops) {
> +			rc = -EOPNOTSUPP;
> +			goto out_put_idev;
> +		}
> +	}
> +
>  	/*
>  	 * It is a driver bug to omit the required operations or
> provide a size
>  	 * smaller than the core vIOMMU structure.
> @@ -95,6 +116,8 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd
> *ucmd) viommu->kvm_file = get_file(idev->kvm_file);
>  	viommu->type = cmd->type;
>  	viommu->ictx = ucmd->ictx;
> +	viommu->tsm_dev = tsm_dev;
> +	tsm_dev = NULL;
   viommu->tsm_dev = no_free_ptr(tsm_dev)

>  	viommu->hwpt = hwpt_paging;
>  	refcount_inc(&viommu->hwpt->common.obj.users);
>  	INIT_LIST_HEAD(&viommu->veventqs);
> @@ -119,6 +142,8 @@ int iommufd_viommu_alloc_ioctl(struct
> iommufd_ucmd *ucmd) out_put_hwpt:
>  	iommufd_put_object(ucmd->ictx, &hwpt_paging->common.obj);
>  out_put_idev:
> +	if (tsm_dev)
> +		tsm_put_device(tsm_dev);
ditto, can be unconditional.

>  	iommufd_put_object(ucmd->ictx, &idev->obj);
>  	return rc;
>  }
> diff --git a/drivers/pci/tsm/core.c b/drivers/pci/tsm/core.c
> index 8f0e5af808a5..4107ff443228 100644
> --- a/drivers/pci/tsm/core.c
> +++ b/drivers/pci/tsm/core.c
> @@ -9,6 +9,8 @@
>  #define dev_fmt(fmt) "PCI/TSM: " fmt
>  
>  #include <linux/bitfield.h>
> +#include <linux/iommufd.h>
> +#include <linux/module.h>
>  #include <linux/pci.h>
>  #include <linux/pci-doe.h>
>  #include <linux/pci-tsm.h>
> @@ -36,6 +38,26 @@ static const struct pci_tsm_ops
> *to_pci_tsm_ops(struct pci_tsm *tsm) return tsm->tsm_dev->pci_ops;
>  }
>  
> +struct tsm_dev *pci_tsm_get_device(struct pci_dev *pdev)
> +{
> +	const struct pci_tsm_ops *ops;
> +	struct tsm_dev *tsm_dev;
> +
> +	guard(rwsem_read)(&pci_tsm_rwsem);
> +	if (!pdev->tsm)
> +		return NULL;
> +
> +	tsm_dev = pdev->tsm->tsm_dev;
> +	ops = tsm_dev->pci_ops;
> +	if (!ops->viommu_get_ops)
> +		return NULL;
> +	if (!try_module_get(ops->owner))
> +		return ERR_PTR(-ENODEV);
> +	get_device(&tsm_dev->dev);
what if tsm_unregister() is called directly? without protection from
tsm_dev->users, unregister can succeed tearing down backend while this
reference is held.

For bisectable result, maybe you can move tsm_get() and wait patch
before this one?

> +	return tsm_dev;
> +}
> +EXPORT_SYMBOL_GPL(pci_tsm_get_device);
> +
>  static inline bool is_dsm(struct pci_dev *pdev)
>  {
>  	return pdev->tsm && pdev->tsm->dsm_dev == pdev;
> diff --git a/drivers/virt/coco/tsm-core.c
> b/drivers/virt/coco/tsm-core.c index 181d6114086f..766f4ad67ed7 100644
> --- a/drivers/virt/coco/tsm-core.c
> +++ b/drivers/virt/coco/tsm-core.c
> @@ -9,6 +9,16 @@
>  #include <linux/cleanup.h>
>  #include <linux/pci-tsm.h>
>  
> +/* The caller must hold a tsm_get_device() reference for the entire
> use. */ +const struct iommufd_viommu_ops *tsm_viommu_get_ops(struct
> tsm_dev *tsm_dev,
> +		struct device *dev, enum iommu_viommu_type type)
> +{
> +	if (!tsm_dev->pci_ops->viommu_get_ops)
> +		return NULL;
> +	return tsm_dev->pci_ops->viommu_get_ops(dev, type);
> +}
> +EXPORT_SYMBOL_GPL(tsm_viommu_get_ops);
> +
>  static void tsm_release(struct device *);
>  static const struct class tsm_class = {
>  	.name		= "tsm",
> @@ -16,6 +26,33 @@ static const struct class tsm_class = {
>  };
>  static DEFINE_IDA(tsm_ida);
>  
> +/**
> + * tsm_get_device() - Pin the TSM attached to a device
> + * @dev: device whose TSM is to be pinned
> + *
> + * A successful lookup takes a TSM device reference and pins the
> backend
> + * module. Release both with tsm_put_device(). Backends providing
> vIOMMU
> + * operations must not unregister their TSM independently of module
> unload.
> + * Return: NULL if no vIOMMU-capable TSM is attached, an error if
> the module
> + * cannot be pinned, or the TSM device associated with the pinned
> backend.
> + */
> +struct tsm_dev *tsm_get_device(struct device *dev)
> +{
> +	if (!dev_is_pci(dev))
> +		return NULL;
> +	return pci_tsm_get_device(to_pci_dev(dev));
> +}
> +EXPORT_SYMBOL_GPL(tsm_get_device);
> +
> +void tsm_put_device(struct tsm_dev *tsm_dev)
> +{
> +	struct module *owner = tsm_dev->pci_ops->owner;
> +
> +	put_device(&tsm_dev->dev);
> +	module_put(owner);
> +}
> +EXPORT_SYMBOL_GPL(tsm_put_device);
> +
>  static int match_id(struct device *dev, const void *data)
>  {
>  	struct tsm_dev *tsm_dev = container_of(dev, struct tsm_dev,
> dev); diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
> index 5f5c67b24134..a4b29915d0ca 100644
> --- a/include/linux/iommufd.h
> +++ b/include/linux/iommufd.h
> @@ -23,6 +23,7 @@ struct iommufd_access;
>  struct iommufd_ctx;
>  struct iommufd_device;
>  struct iommufd_viommu_ops;
> +struct tsm_dev;
>  struct page;
>  
>  enum iommufd_object_type {
> @@ -104,6 +105,7 @@ struct iommufd_viommu {
>  	struct iommu_device *iommu_dev;
>  	struct iommufd_hwpt_paging *hwpt;
>  	struct file *kvm_file;
> +	struct tsm_dev *tsm_dev;
>  
>  	const struct iommufd_viommu_ops *ops;
>  
> diff --git a/include/linux/pci-tsm.h b/include/linux/pci-tsm.h
> index 1458935234a4..27a76aeedf50 100644
> --- a/include/linux/pci-tsm.h
> +++ b/include/linux/pci-tsm.h
> @@ -3,7 +3,10 @@
>  #define __PCI_TSM_H
>  #include <linux/mutex.h>
>  #include <linux/pci.h>
> +#include <uapi/linux/iommufd.h>
>  
> +struct iommufd_viommu_ops;
> +struct module;
>  struct pci_tsm;
>  struct pci_tsm_context;
>  struct tsm_dev;
> @@ -16,12 +19,27 @@ struct tsm_dev;
>   * @devsec_ops: Lock, unlock, and interrogate the security state of
> the
>   *		function via the platform TSM (typically virtual
> function
>   *		operations).
> + * @viommu_get_ops: Return operations for a supported TSM-owned
> vIOMMU type,
> + *		  or NULL if unsupported
> + * @owner: Module providing the vIOMMU operations, if built as a
> module
> + *
> + * The vIOMMU owner holds a TSM device reference and pins the
> backend module
> + * before querying @viommu_get_ops, releasing both after vIOMMU
> destruction.
> + * A backend providing this callback must not unregister its TSM
> while the
> + * module is pinned.
>   *
>   * This operations are mutually exclusive either a tsm_dev instance
>   * manages physical link properties or it manages function security
>   * states like TDISP lock/unlock.
> + *
> + * @viommu_get_ops runs with the backend module pinned. The PCI/TSM
> + * association is checked during acquisition under pci_tsm_rwsem.
>   */
>  struct pci_tsm_ops {
> +	struct module *owner;
> +	const struct iommufd_viommu_ops *(*viommu_get_ops)(
> +		struct device *dev, enum iommu_viommu_type type);
> +
>  	/*
>  	 * struct pci_tsm_link_ops - Manage physical link and the
> TSM/DSM session
>  	 * @probe: establish context with the TSM (allocate / wrap
> 'struct @@ -151,6 +169,7 @@ struct pci_tsm_pf0
> *pci_tsm_context_pf0(struct pci_tsm_context *context); struct pci_dev
> *pci_tsm_context_dsm_dev(struct pci_tsm_context *context); bool
> pci_tsm_context_match_device(struct pci_tsm_context *context, struct
> pci_dev *pdev); +struct tsm_dev *pci_tsm_get_device(struct pci_dev
> *pdev); #else
>  static inline int pci_tsm_register(struct tsm_dev *tsm_dev)
>  {
> @@ -165,6 +184,11 @@ static inline bool pci_tsm_is_configured(struct
> pci_dev *pdev) return false;
>  }
>  
> +static inline struct tsm_dev *pci_tsm_get_device(struct pci_dev
> *pdev) +{
> +	return NULL;
> +}
> +
>  static inline struct pci_tsm_context *
>  pci_tsm_context_get(struct pci_dev *pdev, struct tsm_dev *tsm_dev)
>  {
> diff --git a/include/linux/tsm.h b/include/linux/tsm.h
> index 19dedf971f14..3d5286aeaa42 100644
> --- a/include/linux/tsm.h
> +++ b/include/linux/tsm.h
> @@ -110,6 +110,8 @@ struct tsm_report_ops {
>  };
>  
>  struct pci_tsm_ops;
> +struct iommufd_viommu_ops;
> +
>  struct tsm_dev {
>  	struct device dev;
>  	int id;
> @@ -124,4 +126,27 @@ int tsm_report_unregister(const struct
> tsm_report_ops *ops); struct tsm_dev *tsm_register(struct device
> *parent, struct pci_tsm_ops *ops); void tsm_unregister(struct tsm_dev
> *tsm_dev); struct tsm_dev *find_tsm_dev(int id);
> +
> +#ifdef CONFIG_TSM
> +struct tsm_dev *tsm_get_device(struct device *dev);
> +void tsm_put_device(struct tsm_dev *tsm_dev);
> +const struct iommufd_viommu_ops *tsm_viommu_get_ops(struct tsm_dev
> *tsm_dev,
> +		struct device *dev, enum iommu_viommu_type type);
> +#else
> +static inline struct tsm_dev *tsm_get_device(struct device *dev)
> +{
> +	return NULL;
> +}
> +
> +static inline void tsm_put_device(struct tsm_dev *tsm_dev)
> +{
> +}
> +
> +static inline const struct iommufd_viommu_ops *
> +tsm_viommu_get_ops(struct tsm_dev *tsm_dev, struct device *dev,
> +		enum iommu_viommu_type type)
> +{
> +	return NULL;
> +}
> +#endif
>  #endif /* __TSM_H */
With the above addressed,

Reviewed-by: Jacob Pan <jacob.pan@linux.microsoft.com>
