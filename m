Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C13E3D71
	for <patches@lists.linux.dev>; Sun, 28 Jan 2024 02:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706410660; cv=none; b=cvlR6coH+g2ipFhJY1vzBtZaTBwzFOMJvroAxVjwagalIdjKkZcXAXvVCVhq4ko91lBPU+z5gacqqrt310QasSRYMaJJblKpXMoyl9LfgaLEN+JDHBd0zGaUn1scCLTbhoo1rNvrzBWF8xHHXqzVV7ZB/VB+q+6UHqX7jRQxrBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706410660; c=relaxed/simple;
	bh=0Ljyz9aN5fI8hdU4LP4IKaxXlOnZcbkEh0t788GhUf8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cfRxWVu+mWDsLxM34sCRkY4YANZipXmWTyhlzr5kHmgVoUDjKgODlclEtzgQC0GoM0v9h331FKWXk6H/LUemHTdz33ZgwQDnDIf5/s060jY6GNl1GUq7JiSYgTjuef1a3iMCTLF9lyHOrX+yFY6izLxTzosV0QhItNbtpRc9+bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=ChbLGzS2; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="ChbLGzS2"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-51030ce36fbso877496e87.3
        for <patches@lists.linux.dev>; Sat, 27 Jan 2024 18:57:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1706410656; x=1707015456; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tUPe8kS/dYQxcvPbyImR2zb7xWJbztZ0Yj4HdTeCp4I=;
        b=ChbLGzS26oj6YQWUpD3i8vvYHcguVvN/nupldtFF8Gfhh5FdzwHdW3wTImcpCRtYE5
         kTKwKmSS2hxP1Zts+EhsjvkvXnqjSRDKyjoDeYVUVn1ecQj6e1J874Lk6wGbphMDfgjK
         HqoxCrNnbdteptLAMXYcXEIpSz27498Td4rfinV1z9WuGu5PcnHL7K4orD5ng6bhN41+
         BqLGWWAI9pD3WvoX0Q6Nzf0VxJOw33yP0Yn4k2edKF44D/SbOmuJ76ed3yrKBzQydHkj
         0zVD33t6crGa5ntuq90ulwLeqdien1GsjPPjzANwYPcyWcKghGcy5kh6DPofM16c3eKR
         Ew+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706410656; x=1707015456;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tUPe8kS/dYQxcvPbyImR2zb7xWJbztZ0Yj4HdTeCp4I=;
        b=A1JaZjpxNdftvFmCeAICqnGqxCYjXdyYF8knVeuGRTgkIbKTZLv+feJazKssoSD7pk
         00vcI9llC86R5I/ZoRV2r/b4ZMkaCSTjcOQ1WNcS2mwNbHAp69jmyZ2XCpwKAFXdjpmL
         H8ID6tL8Ede8r0u02IiVhES6uVFAbui+VAGZtZE3QwiDWCZgzYPiQHgXlqlPT/DuFF9c
         bBBtzQmz2VvpNGdaOHH9vlGr8psziyTb62NLaxMIl/3X/oVV88XcPA93qgN34oeJx/QC
         TW+qsWSOBlC7yE59ghyyvNYZPel8YKNfMukgj8OEwj/uh5wiHTP9QkkFMVildoOWo9mP
         9SlA==
X-Gm-Message-State: AOJu0YwpcnUlDkR+saUVwIRCddnqyf33xvFeQlGg/ePhaFmGQT5WVVYZ
	f5UziC7C4p/o6fTZsuC5oARMiTUg/kycS7Ehl2Utzcib33E732p/1P6GRV5MyxJ/yH502OGR0q5
	lEAhh2VRKZ7A3Vi3eaasArssZuukGOwLkPLXY1w==
X-Google-Smtp-Source: AGHT+IH9hs8nV3EIySrlhWIGxmnGMq22449h+fsNcRpbxaYZsJKDaLHJx2IgCnzvK9tg/L1sdXMDyhVz1NejyYUort8=
X-Received: by 2002:ac2:4893:0:b0:50e:630d:7364 with SMTP id
 x19-20020ac24893000000b0050e630d7364mr1500830lfc.28.1706410655622; Sat, 27
 Jan 2024 18:57:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240125-fix-riscv-option-arch-llvm-18-v1-0-390ac9cc3cd0@kernel.org>
 <20240127090310.GF11935@sol.localdomain>
In-Reply-To: <20240127090310.GF11935@sol.localdomain>
From: Andy Chiu <andy.chiu@sifive.com>
Date: Sun, 28 Jan 2024 10:57:24 +0800
Message-ID: <CABgGipVMv-+AJkGMPzFhimaPCUVATk3gjUDG0P4btRJWtXcMxw@mail.gmail.com>
Subject: Re: [PATCH 0/2] RISC-V: Fix CONFIG_AS_HAS_OPTION_ARCH with tip of
 tree LLVM
To: Eric Biggers <ebiggers@kernel.org>, Nathan Chancellor <nathan@kernel.org>
Cc: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	masahiroy@kernel.org, nicolas@fjasle.eu, conor.dooley@microchip.com, 
	linux-riscv@lists.infradead.org, linux-kbuild@vger.kernel.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 27, 2024 at 5:03=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Thu, Jan 25, 2024 at 10:32:10AM -0700, Nathan Chancellor wrote:
> > Hi all,
> >
> > Eric reported that builds of LLVM with [1] (close to tip of tree) have
> > CONFIG_AS_HAS_OPTION_ARCH=3Dn because the test for expected failure on
> > invalid input has started succeeding.
> >
> > This Kconfig test was added because '.option arch' only causes an
> > assembler warning when it is unsupported, rather than a hard error,
> > which is what users of as-instr expect when something is unsupported.
> >
> > This can be resolved by turning assembler warnings into errors with
> > '-Wa,--fatal-warnings' like we do with the compiler with '-Werror',
> > which is what the first patch does. The second patch removes the invali=
d
> > test, as the valid test is good enough with fatal warnings.
> >
> > I have diffed several configurations for the different architectures
> > that use as-instr and I have found no issues.
> >
> > I think this could go in through either the kbuild or RISC-V tree with
> > sufficient acks but I will let them fight over who takes it :)
> >
> > [1]: https://github.com/llvm/llvm-project/commit/3ac9fe69f70a2b3541266d=
aedbaaa7dc9c007a2a
> >
> > ---
> > Nathan Chancellor (2):
> >       kbuild: Add -Wa,--fatal-warnings to as-instr invocation
> >       RISC-V: Drop invalid test from CONFIG_AS_HAS_OPTION_ARCH
> >
> >  arch/riscv/Kconfig        | 1 -
> >  scripts/Kconfig.include   | 2 +-
> >  scripts/Makefile.compiler | 2 +-
> >  3 files changed, 2 insertions(+), 3 deletions(-)
>
> Looks good,
>
> Tested-by: Eric Biggers <ebiggers@google.com>
>
> Unfortunately another LLVM commit just broke TOOLCHAIN_HAS_VECTOR_CRYPTO,=
 so
> I've sent out a patch to fix that too...
>
> But with all the fixes applied it works again.
>
> - Eric

For this series

Tested-by: Andy Chiu <andybnac@gmail.com>
Reviewed-by: Andy Chiu <andybnac@gmail.com>

Thanks,
Andy
