Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD5E54782
	for <patches@lists.linux.dev>; Thu, 27 Mar 2025 23:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743117573; cv=none; b=k+NDjRD5qJwbCTDGePbvOfqFw31L7j3QtXjpbuoIXKlkZrqPB2peem+Y/fvZevzABCB15+nDr7uPfRlt6aL+G+dEfZUb74jYk0Wh4aXKkW7SB6BUT4fVTI/E+hSFPEX8srDYNI+YmV+4LikJF2Ar7UqKNX4+9Dsb3dlDcKfdudc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743117573; c=relaxed/simple;
	bh=JtHkof5Kn1s3OvzmD5FvCZbT7RpY4G+M3J77IZkSWJk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KeLGk8aZ8EFbJWvu4yjZeYLpFH2RVxaAKEvEhgEA6Tap/k/MHsKDPDr8kDgWv4z0R+iGoDxJ2f6vOW9/y0fK6Di49Ekm/oeKY2lrbKUtddmFqBDbstdQ4U5605oS0bBxGog6Wmee3lvGBJSn28wg483X/U7dx3hTBcufXejhEHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EoFRMafB; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EoFRMafB"
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e3978c00a5aso1356640276.1
        for <patches@lists.linux.dev>; Thu, 27 Mar 2025 16:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743117569; x=1743722369; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aMnF9vs8JB47IN/cDkEjD5+fBKENuY4T9JJxCznicyY=;
        b=EoFRMafBHpqasMEQcP5dITQWrmfo/jmITJ08zrQtKG6Ayki6Z28HzZFg7rcNhjj4LV
         AqUFZQXT1et/0N0B+TFJwhhiplSIMk3WnnOy1QqXF2X1obJyYw5E2Xp4tOjd5G1s2Q3z
         2dq7C0vDNh6IMcvGl2Ug/LyKr6jN7wQ5dbhhKsPya3Plrosd/9Lw5R5aN9A7dpoWo/n2
         q2dLGrkukk8t/HOorbtQfkb2bmIi4RHkut9uUDjR3TwLAdDtruiyAXN/VdWEG6tZPAYg
         LDrEdvX2ZfriTU9VnJBaLG/lZ7ojSRmp9LC0BSA1f2uK9FsIZ7/BwZyeZXjU+ofH7VOc
         Kq5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743117569; x=1743722369;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aMnF9vs8JB47IN/cDkEjD5+fBKENuY4T9JJxCznicyY=;
        b=M9A0EodhP4pIMV3wDET3HYalMcXErH4J/71zRl5ofoWXLM4qqWbfOL16MPjTL5HjnI
         eZ6gg8wXzD34Lpd2kQ+6iVRqGiMts0YNsi4gXsg9mMIEN2cn9WQ5WXvCoJENdeaKMmOq
         o/dkdJgSXtIh/pPeiPc1c18iLXG5lNirScPL3pA+2+3db0850I31pF8Dbby8WXNGy1BR
         LvcD8Rv9/o3Mmx9oUYdXg8LjGEi3q3lmUNCdANrH/Mvbm3ZeLMl3370BtnbSTiutQDP8
         4j/9t6v2TEkHbXGaXltDl3xAZ7SEwLWQxxC8vkieWuNn6vgq/0/QQzrsOvDwpZY5v9dw
         b3lQ==
X-Forwarded-Encrypted: i=1; AJvYcCWOZTSThohvFFdz1L82OqXzllR7PI9Q5f1rC01yuR22GP0/gak00yjujM7r1y5SwEYEYnZNkNyh@lists.linux.dev
X-Gm-Message-State: AOJu0Ywjm0Kqaz8oFnLxKF2gGQnrLw98McYXUvLJznv9hPqGlGXx5/LE
	P+u5thxpcTI2fh6jppUZBitYTE+TPrcB8B56zVsjcP6eHXebFT8FntgnSq1Bm0at3k3Y6RCDdr6
	1CYm9Tqe4qx0e1HtZ198pwjSJuMM=
X-Gm-Gg: ASbGncvldK83hlp2JdI9Urcv/CIngQrsSwL9SRlAy/RtGY7JnwsB28cwf087VjiHi0I
	nNcEp+yaTPpv/SmXN2RXkPU7i8dMBalzRf6kCc970NTB2TyDCv4iztlGuCAD52BF+sgIDTcGGPI
	T8ByDAWjbJYdMTwM1KazVQe7NW7G0D8SgwaYv0tskLAZ7qdPm403Bv1uc=
X-Google-Smtp-Source: AGHT+IFFzruC25MmRQ8O0m11e88aqMai4IgHeja7o6hpsDHutAEbLnqb6CJ+2QXVsTRPqdu8ITPVSGFdMHLnDsZUS7Q=
X-Received: by 2002:a05:6902:4a03:b0:e6b:769f:556b with SMTP id
 3f1490d57ef6-e6b769f5aa6mr107233276.35.1743117568538; Thu, 27 Mar 2025
 16:19:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250326154349.272647840@linuxfoundation.org> <CA+G9fYsRQub2qq0ePDs6aBAc+0qHRGwH_WPsTfhcwkviD1eH1w@mail.gmail.com>
 <CACzhbgQ=TU-C=MvU=fNRwZuFKBRgnrXzQZw15HVci_vT5w8O7Q@mail.gmail.com>
