Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDF17E
	for <patches@lists.linux.dev>; Wed,  2 Aug 2023 01:54:36 +0000 (UTC)
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-4476a9e8812so2061229137.2
        for <patches@lists.linux.dev>; Tue, 01 Aug 2023 18:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1690941275; x=1691546075;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Il+U9n5lkmGrYzbgPyJy+8Iv+Ld+DI3VHeIjDoz9VUM=;
        b=vSL0H8DTXB0Kmux8lwHUA0+W91duPqgibPyWwXQ6YMB+vb1l4P2S5ewfEHHHnR4WIN
         4DdmLWqkZyUM2yUIa/LA/VGeYSRLQTUtw1HTiMhy+PE9fkfpGO8Nm7rdXYatSGDhEkQs
         imK3HsRUgwVo2eeH+4FjzpfgZzjFzX6kjXTYqGVXAG+DPHsvM5t1n4ujqIUXcznjO4+z
         /ssmOzh6Bp2DD//7d2bf/zApW8dDuKVx+4cYL7TXCRDXXFe2gMeo+n37VFRXZ0uXspqg
         w867U2wDo3tVKXXNxVyumM7zKmroWlSSMHsghwAIiYCqwlP1DCLmqmIgjg8/MARKAcF8
         jhPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690941275; x=1691546075;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Il+U9n5lkmGrYzbgPyJy+8Iv+Ld+DI3VHeIjDoz9VUM=;
        b=hzr2KBcz92IsgfjqacdRpOiJQN1O7OmxLKVp6ZDpjuFpiXC66ZX2+Jh5uwmToMuXVK
         5ot+kS0xXoSuIgjz4gPfrXHq49v9RNtvYbGwvNNJka3byCP5YpCEKHrO3CaeXkVl96ld
         0IqMwUbtcL62z/xKCybfX67xrG60GdIYrD8WjBXtnx3fIim0r7RJbkXokYwhpOSppx4B
         3TzNuqlX9lvVp+5THS7X1c/TTCv7NLEzH9zPoPTnw8ZgfeE4zI/0at5fOqCBEorESlto
         AYDRNTICDArHsGnnsw3vvs8z2BIIxmF11S5Ypmu6VgsOQLe72ssJl2CMFLBPBbwlU70H
         Z2oA==
X-Gm-Message-State: ABy/qLYann2zr4Giropnj2dXyDENUe+otFUqVHZ17cQat47HLz+yLr6u
	mlJ5gpDLNI/WJDok4T71OA7EQ0pjK4Q2csEqhoE4jg==
X-Google-Smtp-Source: APBJJlHVwke1xKedtBlG6j6nnQKNFJJs08fE/jID+0Q0nxx/66rdtlH74xRK3FUg7aXspTtHo+zeGBv+Kznh+Q3Z30Q=
X-Received: by 2002:a67:eb92:0:b0:443:6052:43a7 with SMTP id
 e18-20020a67eb92000000b00443605243a7mr3785649vso.32.1690941274911; Tue, 01
 Aug 2023 18:54:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230801091922.799813980@linuxfoundation.org>
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 2 Aug 2023 07:24:23 +0530
Message-ID: <CA+G9fYsqEE6P8vKKvWgFDjpgT64FebUssPNS48n6qfUriu6Z1w@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/228] 6.1.43-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	=?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, 
	Andy Shevchenko <andy@kernel.org>, Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 1 Aug 2023 at 15:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.43 release.
> There are 228 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 03 Aug 2023 09:18:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.43-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Following patch caused build regression on stable-rc 6.1 and 5.15,

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

--
Linaro LKFT
https://lkft.linaro.org
