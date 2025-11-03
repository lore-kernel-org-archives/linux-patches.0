Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B452FF14E
	for <patches@lists.linux.dev>; Mon,  3 Nov 2025 10:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762167142; cv=none; b=c+qDJkVnIOIyzN7SVydulTXj8TLXP5A49AzgxJWGkSkQBcBjJ7rswmjXc23cLYgNVgz4OeckjoxeeBw0ftFDLks5D1M4IxA2wyg//IZzup+Iwf4BBI/Zm6pZl3DKARiNnSOKnfsblE9tOhuhNfCUpEx/jToeeXH6mCcBSfneD+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762167142; c=relaxed/simple;
	bh=mvE+DUWqyOq8EZSNgDW4VO8ZUoDnjwG4bmh01CUVPv8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XvPYoBGDvtXXSc8VN+JH2PoTjA0AyLRY2q8HW3twrp4dz26xCtLNAXm9+CX/InDpaUB+f1hXwYUYg73trM3iHcsZSysS+OAuvpzTGJ0QU1FTVT7i2aMJ4qaXkIzCcB90Z6QCPC/ZYIsdiyvfWFbmBE4ZQj6Lw03LSOkg+uUZ0XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Mh6mycrM; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Mh6mycrM"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2959197b68eso235595ad.1
        for <patches@lists.linux.dev>; Mon, 03 Nov 2025 02:52:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762167138; x=1762771938; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WwKprwTirCt4i5Js91Sl+ZyTThwVs5kTlEuvLY+kPJk=;
        b=Mh6mycrMnn7W0hdLAKXB8t/p+29yRWjMXSWX1E27SC2Gj7Ad7hsf45OEtKwzU4k4qt
         H6EOD8f78o+Uwbc/cR9HJo9nkbNXjPWB1ndluUtExIuUDszSA9YRQVKHuAyLGnpP/di1
         d1dmnaefrABLz0AaIH460gd8kbvR1E/YhbRjAFcEk9mbkn3LteTRTdyA3GqcPax77bzq
         L1DQBFsRwX0CCKVzqMhE7b+gOHIN4tiNV/6CW1NZF5P+Cm2wS3NfqDrWfNklBUh8uLOa
         94u5fJpvs+Bvo5m+qBQsv/uA42N2F4z3+poRQffyOFyyg5/Fxc2Zdx9kyepH1wgwGMFW
         Xk7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762167138; x=1762771938;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WwKprwTirCt4i5Js91Sl+ZyTThwVs5kTlEuvLY+kPJk=;
        b=kMJ+x5pWu50VsfMt/oYt4vmDdz8ikMdFKK+M9Dw/xEtdjjH6PugTVsoz1xWlCSdyjT
         oPhXkkbZ6bI/GvZFtuFz1wax0h701bFw5DkJwRkhs6itTKKvIjfgOYQJlkbJG7B7y6Al
         iNdr1MZ32K1DUoeVjuVSo+lUbElFZOYdO8F2MGogFqxAtQmq+2CbEvnJ9fqczfqZHsC3
         gpnAqZh7VVRLZejln3ECI4Kwf7XDOcYxwbuwkGA9vGSNVC5hUtsL5tiQoJRE8PUpLKP3
         oZ12yV/fMNjI7ncMM8b0kGofVH93yXh77f1vcIaFwOk+ZXRxhyhWe2hz/C0nTAODCnqG
         30sA==
X-Forwarded-Encrypted: i=1; AJvYcCWGDGaYrmEtykjQZ8PGP8Txg5Ir5p5BRc91eAqhNz8/sA+99m7K317at8948AFTAnzxGwK+v93q@lists.linux.dev
X-Gm-Message-State: AOJu0YzFFjL11a/1RmyMXqthHNpWd+BiXZjg2dU04zr+yTYQFpAhaiFj
	HjuTh5juL1aCnL7PzdLmLJestYh0C8/3wHIQGiTfJ4XXap0zGErmFZ4CeU//qEbnBg==
X-Gm-Gg: ASbGncv0HDjO+LRvFCum1thiA+8tYH/sGONMjfaj7wouiwYaTz/uT6jSidgdi2Owpd+
	QwSTQTtKH18ofPH7jrz73NtYtj6XCvjOMvtjCqlulDPmhWRDrQflsIomy/7s/PBWjPrwcMHnVYU
	m2qtgFmlHVYWyb7zabt1zByjpAU6RINIvHbRq/xEo8IFEKhLZKFboFKSrBrjjJ3JrXgZIntatRU
	W6NDlYwOPoZPJDjp1BJsw9vmfLoY1ioQ8/UQWMvnw6nsEHvSGTK+FBY3bDiS8eU1fduBcwVn1gT
	rxFaLXOq7av3fdejNUj/VQ/SDGF/gCAcfsPiaRf3rtcCOtwhMYpXwpNsdZeH3dZXBN+mHCztfej
	NM55UBGOB2u0uq4+zIodnXJ7fWh6OZZjVH0Ml+hYQFmrHU1aUaGED784scR716fzESUvnsyS7e9
	n+f0x+cWmwBiNYW99/PGVb9JcQ8riARRAP5BpoZg==
