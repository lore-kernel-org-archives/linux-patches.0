Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72831C697;
	Sat,  6 Jul 2024 05:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720242526; cv=none; b=En0LFulQOSsZnTIzLYfoWRJKaYcTg6ZqFPIxkHub/3HoM+pocsxmegVo6XLRq8ofptlVFrnJspZQ+tXPUasG2/Nqo6w4/mwAw36ZaMCX4dVUPvm+AtQ3q+ykpaNcq3piilhbGoxSZJIapNRwk4xJAfsrtOlL5nY4L0Blzgmh8zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720242526; c=relaxed/simple;
	bh=zgH/M+SgbCYYqLZrK1bBrCCIYhVHv7m7Hl5FLTrI+hk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jD0few8/vYEOqZyJC/DsVdXodNMDdgqcYSmDnO36A+jN/wGl+wBPiX2raSJxPClFSwpqfCcyG/UYxlGZZJs2KLkPTRu5JinhbE58i37dFFbmEzLR4DnS7pKhJt6jHAmIKu/rapq6yMfSRZxeGsNr8u946V2D1ds2DCRdVmxJ4jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QIqknfjk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QIqknfjk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FCC7C4AF0B;
	Sat,  6 Jul 2024 05:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720242526;
	bh=zgH/M+SgbCYYqLZrK1bBrCCIYhVHv7m7Hl5FLTrI+hk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=QIqknfjkSVtVSg4NGQtVdVWogDKObZsuaYOD5cn8HJn8+Up0LAPHXMd9WqqQeZb8T
	 y53MtNI6QMXnEC5VHvMfGtit2C+ajG3NnezI6ezOxkH8jlNbUpzn3Tcj/kir8iyfPS
	 DtYER5wnKIs3b1tridciDTh1XzuBK2r8rIFNtgl1fz4iB0uyweusLPLauZIl95Q6fI
	 rxnfl+kLq8B2w61l9M2+HnNmqDZyWLMi31RKQd7jyhzad+21ipuvCZ1OyEozh475m/
	 1qxQ7j4npgQHea0zBoMihUhZG27t4tOZq64aN2RxXjc6caljLhzkO21Q415cvwumow
	 xinYVOCH1+LNg==
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2ebec2f11b7so26565861fa.2;
        Fri, 05 Jul 2024 22:08:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV5tMk4x1XuNUbv1F2sKwdLUY2uYdkFsXj8mHsjsZCX1mocHyOUwGV7RGzEGK6sRVgQ7GgD5/mPzPTLorbJhi5wyQsxPMt+rbHyMZPTXNj/JOBJ0IkF3RCOQbRSBdw=
X-Gm-Message-State: AOJu0YxCI2O5e6NpwGaaJLSiSBkkR+RqlV9w1tQT81NWjqyLMyM9uJwD
	wtupbOgQDMIdg6YmD/yU403IR7Tnp51hz8BVmp87N4NvrrCdyjI0Kz7d+FvbOGzXGgSUPJxVlrU
	OTzJd/RNowgMpW8NPhgcyO6Hn3cM=
X-Google-Smtp-Source: AGHT+IF+bjFqkKo1FutL799t8aduhDZQ1qJi+ES9lDEid9QJoTyI2zeh9MzBBODHsCwO1mRhS/8SE6THWmTW6Vvqlig=
X-Received: by 2002:a19:ac45:0:b0:52d:b1c9:34e with SMTP id
 2adb3069b0e04-52ea062e361mr4144684e87.21.1720242525092; Fri, 05 Jul 2024
 22:08:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240704-update-ld-version-for-new-lld-ver-str-v1-1-91bccc020a93@kernel.org>
 <CAFP8O3JUgH-tBJtqO-QS0HmO4mrFBE6Dz+tnrBcse=gw_Q_4vQ@mail.gmail.com> <20240705160007.GA875035@thelio-3990X>
In-Reply-To: <20240705160007.GA875035@thelio-3990X>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Sat, 6 Jul 2024 14:08:08 +0900
X-Gmail-Original-Message-ID: <CAK7LNASjHQVJoZVR6G6HUgoyFyS87-o0RZVQSO3XZgbxMWCLCQ@mail.gmail.com>
Message-ID: <CAK7LNASjHQVJoZVR6G6HUgoyFyS87-o0RZVQSO3XZgbxMWCLCQ@mail.gmail.com>
Subject: Re: [PATCH] kbuild: Update ld-version.sh for change in LLD version output
To: Nathan Chancellor <nathan@kernel.org>
Cc: Fangrui Song <maskray@google.com>, Nicolas Schier <nicolas@fjasle.eu>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, linux-kbuild@vger.kernel.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 6, 2024 at 1:00=E2=80=AFAM Nathan Chancellor <nathan@kernel.org=
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
>
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



Thanks. V2 seems much cleaner.







--=20
Best Regards
Masahiro Yamada
