Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795492639;
	b=KfpqOmlMuVo7WUyLrr71mVYVwtHIzfBnwoM1n9QK7Oa4hKEbb5qdDvcvdr5t0Zs2lDsC
	 jWL2kFzK6Qp/+qSEjyNrsK4R/g4oIsLZAMHeQUKAl2NPPwMUuKAGJ1TItdgX64P/nc81x
	 pRaaqi3kxl6zKS1UXFHz8/qwlC0FDu8KE0SZawDkVMI2QG2tYsuCuNN5M6mS+IUYFeJRx
	 15aVKVJqqL1DInGyj1y0ImjVWTAvQc/r8cX2asC3ApoOndSoPTCFLfMeK0W9BHy6vnThS
	 fymM98L8DMcaI7Jngds8tUGCfseVFluIAXSgXgnE9ObcvU2NZWxt8Qtg+Sa0SNW89pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795492639;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=I0mp7A61esK3VrRBd+nFXF5BVs7NKqG01QIp73dC2D0=;
	b=gUrru3VX974M9/swVaSlm0g+U5xAmwUmZTll2HOawFXngMAfuhOrWFZHjBBAwWd3c1Sk
	 +3SpjBCcfGFZfjid/ATkHTj/LkO4EgrQdGkMKUO/fFP9cpk8a10zpxpid/IppRp+XRCL5
	 0m5/xqwsXBPSTN/O+Yxm/crpt6MQQnwBQLr0zCNv0RGmjfawwp+sC0K7I9eEZgJBtfKq4
	 whc6RQryCW9Aj6FpVR5PuoaZnpkxiIeEDl99fUOd332GXYnRbAMhgsXVczvW4qnulHS2d
	 g/H+CXi8IGR/1xgY+oQYMn/Mu8ZK4JPktjofdVseoHiNR4dLArHc4D16ZgaiRXP3wHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jeLjHV1j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6EE9606A68B;
	Tue, 24 Nov 2026 03:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jeLjHV1j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A54F1F000D4;
	Tue, 24 Nov 2026 03:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795492639;
	bh=I0mp7A61esK3VrRBd+nFXF5BVs7NKqG01QIp73dC2D0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=jeLjHV1j+0TpVU9Hk9tvCDsB72vEt9R80xfmbQ28wipdFEcuw6wQbvCmRZBIyNRw5
	 VjXgLsKhqp9HdWjZkm2fnw266bar7hbn3O6AmxR5GAchqwTS8coNXKDdhmQCK7fmsX
	 RMAOb6oPASFHBdDKsAM+LPOzPVnQv4fq/vyIAndrCq6ElK7KYlTeOPUtDjwdv0cuMA
	 ddT0isU7gLNybgIWxe2KLs67EAeXaGl991V9GBvvPIBQR4LuP2prMbjv6oXhcOcdPI
	 HSd78mtysn1gzSGQ++YEoyBQkrvxx7YmijwiB5IEtAdHiK4gLdy5EKA/+qrpu/pE4n
	 xIpvvc1TnmASA==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: linux-coco@lists.linux.dev, Alex Williamson <alex@shazbot.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
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
	Ashish Kalra <ashish.kalra@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	iommu@lists.linux.dev,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
	linux-tegra@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v9 02/13] virt: coco: tsm: Remove the device from lookup
 before PCI teardown
In-Reply-To: <av1JFH8W63T37bK6@yilunxu-OptiPlex-7050>
References: <20261116081935.85372-1-aneesh.kumar@kernel.org>
 <20261116081935.85372-3-aneesh.kumar@kernel.org>
 <av1JFH8W63T37bK6@yilunxu-OptiPlex-7050>
Date: Tue, 24 Nov 2026 09:27:04 +0530
Message-ID: <yq5a33sqdgq7.fsf@kernel.org>
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

Xu Yilun <yilun.xu@linux.intel.com> writes:

