Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CB9297A41
	for <patches@lists.linux.dev>; Mon, 28 Apr 2025 20:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745871274; cv=none; b=D851x4tJSyxJU1Yfl/vQ5dPGQionfKlXYaGr0ZVQfQDUW0krnzoBKLRvsmredsf5nfoaqASJUgl0zYmcDJsBeh3JnwOcIRtsKYv8z3KjVAP0Nzo0SjXeeEjPMR+4WHDqoRdQp7q4sXW7X066w56HJncv0hQXZt94PtmZ8/5fA5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745871274; c=relaxed/simple;
	bh=npEaUa9y7aoYDxWJKVP6eFuSAM+GuqK8BYJKktzo5Io=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=atJZkF2V3ZHMPK4ycF/oJDTixNxKBQtm1S0dmf7Sh8kzz3XhAsD2nwVAYu3/OOZL+ANGZIxma2GEgw3AIqiG926wy1I/JVZfRSxh7vSTy7vdqa1mr5gwO0lEShtmkZiopPDUteB9aRjFlA7819yW+rf+nDH7U04L1fIb/GmDjbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=09ZT0RnR; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="09ZT0RnR"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2264c9d0295so50125ad.0
        for <patches@lists.linux.dev>; Mon, 28 Apr 2025 13:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745871271; x=1746476071; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sF3TQXTjTwLlsmEr6Vx8Y4aN4YqmuAbAC+QoJEmyUXM=;
        b=09ZT0RnRzGaPvuxJ4mpglmqCh5Y0H2AWaptTcLBAEEx3ou9q1ZMmTpBhZzP3Yw6bq8
         fGqLDYJrD/GZs/zcGq72q9Nc7i9id6XyTHx9L1l415iGligop8V/9X4dLacwW6UlKWoD
         kDwTB+Qwseynu1LZVZ0n6exOLenVmoHiZqTOlhTSG3ygu3+8SSREvCXKCKxe4TeJy8I/
         89wro0wqahpSD0O9rOx5VD7CR94BGyLyBd3twAAtFH7wnu2DAtrAuFraWJeP2BpmVk4+
         k4lY3ieOPiCZGpTEmYqef7iaAirBEYkxNvTQqnaaZ3hiPN3gtAQY5uA+UMcoEByWyDW0
         kQug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745871271; x=1746476071;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sF3TQXTjTwLlsmEr6Vx8Y4aN4YqmuAbAC+QoJEmyUXM=;
        b=RTY5nRzznmuv7dxgAyM/iNSUFtiqazeV+Q9k+bGT/DSh5zzfu6Ov3aCK10IdR5AG3G
         w+JbJYRVcsBar5KJZb+z0Y1JyUzbTgy4dPLmiXdYpr5eHRZrPjh/JYJK3vp4xjavqeRr
         HSEmWKcMO8R5K4FFlNNlIVwTcai/HgmFp3HqL+O3n5vhFj4FWQuNFVca6t7QdV/ij90r
         MBWy7QfA5ckBoLrs6y9nDGpJ1PZoAQ+0vk6c4cB3/N+VGX4qHY6qL6GO6d4N2xurS0qP
         cqrbBbtw54H+hwTZAUx6HFq5O5bT82RnszBwmYRX1fZrUMtA66Ku6SpPmfVINtU7OjII
         XTRA==
X-Forwarded-Encrypted: i=1; AJvYcCVUXtRfoyW9Qu+u8dn+ipb4ykuVIeOY6x0BnkrRXYFcZB2rehptNZYUYyvA42K7/gHpby66tp5h@lists.linux.dev
X-Gm-Message-State: AOJu0YxlipuQ01ZBDeghzQsp0m4VovmrtT6YtjCcoluCDAsq3l5VW6mU
	6myUUiCGf6icV9L6ePCbSTawYp4S0qSt4vbUB+nAuBeJ2n3sCgP0CGreUUPmjw==
