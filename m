Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E332258B
	for <patches@lists.linux.dev>; Fri, 31 Mar 2023 12:44:10 +0000 (UTC)
Received: by mail-wr1-f47.google.com with SMTP id h17so22237754wrt.8
        for <patches@lists.linux.dev>; Fri, 31 Mar 2023 05:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20210112.gappssmtp.com; s=20210112; t=1680266648;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=Pj2oN2LwZ2WDVYe/kJrJYhEskC0mu3RJkM2yXvZMoo0=;
        b=romFrc+yurgbCwzfpHvf55mEkveW/UWgdUQvLlSgn+vNSyDFcUbgBY6A5BD6RLggkS
         WFOb/znbl01YD+TZx9uMbPqgmpfGbTf9s9+lNnFUnvgbNAJbhVGCd5PKqxY6SfLU+0yT
         TvIr4GX4qQ/A2nqAmxsCIQSQ69eLj/KN1ybe0we8EHFy5iFRQOOwNUhwl219CA223pis
         Vj9z1byg7h9oEldI6Gog2U6NVyJYXVTP/3eUm96zH8KWMDzD9t4YtrLdvA7vjrxc4B97
         o5Yg/fGOZd/8zHhTqrS3oNdz2D0Jp2YK3Di+n8X1CZwCDcqAvwxh62DxzzkoYk+Wb1yo
         PPUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680266648;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pj2oN2LwZ2WDVYe/kJrJYhEskC0mu3RJkM2yXvZMoo0=;
        b=W6sR7qGJU+qixx/ASOtX15CSYaOVYKjE3O6+DzH/p+4OiGMfW/JzVx/ErsvyyKki4Z
         gUkgGIc1drD6HeYCHZQvwszoTMCidtCQqMdqm2S/Wi/9yAm5VlFJlXmc679etMg6b5Sl
         yHp1hBFvuK5PVEzT+rrpN8yb7vYR0Q5Ancg8amkMgvKNmgr7KkQ3uCrOgltybtyPJRIY
         786ByxIcokcEwjBBoNZ4HA4rldGLgYJBRTvO9H4ELAiFkGcYWs0byA05ruWNV5WNbP/V
         ubVVliNNdRmb6UQvjGA9ARrYrpXl1Pj3na4xfSlecUm8IMwDDvSFGFO7TN5g043efkta
         y7Hg==
X-Gm-Message-State: AAQBX9eq7CYcN5hpMs6Tb7c6Yh/vKv50EnDT4085TKoHHMiC01gpF5qQ
	MIkA2jiq0R1MEwDklQPuTJMOuA==
X-Google-Smtp-Source: AKy350ao52RjPAABRebzNyJWrFOWCr3+nwOfqSWPcCtqMC225ZVtUvGv6uakeGn9QcWOxDPpdU7z8w==
X-Received: by 2002:a5d:44c4:0:b0:2c5:4f2d:d9b4 with SMTP id z4-20020a5d44c4000000b002c54f2dd9b4mr20341258wrr.58.1680266648536;
        Fri, 31 Mar 2023 05:44:08 -0700 (PDT)
Received: from localhost ([165.225.194.194])
        by smtp.gmail.com with ESMTPSA id s12-20020adfeccc000000b002da1261aa44sm2155877wro.48.2023.03.31.05.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 05:44:08 -0700 (PDT)
References: <20230329223239.138757-1-y86-dev@protonmail.com>
 <20230329223239.138757-9-y86-dev@protonmail.com>
User-agent: mu4e 1.9.18; emacs 28.2.50
From: Andreas Hindborg <nmi@metaspace.dk>
To: y86-dev@protonmail.com
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng
 <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?=
 Roy Baron
 <bjorn3_gh@protonmail.com>, Alice Ryhl <alice@ryhl.io>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev, Andreas Hindborg <a.hindborg@samsung.com>
Subject: Re: [PATCH v3 08/13] rust: init: add `stack_pin_init!` macro
Date: Fri, 31 Mar 2023 14:43:33 +0200
In-reply-to: <20230329223239.138757-9-y86-dev@protonmail.com>
Message-ID: <87fs9l2iqw.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


y86-dev@protonmail.com writes:

