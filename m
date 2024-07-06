Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C1DDDA1
	for <patches@lists.linux.dev>; Sat,  6 Jul 2024 03:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720236253; cv=none; b=Db30mSY7tLlyRyI0DDRjWp25wcWmTEKrcYRcWV1HdGwcPlsIuDZ0u9Lq4yP1O3PhZjvG/W2QI3IEUsCabLJqCZ11anoE9HygsocdOriPDioA1SD7/lrrtui4cdUNCh90A0ysy2NeiDINj3y4aaUgt9YZ1wioVeXrlhdWwJne1sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720236253; c=relaxed/simple;
	bh=Zf7fegEOz88S+uefNQgGk7kN64iUyK0nqei1SbhANDY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Lic2oFRjqX4fUJvTmQAXDLIwCZwPuHcf/BDtWIro6kM3YuFqXDXJUFCFstskyz1XGwJrTDfu8/BPlTSYR/z2fFwMl5Nc4kmQmzUYXhOLMZ73SnqtWjormIgBE5MkJUkdJHkv6HAvietAf+nZkD2/JeqU743MBU45slNweEeJPHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d6Y1lQdj; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d6Y1lQdj"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-58ce966a1d3so23895a12.1
        for <patches@lists.linux.dev>; Fri, 05 Jul 2024 20:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720236250; x=1720841050; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EeOWn8Dcpi/0Zne7XKezGHMzmpPhwxsGnD8ugnUza50=;
        b=d6Y1lQdji4URgM8MjhuFPxZ6ifzhfxNbYSeFW6GzHLrxT3FdfGu69ue5B3WC5SpSG3
         spHOg2Ws722VPFsm7IlFoHAVKG/VSmhLu6rjvuMYx9jDR6vxLPbrzluYh8BTcPjwbJud
         4iNKzN3+T2TVbN0Ky2JpASaWADhLrhWqcdvRyKJTQXofXyJmEcCLCq2f2zVxnE5qXUq6
         e+mYYP6lZ3zZg+yj/NbW5NZejckOyEuMHPYapVl+ojFZozVLaQ0eiWRb7ouoP7OufHTs
         ZA5oRydZ4TW4zlxD06AeSaCWaTu0BWk8gxl+xRKvh6FLnWtBMAnwkSVZLDuak2Sx/yDs
         ntFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720236250; x=1720841050;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EeOWn8Dcpi/0Zne7XKezGHMzmpPhwxsGnD8ugnUza50=;
        b=seu/2lP07sC69BqloZ1nWkXPh7wrmx30Px8qHAwGHFUbt0byW797Hky7z8Xpx+jw7O
         TfzbEW7SPAbCdIhT074XV6FMwfopvjjVBd/5oYxWD47n8SjsOUVInmcI7Syq+UT1c4nX
         kUEbOdTOS9UJgZEKpREmot1KUPKYl1G6q8hyW5B9ZesU9mHYVxXwgC2HypAMjeUrw6d2
         D+niK8NMQifjNEA5t+tGsis/yNcu4pgQ6lHZlA735iXImOwO1t/fOEhlHVEVTlXH/YcS
         o720Wb2ruvIL2eSRHNRmMcGLw7IcwL4fBsIy9IMQrpf0J4W+LjXB5qtpnzqCt89AngHJ
         r/rA==
X-Forwarded-Encrypted: i=1; AJvYcCXqOJgm7KWPa6P2IKbK0IU5ANJp8DIrbXhBIzr2++WeeMlEOmTW1fwI2JNLjsmJUBCPjm2W3+CXX4AqwRbOdrYZ/N/QCPCPcQ==
X-Gm-Message-State: AOJu0Yw/6obYLDN1Hyx2W4Q5N/OVqNo0/OhtLDJc6ZwtDrXyNHspeO2z
	0XLSurctgHy30fjRpZimINpXEDa+2qXxlGwK6UDg9JpwSzaGMrTypZf4etKmDlTza7ye+OKqv7/
	z5md700X1j1iHwJeESAlPyOVz8Nj3DNT/E9N1
X-Google-Smtp-Source: AGHT+IExJJ+2hSaxJtRHZGJ4Ox4OzW4oFndkiki9VhxYJFTQsxkQqN4Vpb3uXzUPWyQhWCVip8yKpWFGS+CMtG1GfTA=
X-Received: by 2002:a50:8ad3:0:b0:57c:bb0d:5e48 with SMTP id
 4fb4d7f45d1cf-58e00933a13mr316161a12.2.1720236249500; Fri, 05 Jul 2024
 20:24:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240704-update-ld-version-for-new-lld-ver-str-v1-1-91bccc020a93@kernel.org>
 <CAFP8O3JUgH-tBJtqO-QS0HmO4mrFBE6Dz+tnrBcse=gw_Q_4vQ@mail.gmail.com> <20240705160007.GA875035@thelio-3990X>
