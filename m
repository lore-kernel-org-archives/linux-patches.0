Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9FC202F63
	for <patches@lists.linux.dev>; Wed,  6 Nov 2024 15:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730905980; cv=none; b=OViwPIaLU60o0CHWzf500frBhmsR3MzEMSIq2k7XmY0qXmV1NQurWNFkXod7/zi8YpqzPTSMNLL5D8+tFuQcQMZHLj7shkGMacW5nA2aOHmGR9s5pvKwOj4GIcwMKJJvelEFVbx5CeUuqcfwzpA5jD4p+rO3GXftS2VaXAllJoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730905980; c=relaxed/simple;
	bh=hJwSnsQSETNFXzvgqfuf9ElowDht9infCxazmOXBa7U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V31lsCXnIrBnr0Zncl6kBNBN34CrOgOyxvSgOhfxooMsWyenfeqddWYz1D3g4JWr0nKEe6wzD4bRVuQTtbhfSc+fPEL/lYWCXmBnrY3pUkz/WZ3RZyQlcedr0heQk6pSzth8DbrPydld6cYYQ9IGSw7wkNNOXqzOiH90K+9y9fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IZhzGVL5; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IZhzGVL5"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-3e5f9712991so3323540b6e.2
        for <patches@lists.linux.dev>; Wed, 06 Nov 2024 07:12:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730905977; x=1731510777; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/s8MXlCqJ3S3d997kkGlOblTEnbIpL85LZHtL6uGm0Q=;
        b=IZhzGVL5khH2/zIVFyVIQN3DmycZWovKY28ly5G2eIDvusWoUHcR/g/5ALafoBwE8K
         UKq+Z9W0w2n+pHelljj+CKnKJMTQl/I1S01PFXaYMsp+DKjHCqGBJzdyBqWqzeibpHRy
         Ju41uC/CopOY6Rpav/ZcZd9eh9eMsNxh2iC0I7fwDx9IS4O6W1wwGb6ixps/v+jJLJUP
         intYC+ntMj26seRyyoJAE6u8U0C/8+H+Azh0OmsqvP/DLk8OSZy3aKd21sy30BzJ0DUD
         82xdvCr7i5hh1Ak8YDTUC8YDUTQgb+tUwXK9cZjXF8Hxb4gxplcND8ptOUWyJnMjCHzq
         Q+MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730905977; x=1731510777;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/s8MXlCqJ3S3d997kkGlOblTEnbIpL85LZHtL6uGm0Q=;
        b=FLwpArLhtwmJgn2KjuB54lXOQ9JQD2usIoGcl+apMw16IKxgZquQ0giPZOxFC4J1sD
         SopnSIeZ4vO9OuQSEEquc3h6Q5W2sASW8q1rZ0+QnHdpvnXDAgO01p6azsidSepewARy
         DvNlmVlJSAd8MaCdvhAbkfdQL8Jgio5rtNGokNK5uMdVP0PK/M4bU/La0qMwl5v3GZ59
         dEWuDkjFgxX//pFtyrCYc2jPBDpt8HqqZowiLKEANodArc3hSKvNWOzuaSJZOsadH/LG
         UnFMoaucuU0gnCuqmglAxHTlPZSpQEwlXAXsxxjIGrALtVZPSiPYhrKZxmgt4Wilmghq
         j30Q==
X-Forwarded-Encrypted: i=1; AJvYcCVUHeer/vd2Jl+tiWOM8vzwz/i6zjDS6rXEU9M3eDV48RXncefw16snGfNsBYzWs8zdHD1jhMOb@lists.linux.dev
X-Gm-Message-State: AOJu0Yx2B+0FzwEBJvxQUCLUYo279oVj3kx2xx8xesRLylC+LYcxeJix
	hwwnwt93HKx7R7yfmN1Zp9EQRC6y8MX05+iUSGnmzo0Duw0tfEJYwfiVibLtoW6VOt6Glsrh7mX
	i/ZXxoRoJVAMO0073dbBrjCfgSPA9p105l22Oxg==
X-Google-Smtp-Source: AGHT+IFK0O+catjkeLn95aRPwfONLUcgvqi/oAotqb/lG7yJa9aCtKL/wkazFs/bxZ/MPrgGD7dqggXgWdBZY7x6muM=
X-Received: by 2002:a05:6218:2814:b0:1b3:9b15:ac01 with SMTP id
 e5c5f4694b2df-1c5f98c5a83mr960654055d.3.1730905977486; Wed, 06 Nov 2024
 07:12:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241106120319.234238499@linuxfoundation.org>
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 6 Nov 2024 15:12:46 +0000
Message-ID: <CA+G9fYtjpUJFFV=FdqvW+5K+JL5ZYN4sPfVDjQovqzd7cib39w@mail.gmail.com>
Subject: Re: [PATCH 6.11 000/245] 6.11.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com, 
	broonie@kernel.org, Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, 
	David Sterba <dsterba@suse.com>, Linux btrfs <linux-btrfs@vger.kernel.org>, 
	linux-mips@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 6 Nov 2024 at 12:26, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.11.7 release.
> There are 245 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 08 Nov 2024 12:02:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The mips gcc-12 allmodconfig build failed on the Linux stable-rc
linux-6.11.y branch.


First seen on Linux stable-rc v6.11.4-642-g0e21c72fc970

  Good: v6.11.4-397-g4ccf0b49d5b6
  Bad:   v6.11.4-642-g0e21c72fc970

mips:
  build:
    * gcc-12-allmodconfig

Build errors:
-------------
ERROR: modpost: "__cmpxchg_small" [fs/btrfs/btrfs.ko] undefined!

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Links:
- https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.11.y/build/v6.11.4-642-g0e21c72fc970/testrun/25700362/suite/build/test/gcc-12-allmodconfig/log
- https://storage.tuxsuite.com/public/linaro/lkft/builds/2oTbq5WdzEalBxPXBBCuzLUA45b/
- https://storage.tuxsuite.com/public/linaro/lkft/builds/2oTbq5WdzEalBxPXBBCuzLUA45b/config

Steps to reproduce:
------------
   - tuxmake --runtime podman --target-arch mips --toolchain gcc-12
--kconfig allmodconfig

metadata:
----
  git describe: v6.11.4-642-g0e21c72fc970
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git sha: 0e21c72fc970e320e6c1ca9d81d2dce4aab95b3b
  kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2oTbq5WdzEalBxPXBBCuzLUA45b/config
  build url: https://storage.tuxsuite.com/public/linaro/lkft/builds/2oTbq5WdzEalBxPXBBCuzLUA45b/
  toolchain: gcc-12
  config: allmodconfig
  arch: mips

--
Linaro LKFT
https://lkft.linaro.org