X-Google-Smtp-Source: AGHT+IHPuCzOHK+gl1PDmhIoWt8nQcQHNMFtOu890fqfdIsVUQlawn89pKWjl6bN9nnq4lv2uM5QPg==
X-Received: by 2002:a17:902:c411:b0:295:3f35:a315 with SMTP id d9443c01a7336-2955658e37fmr6124875ad.5.1762167138172;
        Mon, 03 Nov 2025 02:52:18 -0800 (PST)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3415994181esm651172a91.5.2025.11.03.02.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 02:52:17 -0800 (PST)
Date: Mon, 3 Nov 2025 10:52:07 +0000
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
Subject: Re: [PATCH 22/22] vfio: Remove the get_region_info op
Message-ID: <aQiJV4p3AKZSDH08@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <22-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>

On Thu, Oct 23, 2025 at 08:09:36PM -0300, Jason Gunthorpe wrote:
> No driver uses it now, all are using get_region_info_caps().
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio_main.c | 50 +++++++++++++++++-----------------------
>  include/linux/vfio.h     |  2 --
>  2 files changed, 21 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 82e7d79b1f9fe2..f911c1980c9420 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1263,48 +1263,40 @@ static long vfio_get_region_info(struct vfio_device *device,
>  				 struct vfio_region_info __user *arg)
>  {
>  	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
> +	struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
>  	struct vfio_region_info info = {};
>  	int ret;
>  
> +	if (unlikely(!device->ops->get_region_info_caps))
> +		return -EINVAL;
> +
>  	if (copy_from_user(&info, arg, minsz))
>  		return -EFAULT;
>  	if (info.argsz < minsz)
>  		return -EINVAL;
>  
> -	if (device->ops->get_region_info_caps) {
> -		struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
> +	ret = device->ops->get_region_info_caps(device, &info, &caps);
> +	if (ret)
> +		return ret;

Shall we kfree(caps.buf); before returning?

> -		ret = device->ops->get_region_info_caps(device, &info, &caps);
> -		if (ret)
> -			return ret;
> -
> -		if (caps.size) {
> -			info.flags |= VFIO_REGION_INFO_FLAG_CAPS;
> -			if (info.argsz < sizeof(info) + caps.size) {
> -				info.argsz = sizeof(info) + caps.size;
> -				info.cap_offset = 0;
> -			} else {
> -				vfio_info_cap_shift(&caps, sizeof(info));
> -				if (copy_to_user(arg + 1, caps.buf,
> -						 caps.size)) {
> -					kfree(caps.buf);
> -					return -EFAULT;
> -				}
> -				info.cap_offset = sizeof(info);
> +	if (caps.size) {
> +		info.flags |= VFIO_REGION_INFO_FLAG_CAPS;
> +		if (info.argsz < sizeof(info) + caps.size) {
> +			info.argsz = sizeof(info) + caps.size;
> +			info.cap_offset = 0;
> +		} else {
> +			vfio_info_cap_shift(&caps, sizeof(info));
> +			if (copy_to_user(arg + 1, caps.buf, caps.size)) {
> +				kfree(caps.buf);
> +				return -EFAULT;
>  			}
> -			kfree(caps.buf);
> +			info.cap_offset = sizeof(info);
>  		}
> -
> -		if (copy_to_user(arg, &info, minsz))
> -			return -EFAULT;
> -	} else if (device->ops->get_region_info) {
> -		ret = device->ops->get_region_info(device, arg);
> -		if (ret)
> -			return ret;
> -	} else {
> -		return -EINVAL;
> +		kfree(caps.buf);
>  	}
>  
> +	if (copy_to_user(arg, &info, minsz))
> +		return -EFAULT;
>  	return 0;
>  }
>  
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 6311ddc837701d..8e1ddb48b9b54e 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -133,8 +133,6 @@ struct vfio_device_ops {
>  			 size_t count, loff_t *size);
>  	long	(*ioctl)(struct vfio_device *vdev, unsigned int cmd,
>  			 unsigned long arg);
> -	int	(*get_region_info)(struct vfio_device *vdev,
> -				   struct vfio_region_info __user *arg);
>  	int	(*get_region_info_caps)(struct vfio_device *vdev,
>  					struct vfio_region_info *info,
>  					struct vfio_info_cap *caps);

Thanks,
Praan
