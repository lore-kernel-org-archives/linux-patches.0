Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13792C950
	for <patches@lists.linux.dev>; Wed,  5 Apr 2023 21:59:40 +0000 (UTC)
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-502739add9dso836358a12.0
        for <patches@lists.linux.dev>; Wed, 05 Apr 2023 14:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20210112.gappssmtp.com; s=20210112; t=1680731979;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=RZZVkPe4AwCbs7pG7yz8OubdmqvEAqRS47xr1RdAx9w=;
        b=ERYi2dpfiVAnS8c8CJFU01G0Zh34IwJJhXbOOe9qa65Sdogiq2+lBBlXX4UaMWXiGl
         3pByt8yzAClGmfMHTH1TurTPaJZ4sdTnyBsqNrvY83aiXY5rmrypjwccyXqmepm6h9ym
         x42ez/i70xtNQh1AvTN7FOvZJ642iGusLuWmQtoCF6B4ZL6YctoQWiFdH3TeXtoVaVAh
         PHmvF2Ymx1na1IeLk/O3quXY5YZAc+RHjMgrX3l/KYpQwIAs0oRQ2HANnnzrQeN57kcW
         +zEfc+AVNEKZOM8XEIWluADGyJUIXKaN883bVUsErupZ9C4oYzDpFTGDlU8z1ERB6d12
         AFWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680731979;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RZZVkPe4AwCbs7pG7yz8OubdmqvEAqRS47xr1RdAx9w=;
        b=s2YC5qigQPP23N2Za6lmr1YMya42mXn68Sx0dt0s/Y65c1Rwo6d8WgOFhlOdBy25eU
         KiRuWEC0HitcJ/K7JcxGpKYCmIjqqQVrVgtmGJ+e04l9/3XMQhGQtjG8ZskNZgHysqew
         Td0SGmtEzYtpL4/ryD7Aua0MLQJo+6OuDODXFseQggi86YxEbCzlmYs35JaYjcgzht2q
         Ff24hI+h8KRLXYuBmiN4R7jmPYr6OKMvGr5mzYMI2M1/YYJo2cjnaNhKWJNlOKKNNRWv
         lz+ptS0txzUcqqXE6U3FSNfo2x0mY4bDBQo3Ori4vGhMlP2ero2YHJSn5NCiLyWBOHi8
         Rrmw==
X-Gm-Message-State: AAQBX9cX+smKEIbvVAds26ydXIOo6GrR91pjgPF0bEpq4gWl0UG1x3vQ
	U122CcmxqqbIfYT7t/5fNZfmJA==
X-Google-Smtp-Source: AKy350aZ5fbWqOqFqxsZjsVdzrI8BDvIV15oXyKuAnwypjN/QNgCyXKwxwCQnsSOgZUF/qv629FpHg==
X-Received: by 2002:a05:6402:b04:b0:4fd:215e:b691 with SMTP id bm4-20020a0564020b0400b004fd215eb691mr3735096edb.4.1680731978953;
        Wed, 05 Apr 2023 14:59:38 -0700 (PDT)
Received: from localhost ([79.142.230.34])
        by smtp.gmail.com with ESMTPSA id h5-20020a50c385000000b004ad601533a3sm7837803edf.55.2023.04.05.14.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 14:59:38 -0700 (PDT)
References: <20230405193445.745024-1-y86-dev@protonmail.com>
 <20230405193445.745024-15-y86-dev@protonmail.com>
User-agent: mu4e 1.10.1; emacs 28.2.50
From: Andreas Hindborg <nmi@metaspace.dk>
To: Benno Lossin <y86-dev@protonmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng
 <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?=
 Roy Baron
 <bjorn3_gh@protonmail.com>, Alice Ryhl <alice@ryhl.io>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, Alice Ryhl <aliceryhl@google.com>, Andreas
 Hindborg <a.hindborg@samsung.com>
Subject: Re: [PATCH v6 14/15] rust: sync: reduce stack usage of
 `UniqueArc::try_new_uninit`
