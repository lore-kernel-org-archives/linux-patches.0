Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8848F20B212;
	Thu, 18 Dec 2025 01:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766021851; cv=none; b=YapRTl01kjQL84l2YduV9lyuNnTEBfnpf3YA3R4h7fmozgM4DUKG/maBFtv/Pn1wP56uCRVrFMJwvXEEc6KhmjkNaxMvRc6JFVC5YSzHBZ0fDs/o03zrw6QLyLkyJgh5AEDgPBLX6Cq6pPrQrYMGxHhVT8mj0aAao5MOIDNHKM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766021851; c=relaxed/simple;
	bh=yQ/ACKLpuOJOvXNi3y0lUdJMBgTLh/DwHdOaDu89sSU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=txqXGw2itzCJlBQgVwjFbkJalqSweO+bIZpSDL0DO2bzDahA9j2TKJUqc+4rhD5wA0dFazzfvdt5y8iLE3XqKSfbfV+1mha/brbbPSLdl08hPMgANKKOmtmIVRT4yadsKyix+7rSLQ29hhpCE/GFCURNbZSyL1M+qbZ4KLL18m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oFB6FeZ+; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oFB6FeZ+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766021849; x=1797557849;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=yQ/ACKLpuOJOvXNi3y0lUdJMBgTLh/DwHdOaDu89sSU=;
  b=oFB6FeZ+4LNcTqHIKoEHohC2aCLyZhBPV/rlVOXIhrIeErtB0jjTS9aW
   xar8dD28IHXENwso8wq4FU9cYhw6+S3VIN+4vusfgYr74wwLVcrcZwERs
   PgHmRWds9n9Cd9LeyEKTbnTVabnOdQls8zXwA6e3LWKW2dwTAqNi+2FM7
   N/uoyeg27G6lhXYcanqevBfprhTtXCc3lfRYGguRFqy5yv1YIFy5foPNM
   I9KHUbHXd8lQUpHY8BjFKdymDS0JZRxC51Yz5vNnIbkgjyxF13t0G1Nyd
   8mjjXeR5QAnXGLh713hYkGmLFSFGRW1eDMnDIqIkKbw8yXUVRRhqWIoWI
   g==;
X-CSE-ConnectionGUID: 7exn5nf8Rt2hMFN6JAu5Hw==
X-CSE-MsgGUID: ZBmRZDymS4Gr5F1FNp1hwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11645"; a="79340487"
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="79340487"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 17:37:27 -0800
X-CSE-ConnectionGUID: an/2cm2HRiO72jzkVLDDOA==
X-CSE-MsgGUID: UOj+KgYeTI2b3GjNz6z6ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="202834563"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 17:37:25 -0800
Message-ID: <f8016176-7c62-4159-a4ae-0eeca4fe7b73@linux.intel.com>
Date: Thu, 18 Dec 2025 09:38:17 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rc] iommupt: Return ERR_PTR from _table_alloc()
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Joerg Roedel <joerg.roedel@amd.com>, Kevin Tian <kevin.tian@intel.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
 Samiullah Khawaja <skhawaja@google.com>,
 syzbot+e06bb7478e687f235ad7@syzkaller.appspotmail.com
References: <0-v1-5e883e102420+59d-iommupt_alloc_err_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <0-v1-5e883e102420+59d-iommupt_alloc_err_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/18/25 01:43, Jason Gunthorpe wrote:
> syzkaller noticed that with fault injection a failure inside
> iommu_alloc_pages_node_sz() oops's in PT_FEAT_DMA_INCOHERENT because it goes
> on to make NULL incoherent. Closer inspection shows the return value has
> become confused, the alloc routines on the iommupt side expect ERR_PTR while
> iommu_alloc_pages_node_sz() returns NULL.
> 
> Error out early to fix both issues.
> 
> Fixes: aefd967dab64 ("iommupt: Use the incoherent start/stop functions for PT_FEAT_DMA_INCOHERENT")
> Fixes: dcd6a011a8d5 ("iommupt: Add map_pages op")
> Fixes: cdb39d918579 ("iommupt: Add the basic structure of the iommu implementation")
> Reported-by:syzbot+e06bb7478e687f235ad7@syzkaller.appspotmail.com
> Closes:https://lore.kernel.org/all/693a39de.050a0220.4004e.02ce.GAE@google.com/
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
