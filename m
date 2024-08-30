Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBFE1C1ADF
	for <patches@lists.linux.dev>; Fri, 30 Aug 2024 22:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725057364; cv=none; b=uDVOjGyj71v4l4SefX/B/fLTBbrxrpdpMNt6oV9WOrltATBRl4RQ4aC0ljEuG5xNHFC2fF/mOZXZY8EqjNBr6pe8RmPm7OEElnzgP9FKCkJF4Q5uUKpWSP7yc3u98F4Z7A2YJCOLxxLj4TPwCGmSdy8zxUTuvLKZ2W2Qua+4Qsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725057364; c=relaxed/simple;
	bh=Jki3kHjC/pOqeEQuN+kE4Utk1Wf3dQ8w9hFoRm2Bb3s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EyGimrWfqciOlld9MtVTZtJ+r66PnhmLfhYFCFA35LvcHB8BePkH4qmXtGFAZLxn9CPXT1O5OQmixucOCutFErAkhkE55SE0RFjiVAS+CYEWlrOCh3spVHV6bqADTfUClLeoUZ24DL5jLT/tg2UbRR0ZpltGfH28NXLGSxQumzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s+axT/lu; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s+axT/lu"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4567fe32141so62041cf.0
        for <patches@lists.linux.dev>; Fri, 30 Aug 2024 15:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725057359; x=1725662159; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5BcN5bnCyZPtNp7WzKEseneLacj7nnrZE1HJU2+SHPU=;
        b=s+axT/luDSU+3sifTJSjtTyAcQOzH50cczX/RpI/8v4w6DmeMBeoag9P+GXiGJQEwN
         g2NirDlsfDE1tSO8KQ9DOia9vYNBaOvvgrRbtK9b0y7jUf50LQr53+Y8BTWaYKQ881u1
         HR29UX4QQ7iVwILhKN/dCqDbQ+02Vq7UsU6WzZqkMVf5ROFlgQLXzuYSZOsDNiqIsvJ6
         c6srCxVdYYNHgWf06msiJa7Y91za8sQO9uV15BCWEkyIefcW1SGiFYlbSMQIO+GWx0Z1
         NppPUsRmEbCZW7Pe/tu4T/WIHxlWoA3z+gd5KygKElQw8ulGWBFftiBZg7Yhh2V6Ou+T
         HqYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725057359; x=1725662159;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5BcN5bnCyZPtNp7WzKEseneLacj7nnrZE1HJU2+SHPU=;
        b=BhZsQ8z0ZxSpZjLnlzdJqrPOewtEQPznB/1MHQRQkf7vgZa+Q9Xi4AOLB5qMX0Ij+D
         A4yssEcZVl0ueYGDugr7TdPrYkp+Ol6ljmZ+UKncZJwopnEu0SqMOwm5bOkfRnAm+qZp
         +MFFpc0pNj00fCS2fFUvho9/yNzVWfaSub952A0OLeVvEItGwP58oIinn9+81/UpreiA
         rwLBdNCQmd/IEBDOhoGOTNcQO897aQYIyj0YD06KiGqapHcApUSJZMJRGO89roLhWY7A
         iHOmF9S5558kIdktC3rNzvAGgeeQWHy8YTqjPzOEL20X8Wffh3jaMTCzGfySLqsirpet
         +cow==
X-Forwarded-Encrypted: i=1; AJvYcCX3MOhcAeOAvxnC8E7S0iwIuSpeEvxDE/7i3c3LJUNpcVtbrjKaaN08unII+G7gdg40PiCZhz7T@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8yJv4rQOx6oG2n9uAPYX3FquFQZfg+Ip0XJ820FMvKgFqIYrK
	XuuNsbc3BjeDD4KGVm9GV5553Q8XbiQev6ADWrJVLeKpe49AHW05Y4ZyhKkiUUAhI1dMjXdq23N
	B1Tm37SNmef0t8X+i4VJFEvj+7qJCLQ+wi8VG
X-Google-Smtp-Source: AGHT+IFoSd8Mos6kY4XwhJyU0nOOLYz6b0y62Ml/7arp+4o+ejjewCSIGzaBDACK8YRr0nUuPSo/97aq7MVgfhtIGjM=
X-Received: by 2002:a05:622a:14ca:b0:453:62ee:3fe with SMTP id
 d75a77b69052e-457c420cb80mr428781cf.17.1725057358621; Fri, 30 Aug 2024
 15:35:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240827143843.399359062@linuxfoundation.org> <20240827143852.163123189@linuxfoundation.org>
 <20240830221217.GA3837758@thelio-3990X>
In-Reply-To: <20240830221217.GA3837758@thelio-3990X>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 30 Aug 2024 15:35:35 -0700
Message-ID: <CAJuCfpGuOtzSshL6U+rT2ytZr2MBAH5yWAqMJd3hLDzHyZV3JA@mail.gmail.com>
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

