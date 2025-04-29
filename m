Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97581266572
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 20:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745958287; cv=none; b=G5QeE+2l5zZ0oXlCInBALmCC/6sfHWIMoSHyAeKRRhcU4MlD23FCsLtxbuUC9DzId4ao8dknP2nUN9Kiwyo39BL7hc2cpcOi5CF/R4HC+ZWsH76+QLOJPjV5fCxfVvz0LjEQVSMeVKBeYDav7gd4x0w/IevNaXMNCOzk5D2WlYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745958287; c=relaxed/simple;
	bh=9O+6WTpy0xx60kojalMCZT1tuZWqKS2nTsLIZ0rjn3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VZn+AZw4m+vKRRmtBnG05pjQC626z9obNrM0+HJoyG0AFRLIU+DxqetNIfyWKpXwWkPqZ8yzRru5wWAQnKCFj9elZyVD0vXI1xGwpNiqNTmejp+JwA/OgGny1SHZKhcxPvW55aW9yE4O+6GDPS8/4VPc7nexBwtmu1NTX+BZjtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=beMpnNjE; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="beMpnNjE"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2263428c8baso69205ad.1
        for <patches@lists.linux.dev>; Tue, 29 Apr 2025 13:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745958285; x=1746563085; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=th0orYzeEy2a+Bk04Qy69a62SaixG+OtsUq4sJ7ZV0s=;
        b=beMpnNjEBQoIRDttSbeWmrevl6oMNSq7QG2FVVLW4zMoaCFNUUrsoAd8QohSDq9QWS
         qpPU4Rf0YmQBiexjLbwviKcTGR8ZGYbY96LoH5CR6AbhLk2CaTDGYrDO3flroZ+zSW2n
         0dCJO2OqT5651zww7rcUCvvYYmLPyXmV3J/Ncn4EVHgWkTtUxru5n80XMdcCd+JldmnS
         bNiBI1+hv46qhLrKttFwDhjoaMy1dIQqvgKOQbmy95QTN0UUePvkCgMYHJ7UhkSz0DHY
         ItYkeKz0j6OOGy8vmkL8RZXRUM285vGC2coygDkCy2f7ON34nOyPUv+s5fBu2sn3skW9
         PH1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745958285; x=1746563085;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=th0orYzeEy2a+Bk04Qy69a62SaixG+OtsUq4sJ7ZV0s=;
        b=jazRnIMTVW0D1H4Htvbq3pB2FMfcx5a2qw5eSefGrlOZl/VnoVsPptf0b+QP5FzdlL
         iVh6ZJuAvrINNVQTu3k/6Pkp2oiBdZNW01T9Eq7ycHsX1ejreIRAUrihejjlZyqpubXW
         mkrnqr7GAX7KaatVRlh0g8I195XknmHDvQZdSLU9FqJizksM1VI8uNLVMrRodPWVTMTR
         cA0ed5OqEaJFEGIaSTacD0aVJrKUokhfdS8fMK5jsjFCFAtNOmhiiGJwDCW5iFwrnevv
         5w4BktWLnWgsWJK9nvVm3Jmt17e1sJcs8PZR4tWzT4S33BXYh1AWQEEFihyIXlyE+1Sm
         maig==
X-Forwarded-Encrypted: i=1; AJvYcCUTT5KixcWfLF036ykzCJL03pLfN8kDfrPinnzRPz3TsHB3lF2jWA3zO0OtcUDZNzYxXcAJA6VQ@lists.linux.dev
X-Gm-Message-State: AOJu0YzUbu+S/WXIo4k3RUjYlXhgEDz2Kov7pbAGHNcA4WVcf646l58h
	lJClAc5nBV+fZ7GHT001IHxw1fBvIrjmCbX8Cm3/PKLKSrrd5xtKVMuy5+eY8A==
