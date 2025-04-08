Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E256722B5B8
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 15:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744125780; cv=none; b=OXYndtjqO0pv0aWj/Yvp60YFsYALCQ2B1GMaiB9DmQvdVcke//mRev4Uj7nAPXg+3DNw2UZc/WV+riWVJJdqQE2DxEHAmaugVbITgsdtwv5AoTfJSBEdbIEKXgaNTuAktWzfza0wkZSctr8Lfv2zZSnIJxnI7foeqjLT30UdnZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744125780; c=relaxed/simple;
	bh=3lpzITRPn00lYD/ndslRx6AUWRX254zjphl4pSWfNo8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m04L9VbAWspAr9/euhgyqiMtsx+stxPfnyCp0kyy9lCAvzYA8c4GeFzxJi4OlcY+MUVwzdgWpGjMNdHPi1mxosMw/rofwGcVDSe6R/op3tGmhmJ6+Furbd2IEYjjObrKk5qbajNtwnNoTLN92m++MZHGsgzm6xOiKKuOxK6V5q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LxE3M1Fr; arc=none smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LxE3M1Fr"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-5259327a937so2389590e0c.0
        for <patches@lists.linux.dev>; Tue, 08 Apr 2025 08:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744125776; x=1744730576; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Cxg9LKA6+kQvyEUrjxprc+UTcXgCvZJ1Wa5TchzdHtU=;
        b=LxE3M1FrhLkin8BBxF7n3qFYq/KCfZP5F0fgbPG4efICkdsFOKWplAH139bWG7o7mU
         BtnulYQYfO1JEaHsTpocJakT4VU/JRTbWeeJMtloxHGQxkUWdKANuOFaoyyWHXWRkeY2
         MvxwcNmSpkJUyo50dw/rQTPRQF9PIpL4M0MK0UjmxB6wZHASr/woGnBfZ39rWVPfGtf3
         Rkh4to1QktJA3/3HDi2f3UNQNhl1aDp7qpjsF52yn4FkIpjsAkbcLFSTSkwS6aVpbBxG
         DfmtinEAEhCjnVWXPx55iCIJ24DNQqiT0zTdxQP5szwe28JRwDvojEZD7s5UzlkJtqYh
         ffrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744125776; x=1744730576;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cxg9LKA6+kQvyEUrjxprc+UTcXgCvZJ1Wa5TchzdHtU=;
        b=e4PAlA8SGMOPbdW0mJKvI/jwkkX7Ztgfzw5IetWOIvfrPPBw3stTwyllL6Rj/l7+aL
         tKj2V/a5zX/3B7pQCqRJP+fT5y0d1WKmUfPrV6yjOkDem9s1MJGwyu0uDLLbtyYzrhoc
         qmkyxHl4TcuhwoUAm1vmojFFOPihVU9NYVjMPHEpx+jXIbAGSBYP4zhOsSbLfDth6FU/
         uV+125sIYlQZy/sKcof4IOt0dw2KZBevv+lxF0FlPlKWfa8A2TrvK4mmi5vPk0MfuWnp
         /JrIMGQTbIHLWE1AUJNbFnh8CygwiUrbxxKKnFCIFNEZvkdtKf6Lsbu1oJCOQMdWWFgE
         gN9Q==
X-Forwarded-Encrypted: i=1; AJvYcCVK2w6jXuLIWCIZlJZ4872vThFv5LAf/aDrx5kexDwg1oTifsUYNDly6Iy84v0v71wOgtQO1H0W@lists.linux.dev
X-Gm-Message-State: AOJu0YxAHMTeBqurZa0BrN1mlsjQIdRhQmk9dlj1fPOOVyfUd8GWOMDi
	c2K3RDHFUOZBAxLyXYiycOTNz9jEujBWzzHG5Mv9NXD7/k0ASeeySiWKr8t1bS0LC3f4lgOx7vj
	G0DPy5Pzb3QO0WPSjEXVXajg2OwH+rsOc196kYg==
X-Gm-Gg: ASbGncuqbYa/mYdtnW555tT2kca2Z2LxM+8VukdhzNs/CnAuQ61hK5Bml2pEO3Y3MyP
	rYDQ3mUKa+cLNfDmNP5i6kT8cBH/Et1xZuzSu4RyPBczbAnrd/13h1+hp0wrFIGzMn/IouplE6f
	l01HvaGrH3x2cJf8BtuEQ5Ebd7HPZwUJxaW/bF4Mcz1XPV91cBHA5HgufDqCBzoNFlsbE=
