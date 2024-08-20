Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E869218B465
	for <patches@lists.linux.dev>; Tue, 20 Aug 2024 08:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724142041; cv=none; b=L/00BG80tuhOIHDjAIJTQGlIbRXP/rztmXJpsbR1HRk84NQPJaHHrVOvk4noETHrm+pUNrZBZP7V/ShY5/rUI482Rpfh9GTQQx7kLL+ER63kIqW7uhJ++tOs3FRWsYAAh8OBsaFHs6Q/b37zcFuaThGJSz+x4yLrLcX8XoIfCwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724142041; c=relaxed/simple;
	bh=U2fujsx9Rc4n0rHEX/kn6T7aFQIMaoi7z30UTc1xBT4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hWjaBg3qY6up1FzTC9QNPqu+7EbGbkaAdLcRVWDoTUdlJwO0lAL3zvIU7dgeMElW5lgDpY/Mze2pz5KcutIn2Z8dUDnx1MrZeYJLC0OIceDpyJlik1PevvVl4ATcBjoCrnnDQPZSzxtw3eMxB9xsIu3vBl1BptkeMZXpTQOHNdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o2jtr3ME; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o2jtr3ME"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-428e12f6e56so23695e9.0
        for <patches@lists.linux.dev>; Tue, 20 Aug 2024 01:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724142038; x=1724746838; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hSwrIo6MlWvOQ+mcUv6uS1wZ25LrFB1ewOcC/h8kM+Q=;
        b=o2jtr3MEzNRPVIR1ae/o5OTIlttPcuWhVI1dWWZmvCQByqAC4IkPJqv0cHE9tLchg7
         MfK6L6a0InCZPHvttKtQ+LnqUSZkfnk7dQ7eZ7YNrLDUvMnzmOqhKIo3ReXYwGsR3OnZ
         /2RCXJlEe+UllcNEGBOFJoikMMFhlYpOI8Uob6megISPnlC/ve4zr4QmbHIr2LJxh8yL
         4gmdNDk5a9GDFIbf8mwmWsloh9uNAohTVUlh+dIF+ngpEYRZOZTmi7YD3Kradv6ukLjl
         wq7tejl9hCThY/N47egYKGK+/d13TDAjNQnunjT3HwBKq4k5FFK0EqUHML//4h+lX2TH
         gR0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724142038; x=1724746838;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hSwrIo6MlWvOQ+mcUv6uS1wZ25LrFB1ewOcC/h8kM+Q=;
        b=FANQCpXkrPW7PxP0kXQ9CYsiCOe9SjpzkfpSwOqZP6Z4YCYqvfltYnOYHby9NfcaFQ
         SZfWzv6wSY3jvYYBg0xdCjKQZql0mjOf8LNfoZ2eNcKXNCKG9ShOS1gv9qdrBrYAtjJg
         3K5wgl23j5cEb+aQM+gMEfDIl1wHkT9fQ59581fD8C1p3yVTCQe9Ynpqf/CCzALlC45d
         xYtPdI4FCNZXxVdrVceKqF0K/vYYjro8YVD4+LtKF5gti+mogIiPDTKBoBhtDTb+XnhN
         7dEpaQhhcBxVWVAxdjYBDAtye81BPtk7GMRp2ceUpgV39c7+yy+AxpTPMyJd0Mv+iPs7
         46mg==
X-Forwarded-Encrypted: i=1; AJvYcCU8O8kUtPv8SSo66H1Jobm76dqsBaVzZeXnYAJfd/lesL4CxCxMKPjy2xaag4IgR61BbD9fsbAhiGUaG9uTTXl3Z6KN5nurYA==
X-Gm-Message-State: AOJu0Yw1X62JloXR9eyNB1EPY2aHpU4v2FjIrvS+Qz6l/WO5cnC4Sc0K
	2pexjeqAz3Jqo27JjDiP9hwxuVdzzz6moKh1pcjLJzMckXfWjrJZ5k+3TPkxaA==
X-Google-Smtp-Source: AGHT+IFkxwYbutMYvAck6HWY9AZnwzgvx67PU4bYEmqMtnbNvH7bwgVYyvbPkbuBgiiDj1GbnYCL7w==
X-Received: by 2002:a05:600c:a0e:b0:426:66a0:6df6 with SMTP id 5b1f17b1804b1-42ab5bee335mr461955e9.0.1724142037758;
        Tue, 20 Aug 2024 01:20:37 -0700 (PDT)
Received: from google.com (203.75.199.104.bc.googleusercontent.com. [104.199.75.203])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42ab87ef024sm10121515e9.1.2024.08.20.01.20.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2024 01:20:37 -0700 (PDT)
Date: Tue, 20 Aug 2024 08:20:32 +0000
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
Subject: Re: [PATCH 0/8] Initial support for SMMUv3 nested translation
Message-ID: <ZsRR0MUHPz23zxu3@google.com>
References: <0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>

Hi Jason,

On Tue, Aug 06, 2024 at 08:41:13PM -0300, Jason Gunthorpe wrote:
> This brings support for the IOMMFD ioctls:
> 
>  - IOMMU_GET_HW_INFO
>  - IOMMU_HWPT_ALLOC_NEST_PARENT
>  - IOMMU_DOMAIN_NESTED
>  - ops->enforce_cache_coherency()
> 
> This is quite straightforward as the nested STE can just be built in the
> special NESTED domain op and fed through the generic update machinery.
> 
> The design allows the user provided STE fragment to control several
> aspects of the translation, including putting the STE into a "virtual
> bypass" or a aborting state. This duplicates functionality available by
> other means, but it allows trivially preserving the VMID in the STE as we
> eventually move towards the VIOMMU owning the VMID.
> 
> Nesting support requires the system to either support S2FWB or the
> stronger CANWBS ACPI flag. This is to ensure the VM cannot bypass the
> cache and view incoherent data, currently VFIO lacks any cache flushing
> that would make this safe.
> 
> Yan has a series to add some of the needed infrastructure for VFIO cache
> flushing here:
> 
>  https://lore.kernel.org/linux-iommu/20240507061802.20184-1-yan.y.zhao@intel.com/
> 
> Which may someday allow relaxing this further.
> 
> Remove VFIO_TYPE1_NESTING_IOMMU since it was never used and superseded by
> this.
> 
> This is the first series in what will be several to complete nesting
> support. At least:
>  - IOMMU_RESV_SW_MSI related fixups
>  - VIOMMU object support to allow ATS invalidations
>  - vCMDQ hypervisor support for direct invalidation queue assignment
>  - KVM pinned VMID using VIOMMU for vBTM
>  - Cross instance S2 sharing
>  - Virtual Machine Structure using VIOMMU (for vMPAM?)
>  - Fault forwarding support through IOMMUFD's fault fd for vSVA
> 
> It is enough to allow significant amounts of qemu work to progress.
> 
Are there any qemu patches to tests this?
As I am confused with some of the user space bits and that would help.

Thanks,
Mostafa

> This is on github: https://github.com/jgunthorpe/linux/commits/smmuv3_nesting
> 
> Jason Gunthorpe (5):
>   vfio: Remove VFIO_TYPE1_NESTING_IOMMU
>   iommu/arm-smmu-v3: Use S2FWB when available
>   iommu/arm-smmu-v3: Report IOMMU_CAP_ENFORCE_CACHE_COHERENCY for CANWBS
>   iommu/arm-smmu-v3: Implement IOMMU_HWPT_ALLOC_NEST_PARENT
>   iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
> 
> Nicolin Chen (3):
>   ACPI/IORT: Support CANWBS memory access flag
>   iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via struct
>     arm_smmu_hw_info
>   iommu/arm-smmu-v3: Add arm_smmu_cache_invalidate_user
> 
>  drivers/acpi/arm64/iort.c                   |  13 +
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 398 ++++++++++++++++++--
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  27 ++
>  drivers/iommu/arm/arm-smmu/arm-smmu.c       |  16 -
>  drivers/iommu/io-pgtable-arm.c              |  24 +-
>  drivers/iommu/iommu.c                       |  10 -
>  drivers/iommu/iommufd/vfio_compat.c         |   7 +-
>  drivers/vfio/vfio_iommu_type1.c             |  12 +-
>  include/acpi/actbl2.h                       |   1 +
>  include/linux/io-pgtable.h                  |   2 +
>  include/linux/iommu.h                       |  54 ++-
>  include/uapi/linux/iommufd.h                |  79 ++++
>  include/uapi/linux/vfio.h                   |   2 +-
>  13 files changed, 572 insertions(+), 73 deletions(-)
> 
> 
> base-commit: e5e288d94186b266b062b3e44c82c285dfe68712
> -- 
> 2.46.0
> 
