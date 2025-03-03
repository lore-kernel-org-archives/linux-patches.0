Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D900D1F17E5
	for <patches@lists.linux.dev>; Mon,  3 Mar 2025 15:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741015281; cv=none; b=oeFupzjT6NgV/57oVgUQrPVdPBtpAB0XRFx0wtWeOShk9G64JAAzNUTCtARFqHDsgnXZVTdwLlF154KV8mCWRkmOW1W8dscq/eH7Jk8ZGCu6hYEMei94yFQk5BZO9HECROl5cTTq6/PwILgNoo8ozYaf0kaGOjHGi+Z+sIH9RFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741015281; c=relaxed/simple;
	bh=sVXFpb1vNNztgXcdoJKcrrt5Z9f/aNmySmYPD7wuYto=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=afocpNbWwOE3n1Z/kL68SQpXSXviK/7v/OJbvl7+kS8PuqfrKQLxEV3p0CISfraBI9n9VLFKIzG259uCCEGTE8rCf8V1ecCnmdR9wXnhA2jbmLnhR38nK8mzkRuo6PQiQXXGG0rNZ2g5cc7bHXLXW3+tIjjp4NDcDnPhDRFvCx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=U1Ro5Dkd; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="U1Ro5Dkd"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4394345e4d5so31625755e9.0
        for <patches@lists.linux.dev>; Mon, 03 Mar 2025 07:21:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741015278; x=1741620078; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rqk2BSH8qHpDZaF2t2aMg9t55BaASSSCPMcqYvAYF3s=;
        b=U1Ro5Dkdv8gFIF2sSmoDS+3wW1SS4t/1cMqgjUyOhJtpfT4qfcnqzUHhbDirE1S6sd
         osk7/3pw3FQPlIRs6J7EGAWEgT66CQ3sytE7Y72wG8qe1m/NUtEd9Ht9+cw1ql8edRlv
         XtcJsC/J0hkpwpG+NAcEHhZ6zD0g/ZzVIyEW17eSSn4406s4rCshhiPN7j/Yf4dsHnCa
         S2SfHd6mG9Uqn2g4Dq33JZZVXXRLwl5nTQaGNU21/dwgq8Flx5f51TFz+QUpTQSiWN6z
         ZPqC1YhI91G5qfIDsUPk3f80nIWrEwBTpclrdDtwfjjcZJzP9/GEDk1bDjtPxDEXhmLd
         csGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741015278; x=1741620078;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rqk2BSH8qHpDZaF2t2aMg9t55BaASSSCPMcqYvAYF3s=;
        b=ldfd8pUQdIumMShbzYfUIl8/jYlzDtmQTKJB5RuwKoPqZnqvk1w2gu5dOUNKSntMvE
         eLYXTTW/z6ORC6oIMYNZx3YP0+4ucrlIiPKhundL96+QifMqTaJrpZ2kVGIG0NzxueBI
         D2vix15jYp3A0Xz6Xm+yVmNrNjkEmV0pCrH/HEUrER0gP9yoALfX5h1y89tl90JDFSRo
         d23lC36yb6izQhVzVa8PZ2BCUKq/mtmTMk2/C5M3PCUoVgb2IHUOjfpvPanDaUrkX5lO
         FfADR8K8MoES7AgJZWZj5avKvhE/T2vFWCbQabsXcJtbiPpAFhhXkBzzqSUeiXSNomnV
         W5sg==
X-Forwarded-Encrypted: i=1; AJvYcCUnVrh3zpMDf2CkWpaA+tfmrGaYU502yEPoZtOcmKzjEeUAdl/kCMzJ52UWGbuC516JoJbujryr@lists.linux.dev
X-Gm-Message-State: AOJu0YxXJXzRXvvjuBzIth0HhzK1n18GuH2uQyvSRfOatlwtux9fN6Ek
	Bs932SVeQvsox8sSFlDKvQIT+tYcznqONHNbP4s5uUroNbvWOPc6I5OJwI4XXE4=
X-Gm-Gg: ASbGncsPkmz4ZLjnkXGt2NBRha813bEyiIJjTRgLmc7R5jdkVnoD7H2qOnii8Swfslz
	nNG2HltZ5cQ1St2i5QPUY5sotpC/oa16KWa73MluHwCE7frOqsx6T6pfUNlsOFBA6yFQTpPd+XB
	7O32zIv1CZgGNoxcvL4TzhfnMSd5zhWwQAIJoLU9t6RGumFY7AHkP5AnzsScHyN4SdiNYemkyfT
	5cqaZWiwGXPT0/vdvxKAuz+VVT+Lit7X8vg6mU73mlzuFyTYDN1yLmk1MOrodqg8PzAHWS5Zw0H
	HQxcBYNdwQuRQt2vMc2PAoAp/Fm3vxynHzLg8DzzNEU=
