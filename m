Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2F5208BA
	for <patches@lists.linux.dev>; Tue, 16 Jul 2024 20:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721163463; cv=none; b=MQxEL8uavO8o9sond5BGNqqNFEGGypPv1sxtoGe99ugSWysyqsGLDTf3ORQkVC6Qt2SW6YHYkKfVt9UqYMaHWMM+MzOyOH034plGGdDai/ku2mWY2jFpSH6kObx4SUUdzeoh4ETtQFC7hcoqfTBz0OsIMfRYcSD4Vf8oemZaFIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721163463; c=relaxed/simple;
	bh=JM0oRMdWBUMRn+0LSClZewRtkAE+Dxhx3Y9s7tfEy7I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LhpMrTSNYe3OJJHpymX3xX8pY6Od4fOLN3F+dBU1ZmcB5p8/h6wcPCGb06vZF0yLwc3on+/ANKeNYUHSTOy4klyJaR3hzxfpc4jBvpeYnqi7yTc6ZgLfmR6BXnve8v4LGUJMgjdsTkn+PjS2d3kpnPhnuDzZnGlj2H6MwvAg5Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=meRz/KxY; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="meRz/KxY"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-58bac81f3f9so6855851a12.2
        for <patches@lists.linux.dev>; Tue, 16 Jul 2024 13:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721163460; x=1721768260; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kUDuJF3m+GLPOXJ4XX+YSbr7/KroHvma3vr0cCZSPE8=;
        b=meRz/KxY7SAspNPxK+r30ySPxO3WJLZ1Lquk4nG3QqVN8LX7pj1ppgRXAGGYufvmPn
         QiDNwu0d5CxUot22wXpQWLnrHCnXU+0iUIrqEEgo0ZP8CXvDp8d/BshxcgBiYkXeOzPa
         dmhirn1ogs55dfNTh6WvRz/QFy/+rMECMHMhjNwVzrqszh808Dy31lnelJsf7Xz7YQut
         Mm1lNCpeHQu9UU7w1qg9re8OtU2w4oVTUWnDi6RLqPEEGnZWRpnYduHp+CHEzAGre/jY
         lr4kAb4it3MN5wmoJeq21twbiV86ajBv7e9O7Vj+tZMCWb0zf0je7nyVXl934DtlW1rt
         Gk/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721163460; x=1721768260;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kUDuJF3m+GLPOXJ4XX+YSbr7/KroHvma3vr0cCZSPE8=;
        b=SoD1ppseBA+eTsrnYbMJOdAgOf42xxbVWYT+awzkZpKfyu8jsM5z2sNtHrnNfQ2N5w
         2wcxfOXdO7Xhq+zIGyKa7iixkS5nh1Opi47fsWbmV55oCghnvJObOemln8lxlNFhvTHW
         xeVrH0O8N5zlKMT1ijQB2xgbpYfeWzjs6w3pqqzEfyQ1oJ7GHZFbAlGmKqqDk3MGHIjo
         OmbhnvquMT8huOSJ4MDqpOLf0m7T7r4xOQxufu7BJOv2S3tXSwnBkqV5QwB/Tl6zYwVK
         x/Ab15xi9CnLnha3R+qn68D7YI9hYhBeY9wONEF/VSpgg9sAjLvzAQhP/o/RiGfXvG+C
         tMjw==
X-Forwarded-Encrypted: i=1; AJvYcCX64C+aJQRIOV3BNU7k3QrweuGgT3UKH3vjCjsq/KIplAowBjzXjn2sLA6njYxnW6iWYz7v+VlRqh/E17jnOOBN8fsaE3fuRw==
X-Gm-Message-State: AOJu0Yy68VHuo2UIjxPBH3lw7PzQ/wc8EsaY1YP6CIQ+RPIvsMVzwipu
	PMadAny/lLrBMXQby+Kscbgtef+0WCZZjMNZHPw7BCPoocZhZCqUoM9VD72lgAYHGdFtfACODkS
	vRugYWux1dd5P2yG41FM9Tewn+wTn0tkrA2xD50P+c7ng1hTstt4=
X-Google-Smtp-Source: AGHT+IGLZtJwgI1nygx1kF8oyAQhYuN/8m//WR987LuP4jm9fUk6c3m8+vXujyaR4jrSfMvB3zXKs6whSRV5URlbOJo=
X-Received: by 2002:a05:6402:3552:b0:59a:ac4c:9231 with SMTP id
 4fb4d7f45d1cf-59eefeae425mr2231802a12.29.1721163459651; Tue, 16 Jul 2024
 13:57:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240716152740.626160410@linuxfoundation.org>
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 17 Jul 2024 02:27:26 +0530
Message-ID: <CA+G9fYtJwjRPsomCFehVXyw27S1f9Uq6H1ZvH573ekakj7Mdng@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/78] 5.4.280-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 16 Jul 2024 at 21:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.280 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Jul 2024 15:27:21 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.280-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The 390 builds failed on stable-rc 5.10.222-rc1 review; it has been
reported on 6.6, 6.1, 5.15, 5.10 and now on 5.4.

Started from this round of stable rc on 5.4.280-rc1.

  Good:eee0f6627f74 ("Linux 5.4.279-rc2")
  BAD: 51945679d212 ("Linux 5.4.280-rc1")

* s390, build
  - clang-18-allnoconfig
  - clang-18-defconfig
  - clang-18-tinyconfig
  - clang-nightly-allnoconfig
  - clang-nightly-defconfig
  - clang-nightly-tinyconfig
  - gcc-12-allnoconfig
  - gcc-12-defconfig
  - gcc-12-tinyconfig
  - gcc-8-allnoconfig
  - gcc-8-defconfig-fe40093d
  - gcc-8-tinyconfig


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build log:
-------

arch/s390/include/asm/processor.h: In function '__load_psw_mask':
arch/s390/include/asm/processor.h:259:19: error: expected '=', ',',
';', 'asm' or '__attribute__' before '__uninitialized'
  259 |         psw_t psw __uninitialized;
      |                   ^~~~~~~~~~~~~~~
arch/s390/include/asm/processor.h:259:19: error: '__uninitialized'
undeclared (first use in this function); did you mean
'uninitialized_var'?
  259 |         psw_t psw __uninitialized;
      |                   ^~~~~~~~~~~~~~~
      |                   uninitialized_var
arch/s390/include/asm/processor.h:259:19: note: each undeclared
identifier is reported only once for each function it appears in
arch/s390/include/asm/processor.h:260:9: warning: ISO C90 forbids
mixed declarations and code [-Wdeclaration-after-statement]
  260 |         unsigned long addr;
      |         ^~~~~~~~
arch/s390/include/asm/processor.h:262:9: error: 'psw' undeclared
(first use in this function); did you mean 'psw_t'?
  262 |         psw.mask = mask;
      |         ^~~
      |         psw_t


metadata:
-----
  config: https://storage.tuxsuite.com/public/linaro/lkft/builds/2jKrMGFV9tK3IYnSE2ntEa22g0J/config
  download_url:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2jKrMGFV9tK3IYnSE2ntEa22g0J/
  git_describe: v5.4.279-79-g51945679d212
  git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git_sha: 51945679d212aae61a418eff41370c13da94f94d
  git_short_log: 51945679d212 ("Linux 5.4.280-rc1")
  arch: s390
  toolchain: gcc-12 and clang

Steps to reproduce:
----------
# tuxmake --runtime podman --target-arch s390 --toolchain gcc-12
--kconfig tinyconfig

--
Linaro LKFT
https://lkft.linaro.org
