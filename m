Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1F42C159F
	for <patches@lists.linux.dev>; Mon,  3 Nov 2025 07:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762155590; cv=none; b=GGs54h2ygDWi9U2Ig8zv+DDQJvMPZGCnf5bMInkOxVJm10oG/HGY6kzfpkXLdwKfjo7REoEg6lvi3hB4q7Y1104Bq2FZeFyhMFc5lSY/ihUiACwYQS3h9zT43d4PS0o026q/SWCheKujz+0QnHlOJ5hZF7DLxBPSJO+sWbpyqCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762155590; c=relaxed/simple;
	bh=30R4PwwoDn0ue1N2GS0GOY1SWIFA7GBPa8q4kx5mc+o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HSIVNg8trAbnLZBkC9qVkO6+qQjjq50rDX2IpJi98KONlJoMF4Ir6rNL4lISMIItSH8jEs1xITXh9ScszPoytpr0CENlV7coI4vGk7UZEvk5pm1z9scOe60LsRQgFAr04dTdPtTQfOagZRIVlpEwkvJ2pfE3ngMuGnsSXIcQzPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BjRsGULq; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BjRsGULq"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-295c64cb951so89495ad.0
        for <patches@lists.linux.dev>; Sun, 02 Nov 2025 23:39:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762155588; x=1762760388; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zzwh3KfEQpKPksD5Xn4ZAd8EEqdDZL8lWisUmSvX4T0=;
        b=BjRsGULq7DgerW7LBG4GUfrwkuPLwnyBpFI6ejm2GJcDVZVK6Cj4rg+t1oE+QAhJne
         clpio00o/XqQbT3h40xsHwjGh6k9f6fkvdFnhjwSmp1SebPwoBG4Mwi8Aw2uz6U/eYKH
         UToQUsLAwrKVSy/YEu43ryGVzFdbu71tJ2C2dAmLGN644hBIMbh4oPwfsc48hBfTZR0l
         7ftYbk8Ta0I100LnOMZJ4pU2smuzLHgm76CCEGf+MJF+HTsMp4xezIX8c22bO+QAKLhz
         3MzNFDIpmF/Kjn956Xzq7DFKGik6H39ouI8jCEY+oPH8WmUCKC2xzCunGvPiz/7RLyII
         CAJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762155588; x=1762760388;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zzwh3KfEQpKPksD5Xn4ZAd8EEqdDZL8lWisUmSvX4T0=;
        b=N15aAxWOKRCDIp7vLBoN/vIp+6FQUBLaShtExxvjm+hn25o3b2tnhB2sPTQ1HsENhz
         k0gpuwxwas0u1WRAruEUZ3dw8s0eG7jKqkQarXHei1PVQ1xd28PmxsfGZ7staxUgIZ+Y
         Zt8TXm3XPl5HwwlzQoeqEO8Zkxa657SbMocuIp+pTm34ZQMS6zGHyuMSEzEx47lQfZ8M
         bzskY4wJcCDsBjfuSS56UP0TPAfA0dLgz++G2f1E/ddU6baLHyQp06S5YVwsRV1mGW6q
         Te8j8/A2HGKh/ifueun2GKLAz/fwOUhKf//w4N8DNz07iPVAH72THzZJvuuaozxed8o7
         s7oA==
X-Forwarded-Encrypted: i=1; AJvYcCWKuZVW/IdM9JY1Z51qiCgcYrh09BCjjg3invqqwHjCSiQnIy4GbbjdiBoidc1oxpG8AzPro093@lists.linux.dev
X-Gm-Message-State: AOJu0YyI+2ECBYXf3p3xVzJXTVazRm4vdz/Biy5A4cMQG9n4qosGTvaM
	lj7QnbBjPSo/LxuAcW+Kt1vobirzbygjKEbG0eOqpCCUiYTFxqrAj0XTaEBeqrb61A==
X-Gm-Gg: ASbGncsd/AH+OHkGAfQzvplCkNM0EanmHGdMVFVehx10awofvI6ZeSPG+apLVANwNSJ
	/D8S+dJ24OPekB/jzABq+WU7SwbV3mKT0ZV64ZCLPbvGlvryp2Y++VYHPhjzU+eCU2Q6g82lalW
	QfLFMMwVpjoGnZ8VhpAgEqaBuKRA/5IJP+WPSNoGZgT2EEFy+1aLCVYy/4qtxKc2xxJIcANB9bB
	SZaDFH6CX2Nk6Wo0YVe1HcqsNQdqTblCV+u0C9ow8WeQHiROJ/BVaxfKUBbYiGB6hMH2bgEUzWc
	xt3CMq49/FbMYgkFdnHEwsAjsYdfEw3HPdJk2A8+CQZW/1t/7+l5IpQP3aaD0wC7hE6ClVSrsd2
	1hlQDXS8HrL0OORFPr9/sgSvxYzAuaJkFGG6kMEPywQLBRJXwgVMIEIhJCTpFgQrr3nGe1t2Tpo
	yLzLCNYtHN/V3W3uzLX4KPdKomk7+tldfq3t08qs7+OQNCvxMR
X-Google-Smtp-Source: AGHT+IGoX/eRPHIgiRFzzACV20d0ftHJvRprPrWC1Oq8kyrn4muK0Mu+0fpj1flmH53tBH91iPLzGw==
X-Received: by 2002:a17:902:ea0d:b0:24b:1741:1a4c with SMTP id d9443c01a7336-295549f6bcbmr6601575ad.0.1762155587782;
        Sun, 02 Nov 2025 23:39:47 -0800 (PST)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2952e9a399csm102714425ad.33.2025.11.02.23.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 23:39:47 -0800 (PST)
Date: Mon, 3 Nov 2025 07:39:37 +0000
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
Subject: Re: [PATCH 14/22] vfio: Require drivers to implement get_region_info
Message-ID: <aQhcOYVbY-LqOjW5@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <14-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>

On Thu, Oct 23, 2025 at 08:09:28PM -0300, Jason Gunthorpe wrote:
> Remove the fallback through the ioctl callback, no drivers use this now.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio_main.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index a390163ce706c4..f056e82ba35075 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1297,13 +1297,13 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
>  		break;
>  
>  	case VFIO_DEVICE_GET_REGION_INFO:
> -		if (!device->ops->get_region_info)
> -			goto ioctl_fallback;
> -		ret = device->ops->get_region_info(device, uptr);
> +		if (unlikely(!device->ops->get_region_info))
> +			ret = -EINVAL;

Nit: Let's also add a warn/err log here highliting that the device
doesn't populate the get_region_info op?

> +		else
> +			ret = device->ops->get_region_info(device, uptr);
>  		break;
>  
>  	default:
> -ioctl_fallback:
>  		if (unlikely(!device->ops->ioctl))
>  			ret = -EINVAL;
>  		else

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan
