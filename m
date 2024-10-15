Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FA518A6D9
	for <patches@lists.linux.dev>; Tue, 15 Oct 2024 07:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728978618; cv=none; b=qoYIhqwf7Oiv9QxgPuZvGomYzL1zphXdWuSBi5aWTq6IMquriqmvTYY+nI/BzsB7BJH4w/gspsgzjcJBbtphQ5BokSV7kwsTTabRgGP6rZdb8DyawOxf7uf+x41L+cqX1nZ2EsaLiDoTdkC/61WtKFaBwWrCewgNV6qfjdDSMiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728978618; c=relaxed/simple;
	bh=vOa6EcRUks3vJ+gN4gguaBuawT8MdWJj35kDikZazRA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IhAecQVpLTJN9/exe1AOk229nASv9tzl24WIRXDlJNe5UDlvXI+TGDmtwLYsU8TIKu2sZmKdbZHhx2Z9/9txWJXhXS5fwX7aERYqpickGghnvyjCQqGNTTf6dF5Jpwp8WQb02grO7exCd8Ih/x9f/6luD6NhaZBw+e+hj3O6+og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oHUHD78R; arc=none smtp.client-ip=209.85.217.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oHUHD78R"
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-4a47177cf6bso1015788137.3
        for <patches@lists.linux.dev>; Tue, 15 Oct 2024 00:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1728978616; x=1729583416; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pLYLixg5lxjAYGEflgM8mT9I/QjIrhiXb1eT8NYFyD8=;
        b=oHUHD78RopSo2TiOfJ1bCwfi7KF8gMXivHDcvx2L14wln6KVpc/IKBj8ff9q7psj3k
         GqNUZZM4cNCazIZOzUweXE0qjTLbJDjF1pU5umCyb3Huk4kGKFqnL8WXdmQk7lQ20dn+
         ObQIwCAGkbP8/5lwNgO8RAWGOuNV5pBnBr44kClY/M4kjrtxyx4jmgqmaQ5UPotNgDBx
         7j9i8ILoRNwq2SP3nW6tuIGNvzyBQcg0ZF28UsI06OWeUhOH7i7tzGMQdyRz5U5BvReT
         yu+07/cFBKWvlX/cOoXsh570RsmDOXVo0HuYJ0/PB1srSdZFXxscu839pxconGW+01Qg
         5h3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728978616; x=1729583416;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pLYLixg5lxjAYGEflgM8mT9I/QjIrhiXb1eT8NYFyD8=;
        b=im2CijrvUGJGzF076lf5wvpmd+600d2HpW2/k2ypJxiKDsj4KguCqG9oKE+UgDVazF
         s+n6SOAuoQAudCgapma5C9FHq7DpVHxjGuppYNEYKrM3Qm+TN4DHjxlQHGa6chY3Sla0
         d6xOPWgtVHff/OVNxzQxiurD8AavEPZZFbBKez6V7SOChq/TSi25OjvnYSKoe6Cz5xba
         Qir9n6E3bn6R2mL412PZRaW8nn0ZZxkhaxBI3JCTQRssTMPdZZ1cD8/JEs5SEIUWgvOq
         9o/rLnLuOFxxEtYJfaa4AbVjAo4XMquDhkgmLQBzJBh1FdZ/zrxubKTflnbGcu40UWUR
         HwDw==
X-Forwarded-Encrypted: i=1; AJvYcCX+B8vNgSgfsUj8v23dGH0f51oIe+f87NLu1+gCTRVGLeTlmox+IqC2hniZuhH2ivXTm/diKRbB@lists.linux.dev
X-Gm-Message-State: AOJu0YyyIda73XrcTYeKrJXYU21p5rwsC+LwED1JnxFaVOaFod57YyKC
	duW/Ry0n+ibZYzUVF0Dq+Ecq1NneNbHxqVPtzTPt+aUdo6Rwjm8PPFv9caTt1UhJPfpBELQaw3n
	diXSBdVtTzKqAgvC2fJfoRkW3HTI3ALYUr1pcEw==
X-Google-Smtp-Source: AGHT+IHJTQgMwy07yt4Kv3cxeA6jaDdGJW3Q76nXmTxUbWPQyJERX0qrCdD9zyui+kZPBA1VduE7XrCzaRDLLhLgFV0=
X-Received: by 2002:a05:6102:3913:b0:493:bb35:d8f9 with SMTP id
 ada2fe7eead31-4a475f0bc31mr6236860137.5.1728978615788; Tue, 15 Oct 2024
 00:50:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241014141044.974962104@linuxfoundation.org> <CA+G9fYsPPmEbjNza_Tjyf+ZweuHcjHboOJfHeVSSVnmEV2gzXw@mail.gmail.com>
