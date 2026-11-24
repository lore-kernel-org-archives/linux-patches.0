Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795493548;
	b=zgCL6IHAnGWvGDnIlCa0LUczerz5vRInX+TYWW27cSvVju7pVSnOkHbg5Fc+Mzdnx3wS
	 bD1yfMjnoDLrubJmYw11qMgnmOAy6J5ggx85LB5Mnz8BUtqQWv4J5Veep9FcQjRc6/30i
	 wNahda6592lx0zloTRZ/xkiHhKR3Q/YNmqf3Ltn2l1Y9nBYaAz6WktGloRNNF98PeosHS
	 H57aTUlxe6LLBk8TL3VsiaFDLDrvacK8tFrTFM8HlidQsu4yQ5XLMeVE5qJJ2SwYd1kGX
	 tjGUqN1U0EBaifn/1E8Z+iPc9Yp/0vnDDTlTBRbRfd0Sb7xk7N4n4wxFSnNCLSvFv0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795493548;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=TOPyh86e0J/wqM6iyFTSqLXbZQLp2s74/uc/F4v5k2k=;
	b=eeFN2un9TOwRzFrtZXYHzBw3PIGJRoSjoFW4DqeY1+ARUMqPvfnxAtvTuOQWwkbX5OcF
	 EUgH8+6/NEI1ObbgXYRPSqn8ya2VhVPwMXLt3wLPRkEnsxLcWvPTfoaQqTltKRI5ZymFn
	 Z7csx+pKMgBJwU118ckGvGZJh1JmqlK2PudHDo5Na6W7KM9bhnx94ri33rBDBH2+a7WVn
	 KlJg+LvhRutdWGheY2zP6NbpOQJG3EySw9NzKa3wBTN4M38N3yjcrSS7mObFCvxyTZEY5
	 m11Pu2sh3Ncrj3eAzBZQNVj1TVjtB04dn9qeoa8mY+drvON+8BjOHmd2z8G4f2SbZxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TacI6VBy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F93A606A31E;
	Tue, 24 Nov 2026 04:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TacI6VBy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F6F1F000D4;
	Tue, 24 Nov 2026 04:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795493548;
	bh=TOPyh86e0J/wqM6iyFTSqLXbZQLp2s74/uc/F4v5k2k=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=TacI6VByHmOlrNMYSCRpaldILoRzjvB7MBWa7eaMuyWG/LfquQTS7/HAwYu9490pe
	 XQ2F8WyNFlP6ZRGn3e6cLQsHNlim7ClGQmqalBH5tr2THZ2VixKCIswPPTBu+Ezszn
	 gMMUpSrPneTOQh4Ad8nB4h/DPqDEewrvZ8CBE0c0CFM1aPs7BSu0j77dIR9LrU1I6E
	 NwO7weBpkdOlqKdKe7Q0BdLDX1hJflxxZT/NzzdL9ixUyP/DKAXhYiR0OJWrX1u2sq
	 Gdj9K9g33VNSw8R1+0e5cJecESdB63deRy19Ht+5ShIxR6iGfgeVcjEZVujvuZB75J
	 LFDjnVJuqj/Gg==
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
Subject: Re: [PATCH v9 09/13] iommufd/viommu: Select vIOMMU operations
 before allocation
In-Reply-To: <20261120094207.00002e89@linux.microsoft.com>
References: <20261116081935.85372-1-aneesh.kumar@kernel.org>
 <20261116081935.85372-10-aneesh.kumar@kernel.org>
 <20261120094207.00002e89@linux.microsoft.com>
Date: Tue, 24 Nov 2026 09:42:12 +0530
Message-ID: <yq5atsl6c1gj.fsf@kernel.org>
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
> On Mon, 16 Nov 2026 13:49:31 +0530
> "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> wrote:
>
>> Physical IOMMU drivers currently provide the vIOMMU size and
>> initialization callbacks through iommu_ops. The initialization
>> callback then selects and installs the corresponding
>> iommufd_viommu_ops.
>> 
>> Add iommu_ops::get_viommu_ops() to select the operations from the
>> physical device and requested vIOMMU type before allocation. Move the
>> size and initialization callbacks into iommufd_viommu_ops. The core
>> can then validate the selected operations, allocate the driver
>> structure, initialize it, and install the operations.
> The patch title is slightly misleading since it does not change the
> order between setting viommu_ops and allocation. IMHO, it is more like:
> "Move vIOMMU ops selection into the core"
>

previously we did
	ops = iommu_dev->ops;
	viommu_size = ops->get_viommu_size(idev->dev, cmd->type);
	viommu = (struct iommufd_viommu *)_iommufd_object_alloc_ucmd(
		ucmd, viommu_size, IOMMUFD_OBJ_VIOMMU);
	rc = ops->viommu_init(viommu, hwpt_paging->common.domain,
			      user_data.len ? &user_data : NULL);
	if (rc)

and viommu_ini did things like
		viommu->ops = &arm_vsmmu_ops;

With this patch it becomes
	ops = iommu_dev->ops->get_viommu_ops(idev->dev, cmd->type);
	viommu_size = ops->get_viommu_size(idev->dev, cmd->type);
	viommu = (struct iommufd_viommu *)_iommufd_object_alloc_ucmd(
		ucmd, viommu_size, IOMMUFD_OBJ_VIOMMU);
	rc = ops->viommu_init(viommu, idev->dev,


That is, we now select the vIOMMU ops before allocation.

-aneesh
