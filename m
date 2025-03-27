Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF102F9FE
	for <patches@lists.linux.dev>; Thu, 27 Mar 2025 17:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743095106; cv=none; b=TwjJlnW0XfIpmjcNZqw/dwZlyayBwqccQiFNgiaCdxkcfgfYKu4L3lHWZvp2MwFs3wtzBMlI9pppzDJK3uS6OLbTPfqLruxqhEIW96SHRrZM8Ooo7NcOYUxktYOES0hKlfvzlRrRBGonbLD8Ii6pXUss/Iee5sHE2utiqcqcjSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743095106; c=relaxed/simple;
	bh=UCukrpff5csPN5PME//Bu0ltX0l7g8zKWFio8g/DdbY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LTX9/1VfD6phQoHhQx+yM4No9svbpYq3iZDKD26BHRSTZrSRU3dhB44ldAQNGyyGD9rTsEtyDlNaWeEA41JVFPjfV4TK4TJ7YEMjFo7t3050LULM+IFi7gznJ6dPgwiyfk9R81Znk1sqMAjlTYZfGFpafXLrNGIIxXKvDz0k3PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HnwOFX3e; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HnwOFX3e"
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-e643f235a34so989761276.1
        for <patches@lists.linux.dev>; Thu, 27 Mar 2025 10:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743095104; x=1743699904; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gIMP4nmwgubN4Pys5aTU2WlwnqqvwCpJ2MLL4ep//RA=;
        b=HnwOFX3enH7Ishm/AFYGfdVGs9pZE3CafJhqB3AapGQiuNgRwAcyp73fr3UkC10Nme
         4FkidhhLB5iJ2+kzpR1ocf2vnP0P6Bv3rmOV0EILNV1aGmDpBH9ZOr4/UEkXeQ1LF/F4
         LMy57+0xvix9Yy1rsn5BFgqVElMpGAZB81Pug0j0Yxo0iTEsbAPFMpC3PlEaDegup2/K
         MrACjJG5NY6y01YZLut9evUKT38EHFuMbVK+zgPfG3zC9Mvy7WIcnHrCiaazJOW5jT12
         xoNliqCdHeVa4TS6tcAkWpGL3ZrzlW+Fg8rQlUmoFP9cVYxPZKTFRgTU3t3NJYk7CrTp
         mvJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743095104; x=1743699904;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gIMP4nmwgubN4Pys5aTU2WlwnqqvwCpJ2MLL4ep//RA=;
        b=diAP2ULOu3wUpBDjkbteOO9JChZIEBjGFwTiiCqc3hZBcKVhlVq/RYc9DE8akzwRls
         OjGVWIRl+aRFtZG6/EYTeEhoHzkdU/1+2tHfJLwvn0oznWx9jsjfxpzFd8pBVdSYiUBo
         gvsorvsLbzufNTQBtNYLSv+nzRcNQanFnuFtnNcOtNFy8FclveuTFP3AZId+sJPqUp6D
         zfDje9rLw4BnBJzkbDliSMUW9etpsBk0fIFeopvq7jBFXXg6TziHI7t9iYeqbN8qh8w4
         e9Na+Gq5nFqk11Ls+LCAlRxZ98kg7dq+0h4AjVfCFRtL9f/M/XkVNVL7IvpqnBIww4of
         OyTQ==
X-Forwarded-Encrypted: i=1; AJvYcCVymolWfwy/AcR1q7KZJYLALOcQoMS1ViNUOhqi0rxLT1oIz6AV2vP7sLypFYlijNYiWVfyjr/2@lists.linux.dev
X-Gm-Message-State: AOJu0Yxj6ABvh9bK9isn3OihonlbBb7Eyv7PBSo3uxwzXwxiZklrsMsk
	X7jK/ZVF3ucf8lkXiObFBBNVboMTKtYJXZFkFYxf4RSKlEr6qFTn4bTsnoSwMvLuPj/d6L6960S
	PlPrdDnxfPMjxeWJSCR904OuiRLI=
X-Gm-Gg: ASbGncu+jAlLVH5l7eGq7yBsq1vaub+UmekRQPWS8+pr+DfSgl41/gYrGhx2UgIxUuA
	nEtjQFS5qbcP4ioFKrrtb45gS5mk1emoHVt0Vpg++ma6VrfXo+HzsFvojsOaFjMfDnyTDeyGQg7
	QPzFt6wPYdwj0F0QI+5DtAs2/vOyPfwMVg4LHnbxRpFqVVxHI7zt/aDoI=
X-Google-Smtp-Source: AGHT+IE0V4W9RPbFnppqS3nJN9J9jxtEhxV4mELuux5c5aERSjVw4aOfjObJ5DON3dZ9u7fr2lGONyc2RPHgBUOPdqI=
X-Received: by 2002:a05:6902:478b:b0:e58:aa00:ffd5 with SMTP id
 3f1490d57ef6-e69435eb3d5mr5861203276.4.1743095103548; Thu, 27 Mar 2025
 10:05:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250326154349.272647840@linuxfoundation.org> <CA+G9fYsRQub2qq0ePDs6aBAc+0qHRGwH_WPsTfhcwkviD1eH1w@mail.gmail.com>
