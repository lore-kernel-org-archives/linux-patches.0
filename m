Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941943090F5;
	Wed,  4 Mar 2026 07:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772608848; cv=none; b=ehpSKCl8/+Znqw5XpQ0GF0wXQvbphX1PEDW4oa8s45kCCTh39UjQUdB/N0cQW8jXLJ/dx2eC7Q6RHfAVxz1+orVPcTgTxjMJiJs2Y+eKvqBZoYqotZYe/oylTY5/63aQzE7P6X7vdSJkSRZAV31SyA328B08ckLFoV4nxAIdH2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772608848; c=relaxed/simple;
	bh=gs/g+FFrHcAMrvZFa5tAqEwg8s88EPVlvR7P02Xxxlo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nSHNukGOX5K1Yf98iX9Cp6xZDupZQbmmBTVt2AZAq6uptOWz+xapUp6DxVaoMY0wYQp7BwPKdlTrlTpzpcaei4jbvf8gMWoVdQUMRStwH3LccdTA07BFlD6EplE7f+orKFSgVB2gPNsqOcVyG2+gjIbWzVRHh4eqWAVhH9Jd2Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y4YmKS1M; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y4YmKS1M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772608846; x=1804144846;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gs/g+FFrHcAMrvZFa5tAqEwg8s88EPVlvR7P02Xxxlo=;
  b=Y4YmKS1MXpFQoPRIJVbYC6MZMR+YT3M37r+sz1ZAb3ONU733ZwLpsz4/
   uzhi2pnKTAOwe9EbqnycqGe9xaf+4OXp/Rb3FJUPp7yoipMIHaDi3GSmA
   +0JVjlh2qaeQ4mOQYCH6X+7szc3cMEoDif1YwHKDo+9eo5MBOIXc8cLp/
   xxJ2EpAhGGLX5dGth6H1WOgx1YFTXuteNiNyIWLHP1bS4tF6/Ox1SG2Yx
   IbwZbFSK6qySk0yWk4bbzgvbAoo7jzPRb0Igs1i6ygYbCzkfTIYZoRLwp
   QQSLz7xR+o4BvEPoa8jaA8Gos1Ah0qeqWqEwdpMOgem+PQzmsWbmR5LSD
   w==;
X-CSE-ConnectionGUID: Sgbv1ltmRfaxTJ46JtEXrQ==
X-CSE-MsgGUID: WBpsYCFDQneHXNppk0Q54g==
X-IronPort-AV: E=McAfee;i="6800,10657,11718"; a="77268482"
X-IronPort-AV: E=Sophos;i="6.21,323,1763452800"; 
   d="scan'208";a="77268482"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 23:20:46 -0800
X-CSE-ConnectionGUID: A5+kVgiXSn+sq0RUQkrTbA==
X-CSE-MsgGUID: Ni1cf27lSROwdTV1k7mGgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,323,1763452800"; 
   d="scan'208";a="248733775"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 23:20:44 -0800
Message-ID: <bf7ba077-ecc0-4ff5-918d-c724b96bb0f6@linux.intel.com>
Date: Wed, 4 Mar 2026 15:20:05 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rc 2/2] iommupt: Fix short gather if the unmap goes into a
 large mapping
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>,
 Joerg Roedel <joerg.roedel@amd.com>, Kevin Tian <kevin.tian@intel.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
 Samiullah Khawaja <skhawaja@google.com>, stable@vger.kernel.org
References: <2-v1-13a02eb0e031+a5-iommu_gather_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <2-v1-13a02eb0e031+a5-iommu_gather_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/3/26 06:22, Jason Gunthorpe wrote:
> unmap has the odd behavior that it can unmap more than requested if the
> ending point lands within the middle of a large or contiguous IOPTE.
> 
> In this case the gather should flush everything unmapped which can be
> larger than what was requested to be unmapped. The gather was only
> flushing the range requested to be unmapped, not extending to the extra
> range, resulting in a short invalidation if the caller hits this special
> condition.
> 
> This was found by the new invalidation/gather test I am adding in
> preparation for ARMv8. Claude deduced the root cause.
> 
> As far as I remember nothing relies on unmapping a large entry, so this is
> likely not a triggerable bug.
> 
> Cc:stable@vger.kernel.org
> Fixes: 7c53f4238aa8 ("iommupt: Add unmap_pages op")
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
