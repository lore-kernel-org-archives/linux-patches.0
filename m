Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24ADF125B2;
	Fri, 28 Feb 2025 02:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740708471; cv=none; b=qA3peT0Gq4Zd532inElkMvxa7i2kWF+ow3ZrGcq133AoPaepu5fFPFj5kGrfPka5mCKRLVOuUBMCOI4BodMOXYMYTI/1t9PnxKJfbfrt9JCOE/dYcPdLU/Skpzy+c6gO6eIFDennPY+/IA8ajAb0dcKldoESBFhDco/DryGSn6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740708471; c=relaxed/simple;
	bh=IkwV04TTqonSTx9zOmlSYVbveg032kXwqmh/0+Sp4IU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MEfVwAlgq+VgHPA+wm/xroSmLC8gOaakOegm9D5tQblAzNAMf7s1zJHA4iR1zepXQYgg0DvQQ08NPoBxGTvBlCtT5nAK2Oey/ioSY3JL1cjzntLD4XNyZBtgQhVPU4oja57oQFQQasArBDUyVgB+YZE/8M57jX2+DVQabowfFYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aTf4J8Pm; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aTf4J8Pm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740708470; x=1772244470;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IkwV04TTqonSTx9zOmlSYVbveg032kXwqmh/0+Sp4IU=;
  b=aTf4J8PmZ1Wx7BNbOpT2wTILRsiw4luyyKCA1KWYXazoaycCVm63gukz
   0vL7uLWldNL9+CsPCEOBonCvOvLk+VlnWOXGTY5SD8w/hgXUTaoRY/Azo
   5Gy4eNBrXQ1sgg7A1ncjqGqWkd9P4BVw6mJ7gsSeYPovRUGVMvPjSwMah
   Hc0M/LwTjfD7BwsBlBV0WhqOee5fWumXQHCG1LYlujurFlL25O4k/llAq
   xSC/6PQHfNA0iQtywT2AEmakasvSDehKCWExZlK7xgf+4r0W62o9ZhAaE
   m7ZfWQXcP/GbecIhTASeA2gPqN9lx48nliQOFCSpknAFh+6iYhQ6JvQoj
   g==;
X-CSE-ConnectionGUID: hYC8xYXRR9OL/xcFjjUwnA==
X-CSE-MsgGUID: azSLlsvlRCOOtpH5BHn1Mg==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="52615363"
X-IronPort-AV: E=Sophos;i="6.13,321,1732608000"; 
   d="scan'208";a="52615363"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 18:07:49 -0800
X-CSE-ConnectionGUID: cwQaEbGRTcW8sXqTmppLHw==
X-CSE-MsgGUID: AP9pkZGzSBaiUqIcMEVr8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,321,1732608000"; 
   d="scan'208";a="148019983"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 18:07:48 -0800
Message-ID: <3dc76605-4630-4ed1-ac57-c95a37685f1d@linux.intel.com>
Date: Fri, 28 Feb 2025 10:04:29 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] iommu: Hide ops.domain_alloc behind
 CONFIG_FSL_PAMU
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 virtualization@lists.linux.dev, Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>, patches@lists.linux.dev
References: <5-v2-a3b72fd4b99a+1b6-iommu_virtio_domains_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <5-v2-a3b72fd4b99a+1b6-iommu_virtio_domains_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/28/25 08:20, Jason Gunthorpe wrote:
> fsl_pamu is the last user of domain_alloc(), and it is using it to create
> something weird that doesn't really fit into the iommu subsystem
> architecture. It is a not a paging domain since it doesn't have any
> map/unmap ops. It may be some special kind of identity domain.
> 
> For now just leave it as is. Wrap it's definition in CONFIG_FSL_PAMU to
> discourage any new drivers from attempting to use it.
> 
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
