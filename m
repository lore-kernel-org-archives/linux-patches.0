Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71781EB5F0
	for <patches@lists.linux.dev>; Tue, 13 May 2025 13:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747142975; cv=none; b=uT3a+YhIhvu77niZtCKtVzXtG39EQ8XCqdo5E656tvt8FNUpks20i/NHAgSpph/lCh2jYahzwyedU1uAW9DgT6+meRKES6b+fKi5BK1wDHLgQTY8PG6h1+gDI07PawnG6f6X6LMQjQ4GnodHJvL9HJIJ3wTPh7X0O5BNhlpN27Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747142975; c=relaxed/simple;
	bh=pIZnqAbvKi6g6bM9xBkbfMYNKRFSU6d2NCIENbAWFOs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dvwjcNQwopQ2EeI4u4ZDo23CQ3m6nwajJbOtfTBcmD85Wl8hRlDcXbZR2FJnsBW6IoiiRZ+PKIF2zFKX00/e5lFGOSob0Jz47eOhhc2gJ0Xwu89IBSdSCkvSZUjWIt2SWmYoYs0Q+SgoPuQ4Iu+mWZypI9xvY1hffBQBPm8qF/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nifmLZU5; arc=none smtp.client-ip=209.85.217.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nifmLZU5"
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-4c6cf5e4cd5so5033736137.2
        for <patches@lists.linux.dev>; Tue, 13 May 2025 06:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747142971; x=1747747771; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LZEie1OhAZfjtagVfLYxTcaBKPW2X7YkdVD9WseQzgE=;
        b=nifmLZU53DomkzKHAve3ShVvfVAHFOLQnvdfyS086xCv1Er9qdgdvxkOwXqCfnUvJi
         DXRwWZaabUUoES69jLeIN4dFR8PLVjCIeFB5a3pDsUgL/KGiJqQVd0kCbnPBO66j3GPG
         roWI5OvP7v/WTN9Q5YQuFNVF7M9KSVWiAiuQbNSad18xsPDW6PSiFr7f1yQ9V+9JtdZB
         WyoHzzbaDnx306Q8bvDdUaNwjEqN0LXt80BDSkVkByXEY3jPktm2kKcbXw0I+GO5nCTx
         WsnzyKfmhacXXgiTdynEohaq+iKfuwLSzgSemEEwCBZePV72JCsWS1zE8IV8eghJAd4J
         UAXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747142971; x=1747747771;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LZEie1OhAZfjtagVfLYxTcaBKPW2X7YkdVD9WseQzgE=;
        b=evEPzvI//SGERGNR1/lvlyO7xfXPI6UPrdwlu4oLe2tb2UsUEphQcjw+J/23/dhu7T
         9weVMXf7K+Ta2meyq85hXr/uLLXHD5iBhdbFYoOdkiBDKi1VZcFZdNPmgmz9h3rWUZPN
         qzaeyjydHTaizW2MDQmzLizxTQL+vEtCdbJKwjDFYf9nmDEN3uTmk/s8f+B6U2NWc5lb
         IMwuzdBS+hvHRhXPut5rFeAoZGvj8DeRTBAk1ooJuJsmaSro8KOnyPS+S2A6gEE6OH+1
         5CUXkBZIaoRUClUciq1UF+N5Di6uxFtYMhi8KRRKGfgs+Mp6LmTL+Ko2/5N1D6c/1gqu
         BKnA==
X-Forwarded-Encrypted: i=1; AJvYcCULYUeRf0JznR8oiztGsXb+47MLjoBAYzBIBZKkhBERJfuSE0Er0wPr3xLRHNcpCYmUbC/x33ds@lists.linux.dev
X-Gm-Message-State: AOJu0YwwddurPkg5D3Hkc022Rf8cPxEgDWK3aLyTPVFKXEqeQoohp/3H
	iii7Z8pyOtpfWQIi3flct1xEQHSubDzNrwQH/ohikx+JwcCA5FQzyGWy6iCuCoPae+YqZXLXGx0
	Kck/+X6dj0qoRbJeP4vbvHa9jR//mFGzx74qxWhPfHy78dADdv1A=
