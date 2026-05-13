Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD284DC552
	for <patches@lists.linux.dev>; Wed, 13 May 2026 17:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778694390; cv=none; b=Z0W2GvGjnb56fZ4OSNY1aSFjRdnSkMUcVAmqVsIow82U8mIHjcNojbp2y8VlEm9ooiFMYMaL1/1Lvhwrg321/BHjCl+lcPXCa43GhHe07EICWgSi4yJxzY3VgtJh2qZ+/p7Aj+w17unXMgIF045aIrLslLNgSkbzJDhV8cWxTD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778694390; c=relaxed/simple;
	bh=RJSvlSo8b3eU3kArKQ0tDZIFebTEAfI2/bt/cNgtTGI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c2ozwiWaOqxM3GgBJ1wLnVKE3MzZgWdWfTHvK8Vwuu9EmCsUS0R0NjW5bU5aByx6XQkryO0aotQ+Qypz9/Pnk4uBkoAlBot/NC6jfkc2kiZ8T47xzEfAU6NDF+dbqSDousMn89tKXsJcTuK0BwZTImYKwLXfqM5cKPQ9v3xRyhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fKpngkg6; arc=none smtp.client-ip=74.125.82.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fKpngkg6"
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-132cccd3d77so781c88.1
        for <patches@lists.linux.dev>; Wed, 13 May 2026 10:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778694388; x=1779299188; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XeNgdwwD024w74BNPer9lil+jH8BVZwrPlFbFGxZTFc=;
        b=fKpngkg6rBN/SDQrFRUJaC9to8jByeL/RZLdLqn8x65Wtsi7HRE/LmkQsXuv2LB5ND
         bgABCuH04jDIiCkWnZp2jHY5lPRSGNL21ML0D3NPe8CCTq1LSLSS0O09F7XG6kfGrYow
         XPF4KIRCdTfIqPTI0e8P45tosruykxxFCjTmEN0/RXh62xoNuYdRVuy5Rhd+r5AB382K
         K1bXOcy2EGf97C5bKc/TdPZo7T6pGZH8A8ghInrp4x21LbC58vo6zK81HSlkA+LmHAPF
         rCMlS0PlrwQ8YUHwL61ZJxWebUUKxRRXIqnOKwOekOqaL4Ogx2roT1VaLwIz/CqwsOgF
         uiQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778694388; x=1779299188;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XeNgdwwD024w74BNPer9lil+jH8BVZwrPlFbFGxZTFc=;
        b=Dpr86M/dQXrfGOY26pAcmXBAP27n6H5J+Y/AQ1ZyEGJ9iuK+lm0KptmTQoFdEEb+I0
         z1gI47rMzjuqrTgguay6fwznm92ReSA6eqw1SP7Y0S0yPGz5MNO9AcjoGmo71BfQZjAl
         OTJ2k3CLnZxMuWjBONJGeWhT5kJ3f2cagsKH38jS2515AO6rwu6/FxD5rVQh4l/ltIMN
         Fp8M9gKu5uwaN0jV5hesaQTRmy5AeBlT6DHQ9iWHKFRFCQ2+fJ6hzBrN77SyL5je0cfp
         1whi+9qIIMuetXZ7VRla6+qQ87NICwcQb9NimHtNGKEHBbwW6odq2dO8c/ox5QDzLgfu
         0krQ==
X-Forwarded-Encrypted: i=1; AFNElJ/UM5oYjPN4rNatUOP/vHa2rgcb9+in1tHqleeDE7EebVfBadzSNnsDRUCWo0AeUk0xJMFUhgR4@lists.linux.dev
X-Gm-Message-State: AOJu0YxHh/rARwUJ1Diz2EMD2ImsQi6KWuQoz1CmQ8RolrVs9sbCTMy8
	pb4hmhP4rLqcjW5F2G0e22VqBWIV1P2cNGUaOt1kuFmzMq2e0NPKIi9EJ/rp1Fm5Hw==
X-Gm-Gg: Acq92OECvf/pPmZY6mmw6/kTJc73PpNFmmoEkCgBuEGH4eWPvG8F7HhUCtzFycHkS+e
	ZWpqoXIkNE7dTV7WWxN56hZ3dT7O4dUN9/5UkYDBJ4iS1dDpCiODvhcbTA7bbDFp+TrTNYB5tt3
	UccIlT1Bff+q32oN3QsnNzwzkzZs2F3YIkRWk+T4Wpw4Da/wMHRjbTUxpF+A5WSFfDk/Eq4abA3
	fjwgx4DVvOK5Lu8yMtA6JLnz5hpnlruOwZDESLBlc7ZarVZdVcO2ER0r04X7Int9//YPigTupig
	J0h2LtoGNHcnqOZdmkAdW9Y7x+orzwPObCcqaMSHCMd6eb5bGf1507jWi+BgDfsR7pCCRgNMX+R
	jxUW9cMF43BTsSGqQaP5u+SeP7wFzv8y6Nxba0akJ0mGKFIXNwjb2u956mzLYyOxrZ6yjXM63Ug
	R2Llkf9N1wBfuMcCk/+5FRULNXbn1h05YPSD9I0wFNFa2CW5te9oyjods0GcF0QlcGfWDpWA==
X-Received: by 2002:a05:7022:69a5:b0:12c:8f55:cd0d with SMTP id a92af1059eb24-134cb46941fmr20666c88.8.1778694386986;
        Wed, 13 May 2026 10:46:26 -0700 (PDT)
Received: from google.com (153.46.83.34.bc.googleusercontent.com. [34.83.46.153])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2f8859eafc2sm29059095eec.4.2026.05.13.10.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 10:46:26 -0700 (PDT)
Date: Wed, 13 May 2026 17:46:22 +0000
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
Message-ID: <agS04F8UmZwWZNao@google.com>
References: <0-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
 <4-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <4-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>

On Tue, May 12, 2026 at 01:46:16PM -0300, Jason Gunthorpe wrote:
>Sashiko pointed out that the driver could drop PAGE_SIZE from the
>pgsize_bitmap. That is technically allowed but nothing does it, and
>such an iommu_domain would not be used with the DMA API today.
>
>Still, it is against the design and it is trivial to fix up. Lift
>the PT_WARN_ON to the if branch and just skip the fast path.
>
>Fixes: dcd6a011a8d5 ("iommupt: Add map_pages op")
>Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>---
> drivers/iommu/generic_pt/iommu_pt.h | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
>index 19b6daf88f2ab1..4877b05291c9d4 100644
>--- a/drivers/iommu/generic_pt/iommu_pt.h
>+++ b/drivers/iommu/generic_pt/iommu_pt.h
>@@ -920,8 +920,8 @@ static int NS(map_range)(struct pt_iommu *iommu_table, dma_addr_t iova,
> 		return ret;
>
> 	/* Calculate target page size and level for the leaves */
>-	if (pt_has_system_page_size(common) && len == PAGE_SIZE) {
>-		PT_WARN_ON(!(pgsize_bitmap & PAGE_SIZE));
>+	if (pt_has_system_page_size(common) && len == PAGE_SIZE &&
>+		likely(pgsize_bitmap & PAGE_SIZE)) {
> 		if (log2_mod(iova | paddr, PAGE_SHIFT))
> 			return -ENXIO;
> 		map.leaf_pgsize_lg2 = PAGE_SHIFT;
>-- 
>2.43.0
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
