Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D199917BD9;
	Wed, 30 Jul 2025 02:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753840948; cv=none; b=dKslIBGtMi0ZwmG6q01maF/qeewjnzZles7mgVuOzjaaUUlePrq85QuHnm/O+JgWadhdI2wF8JSC60/eOJDlBMzKW1za25bR2n6zx1UpsX8EwjSH9+Y8TePLPh84xo7j9NfrV3B8JOipOHKd70sEv54tsVUyAn5c8KvHmTu57OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753840948; c=relaxed/simple;
	bh=fnyCNz+4iMDEG9ouRGchQ7hEGKbqymufcyH6SUVKndE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rixjDb+pyjmkeLVwb+0hms1rwHG2LWe3MqqdOuB8TlyPOcNBXpcoLo6gLJvdo6sQzGh/T6KZJr5m+Mul+l9m0SuOyFoji107dfij8vrua2WXbQXt5ObY+kX2M/AKr9TjKJ0icGx9e67Fih7N3f41XM461QYpXL0CtztfMEKo6W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CQnKegVZ; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CQnKegVZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753840947; x=1785376947;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fnyCNz+4iMDEG9ouRGchQ7hEGKbqymufcyH6SUVKndE=;
  b=CQnKegVZVlAuIXB56NJb1Q9zQ27h+dcgqztI/kkguH+NVt6YlHsruydh
   wIs64cGeG32YE58xRbltM5lsT20/vnb+/UQFvp1p5QGlU5IzDcP47iwfh
   FAZMJJuwJPWidOvRP5utqVbPAzFBrCROkr7ayF1RhPkM6siiG0G4s7iOA
   05wG/t69r37ku/6tPYlFXshb+wtXSIRVFhRa4mT8qwM3VPZNXN5nR6qSe
   0VlxJrY1WTzNKfLx5GSS5frO7M2/Ei9Mxqh1Jr3YaCp5LtcXRuOVahJSt
   NJx9uu1BtesBO1uoMhxoJt+j+80abtmI7EkuJiJYeWY1/Mz06xvE+FanG
   g==;
X-CSE-ConnectionGUID: t6QC11kFTZKwjraU3V+ZCA==
X-CSE-MsgGUID: OoyTkVQDRHmwkIXm5++5Wg==
X-IronPort-AV: E=McAfee;i="6800,10657,11506"; a="58752672"
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="58752672"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 19:02:26 -0700
X-CSE-ConnectionGUID: 5EDOjo7fQSu/VPbLVpDGWA==
X-CSE-MsgGUID: 35hUmqlSTP+mVIOxIKeZIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="193850522"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 19:02:24 -0700
Message-ID: <0069af21-1238-4a5d-8e23-c2db07d3b124@linux.intel.com>
Date: Wed, 30 Jul 2025 10:00:08 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/9] iommupt: Add the Intel VT-D second stage page table
 format
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>, Kevin Tian <kevin.tian@intel.com>,
 patches@lists.linux.dev, Tina Zhang <tina.zhang@intel.com>,
 Wei Wang <wei.w.wang@intel.com>
References: <5-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
 <529ca56f-5bdc-47ad-8d0d-6b3b5c800c7a@linux.intel.com>
 <20250729230518.GD82395@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20250729230518.GD82395@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/25 07:05, Jason Gunthorpe wrote:
> On Tue, Jul 22, 2025 at 11:11:02AM +0800, Baolu Lu wrote:
>>> diff --git a/drivers/iommu/generic_pt/Kconfig b/drivers/iommu/generic_pt/Kconfig
>>> index 953856e4b48369..b631cf00eba559 100644
>>> --- a/drivers/iommu/generic_pt/Kconfig
>>> +++ b/drivers/iommu/generic_pt/Kconfig
>>> @@ -56,6 +56,17 @@ config IOMMU_PT_RISCV64
>>>    	  Selected automatically by an IOMMU driver that uses this format.
>>> +config IOMMU_PT_VTDSS
>>> +       tristate "IOMMU page table for Intel VT-D IOMMU Second Stage"
>>> +	depends on !GENERIC_ATOMIC64 # for cmpxchg64
>>> +	default n
>>
>> The default value is a "n". So what's the value of putting a "default n"
>> here?
> 
> I do not know, I cargo culted this from somewhere else, lots of
> examples. Do you think we should drop it?

