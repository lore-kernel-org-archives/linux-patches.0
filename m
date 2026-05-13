Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866354DD6CD
	for <patches@lists.linux.dev>; Wed, 13 May 2026 17:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778695043; cv=none; b=Sd1cr8JMe9ZnapQYLw9s7GLPU3dhjjl6KKDHmqGhGQJcxzZmoo1USDmOFC81Vdi70l5uxJYXmMsJsrxi92R5VTNLDnE0ZGXJDNvdU5GlJ1Y6w7L9Wx5sACGUBhPkGM+V4E/DVE4eihotHV0JEnGzLgp24iAYNrGw7GbyZ84Eot4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778695043; c=relaxed/simple;
	bh=QKN3YqFmH0/TeY985PphVsKphrajBj6NCp6nMBNJqi4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fWc/HNWPrfwPdjqNyDb9UDiqfLrKdXZsCegluLC7PRXIy0XXAqxu068FVXxhQiy0nQTxe+xo2W3XrMyKMLVplfM0YdrXhvWr+OtCQFWPa/2QN3jOzGlnL3iIBaaEkjx8jrczpAbBHspS/rbTNKXmLcZtKwlm/yjYCVabmvSnZVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JK5DFKCY; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JK5DFKCY"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2b46da8c48eso905ad.1
        for <patches@lists.linux.dev>; Wed, 13 May 2026 10:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778695037; x=1779299837; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rumaNYmYuf6e0hytuftPfqmK7NdxUKC1PH7+SuVwJzI=;
        b=JK5DFKCYUWA95Fpb+z+8J9S9HgzbBionroCX6IFaQL6F+9+Q5GHYUY1PPJcryInUml
         Fnbdk1F9z/+yLGr8EP188PJUB1A7m7FJhya+AaH1AzaZArY6UsatRrbajYsU8np5N5Ip
         ZtIXIugiz52S6xGsA/fvdx5BBTdgls0k0IIWUxQ0M57DFFCocpsuSpYEw0org3IRrNSU
         eaimpi6nSAfwCGWt7x4rfYo1R8PZkeya3qY5xX97EWCiOBg0SAUwLwXE/JOzZbE2z4OM
         BVVriO90UnTOSUQ7oNoonmvai2LtG+jmWZaTCqpPqmfiksyiPXijrLm1vpSdncvMJupT
         NFew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778695037; x=1779299837;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rumaNYmYuf6e0hytuftPfqmK7NdxUKC1PH7+SuVwJzI=;
        b=kwGYAEkNadOsr3FkPdPDTqXRu/yranN/dPEzEN19hwLTCL5BgoaDQYKB8M6o8dUobM
         0rSAKkZQUEd+1A//VDJI7TQCgKZVjsTg1aOfQqlxV375P2Al5NRluiOa8MqQnQf+QuqT
         hfYRywqFp5PEkCOilPIzMzRejbBYEIAvlBswUvoVH6gAOZ+FkfeeRrWcRmXIUjZnS6VN
         sOY9g6rzphd2tEjK5wyEghQ/yoOcFPAMr6fozo689GaCFZZMb6EQ367DjeTwoHhDdxYg
         hBWxcxQyymXImVtebVWY1rIxFOaYIgAatWaRN4eTOop7NyFkG1XS+oMFTyzkzpQzA6lS
         GQxQ==
X-Forwarded-Encrypted: i=1; AFNElJ+sBJExTMeB8lnGKYcjw+HtHIihF0rmoUP5r6fpvlMysC3bJUOEOh0MwjG7JGAviDD23rVGEwnf@lists.linux.dev
X-Gm-Message-State: AOJu0Yz2r95rT5Bcd8YpAX6Pbkvb670WskqtgEA4mk31WbpVIox5bM2n
	UoKWmIpP2xlc+kJhUK9wzispU6X+c/Q1/wyP758EHFhm9sRIG0VmvAnu8OAQcSPiQQ==
X-Gm-Gg: Acq92OGbvyYbk/LanIFLT+UBdMno/dPbEb1593QeEFBPkmgkr0gO1S2plxQvSkTn7JK
	ZlnCvZXabIraEhOIjaFynIsqcxnfTAWETMXK//ukGCYZMt12cbp+CfdnCl5GxDq8m/fOdqf0AB0
	N/muqmEeit4vsbnNQ2QVOMm1D7EZtZ2zdhix5LrLYdiijQvOCX8EqXWnTTS15zTipVoTnbinAci
	LOT/Srwd2pnhZeNgiQkE3eg6peRfbMPinnu3PJk8umAIYAT1GFunQDTDp9jDxYT08zwZ1wftWDR
	dHVBNUVFj5XWIdOUoxBt4YKo55Aei7sb4bK5ovUQMAASxwzFenBzqBfRs6ByPj0Sjx3b8X9CLrj
	q/m1CCl1KCBs9XHSSrBCtqEFxvx/pNs5wkk4AqJYGyqOiDF4kOEoccg2eOS/Qdv8o90b1hMiga8
	WgxQKgRr+PlRv3KxwcPvuOMeIxUW7+nciT2un3t2tt9EVNZu3ymA7xscUKaPTRlG1UKJHF3g==
X-Received: by 2002:a17:902:ef0b:b0:2ba:dfa:328d with SMTP id d9443c01a7336-2bd55ecaa5fmr219545ad.1.1778695036910;
        Wed, 13 May 2026 10:57:16 -0700 (PDT)
Received: from google.com (153.46.83.34.bc.googleusercontent.com. [34.83.46.153])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e9fd64sm158045275ad.69.2026.05.13.10.57.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 10:57:16 -0700 (PDT)
Date: Wed, 13 May 2026 17:57:13 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>, 
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Joerg Roedel <joerg.roedel@amd.com>, Josua Mayer <josua@solid-run.com>, 
	Kevin Tian <kevin.tian@intel.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	patches@lists.linux.dev, Pranjal Shrivastava <praan@google.com>, 
	Mostafa Saleh <smostafa@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH rc 4/5] iommupt: Check for missing PAGE_SIZE in the
 pgsize_bitmap
Message-ID: <agS6jQII_2PsAuZh@google.com>
References: <0-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
 <4-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
 <agS04F8UmZwWZNao@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <agS04F8UmZwWZNao@google.com>

On Wed, May 13, 2026 at 05:46:22PM +0000, Samiullah Khawaja wrote:
>On Tue, May 12, 2026 at 01:46:16PM -0300, Jason Gunthorpe wrote:
>>Sashiko pointed out that the driver could drop PAGE_SIZE from the
>>pgsize_bitmap. That is technically allowed but nothing does it, and
>>such an iommu_domain would not be used with the DMA API today.
>>
>>Still, it is against the design and it is trivial to fix up. Lift
>>the PT_WARN_ON to the if branch and just skip the fast path.
>>
>>Fixes: dcd6a011a8d5 ("iommupt: Add map_pages op")
>>Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>>---
>>drivers/iommu/generic_pt/iommu_pt.h | 4 ++--
>>1 file changed, 2 insertions(+), 2 deletions(-)
>>
>>diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
>>index 19b6daf88f2ab1..4877b05291c9d4 100644
>>--- a/drivers/iommu/generic_pt/iommu_pt.h
>>+++ b/drivers/iommu/generic_pt/iommu_pt.h
>>@@ -920,8 +920,8 @@ static int NS(map_range)(struct pt_iommu *iommu_table, dma_addr_t iova,
>>		return ret;
>>
>>	/* Calculate target page size and level for the leaves */
>>-	if (pt_has_system_page_size(common) && len == PAGE_SIZE) {
>>-		PT_WARN_ON(!(pgsize_bitmap & PAGE_SIZE));
>>+	if (pt_has_system_page_size(common) && len == PAGE_SIZE &&
>>+		likely(pgsize_bitmap & PAGE_SIZE)) {
>>		if (log2_mod(iova | paddr, PAGE_SHIFT))
>>			return -ENXIO;

After thought nit:

I wonder if the error handling of iova and paddr alignment should also
be deferred to non-fast path? Basically lift the iova and paddr check
in the parent if?
>>		map.leaf_pgsize_lg2 = PAGE_SHIFT;
>>-- 
>>2.43.0
>>
>
>Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
