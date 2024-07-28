Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661068F77;
	Sun, 28 Jul 2024 07:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722151266; cv=none; b=az3Sj/s3DBUk3HI9vjY2NBF8utrVPoId8SVstbjzXDb1llaadu4+4cRrMVNFaKO+2d0Hkdj/iGbdfzXTC6xvOp3857oX+SGHRIMibUc0+LQZ4CkIBZaEG6ezGfvrM9Yce+HtStC2D2BDHyFeE2Waugd4LkA26p7p2JaMKTngaSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722151266; c=relaxed/simple;
	bh=GG5jFH9fLcS8G24YwDi2MBNErZaorWB+Mf6iZebzfCg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UvP8XYlHOK0Q256ZUebn7Z616jtSsd9alWg02iR1wcHTftA+3UrbbQScOvB5dsF08WpNzV1azwMxigcutFwKjX5dj2WJYJjj5S2slq6xA2UR5UFVrTYCQWnWMWrLB88htZO2Ryu6EgdSQnwIy7gsw0GN8Y3VAaSZzK42dg0A+WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GNFKmuQ4; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GNFKmuQ4"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-52efdf02d13so3932356e87.2;
        Sun, 28 Jul 2024 00:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722151262; x=1722756062; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p4zxJCQGItJM4cJnL8e4bqJxqyn3oTDAKU3y3PFgwvo=;
        b=GNFKmuQ4MxWVRYhfH4+eym7vdFJNK06QpgDMachsggqfPfiMi1x1A/IPtkK7+ZIhVS
         qwiUAVO9I3F2JhIaiO6AV1QWBucc/2cxhjg6+kLgghqMiKQzeC6VOK0QHXqQz9WC3S1z
         aXRVcmnKK+rVmz8dZJ4ht7qN/GxYRp2/O7ll5MsDoou13ehlKqBqTIuW99QsBDeY/76P
         Vr8aeSwKHYyh3E+sHHVpUtJro8RR5x4LAPujwSn6hV7gwszlWJNRyt/+FYW/qxEcoDR8
         j8CtuGWLxJHZOCSHt6tTUr6Y0vbWtSgXyLyzHPB27zi2MzMSiDiwqwqIeubPT2hfwhR5
         9nsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722151262; x=1722756062;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p4zxJCQGItJM4cJnL8e4bqJxqyn3oTDAKU3y3PFgwvo=;
        b=PKNMbuBt0aoakGCqIudluLAE9riHGC/mvvvLbUrR7eZUGGC8CE4myyi7KBbaZT2+XA
         xVxUKUClWLUSAyigKfrQn8uB2jYEKm1vmSNGaOA3IzcSz+hGqNymtPN3+a+R3IcRH6m2
         SRjcNDvClmnc7RNa235x7NX/9Zu1p27wDfvBeDQwRNMVa4y5CJNS/5V9M1zekwZfAdmO
         hAL1tTF/CMuU0/KYcXpCbHGrqoc0kMZzV/zH+HjvihQQEw2gXRwlvxHGaCK2ujluM7EC
         uZ6KEUUC2tmrejk0BfS1w6kl75urIh8IS7qYOpi2tf/5c0jppqxIedp5cwvhvG57FXMW
         Wznw==
X-Forwarded-Encrypted: i=1; AJvYcCXyYcS2Cfd3qR+sCQUg/ElvXDxTBPMpLTXS01dDP4zBJfv4cxaiFYvy6hh4TS4f1hWbwO8i7u1R9Pq+TJokkR//db8bAWYie71QjB1qpvarrRGv6ma0stC3isP+8Uw=
X-Gm-Message-State: AOJu0Yx0EjDCPODisug4wXAyeH2BQclkpT2WrzEVNomtdYxlivbLFneH
	hlD/LfhfFR3fpNJcb6i5URkzaolAotz/p0iRp1rf0zs/MJ7ENKRq33k+kQAXsjxKTpWeE5AC1hE
	M1kDHprek7g4axzkBmB4reTyN4A==
X-Google-Smtp-Source: AGHT+IE3KZlyMjLAe5MDRiJ4zEfUTV2a7YgnW8Wfv+fDZR89gbai9KqCjOPG0O2c7Dd4ZVvhaLaqM/KPOJ60tRdSeL8=
X-Received: by 2002:a05:6512:2c0f:b0:52c:deea:57cb with SMTP id
 2adb3069b0e04-5309b269215mr3547186e87.3.1722151262076; Sun, 28 Jul 2024
 00:21:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240726-fix-x86-stack-protector-tests-v1-1-a30fe80e8925@kernel.org>
 <CAMzpN2hRVzWOF5YDvE8pPKfogdcuou8REsY+uXzkdORnFn=buQ@mail.gmail.com>
 <CAK7LNARjggcomzGMgHxuYE=Lm0_zsZS5dvjo3g4tjKJaM2oydg@mail.gmail.com>
 <CAMzpN2i6_-tiYKuXgq0ppowtfB8JipZvkMLmT8Mn02YE5shC5g@mail.gmail.com> <CAK7LNAQiL=swKikuquFW9BrTftxNGHkwhLZVqQq3oNTYByEDxA@mail.gmail.com>
