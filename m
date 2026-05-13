Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FAFF40DFB8
	for <patches@lists.linux.dev>; Wed, 13 May 2026 14:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778684248; cv=none; b=M28JHas+ujducF52LmWyEnmU0Girv7kR7xhwS/JEa9okcv/2Mek6o3h/WpCGfZ9MQpQRNCBGg4h0Dy3vX2m3iMB3vIL49NB2jhlWF9cHazQJrOsuCxI2DcL97MfDSqyD6ZMOpwFyxmgzbl5xdC87sB49x2vnPAYhcoqeOZwbGXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778684248; c=relaxed/simple;
	bh=h9bAwQMPen4e2kR3BQjshOf6XOKV0LRZUx+Q+Yhg74M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WI20zeq9lNxigl7yCT5GeA66tjJ5mNXg5FascdopX4aq1O1PS35HUVdp1vtFSwOMZOTbRBCOm3Cp3vuxhRDZ8q3yWUzTYHF/dRMNt05a9n4VCWaHzNWmtfoBvlpQ54e45lBEu+r9E7iPf+n/5lEXnGn5q6sDBwy2bIU5L2k3ThY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=REaO78rU; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="REaO78rU"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-488940ccfa6so1085e9.1
        for <patches@lists.linux.dev>; Wed, 13 May 2026 07:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778684245; x=1779289045; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7HJ+58x1aDhyagRTCbZYUW45HaOqv0hJBTleCF7fG8M=;
        b=REaO78rUhyulxXuXT75rODCIRGe6TGovU8TCO5vyVFnzT52zwT+AQFC2Dn+TJik+fE
         rQDaaoOniBPAx9jz6fldAqhwNo9ZQqBMJlB6NxrZmbgZ6Nyl3lvQ3taUwkCMqoCjPrTa
         rvYquIoP8KfCenKl0JwCDEvN5yH+QDHosNctmtC5yt+O7r/EkPB9AKSiTsZlNaIjn2t4
         ls1OnqFqSbdI97r+1vMkFTIlCwz+8Ronsfp+Ej+fSnM+vq/eOz0Rfro2rBrJeJXttnxM
         APc7EHF20SbJofcdPSBaXjD+0dj7k2tbghF/C+I09p/XVbTogJmnzo0sTb/2eYPGermY
         mPFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778684245; x=1779289045;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7HJ+58x1aDhyagRTCbZYUW45HaOqv0hJBTleCF7fG8M=;
        b=QaNis3ZQT03W2EYgwiDzKJaElPU8/5Cr46CyApaOY0Zm0HFbEWElaFOfWNvb49EJQl
         UZJ34yLtM09ZYmWfp7cAE0q3DF722WCkUXy/7Qlru54opZGMLammWbaEP//ODwUbluhM
         lQW+a0vl53IkU/EJqBIcRrYCZw7pxSKOC5tqRWyNkrLfqe8gKUyHCl9EQUlWsQ+Furzg
         RCz+PF7BAVJBtF8Kc/8+/pWBDorz35E0rfK+cW1ZG5lIKcDpIThF52wp8yLMzJWfeplV
         lZ1Rzd4D6nmfLEsCUucVy6E837TXSjz4HbnYy6tD5tRsbHKkW/J15ZNe9p97mMJ07nrZ
         tkyQ==
X-Forwarded-Encrypted: i=1; AFNElJ85d9yd/iuTfvljFDyZ5NqW3Xqux6dnSmBmmjGQl5hYAIlPyNlRpDWeGF/NN/y2iRMlwf4lOcga@lists.linux.dev
X-Gm-Message-State: AOJu0Yxew7LlPKCvV3KJKBt9bkYG6ElVdfZfnN2iBBfD3WIy5O4VEAcR
	DQtdnW3EnSkQMqc/HwJ4lkTxzeSr/vyEcmm7L9SwDkZ0/zJQPByvwoIQZLA3neJPtA==
X-Gm-Gg: Acq92OFkZSfGMrp4AQ2IHiYpvTbFwsqPN90QjrBJ62F0cWFUufNwMw8pZv5vetCOWUG
	8qENYnWbrMIe14SXr3Jm2mvOSlOBY651FxD8055jxWJIJTWa6uYv+jDEup1mRb7exFeDCvJBrzg
	r4/xqQTM7GeWxqaNt90v1Dq3PTvM+sbrlbs0Zt8Fd2WAfgNEW5tTfngZL78y66f6OopumZuwrbk
	6AhH4DrkFKl3AAaSjAF5Bb/WlHFY7uV4ban1lQgLU70j3OIjL4TtuKzl422vkHE4Pff2UFsy1Ug
	sn17KqC+tVBIhobnkg2UVpXwnH+Ahcbso9qWMr6sD0wdhTOxrw7HZs8uxcXb/L8WJIPnHN4uTF9
	q+IAJf8VeqluqyN26kD/yW0ltnDwWBVpeAgBd8HL6RToecN0Wh0tZUxSUedA6EmQeBCwWE/iVI2
	vIOl+PC2txd5q6tlv3xz1XtBklVtQhRGravPWADsPkf4NgTxzdl+09q36JTdivNUf5pbM=
X-Received: by 2002:a05:600d:8486:20b0:477:86fd:fb49 with SMTP id 5b1f17b1804b1-48fc919a43dmr860735e9.10.1778684244549;
        Wed, 13 May 2026 07:57:24 -0700 (PDT)
Received: from google.com (8.181.38.34.bc.googleusercontent.com. [34.38.181.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fc8d27d31sm128460865e9.8.2026.05.13.07.57.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 07:57:23 -0700 (PDT)
Date: Wed, 13 May 2026 14:57:17 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Josua Mayer <josua@solid-run.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH rc 1/5] iommu: Fix loss of errno on map failure for
 classic ops
Message-ID: <agSRTQFAhiRQ6DYQ@google.com>
References: <0-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
 <1-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>

On Tue, May 12, 2026 at 01:46:13PM -0300, Jason Gunthorpe wrote:
> A typo, likely from a rebase, inverted the condition and caused
> errors to be lost. Fix it to be "if (ret)".
> 
> This was breaking iommu_create_device_direct_mappings() on drivers
> that don't use iommupt and don't fully set up their domain in
> alloc_pages() (i.e., SMMUv2). In this case the first call of
> iommu_create_device_direct_mappings() should fail due to the
> incompletely initialized domain. Since it wrongly returns success,
> the second call to iommu_create_device_direct_mappings() doesn't
> happen and IOMMU_RESV_DIRECT is never set up.
> 
> Cc: stable@vger.kernel.org
> Fixes: d6c65b0fd621 ("iommupt: Avoid rewalking during map")
> Reported-by: Josua Mayer <josua@solid-run.com>
> Closes: https://lore.kernel.org/all/321c2e57-6a17-4aef-ba42-d2ebd577e472@solid-run.com/
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Mostafa Saleh <smostafa@google.com>

Thanks,
Mostafa

> ---
>  drivers/iommu/iommu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 61c12ba782066a..6e53cfad5dc001 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -2669,7 +2669,7 @@ int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
>  		return 0;
>  	}
>  	ret = __iommu_map_domain_pgtbl(domain, iova, paddr, size, prot, gfp);
> -	if (!ret)
> +	if (ret)
>  		return ret;
>  
>  	trace_map(iova, paddr, size);
> -- 
> 2.43.0
> 
