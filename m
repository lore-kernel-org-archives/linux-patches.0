Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A3C2882D6;
	Mon, 16 Jun 2025 03:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750044508; cv=none; b=jlPxH65WQEbKBx3WmI1+KbGcSry9gxCMqG3GvpFZPL8gyYDnGZJUOZBGf2rW8MM23ROROCpi0O1zuCTAKKPP5rNspnkL77XzK3Q5hw6DrhIdB+9lLB+zAWzSEV3gJ0r/040WngwWcE9QVqcM6XTy0ViH69zL74/DkP59U0p08Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750044508; c=relaxed/simple;
	bh=3crnHZWWyc6HQi2ObquKyXrIRR65iwUXK5eb9xDLGyE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=unMOejC0Ex/vin/JBGpCspKWxv6z9pUEC1tow4swHa3a7OVMd8yhs1rsbuvt6uc1OOradkXTFNiIH4z5zB4F7JvIL0LMp08VWXOa4Cffim5qkTzi6vdKRszdOnxVP/IoMy+PVsWwsbX9CvlrhtJx4iYYngTp5H6PZ459Dqu9y+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F+BZVN81; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F+BZVN81"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750044507; x=1781580507;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3crnHZWWyc6HQi2ObquKyXrIRR65iwUXK5eb9xDLGyE=;
  b=F+BZVN81jDiKJ2VQPbjGkHq+Y0xVf7/cNYEsB5tTtqk04kJw0Z7YyH8h
   rauAWbyI2+CaoitaQ5QGKO40Oq2Hb3mKOHv+HVXc20xI/6f3n5YTphv40
   nZa8qdK963qQO7LLakr5Fd33Wn/5QWvzQzo1bpk3S3Epgf5JvGaPAIgYU
   E5tucVcHB0ORedXVQLgcmrxA0qoIO2cK9F9RvFRkMrcCpX6eNxclZpYls
   6OCZ3f2dPzdT9+IgH0Pjr48uPuvdFThZLF/1IdvlOapwhGGRPPNxVpaYw
   xjXgMV2azdsBayd8fkCgtHGxYqxZhyY+AdXzkuESIzr+tArazAzvAFw5e
   w==;
X-CSE-ConnectionGUID: 7N/xRyllT/mDPHIRJgGXpQ==
X-CSE-MsgGUID: 4P9kP0aAQ7iJfdglg4iZOQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="69621977"
X-IronPort-AV: E=Sophos;i="6.16,240,1744095600"; 
   d="scan'208";a="69621977"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2025 20:28:27 -0700
X-CSE-ConnectionGUID: U7O3D45sRme+/EgWHKETWw==
X-CSE-MsgGUID: aL3V/0EgTX2OJibq0nW3Sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,240,1744095600"; 
   d="scan'208";a="152177197"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2025 20:28:24 -0700
Message-ID: <e27acc05-3d31-42c3-8674-4891122ba833@linux.intel.com>
Date: Mon, 16 Jun 2025 11:27:24 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 14/14] iommufd: Apply the new iommufd_object_alloc_ucmd
 helper
To: Nicolin Chen <nicolinc@nvidia.com>, jgg@nvidia.com, kevin.tian@intel.com
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org, praan@google.com,
 yi.l.liu@intel.com, peterz@infradead.org, jsnitsel@redhat.com,
 linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <cover.1749882255.git.nicolinc@nvidia.com>
 <107b24a3b791091bb09c92ffb0081c56c413b26d.1749882255.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <107b24a3b791091bb09c92ffb0081c56c413b26d.1749882255.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/14/25 14:35, Nicolin Chen wrote:
> Now the new ucmd-based object allocator eases the finalize/abort routine,
> apply this to all existing allocators that aren't protected by any lock.
> 
> Upgrade the for-driver vIOMMU alloctor too, and pass down to all existing
> viommu_alloc op accordingly.
> 
> Note that __iommufd_object_alloc_ucmd() builds in some static tests that
> cover both static_asserts in the iommufd_viommu_alloc(). Thus drop them.
> 
> Suggested-by: Jason Gunthorpe<jgg@nvidia.com>
> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
> Signed-off-by: Nicolin Chen<nicolinc@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