X-Google-Smtp-Source: AGHT+IFcaBMZpOjCK8gQ2QsCdipEfz5tcc2MWFn+tkjIsqIEc3l9Q7yngfldgElId2H3IqVaSJqjZw==
X-Received: by 2002:a05:600c:a581:b0:43b:ba80:4393 with SMTP id 5b1f17b1804b1-43bba80467emr39209465e9.3.1741015278172;
        Mon, 03 Mar 2025 07:21:18 -0800 (PST)
Received: from myrica ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43b694524c6sm169018685e9.0.2025.03.03.07.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Mar 2025 07:21:17 -0800 (PST)
Date: Mon, 3 Mar 2025 15:21:43 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>, virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH v2 3/5] iommu/virtio: Move to domain_alloc_paging()
Message-ID: <20250303152143.GA2083810@myrica>
References: <0-v2-a3b72fd4b99a+1b6-iommu_virtio_domains_jgg@nvidia.com>
 <3-v2-a3b72fd4b99a+1b6-iommu_virtio_domains_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3-v2-a3b72fd4b99a+1b6-iommu_virtio_domains_jgg@nvidia.com>

On Thu, Feb 27, 2025 at 08:20:01PM -0400, Jason Gunthorpe wrote:
> virtio has the complication that it sometimes wants to return a paging
> domain for IDENTITY which makes this conversion a little different than
> other drivers.
> 
> Add a viommu_domain_alloc_paging() that combines viommu_domain_alloc() and
> viommu_domain_finalise() to always return a fully initialized and
> finalized paging domain.
> 
> Use viommu_domain_alloc_identity() to implement the special non-bypass
> IDENTITY flow by calling viommu_domain_alloc_paging() then
> viommu_domain_map_identity().
> 
> Remove support for deferred finalize and the vdomain->mutex.
> 
> Remove core support for domain_alloc() IDENTITY as virtio was the last
> driver using it.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>

And my tests still pass (after fixing the build issue on patch 2)

