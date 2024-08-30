Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8A017C9F1
	for <patches@lists.linux.dev>; Fri, 30 Aug 2024 22:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725058134; cv=none; b=WJO5wJz+FhX3Y+nhH5OPNH8vz/JViJyB70hRDnQsHbbiLss6b9X4tlf3xJHPetBL37TnQDWgMET1qK1ffy0T066EnTecO9W7SXZMalKWqWGSfCJsCvlb1OySy/PKkR1iRzLSgm2FAL8KgC+eiLoHFHaGqiSqLMwSecIeUeO1lP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725058134; c=relaxed/simple;
	bh=vQSHT5Cx85f6cSUyggBt/S75C/KCzPjVHtXsoW2XU6M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h7U7bXV8kNV9iZ+73Oj+Cm6INGtGjTbXU2Idwxx9KAcNGSxZvgeL3ubwQvNRF47N+mb4wqXbF2B4mmCY7Y0lAEt95i//JDxrQumXvrwHnnJOif6edRlDCyzw2nhPej/KqYYMV6zfdZBnmZMRF9Pw9bxg5HhRWc0MEYw8qIaHe9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XI+nKCDf; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XI+nKCDf"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-456871a4d8fso50341cf.0
        for <patches@lists.linux.dev>; Fri, 30 Aug 2024 15:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725058131; x=1725662931; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5yf5qwNlK9KJHYQLjEH/sJ7OAWoMrkf4Md9wGz0SP8U=;
        b=XI+nKCDfO//GNelXyLRhzRhpFD9j61b94KnDzVq5/FAu5Kr2LdWbDj+FVzShXQOYF1
         xibpGnX5ZnoXwFqmLAjhKwWImUgxPQBDtGTW5EQWAtwpbnYN5Kjqj5hQz9IVUVSrLUD9
         hvrXqN7zCzLRuHG9GT7u1kdMiu/1oxNcdeALjdASJO1WsC9JAms3wGgSY3a2E8N3SxGy
         7GrO2G8iIHIQWGpsFNVDWNx5hDlzs4cBPzzPu0Ic3tVFtANYx74RWC4oM2naYsEX5vu0
         2Hruivz/2oy2OcrNtH0Oyt+8Dzgm/pMCy1wxX6mtGaC6tUYsu5lRCTr5WEPpg5jiVcco
         mg0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725058131; x=1725662931;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5yf5qwNlK9KJHYQLjEH/sJ7OAWoMrkf4Md9wGz0SP8U=;
        b=SKILozujmazCa7yiZ5zkFYJuiAtp1YA7tSjaqkyyPDuxm0aunOpbqdHjqB3RUq7qN5
         10rX6AY95y2QVHzFEfi9ysQLt6B35r85sLUW2F3/zX1mHmg1ewDYNu/qTUzb4CTT9+CV
         Yf5vh/KYtMkiOqmlLRkzry8ugZ8VgU0v7+icOUGlvOlVcyIg6NfdiO9pazLaRTYhaxmF
         1JpxXHTeV4xEuIBZim1ACL8T/xRTYO1646rSqJhdkr8ElXHZM/ImnuC3kR+13ELkq7Um
         jeqLx5SpBFo+aU28kRSUPvd6/q/B5tKhxJRcMar3lCfckNR5odBAIy5N/p+dM5XYuxJs
         HfuQ==
X-Forwarded-Encrypted: i=1; AJvYcCUAjt1QEl/eNZCJtbaP8ayZeukUBi+4Ok9qhMKBFYG4InUf5laW8b8kQTZQIOBbl7iCmxAsvGN9@lists.linux.dev
X-Gm-Message-State: AOJu0YzVIv4uDo06Y4QsZIPRHCtNtY0H2toAViU2E2kUZLY7ogD7nnn3
	w+59q9gPrz0I9dG4EfnWVSkExKwet6zq1/f/0U9egCPlY57y1DQ2ZdSED1QTjhQfBsVsE+BqnFT
	oM7Jonm5338hCF0mnc/3kMlXKBtsruekOhMRO
