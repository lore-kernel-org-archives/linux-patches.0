Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A7C18FC74
	for <patches@lists.linux.dev>; Wed, 19 Mar 2025 16:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742402015; cv=none; b=P+oaJtnKvP4TnxrPKqqG/FGF8JnhOlIhizxA+Isa35UDtoWOhU3l37UYNbCV3uL1329nNG8mKyG+zjL8zEvyCunREgquCgGRAYSoGp6k46DcdFJmMfJSVrCPISvj1LjNzNBmBm+Wf0/HIwUEMawSfSak5jl6I5UUHdK8NJeJPIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742402015; c=relaxed/simple;
	bh=b5JoerGjzoODytPs4/JCCgsORTIkD1OWdTmBFC8AjPo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RHPMlKT8ZcwSwEUZ7gJShltzmpoTiUhacdK2iHC1uy6DX7PcuJfJWEs8NU7cVL8sLce3fpft6aYLg1/cr+LSzaBdAcPlpH6GLq8crW/kq1id08jZfXD2fd/Asqp7mUBjl87Agi/lipHINvgkiP6hiYVVcRIA5nBQ5L7dUO2uMAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wnpPoQyN; arc=none smtp.client-ip=209.85.222.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wnpPoQyN"
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-86dde90e7a3so972992241.1
        for <patches@lists.linux.dev>; Wed, 19 Mar 2025 09:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742402013; x=1743006813; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OVuqKpUv1pEU4LzOHuIA6EH8XUgNHnH2M2llTP84R4g=;
        b=wnpPoQyNTkytKDvzAZuxfaH5l4MDvVpaypn8p7aHPdo7dSOvqLxLgk9Hhs66e7SIy0
         bVpQ8FSlyx97BGdYsYDggrT9UUfUJbMgpJcUQA7cjYfvP+s369h7G4vFyyS+8tOz1gP8
         MqbAd3NQ/eFi2E9nHJ4MsoO5U+MXVN7X4ZHzWTT3pINCN4KP483HNJuhMWHfXF1SD4rI
         1+mzJBfGuzpTbBZV3p9kViVqvNpyrFUB1VbcU0kNVs7dGiQpbNjVHFrGcGECJzoow2Ls
         Ov0IINsPsvMW/ocrtcdYSkzTbR94znx57VA1bxe2vgdps4Md6/RRm8jmE4IWeFTKpTNh
         CBVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742402013; x=1743006813;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OVuqKpUv1pEU4LzOHuIA6EH8XUgNHnH2M2llTP84R4g=;
        b=Nf0z7PablkKgAnox2t63zi5E0cCnbaCmgrCzd5QYNEeCp8Z5Tot7baku9bX7aQOK2T
         u2Hp9NgBEUMdSSGEZHsT9IwkHvJqVaHA/6EtqcO93eYyVdwu5rc7dHpp9MDjsgJR5dId
         ZD23qBosCaAYyMR1849zrFaEE73DLxTQbtl/OJiHe62QGWvJymB/y5MD6IXlpC+M52R+
         0mvylqnizIl/Ms0KiLNaxmmY0zUSwfe9gkS/BLyHV2oY3mU6OUnb8hXBgbTiF4tXkecE
         SgZ27/hGEvfFudo+b/csfzjt4Gwh7n6zeNLoBtB7umdSRalA6FjN+/lihmnfQyYxIshd
         p+Dw==
X-Forwarded-Encrypted: i=1; AJvYcCUgS3scFi6uiM9NgPVEvdDiPHY3DJOGx4l33liG+Tsrd/gOsTilmv9wuXIlKKpSbNK1Cgko7JKA@lists.linux.dev
X-Gm-Message-State: AOJu0YxJUkUvu2Krf7SAMeuYnZyE/+Xq2VFIwqpfqzKr8VThgCmLNhvZ
	tBVD9Q03itZlLk8PZ9gztMEsJjqoYmS8ZvouZK+ikFGHNv4mcSlwqY2icZzS9vnhK3Ms0kfSMY4
	lBK21lbUlo/BfjO/6KWMnO0mIWWy6hWEziSbhGw==
