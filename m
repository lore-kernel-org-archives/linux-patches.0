Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6175B2E7F1E
	for <patches@lists.linux.dev>; Thu, 26 Jun 2025 13:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750946210; cv=none; b=gt247kBLlOU+/LcB5kS1a/nDXRbuxnDpSKHGe8DndXqz/P0spMZMeQbYD+abGFw49v49vvowNZnAkHR757dOr00aunCAl9+LGA4ozHCRmJhBetPUM0l60F+eyW6wZLR469tLWpuyN7ZUwcznlxqqWO+QQ+ABDlQokvPSq7/i0sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750946210; c=relaxed/simple;
	bh=gjdHL52RORLpW8wvnJn6OWMRqxB5lI1erYSoLtMSVmw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DR8AUadWSjyI3KB4vEWKCZNbONpccckL5GA8l2djxE+DgWngm/0wr4P9FCwCxZ8YEo9qLMts5zIkA455pCAbz+4pwoYuAkP/h0T+y5jxhZu5yVXIqU/E03Y1JOvNb5EWLAT+uI6eBDxe4TThVouDAA2KNLMY7rvj7Nhp9glrSZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JjkJE4iq; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JjkJE4iq"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3134c67a173so1091199a91.1
        for <patches@lists.linux.dev>; Thu, 26 Jun 2025 06:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750946208; x=1751551008; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WvA01Sx6mR6kWi/vaxXvE8U/fUvAZjtw0tMx9Rr2caI=;
        b=JjkJE4iqJ22hZrbJbj/cni4qWD8Cg1CCEKHutTjMF+l5uniy7nRMlFtraEEy750NNB
         tENqVOzQPKNu5n8W2ugvj17R5KWRJJJ2utnj8dWGzicBPpdWznOvy/xvMa3GtaOfCXG6
         MOtftY5AIe3PIWzxoBC6MAeg3u1OPQiV7B/VcaL2in94HAm0b2K5GpuoVUP2ryA4Bvv0
         +BnynRr0ALTWaZg6xMj8Eqr5t4ZvyKCP/Xw42RDwQdbGwFuePZKw6kywSMr+yeGdv+Gc
         MqqYZGt1RmJWXEIA59Q9fBKxgcoqFHvp05FeZPa2dVJFkVVE6JLtpPofrXlioT7ZnI4r
         QE9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750946208; x=1751551008;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WvA01Sx6mR6kWi/vaxXvE8U/fUvAZjtw0tMx9Rr2caI=;
        b=GVnDVLM0y0yXuDYJjOW1W5kyIWZfAWdIvZUKsoVP9p3RGa0mEovXMMdYNbCZj5l9Qr
         w7YqeuwRo/dDEMx7ZaM2x+0sxhrQHii0UFjKJYB7YyezecGxu6HheWSGm0znCrLESFya
         ByZLOe/3MGpISs24ZXpjWkvx+lFDhZoa+r9EE2i8ImIyUE0rownvBJ6YkKzyiFMptRx6
         8nwIyNyfeHukQvGFTdKdxUKTybpUT4J5oLd1nsLjV5Cb3CywH7Bv9a7aByH5Z7jSU0YC
         MzpEfb2IKZP7DNEf7ZLp3ucbUKam9BJ3je89wI8W4B86LG/pdxTbVapU94Nj4I2Q37LZ
         +W7g==
X-Forwarded-Encrypted: i=1; AJvYcCVSiZ9R8oY++fAZoBC2o3NZV3oeU8M5jATqaMFPHHdCKTqsX5Pcvw56VS0A03IZot1dcwh/+qIa@lists.linux.dev
X-Gm-Message-State: AOJu0YxuJGO9OCns3I76iXn/Pmf/HxlTF4hFlhotT6yLEQ2DkFwdXJm6
	F6hLfQyG0oKj9kb+pl1UIsEoc2lbwLTc8q5YYPd0q8INe4R2pbfXGHzfz+ALHkDnJSy1awDNcU/
	FGEHX19G4kKd2Pt2HeHcCNs1IvHQsotw=
X-Gm-Gg: ASbGncuQTliWt8Wbq8qDj/w3eKRBECK1n9MBp9eHUqkElLvrEgkmqhsEWqceip6W0Ul
	+i3lnirGsdMFZRqa63A85lwDgJjJFauwlmfLD0FRAWSEW9TJVXls76DuqaFJ16AUniaFn1Ujp5h
	dvmF1YtSRJzvw/W4qfoDkHgxJ4O0hxwfPfz5acvSDq8kZd
X-Google-Smtp-Source: AGHT+IHa6yXbM+5t0Adv5dhFozO1ihksVo3U4Ek0FSY6Tg6xwKFT7Wimn2JDB77xa3AbviAVvHPk4vp6zrXXGggTnYM=
X-Received: by 2002:a17:90b:51c3:b0:312:ea46:3e66 with SMTP id
 98e67ed59e1d1-315f26771admr9880287a91.21.1750946207302; Thu, 26 Jun 2025
 06:56:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250625111133.698481-1-shankari.ak0208@gmail.com> <DAVYWQE2PYZE.3TRIT906A9BJM@kernel.org>
