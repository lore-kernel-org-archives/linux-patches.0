Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA94213440D;
	Wed,  6 Mar 2024 14:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709736905; cv=none; b=ATp5jkirhBUFjowzS8s9gvht/o+vyl/W99RTD3ZKkvVloy7tITNdvpR22/TtJTBhKjtRZmvWvHABCALC9vR53ZC0X+nXdtvnjzI4nJqXuNdYwFXhGy39wbGo0qY4QbPM9oQiu1MLTMHJuDItc1p5P7CQTK41hI9euwt6Em4FbBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709736905; c=relaxed/simple;
	bh=nNpO6ESIQuWNHV3anMdBB0uTpqzi1/v1tY6k8m6q5S0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K6rroyOxnsIGBkVJ05Q33522glBVBfBa4+om36zIj4nJOORObgb7xbL+pSiyAZ2F4hvvsq8ly6PRQPq+jnnSqLZrgJCOdRAkebav9sRopOwptl6TzvaRDv3pA1uehGV8mZiISOrOEOAs2b4TSNxlg+0oHdlEyC1EE0FnbEXqC8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ND6ZOgXl; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ND6ZOgXl"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-29b7dbe39ccso244153a91.1;
        Wed, 06 Mar 2024 06:55:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709736903; x=1710341703; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kNsQrzui79q+RpiAKCUg2sUg0iqLQRE/fhXeQe2h8Ek=;
        b=ND6ZOgXlpM+mzKyllv1jqwaJtl55XJ1tcO7WHo5/l2nsmVH7i2ldY4a/Qz+pZz6ydH
         lx7BmzppdofPA/6aIXb67vAWicLyw1BO6IYFrbHYnH1suoxh+x/pdiA93PasxoZHDrM+
         y+BSbwPp6NWbIgl0biT/C+POSB9qhQ4Mejp+ChsBgb0ishE5oLpgeAEWYzIPrWh0kvdQ
         UZJ1D/0qRqp+fgQgPoviRVpsBTQM9mERFW5kw/OX6u1k+f+UCZ74KcLsn6tc9Pe/8Swd
         afzgKYhgEgJvycj+zE2Ylgag6uS06ribPEFLYkdUAxXDkfm3DhH+V7nvk1pCdfiJUgPD
         liGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709736903; x=1710341703;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kNsQrzui79q+RpiAKCUg2sUg0iqLQRE/fhXeQe2h8Ek=;
        b=jH2kvBMGSeRGZemZhHV+G2D7k0Cq/idSsnQhz/NoZx/NS2uL6CT8gyOU6wyQDrq/EB
         0GPsr02OxW5ovMNFkC0qBP5KUTW1NPFQsI/yOgDUfhErI1ejuEjcWlZR4MtzRC4d5rFv
         KJbOSMl1aQzVIzq3bx3mduxgI2rh8jufDct5cXLAqNj8K/C2Y203pSucKUdw8mBjVGN9
         3faeW3lg+gL0TXHHTaRSkZ7LF330KNLnoKqeczBId/8msEvfUm8odcZ8qKqhJ20poJ7i
         reY056lA7EAETmyxrKMWTd8NaGQUjYH6XQbmuOfkRdJIKqDy/Q5i5Cs+OVDSHhhORYd2
         Hmmg==
X-Forwarded-Encrypted: i=1; AJvYcCV5SWRzyREt19Q4WrnSxvHwqduj/PJcpH3X649lDDST1wVP1QHPt4x7XTZ5F/GXc45+BqcnFIN1VLXKJbGxMYurXkdM/Pg3SFPvNkbwzCfRV60psrcYHCYUQikxjnCP
X-Gm-Message-State: AOJu0YxK6TvQUQqpFRwFBPPfxH9ptkQSD7GJyJuyVuHH2qjUhe4eVB30
	rCFbiYFvBrUHyILILBp/YAZGDJlKOLTIfFzwVKxcnbfM7ZFEHrvZGOyhkTvR3Wbk50HHZiQ5V6N
	5PGsP4NpQ/rP1BvCUX2Edd5UWvDQ=
X-Google-Smtp-Source: AGHT+IH+SzGwawUqge120mvgXtvy59eTBMFCd0+4qfzbDoCxlgbUsEiqbq5q/j9OyqS4I31oiXEXizOmvUgy+fJ0Hqw=
X-Received: by 2002:a17:90a:9f87:b0:29b:7f85:db2c with SMTP id
 o7-20020a17090a9f8700b0029b7f85db2cmr719232pjp.12.1709736902964; Wed, 06 Mar
 2024 06:55:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240304211551.833500257@linuxfoundation.org> <20240304224813.73380-1-sj@kernel.org>
 <CADo9pHi0az-CL_hktmpCVcuoiDaUJn2U208=TwAvBM6YQhfFqw@mail.gmail.com> <2024030653-reforest-gauze-149e@gregkh>
In-Reply-To: <2024030653-reforest-gauze-149e@gregkh>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Wed, 6 Mar 2024 15:54:50 +0100
Message-ID: <CADo9pHi0OqBgMsVCf-QaUea+x1viiXHJp+rGn3Jie5noEHv49A@mail.gmail.com>
Subject: Re: [PATCH 6.7 000/162] 6.7.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: SeongJae Park <sj@kernel.org>, stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Tested-by: Luna Jernberg <droidbittin@gmail.com>

Den ons 6 mars 2024 kl 15:52 skrev Greg Kroah-Hartman
<gregkh@linuxfoundation.org>:
>
> On Tue, Mar 05, 2024 at 12:05:33AM +0100, Luna Jernberg wrote:
> > Works fine on my Arch Linux desktop with model name    : AMD Ryzen 5
> > 5600 6-Core Processor
> > after the Arch Linux manual intervention for new mkinitcpio settings
> > and version in Arch
> >
> > Tested by: Luna Jernberg <droidbittin@gmail.com>
>
> Nit, this should be "Tested-by:" without the ' ', otherwise our tools
> will not pick this up.
>
> thanks,
>
> greg k-h
