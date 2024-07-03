Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BEF13958C
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 08:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719994345; cv=none; b=sgEUoQG6bTtNbSFlisFlhaE2iqlRp5BQsip8BepHwU2xXx8cTexHObfJLL51/3ebQcpz/pJhiqb9ikr8B2/m5SHFvlDaJ/lglB0tr5AQgXLAOd6RgPfJqQXZW51BgYOPbybKlve70PBU2jtOEXRDu91F56lornBm/dOSsXuo+j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719994345; c=relaxed/simple;
	bh=urfNG6+cHLdQJrrRl7mWdBtS/y3l6Djk40r2tdEqB2g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=irApCzKN51kchGuCvHWErTS82na0VwofoXarPmp2Mf46Nrk4eoTc8EY1MhBj+kyS2frD6eDfbLm+AVUoqBmGwWdN/LYMQEuAgLc70F++maj4WLbW13lgAyo/DXopakkFgqvwmi8hwURdkiXeHIQFktuNsAJyHjSRu60Ap4UyG7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nM+JfZGK; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nM+JfZGK"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-36796bbf687so40533f8f.0
        for <patches@lists.linux.dev>; Wed, 03 Jul 2024 01:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719994340; x=1720599140; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EYZQ6hvzbyuQ9dkJY/vs/6RIOJzsf5Qm2425goUaxvE=;
        b=nM+JfZGKNhYZ2T0gcpLO6KNVdXC1GGJFSR57k4WO+va0K9KevosLQHC73OsqYUQeZy
         ioHEnjmcj2qDlvyiUhsi/Ae2j/l5JXMWt17v1k8CU+8ON1J+4SQ8I87/Z/vSoW8YfmTJ
         rjP1hAnbMWTIVSe7KL4z5WbqGOxAd9ivA2lIxsreV5fWbBxnOltOK0yz8e/u4iGg4Ryx
         +yMdipgQHnaTBQf2I7zr99c+gWavNAXcpGCLKgDRt/FuwYkKpQ1PJN9zV5USl9aNUWnV
         Q0rvSpPDUSHjf9s9/oXVaNyvNuN8T6/eLwjuCzKYlYmhDw0F90LDGdtiHbVKkQbQhnjs
         g6Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719994340; x=1720599140;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EYZQ6hvzbyuQ9dkJY/vs/6RIOJzsf5Qm2425goUaxvE=;
        b=RGprXLfDik1C7N9t9g+4qteLV8QmHoPHSRYLfqkIyxTQJMQJ8B86rc5rcc/UXHvxve
         QCOVgU7twaZ6JyNBh2h/yFY/k0KQ/eHx1emt0YGyTLPl5ZZHyzDyg07lX8O9jFFYtu/Y
         eSa9+BchDQdus09PLVkkA7ZFO/DXjgJPBPT+nKNyUiMeNtqfbX0TNTzNc99Qpb2EjWSa
         +h99tAwGJ1k6vfJ4b3aZpKa6rQ8s54/O2TJnrVHOngXkXzHoBfOOhfGNp5PsMuaHyaWx
         fEMxiStuJ03/brl1v3sEc1S8lhNyCyPD5V97WUxu+8f7d8I4ArHcQu38YE8nbZA57lIk
         KYnw==
X-Forwarded-Encrypted: i=1; AJvYcCWgGvbAbUzyHwGy+g6ZbU95U7FgrW5qnQLlOpTHCzg2KftZpOWEGRdKLokxvMLJKlKkxlmdLO/IVFYdV9wZbtn1ekRuBzjGrg==
X-Gm-Message-State: AOJu0YzQece4XH2jLDijSX0HOBzmwst40BzAfTm7fHXwewaK0EGhuDfV
	44Ip3xd1d2do7Qx37f4LzMLMhGHOQHHwo1XbVcgaWZ9Elgi911m1pQWe/z3pFffQ7w8ie7gRp9q
	lLdge/jAHA/chZ57dEKpPeXj2bLgUFaW7qqrC
X-Google-Smtp-Source: AGHT+IEICDH5BfKPspvMCdmvkvvtMFo63HbRNY8nyE4K1FX/Ysrh7tFANjRp15gsI9lcNyfLPvRWNd79Gsa/BRnUtVg=
X-Received: by 2002:adf:f510:0:b0:35f:2366:12c5 with SMTP id
 ffacd0b85a97d-367756aade1mr7017890f8f.23.1719994339769; Wed, 03 Jul 2024
 01:12:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240703072520.45837-2-vbabka@suse.cz>
