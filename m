Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B276A1E8823
	for <patches@lists.linux.dev>; Thu, 30 Jan 2025 19:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738265756; cv=none; b=mS5DV08/h50SUrryXOgrmTTsOvvkyNfCS5+O9lWOs7xRAUFw7mvPuZ19/B/DXsOkBM/lvCqIjOHs5kd3eVLVbYPpSIrrKNmt1/71kb6jNDla4HTf5tND3wRTIoTrRDYPE1VxKYNfVWt6qKmKAQ9F/ePlmiYgCZB+5aS90eorNoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738265756; c=relaxed/simple;
	bh=tc/PDcSzixb+iXX1akNgTyMJBuee/WcKU6Flx+8L31o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bqG42OvwAf6rLOoZEC6zCc2ScVfV090/C3eR/sZnLZCdEOjwZ4knkOoobkNd5bIkj0sHJfsJOJolwWJkKF2UgI74iNqWPngsejnbiC6DAYV8Y+h2sYRqWMplBU55zKVT4syhr3dFQK2plHD31fd/+u4D3b0xQTX8Fxvcq3UE6JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EBRU31Fy; arc=none smtp.client-ip=209.85.222.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EBRU31Fy"
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-85c5a91374cso626913241.3
        for <patches@lists.linux.dev>; Thu, 30 Jan 2025 11:35:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738265753; x=1738870553; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/s8I8F9pmlrzQR5tZezmCD4RoX0HPxCcaLCSVaDRDLw=;
        b=EBRU31FynTFqVss+dLiyeEkPYDy4XT9nUroPX576ETKfOrVnrrA0BhfcIdcUR8CErS
         FeFG6YDJ6NSm2JSfwdbDripgceqbvKx0sR2iVgDkU72xNmIgda89o5CJQ1RsR48Kz4sn
         gWhmL+DH4tMmeKgpe01duRytiGk5WId1f30XBDjj2/+I/1rTt1qAyhjU/U9L7adtbg7u
         GcB3CsJ+V/+JXgowjrfgjWKSSc8PlruZM8wJ+TiGmRM1djGqlx+uatKZPbwbtYu9tT5K
         T6nFU2CWoFdQN3BEhj49u+NixwsokjE1W26PhJkMjpG0sP5QlDHCgdvccGUUJgP7xyUA
         q7zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738265753; x=1738870553;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/s8I8F9pmlrzQR5tZezmCD4RoX0HPxCcaLCSVaDRDLw=;
        b=lge5rnuMZVmTeNzeL9ufqVaDdFhRct+dBqrXu4nsenZIVFEvwti2K8s9Y7R8ubbEoQ
         P9nCBPfaKLY1oULO0Cm4qwjw+b5iG95h+HqcRRJI1xREDxHf2dsSOqdHqUF/VvPwin2e
         cFf7hDBoqVFDZOOKgwB3FIPZCoKiA2asfV2DDSNyiiTxem9uPOjvcRfJai1G75eb+16/
         hVkwPTE1zdPoz3f2T+mMC/79KXxmhrKtMcUKd77On6b+haYM8OsPekahO0A6vOzGOPVm
         E0auGt2wYjdAvsgRAH0hx3U0vBedWY3QqwhHPBBXrzXvL4C37tlwBNrNRCXMmaBpATAk
         b4uA==
X-Forwarded-Encrypted: i=1; AJvYcCUVq4pxREhSaXWTiqakJhixLUkMjQCGH4N7rlSEgJsgefp8hywsv4b34fh2AjPUbCfQiTD+0iFL@lists.linux.dev
X-Gm-Message-State: AOJu0YxfAvKvBdDIkbTz07UzIWa3rHGLvGzQGLVQMwYCCGBcb1cjL7g4
	QR65i936m/vcQ/c7pufXd/VjVERjjf6rBojNQWocQ2Dy6t2bDRu6R/0eUTGyJU4ozoG6vuUfqar
	o1HYc5lp3rZOD+ZyygqXbg18qdcE2T5wREfcYcg==
X-Gm-Gg: ASbGnctpzU2WeuZAPaGTAVB9F9OqCWpo2Y4RkeVsvMncPw75nR448WBj1j2X7ivrCAd
	PW58TeeHBfccKPVX/c69MfEUendp8LdvJe7kME4fqm5vT+DxroCX4WWa4N66eCi9VPyGFbwHlTP
	+auH1MWf/pgPRGTd6CIQQmFq+3IFv9
