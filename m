Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7283A2540
	for <patches@lists.linux.dev>; Wed, 13 May 2026 17:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778695102; cv=none; b=SSeRVmFEVRKuDQ1RPjwRo54Trmx5S5lBvhArzeifqEox/lmeEyjEb6srPCl3izD0qnFtJo/7HzKjHM50+Buod2268C4VUN9utBghD82OcVVR6gIjp4Ubk+gTs/1CNDv8MVE2J2ra8xwdDHMDKLXbA/Ry4DLKujd9/fRvMDLRiBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778695102; c=relaxed/simple;
	bh=MzXdRwxMA2kEQ6q1Wsb/dOQftZjJ4Cbj6XE+Lz3pOxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PX0MHXNuYuW0yskba6DCXOKlcZ2bqpPCjluvlP5ConQcivVsqyPt+hIBCM4ivpPJ8mirRiKH4py1B2rEfdKFH8CcAmRV1f6iOfVDAULduoER6tV8+7WPkSjC0oliPXsGTjJ80mowUpCkNmFzNbverjd+edYC2i80F1dxEMPAG90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZIGIX57M; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZIGIX57M"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ba3b9bcf69so515ad.0
        for <patches@lists.linux.dev>; Wed, 13 May 2026 10:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778695100; x=1779299900; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=S3fT1aVwPbo1hAx2uAtxA0S4rzdrTURQ0V1Kv0JH3lw=;
        b=ZIGIX57M5K6/5Iia2J+RierlHYev/TVLpk5Ahv2iJ2HYqSpay+wSk6OehgJhqLjNva
         lLJ8mAF4jrdu0VUJ+v3NrlXlTlKv+vkBFdCOEehJlG3fCFMtUwPW/kmhsk5psHbmH/qZ
         iak7kbrfpjUYg1p1CakMVOVXuk7KTXO+ZOOX8k/F7Lqr4FazycRbxBIIzAJSdj4/X9gI
         BKbWP0RoCmgvXO7H+L4EZE0MslOwXBFY2A5JEEiFXRH7K2dc40S4rzROAVsX0ycVCmL0
         RUhT/2r7IuZ14QyorWDcy9DMKGnDU+L7VQe0NpGoUT45/qGoUgE9mlngkpas+sZK2k2I
         kJ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778695100; x=1779299900;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S3fT1aVwPbo1hAx2uAtxA0S4rzdrTURQ0V1Kv0JH3lw=;
        b=YttLQC9BjlHf/8khEhzpBcSV947Hh4MglVQYlk9LzQg7+8LrNHFYItqaxnnc2xTqmn
         lPBLNKQ1QKhn/SvIrE6UNj4MOeV013Kakmu4FfvOBn3REGHb+vxrmyEySrJtGOOQEDDc
         ecw3jEayt9hu7LgobjSsnWi6o+lFEHVT3psPRp/lXIG7gXLoZDlZBJnedt42icKaKs51
         tSnPehqOu/f5Saae9v8U3+E9j2FrxwVNbxdWhsQzYDssyG6HDhBqU4sQ8um79WbJ+SEo
         eT1DJctwQxe2rm0waQ1nTDidJPsG4deKMlpKmI/fYMuvZw9d/Tf83Q5bIRdLd6NBdnzc
         smBA==
X-Forwarded-Encrypted: i=1; AFNElJ/tzC+yb1mWymOlIdVLO40aW5sj0lS8ypLYbnK5SYVnMFwFrLn+UpxvVPqydsmCJEhd+j9LRVXR@lists.linux.dev
X-Gm-Message-State: AOJu0Yz5GGmC0KYHTtI0vqJJolDv0zhxSjHOWqQYKzsiW7r5DzOMDU+F
	ENTLbIL1gu4vxcb/bnaK1FMejObx7iBR5av629E4sAlQ70m/XyCz1AzlD5VR7HVf0g==
X-Gm-Gg: Acq92OHU6G4O9EKm246eLbM15zhR4IzqUQk40HLwr4RNgnrFR3I6T7kj4s2gCuKbpna
	zOORB8CY0tDtMC4wRhtiyF4cZHO9M9O090dyuItow6pPC7rIRv9/KPKYdpDV8+1VRJJFcVJQ+92
	S4f7soXeTr4r55Mh8/ALTpgki4uE2GqF8IbZxsU/yhj6NrRUwemGKlRvmilLa7lDkxlCrbcWeCY
	wAe4jyEA2e//s5vMjjupE1ujLO2afj6zsoUL6yRZE25MrmvAIaoBGj/3XkE47vGZKzr7OxreP/q
	lQ779Rv16wTU2G+6J6FNS+o2u6zpWInIG5O1IrtpnmEpPP3xYaaWDMSKFPbsAvT3WYU6c1qVX0Z
	5HLFzs99BgUoO7NPKrH7Gmh6EJPFqYdDIDCmfIp2s1h3IMfFrq6osakgJ32ArMQJCtEFDGC2RVA
	eoRc+PaVy6NET5EsF2zIHimkI7yqxmK++LV1rXqKQuzBVt1bzpxqcCydUwkoNVpRaR+2p8
X-Received: by 2002:a17:902:db09:b0:2b4:58ad:e987 with SMTP id d9443c01a7336-2bd568f44a7mr187755ad.17.1778695099515;
        Wed, 13 May 2026 10:58:19 -0700 (PDT)
Received: from google.com (44.234.124.34.bc.googleusercontent.com. [34.124.234.44])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c8267735eccsm15998141a12.32.2026.05.13.10.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 10:58:18 -0700 (PDT)
Date: Wed, 13 May 2026 17:58:11 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Josua Mayer <josua@solid-run.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH rc 5/5] iommupt: Fix the end_index calculation in
 __map_range_leaf()
Message-ID: <agS7swDV8-REdbaU@google.com>
References: <0-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
 <5-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>

On Tue, May 12, 2026 at 01:46:17PM -0300, Jason Gunthorpe wrote:
> Sashiko noticed a mismatch of units in this math: num_leaves is
> actually the number of leaf *entries* (so a 16-item contiguous leaf
> is one num_leaves), while index is in items. The mismatch in maths
> causes __map_range_leaf() to exit early instead of efficiently
> filling a larger range of contiguous PTEs.
> 
> The early exit is caught by the functions above and then
> __map_range_leaf() is re-invoked, so there is no functional issue.
> 
> Correct the misuse of units by adjusting num_leaves with the leaf
> size and avoid the performance cost of looping externally.
> 
> There are also some mismatched types for num_leaves; simplify
> things to remove the duplicated calculations.
> 
> Fixes: d6c65b0fd621 ("iommupt: Avoid rewalking during map")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

This is an important catch! It means that today, we were redundantly
re-walking the upper page table levels.

Reviewd-by: Pranjal Shrivastava <praan@google.com>

Thanks!
