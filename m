Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA49D37DE93;
	Tue,  3 Mar 2026 03:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772510219; cv=none; b=dxjCpN9fAbhhJCqvilhjlBkUzCiHjMX5/nS6Gti9GePAQS8YfqYuvavn46EghwIy+cqKGFM8B3SpJFl8YmB+/vhUuTH6ScuyYIKkYo/cjU/DEr9h00kkJwCqAY+d8C82LSwip9cDJxXyqeTN/94pyi+o9JbHoaIBbcCb4EliSlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772510219; c=relaxed/simple;
	bh=4PjLlcf3aGwEc2c7Vmi86O7dXU6ZqbUF2VHr/pah2/g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YXPvVKtTQwwNPVyGHu9A+TZu+G51C6h89JUhwFbHBdlfkHZmKBzRtt+t5MSRYQuzKNHQK5jDcXotXPG0mGx/y5Gci6D5WW4VNIyaFdPk+C7/1ItchdGEMnTqaPZYNGzXsmCFVZXFWbWltWXaKqsy8/wxiAmAnCb4pwfJZF4ePgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IR4AA9zF; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IR4AA9zF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772510219; x=1804046219;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4PjLlcf3aGwEc2c7Vmi86O7dXU6ZqbUF2VHr/pah2/g=;
  b=IR4AA9zF0mMNijwkm8VoIOe2p02kYGW3+bI23UFpcjXc7gnJZsV2lG6D
   VbmCTbr4bU1FAyRmC/CzP1aK/1zp8J2u6a9O/On5jjUyFI9n4CJUMQ43R
   qj3w6WR+bSXIfMQYDJpeeGx3siR9PY9dbXAJuyKH3w6luFIFtwJe5tqWn
   H8I9L1ISSJa8v2+na3x+3bjtCmW+QsiG8vfBnE3QNbYpfNj/A7KgLgsce
   I/nlhirRD4KhP9Nd0GnATq3ihSoOEf2oyai9wswn1IBbOscqUUCClda4a
   03ovqk8O3P6EYdmcufISHCstgvjqr9mh3fsy/wwA41lqzeHxM1l8ewNlT
   w==;
X-CSE-ConnectionGUID: ZrKDmm4NS7Cg+IxbfTwtag==
X-CSE-MsgGUID: 3/iYWnmMR9K2tUfz3unIoQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="72561686"
X-IronPort-AV: E=Sophos;i="6.21,321,1763452800"; 
   d="scan'208";a="72561686"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 19:56:58 -0800
X-CSE-ConnectionGUID: iltafcIyQK+nm7TBBPDPog==
X-CSE-MsgGUID: QCuZTdXFRf2KEg5EdDvNew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,321,1763452800"; 
   d="scan'208";a="217858443"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 19:56:25 -0800
Message-ID: <44368869-5906-47e4-ab14-8ddf1233e365@linux.intel.com>
Date: Tue, 3 Mar 2026 11:55:49 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/2] Let iommupt manage changes in page size internally
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>
Cc: Kevin Tian <kevin.tian@intel.com>, patches@lists.linux.dev,
 Samiullah Khawaja <skhawaja@google.com>
References: <0-v3-a1777ea76519+370f-iommpt_map_direct_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <0-v3-a1777ea76519+370f-iommpt_map_direct_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/28/26 03:30, Jason Gunthorpe wrote:
> Currently the core code has some helpers that use iommu_pgsize() to
> fragment operations into single page-size chunks and then the driver has a
> simplified single-page size implementation. This was helpful in
> simplifying the driver code.
> 
> However, iommupt has a single shared implementation for all formats so we
> can accept a little more complexity. Have the core code directly call
> iommupt with the requested range to map/unmap and rely on it to change the
> page size across the range as required.
> 
> The iommupt implementation of unmap is already fine to work like this, and
> the map implementation can reset its walking paramters in-place with a
> little more code.
> 
> The net result is about a 5% performance bump in the simple iommupt
> map/unmap benchmarks of mapped alignment, and probably more for
> unaligned/oddly sized ranges that are changing page sizes.
> 
> Introduce a iommupt_from_domain() function as a general way to convert
> an iommu_domain to a struct pt_iommu if it is a iommupt based domain. I
> expect to keep using this as more optimizations are introduced.
> 
> v3:
>   - Rebase to v7.0-rc1
> v2:https://patch.msgid.link/r/0-v2-973a6bdc820f+693- 
> iommpt_map_direct_jgg@nvidia.com
>   - Rebase to latest iommu tree
>   - Adjust to the IOMMU_DEBUG_PAGEALLOC work
>   - Fix missed trace calls for both map and unmap
>   - Add a comment explaining the level changes
> v1:https://patch.msgid.link/r/0-v1-d7be57da596d+3f8c0- 
> iommpt_map_direct_jgg@nvidia.com
> 
> Jason Gunthorpe (2):
>    iommupt: Directly call iommupt's unmap_range()
>    iommupt: Avoid rewalking during map
> 
>   drivers/iommu/generic_pt/iommu_pt.h         | 162 +++++++++++---------
>   drivers/iommu/generic_pt/kunit_generic_pt.h |  12 ++
>   drivers/iommu/generic_pt/pt_iter.h          |  22 +++
>   drivers/iommu/iommu.c                       |  66 ++++++--
>   include/linux/generic_pt/iommu.h            |  69 +++++++--
>   include/linux/iommu.h                       |   1 +
>   6 files changed, 231 insertions(+), 101 deletions(-)

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
