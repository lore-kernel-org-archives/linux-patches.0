Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6501ADFFC
	for <patches@lists.linux.dev>; Tue, 15 Oct 2024 07:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728975915; cv=none; b=REK4tpQwtANTTJ6QvpaZB4q9Br79AwPoeoJyN7L2u7wxfWvbOiRvnFxqkHozurxTlZyJPUkMcjpeOVkNpFLp5GlTgXl2jmTb3VQLnTzZcS5cVsgbegaHQHRppcasb2LOHRI17XzW5az0PhUggondv9r5VL578rzJ7YZ4BAtLhEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728975915; c=relaxed/simple;
	bh=oBC+1HsUohKVIcQAJ+6MB0/ZUctHQtUBhtp+e9sDpvI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FU1iynW3++gTGT/RV0nHW8cPQ/wixdE+MTUhPbVf4gtWWFhzN1XbqZowyKLfZ3Iwb0ONq38Guas1QfQsPxtn/OEhxxRaSbG9OQdPDP8oGQ9vw9b+CDO8OdAXQe6WZjyAAwgNTw2wTMXLbuYhHAI/SH96RdzdM9rykFOuT0DzrPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=q+PCQ8IB; arc=none smtp.client-ip=209.85.222.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="q+PCQ8IB"
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-84fc5aaccf8so1359582241.3
        for <patches@lists.linux.dev>; Tue, 15 Oct 2024 00:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1728975912; x=1729580712; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9S+Y8EgTI4RaVYlHU0odSMHwKx4OEouTcUJBn6Fq/ys=;
        b=q+PCQ8IBoFYxmRFsQk62qoNX4b6S0cM1WHZUk8YVv9h7pNSOjG2sjU+PCf4pYHcFI7
         VEdoyPhq/+x2d0ceW3IcSDEiPASL2spwvspPSs2SwLDxp6AtUuA3djkwvBdFU1Mshull
         dEw6WvB9PtBWWaFbTmyU0izODdT/M//I9T3rqMdrMMUTkfLPL1LZR1SeQ2DlRpeZCOK9
         rVv2bsbx7NZRnYzxwYUx8z+B4EgqTCI0ncSlR883864TbVbsa6wnXrqiK5MgJWCok0p8
         zhNtu7tZx/4QuA//Ps7uArDA4rJj2FrsellaU0WMPcYpoVszQOCh36ZGdfrF6ndTZjKV
         +2+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728975912; x=1729580712;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9S+Y8EgTI4RaVYlHU0odSMHwKx4OEouTcUJBn6Fq/ys=;
        b=JPDY0RIjRnICecepr63bZmiJvPAAkcZyf0qPCeNMMI5EnUkaGWnFKup1ihrSOb/BTz
         o99rC4Lyls36p+qswoAjcG4fOPxM8FfWMe8iwn3++rEPkc6PuRXapZFLJtQbadrc1WxI
         vFARbklVvJBzIqH18zqsVkON8UwZdR2DpjS5N6shbGbl/K5KaRMUliWJwMgcBH04PGvB
         qe+1jH63i4kzNxSYSYagPdqddRMNgCh2XcZNmAgeK2ZZGs2lfBWXxo11Z3A+SLx1USrv
         kDBOBwd70SHtgLegSotZT0ECKWm35+r5P6JA0swWWlgpYD/ZLDt92l7zsl6wb0TdeCKR
         6HXg==
X-Forwarded-Encrypted: i=1; AJvYcCWWMXsBEGZBFUUKPo36bNHrplqrLcId4xHbXi4iMaqf8vJgwnoSPBL105fumU8BmqClEkTvCsYp@lists.linux.dev
X-Gm-Message-State: AOJu0YwZfj7uA6vG8uuBZjwW/Dgn+uc1uNlpRewj4vG8wSjNInrRFlCI
	nXcpoFQEwCMaHkApOwR78YKVkHWQti+iMK1HFfnFFVVPe5saun3ba8oEi2LCYQKRcmZEwRZoefi
	apXpaOzZblIbg5uNwZfIGd9atpvv3lv3MZksHKw==
X-Google-Smtp-Source: AGHT+IHEcqC0X9UrZgnNhMSIO+RyEt/FWn39JNphrOjRmt8okVO8tsYm73/rsHZiD48SNgda7GloKr6sPzvke21V0Ok=
X-Received: by 2002:a05:6102:2ad2:b0:4a3:b2d0:ac50 with SMTP id
 ada2fe7eead31-4a475f4c6damr5693483137.11.1728975911768; Tue, 15 Oct 2024
 00:05:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241014141044.974962104@linuxfoundation.org>
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 15 Oct 2024 12:35:00 +0530
Message-ID: <CA+G9fYsPPmEbjNza_Tjyf+ZweuHcjHboOJfHeVSSVnmEV2gzXw@mail.gmail.com>
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

On Mon, 14 Oct 2024 at 19:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.11.4 release.
> There are 214 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Oct 2024 14:09:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The S390 build broke on the stable-rc linux-6.11.y branch due to
following build warnings / errors.

First seen on v6.11.3-215-ga491a66f8da4
  GOOD: v6.11.3
  BAD: v6.11.3-215-ga491a66f8da4

List of regressions,
* s390, build
  - clang-19-allnoconfig
  - clang-19-defconfig
  - clang-nightly-allnoconfig
  - clang-nightly-defconfig
  - gcc-13-allmodconfig
  - gcc-13-allnoconfig
  - gcc-13-defconfig
  - gcc-13-tinyconfig
  - gcc-8-allnoconfig
  - gcc-8-defconfig-fe40093d
  - gcc-8-tinyconfig

Build log:
-------
  arch/s390/include/asm/cpu_mf.h: Assembler messages:
  arch/s390/include/asm/cpu_mf.h:165: Error: Unrecognized opcode: `lpp'
  make[3]: *** [scripts/Makefile.build:244: arch/s390/boot/startup.o] Error 1

  arch/s390/include/asm/atomic_ops.h: Assembler messages:
  arch/s390/include/asm/atomic_ops.h:83: Error: Unrecognized opcode: `laag'
  arch/s390/include/asm/atomic_ops.h:83: Error: Unrecognized opcode: `laag'
  make[3]: *** [scripts/Makefile.build:244: arch/s390/boot/vmem.o] Error 1

  arch/s390/include/asm/bitops.h: Assembler messages:
  arch/s390/include/asm/bitops.h:308: Error: Unrecognized opcode: `flogr'
  make[3]: *** [scripts/Makefile.build:244:
arch/s390/boot/pgm_check_info.o] Error 1

  arch/s390/include/asm/timex.h: Assembler messages:
  arch/s390/include/asm/timex.h:192: Error: Unrecognized opcode: `stckf'
  arch/s390/include/asm/timex.h:192: Error: Unrecognized opcode: `stckf'
  make[3]: *** [scripts/Makefile.build:244: arch/s390/boot/kaslr.o] Error 1
  make[3]: Target 'arch/s390/boot/bzImage' not remade because of errors.
  make[2]: *** [arch/s390/Makefile:137: bzImage] Error 2

Build log:
---------
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.11.y/build/v6.11.3-215-ga491a66f8da4/testrun/25429522/suite/build/test/gcc-13-defconfig/log

metadata:
----
  git describe: v6.11.3-215-ga491a66f8da4
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git sha: a491a66f8da4fbfc06aedae9a8b0586d11a51fa9
  kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2nQsfudCDSTlwmKIKEozbcVOnCs/config
  build url: https://storage.tuxsuite.com/public/linaro/lkft/builds/2nQsfudCDSTlwmKIKEozbcVOnCs/
  toolchain: clang-19 and gcc-13
  config: defconfig
  arch: S390

Steps to reproduce:
-------
# tuxmake --runtime podman --target-arch s390 --toolchain gcc-13
--kconfig defconfig


--
Linaro LKFT
https://lkft.linaro.org
