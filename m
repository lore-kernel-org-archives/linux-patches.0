Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F2B27AC54
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 18:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772562632; cv=none; b=nMIC+XzLaCB2buFvGElhrQFBLnq6kLvMaIJG+O/7xjGURjX7vi5RleL8E/XFXCE9JLSqXnnuNfYNqYJz9Jogtop8fmILcuJ1rNo7biJQAJz+8o6b53QXllFj130DXBPmh+vcCnLOTX25kHUupH4Qcs5zURrBbVYcd/ppq/A1QyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772562632; c=relaxed/simple;
	bh=XW0MM9Qb0l7ek0D6rjJBMdfOtLG2Js4WUdcnE1GL9zo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mxu6IabfmFJ60NOonFqDZE7r13Bp8h/n+xAoDL2h3o0r295QfkvRbY9W0n6/VE1CNpLSVorBhqSC5xg6UevvENB/igH5r/oU+mp8fFEzRuFcUWDeh+0YQDdvnfqTT3BP50ccmSpsJ+DaKkFqNMpq9MBBFCag10YNbqiGmSvZKp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e+/5VJ+V; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e+/5VJ+V"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2ae523d54d2so99255ad.1
        for <patches@lists.linux.dev>; Tue, 03 Mar 2026 10:30:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772562631; x=1773167431; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jZwVdnEFy1OqWo7KkJ5/mQriJgyzWARTRDxGrzurnM4=;
        b=e+/5VJ+VLmBNumDS28v1axxUnNnjaoChxyWFuhTnYJiqslIAKtQDTYlIT/AkHCkGo9
         Y1ZYwBmB0HmYDwiKt9feyevPyjEjTfy7UfsigBcOSJtNPpa9lLeIoxrWjWuUT+rxqAHA
         ozL9Y7Ix/2vdrlbT9baw83Dkxp+EUf+d1EaAk8TBHAK3WpwZHHSK/j7fIovlZTxJg0VC
         47TmF93LoLGl05tZap2pPq0e7vBapMQYMIM4WF7iABvJ6sN/Ax1yb4q10+lrsbEZ+TJE
         lDtPP09YnCa1fmeFHXfw6hesrBBSflrQcXDcHZcsfaaJRh+5HQfjmyV1NLd5KIiSacji
         pRAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772562631; x=1773167431;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jZwVdnEFy1OqWo7KkJ5/mQriJgyzWARTRDxGrzurnM4=;
        b=B+7iuwnTYJhiySocIQ3bNLmeclQ7vF4wgHCVS+d5Qx7AqrYJDUyKCUF+kp/QReFoNf
         WUhBOR5QBkNrmM6k2aL/b6L14IXAZPHIfkCYd9a5OUkgwZ6kWc2K1REIV8zI1ktqfVt+
         ghTAy71XIxoINP8SFZKkEdau7v+gV5DwJyweKWMNVfbtv9qJcBnRNBqqyi2A/Tzr+XZy
         XIGAvS29gkweLJC4SHrErtNqYfrrANhcgr88MQGMVegnIRrBg2hnERpV/0nKX4qX2Pk7
         7Dzu+Jw0lrXuW1qOiTvkKla8QtKbcAxCPpJGXvuJWC0MCFvwI3Y48kHMY8zJQ/ZPSaB4
         47+A==
X-Forwarded-Encrypted: i=1; AJvYcCXklQMJeEn0DOFLeUL+9jUWp9/WL6n7BZJF5j1W/U3zTG2bZiQQigD6lFKsBIpQd+RAwYmJ6QE/@lists.linux.dev
X-Gm-Message-State: AOJu0YzzBA+CTquoSN6pofwuNecJ1V1yHERU/1Gw5aoDHhLDbDyF/F8T
	lOEXLIonHLH1h0e1TSkDsUnmuy0s6rhmrCDma+FcQOkXEu5klZE1TQbsew3H9mgBXQ==
