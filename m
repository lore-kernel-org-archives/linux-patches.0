Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D7017F511
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 17:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720028730; cv=none; b=PjKuJM0MIegrX06BHMjSl3rgJFiaom6QldlgB/nBngWz1mPfbquBbCpwn/3qyMw4waPG5sB6/ghwxrZc7n5D26oTScVvm594szEywfTHka6jMzh2fD8btnr7JOMOBSgcOjJKiCYBqB1o5/pqdEJmbG0arH5YWNzU7nM4MCwZb4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720028730; c=relaxed/simple;
	bh=sewsy2PNlhAHTIAwKUo9Yw0nLuZyn06JcxUxF2qHRro=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=naEHCyD82tFztSTbR7kKP8ELTjCkU/YaQndQXCPwpze6gqRdRjPfpxIPd5B6GROGD5lJNXrKRBvJsQ+p0rGWlDdvd17eWrI5Yyz9CayupCA4iooq2sUm9GaK+Q5UMH5PbWFifuNUyuowoARjJTiLIlH8mZTyasKjqc8rlZVNOyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Q61gR9n0; arc=none smtp.client-ip=209.85.217.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Q61gR9n0"
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-48f5d1c2341so559630137.0
        for <patches@lists.linux.dev>; Wed, 03 Jul 2024 10:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720028728; x=1720633528; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5cDuIQ1SVOlntwrCaUKDE4lSKPTpSufh+g8wiE4Zb5w=;
        b=Q61gR9n0SGBwu7wlzbnYpS8sl7qq0f7iSELQc/NfQ3g7Yjl+hBkSqHUD3xYKPBzspE
         4Np6KDkU9fd5jp1wUhY3E7Zbu5YVT8LYoP6X6YeLHeApYKAZzzJNJZMz2h8rMDt15xE6
         FRPoDO/ksnbDu7LlirM6uFJuROCX0ys9FTZ+ECGdPLP7GgrbGv8w37Zox6Ulce6yy9+k
         tGhWAK3we0jDhYtLlXLSixA1r1GGOc5xF6MYOszUZkDlpHMFjUHH36ftZkc6dkOcT8m+
         zJrD12+79GhDfBkyMsqRUxhkY6+59UpwN4Ib2zvlrmttEfcDMq4RUWrO3os75p90zyqY
         i8Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720028728; x=1720633528;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5cDuIQ1SVOlntwrCaUKDE4lSKPTpSufh+g8wiE4Zb5w=;
        b=vIuNg6vFWcdu4guHur3Wl9hewBvCfZ6pzbACL9C2FJEXrfdz8gybEJNhAMmqsPn+AG
         vMnrnj+aAX8ZLKYpI5duzNiUY1UZ5TOUsfS34+s7C5qAhZAL1IEzh5XFMKDGxXQEHNmM
         ZjOuHBGcIymZg/SzM6U71IEMJx3NnbYSRpv3426vprNMqX2gaEwKeXS3IqPg5B0PhwgY
         DmvP80h24ufCRz2x7npWOGWYmY8EJO+GfTWhMXhwuj1SqXvTyJ2il97PzXzc+qulCr72
         I4sGiIsfMWobzHVoHMMN6tIQNYW9ApyiAgu6vupFu+h/Hnx8dmY7Yy7oR6Tvv/dkOn9Y
         0pDA==
X-Forwarded-Encrypted: i=1; AJvYcCWm5mv37P2wsG8ZuKj64Xe1VRRfFmvTgweG7iXisDIYvvYg96mh/s7JltFqFJ4uTPeYvCqO1C1HUeJfqEv31rXtnux02O1NyQ==
X-Gm-Message-State: AOJu0Yzli2JTaVHFHLLN4/4q/YqaLERxx0531Uu28m5crgxphpyhkryy
	cng89BQgo1CtiXcYwYnjmni7QwNxWTRHGRaF0006pcv6eWAs6wqffRQ9o5nE+yRZUMfuK2SoRk3
	TQabcHEO866qHsmOy1Uhs9p7M4kXd7OhQ6pQv/g==
X-Google-Smtp-Source: AGHT+IF+f1WlbG8vYxx3JDKGgZzmMKhXtY8j4lhiNmTEhtO8JGWtHRi31ETtlSqGO8zmmaqnZauCj6D8pDnZbW6J8iA=
X-Received: by 2002:a67:f447:0:b0:48d:a4aa:35f9 with SMTP id
 ada2fe7eead31-48fdec17e8amr1799967137.4.1720028728227; Wed, 03 Jul 2024
 10:45:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240703102841.492044697@linuxfoundation.org>
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 3 Jul 2024 23:15:16 +0530
Message-ID: <CA+G9fYvAkELSdWF1EYyjS=d_jvCJD0O=aPnZFHUGnhYy6c1VCg@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/189] 5.4.279-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Dan Carpenter <dan.carpenter@linaro.org>, 
	Arnd Bergmann <arnd@arndb.de>, Anders Roxell <anders.roxell@linaro.org>, 
	Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 3 Jul 2024 at 16:20, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.279 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 05 Jul 2024 10:28:06 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.279-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The sh builds failed on stable-rc 5.4.279-rc1 due to following
build warnings / errors.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Regressions found on sh:

  - gcc-11-defconfig
  - gcc-11-dreamcast_defconfig
  - gcc-8-dreamcast_defconfig
  - gcc-11-tinyconfig
  - gcc-8-defconfig
  - gcc-8-allnoconfig
  - gcc-11-shx3_defconfig
  - gcc-11-allnoconfig
  - gcc-8-tinyconfig
  - gcc-8-shx3_defconfig

Build log:
------
arch/sh/kernel/sys_sh32.c:68:1: error: macro "__MAP3" requires 4
arguments, but only 2 given
   68 |                 SC_ARG64(nbytes), unsigned int, flags)
      | ^
In file included from arch/sh/kernel/sys_sh32.c:11:
include/linux/syscalls.h:110: note: macro "__MAP3" defined here
  110 | #define __MAP3(m,t,a,...) m(t,a), __MAP2(m,__VA_ARGS__)
      |

Build log link,
 [1] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.278-190-gccd91126c63d/testrun/24510005/suite/build/test/gcc-11-shx3_defconfig/log
 [2] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.278-190-gccd91126c63d/testrun/24510005/suite/build/test/gcc-11-shx3_defconfig/details/

Build config url:
  config: https://storage.tuxsuite.com/public/linaro/lkft/builds/2ijXtbqe6slPmKG8dbt7I6JJ7eg/config
  download_url:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2ijXtbqe6slPmKG8dbt7I6JJ7eg/

metadata:
  git_describe: v5.4.278-190-gccd91126c63d
  git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git_short_log: ccd91126c63d ("Linux 5.4.279-rc1")
  build_name: gcc-11-shx3_defconfig
  toolchain: gcc-11
  arch: sh

--
Linaro LKFT
https://lkft.linaro.org
