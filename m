Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5183090F5;
	Wed,  4 Mar 2026 07:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772608842; cv=none; b=kBF3T7DZcCyEQZZ4gc+TDFBUQI0WqKHS+g4G2bk1gdV1kj/TU215We43oJYA4yTHXcIb1bgGezqR5G2R4huezye4pjAB3Q1jfFlIsgIgH5Nxhg6mWmzBHt9WsK/vwGFCJ9tOmpv7PGy16fkClZ00evWJoTcTpzfOw8FZxSjTrp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772608842; c=relaxed/simple;
	bh=D6GYEd3d6gvnRsSCgzPjSlNov5PrrHCdZ5y8IBebYA8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D/5FkAdmZdWBcLHtiRGOTV44Ct7Vny/uIUPAW3CQurwbU+FdfAYVwnj1VOKN1PKlu8rAxXYx5ysKP4OFVpO7OMeOFKsBS2TYGmIMVwIwr83ZIAHlv3baDliWj77IBTesZ90RG/kbZUGLCRnSXE8G1ddsuWwmOzCB5L6QcP6+rsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UlVO+fkh; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UlVO+fkh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772608841; x=1804144841;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=D6GYEd3d6gvnRsSCgzPjSlNov5PrrHCdZ5y8IBebYA8=;
  b=UlVO+fkh5Q4IrFml9byh0x9g/nwvu47b2zM3fXS9h1vDENbcUmBpS/IR
   KBCiMWDYQ0Ez+w2jenmuAhVAUp4OaQCAu5vTj0SdRgVOyjIbBSawWUAzM
   C2Kj7b2KUm0qieCLy2HAWshXBBWmh1TxN+cyDv1yy46pildfYmqr8vR8p
   dpXuIWsDIuhAYhyAyl07rCY4GlW2uSl+fwilih/dcAMLRE90o6O4d6tYG
   5usU/yBJk4cD9O+z/aZlbNc0ZlEBp5GUI97Xirv0K9lJjj4N7yOcWozft
   ZEfb0DzlQuEGLQPVwLgvffuXjbWulPptsir/KxrrHGpzrb56MqIS2hkOB
   A==;
X-CSE-ConnectionGUID: wNxE4JS2SZ+iwZ1Kw5kIVA==
X-CSE-MsgGUID: skYmZPJFQ0qXrxhRz64h+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11718"; a="77268460"
X-IronPort-AV: E=Sophos;i="6.21,323,1763452800"; 
   d="scan'208";a="77268460"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 23:20:29 -0800
X-CSE-ConnectionGUID: Rg4hloOgT4eSbbO7WSHaNA==
X-CSE-MsgGUID: 8gdJvCT/Tuy8Xmcr03vmSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,323,1763452800"; 
   d="scan'208";a="248733762"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 23:20:27 -0800
Message-ID: <3b745716-b24a-46be-95a3-fe1e34e005fb@linux.intel.com>
Date: Wed, 4 Mar 2026 15:19:48 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rc 1/2] iommu: Do not call drivers for empty gathers
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>,
 Joerg Roedel <joerg.roedel@amd.com>, Kevin Tian <kevin.tian@intel.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
 Samiullah Khawaja <skhawaja@google.com>, stable@vger.kernel.org
References: <1-v1-13a02eb0e031+a5-iommu_gather_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <1-v1-13a02eb0e031+a5-iommu_gather_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/3/26 06:22, Jason Gunthorpe wrote:
> An empty gather is coded with start=U64_MAX, end=0 and several drivers go
> on to convert that to a size with:
> 
>   end - start + 1
> 
> Which gives 2 for an empty gather. This then causes Weird Stuff to
> happen (for example an UBSAN splat in VT-d) that is hopefully harmless,
> but maybe not.
> 
> Prevent drivers from being called right in iommu_iotlb_sync().
> 
> Auditing shows that AMD, Intel, Mediatek and RSIC-V drivers all do things
> on these empty gathers.
> 
> Further, there are several callers that can trigger empty gathers,
> especially in unusual conditions. For example iommu_map_nosync() will call
> a 0 size unmap on some error paths. Also in VFIO, iommupt and other
> places.
> 
> Cc:stable@vger.kernel.org
> Reported-by: Janusz Krzysztofik<janusz.krzysztofik@linux.intel.com>
> Closes:https://lore.kernel.org/r/11145826.aFP6jjVeTY@jkrzyszt- 
> mobl2.ger.corp.intel.com
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