In-Reply-To: <20240703072520.45837-2-vbabka@suse.cz>
From: Alice Ryhl <aliceryhl@google.com>
Date: Wed, 3 Jul 2024 10:12:07 +0200
Message-ID: <CAH5fLgj9HKT2NsuR6pL6y9aARtkJ26KGkyWHQ2Rzw3baC0onDQ@mail.gmail.com>
Subject: Re: [PATCH v2] slab, rust: extend kmalloc() alignment guarantees to
 remove Rust padding
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, David Rientjes <rientjes@google.com>, 
	Christoph Lameter <cl@linux.com>, Hyeonggon Yoo <42.hyeyoo@gmail.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Kees Cook <keescook@chromium.org>, 
	Boqun Feng <boqun.feng@gmail.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 3, 2024 at 9:25=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wro=
te:
>
> Slab allocators have been guaranteeing natural alignment for
> power-of-two sizes since commit 59bb47985c1d ("mm, sl[aou]b: guarantee
> natural alignment for kmalloc(power-of-two)"), while any other sizes are
> guaranteed to be aligned only to ARCH_KMALLOC_MINALIGN bytes (although
> in practice are aligned more than that in non-debug scenarios).
>
> Rust's allocator API specifies size and alignment per allocation, which
> have to satisfy the following rules, per Alice Ryhl [1]:
>
>   1. The alignment is a power of two.
>   2. The size is non-zero.
>   3. When you round up the size to the next multiple of the alignment,
>      then it must not overflow the signed type isize / ssize_t.
>
> In order to map this to kmalloc()'s guarantees, some requested
> allocation sizes have to be padded to the next power-of-two size [2].
> For example, an allocation of size 96 and alignment of 32 will be padded
> to an allocation of size 128, because the existing kmalloc-96 bucket
> doesn't guarantee alignent above ARCH_KMALLOC_MINALIGN. Without slab
> debugging active, the layout of the kmalloc-96 slabs however naturally
> align the objects to 32 bytes, so extending the size to 128 bytes is
> wasteful.
>
> To improve the situation we can extend the kmalloc() alignment
> guarantees in a way that
>
> 1) doesn't change the current slab layout (and thus does not increase
>    internal fragmentation) when slab debugging is not active
> 2) reduces waste in the Rust allocator use case
> 3) is a superset of the current guarantee for power-of-two sizes.
>
> The extended guarantee is that alignment is at least the largest
> power-of-two divisor of the requested size. For power-of-two sizes the
> largest divisor is the size itself, but let's keep this case documented
> separately for clarity.
>
> For current kmalloc size buckets, it means kmalloc-96 will guarantee
> alignment of 32 bytes and kmalloc-196 will guarantee 64 bytes.
>
> This covers the rules 1 and 2 above of Rust's API as long as the size is
> a multiple of the alignment. The Rust layer should now only need to
> round up the size to the next multiple if it isn't, while enforcing the
> rule 3.
>
> Implementation-wise, this changes the alignment calculation in
> create_boot_cache(). While at it also do the calulation only for caches
> with the SLAB_KMALLOC flag, because the function is also used to create
> the initial kmem_cache and kmem_cache_node caches, where no alignment
> guarantee is necessary.
>
> In the Rust allocator's krealloc_aligned(), remove the code that padded
> sizes to the next power of two (suggested by Alice Ryhl) as it's no
> longer necessary with the new guarantees.
>
> Reported-by: Alice Ryhl <aliceryhl@google.com>
> Reported-by: Boqun Feng <boqun.feng@gmail.com>
> Link: https://lore.kernel.org/all/CAH5fLggjrbdUuT-H-5vbQfMazjRDpp2%2Bk3%3=
DYhPyS17ezEqxwcw@mail.gmail.com/ [1]
> Link: https://lore.kernel.org/all/CAH5fLghsZRemYUwVvhk77o6y1foqnCeDzW4WZv=
6ScEWna2+_jw@mail.gmail.com/ [2]
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
> Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

