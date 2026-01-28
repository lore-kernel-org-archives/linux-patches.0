Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540A8328B78
	for <patches@lists.linux.dev>; Wed, 28 Jan 2026 20:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769632620; cv=none; b=BZkYsNbVmSstNXjAGsQIEo3rOhbrlRZJ90PQjk7QXXeIN7i1Ti0lW2zmuJP+qiQ5G2huWyXNDeQlTUuD5TVJgdsFFDv4oUgcG1QJsulXWBDaNp2fPUNlBSnNmEGC8p9sWyMBnYBSBl3fUsY+9gCb3/T5I+2riuu3WBfONNJoTd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769632620; c=relaxed/simple;
	bh=KJYEAdU+kHx97V7CXyWkDRfONvbdw4a+tdv0QncuI7g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SyCsqjo4/7o+3M5VF5ev8IOkrRcWNmphIgiiU2jtg0dQFT5PDU4pj5OwhuGLq+9fUd8ZMWQCbLKVfBzZaYLZiIWDhOELE8EnIRqA/R4M6ILqPfRjVMr4npIZi/XzX5S7D2Wkc4iQjILsouocSLsgh1rrUTVhVgC3pvTXFkC0J1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fw/r+Bp5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fw/r+Bp5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3445C4CEF1
	for <patches@lists.linux.dev>; Wed, 28 Jan 2026 20:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769632620;
	bh=KJYEAdU+kHx97V7CXyWkDRfONvbdw4a+tdv0QncuI7g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=fw/r+Bp59gCtwUHejInTp6d8z+jo3+i0yymhW1XZaAXSv4RONm/OxNmjnmFfQUuIT
	 A+lsA4V6U4MvcliHL7I5FreQw5kRj/SWZ6Rrli/5dIKkFk3f5UQ9ML4VZuzS0ame0/
	 n236m0Z0x9edC5cv5nH4yiy8byM3HtlFwCJWMN1ohKNkT8/BdwctzmqOSd4pJd5vXv
	 nUMNWBIg/Pv7kIlmkFfYU1pzadx7IeZIbJ2nBTOaaieaJGlyqPEyKqNIq2+uzGa6Tq
	 cquTggp5NcD/W0/YDJIRMCUN9RqGT/DvfkCPBlKz/kndOhh/TvkbERJUIRmVWo9tt+
	 bugJImdwNHYcQ==
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-662f2fa7e67so101287eaf.1
        for <patches@lists.linux.dev>; Wed, 28 Jan 2026 12:36:59 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCU1QzC07S9UVXlf9iENsJiEvGomgro8uQZmdwOorVRnkfvS1vtJs5BRvb3K4AW//2e9dM+AsU8t@lists.linux.dev
X-Gm-Message-State: AOJu0Ywv9mr7u+WCGnLli3eFcAggX+7NXeHb2B7DfzsxI7sZV3CiDqzt
	TTpO4kcUo+wIvuSVBZl7Aug++BLAvYODNHtnTSsP2m6DObBHpEIfk/bq/bu+saTY13Np20gZNt/
	aA/unQ2j7h4r0nn4DpeM9qeWqIjGqGd8=
X-Received: by 2002:a05:6820:80c7:b0:662:bc9a:91c6 with SMTP id
 006d021491bc7-662f20435acmr3692656eaf.22.1769632619038; Wed, 28 Jan 2026
 12:36:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260114-ghes-avoid-wflt-clang-older-than-18-v1-1-9c8248bfe4f4@kernel.org>
 <CAJZ5v0ju+7U10_nuQMijadeFrVxUWQFYJfUyRvga9qEPdK50_Q@mail.gmail.com> <20260127214711.GA3382807@ax162>
In-Reply-To: <20260127214711.GA3382807@ax162>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Wed, 28 Jan 2026 21:36:48 +0100
X-Gmail-Original-Message-ID: <CAJZ5v0g1mx=ASYAVwxOxVHG8Bx0H8HyXt1PT3dcXJrg=WcpLhA@mail.gmail.com>
X-Gm-Features: AZwV_Qh1U15hps-Avsd1ANLbxEbDXc2lJ961elNZQhk0i28PcdKN2Svifb6RoMo
Message-ID: <CAJZ5v0g1mx=ASYAVwxOxVHG8Bx0H8HyXt1PT3dcXJrg=WcpLhA@mail.gmail.com>
Subject: Re: [PATCH] ACPI: APEI: GHES: Disable KASAN instrumentation when
 compile testing with clang < 18
