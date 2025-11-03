Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69892A1C7
	for <patches@lists.linux.dev>; Mon,  3 Nov 2025 06:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762149981; cv=none; b=tUSXyRfzslcPyuyakeNe0n6zNMUoLkzp5avd5/UEwMnRUuNT2si+ABoFLjZ+NgoYY4Id0bZFeMemsAwH1E7+W5JVyJ+AjkISq68pNn9x2Bbz1HfrlisDCfbES/cLsLkrs/Waf13Hj39DqdpAK0Zohb2I19C3uX5m1UCjnn4OTTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762149981; c=relaxed/simple;
	bh=aNWT1S8ZE3WFAX7jq/LAX4FFPsVg9T8Q53OEL4HSo8c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mOMyjMiqOVU/Z9mTvCjLsKjwrtbsey+f6084joyue/0U24/cp8RHidhaBDG956kTn5UZE71tuzGAU/85VVGjhujjB4XvCka5sysyBDebbML+trSYaVRB3IVhRdThwpKDtMQA5JTtGPY0ENi0Wu9QiCFvsbDmH9gAa6061F+gMTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NLxzac5B; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NLxzac5B"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2959197b68eso184765ad.1
        for <patches@lists.linux.dev>; Sun, 02 Nov 2025 22:06:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762149978; x=1762754778; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=daEhgCusceEtpwe81ptEC+bKqGITwloFYe7hKEHFGD0=;
        b=NLxzac5BB89DSNJ3EVtmfWMkAMaMgqrcQKnwDPHvng9cDq2PxnUo6Fe0Yn3udAEMtj
         XeIa1liJHiGRzSWLt1zBYxzzD2na2rmINOasnJIbVo02Jxx87e130SRoybA3ErmmS6Ea
         wmshsyFrCZyKZi3Z9ZGdUA6VPn7tkPpcxnAozp1zm77ewMj17x93REZqdGVOdxdNfjOS
         6t4sugZaodUFQ+4gv61nctk5wYdFUhSpVRADhnNn1db3e4VpG+r4rRgqaGSfIM9I1/9g
         qeu5/9ToSpZUuAgj4HUDKka5fpEXEveVp8VZj5aYdD3s+h0ERrjPbVT7sYxrcc7PAKP0
         xvKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762149978; x=1762754778;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=daEhgCusceEtpwe81ptEC+bKqGITwloFYe7hKEHFGD0=;
        b=aJKH+ak81jXlfUMg4F57eHKVVkxxxUtyoOZKBxu6b8WeHfQURlm89br8BIt2OwIy9E
         G8W/QYrOHR58sWgFpy9auDxAPiRI2WMEf7uWxja331J+8EeHi/HCrslpKSLpGjyIgkrJ
         69IAjPHM9k1T8HVVZHbJxgEWLOkt15BQacLGr5Z6S7XadiXgt7Ez69m8jeO3GJ7RKL5r
         SAfXUsdQdfmJZ59YnHA5j7gcea9ACPRxNBd5JF55lpaZssDPUYlsJ1g0WPPnhruHL6eX
         FIaEV0p7ALf0IFB1UlwXgWnbEypQZ1WhKguDEQ2bymaUu9QYbS7TWZDUGMCTKSHcQDhd
         BZvg==
X-Forwarded-Encrypted: i=1; AJvYcCVTN45sN7fRlzGz82AZmQUPnONo3ag/x8B1xRUxRoM/ktKerb3g5cxLDJrp5omUdapixYQTZ2c5@lists.linux.dev
X-Gm-Message-State: AOJu0Yzg1u1m6ClqSwe43j506Ys2rYCwxvJhKAFS87hrcXlAmelMujnr
	I0R2NnKdkyNkX0pUJ1g4R5CTXBZ9zwkRb/pQgPEY8wP8Kkh3y7Zh2hVLZmuyh2XaIw==
X-Gm-Gg: ASbGncsA7NMRu1+4fEQ+34mK2nogEr9qXJP0ILp2sh8hMlPqu9eb2IJfnMdcQHzCVqI
	iiX1QQMB1wiIW8wSKLlHfvPWa/tman2+MlN/A0rS/g8hhIWZa34VeaxqY7qW8LHCBBZkoquo0hO
	0NGwTkwEhNG+CK5CGcGp97pNOq8xsWOYx/xzgJbkY+qcWi2Oa3xcxk9TmjU5GbmxDmcKvFA4Prf
	zOR9QCI+2SgJD0xqhdiiyn025KUG+cwD8bxS0uDEWFtXhxHbQrm9ipdUyP8WwJZAsnaTL1kIU+f
	VjoQiVvKAuBR1lEJI3t8IpDrSVFyq2k0h2ZVtPk+K4nAxDqDUAU6xAAdB3IXxFlQN8Gywi9y46g
	4J/IikqYv5Y/7VfLSbfKwXN0sXmegiIpPYeiVnZpQ15+IcTMB8bp6Bx8ziIxaMczdN5c2oaY99g
	IpczAc10HtkgRxnTq1eHw5rrWKbob3dmHxPnPX9g==