In-Reply-To: <20240705160007.GA875035@thelio-3990X>
From: Fangrui Song <maskray@google.com>
Date: Fri, 5 Jul 2024 20:23:58 -0700
Message-ID: <CAFP8O3+X4iT1OPoMdTTa_Y1WKjK4f6ownE0tBYZD_a-ngSNufg@mail.gmail.com>
Subject: Re: [PATCH] kbuild: Update ld-version.sh for change in LLD version output
To: Nathan Chancellor <nathan@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, linux-kbuild@vger.kernel.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 5, 2024 at 9:00=E2=80=AFAM Nathan Chancellor <nathan@kernel.org=
> wrote:
>
> On Thu, Jul 04, 2024 at 02:23:46PM -0700, Fangrui Song wrote:
> > On Thu, Jul 4, 2024 at 9:19=E2=80=AFAM Nathan Chancellor <nathan@kernel=
.org> wrote:
> > >
> > > After [1] in upstream LLVM, ld.lld's version output is slightly
> > > different when the cmake configuration option LLVM_APPEND_VC_REV is
> > > disabled.
> > >
> > > Before:
> > >
> > >   Debian LLD 19.0.0 (compatible with GNU linkers)
> > >
> > > After:
> > >
> > >   Debian LLD 19.0.0, compatible with GNU linkers
> > >
> > > This results in ld-version.sh failing with
> > >
> > >   scripts/ld-version.sh: 19: arithmetic expression: expecting EOF: "1=
0000 * 19 + 100 * 0 + 0,"
> > >
> > > because the trailing comma is included in the patch level part of the
> > > expression. Remove the trailing comma when assigning the version
> > > variable in the LLD block to resolve the error, resulting in the prop=
er
> > > output:
> > >
> > >   LLD 190000
> > >
> > > With LLVM_APPEND_VC_REV enabled, there is no issue with the new outpu=
t
> > > because it is treated the same as the prior LLVM_APPEND_VC_REV=3DOFF
> > > version string was.
> > >
> > >   ClangBuiltLinux LLD 19.0.0 (https://github.com/llvm/llvm-project a3=
c5c83273358a85a4e02f5f76379b1a276e7714), compatible with GNU linkers
> > >
> > > Cc: stable@vger.kernel.org
> > > Fixes: 02aff8592204 ("kbuild: check the minimum linker version in Kco=
nfig")
> > > Link: https://github.com/llvm/llvm-project/commit/0f9fbbb63cfcd206944=
1aa2ebef622c9716f8dbb [1]
> > > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > > ---
> > >  scripts/ld-version.sh | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/scripts/ld-version.sh b/scripts/ld-version.sh
> > > index a78b804b680c..f2f425322524 100755
> > > --- a/scripts/ld-version.sh
> > > +++ b/scripts/ld-version.sh
> > > @@ -47,7 +47,9 @@ else
> > >         done
> > >
> > >         if [ "$1" =3D LLD ]; then
> > > -               version=3D$2
> > > +               # LLD after https://github.com/llvm/llvm-project/comm=
it/0f9fbbb63cfcd2069441aa2ebef622c9716f8dbb
> > > +               # may have a trailing comma on the patch version with=
 LLVM_APPEND_VC_REV=3Doff.
> > > +               version=3D${2%,}
> > >                 min_version=3D$($min_tool_version llvm)
> > >                 name=3DLLD
> > >                 disp_name=3DLLD
> > >
> > > ---
> > > base-commit: 22a40d14b572deb80c0648557f4bd502d7e83826
> > > change-id: 20240704-update-ld-version-for-new-lld-ver-str-b7a4afbbd5f=
1
> > >
> > > Best regards,
> > > --
> > > Nathan Chancellor <nathan@kernel.org>
> > >
> >
> > Thanks for catching the issue.
> > If we want to minimize the number of special cases, perhaps we can
> > adjust `version=3D${version%-*}` below to
> >
> > version=3D${version%%[^0-9.]*}
>
> Thanks for the suggestion! I think this wants to be
>
>   version=3D${version%%[!0-9.]*}
>
> because of "If an open bracket introduces a bracket expression as in XBD
> RE Bracket Expression, except that the <exclamation-mark> character
> ('!') shall replace the <circumflex> character ('^') in its role in a
> non-matching list in the regular expression notation, it shall introduce
> a pattern bracket expression." from the link that you have below.

Yes! ! should be used instead.

> That does work for me with all the different linker versions that I can
> easily access (Arch, Debian, Fedora) along with my own self built
> toolchains, so it seems like it should be pretty robust.
>
> Masahiro, would you be okay with me sending a v2 with that change or do
> you foresee any issues where it would not be sufficient? I would
> probably change the comment to:
>
>   # There may be something after the version, such as a distribution's
>   # package release number (2.34-4.fc32) or a comma (like LLD adds
>   # before the "compatible with GNU linkers" string), so remove anything
>   # that is not a number or a period.

The v2 change LGTM :)

Reviewed-by: Fangrui Song <maskray@google.com>

> > (POSIX shell doc:
> > https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.ht=
ml#:~:text=3DRemove%20Largest)
> >
> > ${version%%[^0-9.]*} is a simpler form than what glibc uses:
> >
> >   "LLD"*)
> >   # Accept LLD 13.0.0 or higher
> >     AC_CHECK_PROG_VER(LD, $LD, --version,
> >                     [LLD.* \([0-9][0-9]*\.[0-9.]*\)],
> >                     [1[3-9].*|[2-9][0-9].*],
>
> Cheers,
> Nathan
>


--=20
=E5=AE=8B=E6=96=B9=E7=9D=BF
