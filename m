Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B63B7E
	for <patches@lists.linux.dev>; Wed,  2 Aug 2023 01:57:16 +0000 (UTC)
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-48642554ef1so2533139e0c.3
        for <patches@lists.linux.dev>; Tue, 01 Aug 2023 18:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1690941435; x=1691546235;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=du9gT3nEt+eVSe4TYuA1bs7ljCbROmy1XMMZ5PJR5GA=;
        b=Rvd2+4Yywg8ZcmZi2a/qLKRqvq/9yK8B9pk6oqe5l9/Q7ugzflHiUc0ybk95JCYS2a
         E6I4Br5GJfH1OJysf8bzX6KZAXWwnUWY3YWSn/vKEKCMHVQoGwxtSOA702CKmqZPcMlP
         E27uFiGYpPNn/sfcDFalTP9qb+ef5XeFoJHELHbK3nogUsA5TzV8fmwGeDFuDZeGd3Rj
         hd/0LRP5K1O9vZezZoK8QXMT5W56tPfdwktAG4i+H+8XXT4WdjY2a4u0BHLVfImi398Y
         3Zxw/wAhMdowOpwNghl5y9uaxDtxSNxUzKUeyy343KMWryGmEg39pCqDWfZpTmM01i2X
         Xncw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690941435; x=1691546235;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=du9gT3nEt+eVSe4TYuA1bs7ljCbROmy1XMMZ5PJR5GA=;
        b=fI6YysxLMtG9x/UgWpClZwnCf7ekCy18PvmxYJEtsJyw/rg9pB+NRMPV/l4D2oflt7
         5lh+RqGBD9sKalv0xTljmN0ZhDEmrIoTAf4aePcTR+YaGw3qN1XgcmHYV31DizKm7m+E
         xfgl1HogfZ0ucjXKAhvfihUtxFnc0s7viWKy9mWKWilY5KbpwvLT0X9HXq0SkSveqYH/
         9eydnxvGkL1ePBVEXmDD2+W5f6F+f0HxLgXRBUEFI6Ll9HYiYiWCqOhCuK7Vc1IfkGqu
         38vf9c0HfDSL3gs1XaKFMVf2D43bDCpW1uUA80KfuGmQjiMVXsPKxowCCF/S7zc6pco2
         NZrw==
X-Gm-Message-State: ABy/qLYCG3vdrXu61sh/4z/f/i9CQL5uXgUq2rLspIdOmncSsSWWaXhc
	bfYF5Qsm5PSKcF90usLOT763JxnNfGw2OUa3lhP/4w==
X-Google-Smtp-Source: APBJJlGWKFhhmL48f26bOfdV+vak3IRD/bcJYZAXm2uQvWL+oHbaEnsw3yuZ6sZ0lfhUB2Nhbw2fFgMEIz/15MCf5W0=
X-Received: by 2002:a1f:5f90:0:b0:46e:85b8:c019 with SMTP id
 t138-20020a1f5f90000000b0046e85b8c019mr4191070vkb.1.1690941434912; Tue, 01
 Aug 2023 18:57:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230801091910.165050260@linuxfoundation.org>
In-Reply-To: <20230801091910.165050260@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 2 Aug 2023 07:27:03 +0530
Message-ID: <CA+G9fYtCYSQ2fzmJU0t7ZCOUWjeRp9+Dn3gJ=4oRJP_CJttOcw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/155] 5.15.124-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 1 Aug 2023 at 14:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.124 release.
> There are 155 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 03 Aug 2023 09:18:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.124-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Following patch caused build regression on stable-rc 5.15 and stable-rc 6.1,

Regressions found on arm:

  - build/gcc-12-orion5x_defconfig
  - build/clang-nightly-orion5x_defconfig
  - build/gcc-8-orion5x_defconfig
  - build/clang-16-orion5x_defconfig

gpio: mvebu: Make use of devm_pwmchip_add
[ Upstream commit 1945063eb59e64d2919cb14d54d081476d9e53bb ]

Build log:
------
drivers/gpio/gpio-mvebu.c: In function 'mvebu_pwm_probe':
drivers/gpio/gpio-mvebu.c:877:16: error: implicit declaration of
function 'devm_pwmchip_add'; did you mean 'pwmchip_add'?
[-Werror=implicit-function-declaration]
  877 |         return devm_pwmchip_add(dev, &mvpwm->chip);
      |                ^~~~~~~~~~~~~~~~
      |                pwmchip_add
cc1: some warnings being treated as errors

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Links:
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.123-156-gb2c388dc2443/testrun/18771613/suite/build/test/gcc-12-orion5x_defconfig/details/

--
Linaro LKFT
https://lkft.linaro.org
