Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6974186F
	for <patches@lists.linux.dev>; Fri, 19 Jan 2024 03:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705636798; cv=none; b=YXWdEhFWlO3ZltkF5AD/56TfjHCr94UsPSgc7ivk/AFbaOsjS7v2/hckmzJTGgrmpW5kPy9YOP96PAyT2uZaqjDU+nGkbZbp18aknMlwc2abDap8r9AP0CBGx8QyoeozIkMNqsQ/Y1YErj5Y/VZz3e8s++Rff8Ba7cQMNatdnTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705636798; c=relaxed/simple;
	bh=5e9g7q6Oan2+OiKIu9+bnga3V9sAcKCrfBAEZwF7lOw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m4akZsRnHUt8aV3Z87XR/CNUYA6oidKIIIHOZPSh0WgvYhe658oQzrbwYIHJpahJN+FyTzddMOQJROPi3VwyjS+53PlMma99n79xUrMUzuQ5Ft/Q224w3KmO7pylYz49KfC0P4cknwOgAsyRTLGLn7WeIN5UQDvpMhfnl8gBH+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xmfocvlO; arc=none smtp.client-ip=209.85.217.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xmfocvlO"
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-466fb253b19so839224137.1
        for <patches@lists.linux.dev>; Thu, 18 Jan 2024 19:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705636795; x=1706241595; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TRMPaZA6cVxoYnie+2qHsbMZkkAgDRtDwgtb7B7rVgk=;
        b=xmfocvlO78acrFuGAOkU7hnylpzWIA0w3rurc9tgMcaEXpE0Vh66j11C1JNyCwQELi
         1J6C/uzKh/WyOiv5YZKTaG6H48H/nLJUzrYhOUtC6euvM1iI+4PEL1NevRudtaasYb6F
         Cd9Du+nJqpGttUepD71YWACNvp+upb6jOa+lb35hDnEaymeYP0LUAuJTW0DzIKXQUE1p
         5GafDafkk1MZt5zbTl0ZUFds+MG5TLYlMvKULxdM4xgm/A1Hix2ZU6dZP6z+VUbbkz45
         2ZMPPM0Fdx65Udy8SmC8NKIcyk716or0OnUTRhsElBVmubebQUtPRiJmJP+IV+O5FbC3
         NH0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705636795; x=1706241595;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TRMPaZA6cVxoYnie+2qHsbMZkkAgDRtDwgtb7B7rVgk=;
        b=g4uR8k4fgNQM93j/F1Run1XwOkJCeWKsv7ODCAWqBEdPYbG+AuUDSgifQD5XL5hLfn
         Z+Z06wjveBEuTwCs6KnOD6gl55kYxBcb217rbxwp+FW4oYX3+MS3Lu8lYG4knlU+yt40
         kJWtKdMp1t/EHmeAzHnO2/rgPkzkZ2KpRO7RV0tHrmYwCf+6u+LHFTdpqEEYp4tHwwhJ
         mApIefFVwfnzpcEq46Kwh/i44JWPqyWFu2xw9CUQ8suWZY9ZO2QhJ18gQae5IHgq9Mct
         pS3hl7bSrAMfdDvDMG3EwtEXr1f9FKrYV7HEc6nT8NNVd9Jzw9mdkEmL8kniN4Zaz/gp
         Uf+w==
X-Gm-Message-State: AOJu0YxMxt5NFeI6K2rGIAB9HyTzuG2jujZ9QhVvTySfw/DDvmnkruNB
	/wrVgCb/xkvPfNffZsDB027ekB2wexGeA+V8jnW5DAiv4wFL1B4ZpqKzEMONtzzRwOhtbueBftk
	MgKYddzI3hHU+3qacRVPx4MTqLF3R/pZzJeSrSw==
X-Google-Smtp-Source: AGHT+IGCG1fEx3hI5i+08dvBfYjHvAtAHA4tYqk2WlJ5JI20qJWhK4NM0fjnnykc6i/Fv8eTnpJMKke4sNcnSNQ/Sn4=
X-Received: by 2002:a05:6102:3713:b0:469:93ac:6dd4 with SMTP id
 s19-20020a056102371300b0046993ac6dd4mr267534vst.21.1705636795545; Thu, 18 Jan
 2024 19:59:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240118104320.029537060@linuxfoundation.org> <ab9bef24-a07b-4930-b09a-b3c0f4e04789@gmail.com>
In-Reply-To: <ab9bef24-a07b-4930-b09a-b3c0f4e04789@gmail.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 19 Jan 2024 09:29:44 +0530
Message-ID: <CA+G9fYt3TKtjxV6=CQTwe5mDuYP7JYyFpkUb05StTEx7E4Mk3Q@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/150] 6.6.13-rc1 review
To: Stefan Wiehler <stefan.wiehler@nokia.com>, Florian Fainelli <f.fainelli@gmail.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, 
	rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 19 Jan 2024 at 00:52, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> On 1/18/24 02:47, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.6.13 release.
> > There are 150 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 20 Jan 2024 10:42:49 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.13-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> Same as with 6.1:
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
> Error 1
> host-make[4]: *** [scripts/Makefile.build:500: arch/mips/kernel] Error 2
> host-make[3]: *** [scripts/Makefile.build:500: arch/mips] Error 2
> host-make[3]: *** Waiting for unfinished jobs....

same here.

> which is caused by 1fa03a4622bb26a31279a453aa251154f11e6c70 ("mips/smp:
> Call rcutree_report_cpu_starting() earlier").
>
> It looks like rcutree_report_cpu_starting() has been introduced
> 448e9f34d91d1a4799fdb06a93c2c24b34b6fd9d ("rcu: Standardize explicit
> CPU-hotplug calls") which is in v6.7.
>
> For MIPS, it would like an adequate fix would be to
> 's/rcutree_report_cpu_starting/rcu_cpu_starting/' for the 6.1 and 6.6
> branches.
> --
> Florian

--
Linaro LKFT
https://lkft.linaro.org
