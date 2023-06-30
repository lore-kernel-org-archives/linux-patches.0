Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BD6185D
	for <patches@lists.linux.dev>; Fri, 30 Jun 2023 05:21:52 +0000 (UTC)
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-39ca120c103so1054424b6e.2
        for <patches@lists.linux.dev>; Thu, 29 Jun 2023 22:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688102511; x=1690694511;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3vh6aUxcW9Sd7Nxw2SV2uQlOuQlDwxv1Adt7CXHdwfk=;
        b=nAeGpiUndUVQPZMONYwc5zzAZpk7CWbiehmHv9I1PbnOL9LX5oMIuZWNTjkq6tKdui
         EGnqJS779zDyO/LiRjSBzAjO+gGxxcQC+bxIbZF56aHwtMEOxObe9iVF6839gBPwwtjF
         1mJodOzwca8fotOK97lnhgj4m/DwMgk58D4YuZ29OCw3zVfftkJiJdQONmPTB1YZ6U6V
         AcdwIWxn391JeUYRd/ZJukEncgow4UMeLLEX5d8iX2T6e0BbrtvuB3br66P77W01YQBp
         wrs4oV7U4Zbc1s7W3yKspvIRTSIXvt+XB+j/kNrL/Wymc+BzhAsYXQAJ0BgedIy1dBUC
         U86A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688102511; x=1690694511;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3vh6aUxcW9Sd7Nxw2SV2uQlOuQlDwxv1Adt7CXHdwfk=;
        b=Y/CRmgSoHSQ2p45KTa2cKvgV97Up7JLqQWSHZ4HucRFxRjpENvTWGU33SSzAyFAVmN
         e5yOqS9xDWdpLO1yT43uFxtTaNejT5VDDG1OHSxwTZf0QszK3/+bTqihRmmRJ1ZFWOEn
         27cGUJXBa3A4HovqR1fBBfaZGU4WidOyEclJkYbIB0IjmxiyDTdG7jLMMjq4ywTy9PMJ
         LpFUYYLaqi7QdAeXTwWpqj/NZJVV1HAFXOITO8DXnGzW8AnVq4Q8nobphNGE0PdO4iZC
         fcNIZAvRMQXjhuAm7ov9k+n6fT684xODL/mxCoQJORXkkFZqchClNKnDCuA44WYpgLZN
         MMNw==
X-Gm-Message-State: AC+VfDyNTRJwQ6eqTzbH7ex9Un0UzEb2FnpFdYSOchyUdKDIhr2SC70P
	GqovIr8RzvGZLYpReD1fTloq32w/6lrjIp2EDA4mqA==
X-Google-Smtp-Source: ACHHUZ6UjmrHQtZtyrtFYxI2C+hfVD90LjdrZ/WYiPgj7rLAkiWiamFoA1AZi+yuYC5Nfm+35QUwTj/FybV0jioAUNM=
X-Received: by 2002:a05:6808:11cf:b0:3a1:c108:41b1 with SMTP id
 p15-20020a05680811cf00b003a1c10841b1mr1656069oiv.25.1688102511194; Thu, 29
 Jun 2023 22:21:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230629184151.651069086@linuxfoundation.org> <CAEUSe7-xC90CGpJjQD4w10ea=nXMiGhsFouhaa8fVK5W-WJJJQ@mail.gmail.com>
 <2023063056-waviness-unearth-08aa@gregkh>
In-Reply-To: <2023063056-waviness-unearth-08aa@gregkh>
From: =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date: Thu, 29 Jun 2023 23:21:39 -0600
Message-ID: <CAEUSe7_3+JHgdEAkJ=7ha5pm=24dV5zN_LakKMM6RUBo+nABXQ@mail.gmail.com>
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

On Thu, 29 Jun 2023 at 23:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Jun 29, 2023 at 04:25:40PM -0600, Daniel D=C3=ADaz wrote:
> > Hello!
> >
> > On Thu, 29 Jun 2023 at 12:46, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > > This is the start of the stable review cycle for the 6.1.37 release.
> > > There are 30 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >
> > > Responses should be made by Sat, 01 Jul 2023 18:41:39 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/pa=
tch-6.1.37-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git linux-6.1.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > Early report of failures.
> >
> > SPARC and PA-RISC both fail to build (GCC-8 and GCC-11).
> >
> > For SPARC:
> > * allnoconfig
> > * defconfig
> > * tinyconfig
> >
> > -----8<-----
> > /builds/linux/arch/sparc/mm/fault_32.c: In function 'force_user_fault':
> > /builds/linux/arch/sparc/mm/fault_32.c:312:49: error: 'regs'
> > undeclared (first use in this function)
> >   312 |         vma =3D lock_mm_and_find_vma(mm, address, regs);
> >       |                                                 ^~~~
> > /builds/linux/arch/sparc/mm/fault_32.c:312:49: note: each undeclared
> > identifier is reported only once for each function it appears in
> > make[4]: *** [/builds/linux/scripts/Makefile.build:250:
> > arch/sparc/mm/fault_32.o] Error 1
> > make[4]: Target 'arch/sparc/mm/' not remade because of errors.
> > ----->8-----
> >
> > For PA-RISC:
> > * allnoconfig
> > * tinyconfig
> >
> > -----8<-----
> > /builds/linux/arch/parisc/mm/fault.c: In function 'do_page_fault':
> > /builds/linux/arch/parisc/mm/fault.c:292:22: error: 'prev' undeclared
> > (first use in this function)
> >   292 |                 if (!prev || !(prev->vm_flags & VM_GROWSUP))
> >       |                      ^~~~
> > /builds/linux/arch/parisc/mm/fault.c:292:22: note: each undeclared
> > identifier is reported only once for each function it appears in
> > make[4]: *** [/builds/linux/scripts/Makefile.build:250:
> > arch/parisc/mm/fault.o] Error 1
> > make[4]: Target 'arch/parisc/mm/' not remade because of errors.
> > ----->8-----
>
> These issues are also in Linus's tree right now, right?  Or are they
> unique to the -rc releases right now?

Correct. I went to look at mainline and it fails the same way there
for SPARC and PA-RISC, so 6.1 and 6.4 are on par there; 6.3's failures
on Arm64 are only seen there.

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
