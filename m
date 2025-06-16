Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B570226AAA3;
	Mon, 16 Jun 2025 03:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750044428; cv=none; b=pbOCh6SCFTvxioA1TVORCshbbRTULiIMdsKHYeGhaB8tH1ggtWFbHIhew+xO8cFUvlamwRnEA+dgWtpUEss+3s1FJXJiE7xW9KjNvQLT+kYuzN3g8ZPpds57OQNfQkPMRRlwE3f3DiznM2aRrzzdUWvRh5mRKvgJz5wb2djNRsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750044428; c=relaxed/simple;
	bh=1isUaEkxKU+8NxNIgj+a8p6XetQvHlnDJA/2nRl2Hr0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hZt6vEIMeOk4Wl7gsYr6YF8YFfVWWWoe04nDnwgubNTWjW6sA9OA5G5nQAYpjSobP1FN54RBGbcbyQ0AgxFkDblIn7vAcejIqpS38JyE7qfG2kaYMIfeUondVj5jWBiQiplW1ChHc5kApZ+WQjgvpBMaFMDGXQl24hi7nuyrAfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DVZF7ygT; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DVZF7ygT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750044427; x=1781580427;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1isUaEkxKU+8NxNIgj+a8p6XetQvHlnDJA/2nRl2Hr0=;
  b=DVZF7ygTYgVcLI9SPesP4S2lA6mnLleoS0dWRC8/hUrA6AxEpfvXRbsQ
   wRrWsy6MzwhpAX9tp43sAvj9PXqilHXwBstpa9e/CCffsCgc5x0VREQ7v
   n8Hhn9nb3I2AR59EsSudcEterSWewnFWfb3ASzCgjPSKfuwRoQ5USTb8O
   F4CKXWNRN0jZypt1OGudFBlWwLmOM6V6dhZHYOapjqk3i3qxnfTm2WQOo
   NAhmgKcCAXhky/Nuxf6pdjiqUFcAUx1tZfOclmlFU6rCM9sgoaW0iNDDG
   cLnkS79w2D07zF0Vrie6o1loxoPlJRAhAy1VKRXkCHbEyCbG6YZVC8tvU
   A==;
X-CSE-ConnectionGUID: rC/5SZmBRWO3haVLEdqkZg==
X-CSE-MsgGUID: gSGzb26TS9CsyXGfcfgkOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="51889584"
X-IronPort-AV: E=Sophos;i="6.16,240,1744095600"; 
   d="scan'208";a="51889584"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2025 20:27:07 -0700
X-CSE-ConnectionGUID: 7R/1QlLuSl2G/90d2tiIow==
X-CSE-MsgGUID: 4y/8BpBJQVO/uJ9JS7qrfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,240,1744095600"; 
   d="scan'208";a="149229879"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2025 20:27:02 -0700
Message-ID: <8ed1d728-084b-42f7-9c15-8c97f565b555@linux.intel.com>
Date: Mon, 16 Jun 2025 11:26:03 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/14] iommufd/viommu: Support get_viommu_size and
 viommu_init ops
To: Nicolin Chen <nicolinc@nvidia.com>, jgg@nvidia.com, kevin.tian@intel.com
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org, praan@google.com,
 yi.l.liu@intel.com, peterz@infradead.org, jsnitsel@redhat.com,
 linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <cover.1749882255.git.nicolinc@nvidia.com>
 <35c5fa5926be45bda82f5fc87545cd3180ad4c9c.1749882255.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <35c5fa5926be45bda82f5fc87545cd3180ad4c9c.1749882255.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/14/25 14:35, Nicolin Chen wrote:
> To ease the for-driver iommufd APIs, get_viommu_size and viommu_init ops
> are introduced to replace the viommu_init op.
> 
> Let the new viommu_init pathway coexist with the old viommu_alloc one.
> 
> Since the viommu_alloc op and its pathway will be soon deprecated, try to
> minimize the code difference between them by adding a tentative jump tag.
> 
> Note that this fails a !viommu->ops case from now on with a WARN_ON_ONCE
> since a vIOMMU is expected to support an alloc_domain_nested op for now,
> or some sort of a viommu op in the foreseeable future. This WARN_ON_ONCE
> can be lifted, if some day there is a use case wanting !viommu->ops.
> 
> Suggested-by: Jason Gunthorpe<jgg@nvidia.com>
> Signed-off-by: Nicolin Chen<nicolinc@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
