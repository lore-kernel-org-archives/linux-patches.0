Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795492919;
	b=bwDQfzZq/Job6b3J/il7TSv5W6byAbSZ7degIkneF49D5cZPFP1COcuDAIu0QFUhRweo
	 0xu/hiuVeD6SnBXGz33tMtles+ufa2H4dJhW4w0FXyri+fP+fAzc8UqvJ3FwN1HA+4nM0
	 k7vGa2JLaAovXXm6JyloaiB99O0JNNDbbt7AlyjNByPZpaRAVMEF42hPZ4XgQjvxADupT
	 oXIxAIjS0TEu7A8l6O6av/pBhCFrY0R5y4WqNtvTA29VXtTrTJGMbOskqbtJEra8oQyxp
	 Jipk8d/bMXULQXEpwiBwnkMAiNg3lvSfZewFLVPenQ9gsXniwFcKjvgsuZgC9Zs9WTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795492919;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=bjVAU0iIAOgnI+Z9r4rv0Vrj1mrxZe06Xngjbnjh7i8=;
	b=wXMVQG8Or4gLUPG5IItcZm/pV+TXLOv7lBo9s++6JJagoxjSeRdFPYzbnL95XBatsH5Q
	 cRAEdaFw0jBHQnFyVqqF8WilM+pIEHHGjFmWzIrosez0/erAdILECUkB3FJTnenZEfVBk
	 Q8r1Ofe+mDOC+J37JvyC2NeYHhE9wgSuOqRhdT+VOPRjuTJLPn5d92Z/D+lPQfN5b/eW5
	 7EVUE/XSKhUNpuHbyHYdnm7+ksBQm3VGZOB8cugxojM+01yA748OsyFp/XuJ57ww+qRoL
	 9vHQrpJWuPWibWRpN0zZB0xZDryeuW+cnt9CuynY0iiV3JC8HrWbkkfqqSBJxko7Ubg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ff1VdN9z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03865606A31E;
	Tue, 24 Nov 2026 04:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ff1VdN9z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E733C1F000C6;
	Tue, 24 Nov 2026 04:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795492918;
	bh=bjVAU0iIAOgnI+Z9r4rv0Vrj1mrxZe06Xngjbnjh7i8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Ff1VdN9zQAt1r47nwbUlqdCSDMu2C95as1MKY0RIwpnWfHbyx0cMO5TKpv4pkcKKn
	 8lgyvvRh56RPwugFLv4xkS7YVm9qh6aUKLwWtDVzNcCuBEf6P5D3LslpYpdaiz4sX9
	 CBcySUuMnXhYdaJ8KtmPtz/BjADI+AVI71RUkQxdChPaS5/RA1sFYw1M6ACBqdLbf+
	 sRQq9r9854hMiPvCJ50fgPXKyQ6okN2FKfGNuoCGeSfAY+495jj6enS3CwmGimIMHS
	 rdna2uyn8LJdO7q4zwLy+XEDnz6kgnLU6aILwK1oRajYg1d7TqUYNwe4HHsyR9IN7T
	 00oxS3AsIR9/A==
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
	linux-tegra@vger.kernel.org, patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v9 04/13] iommufd/device: Associate KVM file pointer
 with iommufd_device
In-Reply-To: <fac3d200-e1e8-4a0f-bd41-8e1c0d727d1a@linux.intel.com>
References: <20261116081935.85372-1-aneesh.kumar@kernel.org>
 <20261116081935.85372-5-aneesh.kumar@kernel.org>
 <fac3d200-e1e8-4a0f-bd41-8e1c0d727d1a@linux.intel.com>
Date: Tue, 24 Nov 2026 09:31:43 +0530
Message-ID: <yq5azeuyc1y0.fsf@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Baolu Lu <baolu.lu@linux.intel.com> writes:

> On 11/16/2026 4:19 PM, Aneesh Kumar K.V (Arm) wrote:
>> From: Shameer Kolothum<shameerali.kolothum.thodi@huawei.com>
>>=20
>> TSM vDevice support needs access to the KVM associated with a VFIO device
>> after the device has been bound to iommufd.
>>=20
>> Extend iommufd_device_bind() to accept the device's KVM file and store it
>> in the iommufd_device. The KVM file reference is owned by VFIO and is
>> already held for the duration of the device open path.
>>=20
>> Reviewed-by: Kevin Tian<kevin.tian@intel.com>
>> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
>> Signed-off-by: Shameer Kolothum<shameerali.kolothum.thodi@huawei.com>
>> [nicolinc: fix build error in iommufd_test_mock_domain()]
>> Signed-off-by: Nicolin Chen<nicolinc@nvidia.com>
>> [aneesh.kumar: Switch to use kvm_file]
>> Cc: Jason Gunthorpe<jgg@ziepe.ca>
>> Cc: Kevin Tian<kevin.tian@intel.com>
>> Cc: Joerg Roedel<joro@8bytes.org>
>> Cc: Will Deacon<will@kernel.org>
>> Cc: Robin Murphy<robin.murphy@arm.com>
>> Cc: Alex Williamson<alex@shazbot.org>
>> Cc:iommu@lists.linux.dev
>> Signed-off-by: Aneesh Kumar K.V (Arm)<aneesh.kumar@kernel.org>
>> ---
>>   drivers/iommu/iommufd/device.c          | 7 ++++++-
>>   drivers/iommu/iommufd/iommufd_private.h | 2 ++
>>   drivers/iommu/iommufd/selftest.c        | 2 +-
>>   drivers/vfio/iommufd.c                  | 3 ++-
>>   include/linux/iommufd.h                 | 4 +++-
>>   5 files changed, 14 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/devi=
ce.c
>> index 1b0bdf57ac8a..935f42616a65 100644
>> --- a/drivers/iommu/iommufd/device.c
>> +++ b/drivers/iommu/iommufd/device.c
>> @@ -295,6 +295,7 @@ static int iommufd_bind_noiommu(struct iommufd_devic=
e *idev)
>>    * iommufd_device_bind - Bind a physical device to an iommu fd
>>    * @ictx: iommufd file descriptor
>>    * @dev: Pointer to a physical device struct
>> + * @kvm_file: VM file if device belongs to a KVM VM
>>    * @id: Output ID number to return to userspace for this device
>>    *
>>    * A successful bind establishes an ownership over the device and retu=
rns
>
> As discussed during the v8 review, how does this series address the risk
> that the KVM file pointer could become invalid if REMOVE_WAIT times out?
> The changelog says the extra KVM file reference was dropped. Is the
> timeout expected never to occur, or should it be addressed by a broader
> fix if it does? How about explaining this in the commit message so
> future readers understand why the extra reference isn=E2=80=99t needed.
>

The conclusion was not to fix it.

https://lore.kernel.org/all/20261112174009.GB2532299@ziepe.ca


-aneesh
