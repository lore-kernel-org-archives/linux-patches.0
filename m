Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2053A2F9DBB
	for <patches@lists.linux.dev>; Mon,  3 Nov 2025 09:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762163863; cv=none; b=n2z3DH6hr4YsSqnGcexs3SllCqXhUh//TZDju0fJkR+trC0ffQZpi8MXq6sBZFNguxjlZYwOoWm5mvMekvqAnSTLJvQp66P7O/U5lYzI8GEuCTDPjfHM3ZU1F5TeGDWD93akAIVEVMmWFIaMakR9wMC8yoy+0/VkGyohq2cn0g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762163863; c=relaxed/simple;
	bh=j9P0kJvHthnqO2tx4rHoHS+OgDbwMwn9qSk75uLg2Os=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S92MDliFQvLx11eyuOFSR9n8+rLWoaWe4O6osDIDDu9dfTdfNXXiy98KcqBlv7rpdNDJyHGG2A71McOVUBrUkg4yUUfo87nG2n0p9sFV9OL3SDi6FQnoNByAsoDIHrEd93jmdV2lsLnWDRb4tAljbgBFZqtofcdFP+1JVjbbPRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hl0PRJVG; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hl0PRJVG"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-470ff2f6e56so81385e9.0
        for <patches@lists.linux.dev>; Mon, 03 Nov 2025 01:57:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762163860; x=1762768660; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4Gxg1uZruJtA4YMzZuNynPGAWW8m9xdZihRPr7yINg8=;
        b=hl0PRJVG9x81hjm8Gt+uhetHOzDn5fQA0mEL4bReEF0w1jkYQinMrRAUOIhIQMgeB7
         PnotclyKkeWURt1VPWDoKt5l6oVbDbQxxG2Jywb1QaZWI6fX7UraqQM/2i8IOg7VYt3G
         cGW8hIhaP3/kducNQQLooHWYuFlpeALPxp+l7CsPHY4gVl2G4ZbSbw7ybN0kicV/HbCH
         VImnW5USCuFFIbtVCtQN//6gsULeivL/mA3ZDDxG99h7B7q0Mw8gqGtIjH+71cgJoWJk
         0URFRrcfqu2HVw8U/09qiXFJhey5E77wIWn1LPU6u33R8/2e20XAHKXNJn5ULxOFbFNW
         pJ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762163860; x=1762768660;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Gxg1uZruJtA4YMzZuNynPGAWW8m9xdZihRPr7yINg8=;
        b=DOPOWiB3VKXGsuRZhrdtKkc28okPvCjyuEj6UimwhjzEsYfCFRs0tI/a/6TvkZZJOY
         oXQm7sNC0s1SpdeEUrW+Xj47qd1bPiSByrb0nXxnW8BcI3FP6WQjHS7RQzKpmvlCsU4A
         GIMIrOQFP242YHAfhlTczs/vc+MJg+AyPJFBpxYH4KR78K0A8pYhUpDyucEsdAvKo+Tf
         2XgVUjhT6KK2PW+Fd1tupXnWhUdncmo/jCc1cg6U0ZGB4pMsk4hgAJ7xXR2q/cr2xKvI
         pw0kpAURNpwfXHQPPQUMPVDzTsGTsRxlb8vOZCr86wAQKOQR/pNjX98stoVfUCNy+iG0
         HlwQ==
X-Forwarded-Encrypted: i=1; AJvYcCU7Cuuj3fUUAg/eFpoQGhSlsu7eimWeQqgWDtscuMff2UOn+6chs5KU7mKFgkAqnpRKwgnqcpnj@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/F+Du93Gt7CxEM4u+DToCCuztCejagknCk0ak0TopHUfkKMUb
	iLLtirylmzmUrLQQ09949OrkkVy5sjIf6PYLfcw6FEqt5eif5vJxeyu7JS8bQcXXaQ==
X-Gm-Gg: ASbGncsWP40ufyAFbeJoRyLkz4tUbK9yKpA3DAAcgw9DRUFh9mUsuA8KCIz1Q2/87p4
	5wsn37KdfvE/1nuHfcHBTNYuoTZG0Ps5tf7bxDs91bHXR215Is6psB+9I37x8ypux/Gp0bVN+kV
	NfyNGpm3oSWOpxUKIDdJCJHwGpa4IO+Jgj0XP9mDH/dX259mjn47Q/xXlPu8OEZ6E7/I9dX1VCN
	m48a7atUyrdJuxNsTM4Q5CxZqTXp6q8qLGJ2j0SeRaC+5MGzur2XcfcSQg8+8fuDKKPWYBvMXME
	Pklv2aMjwE6ARyHXwc7jNUhmNAOljqdRK2xf9vtcIIHsIbhpu2WraFw1OrfkgK206IErMfQuz2H
	OplQhVGltHMH7FcJik9TGsjuG+CitDJ/0KBRoshXI5nC8KyXqElig9uTiLtxBRx0XQ0S2PF9Gie
	lNHLBC8NSAVgwJucpwVS0uOaKnwjMWDanQiv60XruNZE1tMTSCKA==
X-Google-Smtp-Source: AGHT+IGLdHq84lPWuC9+6LJzgqfOJA4DO6nS6TVGXk5Ftt4X8sQj+LIHdpfQT0AOQR/zxEXR5CFwjw==
X-Received: by 2002:a05:600c:8711:b0:45f:2940:d194 with SMTP id 5b1f17b1804b1-4773cdce892mr7234625e9.2.1762163860205;
        Mon, 03 Nov 2025 01:57:40 -0800 (PST)
Received: from google.com (54.140.140.34.bc.googleusercontent.com. [34.140.140.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429c11182e3sm19786186f8f.11.2025.11.03.01.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 01:57:39 -0800 (PST)
Date: Mon, 3 Nov 2025 09:57:36 +0000
From: Mostafa Saleh <smostafa@google.com>
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
	Halil Pasic <pasic@linux.ibm.com>,
	Pranjal Shrivastava <praan@google.com>, qat-linux@intel.com,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Simona Vetter <simona@ffwll.ch>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	virtualization@lists.linux.dev,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Zhenyu Wang <zhenyuw.linux@gmail.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>, patches@lists.linux.dev
Subject: Re: [PATCH 20/22] vfio/platform: Convert to get_region_info_caps
Message-ID: <aQh8kE9DrbxS2x1e@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <20-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>

On Thu, Oct 23, 2025 at 08:09:34PM -0300, Jason Gunthorpe wrote:
> Remove the duplicate code and change info to a pointer. caps are not used.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Mostafa Saleh <smostafa@google.com>

Also, I smoke tested this on Qemu.

Thanks,
Mostafa

> ---
>  drivers/vfio/platform/vfio_amba.c             |  2 +-
>  drivers/vfio/platform/vfio_platform.c         |  2 +-
>  drivers/vfio/platform/vfio_platform_common.c  | 24 ++++++-------------
>  drivers/vfio/platform/vfio_platform_private.h |  3 ++-
>  4 files changed, 11 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/vfio/platform/vfio_amba.c b/drivers/vfio/platform/vfio_amba.c
> index d600deaf23b6d7..fa754f203b2dfc 100644
> --- a/drivers/vfio/platform/vfio_amba.c
> +++ b/drivers/vfio/platform/vfio_amba.c
> @@ -115,7 +115,7 @@ static const struct vfio_device_ops vfio_amba_ops = {
>  	.open_device	= vfio_platform_open_device,
>  	.close_device	= vfio_platform_close_device,
>  	.ioctl		= vfio_platform_ioctl,
> -	.get_region_info = vfio_platform_ioctl_get_region_info,
> +	.get_region_info_caps = vfio_platform_ioctl_get_region_info,
>  	.read		= vfio_platform_read,
>  	.write		= vfio_platform_write,
>  	.mmap		= vfio_platform_mmap,
> diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
> index 0e85c914b65105..a4d3ace3e02dda 100644
> --- a/drivers/vfio/platform/vfio_platform.c
> +++ b/drivers/vfio/platform/vfio_platform.c
> @@ -101,7 +101,7 @@ static const struct vfio_device_ops vfio_platform_ops = {
>  	.open_device	= vfio_platform_open_device,
>  	.close_device	= vfio_platform_close_device,
>  	.ioctl		= vfio_platform_ioctl,
> -	.get_region_info = vfio_platform_ioctl_get_region_info,
> +	.get_region_info_caps = vfio_platform_ioctl_get_region_info,
>  	.read		= vfio_platform_read,
>  	.write		= vfio_platform_write,
>  	.mmap		= vfio_platform_mmap,
> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
> index 3ebd50fb78fbb7..c2990b7e900fa5 100644
> --- a/drivers/vfio/platform/vfio_platform_common.c
> +++ b/drivers/vfio/platform/vfio_platform_common.c
> @@ -273,30 +273,20 @@ int vfio_platform_open_device(struct vfio_device *core_vdev)
>  EXPORT_SYMBOL_GPL(vfio_platform_open_device);
>  
>  int vfio_platform_ioctl_get_region_info(struct vfio_device *core_vdev,
> -					struct vfio_region_info __user *arg)
> +					struct vfio_region_info *info,
> +					struct vfio_info_cap *caps)
>  {
>  	struct vfio_platform_device *vdev =
>  		container_of(core_vdev, struct vfio_platform_device, vdev);
> -	struct vfio_region_info info;
> -	unsigned long minsz;
>  
> -	minsz = offsetofend(struct vfio_region_info, offset);
> -
> -	if (copy_from_user(&info, arg, minsz))
> -		return -EFAULT;
> -
> -	if (info.argsz < minsz)
> -		return -EINVAL;
> -
> -	if (info.index >= vdev->num_regions)
> +	if (info->index >= vdev->num_regions)
>  		return -EINVAL;
>  
>  	/* map offset to the physical address  */
> -	info.offset = VFIO_PLATFORM_INDEX_TO_OFFSET(info.index);
> -	info.size = vdev->regions[info.index].size;
> -	info.flags = vdev->regions[info.index].flags;
> -
> -	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
> +	info->offset = VFIO_PLATFORM_INDEX_TO_OFFSET(info->index);
> +	info->size = vdev->regions[info->index].size;
> +	info->flags = vdev->regions[info->index].flags;
> +	return 0;
>  }
>  EXPORT_SYMBOL_GPL(vfio_platform_ioctl_get_region_info);
>  
> diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
> index a6008320e77bae..05084212a76eb6 100644
> --- a/drivers/vfio/platform/vfio_platform_private.h
> +++ b/drivers/vfio/platform/vfio_platform_private.h
> @@ -86,7 +86,8 @@ void vfio_platform_close_device(struct vfio_device *core_vdev);
>  long vfio_platform_ioctl(struct vfio_device *core_vdev,
>  			 unsigned int cmd, unsigned long arg);
>  int vfio_platform_ioctl_get_region_info(struct vfio_device *core_vdev,
> -					struct vfio_region_info __user *arg);
> +					struct vfio_region_info *info,
> +					struct vfio_info_cap *caps);
>  ssize_t vfio_platform_read(struct vfio_device *core_vdev,
>  			   char __user *buf, size_t count,
>  			   loff_t *ppos);
> -- 
> 2.43.0
> 
