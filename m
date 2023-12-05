Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1E222EE7
	for <patches@lists.linux.dev>; Tue,  5 Dec 2023 16:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SCvkrShx"
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-7bb4b7eb808so1973201241.3
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 08:49:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701794941; x=1702399741; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YfqclM3ZkWiAXDbZmcjbBwB6xmJbMZCT4iOO/IexVc0=;
        b=SCvkrShxDB/+S0edJdeVxSR6swO3hnsvvAIIR07CwoGHOajLW8SRnAa/55NPjj38Aa
         vzEsMtcsB3gUIEOEuhkfMXZdJEjSHif3WcHIqS8+kOoF07sEkmuOAaqFqcEqNevRsN2y
         20BWodP7/bjVuy7rXNixxjMWUH/Xk7il5MRaQKYRRq6+kCsHGatmukhusNjwVWXva5Il
         PQOyUmpl6cDchqT+AY86kYpv01E9AZM6eFDwbDEdwFoOP/h+jjNtyQ/ZNJmk0WvvFhyA
         zmG8TOPyfKEZMK1sai1rIuW9Fk7joNQKxdpPZSVq6Spt2wYB9lsWh+dE162E86Tztc+W
         s9sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701794941; x=1702399741;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YfqclM3ZkWiAXDbZmcjbBwB6xmJbMZCT4iOO/IexVc0=;
        b=M0FI7Gh1ICdeueVaLE3JJjNCnaokEmIuLZIkbusejDW34z0Q0FKi8BkFNWisAQRKU+
         4k563bTj1rjNnLCPsD/aPRtKCqxBWE5Qr9lco4k2PiuzLVwLARvdfSCsuDqNJcWRMHIx
         2i+/AE1YSbs4OKMk3Wzybk5WwRBER+q5VgTsMtyCpLMCet+leyXJaleI0BwQbOsih5gn
         ctzwplh9GNKIlGAZIrWtmfyknk2WtdyHk3/30MbROcNgRYlZs7Qys2KaJBwuQRp7SifA
         2/4z8LzbRrHymxnt0tA+C63Wv7pHoSJeTn8oc1qH/bqzKUKArYhkI3t4XEt/N3JEGQjc
         73xA==
X-Gm-Message-State: AOJu0YyADdkG9CvJd9o2+92fBMpf4wAaIYZRD2CL+BmoZQbxtxXdvbCw
	9QRV7yvogkuh/2AtnhpueyK7SuGQYs4uUtVxT4SvEg==
X-Google-Smtp-Source: AGHT+IHus3uB7dNMpJ0cP1uy5kkamJOMFLF8zMXjR6WyF50uZ0U0xiaK7tFOWnFeBiVqsPbRDg47o04MaF15ciRegfc=
X-Received: by 2002:a05:6102:34e2:b0:462:c2e9:6dda with SMTP id
 bi2-20020a05610234e200b00462c2e96ddamr3198642vsb.31.1701794940837; Tue, 05
 Dec 2023 08:49:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231205031519.853779502@linuxfoundation.org>
In-Reply-To: <20231205031519.853779502@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 5 Dec 2023 22:18:49 +0530
Message-ID: <CA+G9fYs-XB29+aZ2kk9psA+MTo8PCh0owWgwGRiq8JK60CuUtg@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/67] 5.15.142-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	Gaurav Batra <gbatra@linux.vnet.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 5 Dec 2023 at 09:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.142 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 07 Dec 2023 03:14:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.142-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Following powerpc build failures noticed.

* powerpc, build
  - clang-17-defconfig - FAILED
  - gcc-12-defconfig - FAILED
  - gcc-8-defconfig - FAILED

build error:
---
arch/powerpc/platforms/pseries/iommu.c: In function 'find_existing_ddw':
arch/powerpc/platforms/pseries/iommu.c:908:49: error: 'struct dma_win'
has no member named 'direct'
  908 |                         *direct_mapping = window->direct;
      |                                                 ^~

suspected commit:
powerpc/pseries/iommu: enable_ddw incorrectly returns direct mapping
for SR-IOV device
 [ Upstream commit 3bf983e4e93ce8e6d69e9d63f52a66ec0856672e ]

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Links:
  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.141-68-gbff845be423f/testrun/21492943/suite/build/test/gcc-12-defconfig/details/
  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.141-68-gbff845be423f/testrun/21492943/suite/build/test/gcc-12-defconfig/history/


--
Linaro LKFT
https://lkft.linaro.org
