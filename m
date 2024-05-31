Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1D6824BD
	for <patches@lists.linux.dev>; Fri, 31 May 2024 23:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717196813; cv=none; b=GgK/ukSmwXlPEzG2l8LqIKqkFKcvFFiZda8YA38BxJG3sgsERkvK3hEpOyoYuxzUj/SDH0tUlpmW//+kzW6T7QKIvTzegNiE1x6rbv2suez4ddvvchtjiV43VmLThvdeRW2+GUxsqChTwcWGtY8EO18ju68hfSKAo7cYUqiSCNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717196813; c=relaxed/simple;
	bh=5P7SqAWOzhMiqoDFx3QmiBn7DYJTmsrcDYi6rn1x67U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j66hdBNNN2rVGGH2W/yJ9uboh83GmjQevyBYrQ5+jbfIB4ylWR6sa7duAf8I6F3dAjkWAN+8mM6qM0RgPxyzUiEm27y0DGucylSPniHeLl/GyfaYwkC9HwrRu46xsikRm6zKH/Gu+uPf7e424rN5xaSosQFbcNh7iS2dakzBxBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20230601.gappssmtp.com header.i=@amacapital-net.20230601.gappssmtp.com header.b=WbT2iKKC; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20230601.gappssmtp.com header.i=@amacapital-net.20230601.gappssmtp.com header.b="WbT2iKKC"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a6302bdb54aso318882166b.0
        for <patches@lists.linux.dev>; Fri, 31 May 2024 16:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20230601.gappssmtp.com; s=20230601; t=1717196810; x=1717801610; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eyHLaILVYS3X8bT62V44NUMw4Rtb28b6MzSGdES42nM=;
        b=WbT2iKKC7Wt7NYTUqKH6hy5/rtEE2zPpTR2MIy9j+BLvqUKxUpLoHHozrN2iRjOCOG
         j9ar6lUvceyPEM1foCA335ZGu3aE6NfQwfHmb8WVzbznq/fzQz+ykiRNgSXCI6H1vF8h
         +72w5zJxKFaIY1Cs+N/OOVkl8KbPmdUYkI8fiMT173bDN2Xmmn5bKffYV0k3s0ELWAPG
         YFw8kRla8h3lhZXbIuE3RDIXVPXhnIINNg5zx3i5iXm80rC7KFqt6EVjVWikPy9nFlTH
         cVxLH9fELN3WKZEqZJQmSwfHBEocrX0fHXPC5Jk3dT+4MpinkkGzAfs9N5j5f5Q4tQlD
         UCcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717196810; x=1717801610;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eyHLaILVYS3X8bT62V44NUMw4Rtb28b6MzSGdES42nM=;
        b=Pc2yOGHwzmSUJ6KMV0AL4y+t1KKHvx90/oKm+d64E3XlDqdNKW8ijhmGdEV0RziPd9
         PQ/nrPe6V70zewlvzPywwCtGkTEjQdrING2qd0thVjy+G2RXyjFGRxMvhQC1UhL2xJmj
         XW1RNf33yW0j6iEQ8+FUHLmj2R/OCzp092Pu9Gtl64gHswAkpD3geTKZXq964DqNLX57
         5T/YcIJfsRCoYjmPYN36sQQq11c9ggynmczR9tcNx3ydZaQKPk5d1FX1T4VkrKZ3p0Nw
         9YpYzPpV3y2Dq70HcsrOnlfiT2rNv8vIPCbp3Bn11WfNBYfVj22UkLG7Xf8TViDgKZar
         d03Q==
X-Forwarded-Encrypted: i=1; AJvYcCX9TQQIrDmlt5x+aNgdXW37WR1+dcU0a6cWy4WpNsKq2MjjSkjQaEmjtrU2myJvpF0BiZcD1jJj0xnkez6ZXHK4earq8a63vw==
X-Gm-Message-State: AOJu0YzIgrOQ3BslFR7oUUyELKE7oP5k7I7+h94NnXAGEL7WCefo2zEm
	QBQLNCqtecMgk6Ka3FqBnviKSOQXr7HB96FhWvEnA0ONEbjiXz+oOTJkLgorg+U4y7ICsjsZ6nR
	ihAsOTcU5wGFfjzI2UVh5KsjwJOYB9QZT1TiD
