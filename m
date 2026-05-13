Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36824DBD7E
	for <patches@lists.linux.dev>; Wed, 13 May 2026 17:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778694253; cv=none; b=I+aMoZmiSXbda4UuCMThHvC3TLZZvoo9CjDz+h5oHBIcjGE1JpFksWtPxFv0TUnjdhKwPPU3ql7BtloEIjfvBOnYNaOnXxirNlEge7D1tDphKRNjkLMIKYmV2TTpNq81dbhZTFX4sDjgk9inDes3tst4d/48eQcGCHCA6OTdz4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778694253; c=relaxed/simple;
	bh=X+MbUVbMjLu+rlmKpQgI/8QF3Ke6PKRPBaagAPDg3qY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Duw1EAZv0/aOwkdFM5rPYLCZVaWUTuNP2bAK9qz9B2nYPuOCxVMusjtAE5haeMh+mxlTwmCm0DJ0X9qNR0GGcfSP+eBbnTtqZIy9fyi9XLQs4hdF2lKXqzUzal9g2rphPWQ/WErY4HK2M9YEmkW02b5uihg6VxghnHavuCZ9Lx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G3QIBYu/; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G3QIBYu/"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2b2e8b95bdbso1305ad.0
        for <patches@lists.linux.dev>; Wed, 13 May 2026 10:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778694251; x=1779299051; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4BJ4po9Dvpfk6XI5pkU3ene6W0TLSq/94NAtPnHwHxU=;
        b=G3QIBYu/wauU5QEmtFeh8QA9UfiZuCUsw0DY/lKQg08g0kcSX10JEaxLzFHRT5Y45M
         JQkntIYa+j/Dhc4ncHrLG2XRNk++opyXM/X8brs6l67aMIRDFitjAicJOBnrtQr1QfuO
         UXy+DCSwLx4Wwf6Pq8Qb1NaHcWPdhxqdB7M6icXxKIrZtZZi59RutvPQhYoh9bbF+0+v
         6nNGejr5JVTaGAV6kbhYH4wracxmT6WrtPKldd7G3Sn1yRQ0LRGycAwe4D7+3+enku1b
         IMvZIuYWW0PHkqyjPQ2KrZ4flb9xICYeNTQ8B24vkfiCUg5cMb1mtxhyG2QjEBKvJUqC
         UC+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778694251; x=1779299051;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4BJ4po9Dvpfk6XI5pkU3ene6W0TLSq/94NAtPnHwHxU=;
        b=IL0f+Hc+4dZAoMU3p+zx4gKvoNdRHXK0OLt9KkLpNW9tQzUTAZT5PsCr1Kf0v2d7Ag
         p4KxXGzN/MFEuOIOoK/y4SO/Yqa//lTFGkKX6ZncwmsGFMB3Okvw/c0bTCM3v5j9DfH0
         d87MdQTmvrTNGR+Wbs6EcdjOz/tDWEV9gNnCCTE/Ess1mPunAlzy4j14mVcTCdN+997D
         Tr4YNMadx3SlCQiBD11jXMusGJZdHhM62tpfNUz3uxI8EAmYrJvah+RFXlxXeqiabQlS
         Qld+MoxVWKqJ1uiqeSSsm83hScCfZ/ORVdO5RbTfg58aib0PHncHAt2c7FRVMTBjSbzR
         zV2g==
X-Forwarded-Encrypted: i=1; AFNElJ+ySCBhzJKHy1hEA5af5Ppg5mlluxorK03uMVyRDyeD/7E5Qypb9mmsT0MhaGAtVEYxKEXT16ZV@lists.linux.dev
X-Gm-Message-State: AOJu0YwXkbWaodTRAYrXF1dWN5NRBZ9uZWM1YmEvfrM/LPhd2NiHARQE
	rKY9LhvKnsstqeLKK2oR16nYE4Ke4oqeKlceo6b9yqPRyUCkxcT8Ws1GMS0JZWrT1w==
X-Gm-Gg: Acq92OF41SXaNhXs9ZAvxy7uG3Sub7KXnzj7n3ZYUUSw5zjVcZ3w912TBBAyT92VyP7
	OvWyVH8Vo0E49R100FlYnfPTg2leuACBB+6En4gs1NUzky66ZNd5ARhTM7mUBFkg5LE41vy+b91
	RyveUKvFBwS43CPTeQrjnt8GL4QdEQ88xWDUqKhtvLHUhv3ovdu8d5V5KohNqjsMVux/kZrsorX
	KYdtmvQMGHTqknItw35xsilA1xxJuGkk7EHGQP8O5K5XY2wiGj8Pd1OWUFWFbn+SRAbtqEx1isf
	96phK4hGjzb660W5BwcJoN7UvCxVEl5eBdYdCsMrZRuTR6IZhZTZAxfZtzd689vr8DEZKP//HmQ
	7H4LkvNYNau3MyefVxYiEzJV74n9qXyaPiq2yp+mFhtcfu4lVZWiXWSYvWFVM6Nr9GIiGr0OrIo
	kt2h8qGTiq1Rr5qjIqo9wnAVRQn3H1qiftZTsc3flk00Sv82KYot9J59BBckhvIos2MAqI
X-Received: by 2002:a17:902:d483:b0:2b4:6529:7bae with SMTP id d9443c01a7336-2bd579828c1mr113055ad.17.1778694250324;
        Wed, 13 May 2026 10:44:10 -0700 (PDT)
Received: from google.com (44.234.124.34.bc.googleusercontent.com. [34.124.234.44])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c8267688e2esm15538264a12.8.2026.05.13.10.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 10:44:09 -0700 (PDT)
Date: Wed, 13 May 2026 17:44:03 +0000
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
Subject: Re: [PATCH rc 2/5] iommu: Fix up map/unmap debugging for iommupt
 domains
Message-ID: <agS4Y7KDBlU3nR_u@google.com>
References: <0-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
 <2-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>

On Tue, May 12, 2026 at 01:46:14PM -0300, Jason Gunthorpe wrote:
> Sashiko noticed a few issues in this path, and a few more were
> found on review. Tidy them up further. These are intertwined
> because the debug code depends on some of the WARN_ONs to function
> right:
> 
> Lift into iommu_map_nosync():
> - The might_sleep_if()
> - 0 pgsize_bitmap WARN_ON
> - Promote the illegal domain->type to a WARN_ON
> - WARN_ON for illegal gfp flags
> 
> Then remove the return 0 since it is now safe to call
> iommu_debug_map().
> 
> Lift into __iommu_unmap():
> - 0 pgsize_bitmap WARN_ON
> - Promote the illegal domain->type to a WARN_ON
> - iommu_debug_unmap_begin()
> 
> This now pairs with the unconditional iommu_debug_map() on the
> mapping side. Thus iommu debugging now works for iommupt along
> with some of the other debugging features.
> 
> Fixes: 99fb8afa16ad ("iommupt: Directly call iommupt's unmap_range()")
> Fixes: d6c65b0fd621 ("iommupt: Avoid rewalking during map")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks
