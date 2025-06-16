Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA9586329;
	Mon, 16 Jun 2025 03:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750044492; cv=none; b=fd9dnPg2qrs0qQErYjwCkic3j0C+Ib4rf8HbCuDwIbsr1KbEq0vNpjwnUSlJk+KB6v3GYJJKiWtRcZyBmllUklVvdfMuwSoRgFlupz2OG59DwQCMyrzY0qhtOKWpPg8EMBOE+tk4p2GqEIRBQe3KisvOPynjNhpJFObvJit89Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750044492; c=relaxed/simple;
	bh=OBHrIbSL+kVLYZcNrGsRVOq3vlVKlEr4ATmlpyHec4g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZXAfvubGoYN4kqhzqmWVv7n5xacNtyKTUOoG4ZARvGJDAlpy2921X38JNLTEREPe3PgHtrxoc15HGO+Cz1eNweguGZTtVqzCZd+CoJqyIKUCNGk+jwE+nUZIdLYeNrh+WT94bnqSSGnGAOsE23++ljqwKlf1Yzu5RNEYutAmLu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G9VMAHgo; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G9VMAHgo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750044492; x=1781580492;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OBHrIbSL+kVLYZcNrGsRVOq3vlVKlEr4ATmlpyHec4g=;
  b=G9VMAHgoSU+lLFWqfHvhHVxDNqc0gjHJQKSqM9JC15Do6PeGPWVDJNL5
   NCeD/2tLz/H24cq9mHe17PjtwWVQmAomTf3Tb1ZqAdgSMvJU35IcEUhcR
   3qI0nPrQYM/8R9OFmpW5Fgf/aMGpx/g98EP69RoNJ62UVsgyqwpnwLtIn
   vvKhVFP86aLmZkXiAkBHMPD5hiWxM98G5mnzMci638nW+JF1RpnoSrdki
   XdIjg2BGmdXXbo9UaFRo0xhOD0leevLJdkYn42Lnsr+Ie+x1sXIaPrIH2
   W6ehERVfTnXG9XS9a3Y5VDlS11DB8NnlsGmVKy27ZRezuNB94roK+CHRg
   g==;
X-CSE-ConnectionGUID: /GaOvJYiSRCG5ZosPZsizQ==
X-CSE-MsgGUID: TVERpS02RkmVSPtZILblyQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="52269818"
X-IronPort-AV: E=Sophos;i="6.16,240,1744095600"; 
   d="scan'208";a="52269818"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2025 20:28:11 -0700
X-CSE-ConnectionGUID: a8uc1QaeSDizUFA//+SP+A==
X-CSE-MsgGUID: 7aN3AdV0RMqe4irRZ+9pzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,240,1744095600"; 
   d="scan'208";a="149262538"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2025 20:28:07 -0700
Message-ID: <8df501e1-73e0-4668-8ebb-880d4b70c53f@linux.intel.com>
Date: Mon, 16 Jun 2025 11:27:08 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/14] iommufd: Introduce iommufd_object_alloc_ucmd
 helper
To: Nicolin Chen <nicolinc@nvidia.com>, jgg@nvidia.com, kevin.tian@intel.com
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org, praan@google.com,
 yi.l.liu@intel.com, peterz@infradead.org, jsnitsel@redhat.com,
 linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <cover.1749882255.git.nicolinc@nvidia.com>
 <e7206d4227844887cc8dbf0cc7b0242580fafd9d.1749882255.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <e7206d4227844887cc8dbf0cc7b0242580fafd9d.1749882255.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/14/25 14:35, Nicolin Chen wrote:
> An object allocator needs to call either iommufd_object_finalize() upon a
> success or iommufd_object_abort_and_destroy() upon an error code.
> 
> To reduce duplication, store a new_obj in the struct iommufd_ucmd and call
> iommufd_object_finalize/iommufd_object_abort_and_destroy() accordingly in
> the main function.
> 
> Similar to iommufd_object_alloc() and __iommufd_object_alloc(), add a pair
> of helpers: __iommufd_object_alloc_ucmd() and iommufd_object_alloc_ucmd().
> 
> Suggested-by: Jason Gunthorpe<jgg@nvidia.com>
> Reviewed-by: Kevin Tian<kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
> Signed-off-by: Nicolin Chen<nicolinc@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
