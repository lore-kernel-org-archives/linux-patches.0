Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC9C2596
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 14:25:52 +0000 (UTC)
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-187b70ab997so24687136fac.0
        for <patches@lists.linux.dev>; Mon, 24 Apr 2023 07:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682346351; x=1684938351;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zKS+UBunzq6RfUrusjalANtwKikt5ldpe5+nBfA+L40=;
        b=dCtzoGH6Qn9+Lq9vX9Hoq0tuDq+B0xGs6WXZL4ZJjiV0wyiz3ZrffOrKd1lhNsEYcA
         c5jgaQWBWVV85KdGWu4XFZVGf4zYmrCSf1A3qouLH4lSJKjQIw0Pte2EB6FvCYGMm9id
         zob2QzjXP+H5ksLaqVQvXowYFSPu3kFxc4NqxBPuUWrqjAGJf0PEKICVFcO4M9iFmJC4
         DAxieo3a4u20dH1y30Fxdfng59czns7NFttybfi4l6Y6As7cMwGMuxfB0Y7QaXXwspVv
         I64Es9jBvK36KosnfvBa4NBPPoLa2LdLyuZFxm9bsEXTVSpYlg0L2GLrSm6PJldy/Ktv
         yIiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682346351; x=1684938351;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zKS+UBunzq6RfUrusjalANtwKikt5ldpe5+nBfA+L40=;
        b=H/jK2rOYjOiNX2cbxHqI94EAdLulxgtQNn1e4TzcDY01wqqJgX5NqX2X24STEvNCop
         bSLcZ3wH1PPLoTz7udQB2UHfG0J1QeJst1eai+1p3OqnpmUetAmcuvwAZnPwtfI+Bitp
         Uu60l0ErrFS/hp22hZPaxntWS3WN4MUMhjKBUc4f5J8E60NH6VC+qghFmT+0s4xS8baF
         ypymUgjdnW9ah4EAlVpFXFwcdG7TMVjCcO2ft9T4oaGlJff58csEm1DQjOibCIv6FWUH
         TapZa3OJ8DyPBrNDWF6pkwwR/AZWK10t5tP6zRweH6YcnYIRx4wYVW+s5gnhtwSbh5sF
         qhFg==
X-Gm-Message-State: AAQBX9cKu17rP0Jg1lp3eaHXcfU2AHIAyz0L9V+FDRZ9OFF08imHHfrZ
	WWsC3Ot/pSTbmTI8Ibj0s8A=
X-Google-Smtp-Source: AKy350YBZkhcmWOL6eMDDY6RuJrJMKAU7V18TedHplJCqLwmQ+gvFhsZzeTwfTlpU2SlmkQRWXpW4Q==
X-Received: by 2002:aca:db56:0:b0:38e:4e96:1292 with SMTP id s83-20020acadb56000000b0038e4e961292mr10895461oig.3.1682346351041;
        Mon, 24 Apr 2023 07:25:51 -0700 (PDT)
Received: from [192.168.54.90] (static.220.238.itcsa.net. [190.15.220.238])
        by smtp.gmail.com with ESMTPSA id r66-20020acac145000000b0038c36edc51dsm4546095oif.24.2023.04.24.07.25.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Apr 2023 07:25:50 -0700 (PDT)
Message-ID: <dfa10c1f-43f6-a93e-e4ca-2362b895636e@gmail.com>
Date: Mon, 24 Apr 2023 11:24:54 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 4/4] rust: init: update macro expansion example in docs
Content-Language: en-US
To: Benno Lossin <benno.lossin@proton.me>, Miguel Ojeda <ojeda@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>,
 Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng
 <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=c3=b6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <20230424081112.99890-1-benno.lossin@proton.me>
 <20230424081112.99890-4-benno.lossin@proton.me>
From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
In-Reply-To: <20230424081112.99890-4-benno.lossin@proton.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/24/23 05:11, Benno Lossin wrote:
> Also improve the explaining comments.
> 
> Signed-off-by: Benno Lossin <benno.lossin@proton.me>
> ---
>  rust/kernel/init/macros.rs | 85 +++++++++++++++++++++-----------------
>  1 file changed, 48 insertions(+), 37 deletions(-)
> 
> diff --git a/rust/kernel/init/macros.rs b/rust/kernel/init/macros.rs
> index 541cfad1d8be..00aa4e956c0a 100644
> --- a/rust/kernel/init/macros.rs
> +++ b/rust/kernel/init/macros.rs
> @@ -16,8 +16,9 @@
>  //!
>  //! We will look at the following example:
>  //!
> -//! ```rust
> +//! ```rust,ignore
>  //! # use kernel::init::*;
> +//! # use core::pin::Pin;
>  //! #[pin_data]
>  //! #[repr(C)]
>  //! struct Bar<T> {
> @@ -71,11 +72,12 @@
>  //!
>  //! Here is the definition of `Bar` from our example:
>  //!
> -//! ```rust
> +//! ```rust,ignore
>  //! # use kernel::init::*;
>  //! #[pin_data]
>  //! #[repr(C)]
>  //! struct Bar<T> {
> +//!     #[pin]
>  //!     t: T,
>  //!     pub x: usize,
>  //! }
> @@ -83,7 +85,7 @@
>  //!
>  //! This expands to the following code:
>  //!
> -//! ```rust
> +//! ```rust,ignore
>  //! // Firstly the normal definition of the struct, attributes are preserved:
>  //! #[repr(C)]
>  //! struct Bar<T> {
> @@ -116,20 +118,22 @@
>  //!         unsafe fn t<E>(
>  //!             self,
>  //!             slot: *mut T,
> -//!             init: impl ::kernel::init::Init<T, E>,
> +//!             // Since `t` is `#[pin]`, this is `PinInit`.
> +//!             init: impl ::kernel::init::PinInit<T, E>,
>  //!         ) -> ::core::result::Result<(), E> {
> -//!             unsafe { ::kernel::init::Init::__init(init, slot) }
> +//!             unsafe { ::kernel::init::PinInit::__pinned_init(init, slot) }
>  //!         }
>  //!         pub unsafe fn x<E>(
>  //!             self,
>  //!             slot: *mut usize,
> +//!             // Since `x` is not `#[pin]`, this is `Init`.
>  //!             init: impl ::kernel::init::Init<usize, E>,
>  //!         ) -> ::core::result::Result<(), E> {
>  //!             unsafe { ::kernel::init::Init::__init(init, slot) }
>  //!         }
>  //!     }
>  //!     // Implement the internal `HasPinData` trait that associates `Bar` with the pin-data struct
> -//!     // that we constructed beforehand.
> +//!     // that we constructed above.
>  //!     unsafe impl<T> ::kernel::init::__internal::HasPinData for Bar<T> {
>  //!         type PinData = __ThePinData<T>;
>  //!         unsafe fn __pin_data() -> Self::PinData {
> @@ -160,6 +164,8 @@
>  //!     struct __Unpin<'__pin, T> {
>  //!         __phantom_pin: ::core::marker::PhantomData<fn(&'__pin ()) -> &'__pin ()>,
>  //!         __phantom: ::core::marker::PhantomData<fn(Bar<T>) -> Bar<T>>,
> +//!         // Our only `#[pin]` field is `t`.
> +//!         t: T,
>  //!     }
>  //!     #[doc(hidden)]
>  //!     impl<'__pin, T>
> @@ -193,7 +199,7 @@
>  //!
>  //! Here is the impl on `Bar` defining the new function:
>  //!
> -//! ```rust
> +//! ```rust,ignore
>  //! impl<T> Bar<T> {
>  //!     fn new(t: T) -> impl PinInit<Self> {
>  //!         pin_init!(Self { t, x: 0 })
> @@ -203,7 +209,7 @@
>  //!
>  //! This expands to the following code:
>  //!
> -//! ```rust
> +//! ```rust,ignore
>  //! impl<T> Bar<T> {
>  //!     fn new(t: T) -> impl PinInit<Self> {
>  //!         {
> @@ -232,25 +238,31 @@
>  //!                     // that will refer to this struct instead of the one defined above.
>  //!                     struct __InitOk;
>  //!                     // This is the expansion of `t,`, which is syntactic sugar for `t: t,`.
> -//!                     unsafe { ::core::ptr::write(&raw mut (*slot).t, t) };
> +//!                     unsafe { ::core::ptr::write(::core::addr_of_mut!((*slot).t), t) };
>  //!                     // Since initialization could fail later (not in this case, since the error
> -//!                     // type is `Infallible`) we will need to drop this field if it fails. This
> -//!                     // `DropGuard` will drop the field when it gets dropped and has not yet
> -//!                     // been forgotten. We make a reference to it, so users cannot `mem::forget`
> -//!                     // it from the initializer, since the name is the same as the field.
> +//!                     // type is `Infallible`) we will need to drop this field if there is an
> +//!                     // error later. This `DropGuard` will drop the field when it gets dropped
> +//!                     // and has not yet been forgotten. We make a reference to it, so users
> +//!                     // cannot `mem::forget` it from the initializer, since the name is the same
> +//!                     // as the field (including hygiene).
>  //!                     let t = &unsafe {
> -//!                         ::kernel::init::__internal::DropGuard::new(&raw mut (*slot).t)
> +//!                         ::kernel::init::__internal::DropGuard::new(
> +//!                             ::core::addr_of_mut!((*slot).t),
> +//!                         )
>  //!                     };
>  //!                     // Expansion of `x: 0,`:
>  //!                     // Since this can be an arbitrary expression we cannot place it inside of
>  //!                     // the `unsafe` block, so we bind it here.
>  //!                     let x = 0;
> -//!                     unsafe { ::core::ptr::write(&raw mut (*slot).x, x) };
> +//!                     unsafe { ::core::ptr::write(::core::addr_of_mut!((*slot).x), x) };
> +//!                     // We again create a `DropGuard`.
>  //!                     let x = &unsafe {
> -//!                         ::kernel::init::__internal::DropGuard::new(&raw mut (*slot).x)
> +//!                         ::kernel::init::__internal::DropGuard::new(
> +//!                             ::core::addr_of_mut!((*slot).x),
> +//!                         )
>  //!                     };
>  //!
> -//!                     // Here we use the type checker to ensuer that every field has been
> +//!                     // Here we use the type checker to ensure that every field has been
>  //!                     // initialized exactly once, since this is `if false` it will never get
>  //!                     // executed, but still type-checked.
>  //!                     // Additionally we abuse `slot` to automatically infer the correct type for
> @@ -272,7 +284,7 @@
>  //!                         };
>  //!                     }
>  //!                     // Since initialization has successfully completed, we can now forget the
> -//!                     // guards.
> +//!                     // guards. This is not `mem::forget`, since we only have `&DropGuard`.
>  //!                     unsafe { ::kernel::init::__internal::DropGuard::forget(t) };
>  //!                     unsafe { ::kernel::init::__internal::DropGuard::forget(x) };
>  //!                 }
> @@ -280,7 +292,7 @@
>  //!                 // `__InitOk` that we need to return.
>  //!                 Ok(__InitOk)
>  //!             });
> -//!             // Change the return type of the closure.
> +//!             // Change the return type from `__InitOk` to `()`.
>  //!             let init = move |slot| -> ::core::result::Result<(), ::core::convert::Infallible> {
>  //!                 init(slot).map(|__InitOk| ())
>  //!             };
> @@ -299,7 +311,7 @@
>  //! Since we already took a look at `#[pin_data]` on `Bar`, this section will only explain the
>  //! differences/new things in the expansion of the `Foo` definition:
>  //!
> -//! ```rust
> +//! ```rust,ignore
>  //! #[pin_data(PinnedDrop)]
>  //! struct Foo {
>  //!     a: usize,
> @@ -310,7 +322,7 @@
>  //!
>  //! This expands to the following code:
>  //!
> -//! ```rust
> +//! ```rust,ignore
>  //! struct Foo {
>  //!     a: usize,
>  //!     b: Bar<u32>,
> @@ -330,8 +342,6 @@
>  //!         unsafe fn b<E>(
>  //!             self,
>  //!             slot: *mut Bar<u32>,
> -//!             // Note that this is `PinInit` instead of `Init`, this is because `b` is
> -//!             // structurally pinned, as marked by the `#[pin]` attribute.
>  //!             init: impl ::kernel::init::PinInit<Bar<u32>, E>,
>  //!         ) -> ::core::result::Result<(), E> {
>  //!             unsafe { ::kernel::init::PinInit::__pinned_init(init, slot) }
> @@ -359,14 +369,13 @@
>  //!     struct __Unpin<'__pin> {
>  //!         __phantom_pin: ::core::marker::PhantomData<fn(&'__pin ()) -> &'__pin ()>,
>  //!         __phantom: ::core::marker::PhantomData<fn(Foo) -> Foo>,
> -//!         // Since this field is `#[pin]`, it is listed here.
>  //!         b: Bar<u32>,
>  //!     }
>  //!     #[doc(hidden)]
>  //!     impl<'__pin> ::core::marker::Unpin for Foo where __Unpin<'__pin>: ::core::marker::Unpin {}
>  //!     // Since we specified `PinnedDrop` as the argument to `#[pin_data]`, we expect `Foo` to
>  //!     // implement `PinnedDrop`. Thus we do not need to prevent `Drop` implementations like
> -//!     // before, instead we implement it here and delegate to `PinnedDrop`.
> +//!     // before, instead we implement `Drop` here and delegate to `PinnedDrop`.
>  //!     impl ::core::ops::Drop for Foo {
>  //!         fn drop(&mut self) {
>  //!             // Since we are getting dropped, no one else has a reference to `self` and thus we
> @@ -388,7 +397,7 @@
>  //!
>  //! Here is the `PinnedDrop` impl for `Foo`:
>  //!
> -//! ```rust
> +//! ```rust,ignore
>  //! #[pinned_drop]
>  //! impl PinnedDrop for Foo {
>  //!     fn drop(self: Pin<&mut Self>) {
> @@ -399,7 +408,7 @@
>  //!
>  //! This expands to the following code:
>  //!
> -//! ```rust
> +//! ```rust,ignore
>  //! // `unsafe`, full path and the token parameter are added, everything else stays the same.
>  //! unsafe impl ::kernel::init::PinnedDrop for Foo {
>  //!     fn drop(self: Pin<&mut Self>, _: ::kernel::init::__internal::OnlyCallFromDrop) {
> @@ -410,10 +419,10 @@
>  //!
>  //! ## `pin_init!` on `Foo`
>  //!
> -//! Since we already took a look at `pin_init!` on `Bar`, this section will only explain the
> -//! differences/new things in the expansion of `pin_init!` on `Foo`:
> +//! Since we already took a look at `pin_init!` on `Bar`, this section will only show the expansion
> +//! of `pin_init!` on `Foo`:
>  //!
> -//! ```rust
> +//! ```rust,ignore
>  //! let a = 42;
>  //! let initializer = pin_init!(Foo {
>  //!     a,
> @@ -423,7 +432,7 @@
>  //!
>  //! This expands to the following code:
>  //!
> -//! ```rust
> +//! ```rust,ignore
>  //! let a = 42;
>  //! let initializer = {
>  //!     struct __InitOk;
> @@ -438,13 +447,15 @@
>  //!     >(data, move |slot| {
>  //!         {
>  //!             struct __InitOk;
> -//!             unsafe { ::core::ptr::write(&raw mut (*slot).a, a) };
> -//!             let a = &unsafe { ::kernel::init::__internal::DropGuard::new(&raw mut (*slot).a) };
> +//!             unsafe { ::core::ptr::write(::core::addr_of_mut!((*slot).a), a) };
> +//!             let a = &unsafe {
> +//!                 ::kernel::init::__internal::DropGuard::new(::core::addr_of_mut!((*slot).a))
> +//!             };
>  //!             let b = Bar::new(36);
> -//!             // Here we use `data` to access the correct field and require that `b` is of type
> -//!             // `PinInit<Bar<u32>, Infallible>`.
> -//!             unsafe { data.b(&raw mut (*slot).b, b)? };
> -//!             let b = &unsafe { ::kernel::init::__internal::DropGuard::new(&raw mut (*slot).b) };
> +//!             unsafe { data.b(::core::addr_of_mut!((*slot).b), b)? };
> +//!             let b = &unsafe {
> +//!                 ::kernel::init::__internal::DropGuard::new(::core::addr_of_mut!((*slot).b))
> +//!             };
>  //!
>  //!             #[allow(unreachable_code, clippy::diverging_sub_expression)]
>  //!             if false {
> --
> 2.40.0
> 
> 

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
