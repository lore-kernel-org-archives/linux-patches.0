Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94D110F9
	for <patches@lists.linux.dev>; Tue, 24 Jan 2023 11:48:29 +0000 (UTC)
Received: by mail-vs1-f50.google.com with SMTP id k6so16186362vsk.1
        for <patches@lists.linux.dev>; Tue, 24 Jan 2023 03:48:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yQNMnRtLnVXUsYbjugmcT/zel0k+030c3Lta9eylBxc=;
        b=dAryDTkfsGIYVUyiFQAQg6UcImbZOES0pg/JxW3sjdY3pY1vjHKvJOqwfFi2azRp7t
         0XRzf1m5bxQUym7GyOV1kCTZ9dHiOIErOkUOux6UIOhLtMhlyqht4ccXzXPh29xJq0zF
         gNXXJECUOefPPI29qKU76tNj/s2F4AEW8HANkfVBjO0NImMJHoJ9odTIDzfm3z/A2nNH
         gO60UKQXtyFVQCn8qlkS+UcE90eXRWjEXB6sD7UdrRAYW147cFZy3JJrKqQA8dB+jY8z
         QASUCs5yHKBGDmDplR/JE/53ks1P4kCgLPQ/rgb6bNu10byxDe+WkbWWSObibzEF5lSf
         brIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yQNMnRtLnVXUsYbjugmcT/zel0k+030c3Lta9eylBxc=;
        b=bN7OutHNPozjT6gmH6p+AiYdCQ1/dd0XjcYUHjzYzI3jgStybk61vREL3JAsxUwgR5
         4TrbvrykKujdrTMEgDMeuH7ZtRImoxt9asAZHKY6Zo+HpioSmykHXHX6r59VIAZrOnsd
         bzfztpHMPw5xmjDJ436h6x342ox9dJ0Xykw8tyjrFLrvccH5nEz9wAxww4nD30vySFpa
         BhViKCAmwTmtqIg4GtyxBZQujzn27cdW5ppLExCzxcPSqhVFGVkWn4px7lp7SdJO+v8i
         y3/lJCqhZ0BeKYRsP7/U5TUPdO2HHkGtGovoYGqdUeHJkEiVoaOn2Db5d91dHsZm/T13
         GzIQ==
X-Gm-Message-State: AFqh2kqJnIrWIJzPNtVDIc+LyFVNaU6b73ChunAl3JEwt6+hp6YRUDkJ
	qyX9grswLEan0Y6oxcYBpMu9cZB5YzIWgT2emVei6w==
X-Google-Smtp-Source: AMrXdXtV11k6d6YefYEGLMcYkYjCLfS2e05CjSs8zizNKh6ibTvHrymxvK6XaoOWU//ZuW76eTprlP1a5kKpxbzunzI=
X-Received: by 2002:a67:f2c2:0:b0:3d3:fdf4:9d30 with SMTP id
 a2-20020a67f2c2000000b003d3fdf49d30mr3269571vsn.34.1674560908400; Tue, 24 Jan
 2023 03:48:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230122150246.321043584@linuxfoundation.org> <CA+G9fYsS1GLzMoeh-jz8eOMbomJ=XBg_3FjQ+4w_=Dw1Mwr3rQ@mail.gmail.com>
 <20230123191128.ewfyc5cdbbdx5gtl@oracle.com>
In-Reply-To: <20230123191128.ewfyc5cdbbdx5gtl@oracle.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 24 Jan 2023 17:18:17 +0530
Message-ID: <CA+G9fYuP+S_teUt1dHtEY11-1k2i=hewTEM2PfDonucQ=6Lb8g@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/193] 6.1.8-rc1 review
To: Tom Saeger <tom.saeger@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	Masahiro Yamada <masahiroy@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Dennis Gilmore <dennis@ausil.us>, 
	Palmer Dabbelt <palmer@rivosinc.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 24 Jan 2023 at 00:41, Tom Saeger <tom.saeger@oracle.com> wrote:
>
> On Mon, Jan 23, 2023 at 01:39:11PM +0530, Naresh Kamboju wrote:
> > On Sun, 22 Jan 2023 at 20:51, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 6.1.8 release.
> > > There are 193 patches in this series, all will be posted as a respons=
e
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >
> > > Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/pa=
tch-6.1.8-rc1.gz
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
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> > * sh, build
> >   - gcc-8-dreamcast_defconfig
> >   - gcc-8-microdev_defconfig
>
> Naresh, any chance you could test again adding the following:
>
> diff --git a/arch/sh/kernel/vmlinux.lds.S b/arch/sh/kernel/vmlinux.lds.S
> index 3161b9ccd2a5..b6276a3521d7 100644
> --- a/arch/sh/kernel/vmlinux.lds.S
> +++ b/arch/sh/kernel/vmlinux.lds.S
> @@ -4,6 +4,7 @@
>   * Written by Niibe Yutaka and Paul Mundt
>   */
>  OUTPUT_ARCH(sh)
> +#define RUNTIME_DISCARD_EXIT
>  #include <asm/thread_info.h>
>  #include <asm/cache.h>
>  #include <asm/vmlinux.lds.h>

Above patch fixes the reported problem.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>

>
> My guess is build environment is using ld < 2.36??

"ld": "GNU ld (GNU Binutils for Debian) 2.31.1",

However, we have been building with gcc-8, gcc-10, gcc-11 and gcc-10.

> and this is probably similar to:
> a494398bde27 ("s390: define RUNTIME_DISCARD_EXIT to fix link error with G=
NU ld < 2.36")
> 4b9880dbf3bd ("powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT")
>
>
> Regards,
>
> --Tom

Best regards
Naresh Kamboju
