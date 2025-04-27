Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850C51D514F;
	Sun, 27 Apr 2025 06:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745736029; cv=none; b=A8QyPB0TpPDeVmj73Q8C/p3I24qtJabshczumU+Ac7tamcyWbPcjiosWpBUurlZvYHq9mMNWXCi33n2bbsZ2OjeG4O0c1odxlN3u+IavTNPQeRZ+mAhYnbh6Un+LhYVApRp5gzQDUlitc9HqUizfDs4PQcaTPkCn5Cfyt2l/KA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745736029; c=relaxed/simple;
	bh=jHRCYwqkDeGnsoQZjCZlk/VB00dZCE9Xt/gFt3+3Ekg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jV+m+jgJsFAyroMdGlz4lxmwxrEU6U9bZx94mqdgJXvlJx5KOzoXf569fAK4savAWa7PXqEWWAvxsakBcqV/Glaazk4HKMeIvVL2LVFsRUNRtz3jsrl2QZCuFBXyR2vuc9iGjy/nqQUkr3zPGQNSpoD0irDYtZ6nGxALNALqlvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HiEDRoEE; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HiEDRoEE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745736029; x=1777272029;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jHRCYwqkDeGnsoQZjCZlk/VB00dZCE9Xt/gFt3+3Ekg=;
  b=HiEDRoEEJt68T4S/kASoKDSrb3P9E7jpXeLzE7/KWdyArGS6lN+MKLH+
   Rwy1++I15gldIUQZgEaWj3MdyeYZFD96NE3vG88ElOwTL/GmbRgiEo1sK
   FIPKLmndus56uqgPrxip3T2QlhVEw8bPi/zvceGHIQ/v8Sbk6mUyjyM26
   FwP6f2m8CxvNEAlgwWVHjBNG6YNhJAvDIOblEr0YsazxnAYodkw5CJBDM
   d2Ivy3mwVFpYYKNZU+FljIva/8WohXo4ac2FpK0+nqIUuI50wfQOOLuYM
   tbkJ1PAIlOTHLay1mgLpo+FIdvWSuHPlAoMUz8TiEBeg5UfzQ7B/8zzvP
   w==;
X-CSE-ConnectionGUID: Crjz16ZST92ARlRBkfGwSg==
X-CSE-MsgGUID: TkoKrUu6SW+MMftejKbeww==
X-IronPort-AV: E=McAfee;i="6700,10204,11415"; a="47430755"
X-IronPort-AV: E=Sophos;i="6.15,243,1739865600"; 
   d="scan'208";a="47430755"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2025 23:40:28 -0700
X-CSE-ConnectionGUID: WKkjJoVMRdmCZIfMb9eS0Q==
X-CSE-MsgGUID: wDOai0I1Qz+zMkODB65DXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,243,1739865600"; 
   d="scan'208";a="133731606"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2025 23:40:22 -0700
Message-ID: <43a93c81-3e7f-46cc-bf93-5e36cbf04b8f@linux.intel.com>
Date: Sun, 27 Apr 2025 14:36:13 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/22] iommufd/viommu: Allow driver-specific user data
 for a vIOMMU object
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
 alok.a.tiwari@oracle.com, vasant.hegde@amd.com
References: <cover.1745646960.git.nicolinc@nvidia.com>
 <7031ae5ab6f625e73dbd51b074c2ff8a9923c731.1745646960.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <7031ae5ab6f625e73dbd51b074c2ff8a9923c731.1745646960.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/26/25 13:57, Nicolin Chen wrote:
> The new type of vIOMMU for tegra241-cmdqv driver needs a driver-specific
> user data. So, add data_len/uptr to the iommu_viommu_alloc uAPI and pass
> it in via the viommu_alloc iommu op.
> 
> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
> Signed-off-by: Nicolin Chen<nicolinc@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
