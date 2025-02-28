Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BCD125B2;
	Fri, 28 Feb 2025 02:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740708439; cv=none; b=c1bmJd0DqO9KD7ZppQt6DTc+jlUiEIaHWr4U5Wd9pAkR7fr+07Cl8X1nRm2iynzhjafZZDVu9YWru4jDWsPRu3xnfD9DBa2AdFXhH9QwK0i660/PW3xG/cOGVYGUzO7mmf+mFa0xX0k+TFVgLVAGUeb7ecLwHQPJ9kw6w+73qeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740708439; c=relaxed/simple;
	bh=CdWZwHwb2grMiTqsIwd6dRVgtx34K44Y8zIsbbArTj0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XW8NvjdwiSaGlG6C4EBnJIsrLmj1tIvMzJmM7Gf7kCMn0MrzLYmh/0RiSM19+pb/QbA9NwoBC9NDSHvxUE3BKY7jC1wx7YeKzZqIGZz307LnYHNYVcBjxNH6duULzjDeyu9dU+xV4gvtZPWghf27wZ+28qp8ThrMGlm5Q9DqvdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UTpveU2B; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UTpveU2B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740708438; x=1772244438;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=CdWZwHwb2grMiTqsIwd6dRVgtx34K44Y8zIsbbArTj0=;
  b=UTpveU2BBnDFvLIsKfsKvQGmuqUqaPaXkjGOqYYTVP8T2i7hQ4IkDCUr
   jEpzek4I7u700u5b+hEEAbTx+v2GOiAgUf4A5V7akmDDXFgv6uyCa/Ric
   qOfFaiujG0OiakqMU0LBHaCYpLkVqDb03aPv9MLxeL3yKkhcSqe2JE9L3
   8Z3I7E2gLr09d2oJCyjwYrPz3ykS3xWA51n52UGRwUG3J00zoZKZ2Yuhk
   /W8iOagkMOdX4pljv5S8GWasCKEOpk1++6G8J6D+gL+ip6xjCPxvMeMDD
   2xcvYY75cvmKEn2jh99cAFl/YOpE4u0wo/zZIGutR8vOHqhWncLT0aMWj
   g==;
X-CSE-ConnectionGUID: S6HhksepSoO8NQdE+JQgog==
X-CSE-MsgGUID: L47Zx6O2SSuELBn+o3BCrg==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="52615319"
X-IronPort-AV: E=Sophos;i="6.13,321,1732608000"; 
   d="scan'208";a="52615319"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 18:07:17 -0800
X-CSE-ConnectionGUID: 6c34GARqQq2flWxz1coZvA==
X-CSE-MsgGUID: dTdRc/uoTLGsZLFAoqjAxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,321,1732608000"; 
   d="scan'208";a="148019882"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 18:07:15 -0800
Message-ID: <f691b42e-1053-438d-9257-e121efd8853a@linux.intel.com>
Date: Fri, 28 Feb 2025 10:03:57 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] iommu: Do not call domain_alloc() in
 iommu_sva_domain_alloc()
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 virtualization@lists.linux.dev, Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>, patches@lists.linux.dev
References: <4-v2-a3b72fd4b99a+1b6-iommu_virtio_domains_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <4-v2-a3b72fd4b99a+1b6-iommu_virtio_domains_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/28/25 08:20, Jason Gunthorpe wrote:
> No driver implements SVA under domain_alloc() anymore, this is dead
> code.
> 
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
