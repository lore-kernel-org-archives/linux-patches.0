Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17662ECE86
	for <patches@lists.linux.dev>; Fri, 24 Jul 2026 17:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784915370; cv=none; b=fSLWvhC5gT8kXJuSmoo4A5pzUCaLW3wlmj7V8zY1LbRjHshBRYHaHdy+pu96ebkwrhRAOg9Vd/0mSEI9UGdVEMEPe9T/kgXsickPt1Q5UrnEg1bywgCIdrWUaa6KSJvlpBaJMBQoDPgf5DT5N0DO3IMfoxhfGAW5MCVWDHrjZaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784915370; c=relaxed/simple;
	bh=vLcGVz2tdtFGGN4iYOW2oVtXgKv/RWuuJl9rYzsx0yc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hMByCOFgT0k+GCr7vit834CTrqVU6dRZMyerSdKxzVpow5EaTyk/JTA2vHoRXq3D43mnqFA2/hSEaM9SRKIrfGO+9Xndfc2gEzdAezrhmoYekPBVepiVOchpkQclRrGKTGLwpKnyvuQ4N6E2G+7P53j9mDGDgCQr4gIDFPkaC+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TxZlsH1P; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TxZlsH1P"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-495509b08ebso3155e9.1
        for <patches@lists.linux.dev>; Fri, 24 Jul 2026 10:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784915367; x=1785520167; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UnE2PZuA4mlcF5l6Wvu31DrgU1W+yVTlxMHSfuz9j+8=;
        b=TxZlsH1PsQzDQkCJFNisZzEpsJvDtJn/svuzO7wjZSOlnAGPgQqj/BwSVJsSxU5Fd0
         +EEcw0LJxSFmaVPkFhPOF7f0nmEb8zaGiSYELuGhafMC2IbMO5cAJYKsjeQ19wQc7dvF
         ZXUMmSOP7dhuQsQ8xGCp+/Q70BvKb626tHbk6Fj48NqqkwNWdQxLkC1Uvil6i9lJZ/Dv
         cj/UNFuyokHmyJodDOjJOt218dSTwnArvpHePg68br6JQUhXjvDo2cLpKqIoWi7UWtIP
         axrEVK+RBzl+h5zz7aIw+L+NIDwnW1F2akrQquw+cxgDcLFzFquibQmua1lrSiedyUBC
         zelg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784915367; x=1785520167;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UnE2PZuA4mlcF5l6Wvu31DrgU1W+yVTlxMHSfuz9j+8=;
        b=q17G4bwXio3F7kyKIXw77m02YjhC1/hqjkgcwdeijq+El8WKdUFnPvYB82sEO+BoKo
         XP6FY2wsKOgdRztYMczpJaYTEBAAGDEHGjRzvQTlp5qj51H1onJRWOuABmFS1lN6z1Vy
         yPTM5Q2xurFmDwIzhsndXAR7NBj6s/L+U1XDUGMqQM76/tlISEJii9B9RMVuW1+ALPgB
         V2hKuK+ffCvTdRc/jGGx0FJ/pU6ysUtE+EOKV9ECtk6mLI603ElooTPSzHvMFWO39vtO
         Gcl/vHmIYOWRIbMnYNuHOCuDBtwOY8CQv5XzfTtEg/VZ4/2QwNfwmxmLKyF7D46H0amp
         gQuw==
X-Forwarded-Encrypted: i=1; AHgh+RqgfQdpeWCcS8a67bD2ZFYjSjgFzfX8XNr0sA06im90kMfro9kcLFRtgB69iKs4TD4BbE8Y0kJN@lists.linux.dev
X-Gm-Message-State: AOJu0Yy0GZ+DHlWlC7AMah5CMf0aUC/qEbOcxvCq6Ek2QHDh/EjfgCOO
	bd7p2TlhchTEeWfG1EcnJm1sOuYSR4xdwBkaQLWQOEH6uRUGyCCMdkuJmwDVZ93QvA==
