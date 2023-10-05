Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBEC7FA
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 05:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fxuV+roA"
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-452527dded1so320554137.0
        for <patches@lists.linux.dev>; Wed, 04 Oct 2023 22:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696485337; x=1697090137; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8ZcZ92+aK7pFvnYG3Zmua4wSvYZMloUcgVE7tYVuTB8=;
        b=fxuV+roAsok2l72YnHyGI+Lm7ovdRFgGqeIxp+Js6QLVV/Pt5nPpQ1vWcIPyCC+SCA
         jUsGT+3D7nFJ38psekonl4PqsNB1225TWFVIGjLSfhlSnKMDLwQEjCdzyf88kk46I7/B
         DHVzaFSX/IWlrYAFhrd9SoEoODresssKjvSnoxYLC0V9/yewYCF5MvnZ9PMQv+zPQ73u
         wAKhymTb3QHXp0W2j8rmtY3OoFhJNR1UQ9+I43gMj4v/48/TUqgcDrMtNFchbng5LBc/
         9UsdUQiEjrP0fPfq8ehmRRxidYMZRONMyIrw+Vd4VUAz9g+XI5whnvkxXIkzFN9inIs1
         5Mjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696485337; x=1697090137;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8ZcZ92+aK7pFvnYG3Zmua4wSvYZMloUcgVE7tYVuTB8=;
        b=Y2Nj/MsHcbHVNIueQsyEPJwHNpmFvHnlAphiFY+2Yhud3TzbxAsBFQjS96UgE2bxYA
         DdmlJDy8D4GXDTTVLV6Lr+hnWF5cmFtm7FkjUUkG5/xro/9jRdBTfsj8WeHWB1KHkZvn
         pMr4ZJIsbYwhaxfC7Y/DJwDFKqWmBJGNP8ySWxdn+jRgtSb061meLtiZEVFr9blpilXD
         ag3IAGT7KREh+s2AbIPuRH/w5ADD6buuG7VWVPqpxL2I46zLeQs8TUWOAxRRisn1wwMK
         oLYOJBK52C69M2kQ8Zko1VSWZBn3iVSPe7ji8y20hHFNHUui/djGgc9KyIJEj1h6Xr4r
         7ZLQ==
X-Gm-Message-State: AOJu0Yw6jb2iW1wPIaQq8RNHWWrYokdX8/qZVpjreyV+pTy8JOZNm1ye
	Xt8hUpMZ4O2G6pxSQibfkXtEe91SJHFn+8m+DC13fg==
X-Google-Smtp-Source: AGHT+IEfqFq+XiDNz2eIQnSJe4kBwvfbehxMBH2culMzbddsGyBv9EAUAsoMj1f9NVtaqL/bP7MZWcqyYrY+8efqtTY=
X-Received: by 2002:a67:b34a:0:b0:454:6faf:204d with SMTP id
 b10-20020a67b34a000000b004546faf204dmr4357700vsm.2.1696485335477; Wed, 04 Oct
 2023 22:55:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231004175229.211487444@linuxfoundation.org>
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 5 Oct 2023 11:25:24 +0530
Message-ID: <CA+G9fYuH90g8jQ5SZHE98k16iQV5n+d2-G64xT9W9wrVmpt_Dg@mail.gmail.com>
Subject: Re: [PATCH 6.5 000/321] 6.5.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jinjie Ruan <ruanjinjie@huawei.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	Netdev <netdev@vger.kernel.org>, kunit-dev@googlegroups.com, 
	Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 4 Oct 2023 at 23:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.5.6 release.
> There are 321 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 06 Oct 2023 17:51:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

While running kunit testing on qemu-armv7 following test failures noticed
on stable rc 6.5.6-rc1.