On Fri, Aug 30, 2024 at 3:12=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> Hi Greg and Sasha,
>
> On Tue, Aug 27, 2024 at 04:37:41PM +0200, Greg Kroah-Hartman wrote:
> > 6.6-stable review patch.  If anyone has any objections, please let me k=
now.
> >
> > ------------------
> >
> > From: Suren Baghdasaryan <surenb@google.com>
> >
> > [ Upstream commit 8a2f11878771da65b8ac135c73b47dae13afbd62 ]
> >
> > After redefining alloc_pages, all uses of that name are being replaced.
> > Change the conflicting names to prevent preprocessor from replacing the=
m
> > when it's not intended.
> >
> > Link: https://lkml.kernel.org/r/20240321163705.3067592-18-surenb@google=
.com
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > Tested-by: Kees Cook <keescook@chromium.org>
> > Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> > Cc: Alex Gaynor <alex.gaynor@gmail.com>
> > Cc: Alice Ryhl <aliceryhl@google.com>
> > Cc: Andreas Hindborg <a.hindborg@samsung.com>
> > Cc: Benno Lossin <benno.lossin@proton.me>
> > Cc: "Bj=C3=B6rn Roy Baron" <bjorn3_gh@protonmail.com>
> > Cc: Boqun Feng <boqun.feng@gmail.com>
> > Cc: Christoph Lameter <cl@linux.com>
> > Cc: Dennis Zhou <dennis@kernel.org>
> > Cc: Gary Guo <gary@garyguo.net>
> > Cc: Kent Overstreet <kent.overstreet@linux.dev>
> > Cc: Miguel Ojeda <ojeda@kernel.org>
> > Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Vlastimil Babka <vbabka@suse.cz>
> > Cc: Wedson Almeida Filho <wedsonaf@gmail.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Stable-dep-of: 61ebe5a747da ("mm/vmalloc: fix page mapping if vm_area_a=
lloc_pages() with high order fallback to order 0")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  arch/alpha/kernel/pci_iommu.c           | 2 +-
> >  arch/mips/jazz/jazzdma.c                | 2 +-
> >  arch/powerpc/kernel/dma-iommu.c         | 2 +-
> >  arch/powerpc/platforms/ps3/system-bus.c | 4 ++--
> >  arch/powerpc/platforms/pseries/vio.c    | 2 +-
> >  arch/x86/kernel/amd_gart_64.c           | 2 +-
> >  drivers/iommu/dma-iommu.c               | 2 +-
> >  drivers/parisc/ccio-dma.c               | 2 +-
> >  drivers/parisc/sba_iommu.c              | 2 +-
> >  drivers/xen/grant-dma-ops.c             | 2 +-
> >  drivers/xen/swiotlb-xen.c               | 2 +-
> >  include/linux/dma-map-ops.h             | 2 +-
> >  kernel/dma/mapping.c                    | 4 ++--
> >  13 files changed, 15 insertions(+), 15 deletions(-)
>
> This patch breaks the build for s390:
>
> arch/s390/pci/pci_dma.c:724:10: error: 'const struct dma_map_ops' has no =
member named 'alloc_pages'; did you mean 'alloc_pages_op'?
>   724 |         .alloc_pages    =3D dma_common_alloc_pages,
>       |          ^~~~~~~~~~~
>       |          alloc_pages_op
>
> https://storage.tuxsuite.com/public/clangbuiltlinux/continuous-integratio=
n2/builds/2lNUl0tacZpSlu9Edrlk3QoSElM/build.log
>
> This change happened after commit c76c067e488c ("s390/pci: Use dma-iommu
> layer") in mainline, which explains how it was missed for stable.
>
> The fix seems simple:
>
> diff --git a/arch/s390/pci/pci_dma.c b/arch/s390/pci/pci_dma.c
> index 99209085c75b..ce0f2990cb04 100644
> --- a/arch/s390/pci/pci_dma.c
> +++ b/arch/s390/pci/pci_dma.c
> @@ -721,7 +721,7 @@ const struct dma_map_ops s390_pci_dma_ops =3D {
>         .unmap_page     =3D s390_dma_unmap_pages,
>         .mmap           =3D dma_common_mmap,
>         .get_sgtable    =3D dma_common_get_sgtable,
> -       .alloc_pages    =3D dma_common_alloc_pages,
> +       .alloc_pages_op =3D dma_common_alloc_pages,
>         .free_pages     =3D dma_common_free_pages,
>         /* dma_supported is unconditionally true without a callback */
>  };
>
> but I think the better question is why this patch is even needed in the
> first place? It claims that it is a stable dependency of 61ebe5a747da
> but this patch does not even touch mm/vmalloc.c and 61ebe5a747da does
> not mention or touch anything with alloc_pages_op, so it seems like this
> change should just be reverted from 6.6?

Hmm, Nathan is right. I don't see any dependency between this patch
and 61ebe5a747da. Maybe some other patch that uses .alloc_pages_op got
backported and that caused a dependency but then that other patch
should be changed to use .alloc_pages. I'm syncing stable 6.6 to
check. Thanks for pointing this out Nathan!


>
> Cheers,
> Nathan
