Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF561AD418
	for <patches@lists.linux.dev>; Tue, 15 Oct 2024 07:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728978459; cv=none; b=ScFercieR+JD2dFjV2dhBjdZxAJQXSSMVs4Qtqg+WaqRuRK5zr1c891iiyug2FLqfowakSF2MqNJO0FloycHwtHoHV8ijKRfUmTN3bwCf8mWtgXSrshn3W2mm2zklAcOte1CtoX4mNR2JnCG2B6ruL7H5TPwt+J9b+5qo+QA6p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728978459; c=relaxed/simple;
	bh=D6bs8AhbvZ1hhOwFTkRYuSj0EUYlQBuMG38nrex0/Q0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nggdf5xIeI4VYsJ/WeNqJPaxxmMYm7VLwyQpiM3rNiiPQuq1rxIKuBeigxyYH/RzgjBT5qaniBDXI2471tvgoe0JZ4dIjOmS5vI+9a660YAVuCyMgDP1hdTZyd5go/GCgAZXid6vysIC0o7xzWS+SyRXloLsI90SVUNa1i9waF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=A1/7varJ; arc=none smtp.client-ip=209.85.222.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="A1/7varJ"
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-84fb86af725so1205175241.0
        for <patches@lists.linux.dev>; Tue, 15 Oct 2024 00:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1728978456; x=1729583256; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=F1JMqOkw9Vt25iJpUnQeg9aOLmHsYLQqSKR1jmOnHY8=;
        b=A1/7varJfzBFat+tzOcVV5+LGeqCS4bO6c4AUpg0RgBHbfjWVph7ko/mokVXSjTE22
         O3YO3lUMqWVkpK+Ia/P798zuTa2sS+OIHa+r4yY4x3U1I+gp4RrbveKw5sS7FAH6dWV/
         70ilfPZiYEsclX7fPOYLm06mpr0nZIaYTqZWeTpD+vkhEpliDOhYOqb22CxtriYaLycJ
         Mi3fZWXP2eLQDAQ7QVKOhWxHemY3OFoNl9KBcyrpyQRykyhl8upGWRKU0KwIi86UJJiY
         wirUy8dkhr7lF1tDqs65qvml7S3En7z+1S9+dbd2kAd+xzySBgRZKM5Px6BrgCx+vn0g
         byuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728978456; x=1729583256;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F1JMqOkw9Vt25iJpUnQeg9aOLmHsYLQqSKR1jmOnHY8=;
        b=D0Si9BHtbC9BCBKKMt+NME60LRVlZHO/nzaIzpWBRSeMWOk0LQGR1jsMGBqIy5z/hM
         TzZV5fyZn77LF0fuRyTEt2fHRtqfE4OnRbvnx5fgoXhgDRqwAwhu0eRztUZiD7cBIprV
         oX4wv6LL1zUXh8hKqM5wRt5gpRzAUlTPNmE306cdj3FaG3zmJemKNg9ZbxC2Mvwv9JRu
         R2nOVb5unTffFSKDwoFFISCT6Cbb7yl/HRrz9a0Bikf1gNXhAWvPxAuRKMx36Qhckg6A
         OzGfGc7YmeUuS/zsgTQdEHZuvNEKV1n24qk7M26aE5W16rNMZhpYENQbvOsy/O7Vk6Hn
         ngXw==
X-Forwarded-Encrypted: i=1; AJvYcCXQIhloWJpEBTUv668nqTqS5zFFJ2Yar/9ApcScV2jvT3X5IBI3t+0cLrQtKpknf6V4cZwppvBD@lists.linux.dev
X-Gm-Message-State: AOJu0YyroqjgQiWt19oO9a1lUwD7px7lifZeOzkYDn5/zTl2eXY9j2rZ
	OTRvCLrrTTuUf5LgKv9F2fwt13eFLV3sy7KM2wx7IonRZ81Pih1p6ReCB2nlJdsNIW4Inzptrtc
	kBMP9oaJKf53lXqg3ZGtdqdJLwLvlQEExTS96LvIMecJ/Zyek5M8=
X-Google-Smtp-Source: AGHT+IGdVCcCuUjhI+WseBShaKTMvVroRB+xVABD2EDZXIOC+Dkk/mBw6Vsr9hWqTFsvCcMpmLqrHD58pwpk6UgsWFA=
X-Received: by 2002:a05:6102:d87:b0:4a3:d8ab:8938 with SMTP id
 ada2fe7eead31-4a475f4cdd3mr5869905137.12.1728978456286; Tue, 15 Oct 2024
 00:47:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241014141217.941104064@linuxfoundation.org>
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 15 Oct 2024 13:17:24 +0530
Message-ID: <CA+G9fYv7K3-4M0unzJz_AGG1kySTkDYMaqXXgCFisd2j0iPCEg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/798] 6.1.113-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>, Lee Jones <lee@kernel.org>, 
	Abel Vesa <abel.vesa@linaro.org>, linux-clk <linux-clk@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 14 Oct 2024 at 20:20, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.113 release.
> There are 798 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Oct 2024 14:09:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.113-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

As others reported,

The arm build broke on the stable-rc linux-6.1.y branch due to
following build warnings / errors.

First seen on v6.1.112-799-gc060104c065d
  GOOD: v6.1.112
  BAD: v6.1.112-799-gc060104c065d

The bisection pointed to,
  clk: imx6ul: add ethernet refclock mux support
    [ Upstream commit 4e197ee880c24ecb63f7fe17449b3653bc64b03c ]

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

List of regressions,
* arm, build
  - clang-19-allmodconfig
  - clang-19-defconfig
  - clang-19-imx_v6_v7_defconfig
  - clang-19-lkftconfig
  - clang-19-lkftconfig-no-kselftest-frag
  - clang-nightly-defconfig
  - clang-nightly-imx_v6_v7_defconfig
  - clang-nightly-lkftconfig
  - clang-nightly-lkftconfig-kselftest
  - gcc-13-allmodconfig
  - gcc-13-defconfig
  - gcc-13-imx_v6_v7_defconfig
  - gcc-13-lkftconfig
  - gcc-13-lkftconfig-debug
  - gcc-13-lkftconfig-debug-kmemleak
  - gcc-13-lkftconfig-kasan
  - gcc-13-lkftconfig-kselftest
  - gcc-13-lkftconfig-kunit
  - gcc-13-lkftconfig-libgpiod
  - gcc-13-lkftconfig-no-kselftest-frag
  - gcc-13-lkftconfig-perf
  - gcc-13-lkftconfig-rcutorture
  - gcc-8-defconfig
  - gcc-8-imx_v6_v7_defconfig


Build log:
---------
drivers/clk/imx/clk-imx6ul.c:489:41: error: implicit declaration of
function 'imx_obtain_fixed_of_clock'; did you mean
'imx_obtain_fixed_clock'? [-Werror=implicit-function-declaration]
  489 |         hws[IMX6UL_CLK_ENET1_REF_PAD] =
imx_obtain_fixed_of_clock(ccm_node, "enet1_ref_pad", 0);
      |                                         ^~~~~~~~~~~~~~~~~~~~~~~~~
      |                                         imx_obtain_fixed_clock
drivers/clk/imx/clk-imx6ul.c:489:39: warning: assignment to 'struct
clk_hw *' from 'int' makes pointer from integer without a cast
[-Wint-conversion]
  489 |         hws[IMX6UL_CLK_ENET1_REF_PAD] =
imx_obtain_fixed_of_clock(ccm_node, "enet1_ref_pad", 0);
      |                                       ^
drivers/clk/imx/clk-imx6ul.c:491:41: error: implicit declaration of
function 'imx_clk_gpr_mux'; did you mean 'imx_clk_hw_mux'?
[-Werror=implicit-function-declaration]
  491 |         hws[IMX6UL_CLK_ENET1_REF_SEL] =
imx_clk_gpr_mux("enet1_ref_sel", "fsl,imx6ul-iomuxc-gpr",
      |                                         ^~~~~~~~~~~~~~~
      |                                         imx_clk_hw_mux
drivers/clk/imx/clk-imx6ul.c:491:39: warning: assignment to 'struct
clk_hw *' from 'int' makes pointer from integer without a cast
[-Wint-conversion]
  491 |         hws[IMX6UL_CLK_ENET1_REF_SEL] =
imx_clk_gpr_mux("enet1_ref_sel", "fsl,imx6ul-iomuxc-gpr",
      |                                       ^
drivers/clk/imx/clk-imx6ul.c:494:39: warning: assignment to 'struct
clk_hw *' from 'int' makes pointer from integer without a cast
[-Wint-conversion]
  494 |         hws[IMX6UL_CLK_ENET2_REF_PAD] =
imx_obtain_fixed_of_clock(ccm_node, "enet2_ref_pad", 0);
      |                                       ^
drivers/clk/imx/clk-imx6ul.c:496:39: warning: assignment to 'struct
clk_hw *' from 'int' makes pointer from integer without a cast
[-Wint-conversion]
  496 |         hws[IMX6UL_CLK_ENET2_REF_SEL] =
imx_clk_gpr_mux("enet2_ref_sel", "fsl,imx6ul-iomuxc-gpr",
      |                                       ^
drivers/clk/imx/clk-imx6ul.c:548:9: error: too few arguments to
function 'imx_register_uart_clocks'
  548 |         imx_register_uart_clocks();
      |         ^~~~~~~~~~~~~~~~~~~~~~~~
In file included from drivers/clk/imx/clk-imx6ul.c:19:
drivers/clk/imx/clk.h:15:6: note: declared here
   15 | void imx_register_uart_clocks(unsigned int clk_count);
      |      ^~~~~~~~~~~~~~~~~~~~~~~~
cc1: some warnings being treated as errors


Build log link,
-------------
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.112-799-gc060104c065d/testrun/25432777/suite/build/test/gcc-13-defconfig/log
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2nQwgipt3iHSCkBuMSKQIhwr95q/

metadata:
----
  git describe: v6.1.112-799-gc060104c065d
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git sha: c060104c065dc2884e301155e32dd955e6bb45b5
  kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2nQwgipt3iHSCkBuMSKQIhwr95q/config
  build url: https://storage.tuxsuite.com/public/linaro/lkft/builds/2nQwgipt3iHSCkBuMSKQIhwr95q/
  toolchain: clang-19 and gcc-13
  config: defconfig
  arch: arm

Steps to reproduce:
-------
# tuxmake --runtime podman --target-arch arm --toolchain gcc-13
--kconfig defconfig

--
Linaro LKFT
https://lkft.linaro.org
