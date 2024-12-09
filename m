Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B65421364
	for <patches@lists.linux.dev>; Mon,  9 Dec 2024 18:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733769122; cv=none; b=Qy5GVZDKQZqgsywxu6v+QHj4BArQdvxTYzoJ/SsXbkds/VRA9tile2SdFIV9/XQLPgNKHG/oDdTiWQOSr3ROptfxKk9GTSathEOMirucdohNSR3zM1QMad1SWlIrNbNeLZY/ZML4XiZEgGXE1mnMse3VQUAt8HX5z/a8Fo82dDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733769122; c=relaxed/simple;
	bh=Nfz9raYey/M397MrbNec+MnVN2czs4w1vB21GrOle6Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=QSBMaW6Q7o8BVrE9ZzYnimYLNRfM0NeWX5s+H9I/GvZs/Zi0rxEsALKU95irlhL5dT18UEAbTs7axbOz9iRPa+PgDWRP2mmEoRdYmdQfbChD/yygRbY1EvxZSlGUhz4g/r73i94Dk3xSwUZNK/qCk/f/dzgObPKwqqMfSdQ3Sbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AfPdxmdw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AfPdxmdw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733769119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s0pY765j5ehy1Z2Ke7p4xF1e0nHxYzj+nGUqdqssuX0=;
	b=AfPdxmdwDgpSLBn4lhvW1G0ldbWpolf3ADc4eOiU2NEVPirOouJJvoCxo4974vzenrn6BL
	+voc8/wJRGyEITGJC1dnFqByuB7Dtc6guwff2SpL0AeGKOxEm7O682sR/9tX+LeCu1VQE4
	qAw/MedxfsHO/zREhxvLblrYgeCU8KM=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-4-1eoTCsMRmgUVgKkwVnFg-1; Mon, 09 Dec 2024 13:31:58 -0500
X-MC-Unique: 4-1eoTCsMRmgUVgKkwVnFg-1
X-Mimecast-MFC-AGG-ID: 4-1eoTCsMRmgUVgKkwVnFg
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6d88c987fc7so73565396d6.3
        for <patches@lists.linux.dev>; Mon, 09 Dec 2024 10:31:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733769117; x=1734373917;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s0pY765j5ehy1Z2Ke7p4xF1e0nHxYzj+nGUqdqssuX0=;
        b=aZRYpL/ZK5q0p74HzvIJjj6r1RN/e5wRSit3rKC7onNRoiLmqPDBxXHelzNcWThc/P
         9ZYXvgbPNbj8wzyjgPiL4LidzGCWxNgGWXHUJAgB8LvO5SCq1ucK56eUehUHBQMWFR8Y
         +fq2T9ZJYDgqrBD4rKI5ruEYdZx7iDY0bLZ4Npq2o9pDe5KQKb0qz5m272zPFOra+pkw
         IyOym1utyM8C5U+JeMmvZn/IZehYVCfX8JZOuOceEgQNpwCYzmipH1XHMvpkManga7tX
         X6jCQT+kx6hfX6ZnagOrvfbvUYS4z/WC+LBTnw9+Cw8aqxL2Nm8qjVKsH7vc0j8SY504
         nvCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZ4W6oJMeaZvoiZcCh3Dg8zrWCpXpK6oTFVfqFFjkG+cE2RbF8AxoNDQISQGPTYViisn3BINwW@lists.linux.dev
X-Gm-Message-State: AOJu0YzhDIDoCPdp9PttMb85podMT/va0I/wmCekMq3GXRmpIGCnpbZR
	v6N4mJXrnjSCjB7RArsEtsNDyPwIiNb1KVvvG4kp80W3Spfqb+nrVSlDRSTuN32w+c2Z9GosFDh
	IQ4TC6WjQ9C0XOzQGmzvFdb8gRrgfA7ECl89o/Zg5FgtTt0ecUKCWTjU=
