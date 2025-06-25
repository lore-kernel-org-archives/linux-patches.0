Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A121E87B
	for <patches@lists.linux.dev>; Wed, 25 Jun 2025 01:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750815939; cv=none; b=FvH0D7bcw+wRY7JrNpmUyprWfdoPUp0dAhrvIWPApfmwQCCUuEB5uxz4wDNhmU7HJk07wftXOSW4EterESFfxwQ9ciws3F/Ymk0eu0Wf4EPBpEoHNd+y3fozXq6AiD+4agKmldNk49B8RN0jeGJ2pmGfPa8DxRuDfMa9qcfv3BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750815939; c=relaxed/simple;
	bh=2zBoULgm03Dwl2J+U7HJ4pssYFLjwhSqOKEIgLREwF0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cinBn38ChvpSsU5iQ2odh+6mEsVCNfauUqz7FibTpmzUXNyRDdPKK+y1fI0yLs++BOtBvJA/a3nG0WvoIPeCG5NSN4hlEwkeo7k9w1Um2b5U67xpP8WGBM83djuTXpCH/dnHL8n5haLVpENytCQbtJqZ1M4xE3O+s7ccNzxkE8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=s1U/MUSn; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="s1U/MUSn"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-313f68bc519so4544035a91.0
        for <patches@lists.linux.dev>; Tue, 24 Jun 2025 18:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750815937; x=1751420737; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=n32Ce14vCqr9g7FIDP6NZp2SFABeqo2yehV//w/3vO8=;
        b=s1U/MUSnrb78OxzOFm5bUm4u+ILCO3Q9FnpIuY/3/zzBszydvtf6kOPKBRRxNsgekL
         Ao9yDrL76yfGbErChgZ9Hw9y9SFcD1iRQiCcB/rOEuB3+HIm+CqGMP/YSj3Ykhx8X8gx
         /pmW4Bm2/TTMaMalOS0PUAyUuW9soyOp91DMOhGr2LVQUJ+bl1t1tCItfFf9Wk0azy06
         Mai6Hg5qywhq/J9CHnLBUbgidumhROrsJk7vmYIYCNygnxqZv8HtashqBwyD1NSXMfKy
         FQdw8a7+d/q/mVZGvyj+oyjl87B2XrqQI3kSaLtdachRY6mQH6btA6v1bK7sLFnQ2HvW
         RjzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750815937; x=1751420737;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n32Ce14vCqr9g7FIDP6NZp2SFABeqo2yehV//w/3vO8=;
        b=ruPOyFmHu/MVyZlPHr13g12ZUPIXnvbEjUaKKLbcf5wVubthwe6McUJNLnS4yBWu+e
         nWcOMqktdGE8FRjFJLvp/L/7Hq5gqEfKsMFRKUjEbIVnftFSAKumWP6ThD5+qSglE0Mt
         UHSuFGU0YIaweKWHa7HGL+Q/sWf4Lk8SqL3hzXO5HVYHxYLIGHUyO8B6RiuLpTTEWYNp
         ddSwmZBM8Hatsb4te9Ss9KySc6g+DgCbdCY9tBKWRPlEYf7E0S7ovcaF2hmZ8qiijmFa
         tt+6c8brbkMn0RG3ghgybfeSBs55ul5HIBfHwk62GNHrio0O9KTEuq+NbHwm3DskGHAu
         335g==
X-Forwarded-Encrypted: i=1; AJvYcCWFgWQ6FZQeZNqnTb7GZhdvprlcrWk14gp+neCyfnwiinmYa032ll6r7qsFUrvK4eoRW1hGWGu+@lists.linux.dev
X-Gm-Message-State: AOJu0Yx3vKcZnABIxTyMe0Aeb3DVp+EFLg6vf2s8II43jZ4FuN1sX64i
	5CXD7Ug/i0KvVLwACXwUy0zpHbjca+f5zL/HQYSNRjuXxacRJoyfgr6/KT59hUwIzTuSZDwF//4
	HivJoh7IWMoytNxPNohnNGgC5zQuFToIFGQUBOw4ekw==
X-Gm-Gg: ASbGncvHqS87L6qKrYnxO2dltkb394pp5GKwOJn53ROfxlzxRulndDAcDM8baQs9iDO
	mt3JjW7BjFCxJjUSWThfir6d0HqWG4JZCtm6HrJAoKmUQygv1K0fMKCuDiMBf4du3IULKNs2Fyu
	n64IL+2eDM4P5mU9tIp6AyCYdpxZoba+gmo1lZC1BvWFC75RIy02HgKtvu+8VD/e+I5QG2ACMjh
	OCt
X-Google-Smtp-Source: AGHT+IEZZrjLJfPFgFgffQ9aiYWL3xtkwNj6XtyL+U8CZwF0zuyVUsKj+smjdUpouvDzUZibEu7iucvZo4MMreOA8eU=
X-Received: by 2002:a17:90b:4a0e:b0:313:287c:74bd with SMTP id
 98e67ed59e1d1-315f26b8a00mr1754310a91.33.1750815936613; Tue, 24 Jun 2025
 18:45:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250623130632.993849527@linuxfoundation.org> <CA+G9fYuU5uSG1MKdYPoaC6O=-w5z6BtLtwd=+QBzrtZ1uQ8VXg@mail.gmail.com>
 <2025062439-tamer-diner-68e9@gregkh>
In-Reply-To: <2025062439-tamer-diner-68e9@gregkh>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 25 Jun 2025 07:15:24 +0530
X-Gm-Features: Ac12FXwfYJX4c32g79VHYXDiATL5pbXpMHEnfwCL6cyaQQoQ60FwmMr-U4O_s64
Message-ID: <CA+G9fYvUG9=yGCp1W9-9+dhA6xLRo7mrL=7x9kBNJmzg7TCn7w@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/411] 5.15.186-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Russell King - ARM Linux <linux@armlinux.org.uk>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, kees@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 24 Jun 2025 at 15:48, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Jun 24, 2025 at 02:12:05AM +0530, Naresh Kamboju wrote:
> > On Mon, 23 Jun 2025 at 18:39, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.15.186 release.
> > > There are 411 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Wed, 25 Jun 2025 13:05:51 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.186-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > Regressions on arm64 allyesconfig builds with gcc-12 and clang failed on
> > the Linux stable-rc 5.15.186-rc1.
> >
> > Regressions found on arm64
> > * arm64, build
> >   - gcc-12-allyesconfig
> >
> > Regression Analysis:
> >  - New regression? Yes
> >  - Reproducibility? Yes
> >
> > Build regression: stable-rc 5.15.186-rc1 arm64
> > drivers/scsi/qedf/qedf_main.c:702:9: error: positional initialization
> > of field in 'struct' declared with 'designated_init' attribute
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> > ## Build errors
> > drivers/scsi/qedf/qedf_main.c:702:9: error: positional initialization
> > of field in 'struct' declared with 'designated_init' attribute
> > [-Werror=designated-init]
> >   702 |         {
> >       |         ^
> > drivers/scsi/qedf/qedf_main.c:702:9: note: (near initialization for
> > 'qedf_cb_ops')
> > cc1: all warnings being treated as errors
>
> I saw this locally, at times, it's random, not always showing up.  Turn
> off the gcc randconfig build option and it goes away, which explains the
> randomness I guess.
>
> If you can bisect this to a real change that causes it, please let me
> know, I couldn't figure it out and so just gave up as I doubt anyone is
> really using that gcc plugin for that kernel version.

You are right !
The reported arm64 allyesconfig build failures are due to,

  randstruct: gcc-plugin: Remove bogus void member
  [ Upstream commit e136a4062174a9a8d1c1447ca040ea81accfa6a8 ]

- Naresh

>
> thanks,
>
> greg k-h