In-Reply-To: <DAVYWQE2PYZE.3TRIT906A9BJM@kernel.org>
From: Shankari Anand <shankari.ak0208@gmail.com>
Date: Thu, 26 Jun 2025 19:25:00 +0530
X-Gm-Features: Ac12FXyUfuHgDsplwFCWon9SVCweA6V7I2FgMpfKrWvpZS6e0pfkq2b7MOiOMmw
Message-ID: <CAPRMd3=5aMx_DmhuXxWbNodM8OV6EWkXMTByAzOSr3ESoSj_BQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] rust: move ARef and AlwaysRefCounted to sync::aref
To: Benno Lossin <lossin@kernel.org>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	patches@lists.linux.dev, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, Roy Baron <bjorn3_gh@protonmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,
Thanks for your feedback!

> I'd say this module is about supporting objects with builtin reference
> counting.
I described the module as an "Atomic reference-counted pointer
abstraction" to highlight its similarity to Arc<T>, but for manually
refcounted types. Your version about =E2=80=9Csupporting objects with built=
-in
reference counting=E2=80=9D is definitely clearer, happy to adopt that
phrasing if preferred.

> I would lead with comparing `ARef<T>` to `Arc<T>` and only later mention
> `AlwaysRefCounted`.
I mentioned AlwaysRefCounted early on just to give readers a quick
idea of what the module is really about, but I understand your point
about introducing it a bit later and can rearrange that.

>
> You also rephrased these docs, can you do that in a separate patch?

I rephrased a few lines in the intro since we=E2=80=99re starting a new mod=
ule
and I thought it might help with readability. But if keeping the
original is better, I can revert those changes, no problem at all.


> Newline?
About the extra newline - I didn=E2=80=99t add it manually, but it might=E2=
=80=99ve
come from creating the new file. I=E2=80=99ll check the patch, and if it wa=
s
actually added, I=E2=80=99ll remove it.

> ---
> Cheers,
> Benno
---
Thanks and regards,
Shankari


On Thu, Jun 26, 2025 at 3:59=E2=80=AFAM Benno Lossin <lossin@kernel.org> wr=
ote:
>
> On Wed Jun 25, 2025 at 1:11 PM CEST, Shankari Anand wrote:
> > diff --git a/rust/kernel/sync/aref.rs b/rust/kernel/sync/aref.rs
> > new file mode 100644
> > index 000000000000..93a23b493e21
> > --- /dev/null
> > +++ b/rust/kernel/sync/aref.rs
> > @@ -0,0 +1,170 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +//! Atomic reference-counted pointer abstraction.
>
> I'd say this module is about supporting objects with builtin reference
> counting.
>
> > +//!
> > +//! This module provides [`ARef<T>`], an owned reference to a value th=
at implements
> > +//! [`AlwaysRefCounted`] =E2=80=94 an unsafe trait for types that mana=
ge their own reference count.
>
> I would lead with comparing `ARef<T>` to `Arc<T>` and only later mention
> `AlwaysRefCounted`.
>
> > +//!
> > +//! It is based on the Linux kernel's manual reference counting model =
and is typically used
> > +//! with C types that implement reference counting (e.g., via `refcoun=
t_t` or `kref`).
> > +//!
> > +//! For Rust-managed objects, prefer using [`Arc`](crate::sync::Arc) i=
nstead.
> > +
> > +use core::{
> > +    marker::PhantomData,
> > +    mem::ManuallyDrop,
> > +    ops::Deref,
> > +    ptr::NonNull,
> > +};
> > +
> > +/// Trait for types that are _always_ reference-counted.
> > +///
> > +/// This trait allows types to define custom reference increment and d=
ecrement logic.
> > +/// It enables safe conversion from a shared reference `&T` to an owne=
d [`ARef<T>`].
> > +///
> > +/// This is usually implemented by wrappers around C types with manual=
 refcounting.
> > +///
> > +/// For purely Rust-managed memory, consider using [`Arc`](crate::sync=
::Arc) instead.
> > +///
> > +/// # Safety
> > +///
> > +/// Implementers must ensure that:
> > +///
> > +/// - Calling [`AlwaysRefCounted::inc_ref`] keeps the object alive in =
memory until a matching [`AlwaysRefCounted::dec_ref`] is called.
> > +/// - The object is always managed by a reference count; it must never=
 be stack-allocated or
> > +///   otherwise untracked.
> > +/// - When the count reaches zero in [`AlwaysRefCounted::dec_ref`], th=
e object is properly freed and no further
> > +///   access occurs.
> > +///
> > +/// Failure to follow these rules may lead to use-after-free or memory=
 corruption.
>
> You also rephrased these docs, can you do that in a separate patch?
>
> > +
>
> Newline?
>
> ---
> Cheers,
> Benno
>
> > +pub unsafe trait AlwaysRefCounted {
> > +    /// Increments the reference count on the object.
> > +    fn inc_ref(&self);
> > +
> > +    /// Decrements the reference count on the object.
> > +    ///
> > +    /// Frees the object when the count reaches zero.
> > +    ///
> > +    /// # Safety
> > +    ///
> > +    /// Callers must ensure that there was a previous matching increme=
nt to the reference count,
> > +    /// and that the object is no longer used after its reference coun=
t is decremented (as it may
> > +    /// result in the object being freed), unless the caller owns anot=
her increment on the refcount
> > +    /// (e.g., it calls [`AlwaysRefCounted::inc_ref`] twice, then call=
s
> > +    /// [`AlwaysRefCounted::dec_ref`] once).
> > +    unsafe fn dec_ref(obj: NonNull<Self>);
> > +}
