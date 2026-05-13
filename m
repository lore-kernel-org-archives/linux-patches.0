Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D068B4A13A1
	for <patches@lists.linux.dev>; Wed, 13 May 2026 16:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778690745; cv=none; b=kp8dJEYdzT/eoYMVMQSpIJL/W7N4ByzdbpIqlZI1VcwxcFFduVB1gbik82vjLe1J0qZVs/s45C9VvQIvGk2mSEBI23GvjYrAmjrVpY4DWPxTIo6Pi5OWpQliYDzQD1XtbMDHWLFmDJnfbdb6UHIqOL2BduX5mRDJVwa7eEjEUpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778690745; c=relaxed/simple;
	bh=G6dCLo5SpKgCvE1TFsg41MaLaUN6BhTG3vfdETy4VBU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qhw+gardKPu83lcPFYhwUo5r4FC5lgnm1XJSxV3a+FYIwj31E7hO/g0bIZhT9mUIOH7RxTjvKUUQvljxZXMI7DqEAImYTQk2AyAoDEaYQwc/ud1VcXK1+kBUFfubHGprAY8eWV5xApBeiDQ41QiKtN5yjOUucitYxdnTj6vFN/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bk4kF3//; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bk4kF3//"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ba3b9bcf69so8785ad.0
        for <patches@lists.linux.dev>; Wed, 13 May 2026 09:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778690743; x=1779295543; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=G6dCLo5SpKgCvE1TFsg41MaLaUN6BhTG3vfdETy4VBU=;
        b=bk4kF3//rjGzn2IbdbtHbHCJTWpsP7WpTbU48V5FtBI5yftnn68eH7dmgz9uT9SFNs
         qH5LRKcTtGeSx8/sYTIsExoElZ3rQQaQbUbnkkIQcy5te3KWh8+MTlSBNLuAPmp+EcJ2
         e+feGtnNMrqObtgfggtq99HXuKsLmhD18IOF5ms06YspCTvyPGPcdEpyV4anOezldI5C
         6RibwbqvTPCxtB+gr9fTz1Q3K2lj/6VrR9znJiU6EwuIv4LGtSqj3NO67oMWZOvo0DKp
         xuPJPPC+ujLkNdvHJcYyeGEsx/tYdlx2oeAsfm5ewIt+dkwzwHhvMuVS+FycyXmDkIgs
         YNrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778690743; x=1779295543;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G6dCLo5SpKgCvE1TFsg41MaLaUN6BhTG3vfdETy4VBU=;
        b=dvm837qk+xP539chAADNDR0h5jQX93Ub6i06UBU1S3pWLQ7KOATAagdv90ZICXHTIv
         pcoRVWhE+xGEmP8yqlEv9WBJD42JxDjus5jQ62CXQjWPRBdyN56DgWqz+PiWEoqiS7b9
         tcAHD+Pa41Wp1ebQhxsMnR7HF+k0cFp79yKVlreZyoTsyYxFpY+UVGTpp8V20AsuBmtc
         cGp5qScapeBQvWAqjh+9W0dWnh7vWtxYgG09Zdu0SKLWpWcbtsX+kJUqIazCRMl+ZSpn
         DfQjPnzTneHQxjkihR+4fv8k2TlAW8QlK6WdOwWNYupBonDmphj9UNMvvU/1elSKdXSj
         WjIw==
X-Forwarded-Encrypted: i=1; AFNElJ9ToklRxSI9JTbs1o86yJp3tpZUjAEaPEoxjh9qleeajYRXdSxeQ/qQerFFrl0ucaeTeLVoM+JH@lists.linux.dev
X-Gm-Message-State: AOJu0YyWnt3KFzFg0tq93ZBK+gRBhws+pEDs2HWSsnAQFmfkejr2/mdM
	8rbLqMxhl1lUM01V3Xl8aBa3FUmm8NwBFCCriTKJg9H56DCG1k3hQPifOpGy5XYnWg==
X-Gm-Gg: Acq92OEUAe5iwfL8SZ2rfkKHVoMOuMFOlaM0DTm9/bdLDq78+xt2K5E04BosZlM33O7
	xuxv8+kbXm4Bfc1TKFvbc9plGEhCHRcTHoxOsWFrPctdi6KZ/DKjSw8u2kQTxE+Dki/Ec4m2f0E
	x7aqGUl/WW3/IgtctsZS76T1ksReTFI1/GS2UM2v/cqwOa7bslIg/bXZAT/dylNV7Dc+Cdd1UQn
	JKkAV6yG7GHMd3ptHcdBf2furqA54uKLDt0qGUAk+sLB4UKRoP/hrH+kvedyhv2Tlg1y0jWvH+Y
	2ZrNXpnjheh+rhWb7y9dtkxB50QvkGjhZ3LXZG7bQ/f5yYXjzNtU6Vrwhy1TT3LGg9O9ix24VNz
	mK0YPAj6MHd9CJ3cgTBvJOfqvq0QBqU238nSzid4qFoPsgS/1sH3cpsJsQDnCbzCNP7kpK2BgPh
	pDC8p3JQWFe92PGUdJ6I4DJIbwZZoGMn2bAhjxBsO0VoBh+VTYSxbe3LsiYdKgFQRk1FjezA==
X-Received: by 2002:a17:903:3848:b0:2ba:dfa:328d with SMTP id d9443c01a7336-2bd2c0a2bd2mr3497385ad.1.1778690742233;
        Wed, 13 May 2026 09:45:42 -0700 (PDT)
Received: from google.com (153.46.83.34.bc.googleusercontent.com. [34.83.46.153])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c8267735e3fsm14858749a12.31.2026.05.13.09.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 09:45:41 -0700 (PDT)
Date: Wed, 13 May 2026 16:45:38 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>, 
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Joerg Roedel <joerg.roedel@amd.com>, Josua Mayer <josua@solid-run.com>, 
	Kevin Tian <kevin.tian@intel.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	patches@lists.linux.dev, Pranjal Shrivastava <praan@google.com>, 
	Mostafa Saleh <smostafa@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH rc 2/5] iommu: Fix up map/unmap debugging for iommupt
 domains
Message-ID: <agSqlM18kAJiC8-U@google.com>
References: <0-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
 <2-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <2-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>

On Tue, May 12, 2026 at 01:46:14PM -0300, Jason Gunthorpe wrote:
>Sashiko noticed a few issues in this path, and a few more were
>found on review. Tidy them up further. These are intertwined
>because the debug code depends on some of the WARN_ONs to function
>right:
>
>Lift into iommu_map_nosync():
>- The might_sleep_if()
>- 0 pgsize_bitmap WARN_ON
>- Promote the illegal domain->type to a WARN_ON
>- WARN_ON for illegal gfp flags
>
>Then remove the return 0 since it is now safe to call
>iommu_debug_map().
>
>Lift into __iommu_unmap():
>- 0 pgsize_bitmap WARN_ON
>- Promote the illegal domain->type to a WARN_ON
>- iommu_debug_unmap_begin()
>
>This now pairs with the unconditional iommu_debug_map() on the
>mapping side. Thus iommu debugging now works for iommupt along
>with some of the other debugging features.
>
>Fixes: 99fb8afa16ad ("iommupt: Directly call iommupt's unmap_range()")
>Fixes: d6c65b0fd621 ("iommupt: Avoid rewalking during map")
>Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>---
> drivers/iommu/iommu.c | 43 ++++++++++++++++++++++---------------------
> 1 file changed, 22 insertions(+), 21 deletions(-)
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