X-Gm-Gg: ASbGncv/QG52CtCa0DiFei94NNak8PgzbwF0m9fA5TfR7F45/Le930uw0vk0vdbctAt
	FDbU63VXOP2o/fMY/bNUG6bqZNZCFo6qILnqMW7i2gZmQyj5MpnXO03VhzubxYRKz03UDJg9Pfz
	1GrZR/jKJtl24+iEYqKghY/G4tGWTHnRsGKb1dol/8bKZIZ2OsGz2+EOIUaDEVxxip8ibgjhhmq
	QaDnqA4CAzSPIVg6vAklcEmSjeafwqUPxR9MX85SxIwF/RPyxzKWorH+Eb1/s7A/yBgN2uoae3/
	qj6pE4QwzzAe9bUv8rvA5BOkgqfqNSx5uWp0sIuvqoYvUdfqV/WsZQ+UT6KX3ORpRLPn/ncF
X-Google-Smtp-Source: AGHT+IFEmxdIWmGebHZgDe3BPjAbf4Gr2zvdjQF+sAsv0SidwYPT51jhJKxYdYkU6a4RRgjjfiLv+w==
X-Received: by 2002:a17:902:e746:b0:215:aca2:dc04 with SMTP id d9443c01a7336-22df4075fa8mr719485ad.26.1745958284303;
        Tue, 29 Apr 2025 13:24:44 -0700 (PDT)
Received: from google.com (2.210.143.34.bc.googleusercontent.com. [34.143.210.2])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74039a5e09bsm100828b3a.131.2025.04.29.13.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Apr 2025 13:24:43 -0700 (PDT)
Date: Tue, 29 Apr 2025 20:24:33 +0000
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
Subject: Re: [PATCH v2 13/22] iommufd: Add mmap interface
Message-ID: <aBE1gUz9y415EuBQ@google.com>
References: <cover.1745646960.git.nicolinc@nvidia.com>
 <7be26560c604b0cbc2fd218997b97a47e4ed11ff.1745646960.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7be26560c604b0cbc2fd218997b97a47e4ed11ff.1745646960.git.nicolinc@nvidia.com>

On Fri, Apr 25, 2025 at 10:58:08PM -0700, Nicolin Chen wrote:
> For vIOMMU passing through HW resources to user space (VMs), add an mmap
> infrastructure to map a region of hardware MMIO pages.
> 
> Maintain an mt_mmap per ictx for validations. To allow IOMMU drivers to
> add and delete mmappable regions to/from the mt_mmap, add a pair of new
> helpers: iommufd_ctx_alloc_mmap() and iommufd_ctx_free_mmap().
> 
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/iommu/iommufd/iommufd_private.h |  8 +++++
>  include/linux/iommufd.h                 | 15 ++++++++++
>  drivers/iommu/iommufd/driver.c          | 39 +++++++++++++++++++++++++
>  drivers/iommu/iommufd/main.c            | 39 +++++++++++++++++++++++++
>  4 files changed, 101 insertions(+)
> 
> diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
> index b974c207ae8a..db5b62ec4abb 100644
> --- a/drivers/iommu/iommufd/iommufd_private.h
> +++ b/drivers/iommu/iommufd/iommufd_private.h
> @@ -7,6 +7,7 @@
>  #include <linux/iommu.h>
>  #include <linux/iommufd.h>
>  #include <linux/iova_bitmap.h>
> +#include <linux/maple_tree.h>
>  #include <linux/rwsem.h>
>  #include <linux/uaccess.h>
>  #include <linux/xarray.h>
> @@ -44,6 +45,7 @@ struct iommufd_ctx {
>  	struct xarray groups;
>  	wait_queue_head_t destroy_wait;
>  	struct rw_semaphore ioas_creation_lock;
> +	struct maple_tree mt_mmap;
>  
>  	struct mutex sw_msi_lock;
>  	struct list_head sw_msi_list;
> @@ -55,6 +57,12 @@ struct iommufd_ctx {
>  	struct iommufd_ioas *vfio_ioas;
>  };
>  
> +/* Entry for iommufd_ctx::mt_mmap */
> +struct iommufd_mmap {
> +	unsigned long pfn_start;
> +	unsigned long pfn_end;
> +};
> +
>  /*
>   * The IOVA to PFN map. The map automatically copies the PFNs into multiple
>   * domains and permits sharing of PFNs between io_pagetable instances. This
> diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
> index 5dff154e8ce1..d63e2d91be0d 100644
> --- a/include/linux/iommufd.h
> +++ b/include/linux/iommufd.h
> @@ -236,6 +236,9 @@ int iommufd_object_depend(struct iommufd_object *obj_dependent,
>  			  struct iommufd_object *obj_depended);
>  void iommufd_object_undepend(struct iommufd_object *obj_dependent,
>  			     struct iommufd_object *obj_depended);
> +int iommufd_ctx_alloc_mmap(struct iommufd_ctx *ictx, phys_addr_t base,
> +			   size_t size, unsigned long *immap_id);
> +void iommufd_ctx_free_mmap(struct iommufd_ctx *ictx, unsigned long immap_id);
>  struct device *iommufd_viommu_find_dev(struct iommufd_viommu *viommu,
>  				       unsigned long vdev_id);
>  int iommufd_viommu_get_vdev_id(struct iommufd_viommu *viommu,
> @@ -262,11 +265,23 @@ static inline int iommufd_object_depend(struct iommufd_object *obj_dependent,
>  	return -EOPNOTSUPP;
>  }
>  
> +static inline int iommufd_ctx_alloc_mmap(struct iommufd_ctx *ictx,
> +					 phys_addr_t base, size_t size,
> +					 unsigned long *immap_id)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
>  static inline void iommufd_object_undepend(struct iommufd_object *obj_dependent,
>  					   struct iommufd_object *obj_depended)
>  {
>  }
>  
> +static inline void iommufd_ctx_free_mmap(struct iommufd_ctx *ictx,
> +					 unsigned long immap_id)
> +{
> +}
> +
>  static inline struct device *
>  iommufd_viommu_find_dev(struct iommufd_viommu *viommu, unsigned long vdev_id)
>  {
> diff --git a/drivers/iommu/iommufd/driver.c b/drivers/iommu/iommufd/driver.c
> index fb7f8fe40f95..c55336c580dc 100644
> --- a/drivers/iommu/iommufd/driver.c
> +++ b/drivers/iommu/iommufd/driver.c
> @@ -78,6 +78,45 @@ void iommufd_object_undepend(struct iommufd_object *obj_dependent,
>  }
>  EXPORT_SYMBOL_NS_GPL(iommufd_object_undepend, "IOMMUFD");
>  
> +/* Driver should report the output @immap_id to user space for mmap() syscall */
> +int iommufd_ctx_alloc_mmap(struct iommufd_ctx *ictx, phys_addr_t base,
> +			   size_t size, unsigned long *immap_id)
> +{
> +	struct iommufd_mmap *immap;
> +	int rc;
> +
> +	if (WARN_ON_ONCE(!immap_id))
> +		return -EINVAL;
> +	if (base & ~PAGE_MASK)
> +		return -EINVAL;
> +	if (!size || size & ~PAGE_MASK)
> +		return -EINVAL;
> +
> +	immap = kzalloc(sizeof(*immap), GFP_KERNEL);
> +	if (!immap)
> +		return -ENOMEM;
> +	immap->pfn_start = base >> PAGE_SHIFT;
> +	immap->pfn_end = immap->pfn_start + (size >> PAGE_SHIFT) - 1;
> +
> +	rc = mtree_alloc_range(&ictx->mt_mmap, immap_id, immap, sizeof(immap),

I believe this should be sizeof(*immap) ?

> +			       0, LONG_MAX >> PAGE_SHIFT, GFP_KERNEL);
> +	if (rc < 0) {
> +		kfree(immap);
> +		return rc;
> +	}
> +
> +	/* mmap() syscall will right-shift the immap_id to vma->vm_pgoff */
> +	*immap_id <<= PAGE_SHIFT;
> +	return 0;
> +}
> +EXPORT_SYMBOL_NS_GPL(iommufd_ctx_alloc_mmap, "IOMMUFD");
> +
> +void iommufd_ctx_free_mmap(struct iommufd_ctx *ictx, unsigned long immap_id)
> +{
> +	kfree(mtree_erase(&ictx->mt_mmap, immap_id >> PAGE_SHIFT));
> +}
> +EXPORT_SYMBOL_NS_GPL(iommufd_ctx_free_mmap, "IOMMUFD");
> +
>  /* Caller should xa_lock(&viommu->vdevs) to protect the return value */
>  struct device *iommufd_viommu_find_dev(struct iommufd_viommu *viommu,
>  				       unsigned long vdev_id)
> diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
> index ac51d5cfaa61..4b46ea47164d 100644
> --- a/drivers/iommu/iommufd/main.c
> +++ b/drivers/iommu/iommufd/main.c
> @@ -213,6 +213,7 @@ static int iommufd_fops_open(struct inode *inode, struct file *filp)
>  	xa_init_flags(&ictx->objects, XA_FLAGS_ALLOC1 | XA_FLAGS_ACCOUNT);
>  	xa_init(&ictx->groups);
>  	ictx->file = filp;
> +	mt_init_flags(&ictx->mt_mmap, MT_FLAGS_ALLOC_RANGE);
>  	init_waitqueue_head(&ictx->destroy_wait);
>  	mutex_init(&ictx->sw_msi_lock);
>  	INIT_LIST_HEAD(&ictx->sw_msi_list);
> @@ -410,11 +411,49 @@ static long iommufd_fops_ioctl(struct file *filp, unsigned int cmd,
>  	return ret;
>  }
>  
> +/*
> + * Kernel driver must first do iommufd_ctx_alloc_mmap() to register an mmappable
> + * MMIO region to the iommufd core to receive an "immap_id". Then, driver should
> + * report to user space this immap_id and the size of the registered MMIO region
> + * for @vm_pgoff and @size of an mmap() call, via an IOMMU_VIOMMU_ALLOC ioctl in
> + * the output fields of its driver-type data structure.
> + *
> + * Note the @size is allowed to be smaller than the registered size as a partial
> + * mmap starting from the registered base address.
> + */
> +static int iommufd_fops_mmap(struct file *filp, struct vm_area_struct *vma)
> +{
> +	struct iommufd_ctx *ictx = filp->private_data;
> +	size_t size = vma->vm_end - vma->vm_start;
> +	struct iommufd_mmap *immap;
> +
> +	if (size & ~PAGE_MASK)
> +		return -EINVAL;
> +	if (!(vma->vm_flags & VM_SHARED))
> +		return -EINVAL;
> +	if (vma->vm_flags & VM_EXEC)
> +		return -EPERM;
> +
> +	/* vm_pgoff carries an index (immap_id) to an mtree entry (immap) */
> +	immap = mtree_load(&ictx->mt_mmap, vma->vm_pgoff);
> +	if (!immap)
> +		return -ENXIO;
> +	if (size >> PAGE_SHIFT > immap->pfn_end - immap->pfn_start + 1)
> +		return -ENXIO;
> +
> +	vma->vm_pgoff = 0;
> +	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> +	vm_flags_set(vma, VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP | VM_IO);
> +	return remap_pfn_range(vma, vma->vm_start, immap->pfn_start, size,
> +			       vma->vm_page_prot);
> +}
> +
>  static const struct file_operations iommufd_fops = {
>  	.owner = THIS_MODULE,
>  	.open = iommufd_fops_open,
>  	.release = iommufd_fops_release,
>  	.unlocked_ioctl = iommufd_fops_ioctl,
> +	.mmap = iommufd_fops_mmap,
>  };
>  
>  /**

Thanks,
Praan

> -- 
> 2.43.0
> 