In-Reply-To: <CA+G9fYsRQub2qq0ePDs6aBAc+0qHRGwH_WPsTfhcwkviD1eH1w@mail.gmail.com>
From: Leah Rumancik <leah.rumancik@gmail.com>
Date: Thu, 27 Mar 2025 10:04:52 -0700
X-Gm-Features: AQ5f1JoUWc8i3RgAxN3mjRbk-tD1j9a8iUSQkbDB7BjyLErxq3tg2jL0zFBfxIE
Message-ID: <CACzhbgQ=TU-C=MvU=fNRwZuFKBRgnrXzQZw15HVci_vT5w8O7Q@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/197] 6.1.132-rc2 review
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, 
	Anders Roxell <anders.roxell@linaro.org>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This is fixed by

https://lore.kernel.org/all/20250321010112.3386403-1-leah.rumancik@gmail.co=
m/T/

but I'm waiting on an ACK. Let me do some nagging :)

- leah



On Thu, Mar 27, 2025 at 5:50=E2=80=AFAM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> On Wed, 26 Mar 2025 at 21:15, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.1.132 release.
> > There are 197 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 28 Mar 2025 15:43:27 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patc=
h-6.1.132-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-6.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> Regressions on arm, arm64, mips, powerpc builds failed with gcc-13 and
> clang the stable-rc 6.1.132-rc1 and 6.1.132-rc2.
>
> First seen on the 6.1.132-rc1
>  Good: v6.1.131
>  Bad: Linux 6.1.132-rc1 and Linux 6.1.132-rc2
>
> * arm, build
>   - clang-20-davinci_all_defconfig
>   - clang-nightly-davinci_all_defconfig
>   - gcc-13-davinci_all_defconfig
>   - gcc-8-davinci_all_defconfig
>
> * arm64, build
>   - gcc-12-lkftconfig-graviton4
>   - gcc-12-lkftconfig-graviton4-kselftest-frag
>   - gcc-12-lkftconfig-graviton4-no-kselftest-frag
>
> * mips, build
>   - gcc-12-malta_defconfig
>   - gcc-8-malta_defconfig
>
> * powerpc, build
>   - clang-20-defconfig
>   - clang-20-ppc64e_defconfig
>   - clang-nightly-defconfig
>   - clang-nightly-ppc64e_defconfig
>   - gcc-13-defconfig
>   - gcc-13-ppc64e_defconfig
>   - gcc-13-ppc6xx_defconfig
>   - gcc-8-defconfig
>   - gcc-8-ppc64e_defconfig
>   - gcc-8-ppc6xx_defconfig
>
> Regression Analysis:
>  - New regression? yes
>  - Reproducibility? Yes
>
> Build regression: arm arm64 mips powerpc xfs_alloc.c 'mp' undeclared
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> ## Build log
> fs/xfs/libxfs/xfs_alloc.c: In function '__xfs_free_extent_later':
> fs/xfs/libxfs/xfs_alloc.c:2551:51: error: 'mp' undeclared (first use
> in this function); did you mean 'tp'?
>  2551 |         if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbext(mp, bno, len)))
>       |                                                   ^~
>
>
> ## Source
> * Kernel version: 6.1.132-rc2
> * Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-=
stable-rc.git
> * Git sha: f5ad54ef021f6fb63ac97b3dec5efa9cc1a2eb51
> * Git describe: v6.1.131-198-gf5ad54ef021f
> * Project details:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1=
.131-198-gf5ad54ef021f/
>
> ## Build
> * Build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1=
.y/build/v6.1.131-198-gf5ad54ef021f/testrun/27785617/suite/build/test/gcc-1=
2-lkftconfig-graviton4-kselftest-frag/log
> * Build history:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1=
.131-198-gf5ad54ef021f/testrun/27785617/suite/build/test/gcc-12-lkftconfig-=
graviton4-kselftest-frag/history/
> * Build details:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1=
.131-198-gf5ad54ef021f/testrun/27785617/suite/build/test/gcc-12-lkftconfig-=
graviton4-kselftest-frag/
> * Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2urS=
wNctsyhQzf1j7dvt6nHemP5/
> * Kernel config:
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2urSwNctsyhQzf1j7d=
vt6nHemP5/config
>
> ## Steps to reproduce
>  - tuxmake --runtime podman --target-arch arm64 --toolchain gcc-12 \
>     --kconfig https://storage.tuxsuite.com/public/linaro/lkft/builds/2urS=
wNctsyhQzf1j7dvt6nHemP5/config
> debugkernel dtbs dtbs-legacy headers kernel kselftest modules
>  - tuxmake --runtime podman --target-arch arm --toolchain clang-20
> --kconfig davinci_all_defconfig LLVM=3D1 LLVM_IAS=3D1
>
>
> --
> Linaro LKFT
> https://lkft.linaro.org
