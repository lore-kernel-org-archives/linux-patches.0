Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D43418657
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 21:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AG6mAkuG"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6b20a48522fso100470b3a.1
        for <patches@lists.linux.dev>; Wed, 15 Nov 2023 13:38:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700084327; x=1700689127; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=viq9qvmJ3LM7HHbpPLpRFQxdnfMhe+VmNzi8uiGAz9o=;
        b=AG6mAkuGBpHii8jojax2mDd5KepKYkJNNBtRmi/szI53IEBjjlwhCnaLoPcokngOBd
         mCYZgNkTRK1bS6ytC1Qt89WClAfuVLGOHBqEommreEzfYqeTooSYTZmohYDyO7iRW2aZ
         4e+3S98QsxMhHfsyzu3oRSYXGzhm3ceBNp3FAdjgQfL2WyR8BEvY1rm7fZfFE+wZr9OO
         xRrp9BFBuWlh4yrUugnK1vbIbxzjQYPVW90TCUJvSg1CN0WNh2AcSUmAveqbX+V1Uj4B
         3GYnfGY10ZZUr+5FyCdc6Y29RzA0ynN9Jg32lX7og78Ekawm608eD1nyuXFbvRJBlSbI
         FrUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700084327; x=1700689127;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=viq9qvmJ3LM7HHbpPLpRFQxdnfMhe+VmNzi8uiGAz9o=;
        b=lv0YXLY3aTsD15vfx0+cUqGRTNi2hzHbGxUa9hxXjfSqVj4m8cFfYIOI8o3MreqQTb
         8FyMZCMZrjaoOVTwuweU+vOrHlvZG9i8SOPdOYC9ufB7O3C9PDaFV8IONyWplvm2dQgj
         iWjqpGNLt1R/+AAqR5nDyH5yaQbgG1/R0hJcZQiXX9VqeurtRP3tYU9x18qNsBpRGlOw
         YGblM8ErWg3cTdpYS0l5kFcd6KL/PsksL8wg6iZ/eh9dhNH91iKrwtgflYH+Dvh5sOkr
         Li95UgwKmZ2xbGlr9SCkZtlyduVst5p4xzJKE1bq8oJNoljdVF5LHxU0eEwfv+jMiYxE
         ppNw==
X-Gm-Message-State: AOJu0Yy6HdSq944mDqQIg7ckHC0/on0C+p6Ac4XVKUs29jkFVjh+ElxE
	zEYX7XzZi45iFGxwmiqHNZhWun9d80wPp7w3lHBR9A==
X-Google-Smtp-Source: AGHT+IGsT1CibUn6Ia99KLaPjPtxI5AQqKcH5XAZwaf3OwLZ4vdydJ8RnA0NKLZ+rMU0rAcfhpGprFwG1SHgmX5tAe4=
X-Received: by 2002:a05:6a00:1394:b0:6c6:1648:5ac6 with SMTP id
 t20-20020a056a00139400b006c616485ac6mr14670509pfg.5.1700084326699; Wed, 15
 Nov 2023 13:38:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231115191600.708733204@linuxfoundation.org>
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
From: =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date: Wed, 15 Nov 2023 15:38:35 -0600
Message-ID: <CAEUSe7_KQ_-Q2ADLVcuKjb9vGOpkgAEgzgq5o-Hf=7a7c9NLXw@mail.gmail.com>
Subject: Re: [PATCH 6.5 000/550] 6.5.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello!

On Wed, 15 Nov 2023 at 13:20, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 6.5.12 release.
> There are 550 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 17 Nov 2023 19:14:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.5.12-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.5.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

We're seeing build regressions on Arm, Arm64, i386, x86, with KUnit
defconfigs (and multi_v5_defconfig on Arm32):
-----8<-----
  In file included from /builds/linux/lib/kunit/executor.c:225:
  /builds/linux/lib/kunit/executor_test.c: In function 'free_suite_set':
  /builds/linux/lib/kunit/executor_test.c:130:30: error: invalid use
of undefined type 'struct kunit_suite_set'
    130 |         kunit_free_suite_set(*(struct kunit_suite_set *)suite_set=
);
        |                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  /builds/linux/lib/kunit/executor_test.c: In function 'free_suite_set_at_e=
nd':
  /builds/linux/lib/kunit/executor_test.c:141:49: error: invalid use
of undefined type 'struct kunit_suite_set'
    141 |         if (!((struct kunit_suite_set *)to_free)->start)
        |                                                 ^~
  /builds/linux/lib/kunit/executor_test.c:144:31: error: invalid
application of 'sizeof' to incomplete type 'struct kunit_suite_set'
    144 |         free =3D kzalloc(sizeof(struct kunit_suite_set), GFP_KERN=
EL);
        |                               ^~~~~~
  /builds/linux/lib/kunit/executor_test.c:145:17: error: invalid use
of undefined type 'struct kunit_suite_set'
    145 |         *free =3D *(struct kunit_suite_set *)to_free;
        |                 ^
  /builds/linux/lib/kunit/executor_test.c:145:15: error: invalid use
of undefined type 'struct kunit_suite_set'
    145 |         *free =3D *(struct kunit_suite_set *)to_free;
        |               ^
  make[5]: *** [/builds/linux/scripts/Makefile.build:243:
lib/kunit/executor.o] Error 1
----->8-----

This is with defconfig, CONFIG_KASAN=3Dy, CONFIG_KUNIT=3Dy, and
CONFIG_KUNIT_ALL_TESTS=3Dy. To reproduce,

tuxmake \
  --runtime podman \
  --target-arch arm64 \
  --toolchain gcc-13 \
  --kconfig defconfig \
  --kconfig-add CONFIG_KASAN=3Dy \
  --kconfig-add CONFIG_KUNIT=3Dy \
  --kconfig-add CONFIG_KUNIT_ALL_TESTS=3Dy

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Bisection is on-going.

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
