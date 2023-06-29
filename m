Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB39FBF1
	for <patches@lists.linux.dev>; Thu, 29 Jun 2023 22:25:53 +0000 (UTC)
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-1b01b43577fso1023990fac.0
        for <patches@lists.linux.dev>; Thu, 29 Jun 2023 15:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688077552; x=1690669552;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7VVwwX9nrMtDElUTnksCD2hg1pI6WoLui9hZmUXkOUA=;
        b=Cfs4r+3s2G+oZHEEH9djQBz/4niZR/nRv7oITEeuxXy9yc60cdW+HiGgXqBrzYrPM5
         RBVCviYxVc9gPRZXtjKNMjIuENGu2pJ8qjIuQHF+aznANdAk3BoxfKvVh4pKOyvZFWa1
         x6fPGUt7aVne9mouyw6xk+YjGo+yIpeXWa5JigKh1uRdjwRP2AOH8z+Gf0gwnab3eVsN
         DU1rwW41gB6TAxThhK2ze0S+pqKe3tlbO8WyqTGExzKEemomds5h/WY8pYjauqS9QnOr
         WyQWfgzQVigPo1brWfpaaq1XSZLJJBTw5kWgvHW16QE69VQ/3KinzVrpsB3UY2jpO8+q
         SE8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688077552; x=1690669552;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7VVwwX9nrMtDElUTnksCD2hg1pI6WoLui9hZmUXkOUA=;
        b=jYhz94OH2+iQp6tZ+bWlZ7aaIUON5sNa0E0Lx9cye7hULbx0W+Ro5T6tpI4pwy+wn7
         yHwDOJzWP9WxruzD44TzW4pe4I4eYerUNDXGzBzlCIl++/hdeVImrptTJK6AH4t0fXJ3
         6A8qOUDXpyiSc1zJkvwfe1fVLrqaPaXezTxIfLxRhFhUGKf4iSMWP4ZSZPoxuTJq7OaR
         3WqUMQyCvjoQnpF3WihVj118rQBnAD51rT/1Mek2zHjk5QclagrkCnfo3l/eMn/0o4FK
         bht5LKCFN3Nr6jvXBLkli+FrlHRFipk6UFKkAVkULrWO6Y1DfnuOxwnfnKzQmT6jWelZ
         zDTA==
X-Gm-Message-State: ABy/qLacczhuzoK5JCerQpuLz+zgvc95ZALMPs5sJZyWB/4E5POB7gOF
	bsL1sCL33dakzfLRvQP7biI1LlJzmsP3+YYdZkK0BZQB0EAPem6ASdykJg==
X-Google-Smtp-Source: APBJJlFx9uA/lUNE2OdWk+UeiIFn0pq5/dwhD/X5fjiA+mq6gLzQ/Hxb60CSmTsJt7uZQ+kheHPbEjiOe5RLarRxLaQ=
X-Received: by 2002:a05:6870:56ac:b0:1ad:1984:9620 with SMTP id
 p44-20020a05687056ac00b001ad19849620mr1523464oao.43.1688077552177; Thu, 29
 Jun 2023 15:25:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230629184151.651069086@linuxfoundation.org>
In-Reply-To: <20230629184151.651069086@linuxfoundation.org>
From: =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date: Thu, 29 Jun 2023 16:25:40 -0600
Message-ID: <CAEUSe7-xC90CGpJjQD4w10ea=nXMiGhsFouhaa8fVK5W-WJJJQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/30] 6.1.37-rc1 review
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

On Thu, 29 Jun 2023 at 12:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 6.1.37 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 01 Jul 2023 18:41:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.37-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Early report of failures.

SPARC and PA-RISC both fail to build (GCC-8 and GCC-11).

For SPARC:
* allnoconfig
* defconfig
* tinyconfig

-----8<-----
/builds/linux/arch/sparc/mm/fault_32.c: In function 'force_user_fault':
/builds/linux/arch/sparc/mm/fault_32.c:312:49: error: 'regs'
undeclared (first use in this function)
  312 |         vma =3D lock_mm_and_find_vma(mm, address, regs);
      |                                                 ^~~~
/builds/linux/arch/sparc/mm/fault_32.c:312:49: note: each undeclared
identifier is reported only once for each function it appears in
make[4]: *** [/builds/linux/scripts/Makefile.build:250:
arch/sparc/mm/fault_32.o] Error 1
make[4]: Target 'arch/sparc/mm/' not remade because of errors.
----->8-----

For PA-RISC:
* allnoconfig
* tinyconfig

-----8<-----
/builds/linux/arch/parisc/mm/fault.c: In function 'do_page_fault':
/builds/linux/arch/parisc/mm/fault.c:292:22: error: 'prev' undeclared
(first use in this function)
  292 |                 if (!prev || !(prev->vm_flags & VM_GROWSUP))
      |                      ^~~~
/builds/linux/arch/parisc/mm/fault.c:292:22: note: each undeclared
identifier is reported only once for each function it appears in
make[4]: *** [/builds/linux/scripts/Makefile.build:250:
arch/parisc/mm/fault.o] Error 1
make[4]: Target 'arch/parisc/mm/' not remade because of errors.
----->8-----

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
