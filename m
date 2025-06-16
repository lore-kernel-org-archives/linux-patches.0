Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D3727454;
	Mon, 16 Jun 2025 07:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750057965; cv=none; b=RDgq+5ZzZPviIyjSNhHxLntrzrT7JHqAYaEwwabZhRdhAT6wOkzmePn/OaQ0DfitaGpN3pNTkAG/uJEL3h2aMbvgmBTeZ0jAXfH8ElqjlnaXORK4v+NVay5Tto1Xj6l8KWrEq2Lt2rcG5rgKyh8CYubpCHjOFVJ8JzIb+izoCY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750057965; c=relaxed/simple;
	bh=xacBKMgmFTMZBZEnYG/hW2BtKPaY7xU5btWyaSE3iwY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ci4VfOpwpuRKGb3idcLQazuARHsUwbsHmodtyREZN4rQI5P9Z32VBXo6owAD+5LFdFPzjsB4sfZPDTvczO3498WlOqdBgDQ5ZsGI+vAYmfZ5QvOx78rxDluUZPs9ftYPL+mldiXLE1v5XrTyUiHgPdlCM4JDKzvuQAE951gqWeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HbTgNI/B; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HbTgNI/B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750057964; x=1781593964;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xacBKMgmFTMZBZEnYG/hW2BtKPaY7xU5btWyaSE3iwY=;
  b=HbTgNI/BcInoeSjn2dwcDplbomMHSXKoK+Cg+G6djkaxm9u37f24k4h4
   6+B8y9+RdZJTwTecqTNe+MmhzlWDqMWo8ubdsUdFDg1XKN4bsEDrMknQ4
   k9Na+q234GE+KMzF3oQofUOwKHkQWoDsIlBNr7sdhlFzsodpm7r3bU2zx
   RynFwCzoMT1HtbA5yGazyKUHdcNM+XG4fihLKb9UhleNd42Pvl6P9rOVJ
   eQC4ijkMquho+leSI0S2BAxfT5tBXw8b7Lhw7ya9yFjXPjLFxnkLpLoH+
   iPJJcQp2M3JqokXPr05Vl+V4E5uiXSjC6DKFkGDChOI0wSmQLDYKML7Ow
   w==;
X-CSE-ConnectionGUID: 5IySNJ4eREikl4lnYkTOqA==
X-CSE-MsgGUID: 1abhIlq0T6Sw1mmdKmqLOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="55866586"
X-IronPort-AV: E=Sophos;i="6.16,240,1744095600"; 
   d="scan'208";a="55866586"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 00:12:44 -0700
X-CSE-ConnectionGUID: HjGOjZ05Sou9BY7TtQfcPA==
X-CSE-MsgGUID: /QmppINgRhqjZEZzCyDuPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,240,1744095600"; 
   d="scan'208";a="148290800"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 00:12:37 -0700
Message-ID: <8b57d3fb-bc0c-4ab6-8a53-22d93718b422@linux.intel.com>
Date: Mon, 16 Jun 2025 15:11:37 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 10/25] iommufd/viommu: Add IOMMUFD_CMD_HW_QUEUE_ALLOC
 ioctl
To: Nicolin Chen <nicolinc@nvidia.com>, jgg@nvidia.com, kevin.tian@intel.com,
 corbet@lwn.net, will@kernel.org
Cc: bagasdotme@gmail.com, robin.murphy@arm.com, joro@8bytes.org,
 thierry.reding@gmail.com, vdumpa@nvidia.com, jonathanh@nvidia.com,
 shuah@kernel.org, jsnitsel@redhat.com, nathan@kernel.org,
 peterz@infradead.org, yi.l.liu@intel.com, mshavit@google.com,
 praan@google.com, zhangzekun11@huawei.com, iommu@lists.linux.dev,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
 linux-kselftest@vger.kernel.org, patches@lists.linux.dev, mochs@nvidia.com,
 alok.a.tiwari@oracle.com, vasant.hegde@amd.com, dwmw2@infradead.org
References: <cover.1749884998.git.nicolinc@nvidia.com>
 <7dfb002613f224f57a069d27e7bf2b306b0a5ba0.1749884998.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <7dfb002613f224f57a069d27e7bf2b306b0a5ba0.1749884998.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/14/25 15:14, Nicolin Chen wrote:
> Introduce a new IOMMUFD_CMD_HW_QUEUE_ALLOC ioctl for user space to allocate
> a HW QUEUE object for a vIOMMU specific HW-accelerated queue, e.g.:
>   - NVIDIA's Virtual Command Queue
>   - AMD vIOMMU's Command Buffer, Event Log Buffers, and PPR Log Buffers
> 
> Since this is introduced with NVIDIA's VCMDQs that access the guest memory
> in the physical address space, add an iommufd_hw_queue_alloc_phys() helper
> that will create an access object to the queue memory in the IOAS, to avoid
> the mappings of the guest memory from being unmapped, during the life cycle
> of the HW queue object.
> 
> Reviewed-by: Pranjal Shrivastava<praan@google.com>
> Reviewed-by: Kevin Tian<kevin.tian@intel.com>
> Signed-off-by: Nicolin Chen<nicolinc@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
