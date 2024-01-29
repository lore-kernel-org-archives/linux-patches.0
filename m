Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861827605A
	for <patches@lists.linux.dev>; Mon, 29 Jan 2024 20:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706561157; cv=none; b=Bhu7n9c48KNJ72L9nffdovTTsowtd7XTJCgLSJMW9YQQpEVMVntNanSWeWzCRMtWI8bvtVuElcW89tY4GD0f4WpPSd05dVtFX/e/WWzu9ipV1vqwzyl2s5akdv54Jg1F6aLnL5RN6kt5OzzghQIzfolLoYlfkiqKivPFOpJN3XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706561157; c=relaxed/simple;
	bh=QEewFaELR8jT5HeqihIe7emzjPRsef1SZlefk2lboWI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hryGLCCj41INbfVpTuqRcK78xx4w0dt4WPhYFENw0zkcmFT0r3xCNJ01yotObXN1WVvzM6RGh5iM3beigrKoXb+JzLmVsNVm7HR0i2Y0SYMELIG8jbJkfmtSryiTqg4cGsOpEBSLl8MMAxAJ4D4id+Y9IDePBLRVxwZfko3VmdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SL//DsUz; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SL//DsUz"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-40f00adacfeso725e9.1
        for <patches@lists.linux.dev>; Mon, 29 Jan 2024 12:45:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706561154; x=1707165954; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2UV3MAZ8RdW/0YVS6qjgV0z5XXsM6lhtJe9UOEZ4rJ4=;
        b=SL//DsUzHw6oawQiVeTh6ytE8Ou0S1+uxcWQtVsFUJStYlUwG1egUajAO0T+kZRO7w
         Ni+hHmk8Osn3hcF1Z9i86FuPCIjy7NFsUpmo4jBH3EbMFpAasENW2mBGH3Ml/8d3GArr
         UAvfQN7fBSvNztxHeafr28TS+bQ1Wq2Rbn3i2XX4zYper1BUYrXEMUQMD22MXS0btge6
         abJGf8v6cpSpJkcLKcRcvKqptomTQiNhzChP6W4E9h+49jvTxoAdUGdaBty5eIXXK+cS
         dTUEAPyzD/y94HR0a3gOMG37JDE38+53nWFq1tAZSCdm82IXUmUMPNDUP061cwsXDagx
         E7sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706561154; x=1707165954;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2UV3MAZ8RdW/0YVS6qjgV0z5XXsM6lhtJe9UOEZ4rJ4=;
        b=SWXdIgYDCZxS0e2Klmknz6CgB6om+yqBS8h9FSz5codumSTVKZ4UwrFZuCLF8C7K7w
         7bY5rRHhNKrWawLXV3BlYaK4e/Bw2li8qxAKSM/ST7cJsQMsTnaiQiGnM4iMXVvoPANj
         mFLDRekT/Kqp0mq5Wbhu1VfeQUwMnP/IYeLIKtYzTjqMcEt2hitbi4/Q9NOT3VppHusd
         TnwlmCDEY0LSNbUbHasoFJSoMKWGVNtWWHTyYGIELdxdGtpzSjaDyRutJ2ReS3xm74P2
         HRYLp7kegLcHtjRxuCQAqsMExwIYG+wrNmWRlUw1JWvplfzZyznJCYCb5ydUBnZUQCM/
         VqZw==
X-Gm-Message-State: AOJu0YyHQmGQDnV2xyIoRRL/CERkRi1zAfBPPm/jEX740WwCAVX9gwy9
	82bqNTLVt+smJn6nx9BgmMGWad5LjtE/JYAApUqXAoWObRkNVqh/SF4gcWF5pQ==
X-Google-Smtp-Source: AGHT+IEVpOHf509H3Rk/eCsw3H2jxU+JiPIn9K2pgQRaGycSddCvc/9A7ZM4kLfBGD0LPRqcsRKq6w==
X-Received: by 2002:a05:600c:4a96:b0:40e:61cf:af91 with SMTP id b22-20020a05600c4a9600b0040e61cfaf91mr30230wmp.7.1706561153654;
        Mon, 29 Jan 2024 12:45:53 -0800 (PST)
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id l22-20020a05600c1d1600b0040ef95e1c78sm2996776wms.3.2024.01.29.12.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jan 2024 12:45:53 -0800 (PST)
Date: Mon, 29 Jan 2024 20:45:49 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v3 00/19] Update SMMUv3 to the modern iommu API (part 1/3)
Message-ID: <ZbgOfek7vvqrUjSq@google.com>
References: <0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
 <Zbf4ySDT0bAMXXwO@google.com>
 <20240129194245.GA1455070@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240129194245.GA1455070@nvidia.com>

On Mon, Jan 29, 2024 at 03:42:45PM -0400, Jason Gunthorpe wrote:
> On Mon, Jan 29, 2024 at 07:13:13PM +0000, Mostafa Saleh wrote:
> 
> > > All parts are on github:
> > > 
> > >  https://github.com/jgunthorpe/linux/commits/smmuv3_newapi
> > I added some comments/questions for this series, but didn’t review it
> > thoroughly as I see the code on github is quite different from these patches,
> > and it seems to be targeted for v4. Do you have any plans to send it soon?
> 
> The part 1 didn't change too, much aside from patch 4, but v4 is already posted:
> 
> https://lore.kernel.org/linux-iommu/0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com/

Oh, I missed it, thanks, I will move to reviewing v4.
> Thanks,
> Jason