> On Mon, Nov 16, 2026 at 01:49:24PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> PCI connect looks up a TSM by ID under pci_tsm_rwsem. Previously,
>> pci_tsm_unregister() released that lock after tearing down PCI state
>> while the TSM was still in the class lookup. A racing connect could then
>> attach a new PCI context that the teardown would never see.
>> 
>> Remove the device from the class lookup first, then take the PCI write
>> lock to drain in-flight operations and destroy their contexts. Drop the
>> device reference only after PCI teardown completes.
>> 
>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
>> Cc: Alexey Kardashevskiy <aik@amd.com>
>> Cc: Jason Gunthorpe <jgg@ziepe.ca>
>> Cc: Lukas Wunner <lukas@wunner.de>
>> Cc: linux-coco@lists.linux.dev
>> Fixes: 3225f52cde56 ("PCI/TSM: Establish Secure Sessions and Link Encryption")
>> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
>> ---
>>  drivers/virt/coco/tsm-core.c | 20 +++++++++++++-------
>>  1 file changed, 13 insertions(+), 7 deletions(-)
>> 
>> diff --git a/drivers/virt/coco/tsm-core.c b/drivers/virt/coco/tsm-core.c
>> index 03894c5663f1..57db3f14cf46 100644
>> --- a/drivers/virt/coco/tsm-core.c
>> +++ b/drivers/virt/coco/tsm-core.c
>> @@ -56,23 +56,22 @@ static struct tsm_dev *alloc_tsm_dev(struct device *parent)
>>  	return no_free_ptr(tsm_dev);
>>  }
>>  
>> -static struct tsm_dev *tsm_register_pci_or_reset(struct tsm_dev *tsm_dev,
>> -						 struct pci_tsm_ops *pci_ops)
>> +static int __tsm_register(struct tsm_dev *tsm_dev, struct pci_tsm_ops *pci_ops)
>>  {
>>  	int rc;
>>  
>>  	tsm_dev->pci_ops = pci_ops;
>>  	rc = pci_tsm_register(tsm_dev);
>>  	if (rc) {
>> +		tsm_dev->pci_ops = NULL;
>
> Previous comment shows this can't solve any racing connect problem.
> And with your next patch, the racing connect is solved. So I think
> remove it.
>


I don't follow. This only undoes the changes made before
pci_tsm_register() on the error path.

>
>>  		dev_err(tsm_dev->dev.parent,
>>  			"PCI/TSM registration failure: %d\n", rc);
>> -		device_unregister(&tsm_dev->dev);
>> -		return ERR_PTR(rc);
>> +		return rc;
>>  	}
>>  
>>  	/* Notify TSM userspace that PCI/TSM operations are now possible */
>>  	kobject_uevent(&tsm_dev->dev.kobj, KOBJ_CHANGE);
>> -	return tsm_dev;
>> +	return 0;
>
> I really don't think we need this wrapper. In next patch we move uevent
> out, so this wrapper is just:
>
> 	tsm_dev->pci_ops = pci_ops;
> 	pci_tsm_register();
>
> Open code it, as Alexey and I suggest before. All kinds of xxx_tsm_register()
> are really confusing.
>

I do that in the next patch, after moving the kobject_uevent() call out
of the helper.

>
>>  }
>>  
>>  struct tsm_dev *tsm_register(struct device *parent, struct pci_tsm_ops *pci_ops)
>> @@ -96,15 +95,22 @@ struct tsm_dev *tsm_register(struct device *parent, struct pci_tsm_ops *pci_ops)
>>  	if (rc)
>>  		return ERR_PTR(rc);
>>  
>> -	return tsm_register_pci_or_reset(no_free_ptr(tsm_dev), pci_ops);
>> +	rc = __tsm_register(tsm_dev, pci_ops);
>> +	if (rc) {
>> +		device_del(dev);
>> +		return ERR_PTR(rc);
>> +	}
>> +	return no_free_ptr(tsm_dev);
>
> I think none of the above changes belongs to this patch. They don't
> solve any problem mentioned in the changelog.
>
> They belong to the next patch.
>


We are replacing device_unregister() with device_del() followed by
put_device(), so the error path should follow the same pattern.

>
>>  }
>>  EXPORT_SYMBOL_GPL(tsm_register);
>>  
>>  void tsm_unregister(struct tsm_dev *tsm_dev)
>>  {
>> +	/* Remove the class lookup first. */
>> +	device_del(&tsm_dev->dev);
>>  	if (tsm_dev->pci_ops)
>
> The patch 1 rejects NULL pci_ops, so is this check still needed? Can we
> remove this check in your Patch 1?
>


Sure, I will remove the check in the next revision.

>
>>  		pci_tsm_unregister(tsm_dev);
>> -	device_unregister(&tsm_dev->dev);
>> +	put_device(&tsm_dev->dev);
>>  }
>>  EXPORT_SYMBOL_GPL(tsm_unregister);
>>  

-aneesh
