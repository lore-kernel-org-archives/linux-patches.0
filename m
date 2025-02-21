Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B272201036
	for <patches@lists.linux.dev>; Fri, 21 Feb 2025 11:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740138105; cv=none; b=JA22olSj2FmLMtndLzjayCtJWwkkVSjjUFYJtdu4EXZ05h4KW8Ztke6yCKryCpRS0xXSZE/ILqgMSJlIPa+k0yIDsjBmFKS6WMsggenVQPkw5QE95vU0Fvq6yKgLavUidY4rMokL3DRb7GbV/y/r35blKE3LUQ4iLvC7WFNm5z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740138105; c=relaxed/simple;
	bh=SvjxmZauslII2+Ca1ZFCYVVzR/2EOh8sGT3TqK6IOHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RHQ0mTrjERVKIN2smkzUX7RCQgAXIzg3yZMy9k8XrrINeXJ17PhSuoxS3dv58SSGDmMwT+98eq4Z0i3aqatgcrhR3OqCGc05qdunReal+5KURszaEXuBW2jsJR6ea4PegOxwLdPuWgtlZFgQ3yUcAC4goGc6B1/U8CXNSY0WJNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iQaVvLe6; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iQaVvLe6"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4398ec2abc2so17206985e9.1
        for <patches@lists.linux.dev>; Fri, 21 Feb 2025 03:41:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1740138101; x=1740742901; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8Hjqn4Gzw1MqP1NTAwTa5QXz+1IZXGfOQwpEgvNl05E=;
        b=iQaVvLe6EXCJRQ/e+PtRn/wv+GbG+g8QQjl4lhK6QJGZfvGWZcQQb3L+c0UeLaajQk
         5kzcCcXlVpoqHGrweGmwdDvlZjBM6+x7EI0I7zTL9t6LZYFOLCsuVYjXQoHBtUR1JyIb
         SgTTr+P5P0VZzPzRM+P8Z0li8J8Ii4ydf20j+uL5z+xCgLVpksVSyMKClM+rqnpLvxWi
         n7yqxoRXfeb4xqRXFBLjGdX3L5LKFNW5/WcpvoQZvp4X9hIrKurasKJn14G5GteA0+vA
         wCNpnjhtCGYw/7LY8Xf4g7a39VzVC6Mfxahlur5OAd9jB0mZ1cjIIbNJvKEgqL/gi49K
         s0FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740138101; x=1740742901;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Hjqn4Gzw1MqP1NTAwTa5QXz+1IZXGfOQwpEgvNl05E=;
        b=Nk5rI3iTBxGBffbFbaISvADcEVqOf3SjX+UVD2ktlao8y0OraUF1fb+u7iFSGnRO1h
         Nxojd+DKuGKJi3Z9IRrn9a+BwX6fX4i2PP7yf1/eoh4tqNui6uuEzrF6L51bs1cZlYyU
         152ZcFA+VPgR+0L0iS2cqcDxJL/S6eY7gSEFlAHbKpZQsIpE+uI/N9MkodkA26gj9jsu
         QPgQFTNzAWNIMiXEkuhd16m2+F9LrKmWNlqrznS7adIDQjOpWrugziEFh12ftx+eg8YA
         r1JGT+SjBqUYEUF/93SwDl2A/CAAQpYPb9h+CNYKdWjDHXNwRj/Z9asnWJ9JH/8MbJQV
         cLAg==
X-Forwarded-Encrypted: i=1; AJvYcCWp+7cbWt1yC7ab1Fo0mf+k/9phnQZ+oWt1uOqGM7KCZ9BZzw/7Q+a3ZnTzZBWbYQHJNg2k0yzt@lists.linux.dev
X-Gm-Message-State: AOJu0YxjOAJ3eHnZGCAScnvqJTB6HVDWNNTQjt4T1+2HWsFDMcrpmTPW
	XKofsaKYf12rmhTB2xmX6vWroZCBbaQIUHH5RnrF2zOe5edIL194SdC66cetENw=
X-Gm-Gg: ASbGnctzRrkUz1KkEYPU6Ci5AP5H8zusMDbErVVJuHQkB8dnm8c9kcrAn0ROJvgHXsU
	vp2u8vYA/rmkREdhn8fYXiwva8bzkdzEByBz2xT2pGu+njX+0UJrDnS/mC/MYIN/ZAZQsbIh5jm
	H9+90x9hov1lryGmLiruF3R6m1YtaRPNN2tT/WgjYuWCK6gc9mlTvVJpT28W4AyCktjYuh+AvTt
	RDsWCrQxZEiWJhNmzuQIxZNWuWyrVsxB6tkdj5B76OQrjPjSukv2eSmqIRnPu9DLbKoPEeEMs1i
	ynNmvrr1LQlZOaT7YstFqpVn
X-Google-Smtp-Source: AGHT+IFsNsE6nwYIxjV3tb1IOYQfAHzudn/bvPIeUKbaIvn1PvgigfMsE/xHa387zcqeYKxGoOg7pA==
X-Received: by 2002:a05:600c:4590:b0:439:95b9:91fc with SMTP id 5b1f17b1804b1-439ae1e6e9emr24389505e9.12.1740138101489;
        Fri, 21 Feb 2025 03:41:41 -0800 (PST)
Received: from myrica ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-439b02d5610sm14624925e9.11.2025.02.21.03.41.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2025 03:41:41 -0800 (PST)
Date: Fri, 21 Feb 2025 11:42:06 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jacob Pan <jacob.pan@linux.microsoft.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>, patches@lists.linux.dev
Subject: Re: [PATCH 0/5] Convert virtio-iommu to domain_alloc_paging()
Message-ID: <20250221114206.GB719702@myrica>
References: <0-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
 <20250211164151.723cfce0@DESKTOP-0403QTC.>
 <20250212125007.GP3754072@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250212125007.GP3754072@nvidia.com>

On Wed, Feb 12, 2025 at 08:50:07AM -0400, Jason Gunthorpe wrote:
> On Tue, Feb 11, 2025 at 04:41:51PM -0800, Jacob Pan wrote:
> 
> > I see the same on arm64 with v9.0, assigned an ixgbe nic via VFIO.
> 
> Huh, I figured it worked on ARM..

Crosvm would be a more useful test because it doesn't implement any BYPASS
feature, but I don't have it set up at the moment. It's not a problem on
QEMU since it supports the BYPASS feature and doesn't need identity-mapped
domains.

> 
> There is no requirement that an iommu driver implement identity, this
> is all an optimization. If it doesn't work in alot of cases can we
> just remove it? It would simplfy a lot..

No objection.  Identity domains are useful if the use-case of virtio-iommu
is assigning devices to guest userspace, in which case you'd want to
bypass the IOMMU for the devices that are still owned by the kernel. But
VMMs have at least two alternatives to identity-mapping (BYPASS feature
and tailored topology).

Thanks,
Jean
