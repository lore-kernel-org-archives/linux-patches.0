Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9FB525C
	for <patches@lists.linux.dev>; Mon,  6 Feb 2023 14:12:52 +0000 (UTC)
Received: by mail-vs1-f50.google.com with SMTP id a24so12793660vsl.2
        for <patches@lists.linux.dev>; Mon, 06 Feb 2023 06:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oi4fqKc8ViThZjQcyqO7FU4A4DRmVAyIaUuFWO0o8PA=;
        b=ENMdbCUKsdJeStCp68yuZIVyU4btt9a3NnvqhNk5RTRik9YizwNzF/2VIBmQUL+RBS
         0ynlpVNAe8zrN7FQF6ypUVdYGrOroz9u2XpvcZiD3+LZ1bMw8mK3ORtvWM4eIw2m08IC
         wgdL+XCUVRd8n57GvmhdNRduw4VVXuWzuUehpPhg5dhkeRuUDZsekrzkaBF7hNH2iTaU
         hvacjikDM82a0bZokqre4bb3JsfJWnqK/p0aCjgOqlB1cR2lDGXDSE+uuwAG+2YfkQUd
         3f7khg7THRhdOBlp36aRaZY712HodWYssDxvviJiOwWqkkOUXZF2rf/9rzU2GvSl/JWd
         7PFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oi4fqKc8ViThZjQcyqO7FU4A4DRmVAyIaUuFWO0o8PA=;
        b=YJftCtwtsIZhnzXjgnm20JuyvSPbUPhFtgRHA5sPSs1PKMg+W3HZzrlMwPkwcVkcVn
         60ZZKIkdOb7wv7Gw2E2vUZJi9OeGycb+aGsSCKZYu0LOlr5UUwxC8EvAY0u5Z4dTrk2i
         UFp6m8W2kURrNN9swtt80TRuTmm5DRVvjXtluTMe+LqylncyAwWkEWAwXOndpC62Vk69
         3Gdu9vKbLlKuWJvc4P9rSAthS+M1X33v9tVLoFjh8j3Qgag4qts7S6Z3+res3yRml0QB
         ih67dtOmUNfp5NjcLZoFXb2dgMs2K1yjSdj91gLiu3sq6nTHXhBbHO2ya6+rnfEC3JZ5
         U7cg==
X-Gm-Message-State: AO0yUKVdh1GvKokGcBpSzOhgnq1CuLInkSkYCOjVOUgSmjMLm3lhHA3a
	xWSA9XfzwlNy9VaKe3SYwg9Vrr7dioGB3v9NAqi6Yg==
X-Google-Smtp-Source: AK7set9W1cqOslAljm2IbR0q5/qXbpfuRcZDUXKQ9VdbxWjIqw0l7z2qUW2rV1oj8sf/RuL5HumAJyO1vdB31QJ+GPI=
X-Received: by 2002:a05:6102:204d:b0:3f1:53d4:9e87 with SMTP id
 q13-20020a056102204d00b003f153d49e87mr2718607vsr.34.1675692770852; Mon, 06
 Feb 2023 06:12:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230203101009.946745030@linuxfoundation.org> <CA+G9fYtsSuw=W0LSpzJRzsXB6qGYS3og1v=FOrvPHSAdRPCDPA@mail.gmail.com>
 <Y+AIsz4/7Ms28aWK@dev-arch.thelio-3990X>
In-Reply-To: <Y+AIsz4/7Ms28aWK@dev-arch.thelio-3990X>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 6 Feb 2023 19:42:39 +0530
Message-ID: <CA+G9fYtN=0nMkkUE7FAFutK5jLS--fr_ZcrJw0nb5BhMqQoZUA@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/28] 6.1.10-rc1 review
To: Nathan Chancellor <nathan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 6 Feb 2023 at 01:21, Nathan Chancellor <nathan@kernel.org> wrote:
>
> Hi Naresh,
>
> On Sat, Feb 04, 2023 at 12:55:10PM +0530, Naresh Kamboju wrote:
> > On Fri, 3 Feb 2023 at 15:50, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 6.1.10 release.
> > > There are 28 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >
> > > Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/pa=
tch-6.1.10-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git linux-6.1.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> >
> > Results from Linaro=E2=80=99s test farm.
> > No regressions on arm64, arm, x86_64, and i386.
> >
> > Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> > NOTE:
> >
> > clang-nightly-allmodconfig - Failed
> >
> > Build error:
> > -----------
> >   include/linux/fortify-string.h:430:4: error: call to '__write_overflo=
w_field'
> >    declared with 'warning' attribute: detected write beyond size of fie=
ld
> >    (1st parameter); maybe use struct_group()? [-Werror,-Wattribute-warn=
ing]
> >
> > This is already reported upstream,
> > https://lore.kernel.org/llvm/63d0c141.050a0220.c848b.4e93@mx.google.com=
/
>
> I think you copied the wrong warning, as the one upstream is a write
> warning, whereas the one I see in your build logs is a read error:

You are right !
Thanks for checking build logs.

>
> In file included from /builds/linux/drivers/infiniband/core/cma.c:9:
> In file included from /builds/linux/include/linux/completion.h:12:
> In file included from /builds/linux/include/linux/swait.h:7:
> In file included from /builds/linux/include/linux/spinlock.h:56:
> In file included from /builds/linux/include/linux/preempt.h:78:
> In file included from /builds/linux/arch/x86/include/asm/preempt.h:7:
> In file included from /builds/linux/include/linux/thread_info.h:60:
> In file included from /builds/linux/arch/x86/include/asm/thread_info.h:53=
:
> In file included from /builds/linux/arch/x86/include/asm/cpufeature.h:5:
> In file included from /builds/linux/arch/x86/include/asm/processor.h:22:
> In file included from /builds/linux/arch/x86/include/asm/msr.h:11:
> In file included from /builds/linux/arch/x86/include/asm/cpumask.h:5:
> In file included from /builds/linux/include/linux/cpumask.h:12:
> In file included from /builds/linux/include/linux/bitmap.h:11:
> In file included from /builds/linux/include/linux/string.h:253:
> /builds/linux/include/linux/fortify-string.h:543:4: error: call to '__rea=
d_overflow' declared with 'error' attribute: detected read beyond size of o=
bject (1st parameter)
>                         __read_overflow();
>                         ^
>
> Regardless, this is still a clang bug that we are actively investigating,=
 so it
> can still be safely ignored by the kernel folks.
>
> https://github.com/ClangBuiltLinux/linux/issues/1687

Thank you.

> Cheers,
> Nathan

- Naresh
