Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09542D5C91;
	Wed, 19 Nov 2025 02:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763520708; cv=none; b=FNlz3+M9XJyePbZ6/FAxha3zzjXEDlXjolTfOJP2fAlH8+jVzJ3O35tP+ZDA8TMVQu2ryqEW/xHIca+E40FhIXjNk07Av6u5zm8bgVRj657OZVvezn9DVostGmxngkAnbMqBT3Nlqq34ARFs21NJqOQtiQ5D6/IWP5o+xgSQVgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763520708; c=relaxed/simple;
	bh=Y06lVyS4i4aGeKoISvtJgz0qBkZ8VMKTdchC7Sci+2E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J1+Qze93N+FgnLVRVoOVcQ7PNFka8O0gQ5YhwDlRCmFDAtTPw8rQZh/IehDCK3MvDhrRl5ipvPA+n3oTmdHtKLto25rROwF1CCQ+QgZS5bW4kSB211TartnVPn7jDiGjR6appVfcrLwUHyDxIYWifklOAZTwmD1deppDnT4cOcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BowUQQEd; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BowUQQEd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763520706; x=1795056706;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Y06lVyS4i4aGeKoISvtJgz0qBkZ8VMKTdchC7Sci+2E=;
  b=BowUQQEdQJkQHIY5asAj1TxzwkcLPIsfArq2qBsgd+55iZHFocwgtH/o
   xrrCNYB0x3YPs1py5n3Uyaxpfacj3i4phL+VMuEDkB14z97LTJG0O0trm
   /Lt7C7YFCQ37dG3HewrD0UJsZXFFtSgNP7PVIHqWAfqF7zHzISDT+1j7a
   eCh3FBxUgI6BLje8q1fbUiHNquKLHd7I7ewLz2t6ogHAm1RLEvlRdGpuQ
   Z28VCfXwp8ARZ8YTNrsiuFMLieIfHRso+l7bKA3UEp7flp8s/lt5xxU6I
   SIG7lYCinPX9Qy6cSZD15MarPRcuxvFTaZPplM4TUJH+3xrvhbHQVWNRM
   w==;
X-CSE-ConnectionGUID: D5YcnqotQIO1FHeiw6HIBA==
X-CSE-MsgGUID: xZEu7yvbTZ6wOPu2VwW5IQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="65713817"
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="65713817"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 18:51:46 -0800
X-CSE-ConnectionGUID: ZvvFg8h+RrWzs/+N7veq5g==
X-CSE-MsgGUID: RePARr2fRJO/pW7IoKusCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="221835583"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 18:51:41 -0800
Message-ID: <69ebd6cc-7620-4156-b64c-35ae1344d54f@linux.intel.com>
Date: Wed, 19 Nov 2025 10:47:26 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/5] iommu: Add iommu_driver_get_domain_for_dev()
 helper
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: joro@8bytes.org, afael@kernel.org, bhelgaas@google.com, alex@shazbot.org,
 jgg@nvidia.com, kevin.tian@intel.com, will@kernel.org, robin.murphy@arm.com,
 lenb@kernel.org, linux-arm-kernel@lists.infradead.org,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
 patches@lists.linux.dev, pjaroszynski@nvidia.com, vsethi@nvidia.com,
 helgaas@kernel.org, etzhao1900@gmail.com
References: <cover.1762835355.git.nicolinc@nvidia.com>
 <0303739735f3f49bcebc244804e9eeb82b1c41dc.1762835355.git.nicolinc@nvidia.com>
 <d5445875-76bd-453d-b959-25989f5d3060@linux.intel.com>
 <aRTGwJ2CABOIKtq6@Asurada-Nvidia> <aRwaHMcgQNqV/cCG@Asurada-Nvidia>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <aRwaHMcgQNqV/cCG@Asurada-Nvidia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/25 15:02, Nicolin Chen wrote:
> On Wed, Nov 12, 2025 at 09:41:25AM -0800, Nicolin Chen wrote:
>> Hi Baolu,
>>
>> On Wed, Nov 12, 2025 at 01:58:51PM +0800, Baolu Lu wrote:
>>> On 11/11/25 13:12, Nicolin Chen wrote:
>>>> +/**
>>>> + * iommu_get_domain_for_dev() - Return the DMA API domain pointer
>>>> + * @dev - Device to query
>>>> + *
>>>> + * This function can be called within a driver bound to dev. The returned
>>>> + * pointer is valid for the lifetime of the bound driver.
>>>> + *
>>>> + * It should not be called by drivers with driver_managed_dma = true.
>>>
>>> "driver_managed_dma != true" means the driver will use the default
>>> domain allocated by the iommu core during iommu probe.
>>
>> Hmm, I am not very sure. Jason's remarks pointed out that There
>> is an exception in host1x_client_iommu_detach():
>> https://lore.kernel.org/all/20250924191055.GJ2617119@nvidia.com/
>>
>> Where the group->domain could be NULL, i.e. not attached to the
>> default domain?
>>
>>> The iommu core
>>> ensures that this domain stored at group->domain will not be changed
>>> during the driver's whole lifecycle. That's reasonable.
>>>
>>> How about making some code to enforce this requirement? Something like
>>> below ...
>>>
>>>> + */
>>>>    struct iommu_domain *iommu_get_domain_for_dev(struct device *dev)
>>>>    {
>>>>    	/* Caller must be a probed driver on dev */
>>>> @@ -2225,10 +2234,29 @@ struct iommu_domain *iommu_get_domain_for_dev(struct device *dev)
>>>>    	if (!group)
>>>>    		return NULL;
>>>> +	lockdep_assert_not_held(&group->mutex);
>>>
>>> ...
>>> 	if (WARN_ON(!dev->driver || !group->owner_cnt || group->owner))
>>> 		return NULL;
>>
>> With that, could host1x_client_iommu_detach() trigger WARN_ON?
> 
> Hi Baolu,
> 
> For v6, I tend to keep this API as-is, trying not to give troubles
> to existing callers. Jason suggested a potential followup series:
> https://lore.kernel.org/linux-iommu/20250821131304.GM802098@nvidia.com/
> That would replace this function, so maybe we can think about that.
> 
> If you have a strong feeling about the WARN_ON, please let me know.
> 
> Thanks
> Nicolin

No strong feeling. I am fine with it because the comments have already
stated that "This function can be called within a driver bound to dev.".

Thanks,
baolu