> From: Benno Lossin <y86-dev@protonmail.com>
>
> The `stack_pin_init!` macro allows pin-initializing a value on the
> stack. It accepts a `impl PinInit<T, E>` to initialize a `T`. It allows
> propagating any errors via `?` or handling it normally via `match`.
>
> Signed-off-by: Benno Lossin <y86-dev@protonmail.com>
> ---


Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>


>  rust/kernel/init.rs            | 70 +++++++++++++++++++++++++++++++---
>  rust/kernel/init/__internal.rs | 46 ++++++++++++++++++++++
>  2 files changed, 110 insertions(+), 6 deletions(-)
>
> diff --git a/rust/kernel/init.rs b/rust/kernel/init.rs
> index 428b5c2ac516..3358f14beffb 100644
> --- a/rust/kernel/init.rs
> +++ b/rust/kernel/init.rs
> @@ -12,7 +12,8 @@
>  //!
>  //! To initialize a `struct` with an in-place constructor you will need two things:
>  //! - an in-place constructor,
> -//! - a memory location that can hold your `struct`.
> +//! - a memory location that can hold your `struct` (this can be the [stack], an [`Arc<T>`],
> +//!   [`UniqueArc<T>`], [`Box<T>`] or any other smart pointer that implements [`InPlaceInit`]).
>  //!
>  //! To get an in-place constructor there are generally three options:
>  //! - directly creating an in-place constructor using the [`pin_init!`] macro,
> @@ -180,6 +181,7 @@
>  //! [pinning]: https://doc.rust-lang.org/std/pin/index.html
>  //! [structurally pinned fields]:
>  //!     https://doc.rust-lang.org/std/pin/index.html#pinning-is-structural-for-field
> +//! [stack]: crate::stack_pin_init
>  //! [`Arc<T>`]: crate::sync::Arc
>  //! [`impl PinInit<Foo>`]: PinInit
>  //! [`impl PinInit<T, E>`]: PinInit
> @@ -199,6 +201,62 @@ pub mod __internal;
>  #[doc(hidden)]
>  pub mod macros;
>
> +/// Initialize and pin a type directly on the stack.
> +///
> +/// # Examples
> +///
> +/// ```rust
> +/// # #![allow(clippy::disallowed_names, clippy::new_ret_no_self)]
> +/// # use kernel::{init, pin_init, stack_pin_init, init::*, sync::Mutex, new_mutex};
> +/// # use macros::pin_data;
> +/// # use core::pin::Pin;
> +/// #[pin_data]
> +/// struct Foo {
> +///     #[pin]
> +///     a: Mutex<usize>,
> +///     b: Bar,
> +/// }
> +///
> +/// #[pin_data]
> +/// struct Bar {
> +///     x: u32,
> +/// }
> +///
> +/// let a = new_mutex!(42, "Foo::a");
> +///
> +/// stack_pin_init!(let foo =? pin_init!(Foo {
> +///     a,
> +///     b: Bar {
> +///         x: 64,
> +///     },
> +/// }));
> +/// let foo: Pin<&mut Foo> = foo;
> +/// # Ok::<(), core::convert::Infallible>(())
> +/// ```
> +///
> +/// # Syntax
> +///
> +/// A normal `let` binding with optional type annotation. The expression is expected to implement
> +/// [`PinInit`]. Additionally a `?` can be put after the `=`, this will assign `Pin<&mut T>` to the
> +/// variable instead of `Result<Pin<&mut T>, E>`.
> +#[macro_export]
> +macro_rules! stack_pin_init {
> +    (let $var:ident $(: $t:ty)? = $val:expr) => {
> +        let mut $var = $crate::init::__internal::StackInit$(::<$t>)?::uninit();
> +        let mut $var = {
> +            let val = $val;
> +            unsafe { $crate::init::__internal::StackInit::init(&mut $var, val) }
> +        };
> +    };
> +    (let $var:ident $(: $t:ty)? =? $val:expr) => {
> +        let mut $var = $crate::init::__internal::StackInit$(::<$t>)?::uninit();
> +        let mut $var = {
> +            let val = $val;
> +            unsafe { $crate::init::__internal::StackInit::init(&mut $var, val)? }
> +        };
> +    };
> +}
> +
>  /// Construct an in-place, pinned initializer for `struct`s.
>  ///
>  /// This macro defaults the error to [`Infallible`]. If you need [`Error`], then use
> @@ -916,8 +974,8 @@ macro_rules! try_init {
>  /// A pinned initializer for `T`.
>  ///
>  /// To use this initializer, you will need a suitable memory location that can hold a `T`. This can
> -/// be [`Box<T>`], [`Arc<T>`], [`UniqueArc<T>`]. Use the [`InPlaceInit::pin_init`] function of a
> -/// smart pointer like [`Arc<T>`] on this.
> +/// be [`Box<T>`], [`Arc<T>`], [`UniqueArc<T>`] or even the stack (see [`stack_pin_init!`]). Use the
> +/// [`InPlaceInit::pin_init`] function of a smart pointer like [`Arc<T>`] on this.
>  ///
>  /// Also see the [module description](self).
>  ///
> @@ -952,9 +1010,9 @@ pub unsafe trait PinInit<T: ?Sized, E = Infallible>: Sized {
>  /// An initializer for `T`.
>  ///
>  /// To use this initializer, you will need a suitable memory location that can hold a `T`. This can
> -/// be [`Box<T>`], [`Arc<T>`], [`UniqueArc<T>`]. Use the [`InPlaceInit::init`] function of a smart
> -/// pointer like [`Arc<T>`] on this. Because [`PinInit<T, E>`] is a super trait, you can
> -/// use every function that takes it as well.
> +/// be [`Box<T>`], [`Arc<T>`], [`UniqueArc<T>`] or even the stack (see [`stack_pin_init!`]). Use the
> +/// [`InPlaceInit::init`] function of a smart pointer like [`Arc<T>`] on this. Because
> +/// [`PinInit<T, E>`] is a super trait, you can use every function that takes it as well.
>  ///
>  /// Also see the [module description](self).
>  ///
> diff --git a/rust/kernel/init/__internal.rs b/rust/kernel/init/__internal.rs
> index 4a3c7bf27a06..bf33c8e96e6d 100644
> --- a/rust/kernel/init/__internal.rs
> +++ b/rust/kernel/init/__internal.rs
> @@ -89,6 +89,52 @@ unsafe impl<T: ?Sized> HasInitData for T {
>      }
>  }
>
> +/// Stack initializer helper type. Use [`stack_pin_init`] instead of this primitive.
> +///
> +/// # Invariants
> +///
> +/// If `self.1` is true, then `self.0` is initialized.
> +///
> +/// [`stack_pin_init`]: kernel::stack_pin_init
> +pub struct StackInit<T>(MaybeUninit<T>, bool);
> +
> +impl<T> Drop for StackInit<T> {
> +    #[inline]
> +    fn drop(&mut self) {
> +        if self.1 {
> +            // SAFETY: As we are being dropped, we only call this once. And since `self.1 == true`,
> +            // `self.0` has to be initialized.
> +            unsafe { self.0.assume_init_drop() };
> +        }
> +    }
> +}
> +
> +impl<T> StackInit<T> {
> +    /// Creates a new [`StackInit<T>`] that is uninitialized. Use [`stack_pin_init`] instead of this
> +    /// primitive.
> +    ///
> +    /// [`stack_pin_init`]: kernel::stack_pin_init
> +    #[inline]
> +    pub fn uninit() -> Self {
> +        Self(MaybeUninit::uninit(), false)
> +    }
> +
> +    /// Initializes the contents and returns the result.
> +    ///
> +    /// # Safety
> +    ///
> +    /// The caller ensures that `self` is on the stack and not accessible in any other way, if this
> +    /// function returns `Ok`.
> +    #[inline]
> +    pub unsafe fn init<E>(&mut self, init: impl PinInit<T, E>) -> Result<Pin<&mut T>, E> {
> +        // SAFETY: The memory slot is valid and this type ensures that it will stay pinned.
> +        unsafe { init.__pinned_init(self.0.as_mut_ptr())? };
> +        self.1 = true;
> +        // SAFETY: The slot is now pinned, since we will never give access to `&mut T`.
> +        Ok(unsafe { Pin::new_unchecked(self.0.assume_init_mut()) })
> +    }
> +}
> +
>  /// When a value of this type is dropped, it drops a `T`.
>  ///
>  /// Can be forgotton to prevent the drop.

