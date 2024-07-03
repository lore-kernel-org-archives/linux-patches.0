Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547723BBEA
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 08:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719997035; cv=none; b=Jt5NcPEUn2ADMwX05S8p//KSDUhU60QErgokfqNKscZzBGOg5I6go10nlsXoYYX/iwOLp+4aii16qBzNu20oG4GuFmdQrvkGITC+mgBNa45rcmeT03EVdcXPG0fnhO0zh3UJMoAkG9TjA2J3RXXYmQRDNluGXDcshiERiDEISZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719997035; c=relaxed/simple;
	bh=9P6gVWhaXfdGANh8cYupR+qgTAfXCsxjmt6x8vMHMpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bKXPRhBYjuaQGy+G0w1NKzJYaO6mmwtefY2cFVhfB0AVSvg+WOVvNk5Gh2DuI1CeuSacHeDVinQh7oHQTCEmSTN9flnOUbFbXWWad2x6nKkyDz3Npf70qbpRnng6EWq8dYAoEWJkT/rp4a5Ee/DNWfy1Gj4cHt6Jc9S/ax6IlAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OLcZXYHO; arc=none smtp.client-ip=209.85.217.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OLcZXYHO"
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-48f8f568ceaso191848137.1
        for <patches@lists.linux.dev>; Wed, 03 Jul 2024 01:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1719997032; x=1720601832; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0XEWnCj/mm3W7EIrD6z86rzpuQbyYOSDTNQl49iY71I=;
        b=OLcZXYHO6Rn+8BiT+aJ3rxVK4kN6wmLOG6TCqwF6YVDdGED/BfBERsjufbF56xZfc/
         al2i7tH9sPel6zx8deWREPXReyCG+GhMTXEpsrboqoltBY1eLNUhOfOO68yGt1+yJvol
         UZ/JwkCif+TjkcvfD5BOMJJGCCH1YQcyNX7eE1hAoQM/P9tqVoXJrB8IY4FGtG/WAN5y
         +3IJSr/OtQJCSYAphSCmvd/Zu8M7vYJ9+bId9Q7EkyxaEI1VTzaC1wvKGdggspM97D8H
         PvbdQGtIz9tPuGHW3N3pkNIIxLAIjzuleyUqlMjtiSXpfpLL2Jo6cF61Bn37C4IuaUMP
         G5kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719997032; x=1720601832;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0XEWnCj/mm3W7EIrD6z86rzpuQbyYOSDTNQl49iY71I=;
        b=kBkSoNoCMyYTOMrC+5qSURozepuGRC7OWUtgDoyxyWHGedp5+inX2ZWWKqaBtMPcxl
         1Pbztqk+WFb4Dkca+a/fe8WykvYejw1a6IAFHL5TP5mmUgFt2Qz1xo3lNibunp6kzmAl
         eWYqG79mbgwZJWMCfPVikCYI6e9696TWq9lTc4CMVLDsY0r8Bi6VvA2bmoMFWeooLAgj
         Us5w0hk7Vo3vHs+ccRtJgvvVCsGLvxFzcMyAPodsxn2nId95rS+B2UXccdeKctsaj3gN
         AE1Hwa91Yd2D2wwrodT7oHWgtvCqgNglgvVhlfHF8k9nLh9PxAOk3hBVlBtq+2ROo95o
         QeFw==
X-Forwarded-Encrypted: i=1; AJvYcCV2hTe2DtnlZO25rIODzC/lXx+F3Xd3UKGqdQVqaOCsLTeDKYad6Q2LJMdNSV4+4lGLFg/1tP/mLZXmygPkxZ88ikOoBwtF7g==
X-Gm-Message-State: AOJu0Yy6srMu8ADv7c7P1DRrrtfW3du+Twk3xbVNGv2NiDBSeaHeWo/T
	cWQX6KResBowO3PYj5QTinvSp0D97XczQEoT2V7k1hGmMEAfq8tcDPog991r5FP+XdZmNCdd89o
	kGPy2SlXWeTmW83//1WdUaqbIfKlZf1i1mQdpqw==
X-Google-Smtp-Source: AGHT+IHbkTRDyG2HvcG78gWTpQrxuOu/Y619sixvhYwI9yjX/IBnZ5qIyumvtHGWox7D6ggwzTkyRtApm42tixwUx2M=
X-Received: by 2002:a67:bd07:0:b0:48f:b5c1:7269 with SMTP id
 ada2fe7eead31-48fdeb0acc6mr352839137.0.1719997032251; Wed, 03 Jul 2024
 01:57:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240702170233.048122282@linuxfoundation.org>
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 3 Jul 2024 14:27:00 +0530
Message-ID: <CA+G9fYs=KkeYFMS01s3VZmeSYd1zJphinPFCk1G2AJ7LZ=+8=A@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/163] 6.6.37-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 2 Jul 2024 at 22:48, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.37 release.
> There are 163 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 04 Jul 2024 17:01:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.37-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The following powerpc builds failed on stable-rc 6.6.

powerpc:
 - gcc-13-defconfig
 - clang-18-defconfig

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build log:
---------
arch/powerpc/net/bpf_jit_comp.c: In function 'bpf_int_jit_compile':
arch/powerpc/net/bpf_jit_comp.c:208:17: error: ignoring return value
of 'bpf_jit_binary_lock_ro' declared with attribute
'warn_unused_result' [-Werror=unused-result]
  208 |                 bpf_jit_binary_lock_ro(bpf_hdr);
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors


Steps to reproduce:
---
 tuxmake --runtime podman --target-arch powerpc --toolchain gcc-13
--kconfig defconfig


Build log, Build configs and build details,
-------------
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.36-164-gca32fab2f2f9/testrun/24498135/suite/build/test/gcc-13-defconfig/log
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2ihU8SlMSZyrWYYdCJrskJS7cLd/
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2ihU8SlMSZyrWYYdCJrskJS7cLd/config
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.36-164-gca32fab2f2f9/testrun/24498135/suite/build/test/gcc-13-defconfig/details/

metadata:
------
* kernel: 6.6.37-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: ca32fab2f2f9ffc305606cc41fe02e41bce06dd6
* git describe: v6.6.36-164-gca32fab2f2f9
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.36-164-gca32fab2f2f9

--
Linaro LKFT
https://lkft.linaro.org
