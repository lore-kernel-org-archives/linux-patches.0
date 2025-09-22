Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF911E480;
	Mon, 22 Sep 2025 13:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758546066; cv=none; b=lgCwVP41GWH7omyyoFLXTcVEUIHSkhAsk4ApsAVwKLLlE6GeBp9SXubHRs1QDE5UAB8grwNjeb1LPgu+B4PuFH1wwbMdOuUKR36cZwHhOHczL8iWHDb45p4X+zR1d1alU8Qcgaln0Ky3Ua5jAjv6pJ+U1GFcM2EyT3jjRtRc7jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758546066; c=relaxed/simple;
	bh=O0vKtIqC3VtmXy33eTVnNcXrqKZtRpf/iMG7p7bLjd4=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=m97qZnEfm2iXnB7Hp40kAbFjAV4fQqFlYQr2o7q4wCj3ZPJp7qahO3BbIWhdF+7nIWmpEctnyXI/zrlE+VD9UyxnwFX5x10yTxf3NFqvlR6P7xQuYdkXljw8sCFeKMuTn97he6ltZ/Po3krLUdAqzRefK965v6buksSvGcctbgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YpekgQFC; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YpekgQFC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758546063; x=1790082063;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=O0vKtIqC3VtmXy33eTVnNcXrqKZtRpf/iMG7p7bLjd4=;
  b=YpekgQFCR1gmNk0p4MsVhuAptIlUQgOU+A3tia9VbTN1ASMjVIo9lOiu
   l1065cW1xr7x5zYTKX2lLMA4OKuvfti3zxZlyYB/bufzaF4HVFPKsuUqr
   jZOteZTE2OH7VuAiwCDhBALHu+4IWxtzwSkHfoAWQCUTS2ftShcpVc4ir
   2NLdMVp847BnDs0lcoe++Bktt3Z+P7D58Y1ZEC1ZVFYeTKdjsP8i3mlAK
   3AVHcS/GxI19zA9wnA8r5IEucZpzQvpAUrEohpfqgcMSGgqu3rjHFLqWL
   CqkHrx0nov2USfPtc1cHbybRVVliIus+uFkHKW5FRXqdOVAJzy7U1sENr
   A==;
X-CSE-ConnectionGUID: MXXlJpdBRE2wxuAVc0j1aQ==
X-CSE-MsgGUID: aKvRy8F6QNy6MeiJlZc+Yg==
X-IronPort-AV: E=McAfee;i="6800,10657,11560"; a="64445760"
X-IronPort-AV: E=Sophos;i="6.18,285,1751266800"; 
   d="scan'208";a="64445760"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 06:01:03 -0700
X-CSE-ConnectionGUID: T60RKy9PTG+81Jm+ymeZEg==
X-CSE-MsgGUID: 1HWbQDKIRNe1cDl02ltOJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,285,1751266800"; 
   d="scan'208";a="176542481"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.235.53]) ([10.124.235.53])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 06:01:00 -0700
Message-ID: <f342858b-2420-42dd-9848-c92bccade6a3@linux.intel.com>
Date: Mon, 22 Sep 2025 21:00:57 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, Kevin Tian <kevin.tian@intel.com>,
 patches@lists.linux.dev, Tina Zhang <tina.zhang@intel.com>,
 Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH v2 09/10] iommu/vt-d: Follow PT_FEAT_DMA_INCOHERENT into
 the PASID entry
To: Jason Gunthorpe <jgg@nvidia.com>, David Woodhouse <dwmw2@infradead.org>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>
References: <9-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <9-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/27/2025 1:26 AM, Jason Gunthorpe wrote:
> Currently a incoherent walk domain cannot be attached do a coherent
> capable iommu. Kevin says HW probably doesn't exist with such a mixture,
> but make the driver make logical sense anyhow.
> 
> When building the PASID entry the PWSNP (Page Walk Snoop) bit tells the HW
> if it should issue snoops. If the page table is cache flushed because of
> PT_FEAT_DMA_INCOHERENT then it is fine to set this bit to 0 even if the HW
> supports 1.
> 
> Weaken the compatible check to permit a coherent instance to accept an
> incoherent table and fix the PASID table construction to set PWSNP from
> PT_FEAT_DMA_INCOHERENT.
> 
> SVA always sets PWSNP.
> 
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>
> ---
>   drivers/iommu/intel/iommu.c |  8 ++++++--
>   drivers/iommu/intel/pasid.c | 31 ++++++++++++++-----------------
>   drivers/iommu/intel/pasid.h |  1 +
>   drivers/iommu/intel/svm.c   |  1 +
>   4 files changed, 22 insertions(+), 19 deletions(-)

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
