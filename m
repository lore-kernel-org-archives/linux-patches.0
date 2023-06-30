Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342311C3F
	for <patches@lists.linux.dev>; Fri, 30 Jun 2023 05:25:26 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-26307d808a4so1060642a91.1
        for <patches@lists.linux.dev>; Thu, 29 Jun 2023 22:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688102725; x=1690694725;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WzaczCUBTZTvAfZLPO+zN4aCSdU9+F5DHZ/dQrcjWzU=;
        b=gyQqADp/Sx903gGG+OLLNk+axKHxz5gbLh03VL9H3rJuq5frIVmqzynqnNdfUUkSO0
         chWzDJq2lk/NdeF58MtUmYE7rgpSzHA4Ilke0sHlMqPANkrZEudFK0RYm5MfTpP/s4Ga
         zW1HeN0uelHRkHaABPcmIdqJBVT4QvqCgK1/PBqH2yqrko+u3/kb0jmSz/FnArnW0Kqh
         wrFJRW6IeMWEJW/aUiQsaSI9Xxiw3LH/pbgdrhIti3ipTb0RUrDI2ehb/mTLq/y2lpBh
         W4nEVl1stzehvrVw5xWZnqomsyIQkIRFXHzVqK+nmyXlm+P1JPB8V4Y4cT2wxjx49U3H
         ZH3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688102725; x=1690694725;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WzaczCUBTZTvAfZLPO+zN4aCSdU9+F5DHZ/dQrcjWzU=;
        b=LCsmdGAFOrlBQ/RUr3KOGl8yYa6LhHYVQ5vcsZUvUeSMhTJoogmoAY9IlJV1RyuQIu
         I+in7xPR5HQP+SVL1we+WOdpfBTK7JliWzfXmacGvUniAvgbjrZbQ8JDZ3pgh5+xUbNa
         ZlSB/ckiapCktsWB/m0ldoom6gf/8quq555We4YSDfcMmWEgFa2EQsg8YCVnWUAgbWC9
         LjAjtN+y4USMhMsWvi2B1RYqEAhxlSTrtIoiAvtd/HUt85/UDX0cP/2UfvVakGy/y/PV
         LDyR5XLTuqGOJ8TJGPRjoOhujqxG7Gj7dqW1Co5mk1SR1nUJwsa3c+Ll1aNZNKfvJ+rq
         Y0Zw==
X-Gm-Message-State: ABy/qLZ/b9nG2ee1AJ0QDit1IB2TbfZsfGSsSMS4E0JRDIe8r1EkCD50
	2448R5qf4flQjiyejfVnw13T5DdQFtxNafcPTcigVg==
X-Google-Smtp-Source: APBJJlEerSM3CUZkODwE5AWzXSKWK4mLESDhEoDSC1FUtMU+f/Z6odp2bCPSDoFODGkGksQKGE17TmrF/h6P0IVn9PA=
X-Received: by 2002:a17:90a:3e0c:b0:262:ea83:ed34 with SMTP id
 j12-20020a17090a3e0c00b00262ea83ed34mr1463410pjc.0.1688102725225; Thu, 29 Jun
 2023 22:25:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230629184151.705870770@linuxfoundation.org> <CAEUSe7__cNqH6d1D96m8XriVckS9MnL6CRfd+iTYXnNkqu9nvQ@mail.gmail.com>
 <2023063037-matrix-urologist-030d@gregkh>
In-Reply-To: <2023063037-matrix-urologist-030d@gregkh>
From: =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date: Thu, 29 Jun 2023 23:25:13 -0600
Message-ID: <CAEUSe7-K199dv5_11O877i4pWYtCkaZU2zrsfVo4-QnNPdPQ+A@mail.gmail.com>
Subject: Re: [PATCH 6.3 00/29] 6.3.11-rc1 review
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

On Thu, 29 Jun 2023 at 23:19, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Jun 29, 2023 at 03:54:03PM -0600, Daniel D=C3=ADaz wrote:
> > Hello!
> >
> > Early report of failures.
> >
> > Arm64 fails with GCC-11 on the following configurations:
> > * lkftconfig
> > * lkftconfig-64k_page_size
> > * lkftconfig-debug
> > * lkftconfig-debug-kmemleak
> > * lkftconfig-kasan
> > * lkftconfig-kselftest
> > * lkftconfig-kunit
> > * lkftconfig-libgpiod
> > * lkftconfig-perf
> > * lkftconfig-rcutorture
> >
> > lkftconfig is basically defconfig + a few fragments [1]. The suffixes
> > mean that we're enabling a few other kconfigs.
> >
> > Failure:
> > -----8<-----
> > /builds/linux/arch/arm64/mm/fault.c: In function 'do_page_fault':
> > /builds/linux/arch/arm64/mm/fault.c:576:9: error: 'vma' undeclared
> > (first use in this function); did you mean 'vmap'?
> >   576 |         vma =3D lock_mm_and_find_vma(mm, addr, regs);
> >       |         ^~~
> >       |         vmap
> > /builds/linux/arch/arm64/mm/fault.c:576:9: note: each undeclared
> > identifier is reported only once for each function it appears in
> > /builds/linux/arch/arm64/mm/fault.c:579:17: error: label 'done' used
> > but not defined
> >   579 |                 goto done;
> >       |                 ^~~~
> > make[4]: *** [/builds/linux/scripts/Makefile.build:252:
> > arch/arm64/mm/fault.o] Error 1
> > make[4]: Target 'arch/arm64/mm/' not remade because of errors.
> > ----->8-----
>
> Is this also failing in Linus's tree?

(Sorry for the previous top-post.)

No, only here on 6.3.

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
