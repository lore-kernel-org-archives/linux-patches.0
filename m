Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C056A239E7B;
	Fri, 13 Jun 2025 03:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749784618; cv=none; b=Ri3LEksGz4qgT5baw1fbQz+R6ulmWm8/wED7xMx1Yvd0q64eq2C20FAYMfLQ7t/Ce84TbH8SDDYKtGODybF+41MidZHD7D+x2OdN1xZu3+03D3AyXK1EJB0mM1fqsqidVOYr8GB/8AIb6viSNf6q7HDSBot+GuCdQEumBWO9Cos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749784618; c=relaxed/simple;
	bh=0jvaie0511ftK/fpbJnHTGdXtBfH9xiqZuo3B3+eSac=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uLSa2kCB1dxwQc44mO+e8LgiQj7leE5uWZVPfJY0XOb2GWD0TQty+j57YYySKeBcSGnULhBcn6CjqJKwNLYNlLFex4xsSi7x9UkUzeeDfTxsVvknp+TIYge78Zm2hqRc50DgkybMnP27HM9JVYsCEfinhEg8mHm7JeR1EXlYWIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X5Q2vH2n; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X5Q2vH2n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749784617; x=1781320617;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0jvaie0511ftK/fpbJnHTGdXtBfH9xiqZuo3B3+eSac=;
  b=X5Q2vH2ndODM/SmEP/AZoXNTWbOiWBsmyqY/6iV0w0i1OG9902sarzPO
   VqkUZwkzLPGPcYI+Le3GcdbbuAbssyiIq9Tw+N/Xhi8NqD35XTE7SrJNB
   fo/e437N1xQj/jPwzStM1iyuqCojbe1jYU5EN/uXws6JVfekhU4sE+AmP
   7SU3TrwdErjZKg/svI/O93phlWTz7HG+bdk0IJ5bcpoxaOlkHBwgmMQdc
   v6fEswSY7YSJO3SCmJqE1amIc8bLoGFh9K2anErmIRoBAXUJJmcLuJ/Np
   FLCbLXvo+m/emWiqqOBeWjG7DdlRGqsflvaYv90NgewJhPEkU7RUiq/Fe
   A==;
X-CSE-ConnectionGUID: dcqxz/snQEOEYY05GO5wHg==
X-CSE-MsgGUID: 5BbsB/iGTaSjri4jaNrUyA==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="62598173"
X-IronPort-AV: E=Sophos;i="6.16,232,1744095600"; 
   d="scan'208";a="62598173"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 20:16:56 -0700
X-CSE-ConnectionGUID: +q824qZfTWm/aNHbL7elTw==
X-CSE-MsgGUID: rMC4t20NQfSfe9vXGSZ4Kw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,232,1744095600"; 
   d="scan'208";a="152996243"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 20:16:53 -0700
Message-ID: <1e71b605-1224-4de6-b816-16c1c0ca2ce6@linux.intel.com>
Date: Fri, 13 Jun 2025 11:15:59 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] iommu/vtd: Split paging_domain_compatible()
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>, patches@lists.linux.dev,
 Wei Wang <wei.w.wang@intel.com>
References: <7-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
 <39400661-9f18-4ba3-8cb8-d56ef548c9b0@linux.intel.com>
 <20250610235125.GP543171@nvidia.com>
 <da8a6938-c45f-4923-af52-1a34702f1b0a@linux.intel.com>
 <20250612134701.GT543171@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20250612134701.GT543171@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/12/25 21:47, Jason Gunthorpe wrote:
> On Wed, Jun 11, 2025 at 12:50:11PM +0800, Baolu Lu wrote:
> 
>>> When this was first done that was harder, but now I think we have
>>> enough infrastructure to do it easily..
>> Yes. I can follow up with a patch series for broad discussion if you
>> don't want to include it in this series.
> Please, I'd rather keep this as is.
> 
> There is also a problem here with AMD, it turns out only its V1 page
> table can support disabling no-snoop, the v2 page table cannot and
> there is nothing like the PGSNP there.
> 
> The iommufd side assumes that if a device supports coherencey then all
> paging iommu_domains support it.. Maybe a creation flag can fix that
> also?

I guess so. For the AMD case, a FORCE_COHERENCY allocation flag
indicates that the IOMMU driver should select a right page table type to
meet this requirement. This requirement will also be enforced in the
domain attaching paths, meaning it will be an incompatible failure if a
FORCE_COHERENCY domain is attached to any device that doesn't support
this feature.

Anyway, we can discuss the details when we have that code.

Thanks,
baolu
