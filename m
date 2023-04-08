Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592131FA5
	for <patches@lists.linux.dev>; Sat,  8 Apr 2023 15:22:06 +0000 (UTC)
Received: by mail-lj1-f180.google.com with SMTP id s20so25664092ljp.7
        for <patches@lists.linux.dev>; Sat, 08 Apr 2023 08:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20210112.gappssmtp.com; s=20210112; t=1680967324; x=1683559324;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=2JKqdvpjALTNY14K+ULfr5K58GEjzN+kYH1iVVw0tNA=;
        b=Ys8BSrbpC92W7+nHHSby0VNSxoRgHZ68oiCSbzNMSUPRakTtMaCvgxF4QwpDePoZlq
         GMPrRgw+SQ7VCyKioHOfdF27zQFjAmX4xU00wcLKqZ2AJJ4IwZ8v/8jhm1J4DsW9UruB
         tvXNPPtvQ8KnKJf/tkLSH9UWdZQhklJj2g2fE9pIPZ4AqZxjd/gsazt8MN8FzCQM0Il+
         bCryuDNohY19/sGzUZnPyIz2N40P6xGAC51L8MwvgyLjj+T9yJK9wm7E4sv5ZUdRNcLB
         Oa5hmLLgh8hE234iBMK2qwSnf5mMmcMTZTOSabbup2XhJxNyMlfaBQSiTglJpMQNepnV
         pu0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680967324; x=1683559324;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2JKqdvpjALTNY14K+ULfr5K58GEjzN+kYH1iVVw0tNA=;
        b=il3ZgytGPyvNtdz1HpWh6YMwXa6QMOGL3GNQWU/MELYv8OLiDQL3JTwsCEDFg8zxZb
         0c35rWHU4Zf9QkOcnp9ZLIq+Cv0AWEW6cmaOGTaqhqv2tUj4K2CTFT2ezMgx2/iKFgz/
         x1jHvokbulrHoEWQ0JqYtl4VpRbrZ9u3J8YXgglr7ERTuf4CaebpfzEh5pQqR8lXAhfh
         1ii0aprlqFNUww8vMA5Fvjm/+E0KvHA0T4IF+P4XFrKkgmuyCcEo+yI+Qk/jYJ3JDzEc
         Vsla2/TLSUC+OnfEg1Po1Vfl5n0+GDhx3tASm5E9SSwdhq65svOpTnCJCZHgBObBu5bc
         yOSw==
X-Gm-Message-State: AAQBX9dh9MZlZCTPZrqiWaC8DXnHz0MhHp8b5N374BuXGNC+IMdAo2NZ
	rfq3rnrbShAqEQeGqy+QkBHVtg==
X-Google-Smtp-Source: AKy350bqba2V+QO9gNz6grpg3wAhPK0lXK/6RxwK2/UfThFmGHSCZgkhl6NsvgijZx+Dq1bIKLaIKA==
X-Received: by 2002:a2e:7808:0:b0:2a6:16b5:2fc1 with SMTP id t8-20020a2e7808000000b002a616b52fc1mr1650988ljc.23.1680967324115;
        Sat, 08 Apr 2023 08:22:04 -0700 (PDT)
Received: from localhost ([2a00:4820:4370:1100:7604:f1ff:fe0c:2c95])
        by smtp.gmail.com with ESMTPSA id l10-20020ac2554a000000b004dc4b00a1eesm1208789lfk.261.2023.04.08.08.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Apr 2023 08:22:03 -0700 (PDT)
References: <20230408122429.1103522-1-y86-dev@protonmail.com>
 <20230408122429.1103522-14-y86-dev@protonmail.com>
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
Subject: Re: [PATCH v7 13/15] rust: types: add `Opaque::ffi_init`
Date: Sat, 08 Apr 2023 17:21:19 +0200
In-reply-to: <20230408122429.1103522-14-y86-dev@protonmail.com>
Message-ID: <87h6tqs8kl.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


Benno Lossin <y86-dev@protonmail.com> writes:

> This function allows to easily initialize `Opaque` with the pin-init
> API. `Opaque::ffi_init` takes a closure and returns a pin-initializer.
> This pin-initiailizer calls the given closure with a pointer to the
> inner `T`.
>
> Co-developed-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Benno Lossin <y86-dev@protonmail.com>
> Cc: Alice Ryhl <aliceryhl@google.com>
> Cc: Andreas Hindborg <a.hindborg@samsung.com>
> ---

Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>

>  rust/kernel/init.rs  |  9 +++++++++
>  rust/kernel/types.rs | 20 ++++++++++++++++++++
>  2 files changed, 29 insertions(+)
>
> diff --git a/rust/kernel/init.rs b/rust/kernel/init.rs
> index ffd539e2f5ef..a1298c8bbda0 100644
> --- a/rust/kernel/init.rs
> +++ b/rust/kernel/init.rs
> @@ -177,6 +177,14 @@
>  //! }
>  //! ```
>  //!
> +//! For the special case where initializing a field is a single FFI-function call that cannot fail,
> +//! there exist the helper function [`Opaque::ffi_init`]. This function initialize a single
> +//! [`Opaque`] field by just delegating to the supplied closure. You can use these in combination
> +//! with [`pin_init!`].
> +//!
> +//! For more information on how to use [`pin_init_from_closure()`], take a look at the uses inside
> +//! the `kernel` crate. The [`sync`] module is a good starting point.
> +//!
>  //! [`sync`]: kernel::sync
>  //! [pinning]: https://doc.rust-lang.org/std/pin/index.html
>  //! [structurally pinned fields]:
> @@ -187,6 +195,7 @@
>  //! [`impl PinInit<T, E>`]: PinInit
>  //! [`impl Init<T, E>`]: Init
>  //! [`Opaque`]: kernel::types::Opaque
> +//! [`Opaque::ffi_init`]: kernel::types::Opaque::ffi_init
>  //! [`pin_data`]: ::macros::pin_data
>
>  use crate::{
> diff --git a/rust/kernel/types.rs b/rust/kernel/types.rs
> index ff2b2fac951d..3a46ec1a00cd 100644
> --- a/rust/kernel/types.rs
> +++ b/rust/kernel/types.rs
> @@ -2,6 +2,7 @@
>
>  //! Kernel types.
>
> +use crate::init::{self, PinInit};
>  use alloc::boxed::Box;
>  use core::{
>      cell::UnsafeCell,
> @@ -234,6 +235,25 @@ impl<T> Opaque<T> {
>          Self(MaybeUninit::uninit())
>      }
>
> +    /// Creates a pin-initializer from the given initializer closure.
> +    ///
> +    /// The returned initializer calls the given closure with the pointer to the inner `T` of this
> +    /// `Opaque`. Since this memory is uninitialized, the closure is not allowed to read from it.
> +    ///
> +    /// This function is safe, because the `T` inside of an `Opaque` is allowed to be
> +    /// uninitialized. Additionally, access to the inner `T` requires `unsafe`, so the caller needs
> +    /// to verify at that point that the inner value is valid.
> +    pub fn ffi_init(init_func: impl FnOnce(*mut T)) -> impl PinInit<Self> {
> +        // SAFETY: We contain a `MaybeUninit`, so it is OK for the `init_func` to not fully
> +        // initiailize the `T`.
> +        unsafe {
> +            init::pin_init_from_closure::<_, ::core::convert::Infallible>(move |slot| {
> +                init_func(Self::raw_get(slot));
> +                Ok(())
> +            })
> +        }
> +    }
> +
>      /// Returns a raw pointer to the opaque data.
>      pub fn get(&self) -> *mut T {
>          UnsafeCell::raw_get(self.0.as_ptr())

