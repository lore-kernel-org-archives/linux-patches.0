Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795497821;
	b=FCskFnJfpjja/5TnETFciO2TKJzNVKk98UaLh10/F0M0Za2RAPue8ge2+JIxigwuiKA8
	 j3+v1SC/rtDCaCP8H/2F+HcLZMbxIlQ+Kt1NHNpH4UivBV4x5zuEzBYan31vLa2oMwhtR
	 +MTtkSCUf+zMvYNT7OTq08PsQubCC6jdovJWCXELMcHwkuAtQGpJIxAoeZar8fLMeEabs
	 vzw0yXm45MncizhjHmQ8ZCEbgcRcFueL8xso+mo0I2WlbkwhyqQ43mnIA1EslnhS49BQu
	 dcoV5DlafwUKTeSpN13z8XThlkSkMLZjgyBAMAqRn4oGysmBtjvWegMmRpWferHOOcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795497821;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=vc9ZjW3MdZZrSawTDR1LO60vJFvLL8Ygoa4DX6STls8=;
	b=jnCDgngwz+nxER1msy7gcdsA571lhMN+i8xfUFNK/9EXRPY8fxlekJYQirqEnzivqTAC
	 BIrTvTNUkCm+Fc9n8bcRBB8xZKs7LIRnpv+ZjpcxjBW8ug+QijYZQ8HhZT5sAmqiaLUTG
	 xopc1Sig7LAXkQane5KRUS3W5LL8E7vmM6OONj/EJxNzUodSrbAy95pHKVeG1pDlCSlCa
	 dkzKnYfWWHz22S+nPFwsDRGt/g2yNZPH8sANfWyAZwVnWi30LL4aQSSsWZrR6PBm5r7zw
	 Tw1QNmJqDogDcL9QdEvYfOTI2ssc4mbxEHDB9Y6cHbM/51GCFvlfP7U0GCEJgP840mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VmOoe8fI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E60606A32E;
	Tue, 24 Nov 2026 05:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VmOoe8fI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3B21F000D0;
	Tue, 24 Nov 2026 05:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795497820;
	bh=vc9ZjW3MdZZrSawTDR1LO60vJFvLL8Ygoa4DX6STls8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=VmOoe8fIHUx8L+nCT7j0WFguj/mguXuQR+RGYclGZKFMdy5PEqlwkPvJZux3QVsb3
	 +BwWMmsS1qJ+8/JwL+UpJSrNkZlHXHU1QLvTZFptUArdX/bTBrW1UPnRTO2q+RDxmS
	 O1S4B2d4ZwGaIaDmOfEyz4z+3HMfvTZof4a76BDCAs9HoV3uiX1V/fHDcJVz/2iX2N
	 UlDOCiqW0cyYxgG2vcmjxmTYQ9FwgbMUtavZB2X3C0kJYq7ZdPZudm3NbNVsRgkdsj
	 0j0VJA+pjn/QLwJ6eSWg4h4DIYzRwnNjwFoW8rNAPvswHpBqjJRQL9CmofF4QogBGl
	 Q8aMWhaAGmr4w==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Baolu Lu <baolu.lu@linux.intel.com>, linux-coco@lists.linux.dev
Cc: baolu.lu@linux.intel.com, Alex Williamson <alex@shazbot.org>,
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
	Xu Yilun <yilun.xu@linux.intel.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	iommu@lists.linux.dev,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
	linux-tegra@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v9 11/13] iommufd/viommu: Allow vIOMMUs without a parent
 HWPT
In-Reply-To: <620712ae-e21e-4daa-9cd3-0c5d06ffb67f@linux.intel.com>
References: <20261116081935.85372-1-aneesh.kumar@kernel.org>
 <20261116081935.85372-12-aneesh.kumar@kernel.org>
 <620712ae-e21e-4daa-9cd3-0c5d06ffb67f@linux.intel.com>
Date: Tue, 24 Nov 2026 10:53:27 +0530
Message-ID: <yq5ajym2by5s.fsf@kernel.org>
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

Baolu Lu <baolu.lu@linux.intel.com> writes:

> On 11/16/2026 4:19 PM, Aneesh Kumar K.V (Arm) wrote:
>> VIOMMU_ALLOC currently requires a nesting parent HWPT_PAGING even when
>> the selected vIOMMU implementation has no use for one. This would force
>> implementations such as the following Arm Realm vIOMMU to create an
>> unused parent.
>> 
>> Add IOMMUFD_VIOMMU_NO_HWPT so an implementation can opt out. Require
>> hwpt_id to be zero in that case and pass a NULL parent domain to its
>> initialization callback. For implementations that require a HWPT, verify
>> that the parent supports nesting and its domain belongs to the device's
>> physical IOMMU driver before invoking viommu_init().
>> 
>> Reject nested domain and hardware queue allocation for a vIOMMU without
>> a parent, and document the two allocation modes in the UAPI.
>> 
>> Cc: Jason Gunthorpe <jgg@ziepe.ca>
>> Cc: Kevin Tian <kevin.tian@intel.com>
>> Cc: Joerg Roedel <joro@8bytes.org>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Robin Murphy <robin.murphy@arm.com>
>> Cc: iommu@lists.linux.dev
>> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
>> ---
>>   Documentation/userspace-api/iommufd.rst | 44 +++++++++---------
>>   drivers/iommu/iommufd/hw_pagetable.c    | 14 ++++--
>>   drivers/iommu/iommufd/viommu.c          | 62 +++++++++++++++----------
>>   include/linux/iommufd.h                 | 13 ++++--
>>   include/uapi/linux/iommufd.h            |  3 +-
>>   5 files changed, 81 insertions(+), 55 deletions(-)
>> 
>
> [...]
>
>> diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
>> index ae62db50885c..52e52ef089a2 100644
>> --- a/drivers/iommu/iommufd/hw_pagetable.c
>> +++ b/drivers/iommu/iommufd/hw_pagetable.c
>> @@ -306,6 +306,10 @@ iommufd_viommu_alloc_hwpt_nested(struct iommufd_viommu *viommu, u32 flags,
>>   		return ERR_PTR(-EOPNOTSUPP);
>>   	if (!user_data->len)
>>   		return ERR_PTR(-EOPNOTSUPP);
>> +	if (!viommu->hwpt)
>> +		return ERR_PTR(-EOPNOTSUPP);
>> +	if (!viommu->iommu_dev)
>> +		return ERR_PTR(-EOPNOTSUPP);
>>   	if (!viommu->ops || !viommu->ops->alloc_domain_nested)
>>   		return ERR_PTR(-EOPNOTSUPP);
>>   
>> @@ -404,10 +408,12 @@ int iommufd_hwpt_alloc(struct iommufd_ucmd *ucmd)
>>   		struct iommufd_viommu *viommu;
>>   
>>   		viommu = container_of(pt_obj, struct iommufd_viommu, obj);
>> -		iommu_dev = iommufd_device_get_iommu_dev(idev);
>> -		if (!iommu_dev || viommu->iommu_dev != iommu_dev) {
>> -			rc = -EINVAL;
>> -			goto out_unlock;
>> +		if (viommu->iommu_dev) {
>> +			iommu_dev = iommufd_device_get_iommu_dev(idev);
>> +			if (!iommu_dev || viommu->iommu_dev != iommu_dev) {
>> +				rc = -EINVAL;
>> +				goto out_unlock;
>> +			}
>
> Is it intended that every tsm-provided viommu has viommu->iommu_dev ==
> NULL?
>
> If so, could the tsm-provider patch make provider selection exclusive by
> looking up the physical iommu only on the fallback path? All checks
> against viommu->iommu_dev should be in that patch. This non-parent-hwpt
> viommu support patch should no longer check viommu->iommu_dev.
>

IIUC, you are suggesting moving the iommu_dev check from this patch to
patch 10?

>
> Also, if viommu->iommu_dev and viommu->tsm_dev are mutually exclusive,
> could that be made explicit in a comment or by using a tagged union?
>

That would be a much larger change, as it would require updating all
current users of iommu_dev to check the tag. We can address that
separately from this series.

>
>>   		}
>>   		hwpt_nested = iommufd_viommu_alloc_hwpt_nested(
>>   			viommu, cmd->flags, &user_data);
>> diff --git a/drivers/iommu/iommufd/viommu.c b/drivers/iommu/iommufd/viommu.c

 [ ... 163 lines skipped ... ] 


-aneesh
