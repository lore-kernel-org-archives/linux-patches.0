Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB704F5E9
	for <patches@lists.linux.dev>; Thu,  8 Feb 2024 21:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707427359; cv=none; b=nYuBeTEsoL/QIQTmN97GH9qRQu4ndaCJeGYXJp3gDpcXbRNm+jtKB+DDUUNNZ+BTfxVANobSEAb6QnGWL3bK/wq9ZurzNfaj8vD7abJZzoEXHpAeExxMechqb0vfzmumWLyuDrHHwH+p/wVNzqI5sF4IJAo0Dd/XoxJ3qkvGLV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707427359; c=relaxed/simple;
	bh=vH5p1yozyS4whmGot7j+dGY6TpRrz6VTlRnbT5a6g3w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o4jLxLYfBFEThCf6TJa6iGd0YSIpR4Uf2gNJND0yDIIMd0i38TmonIenifBBjkc/y+r2wc0iKd74ogrW8EXrt7DfJ2Y3l+sVrLESk+Yd0exoial35C/0eLc9ZdHPV38aij3og+NAmTwtwNTOQEwt2wqBdDmPGlaCVdu1ZXhHZ9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pqlfOOuH; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pqlfOOuH"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-40fd15fe6a8so108535e9.0
        for <patches@lists.linux.dev>; Thu, 08 Feb 2024 13:22:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707427355; x=1708032155; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l8OU3wz4Ub9unVCJsi58NeLWLTNcAHTCBjqsWFPwn4Q=;
        b=pqlfOOuH6ag64VPK8Ye+usZOae/zMNZ0cOkrlq0yh0EuBempjmVsEQlx+AjDNeurDt
         N+Yug0enuHKysP6nnaCq4BoP8jsRDZ63eN9idMzQcw1zl7cOm/nONRJYqPleB6jPaoGa
         2OYVC2MkMzZMkTjz5ZJnbNSy6ZXKlrhyY2Fr6mC6hCxRlJMGBn2zK+WApjJfj4b14XNx
         lN8Ca9YhVGhBnTxRtntF8ESFBAFmUNL+JE/4KNcVRBfgBSUXVVv/LU/q+RxfNovjY23y
         wCjfF4EfnG0Y7839/5/mWujeAxse31VsLBh7so5vDVXLNM4JPz2LUFZdseMG/MbZhuwm
         q0gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707427355; x=1708032155;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l8OU3wz4Ub9unVCJsi58NeLWLTNcAHTCBjqsWFPwn4Q=;
        b=WxHoZwNGTZpQQXmUzUNeSm0px+8TOEepv/Jo9fLZSEPVs++jgjwvMi8b9IAzmm1mDd
         BcVWafhC4Pl+83IMDbhJiEbEmCuHW5UX9bIvsLmDBveV54VwSdScTpJHMudKvu/1sbL3
         FOlYf+dso7ViyT41d/scsZiIda54XvHJVJoI6xSKFXwR3DIyWQIUNiezBzq3ojsa6dcD
         SjLdMAd2oo6GLJijsi7fsQClL8IvYZFSVIFGNtuHMb7ijEAbHdDyb6uV8o+Rp0eE4v9D
         JnGUrIjzBoP3IerTxLGgfZ0UjIc/sMHdgW/I7XtPk6+xNQo9UcfDezDtrKuyh9KKEYI/
         Oc/g==
X-Forwarded-Encrypted: i=1; AJvYcCUMi3hFmC7zv/1EcFiRrFAsxG+Qc+JxuvbclTbwVA6lJ8HsZvUWmjRqFmimZObEC7aoBT2v1cPEq21N06UIZLoj1h1O78HRSA==
X-Gm-Message-State: AOJu0YwgY/G/e0BxFwfLzXjwxF/H0q+OaLRHAUPnaLbM2RkEwG6a0cEh
	a1FrqImuCnKkv//lJQFSWj1rJg2/QUuIbVtwqsWWWPAgfXqK0AIG6F/ptckpJe20jQSB8R7Ta3W
	edG0deMwJHJuYF9IhVjrrMCvLT1vKxIQ0Bpsd
X-Google-Smtp-Source: AGHT+IE7vsPh10DxxI1KA5C1YT2SkrXDYmEzpjmr7LVzOBYiWexDjyjtO0Q/ohKVicH6UWqWtcYYaAlJfHXUAZ5liMM=
X-Received: by 2002:a05:600c:3d8e:b0:40f:dd8f:152c with SMTP id
 bi14-20020a05600c3d8e00b0040fdd8f152cmr51960wmb.4.1707427354952; Thu, 08 Feb
 2024 13:22:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240208-fix-elf-type-btf-vmlinux-bin-o-big-endian-v1-1-cb3112491edc@kernel.org>
 <ZcVDXhFQB1tzka3C@fjasle.eu>
In-Reply-To: <ZcVDXhFQB1tzka3C@fjasle.eu>
From: Fangrui Song <maskray@google.com>
Date: Thu, 8 Feb 2024 13:22:21 -0800
Message-ID: <CAFP8O3L4qM8d9oFCdx4F4FnQ-97aaA_QXgiGm=gGB0HuVdDS4w@mail.gmail.com>
Subject: Re: [PATCH] kbuild: Fix changing ELF file type for output of gen_btf
 for big endian