X-Gm-Gg: ASbGncv1oaUBu6NOMYCZWczS8azVMv9wrnhA9uU+3vV9GJLoLFmsUU5VmHkLONBOsuO
	A7joW+pxyXeS3AusWFvOloajmA+V0C8znA/Jycf7S1iTS4AL+tBypYCQkI3uOPS/aARcz9UR1Jo
	C9arcdJ5zyNkhwUgQ3Iy3J7RrwIEyh31I=
X-Google-Smtp-Source: AGHT+IHlbMMFq5nAfSA83CCKmxe6r5lw+vXbf9voMmrMRSDCezf0HsCPwNDvoXL3icNnJqJh9L6Y0Q0gPm4WwUngrEA=
X-Received: by 2002:a05:6102:2c08:b0:4c1:9b88:5c30 with SMTP id
 ada2fe7eead31-4deed3d3870mr14789892137.19.1747142971375; Tue, 13 May 2025
 06:29:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250512172044.326436266@linuxfoundation.org> <CA+G9fYuO5m0EgOAbytJv2Ytp9uj-0jHVUGddaXHLckHk+ZLEHA@mail.gmail.com>
In-Reply-To: <CA+G9fYuO5m0EgOAbytJv2Ytp9uj-0jHVUGddaXHLckHk+ZLEHA@mail.gmail.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 13 May 2025 14:29:20 +0100
X-Gm-Features: AX0GCFvoub22XkeGUwB2DkAUVguhCcizeWQN8lgksWkCPZabNB8ZW-3lo3CS3bQ
Message-ID: <CA+G9fYsGTqCxiXQOY3HEu4Z3CEwmyQoOb8DnpzVToWMW-Y8R5A@mail.gmail.com>
Subject: Re: [PATCH 6.14 000/197] 6.14.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, clang-built-linux <llvm@lists.linux.dev>, 
	Anders Roxell <anders.roxell@linaro.org>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Arnd Bergmann <arnd@arndb.de>, Nathan Chancellor <nathan@kernel.org>, 
	Marco Crivellari <marco.crivellari@suse.com>, Thorsten Blum <thorsten.blum@linux.dev>, 
	linux-mips@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 13 May 2025 at 11:40, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Mon, 12 May 2025 at 18:43, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.14.7 release.
> > There are 197 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 14 May 2025 17:19:58 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.7-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> Regressions on mips defconfig tinyconfig and allnoconfig builds failed with
> clang-20 toolchain on stable-rc  6.14.7-rc1, 6.12.29-rc1 and 6.6.91-rc1.
> But, builds pass with gcc-13.
>
> * mips, build
>   - clang-20-allnoconfig
>   - clang-20-defconfig
>   - clang-20-tinyconfig
>   - korg-clang-20-lkftconfig-hardening
>   - korg-clang-20-lkftconfig-lto-full
>   - korg-clang-20-lkftconfig-lto-thing
>
> Regression Analysis:
>  - New regression? Yes
>  - Reproducibility? Yes
>
> Build regression: mips defconfig clang-20 instantiation error expected
> an immediate
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> ## Build error mips
> <instantiation>:7:11: error: expected an immediate
>  ori $26, r4k_wait_idle_size - 2
>           ^
> <instantiation>:10:13: error: expected an immediate
>  addiu $26, r4k_wait_exit - r4k_wait_insn + 2
>             ^
> <instantiation>:10:29: error: expected an immediate
>  addiu $26, r4k_wait_exit - r4k_wait_insn + 2
>                             ^
> <instantiation>:7:11: error: expected an immediate
>  ori $26, r4k_wait_idle_size - 2
>           ^
> <instantiation>:10:13: error: expected an immediate
>  addiu $26, r4k_wait_exit - r4k_wait_insn + 2
>             ^
> <instantiation>:10:29: error: expected an immediate
>  addiu $26, r4k_wait_exit - r4k_wait_insn + 2
>                             ^


The bisection found this as first bad commit,

    MIPS: Fix idle VS timer enqueue

    [ Upstream commit 56651128e2fbad80f632f388d6bf1f39c928267a ]

- Naresh Kamboju