Date: Wed, 05 Apr 2023 23:59:01 +0200
In-reply-to: <20230405193445.745024-15-y86-dev@protonmail.com>
Message-ID: <87pm8irnw5.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Benno Lossin <y86-dev@protonmail.com> writes:

> `UniqueArc::try_new_uninit` calls `Arc::try_new(MaybeUninit::uninit())`.
> This results in the uninitialized memory being placed on the stack,
> which may be arbitrarily large due to the generic `T` and thus could
> cause a stack overflow for large types.
>
> Change the implementation to use the pin-init API which enables in-place
> initialization. In particular it avoids having to first construct and
> then move the uninitialized memory from the stack into the final location.
>
> Signed-off-by: Benno Lossin <y86-dev@protonmail.com>
> Reviewed-by: Alice Ryhl <aliceryhl@google.com>
> Reviewed-by: Gary Guo <gary@garyguo.net>
> Cc: Andreas Hindborg <a.hindborg@samsung.com>
> ---

Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>

>  rust/kernel/lib.rs      |  1 -
>  rust/kernel/sync/arc.rs | 16 +++++++++++++---
>  2 files changed, 13 insertions(+), 4 deletions(-)
>
> diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
> index 821bd067151c..2d7606135ef6 100644
> --- a/rust/kernel/lib.rs
> +++ b/rust/kernel/lib.rs
> @@ -28,7 +28,6 @@
>  #[cfg(not(CONFIG_RUST))]
>  compile_error!("Missing kernel configuration for conditional compilation");
>
> -#[allow(unused_extern_crates)]
>  // Allow proc-macros to refer to `::kernel` inside the `kernel` crate (this crate).
>  extern crate self as kernel;
>
> diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
> index 43a53fbe175d..d05caa723718 100644
> --- a/rust/kernel/sync/arc.rs
> +++ b/rust/kernel/sync/arc.rs
> @@ -18,7 +18,8 @@
>  use crate::{
>      bindings,
>      error::{self, Error},
> -    init::{InPlaceInit, Init, PinInit},
> +    init::{self, InPlaceInit, Init, PinInit},
> +    try_init,
>      types::{ForeignOwnable, Opaque},
>  };
>  use alloc::boxed::Box;
> @@ -30,6 +31,7 @@ use core::{
>      pin::Pin,
>      ptr::NonNull,
>  };
> +use macros::pin_data;
>
>  /// A reference-counted pointer to an instance of `T`.
>  ///
> @@ -122,6 +124,7 @@ pub struct Arc<T: ?Sized> {
>      _p: PhantomData<ArcInner<T>>,
>  }
>
> +#[pin_data]
>  #[repr(C)]
>  struct ArcInner<T: ?Sized> {
>      refcount: Opaque<bindings::refcount_t>,
> @@ -502,9 +505,16 @@ impl<T> UniqueArc<T> {
>
>      /// Tries to allocate a new [`UniqueArc`] instance whose contents are not initialised yet.
>      pub fn try_new_uninit() -> Result<UniqueArc<MaybeUninit<T>>, AllocError> {
> -        Ok(UniqueArc::<MaybeUninit<T>> {
> +        // INVARIANT: The refcount is initialised to a non-zero value.
> +        let inner = Box::try_init::<AllocError>(try_init!(ArcInner {
> +            // SAFETY: There are no safety requirements for this FFI call.
> +            refcount: Opaque::new(unsafe { bindings::REFCOUNT_INIT(1) }),
> +            data <- init::uninit::<T, AllocError>(),
> +        }? AllocError))?;
> +        Ok(UniqueArc {
>              // INVARIANT: The newly-created object has a ref-count of 1.
> -            inner: Arc::try_new(MaybeUninit::uninit())?,
> +            // SAFETY: The pointer from the `Box` is valid.
> +            inner: unsafe { Arc::from_inner(Box::leak(inner).into()) },
>          })
>      }
>  }

