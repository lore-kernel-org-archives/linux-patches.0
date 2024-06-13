Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871F91494AF
	for <patches@lists.linux.dev>; Thu, 13 Jun 2024 15:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718291637; cv=none; b=nWX8rQkIuDBIEmJJAkuBeO4hdmf8+9SOji9xNZXbBSfFsitHJM4ReXeZ0TDVITyE5WQm8z+Zv9NvGjP+0UZUttS/kATz9zf3QPd6yfRQ7Oyh4UDHuTiBpmobct9Q3yS7z92H/1gZwgUF2Bk4uY2pnloLph582tKckYAaJ/Vh708=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718291637; c=relaxed/simple;
	bh=14Z/QPjhD+7BffP2eGAJ+9YQJulua94nuc8mbHlPwaE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CzHjhJ4nYZSgzI05IyJE8WtdRfmRwM5sEYizv0sNsi0Vl0KClfGq0kO7leiOTBtCU8hhHLzDRl0g7qwg36TBBKCRfpsUlAujzljHDuobOu8+L32zgF8MugmHvAa80ZQjVr7qDI/z/XLV7XYLa3PPzxJgpj1R4zzd9eXrsaMaaF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YWGOj+BV; arc=none smtp.client-ip=209.85.222.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YWGOj+BV"
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-80b755c6c06so390711241.2
        for <patches@lists.linux.dev>; Thu, 13 Jun 2024 08:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718291633; x=1718896433; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YrxYBwFmJZ2ShtzXRL4Y2grRkz6qOWp2v7p/c2wyXj0=;
        b=YWGOj+BVUyKK8X2jXj/8vXpHl4/UvvM1kZL8YhRmg09jIvRPUfTCeWMiVKxcDXDMNJ
         JQ5g7eLfvKgAi6MbS/JV87ukcYxio4F8fdcsKzbdGeSIulvJz0ZbmzQmPtnTEhqOiVYx
         pPoGoHFp95CympxE9qNzHin7XWuIYY5MpZc9kBOEn96VyuGDuJBNL5fOjOHSxFchqTSU
         TnOWPQDqnx7vCOJNAkZ37+APpF+dSCwgFaql3pe90d16hHjQ03HTEL2U2/AvFvOJc9kC
         aLI+mXD1Ih2EjLOJ7dhUImmGV79iMf9IVrcgJDzabTbH+s65Ke6L3giwfT5o9EmtW08r
         axnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718291633; x=1718896433;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YrxYBwFmJZ2ShtzXRL4Y2grRkz6qOWp2v7p/c2wyXj0=;
        b=nN5IBj4wSILPXX3gTe9Cc0opiku6kTQgY9LCw9n/40bxsFF3PV6WqruDKSiNsEdo3p
         oWZ+yMkOsOl/qcA/YblP4Af9uv62BOSj0xigi1oyBrZUtyad51OFsE7tt5yOC+AvHdd/
         iDWXgmxd4/xSXpopoJK5D721czdYfSglopEMKCkqTmQrS3mRQvPGBOCskFYGG90S98pJ
         EoI7i4YB0B+3CoAFXTKBXuB3telwr5eWmeTnV8uMgm+GX1GBFU8FFLwxXeuWZgrASpal
         BqnNMX9+x0FqLu0w/upvC3fR7ikd/rWdwNKLL06vYLBQhluJXJsIzlyVqKEX6cqiG/vj
         zNTA==
X-Forwarded-Encrypted: i=1; AJvYcCWOh15EuyDiykWdZK++A0VmNmtWkbeD+pesPAoeGpi3f3UaAe7ljJC4+O4KlAfAWWWFDMOQQKgwR+QJhHlicXNiMP28kHfS5w==
X-Gm-Message-State: AOJu0YwvIb9EWfSdxZrrK66R5rMbtPt72T+yJmdc6ttcLkTOCi87KeBK
	3O6GV1NIhFRPgx4XBEQSGVUr1VQoZK8YeZyApzjUSuG+BlHV6NpZLL7UCCmkFEvBoGmo/vwMu+b
	aMPJm7b4uUSkwpA3J4g4mvIh0cu7iQrLMdEy5sQ==
X-Google-Smtp-Source: AGHT+IEN/IxLFSZi+7ySH7Yli8WEc2cF1WYEl0a+Gfrx6rp5ZdvnxPevY6/6w7U4zj4C97saSZZh8hfOmFU6AZ7IZKI=
X-Received: by 2002:a05:6122:c9f:b0:4ed:80:bd85 with SMTP id
 71dfb90a1353d-4ee3df992c1mr183882e0c.5.1718291633421; Thu, 13 Jun 2024
 08:13:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240613113247.525431100@linuxfoundation.org>
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 13 Jun 2024 20:43:41 +0530
Message-ID: <CA+G9fYvnVJi1RFhO5f6ZH2mpagZ6jcEdoQAxnSBxWPHsEVQwYg@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/317] 5.10.219-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Anders Roxell <anders.roxell@linaro.org>, 
	Guo Ren <guoren@linux.alibaba.com>, Guo Ren <guoren@kernel.org>, 
	Palmer Dabbelt <palmer@rivosinc.com>, clang-built-linux <llvm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Thu, 13 Jun 2024 at 17:43, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.219 release.
> There are 317 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.219-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


The following build errors are noticed on riscv with clang-18 toolchain
but gcc-12 builds pass.

However, compared with older releases this is a build regression on
stable-rc 5.10.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

riscv:
 defconfig - gcc-12 - PASS
 defconfig - clang-18 - FAILED

Build error:
------
arch/riscv/kernel/stacktrace.c:75:52: error: incompatible pointer to
integer conversion passing 'void *' to parameter of type 'unsigned
long' [-Wint-conversion]
   75 |                                 if
(unlikely(!__kernel_text_address(pc) || !fn(arg, pc)))
      |
                ^~~
include/linux/compiler.h:78:42: note: expanded from macro 'unlikely'
   78 | # define unlikely(x)    __builtin_expect(!!(x), 0)
      |                                             ^
arch/riscv/kernel/stacktrace.c:75:57: error: incompatible integer to
pointer conversion passing 'unsigned long' to parameter of type 'void
*' [-Wint-conversion]
   75 |                                 if
(unlikely(!__kernel_text_address(pc) || !fn(arg, pc)))
      |
                     ^~
include/linux/compiler.h:78:42: note: expanded from macro 'unlikely'
   78 | # define unlikely(x)    __builtin_expect(!!(x), 0)
      |                                             ^
2 errors generated.
make[3]: *** [scripts/Makefile.build:286:
arch/riscv/kernel/stacktrace.o] Error 1


Links:
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.218-318-g853b71b570fb/testrun/24322227/suite/build/test/clang-18-defconfig/details/
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.218-318-g853b71b570fb/testrun/24322227/suite/build/test/clang-18-defconfig/history/
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2hp7bDTOjqzNr8hqqSWyMf943W8/

--
Linaro LKFT
https://lkft.linaro.org
