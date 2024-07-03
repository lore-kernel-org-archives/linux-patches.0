Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3315F17F51A
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 18:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720030328; cv=none; b=LpL9mpiepZW3EVQ9xWyZoBnPdN6v98gZhAR0qJfI9/37oOwtK353ExD4SqRsjgaHlSLVDIRPlxgCAr6Vcn+bjRSH7I9r9p/6xAlWt7ACNOv9PJWjLJotU4wg851XaD4val3cIBmCEt9Wdw5oS25cXuErMON4RnT7MSSEN6kOYaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720030328; c=relaxed/simple;
	bh=fPhCmgnaiDZl2A6WXQkFrJg4shudkED3sjVTlU32HrM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XE5xQgb663A3dtpb5D20lnuQLZV9I2e2yNy3luUYbiQdZ5RChsfGm+UyROXZsdE4U3oYijzD+xm5W3nFZEEccZRv9C8P5FLDX+HIYxa4hmYTjRzXg9EYUOPueDj1v2Bqjzfy/MyQHmIqhxlE2rJRtQPNsASP1w4IhfRJZE+WnYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qLwveQVh; arc=none smtp.client-ip=209.85.217.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qLwveQVh"
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-48fdb95421bso505341137.2
        for <patches@lists.linux.dev>; Wed, 03 Jul 2024 11:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720030326; x=1720635126; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mr6GiDtRMzhlcU7TEUxy1mdYCuFY8dTCGfwcOk7GP/c=;
        b=qLwveQVhkiv1Kb8Fx6knNwxWGVgb6jxrpf4UsAzjNtdtFRxnuGDtCzSszlb+4mSqeS
         224mAxUyDh9U79kLnlV1h3vnVYIRr6p+eUZXFYsV2+BJYaysFT4tFtYjVbsYjCnSlgI9
         TgVYkYz8CNun0Xrv4QzNbuGwm/RnUvGrf8Q4gffwlC346XzORlCr5Pa9oTanvxwoPGbm
         KMm+esY8Zug47iM+yC95F3LuakD3YA+D9HWxNkBQCXsWiX2X+DdLg8pRPvC0i+xqxP7e
         2LLLjrivH7MjwZyXE6eEdhzxbKn9L1HRKHAxkDsrguMoz3x0VDO58fhmjM0eTBBwwMNa
         4yXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720030326; x=1720635126;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mr6GiDtRMzhlcU7TEUxy1mdYCuFY8dTCGfwcOk7GP/c=;
        b=QHM0/qjIoVRglurQELLJrwNOjZFDraFTwZS+58vbr7eiXBdcnr/Q9JmtNU8cHEyE1U
         drIdUpaxoHmrWm4GoYHwNsdCdP9WF6mlOZTDNUES6W0eNAHxTqzQwvOyClp3BqD4uQ1s
         nAsuHH5H+KL7VzZsiSPmCXPXKpMyND/oz1obBevnz7dHPp/y6i5UoequmOSKeScx1BjS
         cD21xi9fYqNE8LL3oMIU6QIEFbHJtsXEqlOcPQBQ6mSk3Zr9oDFU8D9zjwZu/pmQj1Gu
         n3+BSRUYE/hh87yXy08OPXur2P6qtptPq4mdSKX2MsDMS/X/RjlBbS8uRtwGgEe5Fscv
         EsVA==
X-Forwarded-Encrypted: i=1; AJvYcCWQ4rOKjHi/kL+Ev7j9l6oJgfgTyZ1S0fnz9KxMsLwhREjz1S69gDq00EyhLKSCqISPlBc6t4IaAB77NfsSz77JcZGRL85nSg==
X-Gm-Message-State: AOJu0YxkQUy3iNflevhl3IJZWjGaFzfzjgLaPrJ+YYNSXsjwpDHjWhdD
	K24D6VVaXjUSirLSB3sK1QkPqDu64nrJgzjEDdloPl57z7UVbg3gEkmf2jni8fv+wmFDJxwLifI
	c3zbxIzdZ0VLQAvjVJ6OojQHeKBLYQWIsZ2DDDg==
X-Google-Smtp-Source: AGHT+IGGt6bUpa80iJhaddgtZTkRvaBxVD+WY5qQ+Y/sKswvE4heTrLyOi9GRMVgEOs9n0cRyAzD/Roo17eqbs8PbQ4=
X-Received: by 2002:a67:f2d8:0:b0:48f:a858:2b54 with SMTP id
 ada2fe7eead31-48faf140919mr13826176137.26.1720030325982; Wed, 03 Jul 2024
 11:12:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240703102904.170852981@linuxfoundation.org>
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 3 Jul 2024 23:41:54 +0530
Message-ID: <CA+G9fYu8dpsNyqPk53wyq1ZTKmCJ3gUb6JBjH3OM9p2pqL_E-A@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/290] 5.10.221-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 3 Jul 2024 at 16:29, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.221 release.
> There are 290 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 05 Jul 2024 10:28:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.221-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


The s390 builds failed on stable-rc 5.10.221-rc1 due to following build
warnings / errors. These errors were also noticed on stable-rc 5.4.279-rc1.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Regressions found on s390:

  - gcc-12-defconfig
  - clang-18-defconfig
  - gcc-8-defconfig-fe40093d


Build log:
------
arch/s390/include/asm/cpacf.h: In function 'cpacf_km':
arch/s390/include/asm/cpacf.h:320:29: error: storage size of 'd' isn't known
  320 |         union register_pair d, s;
      |                             ^
arch/s390/include/asm/cpacf.h:320:32: error: storage size of 's' isn't known
  320 |         union register_pair d, s;
      |                                ^
arch/s390/include/asm/cpacf.h:320:32: warning: unused variable 's'
[-Wunused-variable]
arch/s390/include/asm/cpacf.h:320:29: warning: unused variable 'd'
[-Wunused-variable]
  320 |         union register_pair d, s;
      |                             ^               ^

Build log link,
 [1] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.220-291-g4d0fada143ed/testrun/24509787/suite/build/test/gcc-12-defconfig/log


Build config url:
  config: https://storage.tuxsuite.com/public/linaro/lkft/builds/2ijXjGemFUwKSWd98LvKtd4i3uF/config
  download_url:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2ijXjGemFUwKSWd98LvKtd4i3uF/

metadata:
  git_describe: v5.10.220-291-g4d0fada143ed
  git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git_short_log: 4d0fada143ed ("Linux 5.10.221-rc1")
  toolchain: gcc-12
  arch: s390

--
Linaro LKFT
https://lkft.linaro.org
