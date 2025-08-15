Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5151E32D7;
	Fri, 15 Aug 2025 05:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755237132; cv=none; b=CrnigFHaaVAQMKy24bReAT7l5dVoeC1MHyM2c53a2G61ptf7wIBanXWcnU3xQb78LzigipCabjmMMrdPWEHJJToxsL9QryFdpVJKaSKixtJ9y9FVYAsFmwNRQ+s+BFXv0pvhxYpxodXrq1VToRY4h30KM1yhmoO0DPiORnmHPhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755237132; c=relaxed/simple;
	bh=0vH1jDcgJGA2Wn7lpJdojReOpMDMj8xScxd5knXRY9g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mkK1YHMLkvsw2a5EfOOn8eqlIHHWkDr2wDZdkwvqJKLilcsAsuh1XUx30sG3mvxn8JneJv0JZns1gFVj3TaQWRjyLfcX3eGKlafLtJ4lhuaH/uPGb9Ts+d7QsOmxaDy3GY6NFnUsuYaX0NQXvGs0fxFUTKAHiXVFmzw6fYoGL/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eaz6aeJG; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eaz6aeJG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755237130; x=1786773130;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0vH1jDcgJGA2Wn7lpJdojReOpMDMj8xScxd5knXRY9g=;
  b=eaz6aeJG6cEjNTpv2mtGC+fllq5riwYJbWB3jgRVKRckI57W77x/lrfy
   uyu9qJF4H43dLmEtM6n0vrLiZdptQFTNCtqFmWXVo+ISjkVSU8DgTy80j
   0ju3gYd8F+GkKoWqwUUsuRX0hTLm1LDxSu84094qoU8qBuWWSs+jOV3b6
   XKmZc3QiE8RXXVN5DhM0nPAb75SJR5Gc/H8mv+n+1sxpxAoVjkuHncost
   m2+vZATPzmOmeEtJj+z6XfZyEuZleXAUV9weGu2bwEiC+yoCOnKK8NfYT
   Z2m4mTM4VNco9fRaEeM8HfBM0S9AHK5Y2Y18CAzJyGsFAIQdYVD/ncKTf
   A==;
X-CSE-ConnectionGUID: UYo1Gk/xSqaGDj8WJjqt+g==
X-CSE-MsgGUID: CYtiOdu1Sqm7KwNUapTltQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="57488205"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="57488205"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 22:52:08 -0700
X-CSE-ConnectionGUID: QsCBNTNzS2uKIJOGMmnTTA==
X-CSE-MsgGUID: wssFlJjGSga9ENc1rcVaxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="197937723"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 22:52:02 -0700
Message-ID: <7b8d8bfa-ca6b-4a07-8a4d-a30d8993c7c7@linux.intel.com>
Date: Fri, 15 Aug 2025 13:49:55 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/5] iommu: Introduce iommu_dev_reset_prepare() and
 iommu_dev_reset_done()
To: Nicolin Chen <nicolinc@nvidia.com>, robin.murphy@arm.com,
 joro@8bytes.org, bhelgaas@google.com, jgg@nvidia.com
Cc: will@kernel.org, robin.clark@oss.qualcomm.com, yong.wu@mediatek.com,
 matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com,
 thierry.reding@gmail.com, vdumpa@nvidia.com, jonathanh@nvidia.com,
 rafael@kernel.org, lenb@kernel.org, kevin.tian@intel.com,
 yi.l.liu@intel.com, linux-arm-kernel@lists.infradead.org,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org,
 linux-tegra@vger.kernel.org, linux-acpi@vger.kernel.org,
 linux-pci@vger.kernel.org, patches@lists.linux.dev, pjaroszynski@nvidia.com,
 vsethi@nvidia.com, helgaas@kernel.org, etzhao1900@gmail.com
References: <cover.1754952762.git.nicolinc@nvidia.com>
 <5ba556fc54777853c499186f494f3411d7a4a5a9.1754952762.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <5ba556fc54777853c499186f494f3411d7a4a5a9.1754952762.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/12/25 06:59, Nicolin Chen wrote:
> PCIe permits a device to ignore ATS invalidation TLPs, while processing a
> reset. This creates a problem visible to the OS where an ATS invalidation
> command will time out: e.g. an SVA domain will have no coordination with a
> reset event and can racily issue ATS invalidations to a resetting device.
> 
> The OS should do something to mitigate this as we do not want production
> systems to be reporting critical ATS failures, especially in a hypervisor
> environment. Broadly, OS could arrange to ignore the timeouts, block page
> table mutations to prevent invalidations, or disable and block ATS.
> 
> The PCIe spec in sec 10.3.1 IMPLEMENTATION NOTE recommends to disable and
> block ATS before initiating a Function Level Reset. It also mentions that
> other reset methods could have the same vulnerability as well.
> 
> Provide a callback from the PCI subsystem that will enclose the reset and
> have the iommu core temporarily change all the attached domain to BLOCKED.
> After attaching a BLOCKED domain, IOMMU drivers should fence any incoming

Nit, my understanding is that it's not the "IOMMU drivers" but the
"IOMMU hardware" that fences any further incoming translation requests,
right?

> ATS queries, synchronously stop issuing new ATS invalidations, and wait
> for all ATS invalidations to complete. This can avoid any ATS invaliation
> timeouts.
> 
> However, if there is a domain attachment/replacement happening during an
> ongoing reset, ATS routines may be re-activated between the two function
> calls. So, introduce a new pending_reset flag in group_device to defer an
> attachment during a reset, allowing iommu core to cache target domains in
> the SW level while bypassing the driver. The iommu_dev_reset_done() will
> re-attach these soft-attached domains, once the device reset is finished.
> 
> Signed-off-by: Nicolin Chen<nicolinc@nvidia.com>

The code looks good to me:

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
