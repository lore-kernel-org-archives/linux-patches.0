Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2499A29;
	Thu,  7 Sep 2023 01:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778ABC433C8;
	Thu,  7 Sep 2023 01:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1694050598;
	bh=K1eFDAwhbRf7Pi6Pvuv3Qv4AccmUHTSMDwU5bRVVpoU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=OmR3VWiuKBu6GwGNUSNd/MTIwDc2lN3s9oD9qTLLLOvpx4VjHIkDYIbbaSekHuTMf
	 gEQhrzH/s6OG1XnUU+C7WBj1NAydN/XQkcuDKPsc3E9MJLO0Bc7LJ71DPUgT6/LNsq
	 +sosp/3Y5JAhIJKnvn3SlcCZoGiJk7ikbkem40YGTcmt0XS0iFVsr3NT7wUYxZLkG7
	 oqIQj/7pNqtXT+/874Z2UujbfvvAvZYy3kXUc6fnWDyeXoDmS5NczNI4C0ke/RvNMS
	 3JGFgkB5NMYzq8yAGiAgpAWLWvX2+aY2ElQ8EoFAboZ2Hofw5zR2FJlUuoKQy4QGsu
	 W7K2pdIuFnwEQ==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-51e28cac164so3312054a12.1;
        Wed, 06 Sep 2023 18:36:38 -0700 (PDT)
X-Gm-Message-State: AOJu0YzM1qcBJglOR6pqCnI7cWujvBnWqIAMSEGQn10zold8IJbdE+6r
	FqnYAX7e92oFor9srKQivX/jhYNtTRt/odovvx8=
X-Google-Smtp-Source: AGHT+IFSrgaoII2JeLHGoz+iy1OHR9VPNyJD5qJLZ1Uu0jZu49j7lK4FXM+HkkDci6x1+pekg5uDLrwJI5OAzveExq8=
X-Received: by 2002:a05:6402:3551:b0:52a:586a:b19a with SMTP id
 f17-20020a056402355100b0052a586ab19amr1333622edd.21.1694050596696; Wed, 06
 Sep 2023 18:36:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230905-loongarch-fix-clang-lto-parse_r-v1-1-d991ee630222@kernel.org>
 <241da154-3092-7dc2-09b5-8e9cc7cac5be@xen0n.name>
In-Reply-To: <241da154-3092-7dc2-09b5-8e9cc7cac5be@xen0n.name>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Thu, 7 Sep 2023 09:36:25 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4ZxssZDCTuQUF7UZ7v+O0hN+7Hmw2qwVFUDBDuewGL8w@mail.gmail.com>
Message-ID: <CAAhV-H4ZxssZDCTuQUF7UZ7v+O0hN+7Hmw2qwVFUDBDuewGL8w@mail.gmail.com>
Subject: Re: [PATCH] LoongArch: Drop unused parse_r and parse_v macros
To: WANG Xuerui <kernel@xen0n.name>
Cc: Nathan Chancellor <nathan@kernel.org>, loongarch@lists.linux.dev, llvm@lists.linux.dev, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Queued for loongarch-next, thanks.

Huacai

On Wed, Sep 6, 2023 at 4:36=E2=80=AFPM WANG Xuerui <kernel@xen0n.name> wrot=
e:
>
> On 9/6/23 07:06, Nathan Chancellor wrote:
> > When building with CONFIG_LTO_CLANG_FULL, there are several errors due
> > to the way that parse_r is defined with an __asm__ statement in a
> > header:
> >
> >    ld.lld: error: ld-temp.o <inline asm>:105:1: macro 'parse_r' is alre=
ady defined
> >    .macro  parse_r var r
> >    ^
> >
> > This was an issue for arch/mips as well, which was resolved by
> > commit 67512a8cf5a7 ("MIPS: Avoid macro redefinitions").
> >
> > However, parse_r is unused in arch/loongarch after
> > commit 83d8b38967d2 ("LoongArch: Simplify the invtlb wrappers"), so
> > doing the same change does not make much sense now. Just remove parse_r
> > (and parse_v, which is also unused) to resolve the redefinition error.
> > If it needs to be brought back due to an actual use, it should be
> > brought back with the same changes as the aforementioned arch/mips
> > commit.
> >
> > Closes: https://github.com/ClangBuiltLinux/linux/issues/1924
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > ---
> >   arch/loongarch/include/asm/asmmacro.h  | 107 ------------------------=
---------
> >   arch/loongarch/include/asm/loongarch.h |  43 -------------
> >   2 files changed, 150 deletions(-)
>
> Doh, I must have overlooked this when I last refactored the relevant
> helpers. Thanks for the clean-up!
>
> Reviewed-by: WANG Xuerui <git@xen0n.name>
>
> --
> WANG "xen0n" Xuerui
>
> Linux/LoongArch mailing list: https://lore.kernel.org/loongarch/
>