X-Google-Smtp-Source: AGHT+IEOlR34bXuxQqGt2PFNT5TRWY3/+xwI26oviRFffNo6Dmsc8TmF/2kOV72l7b/SwPzHbmJnmQyullweIjU1Qtc=
X-Received: by 2002:a17:906:a050:b0:a66:4cf6:b9c with SMTP id
 a640c23a62f3a-a6820be9310mr200072666b.45.1717196809795; Fri, 31 May 2024
 16:06:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240528122352.2485958-1-Jason@zx2c4.com> <20240528122352.2485958-5-Jason@zx2c4.com>
In-Reply-To: <20240528122352.2485958-5-Jason@zx2c4.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 31 May 2024 16:06:37 -0700
Message-ID: <CALCETrUgPwVsMwkxkCyuqBKyqouyejikxxyGuBDxnWWKskYG8A@mail.gmail.com>
Subject: Re: [PATCH v16 4/5] random: introduce generic vDSO getrandom() implementation
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, tglx@linutronix.de, 
	linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <dhildenb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> On May 28, 2024, at 5:25=E2=80=AFAM, Jason A. Donenfeld <Jason@zx2c4.com>=
 wrote:
>
> =EF=BB=BFProvide a generic C vDSO getrandom() implementation, which opera=
tes on
> an opaque state returned by vgetrandom_alloc() and produces random bytes
> the same way as getrandom(). This has a the API signature:
>
>  ssize_t vgetrandom(void *buffer, size_t len, unsigned int flags, void *o=
paque_state);

> +/**
> + * type vdso_kernel_ulong - unsigned long type that matches kernel's uns=
igned long
> + *
> + * Data shared between userspace and the kernel must operate the same wa=
y in both 64-bit code and in
> + * 32-bit compat code, over the same potentially 64-bit kernel. This typ=
e represents the size of an
> + * unsigned long as used by kernel code. This isn't necessarily the same=
 as an unsigned long as used
> + * by userspace, however.

Why is this better than using plain u64?  It=E2=80=99s certainly more
complicated. It also rather fundamentally breaks CRIU on 32-bit
userspace (although CRIU may well be unable to keep vgetrandom working
after a restore onto a different kernel anyway).  Admittedly 32-bit
userspace is a slowly dying breed, but still.

> + *
> + *                 +-------------------+-------------------+------------=
------+-------------------+
> + *                 | 32-bit userspace  | 32-bit userspace  | 64-bit user=
space | 64-bit userspace  |
> + *                 | unsigned long     | vdso_kernel_ulong | unsigned lo=
ng    | vdso_kernel_ulong |
> + * +---------------+-------------------+-------------------+------------=
------+-------------------+
> + * | 32-bit kernel | =E2=9C=93 same size       | =E2=9C=93 same size    =
   |
> + * | unsigned long |                   |                   |
> + * +---------------+-------------------+-------------------+------------=
------+-------------------+
> + * | 64-bit kernel | =E2=9C=98 different size! | =E2=9C=93 same size    =
   | =E2=9C=93 same size      | =E2=9C=93 same size       |
> + * | unsigned long |                   |                   |            =
      |                   |
> + * +---------------+-------------------+-------------------+------------=
------+-------------------+
> + */
> +#ifdef CONFIG_64BIT
> +typedef u64 vdso_kernel_ulong;
> +#else
> +typedef u32 vdso_kernel_ulong;
> +#endif
> +
> +#endif /* __VDSO_TYPES_H */
> diff --git a/lib/vdso/getrandom.c b/lib/vdso/getrandom.c
> new file mode 100644
> index 000000000000..4d9bb59985f8
> --- /dev/null
> +++ b/lib/vdso/getrandom.c
> @@ -0,0 +1,226 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2022 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights R=
eserved.
> + */
> +
> +#include <linux/cache.h>
> +#include <linux/kernel.h>
> +#include <linux/time64.h>
> +#include <vdso/datapage.h>
> +#include <vdso/getrandom.h>
> +#include <asm/vdso/getrandom.h>
> +#include <asm/vdso/vsyscall.h>
> +
> +#define MEMCPY_AND_ZERO_SRC(type, dst, src, len) do {                \
> +    while (len >=3D sizeof(type)) {                        \
> +        __put_unaligned_t(type, __get_unaligned_t(type, src), dst);    \
> +        __put_unaligned_t(type, 0, src);                \
> +        dst +=3D sizeof(type);                        \
> +        src +=3D sizeof(type);                        \
> +        len -=3D sizeof(type);                        \
> +    }                                    \
> +} while (0)
> +
> +static void memcpy_and_zero_src(void *dst, void *src, size_t len)
> +{
> +    if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)) {
> +        if (IS_ENABLED(CONFIG_64BIT))
> +            MEMCPY_AND_ZERO_SRC(u64, dst, src, len);
> +        MEMCPY_AND_ZERO_SRC(u32, dst, src, len);
> +        MEMCPY_AND_ZERO_SRC(u16, dst, src, len);
> +    }
> +    MEMCPY_AND_ZERO_SRC(u8, dst, src, len);
> +}
> +
> +/**
> + * __cvdso_getrandom_data - Generic vDSO implementation of getrandom() s=
yscall.
> + * @rng_info:        Describes state of kernel RNG, memory shared with k=
ernel.
> + * @buffer:        Destination buffer to fill with random bytes.
> + * @len:        Size of @buffer in bytes.
> + * @flags:        Zero or more GRND_* flags.
> + * @opaque_state:    Pointer to an opaque state area.
> + *
> + * This implements a "fast key erasure" RNG using ChaCha20, in the same =
way that the kernel's
> + * getrandom() syscall does. It periodically reseeds its key from the ke=
rnel's RNG, at the same
> + * schedule that the kernel's RNG is reseeded. If the kernel's RNG is no=
t ready, then this always
> + * calls into the syscall.
> + *
> + * @opaque_state *must* be allocated using the vgetrandom_alloc() syscal=
l.  Unless external locking
> + * is used, one state must be allocated per thread, as it is not safe to=
 call this function
> + * concurrently with the same @opaque_state. However, it is safe to call=
 this using the same
> + * @opaque_state that is shared between main code and signal handling co=
de, within the same thread.
> + *
> + * Returns the number of random bytes written to @buffer, or a negative =
value indicating an error.
> + */
> +static __always_inline ssize_t
> +__cvdso_getrandom_data(const struct vdso_rng_data *rng_info, void *buffe=
r, size_t len,
> +               unsigned int flags, void *opaque_state)

