Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3F22DC34D
	for <patches@lists.linux.dev>; Wed,  5 Nov 2025 21:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762377566; cv=none; b=pRcjjKi9Q7nQvlpHBuBIm5WzNOUCDJ6uJk8gL4o2+Tn8rnCGasFQe5Uj9OzF8MfgvqQELdBdYZY9e3ql4haRIMsba4q/i7mdX4mdTzTBW9d7APnmdsZZLhqQUeFvnUAgq0OO+9bmGlBzw3uCWkpt5xA4wmpSap3Mnhzqf2mvFRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762377566; c=relaxed/simple;
	bh=qCj0HkjcLlvzURF6w77QHtU0WP9/ZsapXnXVQY35VDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ij9Hu5tSp4KnwwceuAMXrox1vid/cl/J05KYJmzv9umWgJAKTQ/CYg1Ms6C9xq4PiyBsxWZivf98VDpYW5Dg0L2oPVNCbudiRO84kQ+f9FlU1diRuk/HKa1G/fB+bXZi7cBdFzokbEhccIf2RbqYVwxhpSl2c/FRkyZ3iIsU1Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2wfO7mSo; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2wfO7mSo"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2959197b68eso11105ad.1
        for <patches@lists.linux.dev>; Wed, 05 Nov 2025 13:19:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762377565; x=1762982365; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wsPKARLgoDbiEbqdjmx1yQIPjPrrWc4YFZC2utX6iXU=;
        b=2wfO7mSoaVuOvGu3v8M2X73oY0Pan62oi//+FK3/9E3zsASyTMqNIWAhxfFj8lcYOO
         PQ9BWK/1+5MWmzQY4KUulz3t6C15qFbO5ZO66hZhVrcK4VsYWKMX3YCFpeqzagi07b9f
         rud0sk0IiHg0V1fNdwDCd9qvkITNuijSSmovOrSzN2LSvtm90h6cediNz783TPmaxQu2
         X0GG4vz61wDJ/m4ZYG22u6WTNPL0hzTpYrfgntJRiN8pv+ERQm4gsAmA+HWXEeb1tbR1
         0NPB243U9I/Ss7IUI8X0j5/+tyZIN9Hb3XtgmyX1KNjQ9DTk6wyo1zgmcag+elY0hxNH
         9U/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762377565; x=1762982365;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wsPKARLgoDbiEbqdjmx1yQIPjPrrWc4YFZC2utX6iXU=;
        b=Vz4oEs2xFYqmiskWOWl38AmKi8pFci3/EpT8jTJ+Hy+Jnz+XPYGL1LVZkaCqNcGIUu
         t41oQE+/F6KL6Mhg+Ex6InKh1jb42r5GXPZ9FQOF6PMeY5KkhGVGyURyKbL7fztxIMNp
         /xb3FtKxISkx8SB5X717phdbqUJ9oRZ8zGPgD9tKDTz5wzIuwgw3/28u+O7c2EmyhRfr
         SJDY671MlwHYnXud16yylAVKvcPAvbckVMNreVGQfowF1GQ8HC3Qbp7QXfL2lxsFYUo0
         Q+7E2wOOk3dACV0OD0owQxJKpwDbmChIyo06BTNUr+KOyrIRL4uBq6vn9dGejYnCs+9f
         zv8w==
X-Forwarded-Encrypted: i=1; AJvYcCXshh8tArRYjMOV48sfAqNsrAbjrIQvCaXIwy5uS7+8zAsPf0mP8pdV/fz96hk/pRPNw0MiAYe8@lists.linux.dev
X-Gm-Message-State: AOJu0YyvDESNqb3Tb3/tcG+VgTzWaloKnQZ0slw7evxMBHb6Ceak6yqf
	8fJlm6ryezwg+R7l1Hd8dDupJ6QIT5K8zcodi67CObMQz9HUrHagAHzYYQ2M3ZwRTQ==
X-Gm-Gg: ASbGnculVu1mSKnds6WAUN9jmtq2Xsj5gJml0d8xfCNUF7fk7Tfr+hewRwBhxA9cb0G
	wsj6ZD+qo6cd54dl8l92LAb00tmvOeWrZS/P6qhEqxZPydK2d4yZygPK41DG+YQVCErYEP0xs1G
	4qg4dUFaHqa08EhN5kFOV3vgnfxbg6xf8AYWWvSBV0c4OuKm2HQjWiPJ8ZrMflPULKTtRo9Rd7B
	nxE/rw8fIYV6VrZ8XN0pc908sUIWcvTbSD0uZ8t16iHzJ09jFmYXwPIMpdA64SPUeOW3Do0A2+u
	L5EZ1/q6FaDwgG7FDB4vRXraDqEGnE+lNTfUm/FjCX/tSP+/+/cUnRBYfE6Xo7/Nu4HirkTIAo1
	+Vjn5xn9iCgEsZfpo1BYyjCEZz9qMjWqq3Ue5bO912Nigc5cbY6sGwGf+ElNBDK/8rCo/fyNNS7
	G79vt6ux8PGr3HohsDlwyWkGMSxpvwW686IGIjIA==
X-Google-Smtp-Source: AGHT+IEIIO35cH2PrBkhqYMd/E+xZSf3lgI2yKX1DyfVtbO2pYBYeKyrnA3lBD1BQHg2AJrJT8JqeQ==
X-Received: by 2002:a17:902:d505:b0:266:b8a2:f5d8 with SMTP id d9443c01a7336-29655c7a119mr1205695ad.14.1762377564053;
        Wed, 05 Nov 2025 13:19:24 -0800 (PST)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7af82bf14d6sm365224b3a.66.2025.11.05.13.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 13:19:23 -0800 (PST)
Date: Wed, 5 Nov 2025 21:19:13 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
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
Message-ID: <aQu_Uc_ZmBJUgw0_@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <14-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <aQhcOYVbY-LqOjW5@google.com>
 <20251105134829.333243dd.alex@shazbot.org>
 <20251105205600.GX1537560@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251105205600.GX1537560@nvidia.com>

On Wed, Nov 05, 2025 at 04:56:00PM -0400, Jason Gunthorpe wrote:
> On Wed, Nov 05, 2025 at 01:48:29PM -0700, Alex Williamson wrote:
> > On Mon, 3 Nov 2025 07:39:37 +0000
> > Pranjal Shrivastava <praan@google.com> wrote:
> > 
> > > On Thu, Oct 23, 2025 at 08:09:28PM -0300, Jason Gunthorpe wrote:
> > > > Remove the fallback through the ioctl callback, no drivers use this now.
> > > > 
> > > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > > ---
> > > >  drivers/vfio/vfio_main.c | 8 ++++----
> > > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > > > index a390163ce706c4..f056e82ba35075 100644
> > > > --- a/drivers/vfio/vfio_main.c
> > > > +++ b/drivers/vfio/vfio_main.c
> > > > @@ -1297,13 +1297,13 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
> > > >  		break;
> > > >  
> > > >  	case VFIO_DEVICE_GET_REGION_INFO:
> > > > -		if (!device->ops->get_region_info)
> > > > -			goto ioctl_fallback;
> > > > -		ret = device->ops->get_region_info(device, uptr);
> > > > +		if (unlikely(!device->ops->get_region_info))
> > > > +			ret = -EINVAL;  
> > 
> > Nit, typically I would have expected a success oriented flow, ie.
> > 
> > 		if (likely(device->ops->get_region_info))
> > 			ret = device->ops->get_region_info(device, uptr);
> > 		else
> > 			ret = -EINVAL;
> > 
> > But it goes away in the next patch, so *shrug*.
> 
> Yeah, still I can edit it..
> 
> > > Nit: Let's also add a warn/err log here highliting that the device
> > > doesn't populate the get_region_info op?
> > 
> > Are devices required to implement regions?  If so, it'd be more
> > appropriate to fail the device registration in __vfio_register_dev()
> > for the missing op than wait for an ioctl.  However, here in the device
> > agnostic layer of vfio, I think the answer leans more towards no, we
> > could theoretically have a device with no regions.  We also want to be
> > careful not to introduce a WARN_ON that's user trigger'able.  Thanks,
> 
> Yeah, I had the same thought, so lets leave this. If we do want a warn
> it should be in registration.
> 
> A device without regions does not seem useful, but also it doesn't
> malfunction if someone does want to do that.
> 

I agree with the both of you.. I just thought if we should remind the
user with a log that the dev doesn't expose a region. But I guess we
don't need to worry about that.

> Thanks,
> Jason

Thanks,
Praan
