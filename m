Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795076058;
	b=YtCyFp9FiaLiicwwXnxDvBj2OnApMbqG+fiEcmB6NDvE/vN3KYH8Cp4jewE/clNGtLFf
	 on06FXAW+cQmNhjCVXWCDR1N0h5a5MqzEfQ9lkXTzMMiUTst4oS+rvY2V4RRGoM/k7hKT
	 uEd7DPkPsZvxlMVQH+Z28umc71x5YMpXfcwWACFHyAqqvfmdiF74U6ztoRotC7ZVWhtTh
	 5AWnlaozMAk49VNgBDw16yMd44AKfFeuh8zoHG5FKmyeiiO/X1UfE9vkVAUfVC6HdS0k4
	 AX0bAfOa0/MqOSPRzRshkouNzwYdq2/EJbD4Fl0SHRBiRjvGQuQ9+DyMTU2oElyUwng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795076058;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Cc:Subject:To:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=Va/Oxtu6vlA30n7TkoMr9m9dnyboRnI7B5KkvZShXuk=;
	b=BKJZRoJZpm264HMJKPhcbUve4X/CgsSdfmSXtiQzFWjfhSGYb3I9cRl90MFpeHK+BSBp
	 P9PLiB6e1Ned+E4oAjRq6tgWi5QK0bX27EXpqCDj7M9Ec++OoZeB+EwWJAMGdgWdrAZI3
	 iS/y8ZKRsrsrw0hrd9FBEDP/hoXkhmUzJLbBM61KRl/q/b3uFyugrkNK+7dK6QI6YQ606
	 nrLiduD+ZrbUlINZYAiLSH7Y231LJSJ44dfk8SeHPNxfOQTFLoHdKBw23Sa92aEJ4H9Jh
	 IW4oJ2lCMfN/bfiLsXec1j+mG1EBbZ4EIrUF5cognWnfHVwHTvGDd2rIlIg0toWpAlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=JHtfP26L;
	arc=none smtp.remote-ip=192.198.163.18
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1177A606A320;
	Thu, 19 Nov 2026 08:14:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1177A606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=JHtfP26L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795076058; x=1826612058;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kzJo+8BaOAZhUntz86DhI1HKcpzg32Rvn/ODVmcnDig=;
  b=JHtfP26LfKGpzsHg0MB2vZ6ix6lSedBydZdHOc/+kGNo4PR95dK1KcHN
   WbtGF0ga04gRvZIBYOXkBdlMLYlAhG60y7ckdX2yEb7P3lOQESXH1KY8Y
   GBYYkMycrosbEfe2IDaGFCTyNWUYyga9mHkEdxVdKoYxpy9oJaiXVnMh1
   ZdXfs6WSggm+kJNCjGGyHeD89I6/3CXFHROYt1fccGHpZFABsxJbgiwwD
   0ysCv/mdWRKp6mDE78z2X2g5gH6Rtqm2wU/H2WgJzhEcZeEICYIKxfxnU
   GJSXTXfh+QbtlYL9q2cgk3FUO1+tR5N4VEFYWaJaH0z/Dq6cxeP0QweN1
   w==;
X-CSE-ConnectionGUID: I03sHtFBQBOkiYOoBeYIWg==
X-CSE-MsgGUID: dHo/ebiYTzGhu0MGZdrseg==
X-IronPort-AV: E=McAfee;i="6800,10657,11970"; a="3944393"
X-IronPort-AV: E=Sophos;i="6.27,220,1787036400"; 
   d="scan'208";a="3944393"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 00:14:00 -0800
X-CSE-ConnectionGUID: 0tlw9+aHSg2IlofLNzybUA==
X-CSE-MsgGUID: EoPnrkujQkWheEz1swf5JQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,220,1787036400"; 
   d="scan'208";a="10730909"