X-Google-Smtp-Source: AGHT+IEH0ch3vYzwxiqoEQU2QupdS+7G5yKuK+OBElSv+sgjfGmViu6CX4mUvnJeQthmaBnw7sp1UOMNu7zBe6bZMHA=
X-Received: by 2002:ac8:7c49:0:b0:447:f108:f80e with SMTP id
 d75a77b69052e-4573b34d5e3mr1194791cf.16.1725058131225; Fri, 30 Aug 2024
 15:48:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240827143843.399359062@linuxfoundation.org> <20240827143852.163123189@linuxfoundation.org>
 <20240830221217.GA3837758@thelio-3990X> <CAJuCfpGuOtzSshL6U+rT2ytZr2MBAH5yWAqMJd3hLDzHyZV3JA@mail.gmail.com>
In-Reply-To: <CAJuCfpGuOtzSshL6U+rT2ytZr2MBAH5yWAqMJd3hLDzHyZV3JA@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 30 Aug 2024 15:48:40 -0700
Message-ID: <CAJuCfpEmrPG6e+tv6t=v-r7TmOenCtKK73xrtaeMQ+brZDE2wA@mail.gmail.com>
Subject: Re: [PATCH 6.6 230/341] change alloc_pages name in dma_map_ops to
 avoid name conflicts
To: Nathan Chancellor <nathan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, 
	stable@vger.kernel.org, patches@lists.linux.dev, 
	Kees Cook <keescook@chromium.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Alice Ryhl <aliceryhl@google.com>, 
	Andreas Hindborg <a.hindborg@samsung.com>, Benno Lossin <benno.lossin@proton.me>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Christoph Lameter <cl@linux.com>, Dennis Zhou <dennis@kernel.org>, 
	Gary Guo <gary@garyguo.net>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Miguel Ojeda <ojeda@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 30, 2024 at 3:35=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Fri, Aug 30, 2024 at 3:12=E2=80=AFPM Nathan Chancellor <nathan@kernel.=
org> wrote:
> >
> > Hi Greg and Sasha,
> >
> > On Tue, Aug 27, 2024 at 04:37:41PM +0200, Greg Kroah-Hartman wrote:
> > > 6.6-stable review patch.  If anyone has any objections, please let me=
 know.
