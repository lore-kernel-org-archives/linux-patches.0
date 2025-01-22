Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D627A213E69
	for <patches@lists.linux.dev>; Wed, 22 Jan 2025 14:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737554940; cv=none; b=dE3z9O8ad/v0cIY2Ju+lsl+g19LQPinF1l3q8DOqf5RhE3buXbV9Skhl6YPrSHQ7HbNNFNQm+iRDTMbsVSdBIul0HgiS/PMXwaYN5Ox+N4+CbnJUvEuyPjy5ySxYLE81Z8RHTpJr1OC1i9UXEjtjOxfkn3qInv9erk/CB7q1Dqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737554940; c=relaxed/simple;
	bh=BNZe9woVKMvClgDyTngIj+nLNjMov1obNzOfpS+FjwI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XHWglRnoIxNVpkq7W4hEAgEXl4R/LvFrtdqOFC5rYbuDf3t5BpC6rhpnuZtAhamhs9zbTxFBajY1goq3Mlbh3dLIftxrGnruS6xm8ZrFAQD3+JMhBznI925VR5igor5zSF7ERplBuC7E5HrgnOwOsHHmpWEZVPXMyoQK0T9fXQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=E2yQpV1p; arc=none smtp.client-ip=209.85.222.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="E2yQpV1p"
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-85bafa89d73so1358016241.2
        for <patches@lists.linux.dev>; Wed, 22 Jan 2025 06:08:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737554938; x=1738159738; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lr1n+IaBijwJyddBXLLjBeruu5O2QY+sKXQxh8k1Lok=;
        b=E2yQpV1pbac6IRImWhDGTPFv3Pe12o98Ab2idlnpA4ytFQxbwJtEPGu2eFatI+yDgM
         22DnetP4txJtqNGx9Yga0QRm3H3DU4SHu9rDTH6k3w2ODLub5zbbqIqSmAtHcMVVaII7
         u4QSVD0QpfFR0vGjDnRg+z4ZZR/NW54JSTVQVHYGjo+VsMX2aL8f8VbG+5urPVWdC/G7
         yrryTzTHLuWI2CqXGD1iXZb1IVWAbV1NwFZL86GO1FWvAV7itHqSTf+1aOXlux9Bb339
         unu73vFlV9luk4rf1UntzmoPqTKZ4TQeyu/Ml+6tFHDXd7cOjfpoMxiM5CJ5EnOyC2Vf
         0RLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737554938; x=1738159738;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lr1n+IaBijwJyddBXLLjBeruu5O2QY+sKXQxh8k1Lok=;
        b=vYaubih4rQDoRRw08jFjW+8Fkvo7EFShkLfzJ7nqMVOKBwHuJ/FZMMSzzBpBXfugba
         hPes5Yorq/cT3GviRXLP98AANSbAuk8j/iIC+bo44gcJFcqd0+T8dxCoeDqH8LBqm7Gj
         0Zra+v0D98uOXKWcEdZaPrhJQQpQOfjs8qXnK8ibnM/+Q3tw/9umuA9HlK2cGDShTN0O
         Wpfn4gyB9UpRBwFUOFWBqsutLfV5FJF9+tPpB1pfSXs3GC2uJtr/skx6pSy6ZITESxk/
         Ror+m+jEnlLOrPwXxBIg/AJUjMBwv0au6MoohdMMdM3wsfK9ZgYu855xChK5GkZ8Q7wX
         xlCw==
X-Forwarded-Encrypted: i=1; AJvYcCUnSVnSKNBYWJIWlFeOaFqSRtCj5fgX1tdXnBB6KkB+29u3+BvzaOoM36AsQIlEXHqpbk0PN5gJ@lists.linux.dev
X-Gm-Message-State: AOJu0Yx3h+PgAykNct3L6AbQoEI3aE2EPhc6qpemd1wyf2UKumIQrCo5
	b6znV9yig18c6Et3xMrhxDZ09hcRzq51SFFMzoFUuX/d4+vLA+e8SsdR194WHYH+FjCFzll0127
	y+5HR2oq1nN3KTHAhXjFSARmBaOm6VlVy3iDScQ==