In-Reply-To: <CACzhbgQ=TU-C=MvU=fNRwZuFKBRgnrXzQZw15HVci_vT5w8O7Q@mail.gmail.com>
From: Leah Rumancik <leah.rumancik@gmail.com>
Date: Thu, 27 Mar 2025 16:19:16 -0700
X-Gm-Features: AQ5f1Jp8lXbaNFjXv08hBRv1tfhk1348_npPOImkZqUQgUwZQdNGnYymj_B4y2o
Message-ID: <CACzhbgTQCuig6eqOJFshthQfT5-7cVkemY9VtO_vu4d+aTcU=Q@mail.gmail.com>
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

sent to stable:
https://lore.kernel.org/stable/20250327215925.3423507-1-leah.rumancik@gmail=
.com/


On Thu, Mar 27, 2025 at 10:04=E2=80=AFAM Leah Rumancik <leah.rumancik@gmail=
.com> wrote:
>
> This is fixed by
>
> https://lore.kernel.org/all/20250321010112.3386403-1-leah.rumancik@gmail.=
com/T/
>
> but I'm waiting on an ACK. Let me do some nagging :)
>
> - leah
>
>
>
> On Thu, Mar 27, 2025 at 5:50=E2=80=AFAM Naresh Kamboju
> <naresh.kamboju@linaro.org> wrote:
> >
> > On Wed, 26 Mar 2025 at 21:15, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 6.1.132 release.
> > > There are 197 patches in this series, all will be posted as a respons=
e
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >
> > > Responses should be made by Fri, 28 Mar 2025 15:43:27 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/pa=
tch-6.1.132-rc2.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git linux-6.1.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > Regressions on arm, arm64, mips, powerpc builds failed with gcc-13 and
> > clang the stable-rc 6.1.132-rc1 and 6.1.132-rc2.
> >
> > First seen on the 6.1.132-rc1
> >  Good: v6.1.131
> >  Bad: Linux 6.1.132-rc1 and Linux 6.1.132-rc2
> >
> > * arm, build
> >   - clang-20-davinci_all_defconfig
> >   - clang-nightly-davinci_all_defconfig
> >   - gcc-13-davinci_all_defconfig
> >   - gcc-8-davinci_all_defconfig
> >
> > * arm64, build
> >   - gcc-12-lkftconfig-graviton4
> >   - gcc-12-lkftconfig-graviton4-kselftest-frag
> >   - gcc-12-lkftconfig-graviton4-no-kselftest-frag
> >
> > * mips, build
> >   - gcc-12-malta_defconfig
> >   - gcc-8-malta_defconfig
> >
> > * powerpc, build
> >   - clang-20-defconfig
> >   - clang-20-ppc64e_defconfig
> >   - clang-nightly-defconfig
> >   - clang-nightly-ppc64e_defconfig
> >   - gcc-13-defconfig
> >   - gcc-13-ppc64e_defconfig
> >   - gcc-13-ppc6xx_defconfig
> >   - gcc-8-defconfig
> >   - gcc-8-ppc64e_defconfig
> >   - gcc-8-ppc6xx_defconfig
> >
> > Regression Analysis:
> >  - New regression? yes
> >  - Reproducibility? Yes
> >
> > Build regression: arm arm64 mips powerpc xfs_alloc.c 'mp' undeclared
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> > ## Build log
> > fs/xfs/libxfs/xfs_alloc.c: In function '__xfs_free_extent_later':
> > fs/xfs/libxfs/xfs_alloc.c:2551:51: error: 'mp' undeclared (first use
> > in this function); did you mean 'tp'?
> >  2551 |         if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbext(mp, bno, len)=
))
> >       |                                                   ^~
> >
> >
> > ## Source
> > * Kernel version: 6.1.132-rc2
> > * Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linu=
x-stable-rc.git
> > * Git sha: f5ad54ef021f6fb63ac97b3dec5efa9cc1a2eb51
> > * Git describe: v6.1.131-198-gf5ad54ef021f
> > * Project details:
> > https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6=
.1.131-198-gf5ad54ef021f/
> >
> > ## Build
> > * Build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6=
.1.y/build/v6.1.131-198-gf5ad54ef021f/testrun/27785617/suite/build/test/gcc=
-12-lkftconfig-graviton4-kselftest-frag/log
> > * Build history:
> > https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6=
.1.131-198-gf5ad54ef021f/testrun/27785617/suite/build/test/gcc-12-lkftconfi=
g-graviton4-kselftest-frag/history/
> > * Build details:
> > https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6=
.1.131-198-gf5ad54ef021f/testrun/27785617/suite/build/test/gcc-12-lkftconfi=
g-graviton4-kselftest-frag/
> > * Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2u=
rSwNctsyhQzf1j7dvt6nHemP5/
> > * Kernel config:
> > https://storage.tuxsuite.com/public/linaro/lkft/builds/2urSwNctsyhQzf1j=
7dvt6nHemP5/config
> >
> > ## Steps to reproduce
> >  - tuxmake --runtime podman --target-arch arm64 --toolchain gcc-12 \
> >     --kconfig https://storage.tuxsuite.com/public/linaro/lkft/builds/2u=
rSwNctsyhQzf1j7dvt6nHemP5/config
> > debugkernel dtbs dtbs-legacy headers kernel kselftest modules
> >  - tuxmake --runtime podman --target-arch arm --toolchain clang-20
> > --kconfig davinci_all_defconfig LLVM=3D1 LLVM_IAS=3D1
> >
> >
> > --
> > Linaro LKFT
> > https://lkft.linaro.org
