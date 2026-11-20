Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.8
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795137461;
	b=P6cME5oX1OIvbg+RISpTHXRjnlr5auZdR5nEA5Dsr/HXDnigLJ/4f7GHPKyEY+oiJlBz
	 kJjMp8uw3ul0SngDuWkX7vny4a/DrszSDT90n0weCzj/IL7lbBY8gSEQjVsYYllez8ddc
	 m/kl4YSWu9RBpqFWtgmH+0Uy51nl74ok9fWRVAq/J6PhWUskqOvy5i03IWkmxPYrdbH4I
	 HUdukxUcC1ivPNIryKudTtkl2E3tUtS2pfO1K/pWj4HmEpn2KHbLZRSpPHhHBqMLxKlUE
	 oh6CV19Ahhnm8QQXq4qWdisx6tI9Ugz6Dd5n89iF2km93kh0lZY3S24a0uhj3g2Z5kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795137461;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Cc:Subject:To:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=JWqZphWtsTTHGvtPX+nDXnK7WB6OveEljmDurlpZ0No=;
	b=GKn2Qw9e8OvJbZUAkex/KEoqQs2i0rWppAj/5iBLsk+1Ts8aB8zgdZA0zwmI0qgXfyXA
	 5VquVxGiylxDG3+IL2PO/kVXQGfBiLD72OE2FdQtEq2jGmaDg4vocA6u8GiGXonURYnS6
	 vEdq//NamfjKtKccH6RJblSp4UnbWy4r0H+sz8aSfnYmUvAb3K8yQls/Ia3eeCK9R6NB3
	 st9p6mYMlhQG3CH2SC1vdzBpsHF821WXHa5KxqmghGUrvbR7WRz65JMACRhxL94fquKJJ
	 0O6PyvXKMqWUkXLk/iSssoFdW/j53uElpjBnQepOIHD0mVIS9BmXTmF2yIDdKS23nVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=aPghIyo8;
	arc=none smtp.remote-ip=192.198.163.8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B3F606A320;
	Fri, 20 Nov 2026 01:17:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 31B3F606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=aPghIyo8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795137461; x=1826673461;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tSIkeLpI67gd3O+5LLJj1iLHNmboO3o26BMKDZZIKS4=;
  b=aPghIyo8Z1W1kb/cxIa0wLjw6A4YTOtfIdXrqpHYns3irNqFTHetajdl
   Q02ZSeW0gIMQkmldP1A6abda4RmyAWICoDQrr6Ir30/aYonZ5OrwSOt1o
   mKL2psiG51rsaBWssbXryauQPKcyp5Y+s/aMTV5tuR7NV2UNe/VypjQSV
   T8ZP+USZXWvyvitmtDYRPDSzkLq0+ZscmgIuzLqJibTnxJ6/HK+CxQZmF
   MaKRmqSvAi56ep1y3flg+DkdDDDguZ59XkO4V43zya+Wqqf4bcLMHIE+d
   VyCZJsX5LtR3oAXpcUkFlF4pKNlALZJR+2E+3qbkjCgnyMBvBWd0wNC4G
   w==;
X-CSE-ConnectionGUID: z5gLC1FYQ4CrLFSxKtXzRg==
X-CSE-MsgGUID: 14olDiM2Reu/GbIczTnU0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11971"; a="3908755"
X-IronPort-AV: E=Sophos;i="6.27,222,1787036400"; 
   d="scan'208";a="3908755"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 17:17:40 -0800
X-CSE-ConnectionGUID: 6v5FeCvQRiSoxhgN7PCPHA==
X-CSE-MsgGUID: l3gJMTkWTfSiu/FcIwximA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,222,1787036400"; 
   d="scan'208";a="10478625"
Received: from unknown (HELO [10.238.1.144]) ([10.238.1.144])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 17:17:32 -0800
Message-ID: <3201ab57-cba6-4484-8dbd-7cfb79d731cf@linux.intel.com>
Date: Fri, 20 Nov 2026 09:17:30 +0800
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
 linux-tegra@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v9 06/13] iommufd: Add a vDEVICE operation ioctl framework
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 linux-coco@lists.linux.dev
References: <20261116081935.85372-1-aneesh.kumar@kernel.org>
 <20261116081935.85372-7-aneesh.kumar@kernel.org>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20261116081935.85372-7-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/16/2026 4:19 PM, Aneesh Kumar K.V (Arm) wrote:
> Add IOMMU_VDEVICE_OP to execute operations on a vDEVICE using separate
> request and response buffers. Each operation defines its request and
> response formats, with response capacity checked before changing device
> state.
> 
> Look up the vDEVICE and check its supported_ops mask before dispatching
> an operation. Reject out-of-range operation numbers before testing the
> corresponding bit. Backends set the mask during vdevice_init().
> 
> This patch defines no operations. The default dispatch returns
> -EOPNOTSUPP; later patches can add operations independently.
> 
> Cc: Jason Gunthorpe<jgg@ziepe.ca>
> Cc: Kevin Tian<kevin.tian@intel.com>
> Cc: Joerg Roedel<joro@8bytes.org>
> Cc: Will Deacon<will@kernel.org>
> Cc: Robin Murphy<robin.murphy@arm.com>
> Cc: Alexey Kardashevskiy<aik@amd.com>
> Cc: Lukas Wunner<lukas@wunner.de>
> Cc:iommu@lists.linux.dev
> Signed-off-by: Aneesh Kumar K.V (Arm)<aneesh.kumar@kernel.org>
> ---
>   drivers/iommu/iommufd/iommufd_private.h |  1 +
>   drivers/iommu/iommufd/main.c            |  3 +++
>   drivers/iommu/iommufd/viommu.c          | 36 +++++++++++++++++++++++++
>   include/linux/iommufd.h                 |  3 +++
>   include/linux/tsm.h                     |  1 +
>   include/uapi/linux/iommufd.h            | 33 +++++++++++++++++++++++
>   6 files changed, 77 insertions(+)

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
