Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B012F39BC
	for <patches@lists.linux.dev>; Mon,  3 Nov 2025 09:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762163743; cv=none; b=hlyNgXW42ho/diY0JrZGAqm1mk/RNrxY6WwF7FBS0NWdflZYRn5l3BBYXOu2SpGyYpFWTaZQ3v4+YcAptk4jfzvtfFbh0gN8Ea/FpScCvsDjRe/henWi22ERnJR7HiSsFjA0FvfaOL/DsrWp1g2DcB/+boCVr1zzEUfBowPSIAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762163743; c=relaxed/simple;
	bh=i8L9n6bZwkPz17FpheWU6M/n9dfpcR4hkCB+s7fwei4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t9lRkGKfC4ljEUNl/udJESrCVo6Df6GlNHy3ry6vANxkzUplq+LHvyuv+Xt1S32bp+u6WtlO1Au42lPTMeYzvDGP+RPb1XMVIrYEM5mM4mP8g4xWV7h19Ppddwi7chk8P/B6zu1k2+/v2JOSG2FNoKlU1P5a/j0UYAwwadLt7K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TJwzt7un; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TJwzt7un"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-47105bbb8d9so72105e9.1
        for <patches@lists.linux.dev>; Mon, 03 Nov 2025 01:55:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762163740; x=1762768540; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/iKwbtWviZdAY+4F++DJl0rWWY/RQA9LSGiuI2/hl/A=;
        b=TJwzt7unbMkp13Jw9k7vyRgWJIk+B2pigamOHsjV7onXWSM/m7WDqnHlVkuCxKq+iv
         dOX9KQf8qjUw62V6FIpcndKkzHR3Bii2lgcTERldtX5ZD2eM5IYXI+kqwXS1UCJpByX6
         TxDsj5oU6oKlpeD+sE5pJqQfPdRO2T3DfJjBs7pxPUYX72s3pWC8asEm1+VwQzjvRrZC
         18wefMNtORtrmqfFYjVS72374bob4uzpteJCCmM7kh2uCDTnTk7jLsoWRRfGPatvH7qX
         pEnt3LjhGNMkcV98qebimJP5b2EmQvDtyMHyQ//JIpvbX5EabeTOX4CtHpqGOF/n9lDD
         fDrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762163740; x=1762768540;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/iKwbtWviZdAY+4F++DJl0rWWY/RQA9LSGiuI2/hl/A=;
        b=pM7VNzdVlHvZm+YfhwdrDTXbBjHiAHBBw8V2SjTpz4bPV4uE4LqvH/AxIBf8+HuzPR
         ES1vnqi2/U/dKGu/AxE/A8SeLIy5E4PgaU1JM+28tfSuhTMUfXGGm4V617c9zqgmNIOd
         Y8C/zgVbI1HTVc5FL86LIVK9uiY5wh8p7i3KHVnZY7/7lrsivXi4lNEDDrLY9ssJ8DHu
         eVoBW2hTUIyiz9kSE4XzTBTaeZdpxK0YEV5+k89Uavb7MESr9A6uEqdD84wVDhPWVYAz
         hxeAylKB7t/eM8fTj/3pdUtJrJLik1O/Hy0ay1m/z36xyU7RIyNOwiJjx+OQOOjmMygg
         DJtg==
X-Forwarded-Encrypted: i=1; AJvYcCVsmoEbFQqGjhcQsb8NaSfAkQGm/DVfjEMVdSE82Ib0bHqkYCggj4vFBLCSfuBHSRYWf9M4i9yB@lists.linux.dev
X-Gm-Message-State: AOJu0YxpZo5Ll45b2L2mRBQEYYzbPWny8V/7IwHKVBExCQTj+R3MJ5TU
	0y5dPoLo6nCnXbk+K+w5ZdBhDilGQOPJz7zJFXXfa+CuumII9uFhnYetBsCOY6PxBg==
X-Gm-Gg: ASbGncu16FigvohZVo1RPxSgT5iL/s1sfdCcd20SLgoU2dei4pW5CHpJEmQkKu7BgfY
	UzK3QEdHGnLR87pRSOZGhR+E1G1HmEW89BghFQbeTLOyJXCk0ztntl7tOqKy/bdJkv7KU2R0kJY
	CFpe8zElCTAwRA9Eveu3Up/qqAuECXSuT94imPUCNcwGydVUcuHpo9+1DDU/uMMHH7Q+jkeBj/d
	8g/RTztk/kcuUt+cQpA98KlUEqacSQe2mS08VsHzokwfElSjHQ1fY0c7tYacs/cJVKdZ84B7/O2
	v28juyHub62ptUfIrVU+/RasILd15HCIiYwUFWaVefHrKY7qSngrrY0vJtSG5eFkOM7r6NfgdSN
	24Zd/dvUpA02LoqwMSTQV0jQUsRbxAPp9vndHoDKV0AvEaBT267E0sAYQsZrT/12LT74cpckcFA
	WXNwp/B9kSIuTKSYfFWGlbq3XokDnCDQsXhJj+G5/U9f9EvzZSWg==
X-Google-Smtp-Source: AGHT+IHAx+AWORE9paLXTzRW7mKzqe0hb2wtQ9DF+W6v23M9Vo/fGIuffOpRO4zhYPoMBhdyXFmsSw==
X-Received: by 2002:a05:600c:8a0d:20b0:477:255c:bea8 with SMTP id 5b1f17b1804b1-4773da9baeemr5918155e9.7.1762163740369;
        Mon, 03 Nov 2025 01:55:40 -0800 (PST)
Received: from google.com (54.140.140.34.bc.googleusercontent.com. [34.140.140.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429c13ebfe8sm19975798f8f.35.2025.11.03.01.55.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 01:55:39 -0800 (PST)
Date: Mon, 3 Nov 2025 09:55:36 +0000
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
Subject: Re: [PATCH 14/22] vfio: Require drivers to implement get_region_info
Message-ID: <aQh8GG15d_-Ge2Xx@google.com>
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

Reviewed-by: Mostafa Saleh <smostafa@google.com>

Thanks,
Mostafa

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
> +		else
> +			ret = device->ops->get_region_info(device, uptr);
>  		break;
>  
>  	default:
> -ioctl_fallback:
>  		if (unlikely(!device->ops->ioctl))
>  			ret = -EINVAL;
>  		else
> -- 
> 2.43.0
> 
