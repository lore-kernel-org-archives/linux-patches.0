Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598DE1FE469;
	Sun, 27 Apr 2025 06:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745736222; cv=none; b=jkdKp1yY7qumepMfEDIVMe+Hyn3Mz55Inze1WnPlUcC2J6KzYAd2yb/GtmRJRCQUjbSQoTbRtg4ijjX5tvkXG26ShgwGctFxHaf1n2pQc/Hra0ZzLtBeTs/AB7m3ucMmyo6dem+R1pspSMCJS8F3XlRmK52L6g7oLeam6jWAp4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745736222; c=relaxed/simple;
	bh=Avkh+IHRFhmXquqMCTj0xnURVEaMs2AVp7RorDHEx4U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tLuZp6dd6IShmGRzoeS2Re3koOCSgMF8mTSSJthMUJZVxhySln7BFnN2z27igAWO7BPIcrZpw1SUPqfELjR66xSMXrcWoTvf4Omdu8iwbY1r8P2ApsbYqkF5xW4oI6/DxUSCUOW/Egg+xbdwVPHBfZAQ/uz4bHnQmzdUHKfgJ4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dudawgPh; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dudawgPh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745736221; x=1777272221;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Avkh+IHRFhmXquqMCTj0xnURVEaMs2AVp7RorDHEx4U=;
  b=dudawgPhlhnQGOnjmfgycjZiRj+TtJk4ySBFyfDIz355QSGnbTsJ39Q/
   TpVXLPu4unfpKKQu21cObNbitNrpSIPy4+uQHdPIjXXoLwRMimniWHWu5
   xMn2+JUQQtuIiJB+MadW3CVdDcFNu8z3Rt5x5cFFge8YEHUYDEbqyIF6I
   Mhwk0s4yBH5nFuZS9pyqPs4IuegtDWTuP6Suuo3hFzxEVGvTQiitbbicm
   6Qk1BVQtC6FGcC+LxNVdH/qc1aHmBrOqM9Pbj5psDXfTHVuMpbKGNsqEk
   lc7y4BB4JCz6edRroQKFosHTQJIFvFNhqnKwmAK65YsYzY48gmPDaEvs1
   A==;
X-CSE-ConnectionGUID: IXi635khRVuv/vP43cKrlw==
X-CSE-MsgGUID: A5JWrN9sSpijnWeO0a+fCQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11415"; a="47430902"
X-IronPort-AV: E=Sophos;i="6.15,243,1739865600"; 
   d="scan'208";a="47430902"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2025 23:43:41 -0700
X-CSE-ConnectionGUID: nlUKeu2LRMaehOEljfFcBQ==
X-CSE-MsgGUID: RSaSroJwTzy9u9o2IB/EVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,243,1739865600"; 
   d="scan'208";a="133732043"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2025 23:43:35 -0700
Message-ID: <6dc981fd-f093-48fc-a162-4e4e989c22f2@linux.intel.com>
Date: Sun, 27 Apr 2025 14:39:26 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/22] iommu: Add iommu_copy_struct_to_user helper
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
 <ca032e90c0241fe0653023fcb655185dba763f5f.1745646960.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <ca032e90c0241fe0653023fcb655185dba763f5f.1745646960.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/26/25 13:57, Nicolin Chen wrote:
> Similar to the iommu_copy_struct_from_user helper receiving data from the
> user space, add an iommu_copy_struct_to_user helper to report output data
> back to the user space data pointer.
> 
> Reviewed-by: Jason Gunthorpe<jgg@nvidia.com>
> Signed-off-by: Nicolin Chen<nicolinc@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
