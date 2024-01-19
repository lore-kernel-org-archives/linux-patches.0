Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B8017F0
	for <patches@lists.linux.dev>; Fri, 19 Jan 2024 03:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705636382; cv=none; b=lUa5Y41BuX4FH6j9C8A6BwBKwxI77wlpJ9jc4/uyfyuAhwF4esw0TtN29AVwqq7YWkauW/HwyeK0l7R7RyeViYR5g9Ht6kQRi3zIYjQP3UXFdADUq1yq9uPeRzxdmuMIkUY5pFHm2RPPZBDV0DtzaopzF6MOwh2AIOMulOgb9Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705636382; c=relaxed/simple;
	bh=mo8c6Bmp42CGWSM8HU8elamRn6AuuJjgecJ+w6iel0w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FuPRl0SXOOv2iRs43xkSFSPDluJSbHSjbgPtCKf9RP4Vv0yWLMc9MDrSxRW23+oSp+jcuZrydgb1gzIvqwV6p/cFr4g4nugeu6Yz3/mMX4bMJO90A9m2DOmBJUwYGN7oUw4cZWe6wSofpnY4C5HeasPAirKK8dMxGVOVCyS6nes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UJEhQEse; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UJEhQEse"
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-4b79c5d035fso97983e0c.0
        for <patches@lists.linux.dev>; Thu, 18 Jan 2024 19:53:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705636380; x=1706241180; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=u3/2Z2xESJ2KA2jr25zZLyl5xbY/16kqULi2iZR1W8M=;
        b=UJEhQEsegBIy38VEjhWLf3hckbrrhIjq8P1AlAihvbludo4K3VPV1XctJnESXKcIZb
         eK+9XNzlBCaajk44092yuUjdHq0GyOTSU6QnNo4+4WVresuQ0Ipt3kO5AdwxamqmNIOL
         cy1NIiDx/O77AQGJUgYubZHdkECHyyQx/SEbZuzQOpGvF3kv4b5zxaqjGqjqd30k7rHp
         9lzeFY5gt5FjDyN6+hkTjY7X1qaYwbxyq5UahTCMq/pw569bagX14T7wJ3SvoSlS98FE
         16tKJ2LpWbTsrvib9xvWWY8N//FMjjzFQ2IlT0J/VQxMk5jFlCxt7kwoI99OSB5jo1cQ
         tVwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705636380; x=1706241180;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u3/2Z2xESJ2KA2jr25zZLyl5xbY/16kqULi2iZR1W8M=;
        b=dg8RPzarqQg9IsSqqc+NyQNeYFznWNT4+24e1f+QvSV1ABXAJ8J7NJ2U8dxUR4PVf0
         uxqCXKT59MgV6SAmCETVI0y0g4V8ZVwEnwgtArk3FxGML8ZsYeX38WyMwBuFv3zs9vPl
         pR5suE0qrymJPU2Qh6b+rkPmhQ57dVuOY4shVSLeP7QyFYnrcO4wajFONaLy8JimdeOS
         TPZ/cj4irWx9LdkyVrj+YmqbxbR+FcInjjpJ9B6bmrUL77uvdfXAoQSmxCcYG73IrJW5
         iT7IdGZ0amAs/DeSxfz9rQx1I66l04XaNNDQaV4ksLnTcguJtzI+h1Fa3DFjHD6I5p/e
         sBZg==
X-Gm-Message-State: AOJu0YztmRkv8xnLt+EINnHnYRB2l2iXrp3cNseRhqPHJP5MnQLxiOrb
	PxOI2gd/b6uUlKaUdwkWkSz9gPlL3gLnuQVPgQI39uU9s2CIyVqOskcCTxHRUC9xR05grGqYJEk
	6Kx49dpuV32EUDoZHA1e7H61aeXrSA+aCtdsUvA==
X-Google-Smtp-Source: AGHT+IFBn8+Y0RhN4QAWZqaCdFNIKah+oo28LokVMtCcQILvtRlHxw7vlb1tQmANN+LKttZN0RO9KtqOFtkXRHgAV0k=
X-Received: by 2002:a1f:7cc7:0:b0:4b6:f254:b234 with SMTP id
 x190-20020a1f7cc7000000b004b6f254b234mr1543594vkc.32.1705636380096; Thu, 18
 Jan 2024 19:53:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240118104310.892180084@linuxfoundation.org> <96dc2b0b-ad51-42f9-a305-744d9d97272e@gmail.com>
In-Reply-To: <96dc2b0b-ad51-42f9-a305-744d9d97272e@gmail.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 19 Jan 2024 09:22:48 +0530
Message-ID: <CA+G9fYvviOww1sOPxZDJR471TUhu+Brgv-k9YqKP_mb++Ek9GA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/100] 6.1.74-rc1 review
To: Stefan Wiehler <stefan.wiehler@nokia.com>, Florian Fainelli <f.fainelli@gmail.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, 
	rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 19 Jan 2024 at 00:40, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> +Stefan,
>
> On 1/18/24 02:48, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.74 release.
> > There are 100 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 20 Jan 2024 10:42:49 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.74-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> ARM and ARM64 builds worked fine and passed tests, however BMIPS_GENERIC
> fails to build with:


Following MIPS builds failed on 6.6.y and 6.1.y
but passed 6.7.y and Linux-next and mainline builds.

mips:

  * build/clang-17-defconfig
  * build/clang-nightly-defconfig
  * build/gcc-12-allmodconfig
  * build/gcc-12-cavium_octeon_defconfig
  * build/gcc-12-defconfig
  * build/gcc-12-malta_defconfig
  * build/gcc-8-allmodconfig
  * build/gcc-8-cavium_octeon_defconfig
  * build/gcc-8-defconfig
  * build/gcc-8-malta_defconfig

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

>
> arch/mips/kernel/smp.c: In function 'start_secondary':
> arch/mips/kernel/smp.c:340:2: error: implicit declaration of function
> 'rcutree_report_cpu_starting'; did you mean 'rcu_cpu_starting'?
> [-Werror=implicit-function-declaration]
>    rcutree_report_cpu_starting(cpu);
>    ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>    rcu_cpu_starting
> cc1: all warnings being treated as errors
> host-make[5]: *** [scripts/Makefile.build:250: arch/mips/kernel/smp.o]

same here,

>
> which is caused by 7c20a4cc189eff36d5aeb586008a540d8024fbff ("mips/smp:
> Call rcutree_report_cpu_starting() earlier").
>
> It looks like rcutree_report_cpu_starting() has been introduced
> 448e9f34d91d1a4799fdb06a93c2c24b34b6fd9d ("rcu: Standardize explicit
> CPU-hotplug calls") which is in v6.7.
>
> For MIPS, it would like an adequate fix would be to
> 's/rcutree_report_cpu_starting/rcu_cpu_starting/' for the 6.1 and 6.6
> branches.
>
> Stefan, do you agree?
> --
> Florian


--
Linaro LKFT
https://lkft.linaro.org
