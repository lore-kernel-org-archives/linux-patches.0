Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F8F362130;
	Thu,  2 Apr 2026 07:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775114515; cv=none; b=ZYi6BdI7RP6AmRQG7xaDB+CpkUAWav8IhNnf02ClKbl3tfcqQrf2xXTapwlA716CDNYa4VdlMLF/SPzcMFaWI7HNiZ+Udby6Zo22aIFaiulQ4e47yfG02mjWLKSChDP5bL05ZGnqCrKvkCAPOJyHFhYJLGwspotewzZQnt86hbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775114515; c=relaxed/simple;
	bh=+JL6oivdWMuarfg8ypyK6cJSWP8sxlSEMnLAR6dnftQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KtMlNRYrmPypEQ7mcNxtCXzAE4++aP3lbpPXRhmW97/a1AwlNce/eMBZStvtUCkHA/uLBsD/P+vHi9j6AyZzVJNXuXqsQALQ3BPLmoEUaNEjDRQifnV3Sh/pNFYDCpEwFSlzemnyvZmNJ512FRRCPYKXHfd+IVkJqxOODN0zr+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=foizvHMb; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="foizvHMb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775114514; x=1806650514;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+JL6oivdWMuarfg8ypyK6cJSWP8sxlSEMnLAR6dnftQ=;
  b=foizvHMbqeOBL7OF6NGlNWPPbHhU22Twd/rtZW/CXL7B8d5HDWT4IDNA
   iwQxgk3VNCuE2e83eUtRY2s9jwFGIoRT5rDQSEvw3kGiwTAbO7qDM3ECw
   XHb+nDFJpeY3pqWghXlvyzCrxybxdLsRuXQMXF4wanE1YQkbHQbh6n6n+
   JpWM0pQP8e+sprrrhBZ8Q3dmAmQaV5MILJiqFkzCupw1BOx9JgzgXYudT
   YGLT0fm958RzcjJFNs9dsD62CZHshkAlu7fXAmas2plE/y68qUyJqVS7D
   hdMltNsipLqFvJSp5Cd4Zx0uA8Ok17I3PJcuIe6mG6H98lRtHEiTQeDe0
   g==;
X-CSE-ConnectionGUID: SrwAZ7pWSFmSN4jBrUV3Qg==
X-CSE-MsgGUID: x7sBt/a/T4eEjpZbcrq2XQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11746"; a="76132746"
X-IronPort-AV: E=Sophos;i="6.23,155,1770624000"; 
   d="scan'208";a="76132746"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2026 00:21:53 -0700
X-CSE-ConnectionGUID: sdpQeQsERcOkb5V7Gt8O0g==
X-CSE-MsgGUID: KSJRlnv9TImaJg/mr20mXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,155,1770624000"; 
   d="scan'208";a="226763487"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2026 00:21:50 -0700
Message-ID: <0de8ad11-3520-492b-9411-a4ab9bac2dd3@linux.intel.com>
Date: Thu, 2 Apr 2026 15:20:22 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] iommu/intel: Split piotlb invalidation into range and
 all
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
 patches@lists.linux.dev
References: <1-v1-f175e27af136+11647-iommupt_inv_vtd_jgg@nvidia.com>
 <ef82f6be-fecf-469b-9df0-88a7a004923a@linux.intel.com>
 <20260330153126.GU310919@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20260330153126.GU310919@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/30/26 23:31, Jason Gunthorpe wrote:
>>> @@ -1168,6 +1166,7 @@ void qi_flush_iotlb(struct intel_iommu *iommu, u16 did, u64 addr,
>>>    void qi_flush_dev_iotlb(struct intel_iommu *iommu, u16 sid, u16 pfsid,
>>>    			u16 qdep, u64 addr, unsigned mask);
>>> +void qi_flush_piotlb_all(struct intel_iommu *iommu, u16 did, u32 pasid);
>> [...]
>>
>>>    void qi_flush_piotlb(struct intel_iommu *iommu, u16 did, u32 pasid, u64 addr,
>>>    		     unsigned long npages, bool ih);
>> qi_flush_piotlb() has been removed by this patch. Therefore above
>> declaration should also be cleaned.
> Ooops that hunk got into a later patch, I shifted it back

The rest of the series looks great to me. I have applied this change
manually and included the patches in my pull request to Joerg:

https://lore.kernel.org/linux-iommu/20260402065734.1687476-1-baolu.lu@linux.intel.com/

Please let me know if I missed anything.

Thanks,
baolu
