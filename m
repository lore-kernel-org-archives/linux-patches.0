Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8975383
	for <patches@lists.linux.dev>; Mon, 16 Jun 2025 21:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750110605; cv=none; b=qbjrPdcEhuhVsafui7KrAyT6yGjQ5imDuFQI3fqRwLw18cL6GZPS6tTVvIiBEW4czFr4Y1e4cSwRgaJv9UqU3h0+DmQqSVRRBpKc3PKk7egOtKF/TUhUZt6ZSZazizMhW5E2tjjrOgEwrm+dpOj8ZCnU71m0KQcMgl32FqPK7v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750110605; c=relaxed/simple;
	bh=4P4+dDLseVM5kdBfJdd+5Th3NLvd1u4/4k+NujoyAVQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pXEk2s5zlMmmheqV2VHk3nUQ4fqG68un4GA3voMXUdYF1BK9dCQVmPpCn8hNNDeCfW4lGCp9jiSfRg89m+AktxU0Bi1/WWw/Bcu6URaJNBdLlCHyOo/vGPsYBPE6VTFqzuvAdeH+CIpmhQQTl8J3tNq+OsQ9kXtRocLx+Vdp/v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XZJPutHX; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XZJPutHX"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2357c61cda7so20925ad.1
        for <patches@lists.linux.dev>; Mon, 16 Jun 2025 14:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750110603; x=1750715403; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nbJOiRet1tK2+kvy2xbNTvVOXK/uFfHNcA+YMImy1oY=;
        b=XZJPutHXxN0FfD3bE2CT5XR3oLe3BK8JXsrFisrN/wVFr8SkE+mD1K4phoRLTEZ663
         tmMGKd048c1+okK1gznHCFw5rBqBKClycw70IcPdksjf/NppG9Wnk5yFolGOmXkpXXVi
         zFJKQpCNPb8EgdTpO6i6NzSH6IH/Nvzt1UVoi9RfY39Q4dxGPYnn3BCqpD4zKNp+ZS4x
         6cjUokxubYAbhGJuh2ogdqT87L+zV+0YPsl9t/m1riYTFANNHXdDED+Ofgx0r1MCwsCP
         OxrG/DtnuZOa8drOvsOiY7bUADStkyAdQnY9qWIQkIK9ZUbcHhLVZrVqk1L1+x34uICL
         SF8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750110603; x=1750715403;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nbJOiRet1tK2+kvy2xbNTvVOXK/uFfHNcA+YMImy1oY=;
        b=OTs1MOGzOHUn6LOMRXTixndmD3MJGZQWViL+yOUfBje/R7NSZxmK82bLYIPNaHVgXG
         K2l/IGduoQewlhztgIU0Jw5WyuFOyapq7c8ygXng4a5y6tBRKG0uwaUD8IAqtlYSHWDP
         Vu/9Xt2lx1UcV0OydtoKSwHCva59SddMeP7VPyDpG6gciS3Xyo7U12bH/Yi4096yTDMO
         JgcPBnB0G+rbPzIZNU6OD99ZmbCQHTSCIYXHa7QenaB3Kr0ikFzKppavwa91QSdTo/Rb
         sQrUAY9B2nAgXkcdlWz0kBGeV/+QfS2qi9qQxwyq1XIPnpJa3uxDbX3ysV0ACnsWplQK
         J6EA==
X-Forwarded-Encrypted: i=1; AJvYcCW5KKHgGOK08sBIrJembBrZN2nOBkjzignsrVJF/1/IEtpo3HVP9RZoSlwUZKVt2iag2s9mh3xB@lists.linux.dev
X-Gm-Message-State: AOJu0YwnRigyPGsNkSAl4aWRFYfYxCf6Py7dTqhasvlJS8epCFNaqBjV
	r3F85w/iSphbFxnBJiMFa7wgwlBmJX/85QGdgsCeZnbdWrTd5lSrvUgUWx5GMzDgUA==
X-Gm-Gg: ASbGncvZs3C7g4KC1bKNW3Y9q0IKF9gl+FR9P/y+md4OIWgJ0OGC+aq7dulc7xxKDQb
	lN5CvSDCPqQOWWxz60D3Tq3BtUnY+mrX5Mknhm+hE9YEa1UVQn3Xt6rX3FrBlqWERauguenuel0
	vll+6nbg3O098+S31z+n1KXq4lfdsL/9Y3o0fw0zyeCF00Byim3yUWb6mEVjJeTsCqZdSO8IKn+
	Q+gJ2tI8iNP3jHxIanfET+c3kAx7FPPnkYhlYX/xiiVphBeytd/wDdK4irEfTdULwIXtFStBLIJ
	Jbosmp3WOONJUOcc65Zef79LKP7pQyh7VTbZtdzqA7oeb7u3i3nIBxN6pdtK2hmZzCa1PVAKdYa
	myJ484/w6l3pfV/wHipyH
X-Google-Smtp-Source: AGHT+IF5kh8T4/erotyg7EIWicbLom/nqSTy/PmeD+RjMgee3aQrbG4s0yxcVK37VjyTfpjXDUZbBw==
X-Received: by 2002:a17:902:e74f:b0:21f:631c:7fc9 with SMTP id d9443c01a7336-2366c4f491bmr6774135ad.0.1750110602745;
        Mon, 16 Jun 2025 14:50:02 -0700 (PDT)
Received: from google.com (232.98.126.34.bc.googleusercontent.com. [34.126.98.232])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2365d88c1f5sm66411465ad.25.2025.06.16.14.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 14:50:02 -0700 (PDT)
Date: Mon, 16 Jun 2025 21:49:53 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, will@kernel.org,
	robin.murphy@arm.com, joro@8bytes.org, yi.l.liu@intel.com,
	peterz@infradead.org, jsnitsel@redhat.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	baolu.lu@linux.intel.com
Subject: Re: [PATCH v2 05/14] iommufd: Return EOPNOTSUPP for failures due to
 driver bugs
Message-ID: <aFCRgUeP8NJ_f-Q9@google.com>
References: <cover.1749882255.git.nicolinc@nvidia.com>
 <623bb6f0e8fdd7b9c5745a2f99f280163f9f1f5a.1749882255.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <623bb6f0e8fdd7b9c5745a2f99f280163f9f1f5a.1749882255.git.nicolinc@nvidia.com>

On Fri, Jun 13, 2025 at 11:35:17PM -0700, Nicolin Chen wrote:
> It's more accurate to report EOPNOTSUPP when an ioctl failed due to driver
> bug, since there is nothing wrong with the user space side.
> 
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/iommu/iommufd/device.c       | 2 +-
>  drivers/iommu/iommufd/hw_pagetable.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
> index ed0dc539d490..e9b6ca47095c 100644
> --- a/drivers/iommu/iommufd/device.c
> +++ b/drivers/iommu/iommufd/device.c
> @@ -1483,7 +1483,7 @@ int iommufd_get_hw_info(struct iommufd_ucmd *ucmd)
>  		 */
>  		if (WARN_ON_ONCE(cmd->out_data_type ==
>  				 IOMMU_HW_INFO_TYPE_NONE)) {
> -			rc = -ENODEV;
> +			rc = -EOPNOTSUPP;
>  			goto out_free;
>  		}
>  	} else {
> diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
> index 8565a6f596b2..fe789c2dc0c9 100644
> --- a/drivers/iommu/iommufd/hw_pagetable.c
> +++ b/drivers/iommu/iommufd/hw_pagetable.c
> @@ -264,7 +264,7 @@ iommufd_hwpt_nested_alloc(struct iommufd_ctx *ictx,
>  	hwpt->domain->cookie_type = IOMMU_COOKIE_IOMMUFD;
>  
>  	if (WARN_ON_ONCE(hwpt->domain->type != IOMMU_DOMAIN_NESTED)) {
> -		rc = -EINVAL;
> +		rc = -EOPNOTSUPP;
>  		goto out_abort;
>  	}
>  	return hwpt_nested;
> @@ -321,7 +321,7 @@ iommufd_viommu_alloc_hwpt_nested(struct iommufd_viommu *viommu, u32 flags,
>  	hwpt->domain->cookie_type = IOMMU_COOKIE_IOMMUFD;
>  
>  	if (WARN_ON_ONCE(hwpt->domain->type != IOMMU_DOMAIN_NESTED)) {
> -		rc = -EINVAL;
> +		rc = -EOPNOTSUPP;
>  		goto out_abort;
>  	}
>  	return hwpt_nested;

Much clearer retvals.
Reviewed-by: Pranjal Shrivastava <praan@google.com>

> -- 
> 2.43.0
> 