Received: from unknown (HELO [10.238.1.144]) ([10.238.1.144])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 00:13:49 -0800
Message-ID: <fac3d200-e1e8-4a0f-bd41-8e1c0d727d1a@linux.intel.com>
Date: Thu, 19 Nov 2026 16:13:46 +0800
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, Alex Williamson <alex@shazbot.org>,
 Alexey Kardashevskiy <aik@amd.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Joerg Roedel <joro@8bytes.org>, Jonathan Cameron <jic23@kernel.org>,
 Jonathan Hunter <jonathanh@nvidia.com>, Kevin Tian <kevin.tian@intel.com>,
 Krishna Reddy <vdumpa@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
 Nicolin Chen <nicolinc@nvidia.com>, Robin Murphy <robin.murphy@arm.com>,
 Samuel Ortiz <sameo@rivosinc.com>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Steven Price <steven.price@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Thierry Reding <thierry.reding@kernel.org>,
 Vasant Hegde <vasant.hegde@amd.com>, Will Deacon <will@kernel.org>,
 Xu Yilun <yilun.xu@linux.intel.com>, Ashish Kalra <ashish.kalra@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, iommu@lists.linux.dev,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
 linux-tegra@vger.kernel.org, patches@lists.linux.dev,
 Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v9 04/13] iommufd/device: Associate KVM file pointer with
 iommufd_device
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 linux-coco@lists.linux.dev
References: <20261116081935.85372-1-aneesh.kumar@kernel.org>
 <20261116081935.85372-5-aneesh.kumar@kernel.org>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20261116081935.85372-5-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/16/2026 4:19 PM, Aneesh Kumar K.V (Arm) wrote:
> From: Shameer Kolothum<shameerali.kolothum.thodi@huawei.com>
> 
> TSM vDevice support needs access to the KVM associated with a VFIO device
> after the device has been bound to iommufd.
> 
> Extend iommufd_device_bind() to accept the device's KVM file and store it
> in the iommufd_device. The KVM file reference is owned by VFIO and is
> already held for the duration of the device open path.
> 
> Reviewed-by: Kevin Tian<kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
> Signed-off-by: Shameer Kolothum<shameerali.kolothum.thodi@huawei.com>
> [nicolinc: fix build error in iommufd_test_mock_domain()]
> Signed-off-by: Nicolin Chen<nicolinc@nvidia.com>
> [aneesh.kumar: Switch to use kvm_file]
> Cc: Jason Gunthorpe<jgg@ziepe.ca>
> Cc: Kevin Tian<kevin.tian@intel.com>
> Cc: Joerg Roedel<joro@8bytes.org>
> Cc: Will Deacon<will@kernel.org>
> Cc: Robin Murphy<robin.murphy@arm.com>
> Cc: Alex Williamson<alex@shazbot.org>
> Cc:iommu@lists.linux.dev
> Signed-off-by: Aneesh Kumar K.V (Arm)<aneesh.kumar@kernel.org>
> ---
>   drivers/iommu/iommufd/device.c          | 7 ++++++-
>   drivers/iommu/iommufd/iommufd_private.h | 2 ++
>   drivers/iommu/iommufd/selftest.c        | 2 +-
>   drivers/vfio/iommufd.c                  | 3 ++-
>   include/linux/iommufd.h                 | 4 +++-
>   5 files changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
> index 1b0bdf57ac8a..935f42616a65 100644
> --- a/drivers/iommu/iommufd/device.c
> +++ b/drivers/iommu/iommufd/device.c
> @@ -295,6 +295,7 @@ static int iommufd_bind_noiommu(struct iommufd_device *idev)
>    * iommufd_device_bind - Bind a physical device to an iommu fd
>    * @ictx: iommufd file descriptor
>    * @dev: Pointer to a physical device struct
> + * @kvm_file: VM file if device belongs to a KVM VM
>    * @id: Output ID number to return to userspace for this device
>    *
>    * A successful bind establishes an ownership over the device and returns

As discussed during the v8 review, how does this series address the risk
that the KVM file pointer could become invalid if REMOVE_WAIT times out?
The changelog says the extra KVM file reference was dropped. Is the
timeout expected never to occur, or should it be addressed by a broader
fix if it does? How about explaining this in the commit message so
future readers understand why the extra reference isn’t needed.

Thanks,
baolu