To: Nathan Chancellor <nathan@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Tony Luck <tony.luck@intel.com>, 
	Borislav Petkov <bp@alien8.de>, Hanjun Guo <guohanjun@huawei.com>, 
	Mauro Carvalho Chehab <mchehab@kernel.org>, Shuai Xue <xueshuai@linux.alibaba.com>, 
	Len Brown <lenb@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, linux-acpi@vger.kernel.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 27, 2026 at 10:47=E2=80=AFPM Nathan Chancellor <nathan@kernel.o=
rg> wrote:
>
> On Tue, Jan 27, 2026 at 03:37:58PM +0100, Rafael J. Wysocki wrote:
> > On Thu, Jan 15, 2026 at 12:27=E2=80=AFAM Nathan Chancellor <nathan@kern=
el.org> wrote:
> > >
> > > After a recent innocuous change to drivers/acpi/apei/ghes.c, building
> > > ARCH=3Darm64 allmodconfig with clang-17 or older (which has both
> > > CONFIG_KASAN=3Dy and CONFIG_WERROR=3Dy) fails with:
> > >
> > >   drivers/acpi/apei/ghes.c:902:13: error: stack frame size (2768) exc=
eeds limit (2048) in 'ghes_do_proc' [-Werror,-Wframe-larger-than]
> > >     902 | static void ghes_do_proc(struct ghes *ghes,
> > >         |             ^
> > >
> > > A KASAN pass that removes unneeded stack instrumentation, enabled by
> > > default in clang-18 [1], drastically improves stack usage in this cas=
e.
> > >
> > > To avoid the warning in the common allmodconfig case when it can brea=
k
> > > the build, disable KASAN for ghes.o when compile testing with clang-1=
7
> > > and older. Disabling KASAN outright may hide legitimate runtime issue=
s,
> > > so live with the warning in that case; the user can either increase t=
he
> > > frame warning limit or disable -Werror, which they should probably do
> > > when debugging with KASAN anyways.
> > >
> > > Closes: https://github.com/ClangBuiltLinux/linux/issues/2148
> > > Link: https://github.com/llvm/llvm-project/commit/51fbab134560ece6635=
17bf1e8c2a30300d08f1a [1]
> > > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > > ---
> > >  drivers/acpi/apei/Makefile | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > >
> > > diff --git a/drivers/acpi/apei/Makefile b/drivers/acpi/apei/Makefile
> > > index 2c474e6477e1..346cdf0a0ef9 100644
> > > --- a/drivers/acpi/apei/Makefile
> > > +++ b/drivers/acpi/apei/Makefile
> > > @@ -1,6 +1,10 @@
> > >  # SPDX-License-Identifier: GPL-2.0
> > >  obj-$(CONFIG_ACPI_APEI)                +=3D apei.o
> > >  obj-$(CONFIG_ACPI_APEI_GHES)   +=3D ghes.o
> > > +# clang versions prior to 18 may blow out the stack with KASAN
> > > +ifeq ($(CONFIG_COMPILE_TEST)_$(CONFIG_CC_IS_CLANG)_$(call clang-min-=
version, 180000),y_y_)
> > > +KASAN_SANITIZE_ghes.o :=3D n
> > > +endif
> > >  obj-$(CONFIG_ACPI_APEI_EINJ)   +=3D einj.o
> > >  einj-y                         :=3D einj-core.o
> > >  einj-$(CONFIG_ACPI_APEI_EINJ_CXL) +=3D einj-cxl.o
> > >
> > > ---
> >
> > I'm inclined to apply this for 6.20/7.0 unless someone has any
> > particular heartburn related to it.
>
> I think taking it for next cycle is fine, I can just apply this to our
> CI until it makes its way to Linus. Could you stick a
>
>   Cc: stable@vger.kernel.org
>
> on the patch in that case so that it can go back to 6.18 after the
> initial flurry of the merge window?

Applied with a Cc: stable tag, thanks!
