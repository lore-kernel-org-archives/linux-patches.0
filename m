Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0689F1E87B;
	Mon, 12 May 2025 06:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747032089; cv=none; b=Czkxt1dpoY9NH96yJBzPV2cvNUDn+Fj+iJr0NG4fnYdxXuxfjyqQy8gN5boxbnYf/15niDpJ4zACkWmQtHYGbAI6je+i6tmSjuT5+xyUs5EKSzFgg10eZeiJsVtiLMg+KpGmy3Vg1Mp9wzN+jGF1I9IEWZbcQOcK1rpExSx0hO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747032089; c=relaxed/simple;
	bh=i5TNk7YR/rZX5iv052OQPX+7/Doigvu7KAe6p5UFrFI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sn0AlgvXdJng35PBsEcAF6jEVIdPV72T08i7tHbdeYT9LbRdxlXFUI06GdRS0JdR8aio9OWS63+w1shzpZOELwSMqkp1EgugAyBSASQqeuieqKAfS5SHJu7ojNFG725/cPi4+kooyxMC4WkqQIxbBNPAp+/nrkdxGtwlFkTbPlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GklW6pqy; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GklW6pqy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747032088; x=1778568088;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=i5TNk7YR/rZX5iv052OQPX+7/Doigvu7KAe6p5UFrFI=;
  b=GklW6pqyBnLzEtQ13Z9Cf1bU98AhTuI+Ecsc1NNqI++J878uizN+NZg4
   VeyOEYDheEOXnoezh2FiTGRv0WiNhq3L+PwzjR+yom52Qc6etBw2lFur3
   6VIb7fmJJLPUr4mRMO6Fgk4xa5GpoMxFBzwPYeJDkZznIvIfQ41RVWG1I
   SByuY4e0QsQdAB/hqOqpSySaoaKhvCYBOdeXd2k4QTjZ2b5o7hbxBalhY
   PKr3N2HJdhKPamZabqoJTXsV35fi9ZTr/QaYq6blOI8ALW5OX0Ckuc9CT
   2jr6utfd+O/cv0/NUPmd3sVpTcyawNoxyuC1rQWC8ypu8Amr7F/DQS/qw
   w==;
X-CSE-ConnectionGUID: P/7JYw0uTIm6f2Ke3XeHYg==
X-CSE-MsgGUID: QPxe18diRbmk9fTlEWi4dw==
X-IronPort-AV: E=McAfee;i="6700,10204,11430"; a="48678652"
X-IronPort-AV: E=Sophos;i="6.15,281,1739865600"; 
   d="scan'208";a="48678652"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2025 23:41:27 -0700
X-CSE-ConnectionGUID: 1Az2Kca3TB+mvU6wMBtWYA==
X-CSE-MsgGUID: UM96D9tkRTyRIis8u/43SA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,281,1739865600"; 
   d="scan'208";a="142028303"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2025 23:41:26 -0700
Message-ID: <3934ac04-8dfc-4ed8-9c7d-7650d7d36999@linux.intel.com>
Date: Mon, 12 May 2025 14:36:51 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iommu/vt-d: Restore WO permissions on second-level paging
 entries
To: Jason Gunthorpe <jgg@nvidia.com>, David Woodhouse <dwmw2@infradead.org>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
References: <0-v1-c26553717e90+65f-iommu_vtd_ss_wo_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <0-v1-c26553717e90+65f-iommu_vtd_ss_wo_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 00:12, Jason Gunthorpe wrote:
> VT-D HW can do WO permissions on the second-stage but not the first-stage
> page table formats. The commit eea53c581688 ("iommu/vt-d: Remove WO
> permissions on second-level paging entries") wanted to make this uniform
> for VT-D by disabling the support for WO permissions in the second-stage.
> 
> This isn't consistent with how other drivers are working. Instead if the
> underlying HW can support WO, it should. For instance AMD already supports
> WO on its second stage (v1) format and not its first (v2).
> 
> If WO support needs to be discoverable it should be done through an
> iommu_domain capability flag.
> 
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>
> ---
>   drivers/iommu/intel/iommu.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)

Queued for v6.16-rc1. Thank you!
