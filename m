Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED73F29ACC5
	for <patches@lists.linux.dev>; Mon,  3 Nov 2025 07:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762155124; cv=none; b=oDSHYmbDDxENMRWu2QrAYQXqPJskMLirBFw0Ox1VFizirD+rVQ3kL6omyz9lcjlG5c1B49H+fYclkYZUkEf/VyThPVcsiQD8i5FleQyZUL9pZwjd6oOiij32bqBbnb8WETu95xdLtzAdqW/XnKEGSPHsf4s610rem/Ov+qdGNfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762155124; c=relaxed/simple;
	bh=I7HDUIQg/KdqyDmPQ+qrxG240GLYIT2LqIXpnIqKcNE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QVIFTMls4UwjSiTj++tQAM3ZzLwdaYWABhBJ+jD8Y3iT+2O+8np8ATgvR/mYnyJh+axPgyrAttnyJuuDMnsVHrD5mPQrVhI62eq9pVSx3b4n2sXnb2jcyjmTrthhl4f3l1/hr9f1IRGbg6cRVtkDig45zmI1N+KidMz2G6Ia2pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HKjEJdf2; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HKjEJdf2"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-294f3105435so342325ad.1
        for <patches@lists.linux.dev>; Sun, 02 Nov 2025 23:32:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762155122; x=1762759922; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dADjXQcJVAcOBFwaI/JeQVroSWZH3kzmeM+gasunsjY=;
        b=HKjEJdf2Hp2y+pT3Ro9uUuW2bFRbUbU4O6TKvsdQgnY/ryzt/oteOEE87lyUtSzkvC
         K5FpBq52vglAAX1RB4F70jHQH0Lg+b49aPD9ag1gD6DmXPaoYF9vlT83qXkrl50Q4v0l
         8vhwBWuvnM0rcVNbANmfgsgrEIRG4q3OmudLi3QyP83kVZVNsEgZjFl2/3hTg1EaKK67
         Rj2b+qCJHb4SUzrLz/qQgXsYYUIR2O5haNAEdp+GS4ZD/B5yLT/U/HUKZtW8AmYpJKTw
         6AZFbnL1x6tkclj3TfJtl2ueefdsE6kvxqle/E9DvoOAunMxkl5/vvO6bJb61Kzi/zCw
         /h6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762155122; x=1762759922;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dADjXQcJVAcOBFwaI/JeQVroSWZH3kzmeM+gasunsjY=;
        b=JdbsTQgkBijIy0Cu1PvxoVgn2VieN+jKwNcwTzk0zD92Drpk5315Ejunej5Ks5zPch
         ljVYMZmGeBOo3kHRxZBPvJ+PfYxGRH97m49SpAZwtikKp8wp3+WttCytYMdz6Srwnvh4
         lwsugjlopEjZ7tTg9gMTl9fsD2HRWXK+0M3ki5QNE1+nlbA+1yuNdLDNNGIwGCvZljzj
         UaMdOjyCUr7mIx0yIXLLX3GOnzk2dX1J5Ua/51W52d/mGj0NlL2NSnxUB3SEV2F/Hc8W
         XKdJn/fHTAYMgyTncX5HiwyAgix1bDHNZ42ChJf/Ub/vJzFtwaLl+u4VrroZwIdLLHgW
         woCQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6fFPDo9FoL+FCSBzDjvE7uwD9GwpwcQ2T2w4xQaoC+F8Bb1YZEQ20MQza4IJKvC0Nv75aPIDM@lists.linux.dev
X-Gm-Message-State: AOJu0Yywi37eLLQ9WaUAE4PqMWe0rmnlcIVQzEIfUR2k/Wx44YP9veyu
	1DgJvxKwwEYP6Nkv6ZAdUqiojQlrYL5rLRYbZ79nWyY+wFJUeyuHfEYNZozmwsqWMQ==
X-Gm-Gg: ASbGncsQRtbl+dceKy4l1B3/eBTQNqRC3edMPRRn6YxY035Udyr3LG+bqzKo/oI7xmv
	AmS0YzistORllWn2k/xxbxca1PTAxds4eRrJS6e1KLSXqdQcc13YzA7fWPtY87BBhmNfMbFwcH9
	tbtCK+NuubNxVOSNsXzE2hmNSq3OqWVOr6QfYLQD9OI7NHsZZpq1mEcu+Iy3wKFTXk9TLODUGwq
	mMYLi9rA1wFufb5E9YsA7zwkpIov0zxowA9trz3McAPwMljg2Bv5xnpdauAEKtNWzWFoKBJdusN
	YHk4tvJdonWlmiUnAkFcd7ykL7ANb1I4sr0Tx6JaVWbP1Lw7pu01mNVru1kOOKerIfhkqkRikBH
	HhJRHnoqGpSzkYep/4LYVzAdx5uouwNufCkhXD7h3+cty2hJTOaTMXuv+YMXsjS2hImP4R84H0g
	Jd4pLuu7vMbzCEMhxyZfnDgx/+qB1h7EIgV0WsdQ==
X-Google-Smtp-Source: AGHT+IHfrP3JzShs73f4Ou9j74BKdOau8otZ+u7WUYTtBZ6PInXsEFYOD9H0FiQHWOz2YtGspU3bog==
X-Received: by 2002:a17:902:ec8e:b0:274:1a09:9553 with SMTP id d9443c01a7336-29554bb5d5cmr6804875ad.6.1762155121865;
        Sun, 02 Nov 2025 23:32:01 -0800 (PST)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-295512dedabsm82398675ad.5.2025.11.02.23.31.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 23:32:01 -0800 (PST)
Date: Mon, 3 Nov 2025 07:31:51 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
	David Airlie <airlied@gmail.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Brett Creeley <brett.creeley@amd.com>,
	dri-devel@lists.freedesktop.org, Eric Auger <eric.auger@redhat.com>,
	Eric Farman <farman@linux.ibm.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>, intel-gfx@lists.freedesktop.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Kirti Wankhede <kwankhede@nvidia.com>, linux-s390@vger.kernel.org,
	Longfang Liu <liulongfang@huawei.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Nikhil Agarwal <nikhil.agarwal@amd.com>,
	Nipun Gupta <nipun.gupta@amd.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>, qat-linux@intel.com,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Simona Vetter <simona@ffwll.ch>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Mostafa Saleh <smostafa@google.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	virtualization@lists.linux.dev,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Zhenyu Wang <zhenyuw.linux@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>, patches@lists.linux.dev
Subject: Re: [PATCH 11/22] vfio/cdx: Provide a get_region_info op
Message-ID: <aQhaZ2HvTTtanNdu@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <11-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>

On Thu, Oct 23, 2025 at 08:09:25PM -0300, Jason Gunthorpe wrote:
> Change the signature of vfio_cdx_ioctl_get_region_info() and hook it to
> the op.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/cdx/main.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan
