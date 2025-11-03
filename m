Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310B72F9D89
	for <patches@lists.linux.dev>; Mon,  3 Nov 2025 09:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762163634; cv=none; b=ClXfHbfWTH66HW3ef7UWYn7pbHWiNygrHOlu/hQopGwPKDuYWDL7KNdyPwevpG4h/acnzXdrXvrDndySZERSmeQXuI+vntii910ARbNBEPnnRc7oUurLV9rIPtkb70Y76+dPz/AF+vCkb5+4qP5Jn19m6vNt4IIMklsEg6YWRVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762163634; c=relaxed/simple;
	bh=N52BuQPS4ZYwLzXT/a19PEi5ZrFoF956jOdQxPeM1SU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V9FfD22J8XIIvZmnGsJGj/Pmb/Khlxjp+gKE3YywjbZ3D6LzOIU+lA1XrFbCVURighLSg2JByoWkFvaapP5i+eRx6kJkXAF0h0ZidsyViyO2m+1YsGhg7/AzLAVm0/3gRH3uoou0h65an7rdHd/MVN3PoJrh+pbSje+gpUdb8LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AY8OQG4u; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AY8OQG4u"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-470ff2f6e56so80915e9.0
        for <patches@lists.linux.dev>; Mon, 03 Nov 2025 01:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762163629; x=1762768429; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D423dPTmNpGJKcSjJTsDfI/X/hTMvomXahsqpyIMTdY=;
        b=AY8OQG4uAOp5EN3BFaO1KGZXpaWLuM4v9retoyHu8ZorxGVbu/w6+B5CMOEnNGkI2V
         FUZ6tF4UqmpP/9k01lIslWnsQK6yiuRnK44BZIBeju7e0KURZBDJ++gPGMBRllSlhvsu
         vrcJArPwLVCWgXPnu0kzI3xr7GXQtqAy8chJXrluqO0Osoid4f0SEX4ieJqd2zoNZfgu
         2zwBbji4AJWyrOSKTLlbVSQ2Uam/pnwvmhJtHdNRQqr2QDRfOEh9mF/vFNhlT5fZ4el8
         zBB0tzq1QJXxJtB44501PSI0u3DanL6SHmX5LknZx3WRvn/TbxSwEyMGzUa0+oFghe37
         723A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762163629; x=1762768429;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D423dPTmNpGJKcSjJTsDfI/X/hTMvomXahsqpyIMTdY=;
        b=ZG/St4qyN5Luq9gz5fZ7lQ39CEBiBr0CeCqTjOPzy/MVXYpvvbV+TDWFXwZPb+1vsj
         yQcK8yDIoxjlIkARdgiMs5byD/QGf4x7BI9AczvbYLestV3Dqh06xokA2oaaeK3YogOa
         dB5KdzW1Vs/HA7y4yviRUpPw88QZVeugDFdsneBQ046RCfwPdQ5v/xdpRxV2kEp4g/Qv
         H1ndvEWzMC35Vmi7Io+rJITP+DXYqZ7K2TqEEYIJjJjStk5DwPLPf9RJ8reGuIj4VMpI
         7MM278/znMHOT9Uj9KNmWbcNo0HuZF+aUj8HQMfaIjUTz2MkNP5APB2JIyeFP00fY7XF
         ojeg==
X-Forwarded-Encrypted: i=1; AJvYcCWu6sWLFi1lpEcIq3Yv4uPfIOFkSjRV3g3Ab8/Wp7T9n24l6s2YqoPIL6YGLFa09HhMajBqkGgW@lists.linux.dev
X-Gm-Message-State: AOJu0YwLYGWqqSuwdCsoCz5O/r/TCtpq9FX0e6w+weVxATjA9+VQ3fnQ
	WqDrjagdwwv3YtFuGUNEHUahVjTf+9xwJe6qjOZxar3ta0/OrHM/linT7JFnRphNYA==
X-Gm-Gg: ASbGnctW4F9XgPwpn4YGEqhKo93gsTQ78DSAGAIogamVLQol+wKPVP+kaEgZvdk8bSB
	8I+gPlumqtrPpRvwIkVzOUUEHXXpF8kJ6WSdnv9/Yp2yrBUDxB50tK6NStT9HLXru9WIiPUKK5+
	oR2v2+zlRo0U6KMCD1yPNkLAv7qyHdED7oqWJWyavc3YARorcB1PwjEeAjoPUHwNpEvxY5P9fpy
	3c3RyTm4YIyfEk4oEajUCsAoqwbuDXpCVWXstwnCG9slG2bUxiZiZ8NFAyy1WqDF/T3Jr+Wu2lO
	M+lNsRTmpNn6WenH/x1avFszp4RTrGsLRiFAXhTkgL6PwJ9w/z8R3qUSLAzsU4Un1cSGyZPfiKf
	73b781X0WLtCFizsszAO2GLo5L6pHxR8rSKBaH3wA2Kk8nXmwZAhH/vwY0KV4en5wNbKXHZaAPx
	5Yp+XyNj6jRRc08fs4Yb2+EYJWyomvZv3awVG012et5KaRwQmdkIDKkOKuWfM1
X-Google-Smtp-Source: AGHT+IGPSKpaT0Ddsg2x/WOeGEJojnpupEDLfdcNfDHxyjySRpAR+bkp9FY0Epu5UNDkS8vExhWcRA==
X-Received: by 2002:a05:600c:8711:b0:45f:2940:d194 with SMTP id 5b1f17b1804b1-4773cdce892mr7221205e9.2.1762163629307;
        Mon, 03 Nov 2025 01:53:49 -0800 (PST)
Received: from google.com (54.140.140.34.bc.googleusercontent.com. [34.140.140.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4773c374f84sm144508145e9.0.2025.11.03.01.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 01:53:48 -0800 (PST)
Date: Mon, 3 Nov 2025 09:53:45 +0000
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
Subject: Re: [PATCH 09/22] vfio/platform: Provide a get_region_info op
Message-ID: <aQh7qbe_lcNysroo@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <9-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>

On Thu, Oct 23, 2025 at 08:09:23PM -0300, Jason Gunthorpe wrote:
> Move it out of vfio_platform_ioctl() and re-indent it. Add it to all
> platform drivers.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Mostafa Saleh <smostafa@google.com>

Thanks,
Mostafa

> ---
>  drivers/vfio/platform/vfio_amba.c             |  1 +
>  drivers/vfio/platform/vfio_platform.c         |  1 +
>  drivers/vfio/platform/vfio_platform_common.c  | 50 +++++++++++--------
>  drivers/vfio/platform/vfio_platform_private.h |  2 +
>  4 files changed, 32 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/vfio/platform/vfio_amba.c b/drivers/vfio/platform/vfio_amba.c
> index 9f5c527baa8a36..d600deaf23b6d7 100644
> --- a/drivers/vfio/platform/vfio_amba.c
> +++ b/drivers/vfio/platform/vfio_amba.c
> @@ -115,6 +115,7 @@ static const struct vfio_device_ops vfio_amba_ops = {
>  	.open_device	= vfio_platform_open_device,
>  	.close_device	= vfio_platform_close_device,
>  	.ioctl		= vfio_platform_ioctl,
> +	.get_region_info = vfio_platform_ioctl_get_region_info,
>  	.read		= vfio_platform_read,
>  	.write		= vfio_platform_write,
>  	.mmap		= vfio_platform_mmap,
> diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
> index 512533501eb7f3..0e85c914b65105 100644
> --- a/drivers/vfio/platform/vfio_platform.c
> +++ b/drivers/vfio/platform/vfio_platform.c
> @@ -101,6 +101,7 @@ static const struct vfio_device_ops vfio_platform_ops = {
>  	.open_device	= vfio_platform_open_device,
>  	.close_device	= vfio_platform_close_device,
>  	.ioctl		= vfio_platform_ioctl,
> +	.get_region_info = vfio_platform_ioctl_get_region_info,
>  	.read		= vfio_platform_read,
>  	.write		= vfio_platform_write,
>  	.mmap		= vfio_platform_mmap,
> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
> index 3bf1043cd7957c..3ebd50fb78fbb7 100644
> --- a/drivers/vfio/platform/vfio_platform_common.c
> +++ b/drivers/vfio/platform/vfio_platform_common.c
> @@ -272,6 +272,34 @@ int vfio_platform_open_device(struct vfio_device *core_vdev)
>  }
>  EXPORT_SYMBOL_GPL(vfio_platform_open_device);
>  
> +int vfio_platform_ioctl_get_region_info(struct vfio_device *core_vdev,
> +					struct vfio_region_info __user *arg)
> +{
> +	struct vfio_platform_device *vdev =
> +		container_of(core_vdev, struct vfio_platform_device, vdev);
> +	struct vfio_region_info info;
> +	unsigned long minsz;
> +
> +	minsz = offsetofend(struct vfio_region_info, offset);
> +
> +	if (copy_from_user(&info, arg, minsz))
> +		return -EFAULT;
> +
> +	if (info.argsz < minsz)
> +		return -EINVAL;
> +
> +	if (info.index >= vdev->num_regions)
> +		return -EINVAL;
> +
> +	/* map offset to the physical address  */
> +	info.offset = VFIO_PLATFORM_INDEX_TO_OFFSET(info.index);
> +	info.size = vdev->regions[info.index].size;
> +	info.flags = vdev->regions[info.index].flags;
> +
> +	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
> +}
> +EXPORT_SYMBOL_GPL(vfio_platform_ioctl_get_region_info);
> +
>  long vfio_platform_ioctl(struct vfio_device *core_vdev,
>  			 unsigned int cmd, unsigned long arg)
>  {
> @@ -300,28 +328,6 @@ long vfio_platform_ioctl(struct vfio_device *core_vdev,
>  		return copy_to_user((void __user *)arg, &info, minsz) ?
>  			-EFAULT : 0;
>  
> -	} else if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
> -		struct vfio_region_info info;
> -
> -		minsz = offsetofend(struct vfio_region_info, offset);
> -
> -		if (copy_from_user(&info, (void __user *)arg, minsz))
> -			return -EFAULT;
> -
> -		if (info.argsz < minsz)
> -			return -EINVAL;
> -
> -		if (info.index >= vdev->num_regions)
> -			return -EINVAL;
> -
> -		/* map offset to the physical address  */
> -		info.offset = VFIO_PLATFORM_INDEX_TO_OFFSET(info.index);
> -		info.size = vdev->regions[info.index].size;
> -		info.flags = vdev->regions[info.index].flags;
> -
> -		return copy_to_user((void __user *)arg, &info, minsz) ?
> -			-EFAULT : 0;
> -
>  	} else if (cmd == VFIO_DEVICE_GET_IRQ_INFO) {
>  		struct vfio_irq_info info;
>  
> diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
> index 8d8fab51684909..a6008320e77bae 100644
> --- a/drivers/vfio/platform/vfio_platform_private.h
> +++ b/drivers/vfio/platform/vfio_platform_private.h
> @@ -85,6 +85,8 @@ int vfio_platform_open_device(struct vfio_device *core_vdev);
>  void vfio_platform_close_device(struct vfio_device *core_vdev);
>  long vfio_platform_ioctl(struct vfio_device *core_vdev,
>  			 unsigned int cmd, unsigned long arg);
> +int vfio_platform_ioctl_get_region_info(struct vfio_device *core_vdev,
> +					struct vfio_region_info __user *arg);
>  ssize_t vfio_platform_read(struct vfio_device *core_vdev,
>  			   char __user *buf, size_t count,
>  			   loff_t *ppos);
> -- 
> 2.43.0
> 
