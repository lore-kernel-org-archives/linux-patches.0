Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AECF17A30A;
	Mon, 16 Jun 2025 03:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750044403; cv=none; b=Cq6TG+5mszs20cNI0UQ0RfrNMHdquHeFvhPqjJ07qc2S0H065cB0V9RyRe20LX9U/t0VTBPnpgoJJ+dG/RIfnFw3iWi6ELcP9VqKbEy8ikZDCyt+DKv3RAEqdtNp0m6Aiq76koFRVlyClSj8TTZfafG/Ddlp1eFtY09ZCMlzdos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750044403; c=relaxed/simple;
	bh=OdSR+LnU8m8mt5Z/YXaqvXjCQ0b6HSOJ3zep8WRESSs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fOg4CBNs9poHTBU5J2X2YOlUSfkPjJi/LvKpJWmFe7rWzmwyymyl5O2BuhNW1k2Q5Lly+tsERnvWLWjUjC1PUMhy0ZFAZ4qA3RHkV5E0M53q9XiHzGf5DvaFV4s0ZoaF1pVlbvEUgJL/7fJ0pj7D5c8U5RDA7izhUG862sqJ3zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f+Lo9Q7Z; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f+Lo9Q7Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750044403; x=1781580403;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OdSR+LnU8m8mt5Z/YXaqvXjCQ0b6HSOJ3zep8WRESSs=;
  b=f+Lo9Q7ZzmW3356mSAcTdg/egpm/czq7YymEvd4CmrxSh5ZR/+4CnhqT
   aJZSOvRgwshjZHnwATKC70DEr/tdPK2x7F32+HXe1POf4bP6rYxjMPBka
   X4QXSLK1PkvHyV1706cW6gJcK0iH6VfnEMj1ZR60W2j6bu9IbCyEHnngX
   O1PToKf7CLQdsgCbFI2R2RijVB2NYuQgObB8QW3k2VoA+Kp9Z6eCC8sHn
   G0dNK1tmoivse15/Rly6NxDe5MxATAF2x9+p6+/t0bVKZ9XBbP1vaFQyr
   myHb5kIwVObWHM942XQ4zEPM9q2z6H8lKcru0oHzZJjSpOkXtt60RJGsl
   A==;
X-CSE-ConnectionGUID: mmzLbC5/RUidxFY7IypMKg==
X-CSE-MsgGUID: qhIuLCGuSuOPWsfrqrGXAw==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="51889557"
X-IronPort-AV: E=Sophos;i="6.16,240,1744095600"; 
   d="scan'208";a="51889557"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2025 20:26:42 -0700
X-CSE-ConnectionGUID: PVYnN9jsR3+8VkdpFkfBvg==
X-CSE-MsgGUID: yh81fqcOQcOBJqZhwK9EVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,240,1744095600"; 
   d="scan'208";a="149229856"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2025 20:26:38 -0700
Message-ID: <fba6404b-62a2-4556-ab49-abffbfc66f8d@linux.intel.com>
Date: Mon, 16 Jun 2025 11:25:39 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/14] iommu: Introduce get_viommu_size and viommu_init
 ops
To: Nicolin Chen <nicolinc@nvidia.com>, jgg@nvidia.com, kevin.tian@intel.com
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org, praan@google.com,
 yi.l.liu@intel.com, peterz@infradead.org, jsnitsel@redhat.com,
 linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <cover.1749882255.git.nicolinc@nvidia.com>
 <3ab52c5b622dad476c43b1b1f1636c8b902f1692.1749882255.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <3ab52c5b622dad476c43b1b1f1636c8b902f1692.1749882255.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/14/25 14:35, Nicolin Chen wrote:
> So far, a vIOMMU object has been allocated by IOMMU driver and initialized
> with the driver-level structure, before it returns to the iommufd core for
> core-level structure initialization. It has been requiring iommufd core to
> expose some core structure/helpers in its driver.c file, which result in a
> size increase of this driver module.
> 
> Meanwhile, IOMMU drivers are now requiring more vIOMMU-base structures for
> some advanced feature, such as the existing vDEVICE and a future HW_QUEUE.
> Initializing a core-structure later than driver-structure gives for-driver
> helpers some trouble, when they are used by IOMMU driver assuming that the
> new structure (including core) are fully initialized, for example:
> 
> core:	viommu = ops->viommu_alloc();
> driver:	// my_viommu is successfully allocated
> driver:	my_viommu = iommufd_viommu_alloc(...);
> driver:	// This may crash if it reads viommu->ictx
> driver:	new = iommufd_new_viommu_helper(my_viommu->core ...);
> core:	viommu->ictx = ucmd->ictx;
> core:	...
> 
> To ease such a condition, allow the IOMMU driver to report the size of its
> vIOMMU structure, let the core allocate a vIOMMU object and initialize the
> core-level structure first, and then hand it over the driver to initialize
> its driver-level structure.
> 
> Thus, this requires two new iommu ops, get_viommu_size and viommu_init, so
> iommufd core can communicate with drivers to replace the viommu_alloc op:
> 
> core:	viommu = ops->get_viommu_size();
> driver:	return VIOMMU_STRUCT_SIZE();
> core:	viommu->ictx = ucmd->ictx; // and others
> core:	rc = ops->viommu_init();
> driver:	// This is safe now as viommu->ictx is inited
> driver:	new = iommufd_new_viommu_helper(my_viommu->core ...);
> core:	...
> 
> This also adds a VIOMMU_STRUCT_SIZE macro, for drivers to use, which would
> statically sanitize the driver structure.
> 
> Suggested-by: Jason Gunthorpe<jgg@nvidia.com>
> Signed-off-by: Nicolin Chen<nicolinc@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
