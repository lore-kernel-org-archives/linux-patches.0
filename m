Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F8D1AF4C1
	for <patches@lists.linux.dev>; Thu, 12 Dec 2024 19:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734032901; cv=none; b=XABo07cDISyLCBWKNinj1Yl8stN7lSq1LjbbYLsEzIqqBmSlM/6Hd5jBW74eS6zNq4rnnVkCcZ0594/iCuWr2Aoh4bG2UfVq4j8OS92+IOeIOF3aY/8kCcIgng+DgmAIlLuOs+KFI4wF0Unr5QEgpJJuVdry80/t15RH7FdZWcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734032901; c=relaxed/simple;
	bh=IczXGAF+eM1R/n6n4f5k72EKL4WE9hhqzfJUbDYrWKk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kzHbCZND0uprC/zPcyuCyEuweK11lDm4iTOJCZRqjk3gzhKTyx55NmYUFNBPB8aSawEyU9sHe5h/4x/HLe3BZjMYcSC8+YkLMZrpHH7JV6DT2I7l8FXTXfDyUg/4W+rsqJ38+hSkRSehDx+vxNVmaDDHGJtIcreXpTy0Lz82/i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=I6rGxQ8d; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="I6rGxQ8d"
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-5189a440a65so488104e0c.1
        for <patches@lists.linux.dev>; Thu, 12 Dec 2024 11:48:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1734032899; x=1734637699; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BlbbI/g+hRuUgF8qGy3bJAgo11Dj0VWxvIagMZzWOus=;
        b=I6rGxQ8dwV9WcK1+oisAJoisisTpKc35Lq7e/tktEu2iHxcziyzNzfm+zyNfGhB2Fm
         4hQlcouEx/uV6BKDuIEeCESPCHWgrjz+3DO0UtoIe49zuvuPKCFJcHfF2wdISkEW3fNg
         y9SWrDUJvsDBz2RiQ+oMPrl5Od1sLWGW6YhXPRqioXsafg6ulGQCbrIXjGgM1rMaopxv
         RWEbjyW3kUsGTgM7EOPo/39TEMK1SL07+pJMupvftc/BubeDJ/HoqGhavZGP7l0hfF3w
         A0sggtfSpzOBST+MTInqIS/GCw7jPzsy3sm17GyjmWg/aHgWnwlR8KcxuIGzClWjmJP8
         zx2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734032899; x=1734637699;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BlbbI/g+hRuUgF8qGy3bJAgo11Dj0VWxvIagMZzWOus=;
        b=A5s3s5OjUyhGOyVjdjNvW5xerfqekdmxmCuH1JeNuqbhH322MtSWZuOMYuw5du+xLT
         EXHOcUIVf1Iy+ABjCog0upveh//q5zBZeHgYj18wJnmNesUaP47SlOVrBX2GF1klzTSx
         JMeEdZ5SU1bU91JLxGf6T+fvvT4yaUo6pOdNSlJU2VLb4+EhEwefuXl3gvBh+GQogII3
         tXwF15sMp0Dr7f5wR26cYEROt29CfCYAbdQB/PUVj90gjqabDwss6/B3Z8Gv9SjgYoi4
         7wExM0zeJBRicQ8IPhzwOvz4r+KZgICV3xDcQzPNCA34f2dg0YSBNWVXqkrFQzOmHPOs
         nBLg==
X-Forwarded-Encrypted: i=1; AJvYcCVBNLR3ING3SLd0qW5Zy8Je/TBmJsHYQ6CPuy6ZZZJmuhyBcPNYE9rDFqSdCuGryrIyAlBv6BCE@lists.linux.dev
X-Gm-Message-State: AOJu0YxTpoiLrq8/yj35Rbdy6FskErau6vBH5kXl5c7rPW8x99m+ZDq8
	4SW5ETnniIGCyUcjXMMIB/sYq30bbLdVPKSABdtUcpVlBDVSMjnvx4MqJhfO5MFR1qkQhL3oRu/
	tI4u1Jvbe5KUVqpCoVvl261KRu5X73zs5nIKRCQ==
X-Gm-Gg: ASbGncv8TabzHfr0h9Gq0cXtNzqAy4EIcO3Yljr10/Z/OZXK7mqPnEf3fZi2+CB9GJC
	RMNUSngGC1sTqRN+W5VTjuyfjHD6xxOOS8KJ3
X-Google-Smtp-Source: AGHT+IFBe0k1ufkZG205NB2FpxYW8UXDiGTPL48pwGMQjlmQbagnb8MkD4Y4QDURyIAwIg3y5dWgFpLofgO5GFaugWY=
X-Received: by 2002:a05:6122:8c17:b0:515:d032:796b with SMTP id
 71dfb90a1353d-518ca48a3d8mr68111e0c.11.1734032899050; Thu, 12 Dec 2024
 11:48:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241212144306.641051666@linuxfoundation.org> <CA+G9fYuX2BsEOCZPC+2aJZ6mEh10kGY69pEQU3oo1rmK-8kTRg@mail.gmail.com>
 <CA+G9fYu3SmdFKRkSDU0UV=bMs69UHx8UOeuniqTSD9haQ2yBvQ@mail.gmail.com>
In-Reply-To: <CA+G9fYu3SmdFKRkSDU0UV=bMs69UHx8UOeuniqTSD9haQ2yBvQ@mail.gmail.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 13 Dec 2024 01:18:07 +0530
Message-ID: <CA+G9fYvV21_-3QYWh_gmKMRZ89AYn-KM99DbmghsLQJEL2+4Nw@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/466] 6.12.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Thomas Gleixner <tglx@linutronix.de>, John Stultz <jstultz@google.com>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Arnd Bergmann <arnd@arndb.de>, 
	Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 13 Dec 2024 at 01:04, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Thu, 12 Dec 2024 at 23:35, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > On Thu, 12 Dec 2024 at 20:30, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 6.12.5 release.
> > > There are 466 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.5-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > The riscv builds failed on Linux stable-rc linux-6.12.y due to following build
> > warnings / errors.
> >
> > riscv:
> >   * build/gcc-13-defconfig
> >   * build/clang-19-defconfig
> >   * build/clang-nightly-defconfig
> >   * build/gcc-8-defconfig
> >
> > First seen on Linux stable-rc linux-6.12.y v6.12.4-467-g3f47dc0fd5b1,
> >   Good: v6.12.4
> >   Bad:  6.12.5-rc1
> >
> >
> > Build log:
> > -----------
> > kernel/time/timekeeping.c: In function 'timekeeping_debug_get_ns':
> > kernel/time/timekeeping.c:263:17: error: too few arguments to function
> > 'clocksource_delta'
> >   263 |         delta = clocksource_delta(now, last, mask);
> >       |                 ^~~~~~~~~~~~~~~~~
> > In file included from kernel/time/timekeeping.c:30:
> > kernel/time/timekeeping_internal.h:18:19: note: declared here
> >    18 | static inline u64 clocksource_delta(u64 now, u64 last, u64
> > mask, u64 max_delta)
> >       |                   ^~~~~~~~~~~~~~~~~
> > make[5]: *** [scripts/Makefile.build:229: kernel/time/timekeeping.o] Error 1
>
> The bisect log pointing to first bad commit,
>
>     clocksource: Make negative motion detection more robust
>     commit 76031d9536a076bf023bedbdb1b4317fc801dd67 upstream.

This issue was fixed in the upstream by adding the following patch,
  timekeeping: Remove CONFIG_DEBUG_TIMEKEEPING
  commit d44d26987bb3df6d76556827097fc9ce17565cb8 upstream

- Naresh
