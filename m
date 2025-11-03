Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1FBC2FD665
	for <patches@lists.linux.dev>; Mon,  3 Nov 2025 10:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762165784; cv=none; b=ZsKh7St2DOcWJBsHj/4gUsZa27fVfLjYvb5wOZDZmoTvZVr+SEnKe7mtqjrMZhBMmyfiFR5JkFpZg1v17zjrTJHQWP8fWw1mZsmNDdZpd4NMi3J8x17LtUXF1KVASJD+utdbLG4P0yD4gDRhkKXvior1jKFKkiUA847B9qlRVCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762165784; c=relaxed/simple;
	bh=V327Um22bMTy/equs3K8rbAzzyPzJ9CLEIoEo0OIurE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n3E0c5Xpjb6jO0EuSKwnJ3wqkLZZNhBDgv4AJhkSDtgSdAvw14WmSNuPofOiVr1GSPUVzCKaIGTUQJXVWIuKMylXLIJvrEN+L6mSdFQPqpWz81RE26v6WavEcqjyntxLxn5j/zXiqYhNDL2nat7SkxqPEWruaxo7MjTgFIyVnZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LE0J2ICw; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LE0J2ICw"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-295c64cb951so124575ad.0
        for <patches@lists.linux.dev>; Mon, 03 Nov 2025 02:29:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762165782; x=1762770582; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gNHaVozbtXB8nI6t/qtWfMkb6Kn6PYTAjlMTSN+Ugyg=;
        b=LE0J2ICwZFr5zC44IEabsQElvmC9kmkluWkWp9/Jn/b3Fb9NLfVAvIydXxJ8bEoi9t
         Vqghzc0CAC4clTnjd+z7i01uSKJM/9thW6shlBUmZWiRtFLKT5TcFoy8h/beNLWHNdzE
         z6EQy3cjyuh0lobCuvNPMQxRUNY2U/vOy1Tu8ox2R3RW5iBxYcQs7pbVOKLX/2pEetHQ
         8NkojEzcT7RPp0jaAnX5fW9Hvsr/S1Hslz7Yq3PF76CK6n/Gspi07d7CxnEfkG5t46QU
         krQ+lbgd83vr40zE62tfmtyLRonQPjEUpajFfWMxcogjxBMl+U/TmugdsAeu2SlpVd5P
         qiUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762165782; x=1762770582;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gNHaVozbtXB8nI6t/qtWfMkb6Kn6PYTAjlMTSN+Ugyg=;
        b=TFwKv/IHhxS4EXUBJZdb6w9c+T8gx4Q9NJweXLLSv3KYs+UXblyQdVCCXFh0hskrXj
         b2zbRPuRpWHBSssSTIg8yG4YNMZiHi8igbBuEnMNJrPWCPmt32xV2AXodw1y+hDgHfmq
         2Vc203ldOuq+dHtTjQHblfQbyYyyxW+bXAUI0lj42s/OSz2lFwZVM0341vRxpxaLziGX
         NXh8rNC0V0/PUQxctcWZZEGWWagzjZ0IY7sYVvrJ3yChxxJHaUWdUTx223h/S7Y+K3ID
         BFi5B2ip9T5w2xtnO3TcfzhYpD99AvJ4yjrGvWx7In58Kokp4s+KRohSF55zn4IhGeel
         MJGw==
X-Forwarded-Encrypted: i=1; AJvYcCVVQIfxfeB1b6TrmmxW4OUNgx86yrYbtPna2EMG1Is0jLfjll2FqpBx/9w9ppeSzFG/jwVJk4Vx@lists.linux.dev
X-Gm-Message-State: AOJu0YwAQSJjcOnVM+0FI0CoSdpvpnvkXhrDYc8etqDxxvaEe4H+aCem
	hYNvN0shmA/32Gam9YGTqvt4DZ90ETFQnTFV/8pCcsqvrePmJM/nt9qnF1w0oFViXw==
X-Gm-Gg: ASbGncuivAWR/4/OAMB0MB0Yzcxyeb8Qgfmmdwee6WTQoM3kRBYKmfSY+6CDNW19Z5I
	mT3Vzf0r26UuRsSOQ7sCl7EoenJqLJ1skGN/x5dXbwov1eDRCFsIbJAcPWca6f/vfjn4CnWlo9J
	VUuuuc+HTAc73ZpijSfOBJzRhe9CbPOB3/xtFVe9MJOOkfntc9aZmIcmoeuAO9PHHKrhEMULsOz
	+4hvP7nPPW1pfred5TJW+fjqAenoBeQ1RtuzAOhMHHOtBRbODA3K9Dj3AHcKinTsDQuE8H6/2Yn
	wHi823QOJuRewM6U4ShV4A+V0cfVMuoKsrKLGgiufDLaI47j8BsEk7Q1X1CbbWzxI1eD5xk5vAV
	LyUOrrNOXzoJPJ9iuFHJdsj5olHdhLWz83jq0swYH1wZX7bFtKtHyVH/6h26M2SsO0QBP7N35ji
	EsDkFzvjd/281W9GpM32nKXgu8SGnWufA8doURuQ==
X-Google-Smtp-Source: AGHT+IE7RbmruVQhXsny/j8l+SFhjfD6jlGy79IZqby3HlHJSxLaU8PrnA03I6j8kd1hYd7zo15JRw==
X-Received: by 2002:a17:902:d2d0:b0:295:30bc:458e with SMTP id d9443c01a7336-29556477728mr6652975ad.3.1762165781842;
        Mon, 03 Nov 2025 02:29:41 -0800 (PST)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ab30909fccsm2991326b3a.20.2025.11.03.02.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 02:29:41 -0800 (PST)
Date: Mon, 3 Nov 2025 10:29:31 +0000
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
Subject: Re: [PATCH 21/22] vfio: Move the remaining drivers to
 get_region_info_caps
Message-ID: <aQiEC2Z3lqxAIY3J@google.com>
References: <0-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
 <21-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21-v1-679a6fa27d31+209-vfio_get_region_info_op_jgg@nvidia.com>

On Thu, Oct 23, 2025 at 08:09:35PM -0300, Jason Gunthorpe wrote:
> Remove the duplicate code and change info to a pointer. caps are not used.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/cdx/main.c           | 24 +++++++------------
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c | 26 ++++++---------------
>  samples/vfio-mdev/mdpy.c          | 39 ++++++-------------------------
>  samples/vfio-mdev/mtty.c          | 38 +++++-------------------------
>  4 files changed, 28 insertions(+), 99 deletions(-)
> 

Acked-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan
