Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96F445948
	for <patches@lists.linux.dev>; Thu, 16 Nov 2023 00:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yeguTO1j"
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-1ea48ef2cbfso108809fac.2
        for <patches@lists.linux.dev>; Wed, 15 Nov 2023 16:00:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700092828; x=1700697628; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tp8xQcGoeOD8I/B6IEM0pHmkue79495Y+96+pRcwJUM=;
        b=yeguTO1j3y9xgNWnMy8wk7qt9OmVbKcRwb1RAxlM4qWq8sXP27SLbr47C/abfF7IQg
         crhFWMz3/BCBO60TsQFF3fQMbpBfN9e1GRHEl4RkB11fNpuCA0W3Is8P6moISmQF1gBW
         /tR7fSqwLb9MMNk3ovYiM8xZ6dv1h0vpzbt5+CsCnsgG1TZlcvAQZSl9P1hzqTKvIc4P
         pHkzPhTktKFsGUMXekrCphlHvWDP5Nf25MbEbgJflLy0LalgzmIO+/eIASqP/dS1rRma
         eOMf7Wd/8VfuqU5mKVTBipPH+9/iEgCty1aLMGqHZ9C8S8iiVDc6LHPvacArCkxnsvNh
         XuHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700092828; x=1700697628;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tp8xQcGoeOD8I/B6IEM0pHmkue79495Y+96+pRcwJUM=;
        b=kd0by9Wbt1LUmc5OK+ju2Dl6WK7zHou1PI9DfApbFip0ih46w4t/ldxbyxTfaLmiKn
         sgn/pf0Bhv9xUk75Rys2+INFDt3Av2LCEosOpIud58h93pZuKYkIfJolAMFvy5lA0CrI
         f+EPmCKmNkTRUgH/KMi55zfBcZxJWFtI9Sq/sC35AHvoQZP2Bo6wruLjyL+PeyjzbUHQ
         x6o3fMhUx0Br3RHiIpVL1jSHsF5Vkddvy7FI1hrEE5H+6iOvRlxxYyyqVPNW83stf2r8
         +Js17djebumL3XLtIGiIF3VMnLsw8OkErYLxc3Y49+Wc21t3R+pjVJDcP+d4AH23ZJRH
         r/Og==
X-Gm-Message-State: AOJu0YzIiMunKnFYh1C3dhzdsOx27BHKJeLwxBrSb9RRWEuIvtqQ5IWl
	gXWCTGsurg5YkR9aBgEMcmDEk/9s1cC+PyBuPl0YVA==
X-Google-Smtp-Source: AGHT+IGoX9qNG01zHQG14ZasIrjS0oqxINZ3hMf6kRT8IIM/DTCOIeAaVm/zU9OtB/I9iqTdLqohGxntcdeWLkl584E=
X-Received: by 2002:a05:6871:b0d:b0:1d5:eb1:c587 with SMTP id
 fq13-20020a0568710b0d00b001d50eb1c587mr17024069oab.19.1700092828602; Wed, 15
 Nov 2023 16:00:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231115191600.708733204@linuxfoundation.org> <CAEUSe7_KQ_-Q2ADLVcuKjb9vGOpkgAEgzgq5o-Hf=7a7c9NLXw@mail.gmail.com>
In-Reply-To: <CAEUSe7_KQ_-Q2ADLVcuKjb9vGOpkgAEgzgq5o-Hf=7a7c9NLXw@mail.gmail.com>
From: =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date: Wed, 15 Nov 2023 18:00:16 -0600
Message-ID: <CAEUSe7_cN0g=i_kS29zbEYdA81ruZNbAA42eYAjRdCDJFSaT+w@mail.gmail.com>
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

On Wed, 15 Nov 2023 at 15:38, Daniel D=C3=ADaz <daniel.diaz@linaro.org> wro=
te:
> On Wed, 15 Nov 2023 at 13:20, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > This is the start of the stable review cycle for the 6.5.12 release.
> > There are 550 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 17 Nov 2023 19:14:03 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patc=
h-6.5.12-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-6.5.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> We're seeing build regressions on Arm, Arm64, i386, x86, with KUnit
> defconfigs (and multi_v5_defconfig on Arm32):
> -----8<-----
>   In file included from /builds/linux/lib/kunit/executor.c:225:
>   /builds/linux/lib/kunit/executor_test.c: In function 'free_suite_set':
>   /builds/linux/lib/kunit/executor_test.c:130:30: error: invalid use
> of undefined type 'struct kunit_suite_set'
>     130 |         kunit_free_suite_set(*(struct kunit_suite_set *)suite_s=
et);
>         |                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~
>   /builds/linux/lib/kunit/executor_test.c: In function 'free_suite_set_at=
_end':
>   /builds/linux/lib/kunit/executor_test.c:141:49: error: invalid use
> of undefined type 'struct kunit_suite_set'
>     141 |         if (!((struct kunit_suite_set *)to_free)->start)
>         |                                                 ^~
>   /builds/linux/lib/kunit/executor_test.c:144:31: error: invalid
> application of 'sizeof' to incomplete type 'struct kunit_suite_set'
>     144 |         free =3D kzalloc(sizeof(struct kunit_suite_set), GFP_KE=
RNEL);
>         |                               ^~~~~~
>   /builds/linux/lib/kunit/executor_test.c:145:17: error: invalid use
> of undefined type 'struct kunit_suite_set'
>     145 |         *free =3D *(struct kunit_suite_set *)to_free;
>         |                 ^
>   /builds/linux/lib/kunit/executor_test.c:145:15: error: invalid use
> of undefined type 'struct kunit_suite_set'
>     145 |         *free =3D *(struct kunit_suite_set *)to_free;
>         |               ^
>   make[5]: *** [/builds/linux/scripts/Makefile.build:243:
> lib/kunit/executor.o] Error 1
> ----->8-----
>
> This is with defconfig, CONFIG_KASAN=3Dy, CONFIG_KUNIT=3Dy, and
> CONFIG_KUNIT_ALL_TESTS=3Dy. To reproduce,
>
> tuxmake \
>   --runtime podman \
>   --target-arch arm64 \
>   --toolchain gcc-13 \
>   --kconfig defconfig \
>   --kconfig-add CONFIG_KASAN=3Dy \
>   --kconfig-add CONFIG_KUNIT=3Dy \
>   --kconfig-add CONFIG_KUNIT_ALL_TESTS=3Dy
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> Bisection is on-going.

Bisection points to 3aed6e0618a9 ("kunit: test: Fix the possible
memory leak in executor_test"), upstream commit
8040345fdae4cb256c5d981f91ae0f22bea8adcc. Reverting this commit brings
happiness back to the build.

This problem is not observed on other branches.

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
