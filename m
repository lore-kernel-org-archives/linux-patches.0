Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916962599;
	Thu, 23 May 2024 02:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716430810; cv=none; b=arNRC4jGs0repzopMRkeIUfcItFNKQ6HnqOcqf9BlG27K1vokop/bCgz4JZwfTn/2eudwg6eFBF8FVTR9aknO121tpXHgdsU4mBKqGJGBk454g0O/9x+ekeldxvzYhnkDEwi7kBUIyyxbOBWg2jJfpPhFaIAZhVOYxrxqr8Y75k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716430810; c=relaxed/simple;
	bh=8YLExkAWvQwUkYKlsfDf7mOtmV2KT3rc2IEA2TsqMH4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fRrmwNs68H3/k6REyvZ/LTPhP1P0aj6AC0X+5CSeLU5i5y1fE3mFr9Yjada/pasvZv2bbZ4jIzNNgBallwTnnbqyg3Avrvc0rk8SayTNKyzcGnLvdkUFXuS1MuEDLIqVcOTGG02IVsXQngzg7mk1eOW7tTZtzjxk8TwT1HSdSBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gqBFRquf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gqBFRquf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA3DC4AF07;
	Thu, 23 May 2024 02:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716430810;
	bh=8YLExkAWvQwUkYKlsfDf7mOtmV2KT3rc2IEA2TsqMH4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=gqBFRqufnpH8uQ3ANXM7tJnCEYf7MZhnBPqa0I9s+8duks+Pgg8Lq45rpWJvHofqT
	 6cXwsEu9xcykJq3I/gzNjiy4Q5/x+vCC2CeBzWsx9hJzWXwogmtCRzizI2gkFV7aa5
	 4PdWYlEz6vllaCO1SuaSZOuU2Oih781BaPZzQCp16dUOO8r+Zk8hH/UnZm6qIuubYG
	 T7EIyR4CLy72Vk4AU/dOH0tmvsiKE+R+vp/oLfS3cllSIfvUx1Ttndd14G9QJc4Gda
	 Bzs+FihojeP4LIFB2dEBEWglO0f5RxajQ/+fmTdHSbRtp9De1AC33qIO53Hk3tV0FA
	 DvNVwhK3UnrIw==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a5a2d0d8644so955863766b.1;
        Wed, 22 May 2024 19:20:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXRi6Dziicx+vKxaWjXiQR24EmtGoQ9Za+bss3hAQ+TcL6/7IAANawEeFgFhS8nu00vcZPDzToWtrBUbF/bMNLVkcdgH779XCAVeOMYN16HroKrNLOzfasqqTAlkzUQe5PYClkEI1uEkVr2GhCcluguCIFR2rtZjJ0=
X-Gm-Message-State: AOJu0YwajrH3jkVchLbheWvHZAAFFv+9SQwhYAFFjXhZrquW4azmCmBr
	6yhWrj31bheMTa108qoQpwJnAJPUV/RWAgB2XS+tnseXsmhwXPJd/rH98+rV3DWD+0I3CEbA12R
	SWMgZ3tU1nnx1m2ZANJ6ftm4XPnI=
X-Google-Smtp-Source: AGHT+IHFFAFNdm2thGmpgTjZWOG+fuvJCmT7/ZlPl55Y9DTWh7mQqEWjHeMPJmZvWGHQXLSxyYiaQAE8rvH+ytx+Hb8=
X-Received: by 2002:a17:906:4152:b0:a59:d44c:9bc with SMTP id
 a640c23a62f3a-a622814def4mr264319766b.66.1716430808794; Wed, 22 May 2024
 19:20:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240522-efi-zboot-lds-add-discard-sections-to-discard-v1-1-6b415efa0f85@kernel.org>
 <CAMj1kXG-Ck3y1STD9GeS6gyqUgOL6ch3jjCtdZjN_w+LScOzpw@mail.gmail.com>
In-Reply-To: <CAMj1kXG-Ck3y1STD9GeS6gyqUgOL6ch3jjCtdZjN_w+LScOzpw@mail.gmail.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Thu, 23 May 2024 10:19:47 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4EOV8cMPpO_=O4rnCNKcMwVa_NeeoA9w8unC5nJU5LzQ@mail.gmail.com>
Message-ID: <CAAhV-H4EOV8cMPpO_=O4rnCNKcMwVa_NeeoA9w8unC5nJU5LzQ@mail.gmail.com>
Subject: Re: [PATCH] efi/libstub: zboot.lds: Discard .discard sections
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, WANG Xuerui <kernel@xen0n.name>, linux-efi@vger.kernel.org, 
	loongarch@lists.linux.dev, llvm@lists.linux.dev, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Acked-by: Huacai Chen <chenhuacai@loongson.cn>

On Thu, May 23, 2024 at 1:37=E2=80=AFAM Ard Biesheuvel <ardb@kernel.org> wr=
ote:
>
> On Wed, 22 May 2024 at 19:32, Nathan Chancellor <nathan@kernel.org> wrote=
:
> >
> > When building ARCH=3Dloongarch defconfig + CONFIG_UNWINDER_ORC=3Dy usin=
g
> > LLVM, there is a warning from ld.lld when linking the EFI zboot image
> > due to the use of unreachable() in number() in vsprintf.c:
> >
> >   ld.lld: warning: drivers/firmware/efi/libstub/lib.a(vsprintf.stub.o):=
(.discard.unreachable+0x0): has non-ABS relocation R_LARCH_32_PCREL against=
 symbol ''
> >
> > If the compiler cannot eliminate the default case for any reason, the
> > .discard.unreachable section will remain in the final binary but the
> > entire point of any section prefixed with .discard is that it is only
> > used at compile time, so it can be discarded via /DISCARD/ in a linker
> > script. The asm-generic vmlinux.lds.h includes .discard and .discard.*
> > in the COMMON_DISCARDS macro but that is not used for zboot.lds, as it
> > is not a kernel image linker script.
> >
> > Add .discard and .discard.* to /DISCARD/ in zboot.lds, so that any
> > sections meant to be discarded at link time are not included in the
> > final zboot image. This issue is not specific to LoongArch, it is just
> > the first architecture to select CONFIG_OBJTOOL, which defines
> > annotate_unreachable() as an asm statement to add the
> > .discard.unreachable section, and use the EFI stub.
> >
> > Closes: https://github.com/ClangBuiltLinux/linux/issues/2023
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
>
> Thanks, I'll take this as a fix.
>
>
> > ---
> >  drivers/firmware/efi/libstub/zboot.lds | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/firmware/efi/libstub/zboot.lds b/drivers/firmware/=
efi/libstub/zboot.lds
> > index ac8c0ef85158..af2c82f7bd90 100644
> > --- a/drivers/firmware/efi/libstub/zboot.lds
> > +++ b/drivers/firmware/efi/libstub/zboot.lds
> > @@ -41,6 +41,7 @@ SECTIONS
> >         }
> >
> >         /DISCARD/ : {
> > +               *(.discard .discard.*)
> >                 *(.modinfo .init.modinfo)
> >         }
> >  }
> >
> > ---
> > base-commit: 15aa8fb852f995dd234a57f12dfb989044968bb6
> > change-id: 20240522-efi-zboot-lds-add-discard-sections-to-discard-5fe29=
bf42d6a
> >
> > Best regards,
> > --
> > Nathan Chancellor <nathan@kernel.org>
> >
