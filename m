Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF3D2904
	for <patches@lists.linux.dev>; Fri, 31 Mar 2023 13:03:45 +0000 (UTC)
Received: by mail-wr1-f45.google.com with SMTP id d17so22294949wrb.11
        for <patches@lists.linux.dev>; Fri, 31 Mar 2023 06:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metaspace-dk.20210112.gappssmtp.com; s=20210112; t=1680267823;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=nDWXEeZ/uffescHeQSMnMnwMWLgrz19ofXim1Y+HCJI=;
        b=lX3rTtbdKu1vFSdVWAWg2eJdqkpxKvBOZ8N9aru4GUYxwpnKmO4v5GkonTvRrgwTGR
         HfLeQ7BxHeMMVucPjj/49KxJb5bMkRD+5SoVmm8rD6srvx3qWvM7rqOFgys4i+PTDF+L
         UhUpNEsv4Cxbv9CXNVb5JesIHM28Z4EWp2H171ir/lUz8HCgoUlYKxlvBCqcqKFkE/Yc
         LJER3dRIKT8A6xTu1MTObKbLqvpKlIfK+uZ9r029ZaLyVZUiEgLYQZ5dcJiYULnewp63
         jKAUmnB2w8bY1SNxHX/4Kp/PWENfAa2kgoXENGpDzwbWJjxI5WdAva26gYqU2rshG1Bw
         deZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680267823;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nDWXEeZ/uffescHeQSMnMnwMWLgrz19ofXim1Y+HCJI=;
        b=SkQ0pRtJTM+4Dx9qcWK3VWoAGUh6VEHmVX+ndyiMU/MbZlQrqHCjdJ9Rwlz7Raz7tc
         SDfBV7Ff05Y4yF7QScOtHLImcn1k3iePnwcF0Z/298Hw7BtyUMtR5sVsd/ZjFwbODP8a
         V7yGru7jrtfQZXXOpcGr+hE67jrTWClSRNi0pHjHcId4yX7HePJkZknAl+J37JCJ9kwS
         gQBPyVvehMuqON+f+1Ig375/KW+vTZq+WXn4guyYmreUQ/IqzrMv6Sr2j3ENSbyVw20/
         bMeFsZD0NUC+lxsegLDt272MhuCXc0nYEWPy9RHuxqjb1I6QwDq8m3gEE3HYMeqgi/E0
         SrmQ==
X-Gm-Message-State: AAQBX9fwisnIRd82De4PZcZbyHgcnWe7GrlPueMh/DwuAdwH4CKNUPmA
	L1FF1HMyRG3/A56ie3ccoicQRw==
X-Google-Smtp-Source: AKy350ZZHCgT2mEkocVnvWxY7Ky32Zu24CV0Urt8TyunzkJdaWlOuvWE49D88zrNIH3z7838cgvajA==
X-Received: by 2002:a5d:6dcc:0:b0:2ce:ab76:cc8c with SMTP id d12-20020a5d6dcc000000b002ceab76cc8cmr7486660wrz.2.1680267823444;
        Fri, 31 Mar 2023 06:03:43 -0700 (PDT)
Received: from localhost ([165.225.194.194])
        by smtp.gmail.com with ESMTPSA id o5-20020adfcf05000000b002c592535839sm2183743wrj.17.2023.03.31.06.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 06:03:43 -0700 (PDT)
References: <20230329223239.138757-13-y86-dev@protonmail.com>
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
Subject: Re: [PATCH v3 12/13] rust: sync: reduce stack usage of
 `UniqueArc::try_new_uninit`
Date: Fri, 31 Mar 2023 15:03:13 +0200
In-reply-to: <20230329223239.138757-13-y86-dev@protonmail.com>
Message-ID: <87355l2hu9.fsf@metaspace.dk>
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
> ---

Reviewed-by Andreas Hindborg <a.hindborg@samsung.com>

>  rust/kernel/lib.rs      |  1 -
>  rust/kernel/sync/arc.rs | 14 ++++++++++++--
>  2 files changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
> index 3e2777d26ff5..d9df77132fa2 100644
> --- a/rust/kernel/lib.rs
> +++ b/rust/kernel/lib.rs
> @@ -27,7 +27,6 @@
>  #[cfg(not(CONFIG_RUST))]
>  compile_error!("Missing kernel configuration for conditional compilation");
>
> -#[allow(unused_extern_crates)]
>  // Allow proc-macros to refer to `::kernel` inside the `kernel` crate (this crate).
>  extern crate self as kernel;
>
> diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
> index 77a3833cc265..4ed6329a5e5f 100644
> --- a/rust/kernel/sync/arc.rs
> +++ b/rust/kernel/sync/arc.rs
> @@ -18,6 +18,7 @@
>  use crate::{
>      bindings,
>      error::{Error, Result},
> +    init,
>      init::{InPlaceInit, Init, PinInit},
>      types::{ForeignOwnable, Opaque},
>  };
> @@ -29,6 +30,7 @@ use core::{
>      pin::Pin,
>      ptr::NonNull,
>  };
> +use macros::pin_data;
>
>  /// A reference-counted pointer to an instance of `T`.
>  ///
> @@ -121,6 +123,7 @@ pub struct Arc<T: ?Sized> {
>      _p: PhantomData<ArcInner<T>>,
>  }
>
> +#[pin_data]
>  #[repr(C)]
>  struct ArcInner<T: ?Sized> {
>      refcount: Opaque<bindings::refcount_t>,
> @@ -501,9 +504,16 @@ impl<T> UniqueArc<T> {
>
>      /// Tries to allocate a new [`UniqueArc`] instance whose contents are not initialised yet.
>      pub fn try_new_uninit() -> Result<UniqueArc<MaybeUninit<T>>> {
> -        Ok(UniqueArc::<MaybeUninit<T>> {
> +        // INVARIANT: The refcount is initialised to a non-zero value.
> +        let inner = Box::init(init!(ArcInner {
> +            // SAFETY: There are no safety requirements for this FFI call.
> +            refcount: Opaque::new(unsafe { bindings::REFCOUNT_INIT(1) }),
> +            data <- init::uninit(),
> +        }))?;
> +        Ok(UniqueArc {
>              // INVARIANT: The newly-created object has a ref-count of 1.
> -            inner: Arc::try_new(MaybeUninit::uninit())?,
> +            // SAFETY: The pointer from the `Box` is valid.
> +            inner: unsafe { Arc::from_inner(Box::leak(inner).into()) },
>          })
>      }
>  }

