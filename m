Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3192F5B;
	Tue, 23 Sep 2025 02:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758594054; cv=none; b=oAUf9briyfJqw0Lg68+AJKBUz4Am6fJnDiNK7agJK6TnIOiFgXuL5o7BMpVJDkhnzGtPBXhwOfHPT9Ttb3IjXWpJDTYX/x3gKleocgRuGV7B2UdMqx9/MWmsi91L9Gn7vpWDS6L7u+fdUXLC1kJVyhq+tjTcH+TsmPP5/D1Boak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758594054; c=relaxed/simple;
	bh=kWX9pr0AuXZHYi+0ToIGNK98Z57cWxHLLjQUSfBuq8M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zq8nzR/4xaiaH4VApra3QYXkNQEYGtuPgVd4/txZcs9nB+vId03z4+FESXrTA9sv35JjTEm71rmtz/C4S34EKAv3CTvROgde9Vdbla6Tza8pUkM9wQuM2sDpyrJ9uggPQvBNARlUT9+8incDo7UDy2FAJlyHcwPubPoIA/3ViKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GL+NAffL; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GL+NAffL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758594053; x=1790130053;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kWX9pr0AuXZHYi+0ToIGNK98Z57cWxHLLjQUSfBuq8M=;
  b=GL+NAffLSxBL1EF6O+uXRKYUZEhDAWncoin8Y1DhmPjiPMfKl4e9GGKs
   SR/px8404iBIZJ9jIWABsPlnIskWLVewLk6v8bKuBNTQPK65kubA12gVu
   rmm0JY8jvvgw1dryyEuc7DqHD5NHjoUT7GYkn3NlXFyXp/z4UW3im6TQX
   S9tFMzZWQF7d9A/iAuEIL0sj2JBDXHPbY4rhKRgM1nLN+hCCUZpIAEiiR
   wqP7mGDNamVQbR79p2iANphU+o4ajezCZKqzzV+hr2Fa1h78RQwNxEyu7
   yhYjtrxS3QlS6j9p40LJZxw/E0ziTFnXHz8JteCkK5rWUoesHe6qQCzSv
   A==;
X-CSE-ConnectionGUID: Vu6ss31eR7q9JWbX7xXC6g==
X-CSE-MsgGUID: uljnwFfWRLOow4Lg3+lZkQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="61034281"
X-IronPort-AV: E=Sophos;i="6.18,286,1751266800"; 
   d="scan'208";a="61034281"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 19:20:53 -0700
X-CSE-ConnectionGUID: ScNmo8O+SuWmQC9DrG9iKA==
X-CSE-MsgGUID: +ZLf3YLwS82GhMzoZAoSaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,286,1751266800"; 
   d="scan'208";a="175771200"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 19:20:50 -0700
Message-ID: <5f7f2727-f1ba-413e-89de-958256b0002d@linux.intel.com>
Date: Tue, 23 Sep 2025 10:17:49 +0800
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
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20250922144216.GA1391379@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/22/25 22:42, Jason Gunthorpe wrote:
> On Mon, Sep 22, 2025 at 10:12:15AM +0800, Baolu Lu wrote:
>> On 8/27/25 01:26, Jason Gunthorpe wrote:
>>> @@ -195,6 +218,10 @@ static void record_dirty(struct pt_state *pts,
>>>    				dirty_len);
>>>    	if (!(dirty->flags & IOMMU_DIRTY_NO_CLEAR)) {
>>> +		/*
>>> +		 * No write log required because DMA incoherence and atomic
>>> +		 * dirty tracking bits can't work together
>>> +		 */
>>
>> Could you elaborate a bit on this comment? Is this a hardware or
>> software requirement?
> 
> dirty tracking relies on some kind of atomic operation coherent
> between the IOMMU and CPU. AFAIK this is not possible on any arch
> unless the IOMMU is working coherently.

Yes, fair enough.

> 
>> Are there any software checks or enforcement in
>> the subsystem?
> 
> I expect the iommu drivers to exclude this combination.

For VT-d driver, perhaps we could add below check:

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index dff2d895b8ab..563ded2eb3b3 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3370,7 +3370,7 @@ intel_iommu_domain_alloc_second_stage(struct 
device *dev,
         if (((flags & IOMMU_HWPT_ALLOC_NEST_PARENT) &&
              !nested_supported(iommu)) ||
             ((flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING) &&
-            !ssads_supported(iommu)))
+            (!ssads_supported(iommu) || !ecap_smpwc(iommu->ecap))))
                 return ERR_PTR(-EOPNOTSUPP);

         /* Legacy mode always supports second stage */

Thanks,
baolu