X-Google-Smtp-Source: AGHT+IEluRFzLqUGHbmfa87kzbGcxD4xtCtUDt3Aesdz6fP5oqFYMacpJF/LHmpqMlg6+1lRT50KTA==
X-Received: by 2002:a17:902:ea08:b0:294:faad:8cb4 with SMTP id d9443c01a7336-29554b85496mr5533065ad.8.1762149977826;
        Sun, 02 Nov 2025 22:06:17 -0800 (PST)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a9bad978c4sm5062872b3a.13.2025.11.02.22.06.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 22:06:17 -0800 (PST)
Date: Mon, 3 Nov 2025 06:06:07 +0000
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
Subject: Re: [PATCH 02/22] vfio/hisi: Convert to the get_region_info op
Message-ID: <aQhGTwg4kpuP8pgF@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <2-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>

On Thu, Oct 23, 2025 at 08:09:16PM -0300, Jason Gunthorpe wrote:
> Change the function signature of hisi_acc_vfio_pci_ioctl()
> and re-indent it.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 57 +++++++++----------
>  1 file changed, 27 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index fde33f54e99ec5..f06dcfcf09599f 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -1324,43 +1324,39 @@ static ssize_t hisi_acc_vfio_pci_read(struct vfio_device *core_vdev,
>  	return vfio_pci_core_read(core_vdev, buf, new_count, ppos);
>  }
>  
> -static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
> -				    unsigned long arg)
> +static int hisi_acc_vfio_get_region(struct vfio_device *core_vdev,
> +				    struct vfio_region_info __user *arg)
>  {
> -	if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
> -		struct vfio_pci_core_device *vdev =
> -			container_of(core_vdev, struct vfio_pci_core_device, vdev);
> -		struct pci_dev *pdev = vdev->pdev;
> -		struct vfio_region_info info;
> -		unsigned long minsz;
> +	struct vfio_pci_core_device *vdev =
> +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> +	struct pci_dev *pdev = vdev->pdev;
> +	struct vfio_region_info info;
> +	unsigned long minsz;
>  
> -		minsz = offsetofend(struct vfio_region_info, offset);
> +	minsz = offsetofend(struct vfio_region_info, offset);
>  
> -		if (copy_from_user(&info, (void __user *)arg, minsz))
> -			return -EFAULT;
> +	if (copy_from_user(&info, arg, minsz))
> +		return -EFAULT;
>  
> -		if (info.argsz < minsz)
> -			return -EINVAL;
> +	if (info.argsz < minsz)
> +		return -EINVAL;
>  
> -		if (info.index == VFIO_PCI_BAR2_REGION_INDEX) {
> -			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
> +	if (info.index != VFIO_PCI_BAR2_REGION_INDEX)
> +		return vfio_pci_ioctl_get_region_info(core_vdev, arg);
>  

I'm curious to learn the reason for flipping polarity here? (apart from
readability).

> -			/*
> -			 * ACC VF dev BAR2 region consists of both functional
> -			 * register space and migration control register space.
> -			 * Report only the functional region to Guest.
> -			 */
> -			info.size = pci_resource_len(pdev, info.index) / 2;
> +	info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
>  
> -			info.flags = VFIO_REGION_INFO_FLAG_READ |
> -					VFIO_REGION_INFO_FLAG_WRITE |
> -					VFIO_REGION_INFO_FLAG_MMAP;
> +	/*
> +	 * ACC VF dev BAR2 region consists of both functional
> +	 * register space and migration control register space.
> +	 * Report only the functional region to Guest.
> +	 */
> +	info.size = pci_resource_len(pdev, info.index) / 2;
>  
> -			return copy_to_user((void __user *)arg, &info, minsz) ?
> -					    -EFAULT : 0;
> -		}
> -	}
> -	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
> +	info.flags = VFIO_REGION_INFO_FLAG_READ | VFIO_REGION_INFO_FLAG_WRITE |
> +		     VFIO_REGION_INFO_FLAG_MMAP;
> +
> +	return copy_to_user(arg, &info, minsz) ? -EFAULT : 0;
>  }
>  
>  static int hisi_acc_vf_debug_check(struct seq_file *seq, struct vfio_device *vdev)
> @@ -1557,7 +1553,8 @@ static const struct vfio_device_ops hisi_acc_vfio_pci_migrn_ops = {
>  	.release = vfio_pci_core_release_dev,
>  	.open_device = hisi_acc_vfio_pci_open_device,
>  	.close_device = hisi_acc_vfio_pci_close_device,
> -	.ioctl = hisi_acc_vfio_pci_ioctl,
> +	.ioctl = vfio_pci_core_ioctl,
> +	.get_region_info = hisi_acc_vfio_get_region,
>  	.device_feature = vfio_pci_core_ioctl_feature,
>  	.read = hisi_acc_vfio_pci_read,
>  	.write = hisi_acc_vfio_pci_write,

The change seems to maintain original functionality and LGTM.
Acked-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan
