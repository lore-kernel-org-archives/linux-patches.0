Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116EA34BA36;
	Wed, 24 Sep 2025 02:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758681240; cv=none; b=jmVGvon8MpnOxekZsvcMoDqaxPHiyDdDPyVWWaODHSLk3O1MEZFMdLZzLCqvXOk7r1cOjmU54gzbr8becYdi29+d0hXrONzbQbBUeZedaUgYFW5dLaVl6nkgQxWXkhhvyHCjy8PQT8lUSjhr6MiT4sBoiWhk9pfi6AkaQtTmGdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758681240; c=relaxed/simple;
	bh=ib+muD5DS7aUcjO0eB6Ynr7WHAGzukS+LbzRNuHlVdA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JLHejTYAKcPXZb4Iyui5P91szsX2KHArI606Cks0RYgYeYTrJrsgpH+HmFTnhqPqDbu+GYpDLdN7JMBal3DMKWE32kOJW6bp0X0hxyRHH9O3nXB23oax3vyHAGFtIej73rIppHr11DduB3DXKzxCGNa6Qd78Dzd6xffJyF9Uo7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UWJBYYRT; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UWJBYYRT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758681238; x=1790217238;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ib+muD5DS7aUcjO0eB6Ynr7WHAGzukS+LbzRNuHlVdA=;
  b=UWJBYYRTeNUfuHAmebGSemIiImiprjZmYIZg8TAhHfQN6mwD53kvFKtW
   V2eSpAX+kpboftm1WRF1xh9xCrLCgazaBqTJPQ6uiI40LZze60CWIw45s
   ioYgL076/vGtoVCUjLymOZMRRZ+ucsaySv9rc37PKBjlTwSp89v1xpkSo
   DjN+clngqP9XorlVE+R3Lhs/XLS4HQly73QyMc4jDG3qcJfgh/hhXIWlA
   w4gS7ye/dhLyb/Jr3h2/6VS6j3GfQfxs31Qo3mhDKzMqxF0kvmGdpWf5M
   9/B3vSGHE3boxgr8yz62b+YYeelNB9XCWIWP7EgZ8t6JBcPRiIsWw9F1G
   w==;
X-CSE-ConnectionGUID: qQ5P37ftTTmyLsGEJMoRCw==
X-CSE-MsgGUID: sfjcXGLATR6T18i7T1Nlgw==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="48536518"
X-IronPort-AV: E=Sophos;i="6.18,289,1751266800"; 
   d="scan'208";a="48536518"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 19:33:57 -0700
X-CSE-ConnectionGUID: LZL2QyEuSfCzBBTUhosH8A==
X-CSE-MsgGUID: zrcQ+sHvRa+AXjKr8cq4wg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,289,1751266800"; 
   d="scan'208";a="182186325"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 19:33:54 -0700
Message-ID: <ed99ad0c-f5df-4c3c-a9ec-b271bd59c0b3@linux.intel.com>
Date: Wed, 24 Sep 2025 10:30:52 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/10] iommupt: Flush the CPU cache after any writes to
 the page table
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>, Kevin Tian <kevin.tian@intel.com>,
 patches@lists.linux.dev, Tina Zhang <tina.zhang@intel.com>,
 Wei Wang <wei.w.wang@intel.com>
References: <4-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
 <79da2a28-3c05-4afa-90d8-dfc664f101b1@linux.intel.com>
 <20250922144216.GA1391379@nvidia.com>
 <5f7f2727-f1ba-413e-89de-958256b0002d@linux.intel.com>
 <20250923141010.GN1391379@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20250923141010.GN1391379@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/23/25 22:10, Jason Gunthorpe wrote:
> On Tue, Sep 23, 2025 at 10:17:49AM +0800, Baolu Lu wrote:
>> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
>> index dff2d895b8ab..563ded2eb3b3 100644
>> --- a/drivers/iommu/intel/iommu.c
>> +++ b/drivers/iommu/intel/iommu.c
>> @@ -3370,7 +3370,7 @@ intel_iommu_domain_alloc_second_stage(struct device
>> *dev,
>>          if (((flags & IOMMU_HWPT_ALLOC_NEST_PARENT) &&
>>               !nested_supported(iommu)) ||
>>              ((flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING) &&
>> -            !ssads_supported(iommu)))
>> +            (!ssads_supported(iommu) || !ecap_smpwc(iommu->ecap))))
>>                  return ERR_PTR(-EOPNOTSUPP);
> Also in the compatible check function!

Yes.

> It is an existing issue, please send a formal patch?

Sure. I will follow up with a formal patch.

Thanks,
baolu
