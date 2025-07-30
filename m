Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6CE2E36E0;
	Wed, 30 Jul 2025 02:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753843089; cv=none; b=cB2b91JTPBbIC1OEQC5yV2FOjzANddvMaP868zaemxi8GQrz3yhKWF6xjSPg9mpSJ1/alI+oZXldXR/sp4Q4b9rj7FgahBjenPS+MANXPhSM9gaH0ZcQW5aasBK9zXx217y4FyvQc2+RHuW1wynkLWuWKHf5dOtS6qRDmgSnYUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753843089; c=relaxed/simple;
	bh=pjFFOfbPQCYPs9ZWZ7vWB/pbdm/ntxgWz06mCJtOFdk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JXhd8Y0b359pQGwNlXf2P/NCanvnDzLXicy5WgUMNGHyYBtbuN49suD80w1QheskRbM1b4kKngOVvkhSAd6H/f00YjLyposDewaGa0J9Umi8/1Ic0pb1EFGBMe8PtR3czpFgKhIhplJHMVneqeyo131dyrCERJumLPptc1hHw+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l/WSxGpF; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l/WSxGpF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753843087; x=1785379087;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pjFFOfbPQCYPs9ZWZ7vWB/pbdm/ntxgWz06mCJtOFdk=;
  b=l/WSxGpF11bcfeSrMjVVTu7EoKIYXHnK4QSOcCp935AkPUG48Gv7uIwD
   qFzUrIXo+HvVuzpQBlOC7FEyyLvkStI+keQ2PfeSoX02n9rB8vxr9u1k0
   G0HD793QvJBkrf0+NGA/VzaE2I6mFwdizYShYVCMahJ6mKBIPdK087GJg
   lZM0RZ04iSBra7UC6IOpZXIy/3tW6Q29tb2Zd7xx6/qCZIKcphDQn6IGY
   S3K/TWKiAoXtZYsAmYnXsnTGD+D3rYCWX8ckBCe4iIDj43OhsjMbXiey7
   mi61rXrTJTBLG4MITCzbaoxo0/gt5xZ7nJaQpTjLfF/+3jtCE6+Avme7m
   g==;
X-CSE-ConnectionGUID: WjT2n67tR0SEkQCftxLl2w==
X-CSE-MsgGUID: c4PYyr5ESF+ir4bWtR590Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11506"; a="59946831"
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="59946831"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 19:38:01 -0700
X-CSE-ConnectionGUID: coLLy+d0TLu0EXYj2z+1ug==
X-CSE-MsgGUID: ECPpdZOURTW0xCN9GhtdDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="186533567"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 19:37:55 -0700
Message-ID: <f15dc6cb-f936-4f3c-9282-184f37e472cc@linux.intel.com>
Date: Wed, 30 Jul 2025 10:35:38 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/9] iommupt/x86: Support SW bits and permit
 PT_FEAT_DMA_INCOHERENT
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>, Kevin Tian <kevin.tian@intel.com>,
 patches@lists.linux.dev, Tina Zhang <tina.zhang@intel.com>,
 Wei Wang <wei.w.wang@intel.com>
References: <7-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
 <158774a0-824f-42a7-93c9-fb1e0d258cc7@linux.intel.com>
 <20250729231314.GE82395@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20250729231314.GE82395@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/25 07:13, Jason Gunthorpe wrote:
> On Tue, Jul 22, 2025 at 01:17:59PM +0800, Baolu Lu wrote:
>>> +static inline u64 x86_64_pt_sw_bit(unsigned int bitnr)
>>> +{
>>> +	/* Bits marked Ignored/AVL in the specification */
>>> +	switch (bitnr) {
>>> +	case 0:
>>> +		return BIT(9);
>>> +	case 1:
>>> +		return BIT(11);
>>> +	case 2 ... 12:
>>> +		return BIT_ULL((bitnr - 2) + 52);
>>
>> Just out of curiosity, why bit 63 can't be used as the sw bit?
> 
> It is not ignored, but used for XD/NX:
> 
> 	X86_64_FMT_XD = BIT_ULL(63),
> 
> Which should comes out for ATS replies.
> 
> The existing drivers didn't wire it up, so I left it alone as well,

The VT-d driver once had such support, but it was removed by commit
e995fcde6070 as the VT-d architecture doesn't support it anymore.

commit e995fcde6070f0981e083c1e2e17e401e6c17ad9
Author: Lu Baolu <baolu.lu@linux.intel.com>
Date:   Tue Jul 2 21:08:35 2024 +0800

     iommu/vt-d: Remove control over Execute-Requested requests

     The VT-d specification has removed architectural support of the 
requests
     with pasid with a value of 1 for Execute-Requested (ER). And the 
NXE bit
     in the pasid table entry and XD bit in the first-stage paging 
Entries are
     deprecated accordingly.

     Remove the programming of these bits to make it consistent with the 
spec.

     Suggested-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
     Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
     Reviewed-by: Kevin Tian <kevin.tian@intel.com>
     Link: 
https://lore.kernel.org/r/20240624032351.249858-1-baolu.lu@linux.intel.com
     Link: 
https://lore.kernel.org/r/20240702130839.108139-4-baolu.lu@linux.intel.com
     Signed-off-by: Will Deacon <will@kernel.org>


> but the XD should be linked to IOMMU_NOEXEC. There are some little
> things like this we can evaluate after. The idea here is to try hard
> to make no change to the drivers existing behavior.

Yeah, we can carve out that bit for now and evaluate it later, given
that we already have enough sw bits.

Thanks,
baolu
