Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B611FC5
	for <patches@lists.linux.dev>; Fri, 30 Jun 2023 05:31:04 +0000 (UTC)
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-78f1210e27fso536213241.1
        for <patches@lists.linux.dev>; Thu, 29 Jun 2023 22:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688103063; x=1690695063;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RpifBzIiPQ544NbGz1gUfjlce5GYM88cZVM7W94e/z8=;
        b=hyBvN72rknPc+l9wuFKRChEoRQvzihluKLc0rqj9jWn7jSXfbXqGs7PqOzz71UrJul
         2I5MP1vzV9P1QOwU2ftEh7xmAeNNyxKrIwL7eUmU1Eh1qcaJwSBd30N4Z8nsbg4sgWxX
         Ay5C+cHWHTZ2TNrYni09u7fkSlpC9Iwh7Zl35POz0a/UJCxwT6LXxnEc8biHSmsYKS5r
         BYUhBRLNpeYM1auRS4Sha5oeLvNIRxtyTOPCWoDQd9U5zcNuyob93zvVMPtPIqlWvmXT
         C5EvzicXDCTWRQ6Ohnx4sKq+xGIbDbgrt9P9WGlsl4MBaXVlGgM+/5zrSfTYyUq6vZM1
         42Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688103063; x=1690695063;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RpifBzIiPQ544NbGz1gUfjlce5GYM88cZVM7W94e/z8=;
        b=PUy/sqtKVY0BqGIiLiAYtXNk2ySxp8hNNUe0HXZOqLPDEvXcELoEztPtLPX6M9LeyP
         LS+T/yv2eRw/oB9fS0Ctc/fjyIyj3DqYxevk/AiPiFvLbZ7qhHBLIbP/BgELUUjWDKS9
         tJi/0AThU7HKlaQTJm5a6sNEBQ8DuCBTuGOkTdplzbTthU5NvB75+IeDXJ8Ep2mZ0iz7
         HhrW/U4OW3XRRBiGeUPgfcpaEYwt9r1AlxIJtw2MrViH9B/UGaka0vllaC1aMjwAVPAP
         /+4PA08ykSACpVUIZe8tGTrEk4lX42QPbOJwO/XFoATuvBddIvO3zn+Y8dfhpZ3gtn9G
         l4Fg==
X-Gm-Message-State: ABy/qLZfiATFyzcNHjLxvpzr5oZJkLda/B6eUZp0s5/g/rx/lEgTAqMv
	RC7GEjh8+/njo/d7BzyciH1DZyYAewq4Tkxiai+Odw==
X-Google-Smtp-Source: APBJJlHzXNWEksubwbMG0b87MFUYjvu+33oPvUefO/Epc8vNSR/lvoS7c0KVgVmuLELsuNvgkFBPvRDY6U2aHzPB9S0=
X-Received: by 2002:a67:ec10:0:b0:443:86be:f326 with SMTP id
 d16-20020a67ec10000000b0044386bef326mr1173207vso.18.1688103063100; Thu, 29
 Jun 2023 22:31:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230629184151.888604958@linuxfoundation.org>
In-Reply-To: <20230629184151.888604958@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 30 Jun 2023 11:00:51 +0530
Message-ID: <CA+G9fYsM2s3q1k=+wHszvNbkKbHGe1pskkffWvaGXjYrp6qR=g@mail.gmail.com>
Subject: Re: [PATCH 6.4 00/28] 6.4.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	linux-parisc <linux-parisc@vger.kernel.org>, sparclinux@vger.kernel.org, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Helge Deller <deller@gmx.de>, Jason Wang <wangborong@cdjrlc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 30 Jun 2023 at 00:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.4.1 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 01 Jul 2023 18:41:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.4.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.

Following build regression noticed on Linux stable-rc 6.4 and also noticed =
on
Linux mainline master.

Regressions found on Parisc and Sparc build failed:
 - build/gcc-11-defconfig

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Parisc Build log:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
arch/parisc/mm/fault.c: In function 'do_page_fault':
arch/parisc/mm/fault.c:292:22: error: 'prev' undeclared (first use in
this function)
  292 |                 if (!prev || !(prev->vm_flags & VM_GROWSUP))
      |                      ^~~~
arch/parisc/mm/fault.c:292:22: note: each undeclared identifier is
reported only once for each function it appears in


sparc Build log:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
<stdin>:1519:2: warning: #warning syscall clone3 not implemented [-Wcpp]
arch/sparc/mm/fault_32.c: In function 'force_user_fault':
arch/sparc/mm/fault_32.c:315:49: error: 'regs' undeclared (first use
in this function)
  315 |         vma =3D lock_mm_and_find_vma(mm, address, regs);
      |                                                 ^~~~
arch/sparc/mm/fault_32.c:315:49: note: each undeclared identifier is
reported only once for each function it appears in


Links:
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.4.y/build/v6.=
4-29-g8e5ddb853f08/testrun/17959811/suite/build/test/gcc-11-defconfig/detai=
ls/
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.4.y/build/v6.=
4-29-g8e5ddb853f08/testrun/17959811/suite/build/test/gcc-11-defconfig/log

 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.4.y/build/v6.=
4-29-g8e5ddb853f08/testrun/17959890/suite/build/test/gcc-11-defconfig/detai=
ls/
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.4.y/build/v6.=
4-29-g8e5ddb853f08/testrun/17959890/suite/build/test/gcc-11-defconfig/log


Both build failures noticed on mainline and sparc build have been
fixed yesterday.
 - https://qa-reports.linaro.org/lkft/linux-mainline-master/build/v6.4-8542=
-g82a2a5105589/testrun/17963192/suite/build/test/gcc-11-defconfig/history/


Following patch that got fixed
---
From 0b26eadbf200abf6c97c6d870286c73219cdac65 Mon Sep 17 00:00:00 2001
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 29 Jun 2023 20:41:24 -0700
Subject: sparc32: fix lock_mm_and_find_vma() conversion

The sparc32 conversion to lock_mm_and_find_vma() in commit a050ba1e7422
("mm/fault: convert remaining simple cases to lock_mm_and_find_vma()")
missed the fact that we didn't actually have a 'regs' pointer available
in the 'force_user_fault()' case.

It's there in the regular page fault path ("do_sparc_fault()"), but not
the window underflow/overflow paths.

Which is all fine - we can just pass in a NULL pointer.  The register
state is only used to avoid deadlock with kernel faults, which is not
the case for any of these register window faults.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: a050ba1e7422 ("mm/fault: convert remaining simple cases to
lock_mm_and_find_vma()")
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

--
Linaro LKFT
https://lkft.linaro.org