X-Gm-Gg: ASbGnctAh+EdYmkJmkycQ3DsDF7y/2b2EsECvciGruq9nHGjjfm7xhWmjOTedB3Xwfg
	vIo8s+4sh7sF2OLaVdX5600cfEF1p0fsEsbXQj2F0EEFQwxgH6zR8TosYg0ArqS9RSCksBALx5S
	vmNG3qYs7h5B4k4xy3h9y6+8fevrtfyRAdi1d/r9jdGmyNK4fy2NvyB9tPTN7oKevXO0lLCwvbo
	/qR7Zsdnci8JCLXMs7EW1nkaeCvapaarAvgnDOLy2fioADSK1STGEDzHANdYKFNJLapdMwr92i4
X-Received: by 2002:ad4:5ae2:0:b0:6d4:287d:b8d6 with SMTP id 6a1803df08f44-6d8e70d5e28mr297131666d6.18.1733769117718;
        Mon, 09 Dec 2024 10:31:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEKJblYHP5q2pIDOUn6eT6/NeUfap9kBzGaLS8smRgro3ONIGkFqmWmTdriNB4IZZFFqqyzDg==
X-Received: by 2002:ad4:5ae2:0:b0:6d4:287d:b8d6 with SMTP id 6a1803df08f44-6d8e70d5e28mr297131466d6.18.1733769117458;
        Mon, 09 Dec 2024 10:31:57 -0800 (PST)
Received: from localhost (ip98-179-76-110.ph.ph.cox.net. [98.179.76.110])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d8da675214sm51471676d6.11.2024.12.09.10.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2024 10:31:56 -0800 (PST)
Date: Mon, 9 Dec 2024 11:31:55 -0700
From: Jerry Snitselaar <jsnitsel@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>, 
	David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>, patches@lists.linux.dev
Subject: Re: [PATCH] iommu/vt-d: Remove domain_alloc_paging()
Message-ID: <yfbshn4muaytd7nt3o74xguxxi6sncgv7yrocbnal5m4kzixsn@kqgx3ez4s2cp>
References: <0-v1-b101d00c5ee5+17645-vtd_paging_flags_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <0-v1-b101d00c5ee5+17645-vtd_paging_flags_jgg@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QR1KaCfBvx_94dhQqp2-BRVoPZ9D2VeUFOCYMcP-S0Q_1733769117
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 04, 2024 at 04:14:58PM -0400, Jason Gunthorpe wrote:
> This is duplicated by intel_iommu_domain_alloc_paging_flags(), just remove
> it.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/intel/iommu.c | 16 ----------------
>  1 file changed, 16 deletions(-)
> 
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 7d0acb74d5a543..88e4e867012cba 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -4443,21 +4443,6 @@ static struct iommu_domain identity_domain = {
>  	},
>  };
>  
> -static struct iommu_domain *intel_iommu_domain_alloc_paging(struct device *dev)
> -{
> -	struct device_domain_info *info = dev_iommu_priv_get(dev);
> -	struct intel_iommu *iommu = info->iommu;
> -	struct dmar_domain *dmar_domain;
> -	bool first_stage;
> -
> -	first_stage = first_level_by_default(iommu);
> -	dmar_domain = paging_domain_alloc(dev, first_stage);
> -	if (IS_ERR(dmar_domain))
> -		return ERR_CAST(dmar_domain);
> -
> -	return &dmar_domain->domain;
> -}
> -
>  const struct iommu_ops intel_iommu_ops = {
>  	.blocked_domain		= &blocking_domain,
>  	.release_domain		= &blocking_domain,
> @@ -4466,7 +4451,6 @@ const struct iommu_ops intel_iommu_ops = {
>  	.hw_info		= intel_iommu_hw_info,
>  	.domain_alloc_paging_flags = intel_iommu_domain_alloc_paging_flags,
>  	.domain_alloc_sva	= intel_svm_domain_alloc,
> -	.domain_alloc_paging	= intel_iommu_domain_alloc_paging,
>  	.domain_alloc_nested	= intel_iommu_domain_alloc_nested,
>  	.probe_device		= intel_iommu_probe_device,
>  	.release_device		= intel_iommu_release_device,
> 
> base-commit: f6ba64bc6669cb5152a31a474734308dcccb3ed8
> -- 
> 2.43.0
> 

Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>

