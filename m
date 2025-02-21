Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016D420010A
	for <patches@lists.linux.dev>; Fri, 21 Feb 2025 11:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740137706; cv=none; b=kkjirDm660cKT9qeVtb2xSr0vaShSLG38MAajxMSalbdvxKn9bwkKAX6auptqS8W+bceT3zlmNVig9afluhIzD2gRGhe60Om1D2W+wqpjXMxxGZVSx7w6sA75CMXDphJQs+8SoEWfVJuurQlx2wz4oVDYfA6kDoOXU2YhAKdENs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740137706; c=relaxed/simple;
	bh=5JO7MAU2pNeHSO0R7VF3GsD5XvtNiBXra9ry7n54Zr0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GS5C/4c20WkpEhzjaPiLk2oXHqRpWvrSc1Q/nPIj6xHFm7oifVr4w+6/3QZqdmN0fg352ii1knmskQP77DONxqtkBpIGsQiPFkwkGMlh2iWtqXOL/0dVr1G3wV8h9L1hJq3xIQjLuYJKYLUAH1CyR6Btxq1P6uNOdnP+Tl3jzyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lPR7Dg85; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lPR7Dg85"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-439946a49e1so12658505e9.0
        for <patches@lists.linux.dev>; Fri, 21 Feb 2025 03:35:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1740137702; x=1740742502; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y3hcxNqTV9LVIYXXbWCIdDjS+CvuYnmWv2VTJipyhvM=;
        b=lPR7Dg85lB0OLZrXtu+jlsZXhcWeTvWjCdwg0jGQ3hdnI3uRrP0CkavB9YIh9ulxcn
         NHKbJ+v6tpLNalgtjACyraM9gew2pDUTDZ1soPb7eASG/xyqkUpRbyzoB0guUqu/Uxq0
         8TOOqG+IZ2rTj4MdbhxWk12MUwe8Mw89tumQDjxZoSFozH7Iu73RvuIA74Up1EHYdN4A
         kxgV2C/aEkWD4yxVLbEPo5vib7RwjlSkVYn327CSxVBjaG23cms4+PAa/imqvus7eu5G
         syahExbfsrqdEq+p1tHcExS7iJuv4GLWG0m3C3W2yWtwgtajEd3eEwkpPLjxyOyTwnyp
         j9wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740137702; x=1740742502;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y3hcxNqTV9LVIYXXbWCIdDjS+CvuYnmWv2VTJipyhvM=;
        b=sKbdv1QkDOn7q6vRQlcdqxGmaSWhMt2P4PQIHqwfjXNKSbLvbR+E5QFexrpFbY36Ap
         I+uXetc0QncxvxZJMkgdka3wwkNYZbvWVcEADCPUZfASfjEv84P101PiYNEjRua6w8oN
         xy7IT2QmfpPwL+vTGj1+k3+DGlmOcMY6iZZBZ7zIuYdmJjGof+VCo7RKtY6SVGFHCvIH
         vjRlUliFOdCNkMoCWWQ4KNEEUUlao6T/s7qQEalw/XWVxecSZ2FxJfEXG1ISUJG+4iGe
         vpqBNQetW/rhBy5Wfks237laKJQnP9hp5COxLdYVeSpJC4g5XUis7LlqyGmivzBlF3eO
         I2Mg==
X-Forwarded-Encrypted: i=1; AJvYcCXl98YeMwmkRPv4JVrW09/aigHz/kB6GKPM4UOUE54TcicJlTFh+Pay6FzSLoGsF806+qxbJ+XA@lists.linux.dev
X-Gm-Message-State: AOJu0YyOL7pEyZDxBn4EK+8wCj2VEe+yJoDcMgvNPsbZuzGgrZRUMrHn
	MZmFH8BvOcf/Sa47yF6SNpXDkZWVAdvBtAlrLu07f5MQSfn4rdIDvQP+MhbXB+o=
X-Gm-Gg: ASbGncuLIc+b07OzIsmCXwZ1ZPPk9OGhqtZ8EdCWO/smFBoY1+y+kevd74rOHuqPJZR
	X0JANPpCpcP+UsvpRdCaOEquCcPygdYtxXtxuERqE39r43PsRqE6QHSECldFDGPugsJ91//e2EH
	N7+hxqPcIf71CGzj4p81LpgCOi9RSq2cUPRLsSjbL+kbA5ptA+QcdykwEQGYsnqGLjol344h9C3
	/04nDnTe9w+juA/PZ03H2Mw9sVuvzjGj48+cmu30Y3mLN9dtk9nISta5Vz4YPDqL5pPy49iXqln
	UmRrDYPPafCf2LpUg5g9mTHF
X-Google-Smtp-Source: AGHT+IFxvYtlAjXtBQ2UW7OEyJ/vTf6nWVmNgpDNCzqY7J4jHXDBefIwgjYoeK3O/AT6rlCvE4nfqg==
X-Received: by 2002:a05:600c:19cc:b0:439:5766:7232 with SMTP id 5b1f17b1804b1-439ae212996mr21449415e9.21.1740137702192;
        Fri, 21 Feb 2025 03:35:02 -0800 (PST)
Received: from myrica ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-439b02d854csm14508535e9.15.2025.02.21.03.35.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2025 03:35:01 -0800 (PST)
Date: Fri, 21 Feb 2025 11:35:27 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>, virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH 1/5] iommu/virtio: Break out bypass identity support into
 a global static
Message-ID: <20250221113527.GA719702@myrica>
References: <0-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
 <1-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>

On Fri, Feb 07, 2025 at 10:46:01AM -0400, Jason Gunthorpe wrote:
> To make way for a domain_alloc_paging conversion add the typical global
> static IDENTITY domain. This supports VMMs that have a
> VIRTIO_IOMMU_F_BYPASS_CONFIG config.
> 
> If the VMM does not have support then the domain_alloc path is still used,
> which creates an IDENTITY domain out of a paging domain.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/virtio-iommu.c | 86 ++++++++++++++++++++++++++++--------
>  1 file changed, 67 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
> index b85ce6310ddbda..c71a996760bddb 100644
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
> +	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
> +	int ret;
> +	int i;
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
> +	if (vdev->vdomain) {
> +		vdev->vdomain->nr_endpoints--;
> +		vdomain->nr_endpoints++;
> +		vdev->vdomain = vdomain;

These two need to be unconditional

> +	}
> +	return 0;
> +}
> +
> +static struct viommu_domain viommu_identity_domain = {
> +	.domain = { .type = IOMMU_DOMAIN_IDENTITY,
> +		    .ops =
> +			    &(const struct iommu_domain_ops){
> +				    .attach_dev = viommu_attach_identity_domain,
> +			    } }
> +};

nit: how about

	static struct viommu_domain viommu_identity_domain = {
		.domain = {
			.type = IOMMU_DOMAIN_IDENTITY,
			.ops = &(const struct iommu_domain_ops) {
				.attach_dev = viommu_attach_identity_domain,
			},
		},
	};

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

Maybe also a WARN_ON(!viommu_ops.identity_domain) above?

Thanks,
Jean



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