X-Gm-Gg: ASbGnct2om6vwdWAom3XjsIGnC4yXSsKGIVAfJRfMdvUoBUDoRnRbsrrIYfqn7Nl0Gt
	KwIlVaIkn9RaRIT/a53RxWBEVTGeo0U21w4VMF5Ea+l3ZRRdBsaMj4Kp83fzN5i5i+GzTjXlbch
	zUYFXjNsCotGpEH6uN7D+J1NxfuLditX48zaNagzqywd4o++H83uSK63TH1mxwpWspjNlxJfUhC
	r4fctCW5WlF57BHJH4b5zS8EyVovDYLGFyZtCmDWRQbUY6Laj4ck7LsVZYgy+gygL8TilSWYCVy
	Gk3tLozY7f7jUXfXhHUYXkl7HgtfrU9jnqyJT8Qo29DoIDbSxb8vD2OMacDVcbooj9DnV0p+
X-Google-Smtp-Source: AGHT+IGmtl/Kj7Dfb3LKwjogpzMnxm1K7d+HjcHQ0Rw+sVKLpRXDlU7ddaIuIujt0mHKuRlgJFYRhQ==
X-Received: by 2002:a17:902:ce0d:b0:21f:4986:c7d5 with SMTP id d9443c01a7336-22de6c488fcmr714075ad.8.1745871271079;
        Mon, 28 Apr 2025 13:14:31 -0700 (PDT)
Received: from google.com (2.210.143.34.bc.googleusercontent.com. [34.143.210.2])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b15fadea8d8sm7669029a12.64.2025.04.28.13.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 13:14:30 -0700 (PDT)
Date: Mon, 28 Apr 2025 20:14:19 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, corbet@lwn.net, will@kernel.org,
	bagasdotme@gmail.com, robin.murphy@arm.com, joro@8bytes.org,
	thierry.reding@gmail.com, vdumpa@nvidia.com, jonathanh@nvidia.com,
	shuah@kernel.org, jsnitsel@redhat.com, nathan@kernel.org,
	peterz@infradead.org, yi.l.liu@intel.com, mshavit@google.com,
	zhangzekun11@huawei.com, iommu@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	linux-kselftest@vger.kernel.org, patches@lists.linux.dev,
	mochs@nvidia.com, alok.a.tiwari@oracle.com, vasant.hegde@amd.com
Subject: Re: [PATCH v2 08/22] iommufd: Abstract iopt_pin_pages and
 iopt_unpin_pages helpers
Message-ID: <aA_hm_AD4Xzm3qJZ@google.com>
References: <cover.1745646960.git.nicolinc@nvidia.com>
 <d44272c153e7596c3cef716044de3dc6c2a8254a.1745646960.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d44272c153e7596c3cef716044de3dc6c2a8254a.1745646960.git.nicolinc@nvidia.com>