X-Gm-Gg: AR+sD12DK4vSP8n9CwBTpUMYzIxilFa6qJNEgb/KhLmc4hxaTubms6+wo5y7QL4+lla
	VjJlk2TWSPj3NJ1wGvM1MlqZNG3N2LPdcC2pdPI1jW45oVQ4NPqGbN3QrGhcXZpGWG8mU/JvUDB
	tPCkSMR5VxOAllSskLQ+2fH5IvT1zZaMYK6GAkMVJeR1ZWv/meOhqyEmWOJt7BVxKTGLlzBXoXp
	GRJjAaygDP45SqjJOuGPnR65wL25oI53Py+AWQvpUnIYc5r+qgibK/Kiv+7RP/mIl9V4IYdapEG
	lFhxq+rcy8LYn+jrd3npqZY1KV3ZFly8Tb/M8EYXjipSCW/IaTsJQO3FbAE8nmsF2hvmsd8mWmg
	WaE16nsaeaVrhzT7ToEoCuf/jhsOGJWy+or2zcjmG6QEOX+wT6jOrJScWfxA3QMVee7FY8StBps
	Pz2E/e67EnzyTTuhN1IacUPBNyQQH8byb+m1FsVRTU0tE32PIM
X-Received: by 2002:a05:600c:4583:b0:493:aca0:32e2 with SMTP id 5b1f17b1804b1-496b4cf6c36mr98295e9.4.1784915366398;
        Fri, 24 Jul 2026 10:49:26 -0700 (PDT)
Received: from google.com (220.60.76.34.bc.googleusercontent.com. [34.76.60.220])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496b4ee1d31sm1129795e9.5.2026.07.24.10.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 10:49:25 -0700 (PDT)
Date: Fri, 24 Jul 2026 17:49:21 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH 1/7] iommupt: Remove the sanity check for
 pt_num_items_lg2() at the top level
Message-ID: <amOloT9ExCVjYxyf@google.com>
References: <0-v1-807e2d1a5efb+e1-iommupt_armv8_jgg@nvidia.com>
 <1-v1-807e2d1a5efb+e1-iommupt_armv8_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1-v1-807e2d1a5efb+e1-iommupt_armv8_jgg@nvidia.com>

On Mon, Jul 06, 2026 at 01:29:07PM -0300, Jason Gunthorpe wrote:
> This was ill conceived, the existing formats work OK because they
> happen to support pt_num_items_lg2() at the top level. However the
> documentation is clear that is not permitted because ARMv8 has
> concatenated top levels and we do not want to calculate an exact
> pt_num_items_lg2() for the top level special case.
> 
> The logic to compute the number of items of the top level is shown in
> pt_top_memsize_lg2() which is:
> 
> 	num_items_lg2 = common->max_vasz_lg2 - pt_table_item_lg2sz(&pts);
> 
> Which is pointless to try and sanity check.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Mostafa Saleh <smostafa@google.com>

Thanks,
Mostafa

> ---
>  drivers/iommu/generic_pt/iommu_pt.h | 14 --------------
>  1 file changed, 14 deletions(-)
> 
> diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
> index c2752151c80af1..f1320c7e88dbbb 100644
> --- a/drivers/iommu/generic_pt/iommu_pt.h
> +++ b/drivers/iommu/generic_pt/iommu_pt.h
> @@ -1207,20 +1207,6 @@ static int pt_init_common(struct pt_common *common)
>  		     PT_FORCE_ENABLED_FEATURES))
>  		return -EOPNOTSUPP;
>  
> -	/*
> -	 * Check if the top level of the page table is too small to hold the
> -	 * specified maxvasz.
> -	 */
> -	if (!pt_feature(common, PT_FEAT_DYNAMIC_TOP) &&
> -	    top_range.top_level != PT_MAX_TOP_LEVEL) {
> -		struct pt_state pts = { .range = &top_range,
> -					.level = top_range.top_level };
> -
> -		if (common->max_vasz_lg2 >
> -		    pt_num_items_lg2(&pts) + pt_table_item_lg2sz(&pts))
> -			return -EOPNOTSUPP;
> -	}
> -
>  	if (common->max_oasz_lg2 == 0)
>  		common->max_oasz_lg2 = pt_max_oa_lg2(common);
>  	else
> -- 
> 2.43.0
> 