> ---
>  drivers/iommu/iommu.c        |   6 --
>  drivers/iommu/virtio-iommu.c | 114 ++++++++++++++++-------------------
>  2 files changed, 53 insertions(+), 67 deletions(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index ee33d26dfcd40d..73a05b34de4768 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -1599,12 +1599,6 @@ static struct iommu_domain *__iommu_alloc_identity_domain(struct device *dev)
>  		domain = ops->domain_alloc_identity(dev);
>  		if (IS_ERR(domain))
>  			return domain;
> -	} else if (ops->domain_alloc) {
> -		domain = ops->domain_alloc(IOMMU_DOMAIN_IDENTITY);
> -		if (!domain)
> -			return ERR_PTR(-ENOMEM);
> -		if (IS_ERR(domain))
> -			return domain;
>  	} else {
>  		return ERR_PTR(-EOPNOTSUPP);
>  	}
> diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
> index 2287b89967067d..cdb8034ece9bde 100644
> --- a/drivers/iommu/virtio-iommu.c
> +++ b/drivers/iommu/virtio-iommu.c
> @@ -63,7 +63,6 @@ struct viommu_mapping {
>  struct viommu_domain {
>  	struct iommu_domain		domain;
>  	struct viommu_dev		*viommu;
> -	struct mutex			mutex; /* protects viommu pointer */
>  	unsigned int			id;
>  	u32				map_flags;
>  
> @@ -97,6 +96,8 @@ struct viommu_event {
>  	};
>  };
>  
> +static struct viommu_domain viommu_identity_domain;
> +
>  #define to_viommu_domain(domain)	\
>  	container_of(domain, struct viommu_domain, domain)
>  
> @@ -653,65 +654,45 @@ static void viommu_event_handler(struct virtqueue *vq)
>  
>  /* IOMMU API */
>  
> -static struct iommu_domain *viommu_domain_alloc(unsigned type)
> +static struct iommu_domain *viommu_domain_alloc_paging(struct device *dev)
>  {
> -	struct viommu_domain *vdomain;
> -
> -	if (type != IOMMU_DOMAIN_UNMANAGED &&
> -	    type != IOMMU_DOMAIN_DMA &&
> -	    type != IOMMU_DOMAIN_IDENTITY)
> -		return NULL;
> -
> -	vdomain = kzalloc(sizeof(*vdomain), GFP_KERNEL);
> -	if (!vdomain)
> -		return NULL;
> -
> -	mutex_init(&vdomain->mutex);
> -	spin_lock_init(&vdomain->mappings_lock);
> -	vdomain->mappings = RB_ROOT_CACHED;
> -
> -	return &vdomain->domain;
> -}
> -
> -static int viommu_domain_finalise(struct viommu_endpoint *vdev,
> -				  struct iommu_domain *domain)
> -{
> -	int ret;
> -	unsigned long viommu_page_size;
> +	struct viommu_endpoint *vdev = dev_iommu_priv_get(dev);
>  	struct viommu_dev *viommu = vdev->viommu;
> -	struct viommu_domain *vdomain = to_viommu_domain(domain);
> +	unsigned long viommu_page_size;
> +	struct viommu_domain *vdomain;
> +	int ret;
>  
>  	viommu_page_size = 1UL << __ffs(viommu->pgsize_bitmap);
>  	if (viommu_page_size > PAGE_SIZE) {
>  		dev_err(vdev->dev,
>  			"granule 0x%lx larger than system page size 0x%lx\n",
>  			viommu_page_size, PAGE_SIZE);
> -		return -ENODEV;
> +		return ERR_PTR(-ENODEV);
>  	}
>  
> +	vdomain = kzalloc(sizeof(*vdomain), GFP_KERNEL);
> +	if (!vdomain)
> +		return ERR_PTR(-ENOMEM);
> +
> +	spin_lock_init(&vdomain->mappings_lock);
> +	vdomain->mappings = RB_ROOT_CACHED;
> +
>  	ret = ida_alloc_range(&viommu->domain_ids, viommu->first_domain,
>  			      viommu->last_domain, GFP_KERNEL);
> -	if (ret < 0)
> -		return ret;
> -
> -	vdomain->id		= (unsigned int)ret;
> -
> -	domain->pgsize_bitmap	= viommu->pgsize_bitmap;
> -	domain->geometry	= viommu->geometry;
> -
> -	vdomain->map_flags	= viommu->map_flags;
> -	vdomain->viommu		= viommu;
> -
> -	if (domain->type == IOMMU_DOMAIN_IDENTITY) {
> -		ret = viommu_domain_map_identity(vdev, vdomain);
> -		if (ret) {
> -			ida_free(&viommu->domain_ids, vdomain->id);
> -			vdomain->viommu = NULL;
> -			return ret;
> -		}
> +	if (ret < 0) {
> +		kfree(vdomain);
> +		return ERR_PTR(ret);
>  	}
>  
> -	return 0;
> +	vdomain->id = (unsigned int)ret;
> +
> +	vdomain->domain.pgsize_bitmap = viommu->pgsize_bitmap;
> +	vdomain->domain.geometry = viommu->geometry;
> +
> +	vdomain->map_flags = viommu->map_flags;
> +	vdomain->viommu = viommu;
> +
> +	return &vdomain->domain;
>  }
>  
>  static void viommu_domain_free(struct iommu_domain *domain)
> @@ -727,6 +708,28 @@ static void viommu_domain_free(struct iommu_domain *domain)
>  	kfree(vdomain);
>  }
>  
> +static struct iommu_domain *viommu_domain_alloc_identity(struct device *dev)
> +{
> +	struct viommu_endpoint *vdev = dev_iommu_priv_get(dev);
> +	struct iommu_domain *domain;
> +	int ret;
> +
> +	if (virtio_has_feature(vdev->viommu->vdev,
> +			       VIRTIO_IOMMU_F_BYPASS_CONFIG))
> +		return &viommu_identity_domain.domain;
> +
> +	domain = viommu_domain_alloc_paging(dev);
> +	if (IS_ERR(domain))
> +		return domain;
> +
> +	ret = viommu_domain_map_identity(vdev, to_viommu_domain(domain));
> +	if (ret) {
> +		viommu_domain_free(domain);
> +		return ERR_PTR(ret);
> +	}
> +	return domain;
> +}
> +
>  static int viommu_attach_dev(struct iommu_domain *domain, struct device *dev)
>  {
>  	int ret = 0;
> @@ -734,20 +737,8 @@ static int viommu_attach_dev(struct iommu_domain *domain, struct device *dev)
>  	struct viommu_endpoint *vdev = dev_iommu_priv_get(dev);
>  	struct viommu_domain *vdomain = to_viommu_domain(domain);
>  
> -	mutex_lock(&vdomain->mutex);
> -	if (!vdomain->viommu) {
> -		/*
> -		 * Properly initialize the domain now that we know which viommu
> -		 * owns it.
> -		 */
> -		ret = viommu_domain_finalise(vdev, domain);
> -	} else if (vdomain->viommu != vdev->viommu) {
> -		ret = -EINVAL;
> -	}
> -	mutex_unlock(&vdomain->mutex);
> -
> -	if (ret)
> -		return ret;
> +	if (vdomain->viommu != vdev->viommu)
> +		return -EINVAL;
>  
>  	/*
>  	 * In the virtio-iommu device, when attaching the endpoint to a new
> @@ -1097,7 +1088,8 @@ static bool viommu_capable(struct device *dev, enum iommu_cap cap)
>  
>  static const struct iommu_ops viommu_ops = {
>  	.capable		= viommu_capable,
> -	.domain_alloc		= viommu_domain_alloc,
> +	.domain_alloc_identity	= viommu_domain_alloc_identity,
> +	.domain_alloc_paging	= viommu_domain_alloc_paging,
>  	.probe_device		= viommu_probe_device,
>  	.release_device		= viommu_release_device,
>  	.device_group		= viommu_device_group,
> -- 
> 2.43.0
> 
> 