On Fri, Apr 25, 2025 at 10:58:03PM -0700, Nicolin Chen wrote:
> The new vCMDQ object will be added for HW to access the guest memory for a
> HW-accelerated virtualization feature. It needs to ensure the guest memory
> pages are pinned when HW accesses them and they are contiguous in physical
> address space.
> 
> This is very like the existing iommufd_access_pin_pages() that outputs the
> pinned page list for the caller to test its contiguity.
> 
> Move those code from iommufd_access_pin/unpin_pages() and related function
> for a pair of iopt helpers that can be shared with the vCMDQ allocator. As
> the vCMDQ allocator will be a user-space triggered ioctl function, WARN_ON
> would not be a good fit in the new iopt_unpin_pages(), thus change them to
> use WARN_ON_ONCE instead.
> 
> Rename check_area_prot() to align with the existing iopt_area helpers, and
> inline it to the header since iommufd_access_rw() still uses it.
> 
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/iommu/iommufd/io_pagetable.h    |   8 ++
>  drivers/iommu/iommufd/iommufd_private.h |   6 ++
>  drivers/iommu/iommufd/device.c          | 117 ++----------------------
>  drivers/iommu/iommufd/io_pagetable.c    |  95 +++++++++++++++++++
>  4 files changed, 117 insertions(+), 109 deletions(-)
> 
> diff --git a/drivers/iommu/iommufd/io_pagetable.h b/drivers/iommu/iommufd/io_pagetable.h
> index 10c928a9a463..4288a2b1a90f 100644
> --- a/drivers/iommu/iommufd/io_pagetable.h
> +++ b/drivers/iommu/iommufd/io_pagetable.h
> @@ -114,6 +114,14 @@ static inline unsigned long iopt_area_iova_to_index(struct iopt_area *area,
>  	return iopt_area_start_byte(area, iova) / PAGE_SIZE;
>  }
>  
> +static inline bool iopt_area_check_prot(struct iopt_area *area,
> +					unsigned int flags)
> +{
> +	if (flags & IOMMUFD_ACCESS_RW_WRITE)
> +		return area->iommu_prot & IOMMU_WRITE;
> +	return area->iommu_prot & IOMMU_READ;
> +}
> +
>  #define __make_iopt_iter(name)                                                 \
>  	static inline struct iopt_##name *iopt_##name##_iter_first(            \
>  		struct io_pagetable *iopt, unsigned long start,                \
> diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
> index 8d96aa514033..79160b039bc7 100644
> --- a/drivers/iommu/iommufd/iommufd_private.h
> +++ b/drivers/iommu/iommufd/iommufd_private.h
> @@ -130,6 +130,12 @@ int iopt_cut_iova(struct io_pagetable *iopt, unsigned long *iovas,
>  void iopt_enable_large_pages(struct io_pagetable *iopt);
>  int iopt_disable_large_pages(struct io_pagetable *iopt);
>  
> +int iopt_pin_pages(struct io_pagetable *iopt, unsigned long iova,
> +		   unsigned long length, struct page **out_pages,
> +		   unsigned int flags);
> +void iopt_unpin_pages(struct io_pagetable *iopt, unsigned long iova,
> +		      unsigned long length);
> +
>  struct iommufd_ucmd {
>  	struct iommufd_ctx *ictx;
>  	void __user *ubuffer;
> diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
> index 2111bad72c72..a5c6be164254 100644
> --- a/drivers/iommu/iommufd/device.c
> +++ b/drivers/iommu/iommufd/device.c
> @@ -1240,58 +1240,17 @@ void iommufd_access_notify_unmap(struct io_pagetable *iopt, unsigned long iova,
>  void iommufd_access_unpin_pages(struct iommufd_access *access,
>  				unsigned long iova, unsigned long length)
>  {
> -	struct iopt_area_contig_iter iter;
> -	struct io_pagetable *iopt;
> -	unsigned long last_iova;
> -	struct iopt_area *area;
> -
> -	if (WARN_ON(!length) ||
> -	    WARN_ON(check_add_overflow(iova, length - 1, &last_iova)))
> -		return;
> -
> -	mutex_lock(&access->ioas_lock);
> +	guard(mutex)(&access->ioas_lock);
>  	/*
>  	 * The driver must be doing something wrong if it calls this before an
>  	 * iommufd_access_attach() or after an iommufd_access_detach().
>  	 */
> -	if (WARN_ON(!access->ioas_unpin)) {
> -		mutex_unlock(&access->ioas_lock);
> +	if (WARN_ON(!access->ioas_unpin))
>  		return;
> -	}
> -	iopt = &access->ioas_unpin->iopt;
> -
> -	down_read(&iopt->iova_rwsem);
> -	iopt_for_each_contig_area(&iter, area, iopt, iova, last_iova)
> -		iopt_area_remove_access(
> -			area, iopt_area_iova_to_index(area, iter.cur_iova),
> -			iopt_area_iova_to_index(
> -				area,
> -				min(last_iova, iopt_area_last_iova(area))));
> -	WARN_ON(!iopt_area_contig_done(&iter));
> -	up_read(&iopt->iova_rwsem);
> -	mutex_unlock(&access->ioas_lock);
> +	iopt_unpin_pages(&access->ioas_unpin->iopt, iova, length);
>  }
>  EXPORT_SYMBOL_NS_GPL(iommufd_access_unpin_pages, "IOMMUFD");
>  
> -static bool iopt_area_contig_is_aligned(struct iopt_area_contig_iter *iter)
> -{
> -	if (iopt_area_start_byte(iter->area, iter->cur_iova) % PAGE_SIZE)
> -		return false;
> -
> -	if (!iopt_area_contig_done(iter) &&
> -	    (iopt_area_start_byte(iter->area, iopt_area_last_iova(iter->area)) %
> -	     PAGE_SIZE) != (PAGE_SIZE - 1))
> -		return false;
> -	return true;
> -}
> -
> -static bool check_area_prot(struct iopt_area *area, unsigned int flags)
> -{
> -	if (flags & IOMMUFD_ACCESS_RW_WRITE)
> -		return area->iommu_prot & IOMMU_WRITE;
> -	return area->iommu_prot & IOMMU_READ;
> -}
> -
>  /**
>   * iommufd_access_pin_pages() - Return a list of pages under the iova
>   * @access: IOAS access to act on
> @@ -1315,76 +1274,16 @@ int iommufd_access_pin_pages(struct iommufd_access *access, unsigned long iova,
>  			     unsigned long length, struct page **out_pages,
>  			     unsigned int flags)
>  {
> -	struct iopt_area_contig_iter iter;
> -	struct io_pagetable *iopt;
> -	unsigned long last_iova;
> -	struct iopt_area *area;
> -	int rc;
> -
>  	/* Driver's ops don't support pin_pages */
>  	if (IS_ENABLED(CONFIG_IOMMUFD_TEST) &&
>  	    WARN_ON(access->iova_alignment != PAGE_SIZE || !access->ops->unmap))
>  		return -EINVAL;
>  
> -	if (!length)
> -		return -EINVAL;
> -	if (check_add_overflow(iova, length - 1, &last_iova))
> -		return -EOVERFLOW;
> -
> -	mutex_lock(&access->ioas_lock);
> -	if (!access->ioas) {
> -		mutex_unlock(&access->ioas_lock);
> +	guard(mutex)(&access->ioas_lock);
> +	if (!access->ioas)
>  		return -ENOENT;
> -	}
> -	iopt = &access->ioas->iopt;
> -
> -	down_read(&iopt->iova_rwsem);
> -	iopt_for_each_contig_area(&iter, area, iopt, iova, last_iova) {
> -		unsigned long last = min(last_iova, iopt_area_last_iova(area));
> -		unsigned long last_index = iopt_area_iova_to_index(area, last);
> -		unsigned long index =
> -			iopt_area_iova_to_index(area, iter.cur_iova);
> -
> -		if (area->prevent_access ||
> -		    !iopt_area_contig_is_aligned(&iter)) {
> -			rc = -EINVAL;
> -			goto err_remove;
> -		}
> -
> -		if (!check_area_prot(area, flags)) {
> -			rc = -EPERM;
> -			goto err_remove;
> -		}
> -
> -		rc = iopt_area_add_access(area, index, last_index, out_pages,
> -					  flags);
> -		if (rc)
> -			goto err_remove;
> -		out_pages += last_index - index + 1;
> -	}
> -	if (!iopt_area_contig_done(&iter)) {
> -		rc = -ENOENT;
> -		goto err_remove;
> -	}
> -
> -	up_read(&iopt->iova_rwsem);
> -	mutex_unlock(&access->ioas_lock);
> -	return 0;
> -
> -err_remove:
> -	if (iova < iter.cur_iova) {
> -		last_iova = iter.cur_iova - 1;
> -		iopt_for_each_contig_area(&iter, area, iopt, iova, last_iova)
> -			iopt_area_remove_access(
> -				area,
> -				iopt_area_iova_to_index(area, iter.cur_iova),
> -				iopt_area_iova_to_index(
> -					area, min(last_iova,
> -						  iopt_area_last_iova(area))));
> -	}
> -	up_read(&iopt->iova_rwsem);
> -	mutex_unlock(&access->ioas_lock);
> -	return rc;
> +	return iopt_pin_pages(&access->ioas->iopt, iova, length, out_pages,
> +			      flags);
>  }
>  EXPORT_SYMBOL_NS_GPL(iommufd_access_pin_pages, "IOMMUFD");
>  
> @@ -1431,7 +1330,7 @@ int iommufd_access_rw(struct iommufd_access *access, unsigned long iova,
>  			goto err_out;
>  		}
>  
> -		if (!check_area_prot(area, flags)) {
> +		if (!iopt_area_check_prot(area, flags)) {
>  			rc = -EPERM;
>  			goto err_out;
>  		}
> diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
> index 8a790e597e12..160eec49af1b 100644
> --- a/drivers/iommu/iommufd/io_pagetable.c
> +++ b/drivers/iommu/iommufd/io_pagetable.c
> @@ -1472,3 +1472,98 @@ int iopt_table_enforce_dev_resv_regions(struct io_pagetable *iopt,
>  	up_write(&iopt->iova_rwsem);
>  	return rc;
>  }
> +
> +static bool iopt_area_contig_is_aligned(struct iopt_area_contig_iter *iter)
> +{
> +	if (iopt_area_start_byte(iter->area, iter->cur_iova) % PAGE_SIZE)
> +		return false;
> +
> +	if (!iopt_area_contig_done(iter) &&
> +	    (iopt_area_start_byte(iter->area, iopt_area_last_iova(iter->area)) %
> +	     PAGE_SIZE) != (PAGE_SIZE - 1))
> +		return false;
> +	return true;
> +}
> +
> +int iopt_pin_pages(struct io_pagetable *iopt, unsigned long iova,
> +		   unsigned long length, struct page **out_pages,
> +		   unsigned int flags)
> +{
> +	struct iopt_area_contig_iter iter;
> +	unsigned long last_iova;
> +	struct iopt_area *area;
> +	int rc;
> +
> +	if (!length)
> +		return -EINVAL;
> +	if (check_add_overflow(iova, length - 1, &last_iova))
> +		return -EOVERFLOW;
> +
> +	down_read(&iopt->iova_rwsem);
> +	iopt_for_each_contig_area(&iter, area, iopt, iova, last_iova) {
> +		unsigned long last = min(last_iova, iopt_area_last_iova(area));
> +		unsigned long last_index = iopt_area_iova_to_index(area, last);
> +		unsigned long index =
> +			iopt_area_iova_to_index(area, iter.cur_iova);
> +
> +		if (area->prevent_access ||

Nit:
Shouldn't we return -EBUSY or something if (area->prevent_access == 1) ?
IIUC, this just means that an unmap attempt is in progress, hence avoid
accessing the area.

> +		    !iopt_area_contig_is_aligned(&iter)) {
> +			rc = -EINVAL;
> +			goto err_remove;
> +		}
> +
> +		if (!iopt_area_check_prot(area, flags)) {
> +			rc = -EPERM;
> +			goto err_remove;
> +		}
> +
> +		rc = iopt_area_add_access(area, index, last_index, out_pages,
> +					  flags);
> +		if (rc)
> +			goto err_remove;
> +		out_pages += last_index - index + 1;
> +	}
> +	if (!iopt_area_contig_done(&iter)) {
> +		rc = -ENOENT;
> +		goto err_remove;
> +	}
> +
> +	up_read(&iopt->iova_rwsem);
> +	return 0;
> +
> +err_remove:
> +	if (iova < iter.cur_iova) {
> +		last_iova = iter.cur_iova - 1;
> +		iopt_for_each_contig_area(&iter, area, iopt, iova, last_iova)
> +			iopt_area_remove_access(
> +				area,
> +				iopt_area_iova_to_index(area, iter.cur_iova),
> +				iopt_area_iova_to_index(
> +					area, min(last_iova,
> +						  iopt_area_last_iova(area))));
> +	}
> +	up_read(&iopt->iova_rwsem);
> +	return rc;
> +}
> +
> +void iopt_unpin_pages(struct io_pagetable *iopt, unsigned long iova,
> +		      unsigned long length)
> +{
> +	struct iopt_area_contig_iter iter;
> +	unsigned long last_iova;
> +	struct iopt_area *area;
> +
> +	if (WARN_ON_ONCE(!length) ||
> +	    WARN_ON_ONCE(check_add_overflow(iova, length - 1, &last_iova)))
> +		return;
> +
> +	down_read(&iopt->iova_rwsem);
> +	iopt_for_each_contig_area(&iter, area, iopt, iova, last_iova)
> +		iopt_area_remove_access(
> +			area, iopt_area_iova_to_index(area, iter.cur_iova),
> +			iopt_area_iova_to_index(
> +				area,
> +				min(last_iova, iopt_area_last_iova(area))));
> +	WARN_ON_ONCE(!iopt_area_contig_done(&iter));
> +	up_read(&iopt->iova_rwsem);
> +}
> -- 
> 2.43.0
> 
