Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AEBB1C8767
	for <patches@lists.linux.dev>; Tue, 15 Oct 2024 08:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728980495; cv=none; b=SE7bDTi6O4c8WRfbdaqwvXhFujsQKlCinzJ9ohKokCHwn1TPPygze1Li7kAXIvscxuQ5IYxoqc8ucBFRrOv7/4wm78L9oqxcAI1uXgrZI1DxT8RTEw+xBUoCLn0rKPx7kWBj7YNKWcgr/J0Zc1uBw05I81TCjAntKGSIV8o38vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728980495; c=relaxed/simple;
	bh=zD3HmgW+TlfcyOvp2QLRv/48BOBk+PPPEeanN3RBWTE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R0goq3RoBpsi3vi/E7U8qqWSue3FgfQfwPKlb1TWuYMm0hDvcJvwZnVOhQgJBvFaWt8vGXQyZUK+RzZteyriozSIYMiEPUZazaeTqpfwixQuL5nI+brESZrL+IPiUBQlRi1T1wsIdEtCZceCKlqn17ZFKi0o9mmaXdmN+TOqsuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jGhd/OyX; arc=none smtp.client-ip=209.85.222.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jGhd/OyX"
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-84fb533bb9bso1100325241.3
        for <patches@lists.linux.dev>; Tue, 15 Oct 2024 01:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1728980493; x=1729585293; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lW8e1d56O5rgpMPsi4Gluv5d8nw+f0Vj8iqFfuuPxRg=;
        b=jGhd/OyX94FBZ+mtorKuju7uguW9h/3xP87WQ7LUdW4x0u31xfgKiiZ/yi1JCvaMKY
         31nb6m+y68QmyRo5GGCb/D438aT3IwFv5Lg8eMDLoqQqijMZqCD3B5DBqHF0fy+qIwTN
         2XEwEBF3L46s8I1e9WfVzrbMkCkA77RfADlCfIVxTlOWgNvUN4Pb6Lo03Y8ugr5faQqv
         vklwXxRyHVv6cb7QpvCpQkh7TTmo0CwREae9rrKtYqZHPM20pju+VfXSMBxV95wf3l6C
         pL+rqhGJqgE0oRhPpKFzt/1oU8hG0Bj1v5L5mqXpqmQL09Dsrd8EATGAz694PBaVafBB
         G5+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728980493; x=1729585293;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lW8e1d56O5rgpMPsi4Gluv5d8nw+f0Vj8iqFfuuPxRg=;
        b=KhQjpGMLUwk/PMj3CUEOzwqDz6UBpwp2EalFnh28q5W1v6Eg5luIhZ/jiaY1ZFW9PH
         N5YVlyIvFeF+hXpFuBK9p2o8Q3BRf7bOjHnjWpfPhmNe20eG+oHAl7rQ2fBHdI8DZOJ2
         QqdFJU1KMce/LigJlsrcokQfukNvdGIl1rQIiuZX7al6+iQvkRddcnkXB/tgxflxm4lY
         Ois8oc8vyYXQsguFYPmGg2HwVr2HgElfnrSFu7Kx8QItVUWTkw1YQnAAjwM8P7ZXtp0e
         ptoi5XR9pMcmbP2rJ2Rfc5zLAKOUZ9j2dwGn+KZgoM7UvEav+ti0JNBA2y7Vhrds0jwt
         5sLw==
X-Forwarded-Encrypted: i=1; AJvYcCWKZXUiCFsSTQtbqxt9mr8x6h086SslA2OpTuBQwYCBTFXow5SUnsXFii7P5IwleQqSmAKpLJap@lists.linux.dev
X-Gm-Message-State: AOJu0YxzM/zMAFHjPy9/T5qcuxJxTLf933H/NvWAcZpORmHwMIXtimdi
	h7GfDuDRzZhs7VcFU3zwBlpBnVZYHt6zMGDSB9XVpzs1sy7ccbSMPssDxqrq0jo7M4/iMulDEMN
	cc81KyD/7lN/1IdbRk/0st8w3zFDkB00KyF06+Q==
X-Google-Smtp-Source: AGHT+IFUIwYSu6KbEUAyth9XxFqC5nZrcsAdb62v1PqnR10rTpKu/1c9tc94aN8gqcFnCnBkFhMxBIdlbJj9h25BLbM=
X-Received: by 2002:a05:6102:cd4:b0:493:eebc:d77d with SMTP id
 ada2fe7eead31-4a4659ca79dmr8656632137.15.1728980492921; Tue, 15 Oct 2024
 01:21:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241014141042.954319779@linuxfoundation.org>
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 15 Oct 2024 13:51:21 +0530
Message-ID: <CA+G9fYs-BXW2J-n1R7VO2j-qqpP=3nzYC4a2C7=-fnLTW8OR8w@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/213] 6.6.57-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Sven Schnelle <svens@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 14 Oct 2024 at 20:06, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.57 release.
> There are 213 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Oct 2024 14:09:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.57-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The S390 build broke on the stable-rc linux-6.6.y branch due to
following build warnings / errors.

First seen on v6.6.56-214-g8a7bf87a1018
  GOOD: v6.6.56
  BAD: v6.6.56-214-g8a7bf87a1018

Bisection points to,
  d38c79a1f30ba78448cc58d5dee31c636e16112d
  s390/traps: Handle early warnings gracefully
    [ Upstream commit 3c4d0ae0671827f4b536cc2d26f8b9c54584ccc5 ]

List of regressions,
* s390, build
  - clang-19-allnoconfig
  - clang-19-defconfig
  - clang-19-tinyconfig
  - clang-nightly-allnoconfig
  - clang-nightly-defconfig
  - clang-nightly-tinyconfig
  - gcc-13-allmodconfig
  - gcc-13-allnoconfig
  - gcc-13-defconfig
  - gcc-13-tinyconfig
  - gcc-8-allnoconfig
  - gcc-8-defconfig-fe40093d
  - gcc-8-tinyconfig

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build log:
-------
arch/s390/kernel/early.c: In function '__do_early_pgm_check':
arch/s390/kernel/early.c:177:30: error: implicit declaration of
function 'get_lowcore'; did you mean 'S390_lowcore'?
[-Werror=implicit-function-declaration]
  177 |         struct lowcore *lc = get_lowcore();
      |                              ^~~~~~~~~~~
      |                              S390_lowcore
arch/s390/kernel/early.c:177:30: warning: initialization of 'struct
lowcore *' from 'int' makes pointer from integer without a cast
[-Wint-conversion]
cc1: some warnings being treated as errors
make[5]: *** [scripts/Makefile.build:243: arch/s390/kernel/early.o] Error 1


Build log link:
---------
  - https://storage.tuxsuite.com/public/linaro/lkft/builds/2nQwi03QYzWjrOZMpsvCF31N0Oc/
  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.56-214-g8a7bf87a1018/testrun/25432877/suite/build/test/gcc-13-defconfig/log

metadata:
----
  git describe: v6.6.56-214-g8a7bf87a1018
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git sha: 8a7bf87a1018a21d9dbbc5a794cb9a4fb3243aa0
  kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2nQwi03QYzWjrOZMpsvCF31N0Oc/config
  build url: https://storage.tuxsuite.com/public/linaro/lkft/builds/2nQwi03QYzWjrOZMpsvCF31N0Oc/
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
