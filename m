Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4166925E801;
	Tue, 10 Jun 2025 02:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749524056; cv=none; b=Qewq7GLCMqTYSxJJ/OXKcza7m9RoBK02yNnY+Z/849DxDU1CloHxxd9ry3YEILjrfMKWnBeyG6K7d/BxOBQGsofu9VC9yTYTnlUp5k9UmC6dv8Qntx3FaljAa5q6blAV4vz3yAAFXJBfe9ioFOdttbRlrl4tvBmJYttAds5BRGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749524056; c=relaxed/simple;
	bh=3bplJj8/piFMvW2ze+ufLvTlVj4AiO9tp/fvw+24Rpk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qXXbgYCG1ygf9NTE5LUb04tZDqtIJ1b1JmiFdSZMkRDiBAMFcvtjx4lUM78eLf0pz94ZpRGKuLzGq2gXokbOcQZThFj+KXJBMcIjqLagbDOxJ3pnRc1VGaTCDL1GGOigKUK7iAn7an8iuGotnAuA20AAQ5x6Dcyc6MaWAxrm+e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lLhST/DP; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lLhST/DP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749524054; x=1781060054;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3bplJj8/piFMvW2ze+ufLvTlVj4AiO9tp/fvw+24Rpk=;
  b=lLhST/DPXmKzVOE193qqTiUlHwN679c/+yKTWKOh7D1TlDmF7XnHT1L2
   gdvafBT/vh6zGU+nuVkFILevSF4kMmxHnWzBg8NX0EbV94OAnNCEJWWCn
   033xq0g/DpoGXjNLCtBX9vShhTH4VejU5mxG71oYYs6Dkj2eothoEfjNU
   uRIsilQbcc46HAPBeAJevcsaGy+W/gLujctnr9s+j10IYZToUYd4UZl68
   5XKU5jFF9VeRgS+rrW0AW+FlYt8aB7eWa46fb/Ay4yc7vbB5uCy+ZGrDN
   NGfZbno+f9q5n7pa852aCb7t3G6s1PLkpZnqn8xo9XNYK2PvXjdE0IZ3S
   Q==;
X-CSE-ConnectionGUID: f29/ff3LSwOvOW/PdipH4w==
X-CSE-MsgGUID: 9JNym2RdSSuLmX4nLVwt2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="54248030"
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="54248030"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 19:54:13 -0700
X-CSE-ConnectionGUID: +6OGlKwkQAqlqBIhOfz64w==
X-CSE-MsgGUID: IPkK9aalT4C1iIyA6Nyqag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,224,1744095600"; 
   d="scan'208";a="147259198"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 19:54:11 -0700
Message-ID: <67501586-8f7a-4faf-80f6-94a125dd9c52@linux.intel.com>
Date: Tue, 10 Jun 2025 10:53:09 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] iommu/amd: Fix geometry.aperture_end for V2 tables
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>
Cc: Joerg Roedel <jroedel@suse.de>, Jerry Snitselaar <jsnitsel@redhat.com>,
 patches@lists.linux.dev, Stable@vger.kernel.org,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Vasant Hegde <vasant.hegde@amd.com>
References: <0-v2-0615cc99b88a+1ce-amdv2_geo_jgg@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <0-v2-0615cc99b88a+1ce-amdv2_geo_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/10/25 07:58, Jason Gunthorpe wrote:
> The AMD IOMMU documentation seems pretty clear that the V2 table follows
> the normal CPU expectation of sign extension. This is shown in
> 
>    Figure 25: AMD64 Long Mode 4-Kbyte Page Address Translation
> 
> Where bits Sign-Extend [63:57] == [56]. This is typical for x86 which
> would have three regions in the page table: lower, non-canonical, upper.
> 
> The manual describes that the V1 table does not sign extend in section
> 2.2.4 Sharing AMD64 Processor and IOMMU Page Tables GPA-to-SPA
> 
> Further, Vasant has checked this and indicates the HW has an addtional
> behavior that the manual does not yet describe. The AMDv2 table does not
> have the sign extended behavior when attached to PASID 0, which may
> explain why this has gone unnoticed.
> 
> The iommu domain geometry does not directly support sign extended page
> tables. The driver should report only one of the lower/upper spaces. Solve
> this by removing the top VA bit from the geometry to use only the lower
> space.
> 
> This will also make the iommu_domain work consistently on all PASID 0 and
> PASID != 1.
> 
> Adjust dma_max_address() to remove the top VA bit. It now returns:
> 
> 5 Level:
>    Before 0x1ffffffffffffff
>    After  0x0ffffffffffffff
> 4 Level:
>    Before 0xffffffffffff
>    After  0x7fffffffffff
> 
> Fixes: 11c439a19466 ("iommu/amd/pgtbl_v2: Fix domain max address")
> Link:https://lore.kernel.org/all/8858d4d6-d360-4ef0-935c-bfd13ea54f42@amd.com/
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
