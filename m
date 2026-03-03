Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BD83CB2F4
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 18:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772562664; cv=none; b=qnJJdYClygcteOmmKSalzrT7mU06tEKVhA0Ivdnt2cft/EKIS2CPOPfrqc+yhBoya8a79aaPQfWKbLfYJf0IowCPL1wYRufw/TnoSFBxVVkddD+f8/Vbt1uHBcRJz3u2k/ueLV1vegtCxfBIvq5DeFDUCqiUt0S/yag8vI9XmMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772562664; c=relaxed/simple;
	bh=sCiUg2lh7iLRhnHcu27aCI5XiBzYr6Wi4NzkifYMdd4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s+/Ld50HPANZa7TP5Xf1foYGyvTve+/hWNp2fJArPIyDKQZWZZV6IOuhj5jA3pCU3JOh9HvSpL4P479/iSTBSuZP8dPfxpc4uxyWCmej/RExsRIJCb4YfEjzWbUXIJSbQlnuh7GfW8PWJqG4ISrMqRikFg5j3MaTmCF8RB39G6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zzu9n5Ua; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zzu9n5Ua"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ae523d54d2so99365ad.1
        for <patches@lists.linux.dev>; Tue, 03 Mar 2026 10:31:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772562661; x=1773167461; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xQzKFsyRhRIrog3eTrUkCLTxvtc/Z0j3oDo/kaQyuvI=;
        b=Zzu9n5UacdyZXUixbSMXUi2yamVCgiE2X8Dofqe4aAU1DGzz+zZa7dLTYfTZhxtuGS
         NhlrJ1kr0wjpejf13HOsNL8ecahncbr3+T7wS0m3xAhlPH2utz1vTTfgbwudGMjcu4r/
         Mitt7KKNEGMu1SbrBVNfls1ykX+ylpVBH8B91OHjoi797OnWdpLxj4WTd9dbDRcnHZAA
         rm9FM6vmZCRhlUbpta2YFz+idc0JrGxaJ6GCOJGlsJ74c8P8eGdn/SzowS3fbKLGL3wA
         ptbrsvVLTxuT5R3keYeH+AJ8vZAp1ItMLzFPwPkcdYIXW4j11jwW7TPwIJS3CKFL1YP/
         4XWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772562661; x=1773167461;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xQzKFsyRhRIrog3eTrUkCLTxvtc/Z0j3oDo/kaQyuvI=;
        b=ngG9Eti8ixGfYFkUaU5sBeTrmG+r3I0+I26mRGCuY9dr1V3b/uUjtTqzMCXsRQPzel
         guWRb8xPORbXfUG/Sa4EVyX11tyu2jgZRTizCr/0Gdj+bxJXrcuVmij6zsAKfJP79D1U
         DQS73SYpSKr7J+kPJBnaD+2oLeIRfm6VIZg+5pKSqFUnwUp6600SNtyzZcLaGL2nLmjv
         M5tOYZsmnbV3HYltiM2HKzN14nb1IDK4hHAwqi27zgAF1xNNWnzukjQWYMaDftpX8Eal
         +trZFFLT7iobyC3lkz0pWE1Yh/qrEmmYpqzXdJ3Qhu6re4I1mdcn2v1vi1I1P+nAPEvr
         WjGg==
X-Forwarded-Encrypted: i=1; AJvYcCUXvZfJH1Fyz2YPtB8dMQW9DrwcPOplMiyyjriDf7sKdnIGdApAMfh2Zxgg23+wGC5jGFgeI1/K@lists.linux.dev
X-Gm-Message-State: AOJu0YxK4w4iF750gicS8aqp8EfEUDu5eNnaoQwWluZd1sCs85z6nOLq
	DizgCHcuGqiDswiFSBRcG2I6FVm8T1+WUb46riTT6NZMfyCrbPCjh0bg+e1r1Mmuag==
X-Gm-Gg: ATEYQzztXYhnkXeHJxEV2rX1bkZvc/5YEYDVL1kXs+3p/pvFE1lKLQiFujL2ogIlawX
	eakZ4GJQO0APSHAcLCVt84MnIjkb2sleq9FpwkijAVpr7RvSlCdtatbKXOSHcQMzw+5GQoEej9O
	6xppU4TfHZeN1JM5StF+/SE/H6TSf/Nclt4QezPMTDDJ0oRLFBlsDwg8FToUoP2OJwd328R4r8T
	MAdWsa4woa7ovX+R5Wm6XMHUhsGZUFDnKPMADJHfE6EYLdIbE6LvqXh0AsM7ykzZ3SbKPkaNdk5
	0f+GNVnB93xacybRX+UqUkOVnZ2akFYz4CU1u7GWqX3Fh8qC/8TyX7nf8ZA89CibXfxpVtvC53Y
	BqI9Vh+XYlUkhJV6ag1uFvns9h92jV24I7htq92Kbl31OGxT66R+WdrscFKD5iDDUx76DgrlOG1
	SEiwMkVTj/pPy9f1cZU/Z2ZApIqPaP7EzG1nrN7CLzQfU8uuRNXwjuhf4XEUSMKw==
X-Received: by 2002:a17:902:d4cd:b0:2ae:4e8e:954e with SMTP id d9443c01a7336-2ae4e8e973dmr4955415ad.5.1772562660023;
        Tue, 03 Mar 2026 10:31:00 -0800 (PST)
Received: from google.com (168.136.83.34.bc.googleusercontent.com. [34.83.136.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82739dabd43sm19660065b3a.25.2026.03.03.10.30.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 10:30:59 -0800 (PST)
Date: Tue, 3 Mar 2026 18:30:55 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>, 
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>, 
	Joerg Roedel <joerg.roedel@amd.com>, Kevin Tian <kevin.tian@intel.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH rc 2/2] iommupt: Fix short gather if the unmap goes into
 a large mapping
Message-ID: <oo4dc27qzpomectrhjyeg3vlshiktejtzppz4vn53q4ufzs2w2@wdl46dnfacv7>
References: <0-v1-13a02eb0e031+a5-iommu_gather_jgg@nvidia.com>
 <2-v1-13a02eb0e031+a5-iommu_gather_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <2-v1-13a02eb0e031+a5-iommu_gather_jgg@nvidia.com>

On Mon, Mar 02, 2026 at 06:22:53PM -0400, Jason Gunthorpe wrote:
>unmap has the odd behavior that it can unmap more than requested if the
>ending point lands within the middle of a large or contiguous IOPTE.
>
>In this case the gather should flush everything unmapped which can be
>larger than what was requested to be unmapped. The gather was only
>flushing the range requested to be unmapped, not extending to the extra
>range, resulting in a short invalidation if the caller hits this special
>condition.
>
>This was found by the new invalidation/gather test I am adding in
>preparation for ARMv8. Claude deduced the root cause.
>
>As far as I remember nothing relies on unmapping a large entry, so this is
>likely not a triggerable bug.
>
>Cc: stable@vger.kernel.org
>Fixes: 7c53f4238aa8 ("iommupt: Add unmap_pages op")
>Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>---
> drivers/iommu/generic_pt/iommu_pt.h | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
>index 3e33fe64feab22..7e7a6e7abdeed1 100644
>--- a/drivers/iommu/generic_pt/iommu_pt.h
>+++ b/drivers/iommu/generic_pt/iommu_pt.h
>@@ -1057,7 +1057,7 @@ size_t DOMAIN_NS(unmap_pages)(struct iommu_domain *domain, unsigned long iova,
>
> 	pt_walk_range(&range, __unmap_range, &unmap);
>
>-	gather_range_pages(iotlb_gather, iommu_table, iova, len,
>+	gather_range_pages(iotlb_gather, iommu_table, iova, unmap.unmapped,
> 			   &unmap.free_list);
>
> 	return unmap.unmapped;
>-- 
>2.43.0
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
