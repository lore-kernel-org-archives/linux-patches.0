Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795494115;
	b=Hclq5Xm27kMe/ZIOAJe1/1W+uf4ecmjfuXv90OZfZTIves4a/YpvzP2wdQPq/WrEykN4
	 qXuN7BpJ0uGmCDP2KtaLyYHzfbKt9ELP8HA8bIC/WXrLGngKILQQR5ZMT2KyPvRcTVNpb
	 lxfQFF+8VouC0/jQ8sOX1AOQHoOwKAT8aCcjaP3AGdSwkM+bP76Hx32LtkLrvO7HV2b9F
	 ISyQbbBBwBA9yfz9OdEjX5KQ6nzZTGpItE97iHLcbqWMaluon+Y+PRiL9+gWXjLc3sGGp
	 MJtmTAjC2aZayQhY29fjWqLJP9zOEWuwcl8SU2a8IOu9GAKhGwZmJNm+IVoHj5ivD1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795494115;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=hbVHtz/VdYNG4+MjjYkeMuPNijBtmeBtCtXVJa8U9S8=;
	b=P6otvCTx+40E60xWAQr0bJC/EcbSK7iBTfY1vL68J5F+Qbxd2xnPCPLWIMp08KmnhDU7
	 enu6yvKCqgENGSY9mushv3+rL30rdEvZ23WQjA/v7ndaCC/T3lrFD3xmWD6uhvSUnxCTO
	 UTFXfn17TKvtDukksT39Fbw8IpJ4fuDNCweuEQg14i4925OD4Rh8uiU9tObN+X3xElUpC
	 fGQJs4iqdVoQvU9eO2vmJXrZ/G3KCYCEQo3hKJbxF2KwHGGPv9Ib0mt6KvwaLzX3ayn2p
	 MGU7MfIiL9rq14ETl0jYLkO6MgpysyLpOl6Ie33Wy3A+I+Xv9Jul7OrPijvB3hu/FtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h8Ws8tl1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C55606A31E;
	Tue, 24 Nov 2026 04:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h8Ws8tl1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C901F000C6;
	Tue, 24 Nov 2026 04:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795494115;
	bh=hbVHtz/VdYNG4+MjjYkeMuPNijBtmeBtCtXVJa8U9S8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=h8Ws8tl1T+bdpKBk1d2DZoqHGkqwkaVFD9PJ2bQmIN0sXVsrZPP5Dpfk9SsatQCYi
	 ejhnA9ix9Ge6tkTCbNK/mI9KuER/1ttGP7k/XDy9PynlBs93PrBE5DdvwhRzz5y/c6
	 53I8CeJk2nJfa7/Tbjq3HlUx0/On3fJyvYhUreeHd/nwE3pxxD1uwHwQpyXQ3sapmU
	 1FuUrvGWrKLgZj5qZ63wNo69Bsf9CpJrfm88moDzevtidQsa1FvZOkKPK6reP4mRnZ
	 baIA3//cUFGDVUkN0YSqh3lbjDPHWLZFcEKKsga1Hy2MX/MlBG9Ug1CAALFKXGOjCJ
	 SaluYIuRuFRMQ==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Jacob Pan <jacob.pan@linux.microsoft.com>
Cc: linux-coco@lists.linux.dev, Alex Williamson <alex@shazbot.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Krishna Reddy <vdumpa@nvidia.com>,
	Lukas Wunner <lukas@wunner.de>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Steven Price <steven.price@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	iommu@lists.linux.dev,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
	linux-tegra@vger.kernel.org, patches@lists.linux.dev,
	jacob.pan@linux.microsoft.com
Subject: Re: [PATCH v9 10/13] iommufd/viommu: Allow PCI TSM backends to
 provide vIOMMU operations
In-Reply-To: <20261119115041.00007215@linux.microsoft.com>
References: <20261116081935.85372-1-aneesh.kumar@kernel.org>
 <20261116081935.85372-11-aneesh.kumar@kernel.org>
 <20261119115041.00007215@linux.microsoft.com>
Date: Tue, 24 Nov 2026 09:51:40 +0530
Message-ID: <yq5aqzgac10r.fsf@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Jacob Pan <jacob.pan@linux.microsoft.com> writes:

