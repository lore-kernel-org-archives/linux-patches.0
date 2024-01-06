Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D9C63AA
	for <patches@lists.linux.dev>; Sat,  6 Jan 2024 09:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="G0GZJe1n"
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-7cc9da9995bso94694241.3
        for <patches@lists.linux.dev>; Sat, 06 Jan 2024 01:48:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704534520; x=1705139320; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vgstzRs1eBJDumteCs72JJvNbnTZ+9hGWDT7za6repc=;
        b=G0GZJe1n+Y01wBnO54BEArfUwFek2k6br6xpHpOnzGAhGRKfaW4l0tOjG0Kd1A/1/d
         adDZsPG8YBHxdy9aYK8I1pwOieSPqflSz4OF1rJkUo1gFh56S2OJkmY3f66vRDyuwFGL
         JqgQfAYc4D6EoSQAQJDIceyLAxbd5sgvAQXvMYv0O1Q2KkMlK1zJXsBC01L3uZSPjrCl
         pCKlEjjtXmepoNK0AWE7xSH51IgsiAfUusBAWQaam28y+mSu44277q5M0QZznDiVnZU1
         4KxJY9SsF4YpLEPTjK4V9SuXVu4QZtnP/yS/3213ytrP6ZlRgTB6t/RObx2XYjKhsK5f
         nbBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704534520; x=1705139320;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vgstzRs1eBJDumteCs72JJvNbnTZ+9hGWDT7za6repc=;
        b=mFAvQKBOQwKGDg85HrLCRr9NU+T5jcDIb/mWGe/vzYSYxP0qhaE3COQkOji93zOOr7
         WPi0I5+NXkhsPLql8ZfXu1bN5p1aRk6PHFmcUZjXm5EfX2jq71eBgTZGMv/7tSBb4p+9
         AhMcrMAZHhYjZIb58/veNAgioW62xEL6A9bLDI2owIs1iXxnwzMBieHNFL0vsyr6s3mr
         t/XJ0pM9hswdlx4JkC16xSmb2JdAS8O6Cwq0g2GgA/F2uO2l/9aIb1oXtm3yNfjB0h3W
         DlJBwT39Mx5IasKCmbzElA5dOWDUNDyYhQaX7mRIaPZTen8Vtzg1d5fdqL+UbGC/b5rp
         4cRw==
X-Gm-Message-State: AOJu0YwuSwi9eaEWxdQsjBgEROGBEM+Nd0t+lmy3Hgc+RSQqVxiHHYc7
	8vncKbV9fBeg0ORkysFCfumB6so1O+SGfE5PjdGvYD+JlYjwZQ==
X-Google-Smtp-Source: AGHT+IFYHaGqado17iy2giax5bLPTFxnfF+oU5WxDjizNvay06w9exwcoknBbu5DdUHqeDkesoIDVabur7jqEIdg2+E=
X-Received: by 2002:a05:6122:4c0d:b0:4b6:d1da:5bd1 with SMTP id
 ff13-20020a0561224c0d00b004b6d1da5bd1mr246148vkb.2.1704534519728; Sat, 06 Jan
 2024 01:48:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240106084013.773696451@linuxfoundation.org>
In-Reply-To: <20240106084013.773696451@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 6 Jan 2024 15:18:28 +0530
Message-ID: <CA+G9fYsjCRtzFpeBQJepL7H=wyyUu0hi0kN+A3w6-BzksHwYhg@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/20] 4.14.335-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	=?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>, 
	Liu Jian <liujian56@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 6 Jan 2024 at 14:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.335 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 08 Jan 2024 08:40:01 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.335-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

As Daniel reported on RC1 about this failure.
Following build failures noticed on 4.14.335-rc2

 Arm64 with Clang 17:

-----8<-----
   /builds/linux/net/8021q/vlan_core.c:332:39: error: incompatible
integer to pointer conversion passing '__be16' (aka 'unsigned short')
to parameter of type 'const struct vlan_vi
   d_info *' [-Wint-conversion]
     332 |                 if (!vlan_hw_filter_capable(by_dev, vid_info->pr=
oto))
         |                                                     ^~~~~~~~~~~~=
~~~
   /builds/linux/net/8021q/vlan_core.c:169:38: note: passing argument
to parameter 'vid_info' here
     169 |                                      const struct
vlan_vid_info *vid_info)
         |                                                                 =
 ^
   /builds/linux/net/8021q/vlan_core.c:344:39: error: incompatible
integer to pointer conversion passing '__be16' (aka 'unsigned short')
to parameter of type 'const struct vlan_vi
   d_info *' [-Wint-conversion]
     344 |                 if (!vlan_hw_filter_capable(by_dev, vid_info->pr=
oto))
         |                                                     ^~~~~~~~~~~~=
~~~
   /builds/linux/net/8021q/vlan_core.c:169:38: note: passing argument
to parameter 'vid_info' here
     169 |                                      const struct
vlan_vid_info *vid_info)
         |                                                                 =
 ^
   /builds/linux/net/8021q/vlan_core.c:366:39: error: incompatible
integer to pointer conversion passing '__be16' (aka 'unsigned short')
to parameter of type 'const struct vlan_vid_info *' [-Wint-conversion]
     366 |                 if (!vlan_hw_filter_capable(by_dev, vid_info->pr=
oto))
         |                                                     ^~~~~~~~~~~~=
~~~
   /builds/linux/net/8021q/vlan_core.c:169:38: note: passing argument
to parameter 'vid_info' here
     169 |                                      const struct
vlan_vid_info *vid_info)
         |                                                                 =
 ^
   3 errors generated.
   make[3]: *** [/builds/linux/scripts/Makefile.build:329:
net/8021q/vlan_core.o] Error 1
----->8-----

Bisection in this case points to:

   commit f33474044777425b3578d4e8b22a003f034ae214
   Author: Liu Jian <liujian56@huawei.com>
   Date:   Sat Dec 16 15:52:18 2023 +0800

       net: check vlan filter feature in vlan_vids_add_by_dev() and
vlan_vids_del_by_dev()

       [ Upstream commit 01a564bab4876007ce35f312e16797dfe40e4823 ]

Reproducer:

   tuxmake --runtime podman --target-arch arm64 --toolchain clang-17
--kconfig defconfig LD=3Dld.lld LLVM_IAS=3D0

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org

- Naresh