X-Google-Smtp-Source: AGHT+IGiEPzFzPkapPW9tYKkO6D7+5pRUyuylUBuGphS/MvvFc6gbIMXzc0fsmezXugCb4QptmMQodulfJJCcyzSat4=
X-Received: by 2002:a05:6102:800e:b0:4b2:5d10:58f2 with SMTP id
 ada2fe7eead31-4b9a4fc15bdmr7858997137.14.1738265753545; Thu, 30 Jan 2025
 11:35:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250130140133.662535583@linuxfoundation.org>
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 31 Jan 2025 01:05:40 +0530
X-Gm-Features: AWEUYZkm0r6LQxZqc8VnDXBKmK1_Cm3f9f2joOD8H6qqpOf194TFrPp8tavbzQE
Message-ID: <CA+G9fYsiw4GSjL7Sf51OaGM_-uWAQYaLCb14L_RC81nwoZJJzA@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/91] 5.4.290-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Arnd Bergmann <arnd@arndb.de>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Anders Roxell <anders.roxell@linaro.org>, 
	Vincent Guittot <vincent.guittot@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 30 Jan 2025 at 19:47, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.290 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 01 Feb 2025 14:01:13 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.290-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


The following build regressions were noticed and reported last time
on 5.15 and found here again on arc, arm, mips, parisc, powerpc with
gcc and clang toolchains on 5.4.290-rc1 and 5.10.234-rc1.

Build regression: arc, arm, mips, parisc, powerpc,
drivers/usb/core/port.c struct usb_device has no member named
port_is_suspended

First seen on Linux (5.4.290-rc1)
  Good: v5.4.289
  Bad: Linux 5.4.290-rc1 (v5.4.289-92-gd06b29df5286)

* arc:
  build:
  - gcc-9-axs103_defconfig
  - gcc-9-vdk_hs38_smp_defconfig

* arm:
  build:
  - clang-19-axm55xx_defconfig
  - clang-19-footbridge_defconfig
  - gcc-12-axm55xx_defconfig
  - gcc-12-footbridge_defconfig
  - gcc-8-axm55xx_defconfig
  - gcc-8-footbridge_defconfig

* mips:
  build:
  - gcc-12-ath79_defconfig
  - gcc-12-bcm47xx_defconfig
  - gcc-12-rt305x_defconfig
  - gcc-8-ath79_defconfig
  - gcc-8-bcm47xx_defconfig
  - gcc-8-rt305x_defconfig

* parisc:
  build:
  - gcc-11-allyesconfig
  - gcc-11-defconfig

* powerpc:
  build:
  - clang-19-ppc64e_defconfig
  - gcc-12-cell_defconfig
  - gcc-12-ppc64e_defconfig
  - gcc-8-cell_defconfig
  - gcc-8-ppc64e_defconfig

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


Build log:
-------
drivers/usb/core/port.c:299:21: error: no member named
'port_is_suspended' in 'struct usb_device'
  299 |         if (udev && !udev->port_is_suspended) {
      |                      ~~~~  ^
1 error generated.

metadata:
---------
* Build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.289-92-gd06b29df5286/testrun/27079097/suite/build/test/clang-19-footbridge_defconfig/log
* Details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.289-92-gd06b29df5286/testrun/27079097/suite/build/test/clang-19-footbridge_defconfig/details/
* build: https://storage.tuxsuite.com/public/linaro/lkft/builds/2sLvp68rK3neoKGJil8eoZjIS1y/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2sLvp68rK3neoKGJil8eoZjIS1y/config
* git_describe: v5.4.289-92-gd06b29df5286
* git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git_sha: d06b29df52866ecaf06746ab6997a9ffabfd4357
* Architectures: arc, arm, mips, parisc, powerpc
* Toolchain version: gcc-12, gcc-11, gcc-8 and clang-19

Please find the lore email discussion
Link: https://lore.kernel.org/stable/eec53047-6118-4a73-9535-335babf68685@app.fastmail.com/
Link: https://lore.kernel.org/stable/CA+G9fYvacKD7aFkMCW6nwjZ4t-cpH0deLiPY-cFvGkRn5hgK3w@mail.gmail.com/

Steps to reproduce:
------
$ tuxmake --runtime podman --target-arch arm --toolchain gcc-12
--kconfig footbridge_defconfig
$ tuxmake --runtime podman --target-arch sh --toolchain gcc-11
--kconfig defconfig

--
Linaro LKFT
https://lkft.linaro.org