> Hi Aneesh,
>
> On Mon, 16 Nov 2026 13:49:32 +0530
> "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> wrote:
>
>> In confidential-computing configurations, a vIOMMU may be implemented
>> by a TSM driver rather than by the physical IOMMU driver. Such an
>> implementation also needs the TSM identity when creating and
>> validating vdevices.
>> 
>> Allow VIOMMU_ALLOC to first query the TSM associated with the target
>> PCI device for vIOMMU operations. Fall back to the physical IOMMU
>> driver when the TSM does not provide operations for the requested
>> vIOMMU type.
>> 
>> Resolve the PCI TSM association under pci_tsm_rwsem, take a TSM device
>> reference, and pin the module providing the operations. Store the TSM
>> device in the vIOMMU. Release the device reference and module pin on
>> allocation failure, fallback to the physical IOMMU driver, or vIOMMU
>> destruction. Drop the device reference before releasing the module
>> pin, since the final put may call into the backend module.
>> 
>> The device reference preserves the TSM allocation. Backends providing
>> vIOMMU operations must not unregister their TSM while the module is
>> pinned, since the reference does not prevent backend resource
>> teardown.
>> 
>> Cc: Jason Gunthorpe <jgg@ziepe.ca>
>> Cc: Kevin Tian <kevin.tian@intel.com>
>> Cc: Joerg Roedel <joro@8bytes.org>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Robin Murphy <robin.murphy@arm.com>
>> Cc: Bjorn Helgaas <bhelgaas@google.com>
>> Cc: Alexey Kardashevskiy <aik@amd.com>
>> Cc: Lukas Wunner <lukas@wunner.de>
>> Cc: Xu Yilun <yilun.xu@linux.intel.com>
>> Cc: iommu@lists.linux.dev
>> Cc: linux-pci@vger.kernel.org
>> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
>> ---
>>  drivers/iommu/iommufd/viommu.c | 35 +++++++++++++++++++++++++++-----
>>  drivers/pci/tsm/core.c         | 22 ++++++++++++++++++++
>>  drivers/virt/coco/tsm-core.c   | 37
>> ++++++++++++++++++++++++++++++++++ include/linux/iommufd.h        |
>> 2 ++ include/linux/pci-tsm.h        | 24 ++++++++++++++++++++++
>>  include/linux/tsm.h            | 25 +++++++++++++++++++++++
>>  6 files changed, 140 insertions(+), 5 deletions(-)
>> 
>> diff --git a/drivers/iommu/iommufd/viommu.c
>> b/drivers/iommu/iommufd/viommu.c index 2eba1562a704..7e74d3992ae4
>> 100644 --- a/drivers/iommu/iommufd/viommu.c
>> +++ b/drivers/iommu/iommufd/viommu.c
>> @@ -15,6 +15,8 @@ void iommufd_viommu_destroy(struct iommufd_object
>> *obj) 
>>  	if (viommu->ops && viommu->ops->destroy)
>>  		viommu->ops->destroy(viommu);
>> +	if (viommu->tsm_dev)
>> +		tsm_put_device(viommu->tsm_dev);
>>  	refcount_dec(&viommu->hwpt->common.obj.users);
>>  	if (viommu->kvm_file)
>>  		fput(viommu->kvm_file);
>> @@ -30,6 +32,7 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd
>> *ucmd) .len = cmd->data_len,
>>  	};
>>  	struct iommufd_hwpt_paging *hwpt_paging;
>> +	struct tsm_dev *tsm_dev = NULL;
>>  	struct iommufd_viommu *viommu;
>>  	struct iommufd_device *idev;
>>  	struct iommu_device *iommu_dev;
>> @@ -49,15 +52,33 @@ int iommufd_viommu_alloc_ioctl(struct
>> iommufd_ucmd *ucmd) rc = -EOPNOTSUPP;
>>  		goto out_put_idev;
>>  	}
>> -	if (!iommu_dev->ops->get_viommu_ops) {
>> -		rc = -EOPNOTSUPP;
>> +	tsm_dev = tsm_get_device(idev->dev);
>> +	if (IS_ERR(tsm_dev)) {
>> +		rc = PTR_ERR(tsm_dev);
>> +		tsm_dev = NULL;
>>  		goto out_put_idev;
>>  	}
>> -	ops = iommu_dev->ops->get_viommu_ops(idev->dev, cmd->type);
>> -	if (!ops) {
>> -		rc = -EOPNOTSUPP;
>> +	ops = tsm_dev ? tsm_viommu_get_ops(tsm_dev, idev->dev,
>> cmd->type) : NULL;
>> +	if (IS_ERR(ops)) {
>> +		rc = PTR_ERR(ops);
>>  		goto out_put_idev;
>>  	}
>> +	if (!ops) {
>> +		if (tsm_dev) {
>> +			tsm_put_device(tsm_dev);
> nit: Since tsm_get_device() may legitimately return NULL, maybe you can
> make tsm_put_device NULL safe, then you can avoid this check and other
> places.
>
>
>> +			tsm_dev = NULL;
> nit: maybe a candidate for cleanup helper? if tsm_put_device is null
> safe. then:
>            tsm_put_device(no_free_ptr(tsm_dev));
>

I will see whether both suggestions can be added.

>
>> +		}
>> +		if (!iommu_dev->ops->get_viommu_ops) {
>> +			rc = -EOPNOTSUPP;
>> +			goto out_put_idev;
>> +		}
>> +		ops = iommu_dev->ops->get_viommu_ops(idev->dev,
>> cmd->type);
>> +		if (!ops) {
>> +			rc = -EOPNOTSUPP;
>> +			goto out_put_idev;
>> +		}
>> +	}
>> +
>>  	/*
>>  	 * It is a driver bug to omit the required operations or
>> provide a size
>>  	 * smaller than the core vIOMMU structure.
>> @@ -95,6 +116,8 @@ int iommufd_viommu_alloc_ioctl(struct iommufd_ucmd
>> *ucmd) viommu->kvm_file = get_file(idev->kvm_file);
>>  	viommu->type = cmd->type;
>>  	viommu->ictx = ucmd->ictx;
>> +	viommu->tsm_dev = tsm_dev;
>> +	tsm_dev = NULL;
>    viommu->tsm_dev = no_free_ptr(tsm_dev)
>
>>  	viommu->hwpt = hwpt_paging;
>>  	refcount_inc(&viommu->hwpt->common.obj.users);
>>  	INIT_LIST_HEAD(&viommu->veventqs);
>> @@ -119,6 +142,8 @@ int iommufd_viommu_alloc_ioctl(struct
>> iommufd_ucmd *ucmd) out_put_hwpt:
>>  	iommufd_put_object(ucmd->ictx, &hwpt_paging->common.obj);
>>  out_put_idev:
>> +	if (tsm_dev)
>> +		tsm_put_device(tsm_dev);
> ditto, can be unconditional.
>
>>  	iommufd_put_object(ucmd->ictx, &idev->obj);
>>  	return rc;
>>  }
>> diff --git a/drivers/pci/tsm/core.c b/drivers/pci/tsm/core.c
>> index 8f0e5af808a5..4107ff443228 100644
>> --- a/drivers/pci/tsm/core.c
>> +++ b/drivers/pci/tsm/core.c
>> @@ -9,6 +9,8 @@
>>  #define dev_fmt(fmt) "PCI/TSM: " fmt
>>  
>>  #include <linux/bitfield.h>
>> +#include <linux/iommufd.h>
>> +#include <linux/module.h>
>>  #include <linux/pci.h>
>>  #include <linux/pci-doe.h>
>>  #include <linux/pci-tsm.h>
>> @@ -36,6 +38,26 @@ static const struct pci_tsm_ops
>> *to_pci_tsm_ops(struct pci_tsm *tsm) return tsm->tsm_dev->pci_ops;
>>  }
>>  
>> +struct tsm_dev *pci_tsm_get_device(struct pci_dev *pdev)
>> +{
>> +	const struct pci_tsm_ops *ops;
>> +	struct tsm_dev *tsm_dev;
>> +
>> +	guard(rwsem_read)(&pci_tsm_rwsem);
>> +	if (!pdev->tsm)
>> +		return NULL;
>> +
>> +	tsm_dev = pdev->tsm->tsm_dev;
>> +	ops = tsm_dev->pci_ops;
>> +	if (!ops->viommu_get_ops)
>> +		return NULL;
>> +	if (!try_module_get(ops->owner))
>> +		return ERR_PTR(-ENODEV);
>> +	get_device(&tsm_dev->dev);
> what if tsm_unregister() is called directly? without protection from
> tsm_dev->users, unregister can succeed tearing down backend while this
> reference is held.
>
> For bisectable result, maybe you can move tsm_get() and wait patch
> before this one?
>

But, the current code calls tsm_unregister() only during module
unload, so this cannot happen.

>
>> +	return tsm_dev;
>> +}
>> +EXPORT_SYMBOL_GPL(pci_tsm_get_device);

 [ ... 201 lines skipped ... ] 

-aneesh
