Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8E85F48A
	for <patches@lists.linux.dev>; Tue,  5 Mar 2024 10:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709634239; cv=none; b=Y/m31QQFXNXUK15dtY0tQ116A9cXSIQU19TB+OH59vOpWMEYGyNKSOpbyjdlGWFxvrjXzZDGZz2lmsqCtjAym2hRHFrq90M65Sodj0P7/M/8jns9n2QDKSU/pYWuI/ZmZLIvr1eSMpOmOpZHDeafNUqf41la0+lZXhWL7xoLJQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709634239; c=relaxed/simple;
	bh=PqHa9jZYY6n6dlsBNRS5MBKuLT4wieT6fvPpCzLLJ7E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e8JaJMGeW15aj1g3d+YobBtNhNnf8akYXKZyMcDl7s+GGSXy4iZmzvVJEfZLozxJkS9zjw4JvYpZUVfgeaimBHayLSoXr4SCubtP1BqRHK6sCVaRPOIu2UAFqhvMQyAaWwnoFohSeoi1HHTcCPt2fqP+cKmtrtMrVBRw8ZRFQK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wNwz328C; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wNwz328C"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-56715a6aa55so2685514a12.2
        for <patches@lists.linux.dev>; Tue, 05 Mar 2024 02:23:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709634235; x=1710239035; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PlspS2X5YJwHI6bCWiB2Kxx+bO+ABr/mcVKBji0Oxwk=;
        b=wNwz328CSWAXFlNxZMo1RK3d8gCjVQeI6OQNduELlbYCVL51OuVRXLmc89U5OAK7E/
         NMyGtyLGnT0B1JYX3RqfIPRnPdrKXYqsZu9pe0X+/hOxIrUARU6c80jqQ5l7T2Q37C/j
         4MxOt6IqZloW0fA5nOnkjvoMdC8NNCCnHfJmz8i+dR/SrigCGglHnduqcKq7v2MO68d7
         qhJXkVMRgd6njf+DYAXiStF+LoB0DGyi391Qqo0OFP8ybjia57w1QSphbzi9JYhps8NT
         M2AWBymSlaNMykXrzm6GhyCElr1bGErM41wun0PxEyetm1D7ttwge9VxCLOT7+Gg60V0
         8ccg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709634235; x=1710239035;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PlspS2X5YJwHI6bCWiB2Kxx+bO+ABr/mcVKBji0Oxwk=;
        b=Hayxr66+p0Oy8ROrGoelqk5/flH4ku26JfGrcdO+kHdT8E5+5e7o24EDfQFBSD8gYT
         zU7ouBqTFj1Nisbdv8B1jSgbQ9OMZK/fSG+Mr5bVXZ4eI1KfYjnbbwHEfQ992+Lc1qcM
         Pzru0ooYwkGpnxTqMXo9pYiU/4i9RGmQBrfOJsprvPc+E2nXjBP8faDq/UwV1q8TSJuY
         CPCMzrpx9LgasgHtp++88ntZPwm1H3ddsDGmziJt0Ub6qE+4VF7BZn/HUFfl/cMOKkyE
         fDg9ALLMKDeymD1+kr2M6EgGPNE+CRRgqO/OwDn8rg6CizYWA+oIW+Hp2gc7e9DUOI3a
         QwYw==
X-Forwarded-Encrypted: i=1; AJvYcCUG6yWzb5gYTt2+M3z3FjB3KMB0VsuZgZX65LAafxVQuetYYPdQ8Td+8M8/pgOjTVLQsOHURPdZEebRYZ7stmQBNpAyBmNbQw==
X-Gm-Message-State: AOJu0YwJHItE4YvETG6dO0AkGJO8c6ryBxE5eJMTzH5r+wnldYOUONYr
	FGXz3D6VD3trjjvgd+colVH9foADbGHkkUctndUVtE6CL8xpgkPjay4RjBEaxUP0PhdbknYLPnt
	NhQuteYyvVLTi0b2NA+vx0jqmLtVB37uUXmXnzw==
X-Google-Smtp-Source: AGHT+IGUwEp/+WhHA0uQ0uW2uvX6Vp5aF/NLRg8+micGN3CEaNubXYVANAb9auNn0QNapfA8iEZ3XcUbSMqmSS5KIi8=
X-Received: by 2002:a05:6402:40cc:b0:567:1458:caa with SMTP id
 z12-20020a05640240cc00b0056714580caamr5847164edb.40.1709634235386; Tue, 05
 Mar 2024 02:23:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240304211537.631764077@linuxfoundation.org>
In-Reply-To: <20240304211537.631764077@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 5 Mar 2024 15:53:42 +0530
Message-ID: <CA+G9fYsFuQDfvRGyUhLNuFXQc0yfu_eE3pnRYbUD7p9U7GEa9g@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/42] 5.10.212-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 5 Mar 2024 at 03:05, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.212 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 06 Mar 2024 21:15:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.212-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Following build failures noticed on riscv.

The riscv defconfig, tinyconfig and allnoconfig builds on 5.10.
The riscv tinyconfig and allnoconfig builds on 5.15.

linux.5.10.y build failures on riscv.
riscv:

  * gcc-8-defconfig
  * clang-17-allnoconfig
  * gcc-12-tinyconfig
  * gcc-8-allnoconfig
  * gcc-8-allmodconfig
  * clang-17-defconfig
  * gcc-12-defconfig
  * clang-17-tinyconfig
  * gcc-12-allmodconfig
  * gcc-8-tinyconfig
  * gcc-12-allnoconfig

linux.5.15.y build failures on riscv.
riscv:
  build:
    * gcc-12-tinyconfig
    * gcc-8-allnoconfig
    * clang-17-tinyconfig
    * gcc-8-tinyconfig
    * gcc-12-allnoconfig

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

arch/riscv/kernel/return_address.c:39:9: error: implicit declaration
of function 'arch_stack_walk' [-Werror=implicit-function-declaration]
   39 |         arch_stack_walk(save_return_addr, &data, current, NULL);
      |         ^~~~~~~~~~~~~~~
cc1: some warnings being treated as errors

Suspecting patch,

riscv: add CALLER_ADDRx support
commit 680341382da56bd192ebfa4e58eaf4fec2e5bca7 upstream.

steps to reproduce:
---
# tuxmake --runtime podman --target-arch riscv --toolchain gcc-12
--kconfig defconfig


Links:
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/v5.10.210-166-g4b0abedc88b0/testrun/22941782/suite/test/gcc-12-defconfig/details/
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/v5.10.210-166-g4b0abedc88b0/testrun/22941144/suite/test/gcc-12-defconfig/history/
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2dF5ke88GqtfanduGie1JGLUbVa/

 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/v5.15.149-332-ge7cbbec10c6e/testrun/22942335/suite/test/gcc-12-allnoconfig/history/
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2dF68wn0dXbU2xGLRyzsxGdXTyB/


--
Linaro LKFT
https://lkft.linaro.org