I don=E2=80=99t love this function signature. I generally think that, if
you=E2=80=99re going to have user code pass a pointer to kernel code, eithe=
r
make the buffer have a well defined, constant size or pass a length.
As it stands, one cannot locally prove that user code that calls it is
memory-safe. In fact, any caller that has the misfortune of running
under CRIU is *not* memory safe if CRIU allows the vDSO to be
preserved. Ouch.  (CRIU has some special code for this.  I'm not 100%
clear on all the details.)  One could maybe sort of get away with
treating the provided opaque_state as a completely opaque value and
not a pointer, but then the mechanism for allocating these states
should be adjusted accordingly.

One thing that occurs to me is that, if this thing were to be made
CRIU-safe, the buffer could have a magic number that changes any time
the data structure changes, and the vDSO could check, at the beginning
and end of the call, that the magic number is correct.  Doing this
would require using a special VMA type instead of just a wipe-on-fork
mapping, which could plausibly be a good thing anyway.  (Hmm, we don't
just want WIPEONFORK.  We should probably also wipe on swap-out and,
more importantly, we should absolutely wipe on any sort of CRIU-style
checkpointing.  Perhaps a special VMA would be a good thing for
multiple reasons.


> +{
> +    ssize_t ret =3D min_t(size_t, INT_MAX & PAGE_MASK /* =3D MAX_RW_COUN=
T */, len);
> +    struct vgetrandom_state *state =3D opaque_state;
> +    size_t batch_len, nblocks, orig_len =3D len;
> +    unsigned long current_generation;
> +    void *orig_buffer =3D buffer;
> +    u32 counter[2] =3D { 0 };
> +    bool in_use, have_retried =3D false;
> +
> +    /* The state must not straddle a page, since pages can be zeroed at =
any time. */
> +    if (unlikely(((unsigned long)opaque_state & ~PAGE_MASK) + sizeof(*st=
ate) > PAGE_SIZE))
> +        goto fallback_syscall;

This is weird. Either the provided pointer is valid or it isn=E2=80=99t.
Reasonable outcomes are a segfault if the pointer is bad or success
(or fallback if needed for some reason) if the pointer is good.  Why
is there specific code to catch a specific sort of pointer screwup
here?
