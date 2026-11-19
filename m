Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795072747;
	b=O4JXq1ZpETIuQ7yjrcM9rgKmDwH16WXu9q3HM2fB44se1hSeRh4pK1qUY/zeB8oFi9Wj
	 zh/K3OtcwXA/awRVwrh7cszbJ0WwFUoJjtMVQ4jgaqLZkUyvIG88CC9Em/oBHdmT1v51w
	 8GpoQ+Uo3/XF7wFIwBBPI2bu/gSb6wJcG+ePgyS+qTtaEAWr9j5B1UzuMDCw0aqdhTnyy
	 FGAHL/rCe8Ci0yLeRDNpK91mGgv3wPJlQzD7G5GYdFqw+uluMetSIDavtYgRve6iuEziM
	 T3OwxWtL0oAKpqE3tOYWNGKDPcgDUEPbros1FjIHyrUL0z8s1kH/XX0OxtLCpSY3qAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795072747;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Cc:Subject:To:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=E7h8y9q5NeM+rdkgTl7ssLz1V6qUb/C0JHpQHZ+0bxs=;
	b=DGZXMj4Ra8Xt0Xm10+0GRfVoHfnVl56iLwjQnkbR/Xmel4ITwtfwcs3IN5WddQHnSkpY
	 u5pZXIE0ICYW/epHjdwIyuYw+OPqS6xucy7FnA4sVax6VmvYzD1eTaIpY+JZJ+XxCdoao
	 3l3Z96QYFVx007hBpAhig4P/c0eXjg8keH7V5K4aOLaKvK1uKJY2j+UkZGosnHWwdgXCx
	 6tgym2IBjgZJkLs09f1nfv2hipQlwXAKhCUF5CLMI+kPGmaWBHsbOo5/0Hr34PEJ8RKmr
	 fDczVSo9JKhKuk2zObbJgk7qvGyvThxxEg2yxSpeyWrccFuIneBQ1UzMsWESb6HoY2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.intel.com;
	spf=pass smtp.mailfrom=linux.intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=PZ0zE6AQ;
	arc=none smtp.remote-ip=198.175.65.21
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2270A606A332;
	Thu, 19 Nov 2026 07:19:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2270A606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=PZ0zE6AQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795072747; x=1826608747;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3DN1/OgZfO6kqe/noeYjCjobh7lUNxQjvfpeYc0fl00=;
  b=PZ0zE6AQUr7rSBE2UfbYoC68H7paaWqJGSO4qi3nTvPeqaeU6XyM+kIC
   p0J6V40KWpUqUxhiCdFSM2Eg5KSBJ4658BjdpmA3ZIKPrLbpPOqUF80+W
   /yHCVzC04/Sl9hh8cERH83ie2B/z7hiDAZp/bvI450e/4wMpoOwrgyKp4
   3rVCbFZltMLEpJQuntX61CRgbeI47TPV5IASkVhbGL8QkDwBOaG/cZjzs
   B3JFvK3kdVfvlmXgCBKikOdJcg/yANTVjcgVsxLQVdsiuK2WSsiyzNYyW
   umkF+IWWjvvdGY4DiySzUQmuP23hA+4JynRwC9jnujTTR7II84HgeFeMw
   w==;
X-CSE-ConnectionGUID: yWvX0ogcQQCjG13AHpQtHw==
X-CSE-MsgGUID: n5k71yhvQ6O5Soj5VkRm7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11970"; a="3991644"
X-IronPort-AV: E=Sophos;i="6.27,220,1787036400"; 
   d="scan'208";a="3991644"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2026 23:19:06 -0800
X-CSE-ConnectionGUID: iHQUrNNQQoW2AgElOEgTwA==
X-CSE-MsgGUID: 4Ehj8R4lSQCZoiG7usmh1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,220,1787036400"; 
   d="scan'208";a="10453034"
Received: from unknown (HELO [10.238.1.144]) ([10.238.1.144])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2026 23:18:56 -0800
Message-ID: <a594edd6-6184-4381-9b48-004c18efa56f@linux.intel.com>
Date: Thu, 19 Nov 2026 15:18:54 +0800
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
Subject: Re: [PATCH v9 01/13] virt: coco: tsm: Require PCI operations when
 registering a TSM
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 linux-coco@lists.linux.dev
References: <20261116081935.85372-1-aneesh.kumar@kernel.org>
 <20261116081935.85372-2-aneesh.kumar@kernel.org>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20261116081935.85372-2-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/16/2026 4:19 PM, Aneesh Kumar K.V (Arm) wrote:
> Reject a NULL pci_ops argument in tsm_register(). Every registered TSM
> then has PCI operations, so registration no longer needs separate paths
> for TSMs without them.
> 
> Cc: Alexey Kardashevskiy<aik@amd.com>
> Cc: Jason Gunthorpe<jgg@ziepe.ca>
> Cc: Lukas Wunner<lukas@wunner.de>
> Cc:linux-coco@lists.linux.dev
> Signed-off-by: Aneesh Kumar K.V (Arm)<aneesh.kumar@kernel.org>
> ---
>   drivers/virt/coco/tsm-core.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
