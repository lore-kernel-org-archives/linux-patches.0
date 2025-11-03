Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A622728CF56
	for <patches@lists.linux.dev>; Mon,  3 Nov 2025 05:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762149489; cv=none; b=HOtOwuckS/ID1lSOa44X8u6hZdZFAS3YZrFQTxvbimEd991prmSAzmcRp3wK0StwWn4R8/H6a7FWlTSSpCUn0o5sGv6Bx7eS5ZSO/IS6Y9rRXigoiyO0I+Fw8NIkRrw4TuhpjiL/Nlk/W+AZw0UcJs+jV94pM+2pj/ziUB/rrX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762149489; c=relaxed/simple;
	bh=COnfabRE25CHEyik36bmtXTyjtL97X8u2YW/C0gU2+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qWgV2d10gI45UXOiK8xDZcGikR7oaNqCy5SC4uGUGGn1uO+q0cHXMEiIDMR03dRy6AfcnL84FFKeM6Sss8UBL3r2vPubjY6ZRTz2Z8EqCEHEfBYh5ToTq8m2KFjUZN1OfzhPxpP3kXMZzaB/5y3GH+8GibK2zuLVACuGMSeFmyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T6GPGEJB; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T6GPGEJB"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-294f3105435so329035ad.1
        for <patches@lists.linux.dev>; Sun, 02 Nov 2025 21:58:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762149486; x=1762754286; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jNN38kSQW+Z67K4qsM9EOBHtmYi+rj4bbcXqoaYoYec=;
        b=T6GPGEJBLVshs1WOyYAd/m0Cg9WEgR0Zi1WSAnkDInY5x7eTV1/b8b+fS+nFfyxZ3Z
         pvQzo37j+OY8dH7kRG1HQEQEJon9rKIobPc0TIePK41WCCbq2VbZYf3MqhuyJfzIEVBp
         o0A8Es2JcqFv71ydjILcaP+ncbb1scqH7JbZcipvLW7yjAgcn9NiK64dxoN2nxFkK8rW
         0Hl+MwuRiIsq2qKzj5IygVZeS1T7JzG2Dy/RFdcF0zi5htCdOYId5o2kzcmlNr+ME+sl
         DO0GKjbZjySIBsJER0RwSwiWQVjtdCE4IQcndRc7QrQfFw/6M+V5XDwF5LqzWaFyntb8
         +mnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762149486; x=1762754286;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jNN38kSQW+Z67K4qsM9EOBHtmYi+rj4bbcXqoaYoYec=;
        b=aOYGfFHw6EeNsdUrvPeajcjdK2Pe5CO8Zsvxpj024WG8IacUgKcZr9VAkjy/gnu1vj
         xfwaZxoyIoxbzCSLNDwDZvy37yPS/VCwKexYBEhX+koBJLPM2uYVqiaJUmGLOn/1Oax6
         mf4zkrr3UpskXMr9ZO5Dg9h4Sdzn55XXESlHI2RFbGvzdNfvvbomxDHjIcSw+pWKtuM2
         OllFiU/UjfLls0msuHRITzW9t0GvcHhLKfPUW8YbGfOhUfboJcEP91IdWDMdjCcXh542
         XCevXtDfrKFGTvFSdKEaWb/LcMPDhnY1NfJSwPDpBSigHBQc7f6XFquR8IFWgHZE0WYk
         ry0w==
X-Forwarded-Encrypted: i=1; AJvYcCViq83W6fGmvp3bNYvUKXwTBDd5o/GPSL7wARM+KjbJiwivZXsO6PaLo3gKhd/XC/PVPAXJcNpx@lists.linux.dev
X-Gm-Message-State: AOJu0YxTv+Dqddhuo7yQFrR5Dc6DiI7K5q4U7Mia/CpkcLEIcrNLLiAf
	BuBq3mVL4PBW7QTxZ86p0EHSUkk7QUp2TRQndtYkncx0sB8DdFhQEl171cuc3N9QmQ==
X-Gm-Gg: ASbGncsgmnh7em1LPN/2ZTG9POPstD9tu6cKdG1F5ulKtXPYvVqVuHTucIG1/NLmLxF
	eCW1adp5XBFTZwSQq5DvWWydWGSRCIaFyUeX5ahb3zVI8cOAz7AdZ8h4mQLM90BkDHuOPN7avca
	oinke8DFtggWNIut0KFVnexgNkHTFcaGwix1mcMYSdW+Vl+xjsxLCHeMxQhABGBGYI7uwxlKhdQ
	/lK1LDn3wmHGbpXV+0uSmMnmUgFLECJGA/9qYD1hN+9PQOTXPxZ29ucUzFfKogEXnP+DRz14W9S
	BVadNE9ssJu1fOL9qy50pATGjY/P5GEEi0Q4mDdA35/hf66btvD8a+J7MMuBdrqwx2H/UXFLf3+
	7nUkNEIV4lFIPPoY6bOsizfyiygGQrBO3xbbUGJSmdONw7sLud3e+4TWl4u9SSCqNwAQJ/K3aEa
	PrONkLBXGOzO29TIWqMHjMDDtZ7cr0nS1BLiU3bmb2MeOK0xq0
X-Google-Smtp-Source: AGHT+IHe2S0n2gwZ091UPBX6ERfL1n+n8BtlVw9vlL1yBRvzccFZt3lfIo5NNtd6hxmzG7hv2JOREg==
X-Received: by 2002:a17:902:f68e:b0:295:5138:10f2 with SMTP id d9443c01a7336-29556599a23mr4787225ad.11.1762149485582;
        Sun, 02 Nov 2025 21:58:05 -0800 (PST)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3407f26e0a6sm5783366a91.5.2025.11.02.21.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 21:58:04 -0800 (PST)
Date: Mon, 3 Nov 2025 05:57:54 +0000
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
Subject: Re: [PATCH 01/22] vfio: Provide a get_region_info op
Message-ID: <aQhEYq9YVzbBlWnC@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <1-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>

On Thu, Oct 23, 2025 at 08:09:15PM -0300, Jason Gunthorpe wrote:
> Instead of hooking the general ioctl op, have the core code directly
> decode VFIO_DEVICE_GET_REGION_INFO and call an op just for it.
> 
> This is intended to allow mechanical changes to the drivers to pull their
> VFIO_DEVICE_GET_REGION_INFO int oa function. Later patches will improve
> the function signature to consolidate more code.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 9 ++++++---
>  drivers/vfio/vfio_main.c         | 7 +++++++
>  include/linux/vfio.h             | 2 ++
>  include/linux/vfio_pci_core.h    | 2 ++
>  4 files changed, 17 insertions(+), 3 deletions(-)
> 

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan
