Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C226E14D283
	for <patches@lists.linux.dev>; Tue, 15 Oct 2024 13:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729000382; cv=none; b=tl2YgmgqG2ktgMWIpytb6AhUKKPf/mNWQW8D0IkvGN4ZvptuP3P05TDPOyXidHNT4JdWydAffVA2OvnpEIYpXIzI2NMKOpUpe8bs6JNBaGeqV0WvAyLNarRrHoBT+rogOyLz3lZsEqsCXbYa2HykPU1BkmZQP73/gREO+aTdHvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729000382; c=relaxed/simple;
	bh=FWQOlZwru2thEbhL4lTMF6xjCwNMEnaS/bczPp/hIus=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CiNV0Ke0VxXTQvqtmYASpUyAZ8Y/Y2QRjKMPhA2KefaD05gI3GWzILOXDae+eeoWwNajNP8ZgdDyd1qYMspTFmc6cgyIFZZ/q+tMwMgTZID29VuYnPKMnD8mSxjWARIchJdz1gpKmBlmhrALmCoAuu7oP6zTFWsQPQkEVJGhOFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HxqXVUAG; arc=none smtp.client-ip=209.85.222.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HxqXVUAG"
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-84fe1bc5284so1077676241.0
        for <patches@lists.linux.dev>; Tue, 15 Oct 2024 06:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729000379; x=1729605179; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iexUV/ndk4U1Dhl/r8ShAJPbiDOAMvjVeQipylX0EJE=;
        b=HxqXVUAGCFvq+RLVtDpazr+xt3d0fQMTvl27A7ufkD7d9/esGvI6U5d8+hAt9nUxOY
         QufMzV4zKxjpbryWWBIpw8CoIO+CO3Xt4/dAjErrmerjqXHJT2GSPaeH3tUELa6eZTCY
         gI+CWUBIWkWwfi/8B4xg0N+NBUBUnb9V817j4BBXbDeZVfB+Avsd2y9KIztMeL9zbDVZ
         jDUCnW9CHXrAAgi2s8V0hX8p5Gtwk1yjzFZzzF18wcA8CxtE87CZx4W/6Cef8W+N8FvJ
         HMXp5Sye0F4WX8inJhH9vnFN5Ph6G59bhKRaSR6Bii2H8Xvl94+yPI/CWRextwh2yKqV
         Dcow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729000379; x=1729605179;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iexUV/ndk4U1Dhl/r8ShAJPbiDOAMvjVeQipylX0EJE=;
        b=suRgs8u4wup//vwaya5HxY6UNRngc26CuJVw3CmAkIfac+sJUqNtw+SN0zi/dHkvgp
         QJyk4SJcVG03IKVH4C7UXrC6DGvPGEqXEPW9bzXn5EMwtGMN2BTKgx4DpVigE0S73ad7
         BMzRK9M7Zio0G0qzzhjcqDMuwmQnY4e95pAMt01e9GxT7i9pLAeoiEDR62+4CGrU33++
         wUEGt0wnXw5KS3s+3Yh5qVFeSpjjdRwuxvn4KRrrHUBiocXm01NDwKuh5WejOmCwS8Kw
         tRNIk2QZcabPYMXhNAOgn4avq3gsTp80Gh+Hpsb7VR0EWnpvFXzWYE4+FBpeYfsir0Bq
         sHLQ==
X-Forwarded-Encrypted: i=1; AJvYcCWzGZI7BI8majb5yZ5aqBQHWIIkhU/GYpp1zcJWjTCu6NTs9ppnTSyMd1I1PSTJDtNLY9OSGJCq@lists.linux.dev
X-Gm-Message-State: AOJu0YzU48GiZUKMY5jsMAjXQLRScKWGZoy2v7Zia5LquVkWckb9PmKY
	umTeKDeGDmIaJCuB/IL465zNEFkMosZFcEY0StPDMww8QGv490T9ZhqJmsQA4D8MpWZrbQfwDMi
	mIErcjJEa4kNUkyWOQ2b/IoF2YIzizyYqp/Y9PA==
X-Google-Smtp-Source: AGHT+IH2roGFwbjAPfRe/dAsoUkaB0X5KgBCAg1wOBa1OFnEfproIcRvnwE2U7eCCjeyZrdFKKgEIyw21oL0+FIDqp8=
X-Received: by 2002:a05:6102:954:b0:4a3:bb4d:1965 with SMTP id
 ada2fe7eead31-4a47600f27fmr7219973137.28.1729000378624; Tue, 15 Oct 2024
 06:52:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241015123916.821186887@linuxfoundation.org>
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 15 Oct 2024 19:22:46 +0530
Message-ID: <CA+G9fYuZun789CY2rZ6WqxzdFswDYCf_fMpT9d-4M0bzJfJrhw@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/518] 5.10.227-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>, 
	Biju Das <biju.das.jz@bp.renesas.com>, Wolfram Sang <wsa@kernel.org>, linux-i2c@vger.kernel.org, 
	clang-built-linux <llvm@lists.linux.dev>, Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 15 Oct 2024 at 18:25, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.227 release.
> There are 518 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 17 Oct 2024 12:37:45 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.227-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

A larger set of clang-19 builds failed on arm, i386 and x86 due to
following stable-rc linux-5.10.y.

And gcc-13 and gcc-12 builds passed.

List of build regressions,
* arm, build
  - clang-19-at91_dt_defconfig
  - clang-19-axm55xx_defconfig
  - clang-19-bcm2835_defconfig
  - clang-19-clps711x_defconfig
  - clang-19-davinci_all_defconfig
  - clang-19-defconfig
...

* x86_64, build
  - clang-19-lkftconfig
  - clang-19-lkftconfig-kcsan
  - clang-19-lkftconfig-no-kselftest-frag
  - clang-19-x86_64_defconfig
  - clang-nightly-lkftconfig-kselftest

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

The bisect points to,
  da1084f5722a9a46bdcadc09429dc4b56ac31de4
  i2c: Add i2c_get_match_data()
    [ Upstream commit 564d73c4d9201526bd976b9379d2aaf1a7133e84 ]

Build log:
-----------
drivers/i2c/i2c-core-base.c:101:31: error: passing 'const struct
device *' to parameter of type 'struct device *' discards qualifiers
[-Werror,-Wincompatible-pointer-types-discards-qualifiers]
  101 |         data = device_get_match_data(&client->dev);
      |                                      ^~~~~~~~~~~~
include/linux/property.h:382:50: note: passing argument to parameter 'dev' here
  382 | const void *device_get_match_data(struct device *dev);
      |                                                  ^
1 error generated.


Build link,
-------
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.226-519-g5807510dd577/testrun/25457427/suite/build/test/clang-19-vexpress_defconfig/log
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2nTXZNd4wRQOyppVvH0kgAPF6cE/

Build history:
----------
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.226-519-g5807510dd577/testrun/25457427/suite/build/test/clang-19-vexpress_defconfig/history/

metadata:
----
  git describe: v5.10.226-519-g5807510dd577
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git sha: 5807510dd5773e507a5ba5ca98fce623d87256a0
  kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2nTXZNd4wRQOyppVvH0kgAPF6cE/config
  build url: https://storage.tuxsuite.com/public/linaro/lkft/builds/2nTXZNd4wRQOyppVvH0kgAPF6cE/
  toolchain: clang-19
  config: defconfig
  arch: arm, arm64, i386 and x86

Steps to reproduce:
-------
# tuxmake --runtime podman --target-arch arm --toolchain clang-19
--kconfig vexpress_defconfig LLVM=1 LLVM_IAS=0

--
Linaro LKFT
https://lkft.linaro.org
