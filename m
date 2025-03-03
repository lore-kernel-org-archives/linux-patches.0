Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C8078F44
	for <patches@lists.linux.dev>; Mon,  3 Mar 2025 15:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741015340; cv=none; b=IPZnhWQKSYCFeYk/4zulBwK0Ac5BtOAGl4JVm4JC700SRThrtriy/ajIZPD9Y6VOI+JJFQp7I6qaBzi8hYJMnVUvzThvGouT6Ylo0u38obmR++QX5tRcC0sz39ue2houKrZb/UnGkkbS3FrYGTf3/E4wTBOWFkbehrGDF6TsoPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741015340; c=relaxed/simple;
	bh=KeAOhF/tSRbbUNCZ1cXZMEVaaaHzf0ZSwQV/BU3ATG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=olAVPH/lIEsq/2pZt/mytMvkd+BHYdIwIBxxOTwvFi4Kzx7ZQA9JSZ2OiQtDKO6/UYyB+spzH+O//KZ1tNGxWzKW3cyKdRr2Jny0OTkXV6x7yenPt1gPkSL52/y+zkVS7Qrd6bTqVSUqFMqmND2R4rJCsN+MEKUlUz8LsfMWYH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kAeTMZDO; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kAeTMZDO"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-390df0138beso2441529f8f.0
        for <patches@lists.linux.dev>; Mon, 03 Mar 2025 07:22:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741015337; x=1741620137; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DcZCKiDmcDV+Zl6nxjCvDXnjag3dxzpo0yD3ZrEqp+8=;
        b=kAeTMZDOKQt0VRrL4DwG3ZV3G/7B0v3T2OIoDGpdEbZBOOF3LrrI7qn5k6mv9tn+N0
         14NijCrQ058cGJuqDvnBJA+b8UPNTR/cIMrMckqIf8vesBZ69u9VBCW/kF6h3GRL+h2o
         FRbO0FAdOm5R8iGl57tmxzOLFmIceevu3DIVJevj66rMntsyKCo0ljSoQBSxAFvSdbLc
         mpn3WWy1oh24Yu5+DqOcRjLOrVSFexrRlVaFceSwVXTBvbeoB51n9DzrwKpnRXnDQ+zN
         xH0uNp7kIXQAQgFqEDcgUJTQ9jLzgsSXkOvB7spZomWELNl08j4kHyBOLk8z6jTyoV3V
         TxVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741015337; x=1741620137;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DcZCKiDmcDV+Zl6nxjCvDXnjag3dxzpo0yD3ZrEqp+8=;
        b=g+unLyrpCgA93Z9kAY001hnnP5GsCqE8Q1k1lvDo2Wg3uY4nYOX10RBgJLVJBfcdi3
         kN0nGDf9PKE2rAr586ZRwioUk8UlGWh/wxCNOYqUzKSWcNfAPLmKgBKDcjwG6YQkHF7u
         QUq+4XrqO14g54fXcS98vxlX4HHkn5C1pt6yS4pYNX1O9/CWWD1dCeL26aI8ELOCegBm
         xl3LjMep1MS1HMkZ44VZM1yLanKDKm+2wItQGxvUujcla+XJ4wDGLHX1L4owsV9VJ9Ql
         0cKUjQh5CMp0Ja3hlZ2NQK2OkMJpgnK++RMgsHhwH5lkRQysSyB7/8uoSunNxWD1PF0o
         ZAtA==
X-Forwarded-Encrypted: i=1; AJvYcCWTlbcO9uR9RjCe9usrxh33+zlws7zBN7lJD9NcFT8CleNuJMUNTlCoRQUxWZsPhLrpY+j5Pgp8@lists.linux.dev
X-Gm-Message-State: AOJu0YyOMdWWeNXxE4wgLK7Dc9fJISunUjWwAMPE3wv1FRclN+OxzwIM
	OLcwyCG5xXuuPLE6UWpNwemBAwSOdL9TJbkBH7XtEHdpbiiMBPxvi2Ejq6Y+sVs=
X-Gm-Gg: ASbGncvIJSvMhIguyWKPDnqYu2/ZpFghnaNwGabo+OiG/yetIpoRE0ixSXHGVfjceuY
	z0j0cTf011TB1sUy4DqbidWRQVRa9uySohUd8E51aY5ohZgvKRmCgFX+2OMgHiheigr8bM72I3p
	A+3MQYI3guh6BHx/Izd3UkQU2oy90tnvLkk7aLHeQWLGzEj4a/HxNujyAEw/KqVdWavDPynCKb8
	3O5XFuiUIs6gb5U6Eo6vmTZAC7hXCfozeMlqK8GNm1JVvrmnir/qRX+vGK0zwqYGcdGyS0iWN1g
	SuQj3D3ZuT0EU9sgIm2tmHktMiBDkdQAaGQgxzmYTYg=
X-Google-Smtp-Source: AGHT+IF2RZ18jiutaNwmQgyXw9Sya7CxFe3BwwYu1EQNCljMSVJq5RUCGSWLg0nAeTOJ0v5+o9CEEA==
X-Received: by 2002:a05:6000:280f:b0:390:e84f:c594 with SMTP id ffacd0b85a97d-390eca41cffmr7152457f8f.37.1741015337171;
        Mon, 03 Mar 2025 07:22:17 -0800 (PST)
Received: from myrica ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390e485dcc1sm14481904f8f.87.2025.03.03.07.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Mar 2025 07:22:16 -0800 (PST)
Date: Mon, 3 Mar 2025 15:22:43 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>, virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH v2 1/5] iommu/virtio: Break out bypass identity support
 into a global static
Message-ID: <20250303152243.GB2083810@myrica>
References: <0-v2-a3b72fd4b99a+1b6-iommu_virtio_domains_jgg@nvidia.com>
 <1-v2-a3b72fd4b99a+1b6-iommu_virtio_domains_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1-v2-a3b72fd4b99a+1b6-iommu_virtio_domains_jgg@nvidia.com>

On Thu, Feb 27, 2025 at 08:19:59PM -0400, Jason Gunthorpe wrote:
> To make way for a domain_alloc_paging conversion add the typical global
> static IDENTITY domain. This supports VMMs that have a
> VIRTIO_IOMMU_F_BYPASS_CONFIG config.
> 
> If the VMM does not have support then the domain_alloc path is still used,
> which creates an IDENTITY domain out of a paging domain.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>

> ---
>  drivers/iommu/virtio-iommu.c | 86 ++++++++++++++++++++++++++++--------
>  1 file changed, 67 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
> index b85ce6310ddbda..55a2188197c621 100644
> --- a/drivers/iommu/virtio-iommu.c
> +++ b/drivers/iommu/virtio-iommu.c
> @@ -48,6 +48,7 @@ struct viommu_dev {
>  	u64				pgsize_bitmap;
>  	u32				first_domain;
>  	u32				last_domain;
> +	u32				identity_domain_id;
>  	/* Supported MAP flags */
>  	u32				map_flags;
>  	u32				probe_size;
> @@ -70,7 +71,6 @@ struct viommu_domain {
>  	struct rb_root_cached		mappings;
>  
>  	unsigned long			nr_endpoints;
> -	bool				bypass;
>  };
>  
>  struct viommu_endpoint {
> @@ -305,6 +305,22 @@ static int viommu_send_req_sync(struct viommu_dev *viommu, void *buf,
>  	return ret;
>  }
>  
> +static int viommu_send_attach_req(struct viommu_dev *viommu, struct device *dev,
> +				  struct virtio_iommu_req_attach *req)
> +{
> +	int ret;
> +	unsigned int i;
> +	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
> +
> +	for (i = 0; i < fwspec->num_ids; i++) {
> +		req->endpoint = cpu_to_le32(fwspec->ids[i]);
> +		ret = viommu_send_req_sync(viommu, req, sizeof(*req));
> +		if (ret)
> +			return ret;
> +	}
> +	return 0;
> +}
> +
>  /*
>   * viommu_add_mapping - add a mapping to the internal tree
>   *
> @@ -687,12 +703,6 @@ static int viommu_domain_finalise(struct viommu_endpoint *vdev,
>  	vdomain->viommu		= viommu;
>  
>  	if (domain->type == IOMMU_DOMAIN_IDENTITY) {
> -		if (virtio_has_feature(viommu->vdev,
> -				       VIRTIO_IOMMU_F_BYPASS_CONFIG)) {
> -			vdomain->bypass = true;
> -			return 0;
> -		}
> -
>  		ret = viommu_domain_map_identity(vdev, vdomain);
>  		if (ret) {
>  			ida_free(&viommu->domain_ids, vdomain->id);
> @@ -719,10 +729,8 @@ static void viommu_domain_free(struct iommu_domain *domain)
>  
>  static int viommu_attach_dev(struct iommu_domain *domain, struct device *dev)
>  {
> -	int i;
>  	int ret = 0;
>  	struct virtio_iommu_req_attach req;
> -	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
>  	struct viommu_endpoint *vdev = dev_iommu_priv_get(dev);
>  	struct viommu_domain *vdomain = to_viommu_domain(domain);
>  
> @@ -761,16 +769,9 @@ static int viommu_attach_dev(struct iommu_domain *domain, struct device *dev)
>  		.domain		= cpu_to_le32(vdomain->id),
>  	};
>  
> -	if (vdomain->bypass)
> -		req.flags |= cpu_to_le32(VIRTIO_IOMMU_ATTACH_F_BYPASS);
> -
> -	for (i = 0; i < fwspec->num_ids; i++) {
> -		req.endpoint = cpu_to_le32(fwspec->ids[i]);
> -
> -		ret = viommu_send_req_sync(vdomain->viommu, &req, sizeof(req));
> -		if (ret)
> -			return ret;
> -	}
> +	ret = viommu_send_attach_req(vdomain->viommu, dev, &req);
> +	if (ret)
> +		return ret;
>  
>  	if (!vdomain->nr_endpoints) {
>  		/*
> @@ -788,6 +789,40 @@ static int viommu_attach_dev(struct iommu_domain *domain, struct device *dev)
>  	return 0;
>  }
>  
> +static int viommu_attach_identity_domain(struct iommu_domain *domain,
> +					 struct device *dev)
> +{
> +	int ret = 0;
> +	struct virtio_iommu_req_attach req;
> +	struct viommu_endpoint *vdev = dev_iommu_priv_get(dev);
> +	struct viommu_domain *vdomain = to_viommu_domain(domain);
> +
> +	req = (struct virtio_iommu_req_attach) {
> +		.head.type	= VIRTIO_IOMMU_T_ATTACH,
> +		.domain		= cpu_to_le32(vdev->viommu->identity_domain_id),
> +		.flags          = cpu_to_le32(VIRTIO_IOMMU_ATTACH_F_BYPASS),
> +	};
> +
> +	ret = viommu_send_attach_req(vdev->viommu, dev, &req);
> +	if (ret)
> +		return ret;
> +
> +	if (vdev->vdomain)
> +		vdev->vdomain->nr_endpoints--;
> +	vdomain->nr_endpoints++;
> +	vdev->vdomain = vdomain;
> +	return 0;
> +}
> +
> +static struct viommu_domain viommu_identity_domain = {
> +	.domain = {
> +		.type = IOMMU_DOMAIN_IDENTITY,
> +		.ops = &(const struct iommu_domain_ops) {
> +			.attach_dev = viommu_attach_identity_domain,
> +		},
> +	},
> +};
> +
>  static void viommu_detach_dev(struct viommu_endpoint *vdev)
>  {
>  	int i;
> @@ -1061,6 +1096,7 @@ static bool viommu_capable(struct device *dev, enum iommu_cap cap)
>  }
>  
>  static struct iommu_ops viommu_ops = {
> +	.identity_domain	= &viommu_identity_domain.domain,
>  	.capable		= viommu_capable,
>  	.domain_alloc		= viommu_domain_alloc,
>  	.probe_device		= viommu_probe_device,
> @@ -1184,6 +1220,18 @@ static int viommu_probe(struct virtio_device *vdev)
>  	if (virtio_has_feature(vdev, VIRTIO_IOMMU_F_MMIO))
>  		viommu->map_flags |= VIRTIO_IOMMU_MAP_F_MMIO;
>  
> +	/* Reserve an ID to use as the bypass domain */
> +	if (virtio_has_feature(viommu->vdev, VIRTIO_IOMMU_F_BYPASS_CONFIG)) {
> +		viommu->identity_domain_id = viommu->first_domain;
> +		viommu->first_domain++;
> +	} else {
> +		/*
> +		 * Assume the VMM is sensible and it either supports bypass on
> +		 * all instances or no instances.
> +		 */
> +		viommu_ops.identity_domain = NULL;
> +	}
> +
>  	viommu_ops.pgsize_bitmap = viommu->pgsize_bitmap;
>  
>  	virtio_device_ready(vdev);
> -- 
> 2.43.0
> 
> 