X-Gm-Gg: ASbGncvbMagIoGmKVDBu0z3bXAK+6Kc9gqwfnctBi96d7j3lucYm8XZCqOUapQO8zLe
	BwPaRT7dNb2TopGA6C89jvi6U7FBwn2qGlHkDZuSQVZR67x4X+Y0a1fQXEa2wkY9HEzE4bJNKTR
	szTVu+z399JA==
X-Google-Smtp-Source: AGHT+IGLWXwyuXaXwfJs34+xd6SLmksW1fOx6jKIpx1cgMPzurnoBpojdOddNFPnUE9Cisi5OmuhcMLx31lCfxgL008=
X-Received: by 2002:a05:6122:16a8:b0:517:4fca:86e2 with SMTP id
 71dfb90a1353d-51d5b3b081emr16121970e0c.10.1737554937647; Wed, 22 Jan 2025
 06:08:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250122073830.779239943@linuxfoundation.org>
In-Reply-To: <20250122073830.779239943@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 22 Jan 2025 19:38:46 +0530
X-Gm-Features: AWEUYZmm_93N1P23_VAh3-RRUpaVrMKj5gQ3K8-rdVA_HV_VCJkQxpDVG-hIKhg
Message-ID: <CA+G9fYvacKD7aFkMCW6nwjZ4t-cpH0deLiPY-cFvGkRn5hgK3w@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/127] 5.15.177-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Anders Roxell <anders.roxell@linaro.org>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"

On Wed, 22 Jan 2025 at 13:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.177 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 24 Jan 2025 07:38:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.177-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


The following build regressions noticed and reported last week and
found it here again on arc, arm, mips, parisc, powerpc with gcc and clang
toolchains on Linux 5.15.177-rc1 and Linux 5.15.177-rc2

Build regression: arc, arm, mips, parisc, powerpc,
drivers/usb/core/port.c struct usb_device has no member named
port_is_suspended

First seen on Linux (Linux 5.15.177-rc2)
  Good: v5.15.176
  Bad: Linux 5.15.177-rc2

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
fs/ext4/readpage.c: In function 'ext4_mpage_readpages':
fs/ext4/readpage.c:413:1: warning: the frame size of 1132 bytes is
larger than 1024 bytes [-Wframe-larger-than=]
  413 | }
      | ^
2025/01/22 08:45:53 socat-internal[1491] W waitpid(-1, {}, WNOHANG):
no child has exited
fs/mpage.c: In function 'do_mpage_readpage':
fs/mpage.c:336:1: warning: the frame size of 1092 bytes is larger than
1024 bytes [-Wframe-larger-than=]
  336 | }
      | ^
fs/mpage.c: In function '__mpage_writepage':
fs/mpage.c:672:1: warning: the frame size of 1156 bytes is larger than
1024 bytes [-Wframe-larger-than=]
  672 | }
      | ^
drivers/usb/core/port.c: In function 'usb_port_shutdown':
drivers/usb/core/port.c:299:26: error: 'struct usb_device' has no
member named 'port_is_suspended'
  299 |         if (udev && !udev->port_is_suspended) {
      |                          ^~

## Build
* kernel: 5.15.177-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: a38aec37d68a477d59deca3dad2b2108c482c033
* git describe: v5.15.176-124-ga38aec37d68a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.176-124-ga38aec37d68a/

metadata:
---------
* Build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.176-124-ga38aec37d68a/testrun/26887549/suite/build/test/gcc-11-defconfig/log
* Details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.176-124-ga38aec37d68a/testrun/26887549/suite/build/test/gcc-11-defconfig/details/
* build: https://storage.tuxsuite.com/public/linaro/lkft/builds/2rydJdviHEKygtIIXuzF9SBprlr/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2rydJdviHEKygtIIXuzF9SBprlr/config
* Architecures: arc, arm, mips, parisc, powerpc
* Toolchain version: gcc-12, gcc-11, gcc-8 and clang-19

Steps to reproduce:
------
$ tuxmake --runtime podman --target-arch arm --toolchain gcc-12
--kconfig footbridge_defconfig
$ tuxmake --runtime podman --target-arch sh --toolchain gcc-11
--kconfig defconfig

--
Linaro LKFT
https://lkft.linaro.org
