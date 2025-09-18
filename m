Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14FA302CB8
	for <patches@lists.linux.dev>; Thu, 18 Sep 2025 11:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758195597; cv=none; b=mXysJlcojkgk5MHSNmjIodA45Ebjk4XmpiXxLXPacP0sw1hNELGbYyRUHDTFkjIE0X1ftHt30ZWg9Bzf9FcQGLzPL353960+v6ofY02p22buBy11pLjI2No+5CwFDjhBmxjhb3QWjbHQ6KHsyxA6haCQbnYilHtuBIJYxNkB/N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758195597; c=relaxed/simple;
	bh=uFxlB2R+ZAYSRcEYlTPVQyhSU7uzPWXjKHbWDaZJTTI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AqBFRJCA+pjq0TL1F2vjVISmJfATd5lzHb7gK5QhAlT2ufbCAQXynr2P2omkHr9osF6poy1XfJjT63OMFVGOtiaiEjZCWObANqN8lwbDQT0VcgJIuUYsx1+kzAMn3e5ne/J4IRh0KcT3MP9U3aaa3TKcRxiG5dSWzFFhM5zReGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NzY9gO2f; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NzY9gO2f"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-827f9ad189eso11593585a.0
        for <patches@lists.linux.dev>; Thu, 18 Sep 2025 04:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1758195595; x=1758800395; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5vUxrIL/IBc7jEhkf1uGzLd2PnG5mi3zNkUmu0ufRfg=;
        b=NzY9gO2fqWAEBP1MdcGgH9+kxDo13S5sC9MeL9RjHFbkor4s8b72hisiRIr4uivmCZ
         GDouX3cWjPd2FOH5pia6KpIxafcqB0TZaakYOHgqwFBc/IkzAXJ1OTjk/jYwQ0mlIWoz
         XIZPuMtRqu8JQXhwuQpBJBrRVWzoPAwIeZ+awocQSMMOHXfC3yz6p4S31zF17WRyOkcM
         5xu3JNCtHKsZg6VLHwknqmx1duedyPflsSvmC0YsjmY0UYx2eaCHXqEBfRvMZPvG6YAb
         +FLal/UlgleGbf6LzvdFJXSOvgkO1rFRAPx1XWIzvzh+vVBbN2IW4lN8N4o3qVyz1nzJ
         H87A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758195595; x=1758800395;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5vUxrIL/IBc7jEhkf1uGzLd2PnG5mi3zNkUmu0ufRfg=;
        b=Ssm7Yhi+6IeMrPwiYBdOw1SSY6FM76PEHeSwRyHF+A4hwNfG1fyzmwGSHapGq0t36V
         2lIhAnMw6T1lkujVJHYQ7HSb+3APhr+0aIye3liM0MZbNO8YxCGVqofi9XZ4KGMx654x
         GXdMMB6qpo6Oe6seZ4U8350FaSVkkxG1mY16GZcpNZbeH0KWT6BNdP7Y7MpP66btHdu8
         nwvcMRMKhQU3/IuLYQ44D9/wATi7ThuYtNbk0aKCpvvVLFUjVYHvK7FT1JX345KC5Pb4
         Mxz4OkeTVGHBXSR/3+V81WcpUii4T1dR2ua402az3QxpVy9KAWzjOCI525SNgbuvBEbS
         c4VQ==
X-Forwarded-Encrypted: i=1; AJvYcCWNh2BdMU0RCkPLh0ZNvGXMsjSQLNiJPfG94NmBUXP4LD5R9jx5FEAb73ip3JLej4qowZra7Z+x@lists.linux.dev
X-Gm-Message-State: AOJu0Yx3F/7JTwsvF0p1oVfZmE6nUB2denhPcUKSUk69QNwRab4igam3
	eDG4ZxVJPHY+aGOLQBm0sWWl+sculExyhej2DlMGEwY1kjDPRAixOa8K5G1jCRMCEWr9PREc/uG
	5EFRZGjLNNkyyldQ/X51ZUtyV76cqwRM8mQdVNVZYVg==
X-Gm-Gg: ASbGncs/i1yjZ4pC/YaFQFCAU4fAHhgXbb1li4vHW5uB9CNFK2s1P3wP+DVBXUBRLJv
	Cc56TCPs6uq29QPQY2T3I6UU+JuiA7vajzUYMLp821VhNjygabtlAdyP9XG2fC9U5Rck8lt9pUU
	7bs2lhPkAd5gO42ysamf9jwQ4qAouj917x4upO2La99foS1JG8MFReLPHTHMHBgq17g5mx/iEWK
	ekyip/zADrPZWpQJnDzQsy8
X-Google-Smtp-Source: AGHT+IH48ivQXtWG6C+0ln0hXjbS+q797BMP5NkKk70x0e10WLGtjHZ+0cOJrQylQsmByXrESmf6BwG/gWAUyqH0+oU=
X-Received: by 2002:a05:6214:519b:b0:795:c55c:87de with SMTP id
 6a1803df08f44-795c55c8cffmr5136256d6.5.1758195594483; Thu, 18 Sep 2025
 04:39:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250917123344.315037637@linuxfoundation.org>
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
From: Anders Roxell <anders.roxell@linaro.org>
Date: Thu, 18 Sep 2025 13:39:43 +0200
X-Gm-Features: AS18NWBNNFTT46ohA_9aWzCCmFKj0hhU1Nz5FCTOq6VyCT2bqNOYD0vIURq0WvA
Message-ID: <CADYN=9+vrKOAkyqp69eG785TXoqbw2QdORoFOJWz=fXeEmGz1g@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/140] 6.12.48-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 17 Sept 2025 at 14:48, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.48 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 19 Sep 2025 12:32:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.48-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

While building Linux stable-rc 6.12.48-rc1 the powerpc allmodconfig and x86_64
allyesconfig build fails.

Regression Analysis:
- New regression? yes
- Reproducibility? yes

Build regression: powerpc clang-20-allmodconfig

Powerpc allmodconfig build error  :
/builds/linux/drivers/net/ethernet/ibm/ibmvnic.c:6134:13: error: stack
frame size (2080) exceeds limit (2048) in 'ibmvnic_tasklet'
[-Werror,-Wframe-larger-than]
 6134 | static void ibmvnic_tasklet(struct tasklet_struct *t)
       |             ^

Build log: https://qa-reports.linaro.org/api/testruns/29918282/log_file/
Build details: https://regressions.linaro.org/lkft/linux-stable-rc-linux-6.12.y/v6.12.46-149-g6281f90c1450/log-parser-build-clang/clang-compiler-drivers_net_ethernet_ibm_ibmvnic_c-error-stack-frame-size-exceeds-limit-in-ibmvnic_tasklet/

Bisection in progress.


Build regression: x86_64 gcc-13-allyesconfig

2025/09/17 13:43:43 socat-external[1252] W waitpid(-1, {}, WNOHANG):
no child has exited
x86_64-linux-gnu-ld: kernel image bigger than KERNEL_IMAGE_SIZE

Build log: https://qa-reports.linaro.org/api/testruns/29919415/log_file/
Build details: https://regressions.linaro.org/lkft/linux-stable-rc-linux-6.12.y/v6.12.46-149-g6281f90c1450/build/gcc-13-allyesconfig/

Bisection in progress.


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.12.48-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 6281f90c1450c5ee21a0f42e3dff4654f395d963
* git describe: v6.12.46-149-g6281f90c1450
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.46-149-g6281f90c1450

--
Linaro LKFT
https://lkft.linaro.org