X-Google-Smtp-Source: AGHT+IEtePmmvCUqzXP4fQmhOiQg0gVcd3/T0A8xgplxbFp6FtfV9GDDW+Rjpln3N7ol4Kj4hD73PnpvQwrVCf9mnBM=
X-Received: by 2002:a05:6122:1d0a:b0:520:4996:7d2a with SMTP id
 71dfb90a1353d-527730f997amr9204517e0c.10.1744125775647; Tue, 08 Apr 2025
 08:22:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250408104914.247897328@linuxfoundation.org>
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 8 Apr 2025 20:52:44 +0530
X-Gm-Features: ATxdqUEXqLGH0AeyqvbH4fTDpyq3lu_NpjMbeRtitNjowMQG1rjdctxiPvSjWaY
Message-ID: <CA+G9fYu_OLOYK_+X6urte_9VA4jye7_GcTbDd1GzjnBB1VYtKg@mail.gmail.com>
Subject: Re: [PATCH 6.14 000/731] 6.14.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 8 Apr 2025 at 16:36, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.14.2 release.
> There are 731 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Apr 2025 10:47:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

1)
Regressions on arm64, 390 tinyconfig, allnoconfig builds with clang-20
and gcc-13 on the stable-rc 6.14.

2)
Regressions on arm, arm64 rustclang-lkftconfig-kselftest builds with
clang-20 and gcc-13 on the stable-rc 6.14.

First seen on the 6.14.2-rc1
Bad: v6.14.1-732-gabe68470bb82
Good: v6.14.1

* arm64 and s390, build
 - build/gcc-13-tinyconfig
 - build/clang-20-tinyconfig

* arm and arm64, build
 -  build/rustclang-lkftconfig-kselftest

Regression Analysis:
- New regression? Yes
- Reproducibility? Yes

Build regression: arm64 s390 tinyconfig undefined reference to
`dl_rebuild_rd_accounting'
Build regression: arm64 arm rust pci.rs cannot find type `Core` in
module `device`

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

1)
## Build log
aarch64-linux-gnu-ld: kernel/sched/build_utility.o: in function
`partition_sched_domains_locked':
build_utility.c:(.text+0x3668): undefined reference to
`dl_rebuild_rd_accounting'
build_utility.c:(.text+0x3668): relocation truncated to fit:
R_AARCH64_CALL26 against undefined symbol `dl_rebuild_rd_accounting

2)
## Build log rust
error[E0412]: cannot find type `Core` in module `device`
  --> /builds/linux/rust/kernel/pci.rs:69:58
   |
69 |         let pdev = unsafe { &*pdev.cast::<Device<device::Core>>() };
   |                                                          ^^^^ not
found in `device`


## Source
* Kernel version: 6.14.2-rc1
* Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* Git sha: abe68470bb82714d059d1df4a32cb6fd5466dc0e
* Git describe: v6.14.1-732-gabe68470bb82
* Project details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14.1-732-gabe68470bb82/

## Test
* Build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14.1-732-gabe68470bb82/testrun/27939968/suite/build/test/gcc-13-tinyconfig/log
* Build details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14.1-732-gabe68470bb82/testrun/27939968/suite/build/test/gcc-13-tinyconfig/details/
* Build history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14.1-732-gabe68470bb82/testrun/27939968/suite/build/test/gcc-13-tinyconfig/history/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2vReGJ6wjd1n99Nsg9WaH58qupU/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2vReGJ6wjd1n99Nsg9WaH58qupU/config
* Build rust history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14.1-732-gabe68470bb82/testrun/27940128/suite/build/test/rustclang-lkftconfig-kselftest/history/
* Build rust details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14.1-732-gabe68470bb82/testrun/27940128/suite/build/test/rustclang-lkftconfig-kselftest/details/
* Build rust log:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14.1-732-gabe68470bb82/testrun/27940128/suite/build/test/rustclang-lkftconfig-kselftest/log

## Steps to reproduce
 - tuxmake --runtime podman --target-arch arm64 --toolchain gcc-13
--kconfig tinyconfig

--
Linaro LKFT
https://lkft.linaro.org
