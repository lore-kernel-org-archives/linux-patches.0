Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA0033E9
	for <patches@lists.linux.dev>; Tue,  2 May 2023 17:00:07 +0000 (UTC)
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-b9da6374fa2so5036699276.0
        for <patches@lists.linux.dev>; Tue, 02 May 2023 10:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683046806; x=1685638806;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2JuzgaRSwqX93Paz8QMIW2w6sN1tsO1/zDhr8bQyJhU=;
        b=eFRn/beJBSstmGMrZtoYnDVn0LbYK/XQfQeez8QUz+OFuKfJjo5HdP0RhIVCl/oKoQ
         0beAEmckSFMVmC/FvrSqxNkyd/oze7dqbUYNYYXtZhFLwp34FhEmy+PyxECIglxEob3b
         h61xNGFSSStI3aKEEiSetu0lubr5OPti/2v7lBAYxz11WmypJFzep6Du33BINW45Xa4O
         QtyuxfJjPl03PTmspIcq4lRLFMIhqbtK2KGRY8b4JK4IZrUKw8SSqo8G/pv8cFF5w2s0
         XU7leAQ+qTmAmfsJTn6tZGCiJNOZrrU7hDNgd9diAFWPrLAfzfDGiMxJsJdhUtD1u7pq
         XA8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683046806; x=1685638806;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2JuzgaRSwqX93Paz8QMIW2w6sN1tsO1/zDhr8bQyJhU=;
        b=MnHk80qe5EK4a2Oi5OfJvsfUelHn/utVyXVSmY2XwAfTGG15ElmVD+dIA6AuMNlvSC
         U35aTx2qpIZ7IrKGKVCPp+TTa9lz+PTJNuG2k4oL0jn+TVSmfaQTNuSqs8NmMfVLl4Fu
         uQt2vDiDAnsPOMGNInERVmG/9n+e7Z/VC1jlQH3gsZRysLtLKF4MVpEAXqtvwU2Zy3uH
         AevDVDDxLTgKKBv+hd5v3o1ri1tBCJ68y5HAAcaMJYjPbezJsLMpon9Gl2RH1cdKZXPH
         PsLESqxIgQxOjMpR7kxyq6OA2rHnM9CSvPxgaFMpxa32SN6Qe/F0lonfuqtyOloj45CU
         lqjQ==
X-Gm-Message-State: AC+VfDxFyONdvM68iPHL8Jt0fopjME9uiYV26HVQiDrRFyo/4NNwx5cR
	bv66LQTg3fdMcPdFnQlTnUGZVFsHa926CjT4sUo=
X-Google-Smtp-Source: ACHHUZ6bE/xq2Qn+iEAMe8Oxl5bvh8V3EXlR1Li/Xdmzx4xFCozf90pZSHDYVUQp6VAj57DeQOOyUAOUucuphEvie0U=
X-Received: by 2002:a25:cd45:0:b0:b9d:7887:4423 with SMTP id
 d66-20020a25cd45000000b00b9d78874423mr12778541ybf.16.1683046806559; Tue, 02
 May 2023 10:00:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230502125306.358283-1-aliceryhl@google.com>
In-Reply-To: <20230502125306.358283-1-aliceryhl@google.com>
From: Wedson Almeida Filho <wedsonaf@gmail.com>
Date: Tue, 2 May 2023 13:59:56 -0300
Message-ID: <CANeycqo+htksD_nj-eyCTOtE0TQHJR+dHZ1Hu8cL5eXNt4cd=A@mail.gmail.com>
Subject: Re: [PATCH] rust: str: add conversion from `CStr` to `CString`
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Tue, 2 May 2023 at 09:53, Alice Ryhl <aliceryhl@google.com> wrote:
>
> These methods can be used to copy the data in a temporary c string into
> a separate allocation, so that it can be accessed later even if the
> original is deallocated.
>
> The API in this file mirrors the standard library API for the `&str` and
> `String` types. The `ToOwned` trait is not implemented because it
> assumes that allocations are infallible.
>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
>  rust/kernel/str.rs | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>
> diff --git a/rust/kernel/str.rs b/rust/kernel/str.rs
> index b771310fa4a4..54935ff3a610 100644
> --- a/rust/kernel/str.rs
> +++ b/rust/kernel/str.rs
> @@ -2,6 +2,7 @@
>
>  //! String representations.
>
> +use alloc::collections::TryReserveError;
>  use alloc::vec::Vec;
>  use core::fmt::{self, Write};
>  use core::ops::{self, Deref, Index};
> @@ -199,6 +200,12 @@ impl CStr {
>      pub unsafe fn as_str_unchecked(&self) -> &str {
>          unsafe { core::str::from_utf8_unchecked(self.as_bytes()) }
>      }
> +
> +    /// Convert this [`CStr`] into a [`CString`] by allocating memory and
> +    /// copying over the string data.
> +    pub fn to_cstring(&self) -> Result<CString, TryReserveError> {
> +        CString::try_from(self)
> +    }
>  }
>
>  impl fmt::Display for CStr {
> @@ -584,6 +591,20 @@ impl Deref for CString {
>      }
>  }
>
> +impl<'a> TryFrom<&'a CStr> for CString {
> +    type Error = TryReserveError;

Wouldn't `AllocError` make more sense? Or even Error (with ENOMEM value).

`TryReserveError` is documented as "The error type for try_reserve
methods." -- that fact the we use a `Vec` is an implementation detail,
I feel it's better not to leak this fact through the public API.

> +
> +    fn try_from(cstr: &'a CStr) -> Result<CString, TryReserveError> {
> +        let len = cstr.len_with_nul();
> +        let mut buf = Vec::try_with_capacity(len)?;
> +        buf.try_extend_from_slice(cstr.as_bytes_with_nul())?;
> +
> +        // INVARIANT: The CStr and CString types have the same invariants for
> +        // the string data, and we copied it over without changes.
> +        Ok(CString { buf })
> +    }
> +}
> +
>  /// A convenience alias for [`core::format_args`].
>  #[macro_export]
>  macro_rules! fmt {
>
> base-commit: ea76e08f4d901a450619831a255e9e0a4c0ed162
> --
> 2.40.1.495.gc816e09b53d-goog
>