X-Gm-Gg: ASbGncuE0FdZ3O5voAURI9BXK712ro0MYZOUlGfCvYmHzn81rkydB60qoN6FjphZlsc
	I3EfGmZPLVDqtiANcPD28cfJxLZJUtr0B/cgczJ4CSZey4njr6o5UJywNYhA4gpi2rtmbHb7YwP
	m5PfEyS87OlppeqTZDshJi72O8YiyzWrdAT8bGDqDM31wYyIULZg4V6Rg=
X-Google-Smtp-Source: AGHT+IHWmBTfBeI+pX6l/d4K6vWO07nXM028XzAozff8NwOIYDbLIFEeoObpskDnFhKhHnfnKlb6wiHJoN9ZGxWxSfQ=
X-Received: by 2002:a05:6122:8890:b0:525:9440:243c with SMTP id
 71dfb90a1353d-525944025e4mr695738e0c.11.1742402012994; Wed, 19 Mar 2025
 09:33:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250319143019.983527953@linuxfoundation.org>
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 19 Mar 2025 22:03:20 +0530
X-Gm-Features: AQ5f1JqIqR8G0jdBi-EqCaYlr4_sxu0nohARN-WaSCDfLRpd0KihGkC9ntbmtXw
Message-ID: <CA+G9fYvM_riojtryOUb3UrYbtw6yUZTTnbP+_X96nJLCcWYwBA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/166] 6.6.84-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, Anders Roxell <anders.roxell@linaro.org>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Arnd Bergmann <arnd@arndb.de>, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 19 Mar 2025 at 20:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.84 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 21 Mar 2025 14:29:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.84-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regressions on mips the rt305x_defconfig builds failed with gcc-12
the stable-rc v6.6.83-167-gd16a828e7b09

First seen on the v6.6.83-167-gd16a828e7b09
 Good: v6.6.83
 Bad: v6.6.83-167-gd16a828e7b09

* mips, build
  - gcc-12-rt305x_defconfig

Regression Analysis:
 - New regression? Yes
 - Reproducibility? Yes

Build regression: mips implicit declaration of function 'vunmap'
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build log
io_uring/io_uring.c: In function 'io_pages_unmap':
io_uring/io_uring.c:2708:17: error: implicit declaration of function
'vunmap'; did you mean 'kunmap'?
[-Werror=implicit-function-declaration]
 2708 |                 vunmap(ptr);
      |                 ^~~~~~
      |                 kunmap
io_uring/io_uring.c: In function '__io_uaddr_map':
io_uring/io_uring.c:2784:21: error: implicit declaration of function
'vmap'; did you mean 'kmap'? [-Werror=implicit-function-declaration]
 2784 |         page_addr = vmap(page_array, nr_pages, VM_MAP, PAGE_KERNEL);
      |                     ^~~~
      |                     kmap
io_uring/io_uring.c:2784:48: error: 'VM_MAP' undeclared (first use in
this function); did you mean 'VM_MTE'?
 2784 |         page_addr = vmap(page_array, nr_pages, VM_MAP, PAGE_KERNEL);
      |                                                ^~~~~~
      |                                                VM_MTE

## Source
* Kernel version: 6.6.84-rc1
* Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* Git sha: d16a828e7b0965ca37245ebea19052ad7b4b2f9b
* Git describe: v6.6.83-167-gd16a828e7b09
* Project details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.83-167-gd16a828e7b09/

## Build
* Build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.83-167-gd16a828e7b09/testrun/27677634/suite/build/test/gcc-12-rt305x_defconfig/log
* Build history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.83-167-gd16a828e7b09/testrun/27677634/suite/build/test/gcc-12-rt305x_defconfig/history/
* Build details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.83-167-gd16a828e7b09/testrun/27677634/suite/build/test/gcc-12-rt305x_defconfig/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2uXZlKzVxja3mOQfRLlPRxHzd5L/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2uXZlKzVxja3mOQfRLlPRxHzd5L/config

## Steps to reproduce
 - tuxmake --runtime podman --target-arch mips --toolchain gcc-12
--kconfig rt305x_defconfig


--
Linaro LKFT
https://lkft.linaro.org