> ---
> v2: - add Rust side change as suggested by Alice, also thanks Boqun for f=
ixups
> - clarify that the alignment already existed (unless debugging) but was
>   not guaranteed, so there's no extra fragmentation in slab
> - add r-b, a-b thanks tO Boqun and Roman
>
> If it's fine with Rust folks, I can put this in the slab.git tree.
>
>  Documentation/core-api/memory-allocation.rst |  6 ++++--
>  include/linux/slab.h                         |  3 ++-
>  mm/slab_common.c                             |  9 +++++----
>  rust/kernel/alloc/allocator.rs               | 19 ++++++-------------
>  4 files changed, 17 insertions(+), 20 deletions(-)
>
> diff --git a/Documentation/core-api/memory-allocation.rst b/Documentation=
/core-api/memory-allocation.rst
> index 1c58d883b273..8b84eb4bdae7 100644
> --- a/Documentation/core-api/memory-allocation.rst
> +++ b/Documentation/core-api/memory-allocation.rst
> @@ -144,8 +144,10 @@ configuration, but it is a good practice to use `kma=
lloc` for objects
>  smaller than page size.
>
>  The address of a chunk allocated with `kmalloc` is aligned to at least
> -ARCH_KMALLOC_MINALIGN bytes.  For sizes which are a power of two, the
> -alignment is also guaranteed to be at least the respective size.
> +ARCH_KMALLOC_MINALIGN bytes. For sizes which are a power of two, the
> +alignment is also guaranteed to be at least the respective size. For oth=
er
> +sizes, the alignment is guaranteed to be at least the largest power-of-t=
wo
> +divisor of the size.
>
>  Chunks allocated with kmalloc() can be resized with krealloc(). Similarl=
y
>  to kmalloc_array(): a helper for resizing arrays is provided in the form=
 of
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index ed6bee5ec2b6..640cea6e6323 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -604,7 +604,8 @@ void *__kmalloc_large_node_noprof(size_t size, gfp_t =
flags, int node)
>   *
>   * The allocated object address is aligned to at least ARCH_KMALLOC_MINA=
LIGN
>   * bytes. For @size of power of two bytes, the alignment is also guarant=
eed
> - * to be at least to the size.
> + * to be at least to the size. For other sizes, the alignment is guarant=
eed to
> + * be at least the largest power-of-two divisor of @size.
>   *
>   * The @flags argument may be one of the GFP flags defined at
>   * include/linux/gfp_types.h and described at
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 1560a1546bb1..7272ef7bc55f 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -617,11 +617,12 @@ void __init create_boot_cache(struct kmem_cache *s,=
 const char *name,
>         s->size =3D s->object_size =3D size;
>
>         /*
> -        * For power of two sizes, guarantee natural alignment for kmallo=
c
> -        * caches, regardless of SL*B debugging options.
> +        * kmalloc caches guarantee alignment of at least the largest
> +        * power-of-two divisor of the size. For power-of-two sizes,
> +        * it is the size itself.
>          */
> -       if (is_power_of_2(size))
> -               align =3D max(align, size);
> +       if (flags & SLAB_KMALLOC)
> +               align =3D max(align, 1U << (ffs(size) - 1));
>         s->align =3D calculate_alignment(flags, align, size);
>
>  #ifdef CONFIG_HARDENED_USERCOPY
> diff --git a/rust/kernel/alloc/allocator.rs b/rust/kernel/alloc/allocator=
.rs
> index 229642960cd1..e6ea601f38c6 100644
> --- a/rust/kernel/alloc/allocator.rs
> +++ b/rust/kernel/alloc/allocator.rs
> @@ -18,23 +18,16 @@ pub(crate) unsafe fn krealloc_aligned(ptr: *mut u8, n=
ew_layout: Layout, flags: F
>      // Customized layouts from `Layout::from_size_align()` can have size=
 < align, so pad first.
>      let layout =3D new_layout.pad_to_align();
>
> -    let mut size =3D layout.size();
> -
> -    if layout.align() > bindings::ARCH_SLAB_MINALIGN {
> -        // The alignment requirement exceeds the slab guarantee, thus tr=
y to enlarge the size
> -        // to use the "power-of-two" size/alignment guarantee (see comme=
nts in `kmalloc()` for
> -        // more information).
> -        //
> -        // Note that `layout.size()` (after padding) is guaranteed to be=
 a multiple of
> -        // `layout.align()`, so `next_power_of_two` gives enough alignme=
nt guarantee.
> -        size =3D size.next_power_of_two();
> -    }
> +    // Note that `layout.size()` (after padding) is guaranteed to be a m=
ultiple of `layout.align()`
> +    // which together with the slab guarantees means the `krealloc` will=
 return a properly aligned
> +    // object (see comments in `kmalloc()` for more information).
> +    let size =3D layout.size();

The size is a multiple of the alignment due to the `pad_to_align` call
above, which rounds up the size to ensure that this is the case.

Alice
