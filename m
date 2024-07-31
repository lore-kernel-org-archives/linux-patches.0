Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9E31AAE00
	for <patches@lists.linux.dev>; Wed, 31 Jul 2024 09:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722418662; cv=none; b=INNh3G0/tKfBWKZHvWqnA2xRL4pubLEOUJeWrxDtePcAnPdOoj8vbVJdO9lIJjSacgl6aHkzcJLiyhGO2KFljLScwmOqqMCh6NAAjTuEv79soSYFcjJiOaOJo2RQRSffTDjPGOjXqBe+tEtndrDkQLhTuh0kdd9sMbHN4C1VD0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722418662; c=relaxed/simple;
	bh=3PqYnVZVjS8Nchubqr5TZb9ZbM9gnu42tzIZibGM38k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mQfVF/Oaa8ExwqmbIdHP8jkhDePX94xnzkzVv06Swv7EMzmDcGktbD9bvxv1bc17vBgPz1tgSG9pcYx0InsttL2so76tsy/wDFQBKjR6Xt8NtBfRUmpouunvXEe8bKpo1myUhRmTFVYxh2I69hq40opnhyywOREChsi5ZhhOtP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=t888snPU; arc=none smtp.client-ip=209.85.217.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="t888snPU"
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-4929992a5e2so901833137.2
        for <patches@lists.linux.dev>; Wed, 31 Jul 2024 02:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722418659; x=1723023459; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KUB2XfCmuTVubROS/hczkI5vuM+eVf8X/sAgSSkYLs0=;
        b=t888snPUsK7/I/M06ftqu1PkjQ++1Dki0CNPY2Z+vktsIZrV7D66Cktkp5ipTiou4f
         SFMviSPL14ujD6OlctZegvdRKTTAG8brdQ4L9zvDLK5+UGxw5gmXtBVPh62jDtePHLNB
         LPXy4CLEqBkMl0tD/NfYyW7Ku7z4CXlfAYoY2jWMYYJ46FLOo3oqeB0BsSsA4hER3Par
         rGWQ1Xu63dovqLz6mzKiIH+UQBkqypSFRhU6Xz75ISnQCj5lJCqXYQd406bHi23lVGCm
         siu685uAD5FsYV2ZthznqmA2OxoNOSI5yEbWP6RghrfR1uFIAk62XMlzLPvfjaPO+uL4
         jz9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722418659; x=1723023459;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KUB2XfCmuTVubROS/hczkI5vuM+eVf8X/sAgSSkYLs0=;
        b=cAmHvnH1CyfTxTy9UVQ66vlIohBhvWcQj9kjJ6pIJXIFt7c1CALANmoHJ0i8LlBXrw
         EgMrFy2iOpomCINq4Ky+JEZQfkqdmcLh5YuJF3xT1KoGzjM1w7f/SU1cI3QuWKNQF9DP
         07cn3SHyy3RrTAHc+C7qNFempEnGcTtuqNqbPUPdWM/7MrXfVK2QFyJEj8N012xxcUtK
         6ClSvpquCYMEruLhuQVUoBagUhXuXH8CsR3FafKlVZ+LVeJ8Gk3xHREsIjxc6wn/4g/8
         vCqhJWAZ2dv9Anuu6BsxrTBFwU9pR5tiwBYfwk+O4Q/y66GcnzUp/hoNc6PnWEDUC/oA
         rw/A==
X-Forwarded-Encrypted: i=1; AJvYcCUie/dHdBvNZIiDJPDPf/nJdIsfdR59Li+ufN8GGcX2WfrMTkW5AOeJIRkris7V05CO/uyFMCzGjWb/8hQxHrT04KKt4Wgc4w==
X-Gm-Message-State: AOJu0YzqpWkWwNpHlNUomsQD1uRMl2unfEw0SMDmWiL4fykwda60NMh/
	FCnLqrrjtQ6vYke4oPOYKwc5gTLG0ndl0UjR0AZTVYhgmKEaVSJOzB04Lx3pIBtpEqcwbwGJb//
	X77Whis1+yrZ8bIwytpWwObQ3dQSjkqeQHDg8Iw==
X-Google-Smtp-Source: AGHT+IFwnHFkgq2DRdLx+mwGenItfQdCUaBvRiNx3dWS7SZyP0MZEu7BMjqAOHN1DQFd77LTqPl7sD/Jd5/SE6O03hI=
X-Received: by 2002:a05:6102:548b:b0:493:bbd7:3ec0 with SMTP id
 ada2fe7eead31-493fad0d470mr11329869137.23.1722418659376; Wed, 31 Jul 2024
 02:37:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240731073151.415444841@linuxfoundation.org>
In-Reply-To: <20240731073151.415444841@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 31 Jul 2024 15:07:28 +0530
Message-ID: <CA+G9fYsGYtFhoSZbv_s=3TCSYis-pSPDJ3LJwxbtv1_9+Q61JQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/441] 6.1.103-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Thomas Richter <tmricht@linux.ibm.com>, linux-s390@vger.kernel.org, 
	Anders Roxell <anders.roxell@linaro.org>, Arnd Bergmann <arnd@arndb.de>, 
	Dan Carpenter <dan.carpenter@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 31 Jul 2024 at 13:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.103 release.
> There are 441 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 02 Aug 2024 07:30:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.103-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


On the 6.1.103-rc2 (and 6.1.103-rc1 ) s390 builds failed with gcc and
clang due to
following warnings / errors.

* s390, build
  - clang-18-defconfig
  - clang-nightly-defconfig
  - gcc-13-defconfig
  - gcc-8-defconfig-fe40093d

Build log:
--------
arch/s390/kernel/perf_cpum_cf.c: In function 'cfdiag_diffctr':
arch/s390/kernel/perf_cpum_cf.c:226:22: error: implicit declaration of
function 'cpum_cf_read_setsize'; did you mean 'cpum_cf_ctrset_size'?
[-Werror=implicit-function-declaration]
  226 |                 if (!cpum_cf_read_setsize(i))
      |                      ^~~~~~~~~~~~~~~~~~~~
      |                      cpum_cf_ctrset_size
cc1: some warnings being treated as errors

commit log:
--------
  s390/cpum_cf: Fix endless loop in CF_DIAG event stop
  [ Upstream commit e6ce1f12d777f6ee22b20e10ae6a771e7e6f44f5 ]


Metadata:
--------
  build_name: gcc-13-defconfig
  config: https://storage.tuxsuite.com/public/linaro/lkft/builds/2k0Kna66eRxxtDjqsue5mHG0j8L/config
  download_url:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2k0Kna66eRxxtDjqsue5mHG0j8L/
  git_describe: v6.1.102-442-g5ad01ec1b787
  git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git_sha: 5ad01ec1b7877a0e30c018e28e3909f96dbcef8d
  git_short_log: 5ad01ec1b787 ("Linux 6.1.103-rc2")
  compiler{'name': 's390x-linux-gnu-gcc', 'version': '13',
'version_full': 's390x-linux-gnu-gcc (Debian 13.2.0-12) 13.2.0'}

--
Linaro LKFT
https://lkft.linaro.org