> > >
> > > ------------------
> > >
> > > From: Suren Baghdasaryan <surenb@google.com>
> > >
> > > [ Upstream commit 8a2f11878771da65b8ac135c73b47dae13afbd62 ]
> > >
> > > After redefining alloc_pages, all uses of that name are being replace=
d.
> > > Change the conflicting names to prevent preprocessor from replacing t=
hem
> > > when it's not intended.
> > >
> > > Link: https://lkml.kernel.org/r/20240321163705.3067592-18-surenb@goog=
le.com
> > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > Tested-by: Kees Cook <keescook@chromium.org>
> > > Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> > > Cc: Alex Gaynor <alex.gaynor@gmail.com>
> > > Cc: Alice Ryhl <aliceryhl@google.com>
> > > Cc: Andreas Hindborg <a.hindborg@samsung.com>
> > > Cc: Benno Lossin <benno.lossin@proton.me>
> > > Cc: "Bj=C3=B6rn Roy Baron" <bjorn3_gh@protonmail.com>
> > > Cc: Boqun Feng <boqun.feng@gmail.com>
> > > Cc: Christoph Lameter <cl@linux.com>
> > > Cc: Dennis Zhou <dennis@kernel.org>
> > > Cc: Gary Guo <gary@garyguo.net>
> > > Cc: Kent Overstreet <kent.overstreet@linux.dev>
> > > Cc: Miguel Ojeda <ojeda@kernel.org>
> > > Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
> > > Cc: Peter Zijlstra <peterz@infradead.org>
> > > Cc: Tejun Heo <tj@kernel.org>
> > > Cc: Vlastimil Babka <vbabka@suse.cz>
> > > Cc: Wedson Almeida Filho <wedsonaf@gmail.com>
> > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > Stable-dep-of: 61ebe5a747da ("mm/vmalloc: fix page mapping if vm_area=
_alloc_pages() with high order fallback to order 0")
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >  arch/alpha/kernel/pci_iommu.c           | 2 +-
> > >  arch/mips/jazz/jazzdma.c                | 2 +-
> > >  arch/powerpc/kernel/dma-iommu.c         | 2 +-
> > >  arch/powerpc/platforms/ps3/system-bus.c | 4 ++--
> > >  arch/powerpc/platforms/pseries/vio.c    | 2 +-
> > >  arch/x86/kernel/amd_gart_64.c           | 2 +-
> > >  drivers/iommu/dma-iommu.c               | 2 +-
> > >  drivers/parisc/ccio-dma.c               | 2 +-
> > >  drivers/parisc/sba_iommu.c              | 2 +-
> > >  drivers/xen/grant-dma-ops.c             | 2 +-
> > >  drivers/xen/swiotlb-xen.c               | 2 +-
> > >  include/linux/dma-map-ops.h             | 2 +-
> > >  kernel/dma/mapping.c                    | 4 ++--
> > >  13 files changed, 15 insertions(+), 15 deletions(-)
> >
> > This patch breaks the build for s390:
> >
> > arch/s390/pci/pci_dma.c:724:10: error: 'const struct dma_map_ops' has n=
o member named 'alloc_pages'; did you mean 'alloc_pages_op'?
> >   724 |         .alloc_pages    =3D dma_common_alloc_pages,
> >       |          ^~~~~~~~~~~
> >       |          alloc_pages_op
> >
> > https://storage.tuxsuite.com/public/clangbuiltlinux/continuous-integrat=
ion2/builds/2lNUl0tacZpSlu9Edrlk3QoSElM/build.log
> >
> > This change happened after commit c76c067e488c ("s390/pci: Use dma-iomm=
u
> > layer") in mainline, which explains how it was missed for stable.
> >
> > The fix seems simple:
> >
> > diff --git a/arch/s390/pci/pci_dma.c b/arch/s390/pci/pci_dma.c
> > index 99209085c75b..ce0f2990cb04 100644
> > --- a/arch/s390/pci/pci_dma.c
> > +++ b/arch/s390/pci/pci_dma.c
> > @@ -721,7 +721,7 @@ const struct dma_map_ops s390_pci_dma_ops =3D {
> >         .unmap_page     =3D s390_dma_unmap_pages,
> >         .mmap           =3D dma_common_mmap,
> >         .get_sgtable    =3D dma_common_get_sgtable,
> > -       .alloc_pages    =3D dma_common_alloc_pages,
> > +       .alloc_pages_op =3D dma_common_alloc_pages,
> >         .free_pages     =3D dma_common_free_pages,
> >         /* dma_supported is unconditionally true without a callback */
> >  };
> >
> > but I think the better question is why this patch is even needed in the
> > first place? It claims that it is a stable dependency of 61ebe5a747da
> > but this patch does not even touch mm/vmalloc.c and 61ebe5a747da does
> > not mention or touch anything with alloc_pages_op, so it seems like thi=
s
> > change should just be reverted from 6.6?
>
> Hmm, Nathan is right. I don't see any dependency between this patch
> and 61ebe5a747da. Maybe some other patch that uses .alloc_pages_op got
> backported and that caused a dependency but then that other patch
> should be changed to use .alloc_pages. I'm syncing stable 6.6 to
> check. Thanks for pointing this out Nathan!

I reverted this patch in stable 6.6 and there is no code using
alloc_pages_op. We should just drop this patch
(983e6b2636f0099dbac1874c9e885bbe1cf2df05) from stable 6.6. Sorry for
not noticing this in the first place.
Thanks,
Suren.

>
>
> >
> > Cheers,
> > Nathan
