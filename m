Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AAE41170E;
	Fri, 23 Feb 2024 05:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708664822; cv=none; b=T2B+wHfm6djaESHa0TzUqOM6ws1GGL2re7eTQ5wA/sFFk760Hs6ksAKJXZJOl0UUR+m0D99+Uiy/FROMDGmUx4uWzrVYFVl4SlVLUpEij0v4fkvE0wCtspC1e5fQ2zywerY1NCzN4dU/Z0Qp7wyi/jzkuVa8I9e0+WLs45Wy8QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708664822; c=relaxed/simple;
	bh=Vq0DUW3Exv2HDTgkq84X+iSqyIRr3W7hZEMz3qwsbH4=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=mm4QBH4LK1M/DyllY9GxxDmTH2rt2Y2BpS3BpS2QqgakH1dFtNRjJSUfRDiCc1mm8vsvQaYYPCtFSdx1Qb1wQnUbCgO4zrLikUAVIuG3W2vbX3ZGp+dUzaL4LkrGCotZz8DJ1je5CwEFdEE4kEu5Sl6pijJ2AnIgvvJzwzBiV+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mquI5VGy; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mquI5VGy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708664819; x=1740200819;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Vq0DUW3Exv2HDTgkq84X+iSqyIRr3W7hZEMz3qwsbH4=;
  b=mquI5VGyXVxyNLFuy5duYK2VAbTRVjl6/rOC4q5kmKgqyNh001xqfV6l
   LoDujI5qWJ/3HQTGrdmgtSY6iPFLE5Vl6/Ks4iRN5zxLHxQbXUXU0+17t
   BtKoGFN0zHPZHF9CUPcb5VCZHd/D3zmn820LY/yfEXya5pxRM2vNP6YbX
   6kF+BGr2A7Lnb6YV+lh20keDznx7EYYXL84hWg4IxcQ5f0PaurKADzRcU
   wDn4+lz2sw/9bfkSglvEpTFjJzodsyOUyv8m5M3GYNEIld62AF23EyrF4
   K7JvHASOG7KmaVppe+3GVDZ6D4OpJigOnbhZClAB/gQS0oG8AkCWzGTF3
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10992"; a="6778227"
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="6778227"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 21:06:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,179,1705392000"; 
   d="scan'208";a="5766182"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.249.171.186]) ([10.249.171.186])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 21:06:55 -0800
Message-ID: <b6dd12c0-4d2c-432e-96c6-10a24e4b16b1@linux.intel.com>
Date: Fri, 23 Feb 2024 13:06:51 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, Joerg Roedel <jroedel@suse.de>,
 Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
 Tina Zhang <tina.zhang@intel.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH rc] iommu/sva: Restore SVA handle sharing
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>
References: <0-v1-9455fc497a6f+3b4-iommu_sva_sharing_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <0-v1-9455fc497a6f+3b4-iommu_sva_sharing_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/2/22 22:07, Jason Gunthorpe wrote:
> Prior to commit 092edaddb660 ("iommu: Support mm PASID 1:n with sva
> domains") the code allowed a SVA handle to be bound multiple times to the
> same (mm, device) pair. This was alluded to in the kdoc comment, but we
> had understood this to be more a remark about allowing multiple devices,
> not a literal same-driver re-opening the same SVA.
> 
> It turns out uacce and idxd were both relying on the core code to handle
> reference counting for same-device same-mm scenarios. As this looks hard
> to resolve in the drivers bring it back to the core code.
> 
> The new design has changed the meaning of the domain->users refcount to
> refer to the number of devices that are sharing that domain for the same
> mm. This is part of the design to lift the SVA domain de-duplication out
> of the drivers.
> 
> Return the old behavior by explicitly de-duplicating the struct iommu_sva
> handle. The same (mm, device) will return the same handle pointer and the
> core code will handle tracking this. The last unbind of the handle will
> destroy it.
> 
> Fixes: 092edaddb660 ("iommu: Support mm PASID 1:n with sva domains")
> Reported-by: Zhangfei Gao<zhangfei.gao@linaro.org>
> Closes:https://lore.kernel.org/all/20240221110658.529-1-zhangfei.gao@linaro.org/
> Tested-by: Zhangfei Gao<zhangfei.gao@linaro.org>
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

Best regards,
baolu
