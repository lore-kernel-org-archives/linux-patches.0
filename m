Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A09184D;
	Sun, 28 Jul 2024 03:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722136418; cv=none; b=JPF0uJUXcwl9VuGgcYWMhdgS55+QigM8YGMLcKshOUymPMLaXo/ED5oQrA8a21j7KuJ0OXQ+N73xpQdAHlFVGxdCxM5YqfAlxtQ0yEVyk+n58INMmgNfqOdPb2BRRLU78Nkj6m+GOiBZTmG5OwMc/44OPkEgirzUEfieGN8m/9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722136418; c=relaxed/simple;
	bh=dxAiWiD2kN5NPOYoa1Wg9mD6ZtfxLFrPDEAvSnCXYvU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YZd9ovaxi0dumc+NzyX7o9lTEpr1d36CDv3xwfjtw3VjR6Gn273cUN+Dy0FEhMSxZQgkF1v7IGzXF7Fk7SPsC/XGSYzvaH/wzNqUlTkLMXim5PPd7ujaOXeO3JXzCAfo/l0BzvSXCJUn9InS6VnWUT/Hjh6JN8Nxdccu3tB/JHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DBkzShEk; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DBkzShEk"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-52efd8807aaso3810953e87.3;
        Sat, 27 Jul 2024 20:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722136415; x=1722741215; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P1a761+r7QAGh3/ol80lxTwi2CiAb1Lq7e0V/KssodI=;
        b=DBkzShEkiYzsrGUJgDyY/ANbffv0dqIJg/oDSe3C4JeVtzNENfoq2u5L4SwN8OhdBS
         DsrBMcD1EtbAET8ACfDiTRi6NkyDGXpP0eNk/R3oGl2LZ433RNENJVvRbzE5X8znD5D+
         ch3pG+kE5uTel5wLbmtHhMry1DxiiraThM0DL9FEb7hV8yj36FVQ0GVwVhuY/e8W//BJ
         pffR/lt4QlJ7lXYQ7AU/fS8TC40hIbYNQ2XkVElESmZUiNQJ5kCy0ewiwkM66mFk7WV1
         T9fx+5qQh5Rxv4K+rMssf0sed1+UKR0PwN2wwbCFONZU54nxHAv+spqMps6qC8bCYTGK
         49/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722136415; x=1722741215;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P1a761+r7QAGh3/ol80lxTwi2CiAb1Lq7e0V/KssodI=;
        b=uX0/3ZhpKsaMzwkHNqpRdYYZ6NX9Z0v9qcMxfFGb7LKJ6wMKqR4xX88zP/2JJtid80
         454M43NwyXjx55AE0g6lCtLLVjP+QSTUB6ElvgYnK0onmgZav1xegXMxmxb0kzbc1IPq
         cwbkrZJbItld9SsLwu1wusjGlnm92c0JuCl/PLcsJh2aTvetIy/XG9rcX5GjXMTiMjis
         E/HqafNi4+KtucjrKG5jEpt3Hhcvwrq0RNRjGCWNqWuard1yMtwDQhRkx+dxpHLXWnw0
         vuyRDqAaz+TC0WSST2o2yRReRwI8Tg+VW2YTHrimzUt9xgt9u5rJ3MuMNYypTc+tI/jM
         jDHA==
X-Forwarded-Encrypted: i=1; AJvYcCVM86UTiai3FVriOaVlt27FR9rvRtInZjP1G1rRiHGc07FCxBl8Eqq/jRgE9Kt7nnu9yumiO2OYKhehDW2vKb/7XYkoWmJCZooA5cp5aa8jLqRugSlfBzMqEQ06fu8=
X-Gm-Message-State: AOJu0YwkmTXUvxf8SGXAskp14TbTqX2f+EgQRXE11jar+i1w6/w4S3Nn
	JBlxF3BNC/SJc/m5xajFCAh+iZKdDTXFMmRnTJUJ2KpXUe4D6abU9Nuze0YxZw3ttUKwhPdaGTJ
	i3IdsFXmjN01OUYB6RfTwpOSxdA==
