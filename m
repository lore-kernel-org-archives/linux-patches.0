Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E81192D87
	for <patches@lists.linux.dev>; Thu, 30 Jan 2025 19:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738266135; cv=none; b=bSSyQwG/h0ciznRsRw4HIdTeDe9BBEJxljIzTrQX8ehBoDBqMuQ6vVeAm5ZKrbRG2s4a3jP8a5QIqYLZIM1oqv8A3XmUbUcmz23kxgJGx6yyHPNB+VFhGxo6H1Q1hzhvMTGPR69h54e86IGyeAon6d2drdUSdQ2kYultSgEFzC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738266135; c=relaxed/simple;
	bh=zehHH8Y1Wwzx+YfhbDuyZL+H1gwEL6TAie0nbVvLEMM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W76HI5jk5BN+2bB01kwliIeKhKWsAfi3UzDlPbfiyKJzaFV7CZ9FWSmZ7y10gihheytZFF3Ve0cvGmYjyTfewqj5mmC9hUxpMNsCTkr5OBlIKOxNYNuJMa9yZiofOXgd5viGLcTf52oBJprNbOOo2zqGefAr6H4MMWnbAQUe048=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jBr0bFTj; arc=none smtp.client-ip=209.85.222.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jBr0bFTj"
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-85c4e74e2baso263009241.0
        for <patches@lists.linux.dev>; Thu, 30 Jan 2025 11:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738266132; x=1738870932; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RjqHYSGSUkq0Y5wudcQHXFnXTvjYr8lKpJ37kSClfG0=;
        b=jBr0bFTji6RBN12jrd42qehKW4Sz84bH/YfGRJY4jYDPnRKZs7fI0w9OS8CK3CxNc2
         YNSI3sI5HK2AVKuI2L886LrxFjCSw34mmBdXcRKFsgOCVNFhESoBcIoAeUCfZOIozV6r
         GIBZPYTcJNVi7CZfoMXVbcr4cDOEouD0PoPt8vooBZce+WcZX/6AX88ZN7RcT0Sj6eVZ
         G+lduvLBCIwDAs3uyHmKdImbg5iT5BY1wzEZog2qomc049e8jhKtxjX6BzAcFIXNqsGa
         /QHqv8P7cNabPm+81A8iW3pAM04AVJ1yx0OVrcE+yyCebvSyS+pJsgXBHSX2dypZRfBa
         VKrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738266132; x=1738870932;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RjqHYSGSUkq0Y5wudcQHXFnXTvjYr8lKpJ37kSClfG0=;
        b=qqUMzMinl+nsi6ttZb1387ksVuRAqjyDHERV/0q3CsjW4EJ0u36IEthzmnkzyHj67A
         vAMO40v5Bn5zspt2xCms+QC9B1GY7cVv+RNAeh5x0Cuk6ne+jfZviXs84Cb61VSuoS9P
         FXgBqoKy17j/tnbXv9u6Wc5E2d5StxXq/hqCDhmYB2V0B1Ic3G5bcYN2qY9kQY0Fwtvh
         PiT5TKkhaIquM/Mgnp+DfQWVjo9QrSPoTkNCj+e0KpSa+0sKxEzsQmOvWDCzN4l1NILG
         gVJeJDkO38bK6p5VJyJUNj8q9nsNCOPHN7rKBol9gH2CyPpiA0qNeuxFJxxiYQrERFni
         UCkg==
X-Forwarded-Encrypted: i=1; AJvYcCUxKtjqpC5OS2QbGBnzkU+erqpmSzbg96JDRlonNjUAyddLMK9wQSpQvGTOnbEryIcT+M1YY0wz@lists.linux.dev
X-Gm-Message-State: AOJu0YzMhd5ssNNFnURUrupuozeW2uhGUOm9ocrn2lmGn6tIqlQT78gw
	siItMhwkEgu18bjOa3GNJL/1pJ8+vUVgFGQCZ/Ibgw2x2BiY4n6cXh5L0QcHv2ykn9hRZsPQySR
	3hqe6Ov99+tTjl6ujE3C0HR7ila/nNHfSw67MUA==
X-Gm-Gg: ASbGncsUM5DKrbJPzwxasCvrcXarindmAwvkQtW9XnSAH7oU0SStC2MpgIVqum3J+0e
	ZTzZ+wtoXOrvMs3A7ey2bQLS+NKF8bnRn5BmFR+6/I869/wvhqJ2e7oT6HTm5qzyYLr55aeF8D3
	B5F/6T9ga4L1D5xJ5KYekmQ/HlqR3e
X-Google-Smtp-Source: AGHT+IFD6Vvxc8sA0n3TKBPikH9o0k59Sle6GqOsO74NocpNslG2/xlUymWtQlqSxJl8oiD0U4+4dEziqRxDIGqKyxQ=
X-Received: by 2002:a05:6102:292b:b0:4b2:af6e:5fef with SMTP id
 ada2fe7eead31-4b9a4f6986emr8241190137.9.1738266132325; Thu, 30 Jan 2025
 11:42:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250130140142.491490528@linuxfoundation.org>
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 31 Jan 2025 01:12:01 +0530
X-Gm-Features: AWEUYZkZA79PZ9fsrU-3OmddYVaf7TuCnzxZur-Nd2qPMPZyDfxA-jiR_FByOOE
Message-ID: <CA+G9fYsDgsJSj=WfH+5pMFJe6pLmBMAp1PiYyCbVn4Nh1Lt3pQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/133] 5.10.234-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 30 Jan 2025 at 19:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.234 release.
> There are 133 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 01 Feb 2025 14:01:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.234-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The following build regressions were noticed and reported last time
on 5.15 and found here again on arc, arm, mips, parisc, powerpc with
gcc and clang toolchains on 5.10.234-rc1 and 5.4.290-rc1.

Build regression: arc, arm, mips, parisc, powerpc,
drivers/usb/core/port.c struct usb_device has no member named
port_is_suspended

First seen on Linux (5.10.234-rc1)
  Good: v5.10.233
  Bad:  5.10.234-rc1

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
drivers/usb/core/port.c:299:26: error: 'struct usb_device' has no
member named 'port_is_suspended'
  299 |         if (udev && !udev->port_is_suspended) {
      |

metadata:
---------
* Build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.233-134-gd215826da15b/testrun/27078309/suite/build/test/gcc-12-footbridge_defconfig/log
* Details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.233-134-gd215826da15b/testrun/27078309/suite/build/test/gcc-12-footbridge_defconfig/details/
* build: https://storage.tuxsuite.com/public/linaro/lkft/builds/2sLvkKOcaJTFWGOHFpeqcAkyaIB/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2sLvkKOcaJTFWGOHFpeqcAkyaIB/config
* git_describe: v5.10.233-134-gd215826da15b
* git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git_sha: d215826da15b526aadf99923695890c777190399
* Architectures: arc, arm, mips, parisc, powerpc
* Toolchain version: gcc-12, gcc-11, gcc-8 and clang-19

Please find the email discussion
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
