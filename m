Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10F64409;
	Sun, 27 Apr 2025 02:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745719682; cv=none; b=sbWqoJ/PTaVKDY6HKIqybP8Awy0E8KQR5C2TwrrOVCb0qI22VDF9yozHgR4r5E2kSxqDYVMxz87Q4agHnR6I5UQoLvAH0wfpMqfLIbAuL92wzrTcr5bvb3ioo6flgSeH93CZKkqyYoLt/bRhkLM2DntFRO/xOCYv3rGS6RF0a5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745719682; c=relaxed/simple;
	bh=8lcsviiWnuurN4y6k2eG3X6KnYRaGR1C7LxmjrHyP0I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ac4G1n6hGscAz7NZyXEP42wmho6MGJlJUT0jA8k9B/EM6QosIxgLL8xuYd3YlPzwRRAL+R2fXFKLl4Vw+ylc/+AkXAvPMHwh2nJJ+5ws0Qcux6dh7aP6M22TqprqZ87C/AjiE0e+1AzqLo/vavppHZ/CvNord5LGYgRPAYP9+6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XpLxwXsS; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XpLxwXsS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745719681; x=1777255681;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8lcsviiWnuurN4y6k2eG3X6KnYRaGR1C7LxmjrHyP0I=;
  b=XpLxwXsSvXY3S2QfyouZjwOsSQEhkKfFWRyqeAI9R/eh0ZU/sfu6nrCX
   rPdPW7omr/IMu3Dq9HeN+DwkuGgRckLAVIvHjX8q4wf0eHpdJwXNp0qja
   7PwzO1bfS7raXIiP+xabfjQZ/d7hThHkce3PrfWW0kBMwtTGiClxBKlge
   RkzRqFsAzeNJ5cynIth42DaZxJ6LcX1UXn9kFQrAXHDnjMmq+SGuUK6za
   UOXSWNabadVwSEWVE47eLTX5I8gUhbV+76ucHyVydX09W+n/rFgG2u523
   LCKI8KrS3WsDrCESNwSRImAH7awaQ9Efqw92Ut+rXHS8SI9tJyu7NpVX/
   A==;
X-CSE-ConnectionGUID: 0Fggfx3dSDCAILaZijYW7A==
X-CSE-MsgGUID: N8ABcUOKSACUtyWXoM4krQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11415"; a="58704914"
X-IronPort-AV: E=Sophos;i="6.15,243,1739865600"; 
   d="scan'208";a="58704914"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2025 19:08:00 -0700
X-CSE-ConnectionGUID: QfRR2frOSzW9ARKdKIKkcw==
X-CSE-MsgGUID: MhKJLYHXSVetw/0FmA85jA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,243,1739865600"; 
   d="scan'208";a="138187331"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2025 19:07:58 -0700
Message-ID: <c6482c18-fb1e-4b24-a527-fc8c275760fa@linux.intel.com>
Date: Sun, 27 Apr 2025 10:03:49 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iommu: Protect against overflow in iommu_pgsize()
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>
Cc: "Isaac J. Manjarres" <isaacm@codeaurora.org>,
 Joerg Roedel <jroedel@suse.de>, patches@lists.linux.dev,
 Georgi Djakov <quic_c_gdjako@quicinc.com>, Will Deacon <will@kernel.org>
References: <0-v1-3ad28fc2e3a3+163327-iommu_overflow_pgsize_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <0-v1-3ad28fc2e3a3+163327-iommu_overflow_pgsize_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/25/25 21:08, Jason Gunthorpe wrote:
> On a 32 bit system calling:
>   iommu_map(0, 0x40000000)
> 
> When using the AMD V1 page table type with a domain->pgsize of 0xfffff000
> causes iommu_pgsize() to miscalculate a result of:
>    size=0x40000000 count=2
> 
> count should be 1. This completely corrupts the mapping process.
> 
> This is because the final test to adjust the pagesize malfunctions when
> the addition overflows. Use check_add_overflow() to prevent this.
> 
> Fixes: b1d99dc5f983 ("iommu: Hook up '->unmap_pages' driver callback")
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
