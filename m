Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795496711;
	b=bsZyK9D1+di1EiUtbSH6sJ1yJpR8GVcSnL18EXolhqVKPlk7ye+1ZZbRuMzZ2GyECHyu
	 FLdhBI9hND/ZY5ZS0rmIhei/yJpCv/6r13IevZAc8Mt3wbtJY5ZtVdgqBji74KAoBsT3a
	 1oH+p2UXoYgOnuRVibNDf+tMuwTFM3Cj5Mt9g2tXGJpajEDN7c8rHrFSd4+K/mAI5VzqX
	 dmZWdx37e0As8TK14KCguKipprfOvpfsbxkVrdKWtekPoq4h9+m8HLA2AoxlhTModOzyk
	 xgRxCdq3vVN4OtzdGrDTVccTKih9ez420Ib8/AGIDvqbSFkClwhzFOQxzoDwH1iQNlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795496711;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=GCQiR5Lx2UKMEtsK+gSKSdJH4PY2fbRO9XAcb5R+0z8=;
	b=D0rxZn3r1Ly0fDqCe2xS06VIWhTcPlRPLoq8xbEjbOA+9YWxhuRpGEumsuHAhzblXQbE
	 VQoTlGBb2TJlx4IFXWgn4XpMOs0MzhUWV61XGmdBP87EnIlOKz/MJ2ausOqsqjx2PC4jL
	 MTgb+ZAzAtz/vs20/ZVH2ZJOX3Bpb84wEL4KcKGHPqfJsACWOhcZkKqR+2k3QCDqkEXPG
	 lUmC3zu9XrIjloBJxlaFGw4BektCrE72aP7R64vOaeZT5U1Bb6B+/kVMViJ+u15zi8hfN
	 3VJBUKMOrslyEDjRW+9GL/lZkuPRtlBZztRJveq4669rrEzJTGscSSZ1o6g3OC/RtLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Sf4jeTTU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E69606A31E;
	Tue, 24 Nov 2026 05:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Sf4jeTTU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E35D1F000C4;
	Tue, 24 Nov 2026 05:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795496710;
	bh=GCQiR5Lx2UKMEtsK+gSKSdJH4PY2fbRO9XAcb5R+0z8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Sf4jeTTUeyNECnDrWH/zHQwCweqyr3ICg/XJr7Dn7sQUhHdZSBrQSD52eyo6OmH0Q
	 zU8gOnX247GPxo4ufgj/OAOJ3DoOsgjDn3NaJ1x3hgmutbUe9OpgE/loVkCo79kJxR
	 oRohNM3MgCe0WDqEpWRyv1fw3lRIHaMTei8SLBUsVYDEYEzjNDq10xh+T1xQ/nzrLg
	 tI3D+xn/LzxZQ6MvVEHtySmqi/Zejda2tFa6wKh82wHIoDZ2wN/DlM4JuRjYn5fp3M
	 baPqje+9fvFyJGEsSLy0k2u6v7W42SrhJUxFg2/zy9paZ5C6Ektd1wsCp1zwiH30CK
	 H2nILDRrxSQqQ==
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
Subject: Re: [PATCH v9 10/13] iommufd/viommu: Allow PCI TSM backends to
 provide vIOMMU operations
In-Reply-To: <2d8af908-4dd5-43a9-b618-d1ee4189f6ba@linux.intel.com>
References: <20261116081935.85372-1-aneesh.kumar@kernel.org>
 <20261116081935.85372-11-aneesh.kumar@kernel.org>
 <2d8af908-4dd5-43a9-b618-d1ee4189f6ba@linux.intel.com>
Date: Tue, 24 Nov 2026 10:34:58 +0530
Message-ID: <yq5ao6bebz0l.fsf@kernel.org>
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
>> In confidential-computing configurations, a vIOMMU may be implemented by
>> a TSM driver rather than by the physical IOMMU driver. Such an
>> implementation also needs the TSM identity when creating and validating
>> vdevices.
>>=20
>> Allow VIOMMU_ALLOC to first query the TSM associated with the target PCI
>> device for vIOMMU operations. Fall back to the physical IOMMU driver
>> when the TSM does not provide operations for the requested vIOMMU type.
>>=20
>> Resolve the PCI TSM association under pci_tsm_rwsem, take a TSM device
>> reference, and pin the module providing the operations. Store the TSM
>> device in the vIOMMU. Release the device reference and module pin on
>> allocation failure, fallback to the physical IOMMU driver, or vIOMMU
>> destruction. Drop the device reference before releasing the module pin,
>> since the final put may call into the backend module.
>>=20
>> The device reference preserves the TSM allocation. Backends providing
>> vIOMMU operations must not unregister their TSM while the module is pinn=
ed,
>> since the reference does not prevent backend resource teardown.
>>=20
>> Cc: Jason Gunthorpe<jgg@ziepe.ca>
>> Cc: Kevin Tian<kevin.tian@intel.com>
>> Cc: Joerg Roedel<joro@8bytes.org>
>> Cc: Will Deacon<will@kernel.org>
>> Cc: Robin Murphy<robin.murphy@arm.com>
>> Cc: Bjorn Helgaas<bhelgaas@google.com>
>> Cc: Alexey Kardashevskiy<aik@amd.com>
>> Cc: Lukas Wunner<lukas@wunner.de>
>> Cc: Xu Yilun<yilun.xu@linux.intel.com>
>> Cc:iommu@lists.linux.dev
>> Cc:linux-pci@vger.kernel.org
>> Signed-off-by: Aneesh Kumar K.V (Arm)<aneesh.kumar@kernel.org>
>> ---
>>   drivers/iommu/iommufd/viommu.c | 35 +++++++++++++++++++++++++++-----
>>   drivers/pci/tsm/core.c         | 22 ++++++++++++++++++++
>>   drivers/virt/coco/tsm-core.c   | 37 ++++++++++++++++++++++++++++++++++
>>   include/linux/iommufd.h        |  2 ++
>>   include/linux/pci-tsm.h        | 24 ++++++++++++++++++++++
>>   include/linux/tsm.h            | 25 +++++++++++++++++++++++
>>   6 files changed, 140 insertions(+), 5 deletions(-)
>
> This change spans both PCI/TSM and IOMMUFD. Could it be split into
> separate patches for each subsystem=E2=80=94for example, one adding the T=
SM
> lookup interface and another updating IOMMUFD to use it?
>

Sure, I'll split it into separate patches.

-aneesh