To: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>, masahiroy@kernel.org, ndesaulniers@google.com, 
	morbo@google.com, justinstitt@google.com, keescook@chromium.org, 
	linux-kbuild@vger.kernel.org, bpf@vger.kernel.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 8, 2024 at 1:11=E2=80=AFPM Nicolas Schier <nicolas@fjasle.eu> w=
rote:
>
> On Thu, Feb 08, 2024 at 01:21:06PM -0700 Nathan Chancellor wrote:
> > Commit 90ceddcb4950 ("bpf: Support llvm-objcopy for vmlinux BTF")
> > changed the ELF type of .btf.vmlinux.bin.o from ET_EXEC to ET_REL via
> > dd, which works fine for little endian platforms:
> >
> >    00000000  7f 45 4c 46 02 01 01 00  00 00 00 00 00 00 00 00  |.ELF...=
.........|
> >   -00000010  03 00 b7 00 01 00 00 00  00 00 00 80 00 80 ff ff  |.......=
.........|
> >   +00000010  01 00 b7 00 01 00 00 00  00 00 00 80 00 80 ff ff  |.......=
.........|
> >
> > However, for big endian platforms, it changes the wrong byte, resulting
> > in an invalid ELF file type, which ld.lld rejects:
> >
> >    00000000  7f 45 4c 46 02 02 01 00  00 00 00 00 00 00 00 00  |.ELF...=
.........|
> >   -00000010  00 03 00 16 00 00 00 01  00 00 00 00 00 10 00 00  |.......=
.........|
> >   +00000010  01 03 00 16 00 00 00 01  00 00 00 00 00 10 00 00  |.......=
.........|
> >
> >   Type:                              <unknown>: 103
> >
> >   ld.lld: error: .btf.vmlinux.bin.o: unknown file type
> >
> > Fix this by using a different seek value for dd when targeting big
> > endian, so that the correct byte gets changed and everything works
> > correctly for all linkers.
> >
> >    00000000  7f 45 4c 46 02 02 01 00  00 00 00 00 00 00 00 00  |.ELF...=
.........|
> >   -00000010  00 03 00 16 00 00 00 01  00 00 00 00 00 10 00 00  |.......=
.........|
> >   +00000010  00 01 00 16 00 00 00 01  00 00 00 00 00 10 00 00  |.......=
.........|
> >
> >   Type:                              REL (Relocatable file)
> >
> > Cc: stable@vger.kernel.org
> > Fixes: 90ceddcb4950 ("bpf: Support llvm-objcopy for vmlinux BTF")
> > Link: https://github.com/llvm/llvm-project/pull/75643
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > ---
> >  scripts/link-vmlinux.sh | 11 +++++++++--
> >  1 file changed, 9 insertions(+), 2 deletions(-)
> >
> > diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> > index a432b171be82..8a9f48b3cb32 100755
> > --- a/scripts/link-vmlinux.sh
> > +++ b/scripts/link-vmlinux.sh
> > @@ -135,8 +135,15 @@ gen_btf()
> >       ${OBJCOPY} --only-section=3D.BTF --set-section-flags .BTF=3Dalloc=
,readonly \
> >               --strip-all ${1} ${2} 2>/dev/null
> >       # Change e_type to ET_REL so that it can be used to link final vm=
linux.
> > -     # Unlike GNU ld, lld does not allow an ET_EXEC input.

From binutils 2.35 onwards, GNU ld also rejects ET_EXEC input. So the
comment can be adjusted.

% file a2
a2: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically
linked, not stripped
% ld.bfd a2 -o a3
ld.bfd: cannot use executable file 'a2' as input to a link

> > -     printf '\1' | dd of=3D${2} conv=3Dnotrunc bs=3D1 seek=3D16 status=
=3Dnone
> > +     # Unlike GNU ld, lld does not allow an ET_EXEC input. Make sure t=
he correct
> > +     # byte gets changed with big endian platforms, otherwise e_type m=
ay be an
> > +     # invalid value.
> > +     if is_enabled CONFIG_CPU_BIG_ENDIAN; then
> > +             seek=3D17
> > +     else
> > +             seek=3D16
> > +     fi
> > +     printf '\1' | dd of=3D${2} conv=3Dnotrunc bs=3D1 seek=3D${seek} s=
tatus=3Dnone
> >  }
> >
> >  # Create ${2} .S file with all symbols from the ${1} object file
> >
> > ---
> > base-commit: 54be6c6c5ae8e0d93a6c4641cb7528eb0b6ba478
> > change-id: 20240208-fix-elf-type-btf-vmlinux-bin-o-big-endian-dbc55a1e1=
296
> >
> > Best regards,
> > --
> > Nathan Chancellor <nathan@kernel.org>
> >
>
> Thanks for the verbose examples!
> Looks good to me.
>
> Reviewed-by: Nicolas Schier <nicolas@fjasle.eu>

Reviewed-by: Fangrui Song <maskray@google.com>


--=20
=E5=AE=8B=E6=96=B9=E7=9D=BF