X-Gm-Gg: ATEYQzzYnYsHTclatrs9c8M6JzQ7LtMskEFDUUyahrDa4kgAXxojhcPPqvYQ3iILHPh
	RFdZhvb4Q4+K9/KRjC6dgmkBIe4MIDPfCwcZ8cAsnaL3ZkjCQqjU3cPp0KPXOUd5aKm4DQZ5Q06
	cugSJleib7Ga8ufUsXL0jzQEdBFxxq7DJubddvGs1n4Dw4WvaZ7MxSJeJNIpJCslUYKRaR5nIwo
	nsza2WV2s7zQ2xlDo5sxib0ULyVjHVK6TAbbXDHiIlQbCFtt3stqEwSGs9j4GErNcL9t8l88ZcV
	7sMgTpoA25DpETesXWHb7OePrOWEt3ZND6+6I9auKOqHCcB1O7BOTfrFw9WuPIW555PDnfk7wG4
	7rvThJvqpaZQKg2r52x1sn/ETyPixgY7AZt/XNngRfCA95bKM3+LwfCq6zVgoGo8yVJPf2EJa3e
	YgrIiCWFveskw9UKNyjYK5KYe9ocBfRl/YwddECxqa72qThpwlZVdr3Sf3ZMjCng==
X-Received: by 2002:a17:903:3c23:b0:2a8:fe50:2933 with SMTP id d9443c01a7336-2ae3949de2dmr1433415ad.0.1772562630134;
        Tue, 03 Mar 2026 10:30:30 -0800 (PST)
Received: from google.com (168.136.83.34.bc.googleusercontent.com. [34.83.136.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3599bb43e28sm1884837a91.1.2026.03.03.10.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 10:30:29 -0800 (PST)
Date: Tue, 3 Mar 2026 18:30:24 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>, 
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>, 
	Joerg Roedel <joerg.roedel@amd.com>, Kevin Tian <kevin.tian@intel.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH rc 1/2] iommu: Do not call drivers for empty gathers
Message-ID: <pvnu5d23x6bk5cs6wbf2nf7v4m3ietrgumeq7rn43twsadns5l@pa4jvd62bmgq>
References: <0-v1-13a02eb0e031+a5-iommu_gather_jgg@nvidia.com>
 <1-v1-13a02eb0e031+a5-iommu_gather_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1-v1-13a02eb0e031+a5-iommu_gather_jgg@nvidia.com>

On Mon, Mar 02, 2026 at 06:22:52PM -0400, Jason Gunthorpe wrote:
>An empty gather is coded with start=U64_MAX, end=0 and several drivers go
>on to convert that to a size with:
>
> end - start + 1
>
>Which gives 2 for an empty gather. This then causes Weird Stuff to
>happen (for example an UBSAN splat in VT-d) that is hopefully harmless,
>but maybe not.
>
>Prevent drivers from being called right in iommu_iotlb_sync().
>
>Auditing shows that AMD, Intel, Mediatek and RSIC-V drivers all do things
>on these empty gathers.
>
>Further, there are several callers that can trigger empty gathers,
>especially in unusual conditions. For example iommu_map_nosync() will call
>a 0 size unmap on some error paths. Also in VFIO, iommupt and other
>places.
>
>Cc: stable@vger.kernel.org
>Reported-by: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
>Closes: https://lore.kernel.org/r/11145826.aFP6jjVeTY@jkrzyszt-mobl2.ger.corp.intel.com
>Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>---
> include/linux/iommu.h | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>
>diff --git a/include/linux/iommu.h b/include/linux/iommu.h
>index 54b8b48c762e88..555597b54083cd 100644
>--- a/include/linux/iommu.h
>+++ b/include/linux/iommu.h
>@@ -980,7 +980,8 @@ static inline void iommu_flush_iotlb_all(struct iommu_domain *domain)
> static inline void iommu_iotlb_sync(struct iommu_domain *domain,
> 				  struct iommu_iotlb_gather *iotlb_gather)
> {
>-	if (domain->ops->iotlb_sync)
>+	if (domain->ops->iotlb_sync &&
>+	    likely(iotlb_gather->start < iotlb_gather->end))
> 		domain->ops->iotlb_sync(domain, iotlb_gather);
>
> 	iommu_iotlb_gather_init(iotlb_gather);
>-- 
>2.43.0
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
