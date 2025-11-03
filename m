Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B361221DB5
	for <patches@lists.linux.dev>; Mon,  3 Nov 2025 11:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762167829; cv=none; b=UruHOonyipZRBDgCpgHrfNv8xk106zQjBEcPubXduMp967fUA3xn4FIyUB2DpYo8WxYZ6OON9InZAW/9rreNWQi5rmFVsYxahX4MC+FDc2JLn3FvypvNmEzwNgiMLfj1ibKcPe4l5mq1vzciGAkmdVEGo3AKfpSLK2mYjJ/v1yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762167829; c=relaxed/simple;
	bh=oQx/ydTW/nop4AcGUNLqHSf/CC+CTlJRuLVJVH3L6VA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fvOuVgphN+zzjl16PrGbkoonSDfGrWDbhN6OEO68vFMDSFpuwF4q8f82XA1ItFpb3fdW5GtcjAgJxSkM6/7Ka4nDV2QO5qcJPF4n8ca19z+tDkFmWQgT+cCK3e73sKJ+KFt0r3UqKLVTkE2KI+kQag46SqxvqnCDTiyBw+nrLJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cD3D3B9P; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cD3D3B9P"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-295c64cb951so131685ad.0
        for <patches@lists.linux.dev>; Mon, 03 Nov 2025 03:03:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762167827; x=1762772627; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JG+etGO4DCF1PIFwJUo34O2NHRXv7sGubVRA4h3tffk=;
        b=cD3D3B9PJRBgh6i0YbktcU/+59LW62oHKq6rlAg8aCkIGS2GDUI21fEzTgG0Xck+gQ
         qvvj974VDQE9z+xEhA6bs9BqDIvcm3k4NyiPJ0+zdS1mDWmCggyIUwGuyGlihtKXWy8/
         HhsYlGCRYnRTDy5ZNxOlwC7B4DAsf2H5yNo3LR2Y3w0KJ6K8QGytsBD0wwF5VSOeeigF
         vMMcQC262gUtLxK3SemrTS37ayLD9IMuGmTsBRiUU9j8S2TjG7AcdAkceJ1qiw4s9/88
         /OgQt8fQCEdApQAJ9qt/Kgtp3PoizCPbSu+PuhDUC65izXKgvTYxJMk9Z0WxfqQ+8ymi
         EDMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762167827; x=1762772627;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JG+etGO4DCF1PIFwJUo34O2NHRXv7sGubVRA4h3tffk=;
        b=I7XQSfQt1wXoZi0IJVjGApsNLA5/KndhHMSgk6qxjPSfXQiKQAeaoHjYFM1JfE1X+x
         Hqrn9krc3jPYly2Ltl0PivcfEtUXjnBLP6IRYnEiHqgmg95kTnO/SOSY0slQ8UfdVnMH
         mj43Qa/jGJutClnC5GlX4VMFnKlR2T3tKbvvgThReKF9Tly7Ka+7/n3jWE3q5rNbXRjs
         fkv5bD7knrrm2aScc+eb7DSeyIuNoEvKiAkiopSuwR3FPk7mNQrhRgSB8SqevDbTJ9V9
         Gg1jSV/EYrN04ibH8ngZ/Ud95NeqTkTP7UPJl3S4iKdZSPKEdCT7GMS5uQkPgk6dmVmJ
         nG3g==
X-Forwarded-Encrypted: i=1; AJvYcCUT+Ofje6atrr0y5L/Xbagg2zNZbLK5bYxgClvsyJnEbqt1qFwmAA/l/YQe3iQWTb+ygtDEyqGh@lists.linux.dev
X-Gm-Message-State: AOJu0Yw3o7xXAK6eE83Eu4+3AsT0ruOHaX5S6eILRd2fUeORLThWxWgi
	4Iulylbc/Czkjn2ai3gbiaLiAtLE36yodEhXaVxdF3WByAPo508nKy5/Ko72WcTUYQ==
X-Gm-Gg: ASbGncuvwyf9CSLYnYnezX9/HpwMSa/tLtLQR8AP41h43H0rEJtRKj0l+swAsccOGD5
	EVJJNqTElCQ0k5wUYcKWtQXXaSTOA63dhi/8TrV5bhLpde/FjtI+3DFRVZDTRmPWoYKi6js57FZ
	/0kCQLlpH1r58Q6H4z3fWVu/0QqaVAL32/JhZDs1R+YlL4FOpi5iJwZYU6dCFMycvgbMqtUyqcm
	6C7hqiirRrlvE8iYUoa3KsldBhkDBDK7rEA3HzgHGjkIn30J/cw+tpYSn9WzONdHw7LDLVtQtXh
	wxx68n2Who/dF9IuRENkB2rM4YWG/dpsFuxiYT1+zE13eJG6fpS+A3JurJx/9HMvBG4OyFkrV41
	fnwZUpfuHzel4ZDf+4ETuYkff/35DZp9RjrchJyuhuN1eJ5073rbVBe0a2wmfppEEtH0h5il8zP
	K9tMNlcuXLINOOEpGiX5mIPAV2c7CP0WjMYf2tsQ==
X-Google-Smtp-Source: AGHT+IGcDUbk6qqLdQjGL3Yxey3X8mTSWxpSXkjqaoDl6gxo10SeAyfD2HQnpWNy1nfGBwMDtJcUBw==
X-Received: by 2002:a17:903:228c:b0:271:9873:80d9 with SMTP id d9443c01a7336-29556476bd0mr5742325ad.7.1762167826744;
        Mon, 03 Nov 2025 03:03:46 -0800 (PST)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29537cccdecsm102934645ad.19.2025.11.03.03.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 03:03:46 -0800 (PST)
Date: Mon, 3 Nov 2025 11:03:36 +0000
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
Subject: Re: [PATCH 15/22] vfio: Add get_region_info_caps op
Message-ID: <aQiMCKszFCvDDHhH@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <15-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <aQiBGEgQ3vCpCvXM@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQiBGEgQ3vCpCvXM@google.com>

On Mon, Nov 03, 2025 at 10:16:56AM +0000, Pranjal Shrivastava wrote:
> On Thu, Oct 23, 2025 at 08:09:29PM -0300, Jason Gunthorpe wrote:
> > This op does the copy to/from user for the info and can return back
> > a cap chain through a vfio_info_cap * result.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/vfio/vfio_main.c | 54 +++++++++++++++++++++++++++++++++++++---
> >  include/linux/vfio.h     |  4 +++
> >  2 files changed, 54 insertions(+), 4 deletions(-)
> 
> The newly added vfio_get_region_info seems to pull-in common boilerplate
> code (like copy_from_user, arg size validation) into the core code,
> removing redundancy across all other vfio drivers. LGTM.

I missed one thing in this patch (luckily caught it in patch 22):

> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index f056e82ba35075..82e7d79b1f9fe2 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1259,6 +1259,55 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
>  	}
>  }
>  
> +static long vfio_get_region_info(struct vfio_device *device,
> +				 struct vfio_region_info __user *arg)
> +{
> +	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
> +	struct vfio_region_info info = {};
> +	int ret;
> +
> +	if (copy_from_user(&info, arg, minsz))
> +		return -EFAULT;
> +	if (info.argsz < minsz)
> +		return -EINVAL;
> +
> +	if (device->ops->get_region_info_caps) {
> +		struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
> +
> +		ret = device->ops->get_region_info_caps(device, &info, &caps);
> +		if (ret)
> +			return ret;

device->ops->get_region_info_caps (via vfio_info_add_capability) can
allocate caps.buf and then return an error for a different reason. The
if (ret) check returns early and the kfree(caps.buf) on the success path
is never reached.

Should we add kfree(caps.buf) to the error path here?
This keeps the allocation and cleanup logic centralized in the core code

Let's either write comment saying that the get_region_info_caps op is required
to free caps.buf before returning error OR add a kfree(caps.buf) here.

> +
> +		if (caps.size) {
> +			info.flags |= VFIO_REGION_INFO_FLAG_CAPS;
> +			if (info.argsz < sizeof(info) + caps.size) {
> +				info.argsz = sizeof(info) + caps.size;
> +				info.cap_offset = 0;
> +			} else {
> +				vfio_info_cap_shift(&caps, sizeof(info));
> +				if (copy_to_user(arg + 1, caps.buf,
> +						 caps.size)) {
> +					kfree(caps.buf);
> +					return -EFAULT;
> +				}
> +				info.cap_offset = sizeof(info);
> +			}
> +			kfree(caps.buf);
> +		}
> +
> +		if (copy_to_user(arg, &info, minsz))
> +			return -EFAULT;
> +	} else if (device->ops->get_region_info) {
> +		ret = device->ops->get_region_info(device, arg);
> +		if (ret)
> +			return ret;

With the above comment addressed,

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan
