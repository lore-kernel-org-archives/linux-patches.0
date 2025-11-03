Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B236D2EAD0D
	for <patches@lists.linux.dev>; Mon,  3 Nov 2025 09:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762163593; cv=none; b=Ddmbp4goUcVYmWN2KLWNHmrdzerPouAGyOTYeYIfWc6qLsL+ZjGDH5xsKNbcrsyuQvyZhAQQXVnWMLrUl7YGQjrN5zarxBi4/ZiEi0AqDDlEZB1f5RPO/cPZLrHjKH1NkllUbv+Vv2wvEbomF6d80iTayTOdKXILJBPmPdAMCb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762163593; c=relaxed/simple;
	bh=JKFySBYZ5L+2LiVx7km0crRWvXRHHVbQF5Z8FU6+lVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gcpSHF/zel/qy+qt0hp2Uz3WRlaaOW/yimqgaCD19pis6KSOhIPNpWwjhvv5iGqw8w3fVBdn57rAHFu4AtDORkbLv4d+hUi2Jv8PGxGL0gsg4xqbJbBt8+4MVZeboCX3O3SaobPhm0rX2jCMpaUCd7glcrmi4JAdvFnTaHrbsO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ut/XZ8x7; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ut/XZ8x7"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-475df55f484so84055e9.0
        for <patches@lists.linux.dev>; Mon, 03 Nov 2025 01:53:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762163589; x=1762768389; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CJ4RrOu9uCN2bW8pg1KpsPpPzgZldv3XyNgHXUg1t1c=;
        b=ut/XZ8x7OvOGWOm7t5TyOUY+MF+7/XnZ8T5rfeREvM9rC1I9BSv3Ka95+D0uiSjXOR
         XBW72AdfYl5aI1VpB//zx6soYMBQP+atycZLLsxhJkSdU1FMoxbFZ/+TcbWKAgnQTxO8
         RmCshXZiD1P9HbG1nrA13jwE/pMOmWJQnjEoxOx+d21JGj6W3Q7JrApswieAIkSkwn3r
         /5+/thqTI5gBBOku2kfIocu7n3O2AnQbqrguR2n75di1xntYdNjczAUOFHoBEZurktv1
         P18wDMdAkf6pKKnY9MZIHfDgyWLly0ApBT0CXDo99k2/Q/c7qWDrAoyZ2Hur6Ah0C9Aw
         DiCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762163589; x=1762768389;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CJ4RrOu9uCN2bW8pg1KpsPpPzgZldv3XyNgHXUg1t1c=;
        b=DM/eHgjdKceVryOvWtvIwor9Xxupyc343nx3sCPKQJyDKLzNnkpLpFPMF8+C/RHU4z
         XI8LcMId8K8RTDkL5xaUkKBp+gAeh2VxaHYP8VSQw4JqzF2ICudwC4V6lvp0SFVeeME6
         EEJQkddmRzhk8pKY5tkT1YZ/KCOLmLpcoX1WqQIDBwHdjq7/RKGJ/68bLVHv41YoSidT
         X6QgAw3iCKU6iVJi3g6RUdBGcYi+H2YgH08FYQLwZbah7mHYdd3PXXOmYL3m4YUT+hAh
         WnUd0aQs+9Qywo1dPRqXeRZubWtT04wwQeB5DJ2AmFWoXozB+1Bf4Orml/w6v/LHhN7S
         wOmQ==
X-Forwarded-Encrypted: i=1; AJvYcCWm/Ey3ngsxAT2WvsqPQpaqH5vlV5819yJsALR7SxAKGFcb2ZDnLBEDawzmwp4wIerm0k4tv72r@lists.linux.dev
X-Gm-Message-State: AOJu0YwrDkNWmQCtDYcRHGDVgq2dxvep1V9ttdX55PWV2oQKBVHtg19+
	P7fsYZpERMwURrRKqxva5MlgvjmBfV8CDvK4J639RexOYaxN642jVnFRLCOvNJfAig==
X-Gm-Gg: ASbGncvipLFf7FQo21zS4stNF23PblDmh6zzduJOLC9mmWNgpJao6xrIgZPl9uU7UJ4
	IQy6W8DX1NFeknX2zaXhsS38NY22HK47/M0urfpMkHtcAqfvQ7Td+wSxOmnvo4UCksxCAqgHYv+
	6vC/giqZ3dbSe8FiMgFUDRxEizm+htVuSKb8oFezUgDbRe4Q4Ui1/hA1TIaIxSxAt3cp+jwjqI7
	PCXsT3MFCQSefvFUelon7RZRP95XMEQgWhWZlD5YOJ0DifkwI/xNUnRehUwEKjMDFq7G5YMDF22
	Ee9pqyey5UxJtGx2rvPMyu8A1xPJewU308SSIw8Uqu83SJAqYAuGxeeFEpoT7jmWd+nKiVQn+25
	PTzhZDS1mZX2iliSOJCWWhGPCTTSYlSC+t/1ZcVCq0rTMOpSnJ/uqa8d3XPwTNGBVHnlXQJdFs6
	tB3yw5KYaHWfw9zfCdaWByw8tJ95TVebcddLx5q1nTGVaFF0v85w==
X-Google-Smtp-Source: AGHT+IE1mff4da9I5vysNB0ob0JmOMr70AWi7AKZOtcSI5qvyyAXHktFY8REU7m0liVQkNgCELSSCg==
X-Received: by 2002:a7b:cb14:0:b0:46f:a42d:41f0 with SMTP id 5b1f17b1804b1-4775268121fmr217365e9.0.1762163588833;
        Mon, 03 Nov 2025 01:53:08 -0800 (PST)
Received: from google.com (54.140.140.34.bc.googleusercontent.com. [34.140.140.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429c13e0325sm20082715f8f.29.2025.11.03.01.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 01:53:08 -0800 (PST)
Date: Mon, 3 Nov 2025 09:53:04 +0000
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
Subject: Re: [PATCH 00/22] vfio: Give VFIO_DEVICE_GET_REGION_INFO its own op
Message-ID: <aQh7gG3IAEgEaKY_@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>

On Thu, Oct 23, 2025 at 08:09:14PM -0300, Jason Gunthorpe wrote:
> There is alot of duplicated code in the drivers for processing
> VFIO_DEVICE_GET_REGION_INFO. Introduce a new op get_region_info_caps()
> which provides a struct vfio_info_cap and handles the cap chain logic
> to write the caps back to userspace and remove all of this duplication
> from drivers.
> 
> This is done in two steps, the first is a largely mechanical introduction
> of the get_region_info(). These patches are best viewed with the diff
> option to ignore whitespace (-b) as most of the lines are re-indending
> things.
> 
> Then drivers are updated to remove the duplicate cap related code. Some
> drivers are converted to use vfio_info_add_capability() instead of open
> coding a version of it.

The series as a whole looks good.
However, I got confused walking through it as almost all non-PCI drivers
had to transition to get_region_info then get_region_info_caps then
removing get_region_info completely from core code after introducing
it in this series.

IMO, the series should start with just consolidating PCI based implementation
and then add get_region_info_caps for all drivers at the end.
Anyway, no really strong opinion as the final outcome makes sense.

Thanks,
Mostafa

> 
> This is on github: https://github.com/jgunthorpe/linux/commits/vfio_get_region_info_op
> 
> Jason Gunthorpe (22):
>   vfio: Provide a get_region_info op
>   vfio/hisi: Convert to the get_region_info op
>   vfio/virtio: Convert to the get_region_info op
>   vfio/nvgrace: Convert to the get_region_info op
>   vfio/pci: Fill in the missing get_region_info ops
>   vfio/mtty: Provide a get_region_info op
>   vfio/mdpy: Provide a get_region_info op
>   vfio/mbochs: Provide a get_region_info op
>   vfio/platform: Provide a get_region_info op
>   vfio/fsl: Provide a get_region_info op
>   vfio/cdx: Provide a get_region_info op
>   vfio/ccw: Provide a get_region_info op
>   vfio/gvt: Provide a get_region_info op
>   vfio: Require drivers to implement get_region_info
>   vfio: Add get_region_info_caps op
>   vfio/mbochs: Convert mbochs to use vfio_info_add_capability()
>   vfio/gvt: Convert to get_region_info_caps
>   vfio/ccw: Convert to get_region_info_caps
>   vfio/pci: Convert all PCI drivers to get_region_info_caps
>   vfio/platform: Convert to get_region_info_caps
>   vfio: Move the remaining drivers to get_region_info_caps
>   vfio: Remove the get_region_info op
> 
>  drivers/gpu/drm/i915/gvt/kvmgt.c              | 272 ++++++++----------
>  drivers/s390/cio/vfio_ccw_ops.c               |  45 +--
>  drivers/vfio/cdx/main.c                       |  29 +-
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c             |  43 ++-
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |  54 ++--
>  drivers/vfio/pci/mlx5/main.c                  |   1 +
>  drivers/vfio/pci/nvgrace-gpu/main.c           |  53 +---
>  drivers/vfio/pci/pds/vfio_dev.c               |   1 +
>  drivers/vfio/pci/qat/main.c                   |   1 +
>  drivers/vfio/pci/vfio_pci.c                   |   1 +
>  drivers/vfio/pci/vfio_pci_core.c              | 110 +++----
>  drivers/vfio/pci/virtio/common.h              |   5 +-
>  drivers/vfio/pci/virtio/legacy_io.c           |  38 +--
>  drivers/vfio/pci/virtio/main.c                |   5 +-
>  drivers/vfio/platform/vfio_amba.c             |   1 +
>  drivers/vfio/platform/vfio_platform.c         |   1 +
>  drivers/vfio/platform/vfio_platform_common.c  |  40 ++-
>  drivers/vfio/platform/vfio_platform_private.h |   3 +
>  drivers/vfio/vfio_main.c                      |  45 +++
>  include/linux/vfio.h                          |   4 +
>  include/linux/vfio_pci_core.h                 |   3 +
>  samples/vfio-mdev/mbochs.c                    |  71 ++---
>  samples/vfio-mdev/mdpy.c                      |  34 +--
>  samples/vfio-mdev/mtty.c                      |  33 +--
>  24 files changed, 363 insertions(+), 530 deletions(-)
> 
> 
> base-commit: 211ddde0823f1442e4ad052a2f30f050145ccada
> -- 
> 2.43.0
> 
