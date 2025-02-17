Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF07115382E
	for <patches@lists.linux.dev>; Mon, 17 Feb 2025 07:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739778626; cv=none; b=deGk7AfE+bKhbFFm3oAydpeqO277ZBOSCiSYa/M1AlMuNvkJPY+UP2tM/hNgLyESkc7RZbOwfumGSvyzjHSvEMmh7/HEGGp4aLrx+/3Heklz5Be9yzxcckf3Ls97NugOU687tMR3Gb80UKAmlxakb45440eI3t9ddhxrZ4Q/2zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739778626; c=relaxed/simple;
	bh=vp4a6t9+gatjenBKfvBoMVmONzCQscQ264+pgS+okNY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T7xgy47mkTHmzjjYM29K5QfbWbqJcdiy6ioWG84+ZN9vcKOYScAQMtU+BwmLTRAUGW+hzmISUUZr+23TPSYq8Q1s7r0arIwSNrZ3KgSc2RMYs8H+c5YKUkXQXXu497pWPth/J066hDPzxD0oNwwAYx6eIRtbXrlO0IqaoeTEYU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=V50JHmsT; arc=none smtp.client-ip=209.85.222.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="V50JHmsT"
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-868f18a629bso1048553241.2
        for <patches@lists.linux.dev>; Sun, 16 Feb 2025 23:50:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739778623; x=1740383423; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sb9TESano3F0qRs1VfUsEveKaGPiE/3bY+CecfKRiUY=;
        b=V50JHmsTz2X47DcfMNz5EPZvMinfbdf5kgM5fNYcGpmbI4hIw7anCvQkBB1ECuTeAi
         enAdv+uomoveVmUL2jLRSXTEDx2Za0696b6qqxi6ip2TnNq2o1IlAZ/w6YXqxQTzZGGP
         Wg3sObCmC/1Fh3e8yKvXL/4dGTqb9+5UrQL0zhP/YdUBx5vpm+OsKLP0z574wEmgMo0u
         XZ0aDX+ys6cuN9FIT2mYuVw1GyCZBMs8gMoXor/xYdLGOP9uufE+mYqIk9hpBHUyhhkd
         UxBMwuYMttIayip3RX1/xECjoPbCfvXx3ohVD4IgPEZZh1Fr/0uDUSt4K/rKY+7lssaq
         AJYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739778623; x=1740383423;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sb9TESano3F0qRs1VfUsEveKaGPiE/3bY+CecfKRiUY=;
        b=clUDro/CLqupQWNT9aSqTSkPyWaocOIiKaL9oYLV/l3JMmbYwiYi711B3moGBHabH4
         5CIdogDjk1wqFpH5YdImeUVUC3znPF4k3oxBC3IlcEN3HfJWz41dOpryGHk0M9ogl0Xv
         ZKy3im/UVdJU0Vy7nKFdsw9dUunqjJf//TTDWDQAOfAZ1C3Z5cJHkbOfKNtNAH5YVnr7
         imLmPR7pqEuw2bRT9EiG9348PIVaG2+iQ6vHhXEnTTpS3rGMYYPNrbyDjyos5eFVWQdi
         dt9nQNFvOYZW7yLX0v3DDximFe4GWv9mztSXREU2qWEZmBxz7IDJvQljR0pbfLY3eCi5
         srFw==
X-Forwarded-Encrypted: i=1; AJvYcCXJUku1w3J/oE2FsvV0K25WX3mtaFXMo3Nc+e0As3IddB35r3SasggGExQDnn2ZobfjVn+3XeQC@lists.linux.dev
X-Gm-Message-State: AOJu0YwJp4wWI5qEnIgWgLRNz4hbstnCJN9iK6/Nk0nxm3ySH3EnGQp8
	D7AarmOxO7ZgCeW//2eI7ibasO/BDomiIdJmV6IkINT66jxJQDwkKe+yd0ZXb9hLIGq2VeOfBSY
	YASn3F/jG2Cq4jGETHNCg6nhbSXO/ik8SJGISXQSbRLD5MzC32ic=
X-Gm-Gg: ASbGncuOKvaEMJjkskoFhl7XVuK3CoifLy6X7WO3Covw+AbblXd3IGK+IWj1ZfFWxUl
	wmUbe8YuemXHLlmazIVuxuImX+e8+bHtm7r+CdHwII6pL0NYg4VlbDVepuTO1+kT882nyGy96Rn
	Q=
X-Google-Smtp-Source: AGHT+IH7AA8lTvvKySDGMR/9+4pfIcZZ0oEGwwCKuY/vSrQj1o5zY23MVYJNqtGjpMCyHJPVzvbKMkBJGAYr8N5YT3E=
X-Received: by 2002:a05:6102:150f:b0:4bb:e36f:6a30 with SMTP id
 ada2fe7eead31-4bd3fd24266mr4376412137.15.1739778623321; Sun, 16 Feb 2025
 23:50:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250215075925.888236411@linuxfoundation.org>
In-Reply-To: <20250215075925.888236411@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 17 Feb 2025 13:20:12 +0530
X-Gm-Features: AWEUYZk9MdnW6iQDFedg0wdqGA5Evc7ByipVWqb3l0MawRNhfY2MpewuEd52Crw
Message-ID: <CA+G9fYv8VcR6Zj1PmqJ-zxUuCvJthO08BWuZo4uWdUbVvcT30Q@mail.gmail.com>
Subject: Re: [PATCH 6.13 000/442] 6.13.3-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 15 Feb 2025 at 13:30, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.13.3 release.
> There are 442 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 17 Feb 2025 07:57:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.3-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Regression on qemu-arm64, qemu-armv7 and qemu-x86-64 on 6.13.3-rc1,
6.13.3-rc2 and 6.13.3-rc3.

We will investigate this and get back to you.

Test regression: arm64, arm, x86 selftests: memfd: run_fuse_test.sh

* fvp-aemva, kselftest-memfd
  - memfd_run_fuse_test_sh
* qemu-armv7, kselftest-memfd
  - memfd_run_fuse_test_sh
* qemu-arm64, kselftest-memfd
  - memfd_run_fuse_test_sh
* qemu-x86_64, kselftest-memfd
  - memfd_run_fuse_test_sh

# Test log
selftests: memfd: run_fuse_test.sh
./fuse_mnt: error while loading shared libraries: libfuse.so.2: cannot
open shared object file: No such file or directory
not ok 2 selftests: memfd: run_fuse_test.sh  exit=127

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Source
* Kernel version: 6.13.3-rc3
* Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* Git sha:  f10c3f62c5fd43a4dea41a460937f2c1a6a412bf
* Git describe: v6.13.2-443-gf10c3f62c5fd
* Project details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.13.y/build/v6.13.2-443-gf10c3f62c5fd/

## Build
* Build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.13.y/build/v6.13.2-443-gf10c3f62c5fd/testrun/27311246/suite/kselftest-memfd/test/memfd_run_fuse_test_sh/log
* Build history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.13.y/build/v6.13.2-443-gf10c3f62c5fd/testrun/27311246/suite/kselftest-memfd/test/memfd_run_fuse_test_sh/history/
* Test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.13.y/build/v6.13.2-443-gf10c3f62c5fd/testrun/27311246/suite/kselftest-memfd/test/memfd_run_fuse_test_sh/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2t4N3DOlWsCre7mv2YlTKUyEFri/config
* Architecures: arm64, arm, x86_64
* Toolchain version: gcc-13

--
Linaro LKFT
https://lkft.linaro.org