In-Reply-To: <CAK7LNAQiL=swKikuquFW9BrTftxNGHkwhLZVqQq3oNTYByEDxA@mail.gmail.com>
From: Brian Gerst <brgerst@gmail.com>
Date: Sun, 28 Jul 2024 03:20:50 -0400
Message-ID: <CAMzpN2iXMtzvyvwjLHMDz2DR-Me8exU_DtQpfO3MJS5BzTnJfg@mail.gmail.com>
Subject: Re: [PATCH] kbuild: Fix '-S -c' in x86 stack protector scripts
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, nicolas@fjasle.eu, 
	maskray@google.com, morbo@google.com, justinstitt@google.com, kees@kernel.org, 
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 28, 2024 at 2:24=E2=80=AFAM Masahiro Yamada <masahiroy@kernel.o=
rg> wrote:
>
> On Sun, Jul 28, 2024 at 12:13=E2=80=AFPM Brian Gerst <brgerst@gmail.com> =
wrote:
> >
> > On Sat, Jul 27, 2024 at 10:36=E2=80=AFPM Masahiro Yamada <masahiroy@ker=
nel.org> wrote:
> > >
> > > On Sun, Jul 28, 2024 at 5:43=E2=80=AFAM Brian Gerst <brgerst@gmail.co=
m> wrote:
> > > >
> > > > On Fri, Jul 26, 2024 at 2:05=E2=80=AFPM Nathan Chancellor <nathan@k=
ernel.org> wrote:
> > > > >
> > > > > After a recent change in clang to stop consuming all instances of=
 '-S'
> > > > > and '-c' [1], the stack protector scripts break due to the kernel=
's use
> > > > > of -Werror=3Dunused-command-line-argument to catch cases where fl=
ags are
> > > > > not being properly consumed by the compiler driver:
> > > > >
> > > > >   $ echo | clang -o - -x c - -S -c -Werror=3Dunused-command-line-=
argument
> > > > >   clang: error: argument unused during compilation: '-c' [-Werror=
,-Wunused-command-line-argument]
> > > > >
> > > > > This results in CONFIG_STACKPROTECTOR getting disabled because
> > > > > CONFIG_CC_HAS_SANE_STACKPROTECTOR is no longer set.
> > > > >
> > > > > '-c' and '-S' both instruct the compiler to stop at different sta=
ges of
> > > > > the pipeline ('-S' after compiling, '-c' after assembling), so ha=
ving
> > > > > them present together in the same command makes little sense. In =
this
> > > > > case, the test wants to stop before assembling because it is look=
ing at
> > > > > the textual assembly output of the compiler for either '%fs' or '=
%gs',
> > > > > so remove '-c' from the list of arguments to resolve the error.
> > > > >
> > > > > All versions of GCC continue to work after this change, along wit=
h
> > > > > versions of clang that do or do not contain the change mentioned =
above.
> > > > >
> > > > > Cc: stable@vger.kernel.org
> > > > > Fixes: 4f7fd4d7a791 ("[PATCH] Add the -fstack-protector option to=
 the CFLAGS")
> > > > > Fixes: 60a5317ff0f4 ("x86: implement x86_32 stack protector")
> > > > > Link: https://github.com/llvm/llvm-project/commit/6461e537815f7fa=
68cef06842505353cf5600e9c [1]
> > > > > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > > > > ---
> > > > > I think this could go via either -tip or Kbuild?
> > > > >
> > > > > Perhaps this is an issue in the clang commit mentioned in the mes=
sage
> > > > > above since it deviates from GCC (Fangrui is on CC here) but I th=
ink the
> > > > > combination of these options is a little dubious to begin with, h=
ence
> > > > > this change.
> > > >
> > > > As part of my stack protector cleanup series, I found that these
> > > > scripts can simply be removed.  I can repost those patches as a
> > > > standalone cleanup.
> > > >
> > > > https://lore.kernel.org/lkml/20240322165233.71698-1-brgerst@gmail.c=
om/
> > > >
> > > > Brian Gerst
> > >
> > > Judging from the Fixes tags, Nathan meant this patch is
> > > a back-port candidate so that the latest LLVM can be used for stable =
kernels.
> > >
> > > You are making big changes, and do you mean they can be back-ported?
> >
> > I was referring to just the first two patches of that series.  That
> > said, it would be simpler to take Nathan's fix for backporting.
>
>
>
> Even the first two patches are not trivial.
>
> The second patch 02/16:
> https://lore.kernel.org/lkml/20240322165233.71698-3-brgerst@gmail.com/
>
> is completely removing scripts/gcc-x86_64-has-stack-protector.sh,
>
>
> In fact, I also noticed it was a workaround for old buggy compilers.
> I attempted to do the equivalent clean up, then it was rejected.
> https://lore.kernel.org/lkml/1541992013-18657-1-git-send-email-yamada.mas=
ahiro@socionext.com/
>
> It was 6 years ago, so the situation might have changed.
> Good luck.

It's a workaround for an old buggy compiler that isn't even supported
by the kernel anymore.

Brian Gerst
>
>
>
>
>
>
>
> --
> Best Regards
> Masahiro Yamada