In-Reply-To: <CA+G9fYsPPmEbjNza_Tjyf+ZweuHcjHboOJfHeVSSVnmEV2gzXw@mail.gmail.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 15 Oct 2024 13:20:04 +0530
Message-ID: <CA+G9fYvpCw4Dh5BhKjS4bsWix=i=koK6Kw_jU=9zSOFu-UePBg@mail.gmail.com>
Subject: Re: [PATCH 6.11 000/214] 6.11.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Heiko Carstens <hca@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Thomas Richter <tmricht@linux.ibm.com>, 
	linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 15 Oct 2024 at 12:35, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Mon, 14 Oct 2024 at 19:55, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.11.4 release.
> > There are 214 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 16 Oct 2024 14:09:57 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.4-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h

[Adding Reported-by: ]

>
> The S390 build broke on the stable-rc linux-6.11.y branch due to
> following build warnings / errors.
>
> First seen on v6.11.3-215-ga491a66f8da4
>   GOOD: v6.11.3
>   BAD: v6.11.3-215-ga491a66f8da4

This S390 build regressions are noticed on stable-rc branches
 - linux-6.11.y
 - linux-6.6.y
 - linux-6.1.y

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

> List of regressions,
> * s390, build
>   - clang-19-allnoconfig
>   - clang-19-defconfig
>   - clang-nightly-allnoconfig
>   - clang-nightly-defconfig
>   - gcc-13-allmodconfig
>   - gcc-13-allnoconfig
>   - gcc-13-defconfig
>   - gcc-13-tinyconfig
>   - gcc-8-allnoconfig
>   - gcc-8-defconfig-fe40093d
>   - gcc-8-tinyconfig
>
> Build log:
> -------
>   arch/s390/include/asm/cpu_mf.h: Assembler messages:
>   arch/s390/include/asm/cpu_mf.h:165: Error: Unrecognized opcode: `lpp'
>   make[3]: *** [scripts/Makefile.build:244: arch/s390/boot/startup.o] Error 1
>
>   arch/s390/include/asm/atomic_ops.h: Assembler messages:
>   arch/s390/include/asm/atomic_ops.h:83: Error: Unrecognized opcode: `laag'
>   arch/s390/include/asm/atomic_ops.h:83: Error: Unrecognized opcode: `laag'
>   make[3]: *** [scripts/Makefile.build:244: arch/s390/boot/vmem.o] Error 1
>
>   arch/s390/include/asm/bitops.h: Assembler messages:
>   arch/s390/include/asm/bitops.h:308: Error: Unrecognized opcode: `flogr'
>   make[3]: *** [scripts/Makefile.build:244:
> arch/s390/boot/pgm_check_info.o] Error 1
>
>   arch/s390/include/asm/timex.h: Assembler messages:
>   arch/s390/include/asm/timex.h:192: Error: Unrecognized opcode: `stckf'
>   arch/s390/include/asm/timex.h:192: Error: Unrecognized opcode: `stckf'
>   make[3]: *** [scripts/Makefile.build:244: arch/s390/boot/kaslr.o] Error 1
>   make[3]: Target 'arch/s390/boot/bzImage' not remade because of errors.
>   make[2]: *** [arch/s390/Makefile:137: bzImage] Error 2
>
> Build log:
> ---------
>  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.11.y/build/v6.11.3-215-ga491a66f8da4/testrun/25429522/suite/build/test/gcc-13-defconfig/log
>
> metadata:
> ----
>   git describe: v6.11.3-215-ga491a66f8da4
>   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>   git sha: a491a66f8da4fbfc06aedae9a8b0586d11a51fa9
>   kernel config:
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2nQsfudCDSTlwmKIKEozbcVOnCs/config
>   build url: https://storage.tuxsuite.com/public/linaro/lkft/builds/2nQsfudCDSTlwmKIKEozbcVOnCs/
>   toolchain: clang-19 and gcc-13
>   config: defconfig
>   arch: S390
>
> Steps to reproduce:
> -------
> # tuxmake --runtime podman --target-arch s390 --toolchain gcc-13
> --kconfig defconfig
>
>
> --
> Linaro LKFT
> https://lkft.linaro.org