# req_destroy works: EXPECTATION FAILED at net/handshake/handshake-test.c:477

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Test log:
----------
<6>[ 1351.687335]     KTAP version 1
<6>[ 1351.688300]     # Subtest: Handshake API tests
<6>[ 1351.688760]     1..11
<6>[ 1351.689362]         KTAP version 1
<6>[ 1351.689985]         # Subtest: req_alloc API fuzzing
<6>[ 1351.694360]         ok 1 handshake_req_alloc NULL proto
<6>[ 1351.705855]         ok 2 handshake_req_alloc CLASS_NONE
<6>[ 1351.710878]         ok 3 handshake_req_alloc CLASS_MAX
<6>[ 1351.715435]         ok 4 handshake_req_alloc no callbacks
<6>[ 1351.722026]         ok 5 handshake_req_alloc no done callback
<6>[ 1351.726579]         ok 6 handshake_req_alloc excessive privsize
<6>[ 1351.732397]         ok 7 handshake_req_alloc all good
<6>[ 1351.732934]     # req_alloc API fuzzing: pass:7 fail:0 skip:0 total:7
<6>[ 1351.733586]     ok 1 req_alloc API fuzzing
<6>[ 1351.741251]     ok 2 req_submit NULL req arg
<6>[ 1351.745979]     ok 3 req_submit NULL sock arg
<6>[ 1351.753307]     ok 4 req_submit NULL sock->file
<6>[ 1351.763090]     ok 5 req_lookup works
<6>[ 1351.770057]     ok 6 req_submit max pending
<6>[ 1351.774878]     ok 7 req_submit multiple
<6>[ 1351.782411]     ok 8 req_cancel before accept
<6>[ 1351.787423]     ok 9 req_cancel after accept
<6>[ 1351.795660]     ok 10 req_cancel after done
<3>[ 1351.799741]     # req_destroy works: EXPECTATION FAILED at
net/handshake/handshake-test.c:477
<3>[ 1351.799741]     Expected handshake_req_destroy_test == req, but
<3>[ 1351.799741]         handshake_req_destroy_test == 00000000
<3>[ 1351.799741]         req == cae22700
<6>[ 1351.803368]     not ok 11 req_destroy works
<6>[ 1351.804539] # Handshake API tests: pass:10 fail:1 skip:0 total:11
<6>[ 1351.805460] # Totals: pass:16 fail:1 skip:0 total:17
<6>[ 1351.806276] not ok 95 Handshake API tests

Links:
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.5.y/build/v6.5.5-322-g9327d0db36be/testrun/20257175/suite/kunit/test/req_alloc/log
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.5.y/build/v6.5.5-322-g9327d0db36be/testrun/20257175/suite/kunit/test/req_alloc/details/
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2WJGlCUgDzR8asQbd2BxMssFcEc/
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2WJGlCUgDzR8asQbd2BxMssFcEc/config

Steps to reproduce:
# To install tuxrun to your home directory at ~/.local/bin:
# pip3 install -U --user tuxrun==0.49.2
#
# Or install a deb/rpm depending on the running distribution
# See https://tuxmake.org/install-deb/ or
# https://tuxmake.org/install-rpm/
#
# See https://tuxrun.org/ for complete documentation.
Link to reproducer,
https://storage.tuxsuite.com/public/linaro/lkft/builds/2WJGlCUgDzR8asQbd2BxMssFcEc/tuxmake_reproducer.sh

or

tuxrun --runtime podman --device qemu-armv7 --boot-args rw --kernel
https://storage.tuxsuite.com/public/linaro/lkft/builds/2WJGlCUgDzR8asQbd2BxMssFcEc/zImage
--modules https://storage.tuxsuite.com/public/linaro/lkft/builds/2WJGlCUgDzR8asQbd2BxMssFcEc/modules.tar.xz
--rootfs https://storage.tuxboot.com/debian/bookworm/armhf/rootfs.ext4.xz
--parameters SKIPFILE=skipfile-lkft.yaml --image
docker.io/linaro/tuxrun-dispatcher:v0.49.2 --tests kunit --timeouts
boot=30


--
Linaro LKFT
https://lkft.linaro.org
