Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77B75381
	for <patches@lists.linux.dev>; Thu, 16 Nov 2023 13:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xliSLi9D"
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-4ac42a20f35so287369e0c.2
        for <patches@lists.linux.dev>; Thu, 16 Nov 2023 05:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700140563; x=1700745363; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=69YHzJgxUUHxHVnmgHSoDMVSUl/PodcB0CYlh9UJ8z4=;
        b=xliSLi9D1pALmRlf+JAAuB0YEEfqEToAwyQBf/K9094LychrSYEep4yHONzZHlGgFx
         GRWovvTKtBTgRoay3Op8PhNPS6+xGgrmgssTE2W2koeM3SHT6ogMmfycPQdYagYXgTdG
         MnqtNTAw4ZZfu7hFd0sKN5rtav15W3rF05Fv7CPzbHlA7VvaMbKOwNxJUEcycWgw2aPU
         CRY6Tt4zU9UdbpB1C0xWOLAynLp9K6cwzGl3cid0pd/BeSPBRxYD55gx2fYmqN5fCEs/
         xWfQpRnSDzaw+2l4meWjaCT+WnP2Ip9F6n/NpKpCCvvwJXjJriWBGJKS5xXl0twcKmU5
         cHzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700140563; x=1700745363;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=69YHzJgxUUHxHVnmgHSoDMVSUl/PodcB0CYlh9UJ8z4=;
        b=n2JAB1hQT+x4f83roflV4RpxG0zQ8VufVatksCQz8z0ObJmPAlo8lrxyjoJdHvIgkw
         hMEZ4ue7wg/VJPj36oRtr64rvLy+WUZE+nxRGGmpin5LSflbSnnwUFdGiSzEdBfTehI5
         dxbYRtre6o6xvrwnGQILBeTjjEc2DOTtIQXptAW1zOoBRjvNS+B/13rvxpymHvSGJdgN
         11XMU5CLnSSjwchRvpDLwobrh3gyRKb65aqSXXgOXhX23EwvdQRSBH5iS8HHs5Nh8CGn
         io9EdGDJ0Z/wNuTCWwk/rAQvBd4wyOxl2Uv2aAKO8jzN0sIdUvsio+jJuLFo4wxLgCCG
         m9hQ==
X-Gm-Message-State: AOJu0Ywm863EfY6sI5UoN/f6RglwJtE3L4qb6QPWNWOuYn5gkufwROCQ
	GrvO6hdrNR6G/MwX5QIWJRVtZhOQxchyrWSUM4Ej6g==
X-Google-Smtp-Source: AGHT+IEhKdssfv9iEp1BRylvQ+lMBhXjwCQDEVddOn5DYOh710s7GJfjHxLmp4ySWGaqaz86D+b9mEPzwkVW+NpGwQo=
X-Received: by 2002:a05:6122:3090:b0:493:7df9:bcc4 with SMTP id
 cd16-20020a056122309000b004937df9bcc4mr12347083vkb.4.1700140563418; Thu, 16
 Nov 2023 05:16:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231115191600.708733204@linuxfoundation.org> <CAEUSe7_KQ_-Q2ADLVcuKjb9vGOpkgAEgzgq5o-Hf=7a7c9NLXw@mail.gmail.com>
 <CAEUSe7_cN0g=i_kS29zbEYdA81ruZNbAA42eYAjRdCDJFSaT+w@mail.gmail.com>
In-Reply-To: <CAEUSe7_cN0g=i_kS29zbEYdA81ruZNbAA42eYAjRdCDJFSaT+w@mail.gmail.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 16 Nov 2023 18:45:52 +0530
Message-ID: <CA+G9fYuncLhP1=BWQv561Jh5cZH9EDmnqnH3Znugi+eua5S0MA@mail.gmail.com>
Subject: Re: [PATCH 6.5 000/550] 6.5.12-rc1 review
To: David Gow <davidgow@google.com>, Jinjie Ruan <ruanjinjie@huawei.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	kunit-dev@googlegroups.com, =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

+ kunit team

On Thu, 16 Nov 2023 at 05:30, Daniel D=C3=ADaz <daniel.diaz@linaro.org> wro=
te:
>
> Hello!
>
> On Wed, 15 Nov 2023 at 15:38, Daniel D=C3=ADaz <daniel.diaz@linaro.org> w=
rote:
> > On Wed, 15 Nov 2023 at 13:20, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > > This is the start of the stable review cycle for the 6.5.12 release.
> > > There are 550 patches in this series, all will be posted as a respons=
e
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >
> > > Responses should be made by Fri, 17 Nov 2023 19:14:03 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/pa=
tch-6.5.12-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git linux-6.5.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > We're seeing build regressions on Arm, Arm64, i386, x86, with KUnit
> > defconfigs (and multi_v5_defconfig on Arm32):
> > -----8<-----
> >   In file included from /builds/linux/lib/kunit/executor.c:225:
> >   /builds/linux/lib/kunit/executor_test.c: In function 'free_suite_set'=
:
> >   /builds/linux/lib/kunit/executor_test.c:130:30: error: invalid use
> > of undefined type 'struct kunit_suite_set'
> >     130 |         kunit_free_suite_set(*(struct kunit_suite_set *)suite=
_set);
> >         |                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~
> >   /builds/linux/lib/kunit/executor_test.c: In function 'free_suite_set_=
at_end':
> >   /builds/linux/lib/kunit/executor_test.c:141:49: error: invalid use
> > of undefined type 'struct kunit_suite_set'
> >     141 |         if (!((struct kunit_suite_set *)to_free)->start)
> >         |                                                 ^~
> >   /builds/linux/lib/kunit/executor_test.c:144:31: error: invalid
> > application of 'sizeof' to incomplete type 'struct kunit_suite_set'
> >     144 |         free =3D kzalloc(sizeof(struct kunit_suite_set), GFP_=
KERNEL);
> >         |                               ^~~~~~
> >   /builds/linux/lib/kunit/executor_test.c:145:17: error: invalid use
> > of undefined type 'struct kunit_suite_set'
> >     145 |         *free =3D *(struct kunit_suite_set *)to_free;
> >         |                 ^
> >   /builds/linux/lib/kunit/executor_test.c:145:15: error: invalid use
> > of undefined type 'struct kunit_suite_set'
> >     145 |         *free =3D *(struct kunit_suite_set *)to_free;
> >         |               ^
> >   make[5]: *** [/builds/linux/scripts/Makefile.build:243:
> > lib/kunit/executor.o] Error 1
> > ----->8-----
> >
> > This is with defconfig, CONFIG_KASAN=3Dy, CONFIG_KUNIT=3Dy, and
> > CONFIG_KUNIT_ALL_TESTS=3Dy. To reproduce,
> >
> > tuxmake \
> >   --runtime podman \
> >   --target-arch arm64 \
> >   --toolchain gcc-13 \
> >   --kconfig defconfig \
> >   --kconfig-add CONFIG_KASAN=3Dy \
> >   --kconfig-add CONFIG_KUNIT=3Dy \
> >   --kconfig-add CONFIG_KUNIT_ALL_TESTS=3Dy
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> > Bisection is on-going.

Thanks Daniel for bisecting this.

> Bisection points to 3aed6e0618a9 ("kunit: test: Fix the possible
> memory leak in executor_test"), upstream commit
> 8040345fdae4cb256c5d981f91ae0f22bea8adcc. Reverting this commit brings
> happiness back to the build.
>
> This problem is not observed on other branches.

stable-rc linux-6.6.y - kunit build pass
stable-rc linux-6.5.y - kunit build failed

## Test Regressions (compared to v6.5.11)
* arm, build
  - gcc-13-lkftconfig-kunit

* arm64, build
  - gcc-13-lkftconfig-kunit


>
> Greetings!
>
> Daniel D=C3=ADaz
> daniel.diaz@linaro.org

- Naresh