X-Google-Smtp-Source: AGHT+IHwdJ/GGFwNwHrHqImp87bRmzlbCkmdBesKSKpVIxf1IZOyEMy384mSKBlU42fWO/aAdLYebQartIGMAqBrChM=
X-Received: by 2002:a05:6512:280d:b0:52e:fa98:d89c with SMTP id
 2adb3069b0e04-5309b26ac72mr2697514e87.14.1722136414377; Sat, 27 Jul 2024
 20:13:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240726-fix-x86-stack-protector-tests-v1-1-a30fe80e8925@kernel.org>
 <CAMzpN2hRVzWOF5YDvE8pPKfogdcuou8REsY+uXzkdORnFn=buQ@mail.gmail.com> <CAK7LNARjggcomzGMgHxuYE=Lm0_zsZS5dvjo3g4tjKJaM2oydg@mail.gmail.com>
In-Reply-To: <CAK7LNARjggcomzGMgHxuYE=Lm0_zsZS5dvjo3g4tjKJaM2oydg@mail.gmail.com>
From: Brian Gerst <brgerst@gmail.com>
Date: Sat, 27 Jul 2024 23:13:23 -0400
Message-ID: <CAMzpN2i6_-tiYKuXgq0ppowtfB8JipZvkMLmT8Mn02YE5shC5g@mail.gmail.com>
Subject: Re: [PATCH] kbuild: Fix '-S -c' in x86 stack protector scripts
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, nicolas@fjasle.eu, 
	maskray@google.com, morbo@google.com, justinstitt@google.com, kees@kernel.org, 
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 27, 2024 at 10:36=E2=80=AFPM Masahiro Yamada <masahiroy@kernel.=
org> wrote:
>
> On Sun, Jul 28, 2024 at 5:43=E2=80=AFAM Brian Gerst <brgerst@gmail.com> w=
rote:
> >
> > On Fri, Jul 26, 2024 at 2:05=E2=80=AFPM Nathan Chancellor <nathan@kerne=
l.org> wrote:
> > >
> > > After a recent change in clang to stop consuming all instances of '-S=
'
> > > and '-c' [1], the stack protector scripts break due to the kernel's u=
se
> > > of -Werror=3Dunused-command-line-argument to catch cases where flags =
are
> > > not being properly consumed by the compiler driver:
> > >
> > >   $ echo | clang -o - -x c - -S -c -Werror=3Dunused-command-line-argu=
ment
> > >   clang: error: argument unused during compilation: '-c' [-Werror,-Wu=
nused-command-line-argument]
> > >
> > > This results in CONFIG_STACKPROTECTOR getting disabled because
> > > CONFIG_CC_HAS_SANE_STACKPROTECTOR is no longer set.
> > >
> > > '-c' and '-S' both instruct the compiler to stop at different stages =
of
> > > the pipeline ('-S' after compiling, '-c' after assembling), so having
> > > them present together in the same command makes little sense. In this
> > > case, the test wants to stop before assembling because it is looking =
at
> > > the textual assembly output of the compiler for either '%fs' or '%gs'=
,
> > > so remove '-c' from the list of arguments to resolve the error.
> > >
> > > All versions of GCC continue to work after this change, along with
> > > versions of clang that do or do not contain the change mentioned abov=
e.
> > >
> > > Cc: stable@vger.kernel.org
> > > Fixes: 4f7fd4d7a791 ("[PATCH] Add the -fstack-protector option to the=
 CFLAGS")
> > > Fixes: 60a5317ff0f4 ("x86: implement x86_32 stack protector")
> > > Link: https://github.com/llvm/llvm-project/commit/6461e537815f7fa68ce=
f06842505353cf5600e9c [1]
> > > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > > ---
> > > I think this could go via either -tip or Kbuild?
> > >
> > > Perhaps this is an issue in the clang commit mentioned in the message
> > > above since it deviates from GCC (Fangrui is on CC here) but I think =
the
> > > combination of these options is a little dubious to begin with, hence
> > > this change.
> >
> > As part of my stack protector cleanup series, I found that these
> > scripts can simply be removed.  I can repost those patches as a
> > standalone cleanup.
> >
> > https://lore.kernel.org/lkml/20240322165233.71698-1-brgerst@gmail.com/
> >
> > Brian Gerst
>
> Judging from the Fixes tags, Nathan meant this patch is
> a back-port candidate so that the latest LLVM can be used for stable kern=
els.
>
> You are making big changes, and do you mean they can be back-ported?

I was referring to just the first two patches of that series.  That
said, it would be simpler to take Nathan's fix for backporting.

Brian Gerst