If there's no special purpose, I'd suggest dropping it.

> 
>>> @@ -72,6 +83,7 @@ config IOMMU_PT_KUNIT_TEST
>>>    	depends on KUNIT
>>>    	depends on IOMMU_PT_AMDV1 || !IOMMU_PT_AMDV1
>>>    	depends on IOMMU_PT_RISCV64 || !IOMMU_PT_RISCV64
>>> +	depends on IOMMU_PT_VTDSS || !IOMMU_PT_VTDSS
>>
>> This line implies that the IOMMU_PT kunit test functions regardless of
>> whether IOMMU_PT_VTDSS is enabled. But if IOMMU_PT_VTDSS is enabled,
>> this kunit test will also cover it. Do I understand this correctly?
> 
> Yes.
> 
> The kunit test will build a unique:
> 
> kunit_test_suites(&NS(generic_pt_suite));
> 
> For VTDSS if it is compiled in and that macro eventually drops an ELF section:
> 
> 	__used __section(".kunit_test_suites") = { __VA_ARGS__ }
> 
> And then the linker and some kunit magic will automatically run it
> just be virtue of having compiled it.
> 
> The odd || expression is a kconfig trick that ensures that the kunit
> and vtdss have compatible modularity. ie the kunit cannot be built in
> while the vtdss is modular.

Thanks for the explanation.

> 
>>> +static inline enum pt_entry_type vtdss_pt_load_entry_raw(struct pt_state *pts)
>>> +{
>>> +	const u64 *tablep = pt_cur_table(pts, u64);
>>> +	u64 entry;
>>> +
>>> +	pts->entry = entry = READ_ONCE(tablep[pts->index]);
>>> +	if (!entry)
>>> +		return PT_ENTRY_EMPTY;
>>
>> Would it be more reasonable to check the present bit of the entry
>> here?
> 
> VTDSS has no present bit? Did I misunderstand that in the spec?

You are right. The VT-d spec doesn't define the present bit for the SS
paging entries. Historically, the VT-d driver treats the R (bit 0) field
as the present bit.

> 
> IIRC this design uses all bits as 0 to mean non-present.
> 
>> Otherwise, it implies that when a PTE is non-present, all fields must be
>> cleared. I'm concerned about any potential corner cases.
> 
> Since this code makes all the PTEs it does do that correctly, and we
> have a great test suite that looks for corner cases :)

Okay, fair enough.

> 
>>> +static inline int vtdss_pt_iommu_set_prot(struct pt_common *common,
>>> +					  struct pt_write_attrs *attrs,
>>> +					  unsigned int iommu_prot)
>>> +{
>>> +	u64 pte = 0;
>>> +
>>> +	/*
>>> +	 * VTDSS does not have a present bit, so we tell if any entry is present
>>> +	 * by checking for R or W.
>>> +	 */
>>> +	if (!(iommu_prot & (IOMMU_READ | IOMMU_WRITE)))
>>> +		return -EINVAL;
>>> +
>>> +	if (iommu_prot & IOMMU_READ)
>>> +		pte |= VTDSS_FMT_R;
>>> +	if (iommu_prot & IOMMU_WRITE)
>>> +		pte |= VTDSS_FMT_W;
>>> +	if (pt_feature(common, PT_FEAT_VTDSS_FORCE_COHERENCE))
>>> +		pte |= VTDSS_FMT_SNP;
>>
>> The comment says:
>>
>>   /*
>>    * The PTEs are set to prevent cache incoherent traffic, such as PCI no
>>    * snoop. This is set either at creation time or before the first map
>>    * operation.
>>    */
>>    PT_FEAT_VTDSS_FORCE_COHERENCE = PT_FEAT_FMT_START,
>>
>> It seems that you are okay with setting this feature after iommu_pt
>> creation and before the first map operation?
> 
> Yes it works as it is now.
> 
>> Do we still need to reform the enforce_cache_coherency callback
>> mechanism?
> 
> I think that was motivated by the code in the driver, not so much this
> code?

I ever thought both.

> I can't recall the detail right now but I didn't think it was a
> very high priority.

Okay, so I'll treat that as a driver improvement, not a feature required
by this series.

Thanks,
baolu
