Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A533298CBE
	for <patches@lists.linux.dev>; Mon,  3 Nov 2025 07:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762154092; cv=none; b=WJAGBLYqLfHL1nfD0bQtF95DnqsbQDqwFL9zcj1O3bYW9geCzZJwrxNOs2oovcCXrQBrQxE8W7HQsN0AUiiQha42XyATOZUqfzSg3DSMf6G50IFwaV0vHVGkgtM/CTFol3ZplQ419GMlRvLpB80n6sZ7AWOvf+lZqz5jUaieyOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762154092; c=relaxed/simple;
	bh=M46toCVjS5FqeK8M2CG3xD/T7DNTY+jrsL9mMEekFOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nv36gwYlvTY0qoHgNm0lycewfBo+OaSkKsdO13DstNn9meROyIhGdeKucb7A8ODeR29jq2aKMYHYle9xk2uDed7enmw6yclGOvz2GGJN/6Kyexfo/hg4rqXzUmIF2fU30Le4p5kHiztZLjP4+rv8A7xujpiTN4aOIqBy4lNRB7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fXxIMuOZ; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fXxIMuOZ"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2959197b68eso193355ad.1
        for <patches@lists.linux.dev>; Sun, 02 Nov 2025 23:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762154090; x=1762758890; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=krxDO85tsubF5J6uxcbfpS+xA/eKw7o0+Vmbt9d1Ois=;
        b=fXxIMuOZp1iH7KvDYHN0tmyf0+kCvQ/tzIQU1LjCi7fkKxoEkF61YzhJp+Wte6zn7D
         9uPTAx8AF/e5xwUkmKlYIDcruLR4a1hF+rTkHBxY10hc60jDoO3Vx64rizVqv1edIPeK
         KX02WRpoPzxwG84D55PpXi12YQQjIedF6jS3lT0dH4kU4QF9tA9eZbxgx+JAUubeTU/F
         y94r3ARvNoPge9F7eUrmvUkvVB8f9nOKeHFDZJIo3XTNXGj7Eihvifhd/geFMoO7Dt3P
         KEVJq74q6XJS8mNUjUVAcTGY+AV3WLWZa05Zqjf0OWaIvaVonSgXJNOKUffh3vVT8Qku
         I58A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762154090; x=1762758890;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=krxDO85tsubF5J6uxcbfpS+xA/eKw7o0+Vmbt9d1Ois=;
        b=ZLJqMQ3c8XFYxBB+ytZ1w298qkCwp01Ku4S620QX3bs/ApujNU9RrbKi+pk7GHsevW
         ngs+sWDJK8uJgh3qEjqqa2dSahLesAo5QuwpARLZY15IHTXFejVlQbaVHAfcVpLQ+bXa
         oX+EWyKtgLajnhePEJdlZX1aktD9e5TvvsKbBQ3fn57xkNuNx4b1RaJLLdsPTZdhaqqW
         crZsF7hCOzDD2pBoIuUyGNG3OxWQFkp7Oz1gIX3p55iBvlKazfNrGg2GpS2/7jt1wXwc
         QDvieNs47iweQLinSdGqZB09ibr5LM89iaWwh0Kycxw6xdMqkXoKlqJ4idQkuZoC/q55
         p/hg==
X-Forwarded-Encrypted: i=1; AJvYcCUo7z8r/8BGqF+0XYdq/zq49EufSV12S9f5BJw6CCibPpr2Uv5yOxraU2zjickfzKm2dul8yeaq@lists.linux.dev
X-Gm-Message-State: AOJu0YxUYHWY+CSRkZdnhzeU/W7RlxqtGm6NisIC/VVWEnnz83v6KdHA
	d1XkNT3goR9c163L0QyCCJh143ZNBGM422agnivTpJEXXS/pBNAJD7DAFIWQxA0gKQ==
X-Gm-Gg: ASbGncsF2o8i8aTeV4fC6gQnDCvHfizWRD2cjNYDhs+c+YSZtYiGGotjZ4eSYc+7PBX
	9AXc9y0cwvDKrGh6i6etOM6p2z4FvD2KcewYkNDqLHw3PFvz4kh3q2HP4D4vPcx+ZxBHd+yrhXp
	QW5wi+XymioZf4DDidPHLb/gqGtBcNR31qBDbeh14sHlWcutBv1+Wm1ai3gyr/GcigK5Ks0RHjF
	qAQg9yVBQqmU2UaZ+plJvWd+VP7+htDBMNSm7+kFugN6g28wSlEoMqoSKDXR1SomslowuPYPxWR
	0hX7d4pu4EZ5LPFLnOtXqKJlFgFIbzj33AMv3klaDdhS6PTKGN+F9ErchQKHLnPeIMCh75Qn4TO
	s3xyWXMNYrbvPM/rXLmtk8I0/UVUO/P8S4Gx+r1MZhvr7nbX59XFRAMeMdiV9NRCmuTvuk8+BEo
	zJ40vT7Flr/Ngz8N5Em+DYSQuRwbIH5jzx+MCyZA==
X-Google-Smtp-Source: AGHT+IE97CemVwDodrlEsACTbu3ii+CcSlX4Mt/UH1nASQkOOWezhknbfsTfFcSLebBhaZ2a41/idw==
X-Received: by 2002:a17:903:184:b0:25b:fba3:afb5 with SMTP id d9443c01a7336-295565ad1aemr5343685ad.11.1762154089465;
        Sun, 02 Nov 2025 23:14:49 -0800 (PST)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2952696eae8sm107020535ad.61.2025.11.02.23.14.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 23:14:48 -0800 (PST)
Date: Mon, 3 Nov 2025 07:14:38 +0000
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
Subject: Re: [PATCH 09/22] vfio/platform: Provide a get_region_info op
Message-ID: <aQhWXmluuFaU3XPL@google.com>
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
> ---
>  drivers/vfio/platform/vfio_amba.c             |  1 +
>  drivers/vfio/platform/vfio_platform.c         |  1 +
>  drivers/vfio/platform/vfio_platform_common.c  | 50 +++++++++++--------
>  drivers/vfio/platform/vfio_platform_private.h |  2 +
>  4 files changed, 32 insertions(+), 22 deletions(-)
> 

Moving the GET_REGION_INFO logic to vfio_platform_common.c and exporting
it for both the vfio-amba and vfio-platform drivers to use in the new op
looks correct. LGTM

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan
