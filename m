Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE681C3BE0
	for <patches@lists.linux.dev>; Fri,  1 Aug 2025 17:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754070975; cv=none; b=YnXfR8ZsfxJa0/2qWvBOznhYl/jdXcPUPYFU69/vcU1IofGwyr9kb+Pat+VqIux8o4ndfmK7UemQNw8v3JEOt72EZ+ZHnT2pmKic+mEG8FyD7tclKha6wFoaLzTSHz4x3THODn23k3/Ec2NLflmjFDEIj/6BeILvaKK4m0WrJuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754070975; c=relaxed/simple;
	bh=0M/tJPfKsbYH+xw3E6m9VJlr0c68OrqSrrrzuvjYw3Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CnJElnopjjYDI2n3n3XiNfgGvVE5KzPAoqz1HjTefpFfH8VvdZTiW5nQmSv/apKf4AagXdvUZw2iiF09nIQOWaRG87kIelWDgATOKxo26Q6OM0K/PP4tkDSkjkJmMZsoGbxYTTAy/HQVg9loogMvCz1QO0qLkP2gDOpNSROG7pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V015e3Dv; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V015e3Dv"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-458aee6e86aso6306645e9.3
        for <patches@lists.linux.dev>; Fri, 01 Aug 2025 10:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754070971; x=1754675771; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zfAsYAfR+/YK9jsRvUDbKg5u2kXyF1RTviQ65IrOhxo=;
        b=V015e3Dv0jlgrUg4j1czV2BaL2eWP64QWVn1UsVsUM8yWLXUy6yHZZbWbUq+MACix0
         kijoe1gNmFHF6oewfcSHeX87SZWWFSEvy/JKxeh45J9bp60+2p7SethVkleqwRV+NwXV
         iZvvHAwtKbnOuKHTEXCeohveq9ZPga6gnkLf+3lv+rjNVpeFT9sQGK0FA4L4SZBqIFJq
         vfguBD4XjOLsEVj9sD2JpiimH5pPyRbgMTfD0ze6+ozzP7Td/KemR+YS+O7xzwGiNknu
         zcbFkinPSSc6lT389BTz8OZEDbYRWwY/+p3fpUDjms9ABVQqFPsM6Wpo3wl0wTnqBKI7
         fhxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754070971; x=1754675771;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zfAsYAfR+/YK9jsRvUDbKg5u2kXyF1RTviQ65IrOhxo=;
        b=hy9RPWsgJcYektfrU2G6YwLmndGI1ovgr3kEO0JJLorQCK/eyP3OWYiGlwl3M6rN5M
         IWIhEqcHIJhBueglQu5oRH/4Dvk+CU3EYQ9lpE+x+xm/dM9bq9FdDljXOKaeJgP9NYQ/
         YUyoAElltJPlAtyQciUbzoQvpH1cCSbVAFuTLuH5zrlKufoWr4tdkIwxHQg/RdxmJ6zs
         w3XaO9yVFBXf9L/TuqPeoLFeoiuQzt1muM44L3xbvzilOokYtz2B3jQIstPo2UAR3HfH
         3ceLbPagPNKob/YCtaaW+9+hIwIPLQ2fU4Og3ONcA75ha5Wr1NQTwY5OD0bGhA2Y04+R
         V0Tg==
X-Forwarded-Encrypted: i=1; AJvYcCUNWQH4p71MjfEnzNcwk7ZsUfZQgKLVC5ZzY/Lkv+mxoEcMp71/elmAlb0LQOvxjFRfkpV8as5v@lists.linux.dev
X-Gm-Message-State: AOJu0YyHbkZDslMB3ioujs9RuJh94gZxb9HhZhD7AY1DEP44+Wod0x5L
	2nZ/VOKnhkhUx2iRgUJGSMUjFzl5LieeLdaqFSNtYwgbFQmtzOL0t1XDcMzbXX4Zspy3zr4ZpTM
	tDmw6DvOCwnx67PBVNWiOQyl3UyoKuS78GiJAXuyt
X-Gm-Gg: ASbGncsa7asIwqKFLz9eAGu2/n5Jqicx4gaDqfgTr97bCJjo/gjOHuqJ5FHIDhSVGhS
	/M5x8LnXSB/zrXxzjld0x5s8l0wdPBrYhSuWHUXSW2Zq9QbjwgOPsh0AINeTyHzIujL6eJGFNZ9
	mhmfQ7LQe6jbXk247aSkG99E+XNHz/MrjA2jvRKP9k+Y6R/1RaFcS/hSn+okh5kNwVThLL9hCyj
	ZqpWZd+
X-Google-Smtp-Source: AGHT+IH5iyoraxt1MqhsOV7Wo1Vl0oy/M8gdsqvDQuvj38MG42AcgPxCKrGsYFjRYglZAErHpBINtAm5x8csp6uGERE=
X-Received: by 2002:a05:6000:401f:b0:3b7:8914:cd94 with SMTP id
 ffacd0b85a97d-3b8d94c1367mr465035f8f.41.1754070970934; Fri, 01 Aug 2025
 10:56:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250801161752.443431-1-ojeda@kernel.org>
In-Reply-To: <20250801161752.443431-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Fri, 1 Aug 2025 19:55:59 +0200
X-Gm-Features: Ac12FXyPfPflOZinXuov3eku6WJJUyueclLsgVuYKQ--6v94gWhcCn1e-LQsq6c
Message-ID: <CAH5fLghFKZgW8T82ZKQNAANfhGBEQG2oLE2rmUOAb6N9UDEMhw@mail.gmail.com>
Subject: Re: [PATCH] rust: prelude: re-export `core::mem::{align,size}_of{,_val}`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Alexandre Courbot <acourbot@nvidia.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 1, 2025 at 6:18=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> Rust 1.80.0 added:
>
>     align_of
>     align_of_val
>     size_of
>     size_of_val
>
> from `core::mem` to the prelude [1].
>
> For similar reasons, and to minimize potential confusion when code may
> work in later versions but not in our current minimum, add it to our
> prelude too.
>
> Link: https://github.com/rust-lang/rust/pull/123168 [1]
> Link: https://lore.kernel.org/rust-for-linux/CANiq72kOLYR2A95o0ji2mDmEqOK=
h9e9_60zZKmgF=3DvZmsW6DRg@mail.gmail.com/ [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  rust/kernel/prelude.rs | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/rust/kernel/prelude.rs b/rust/kernel/prelude.rs
> index 25fe97aafd02..198d09a31449 100644
> --- a/rust/kernel/prelude.rs
> +++ b/rust/kernel/prelude.rs
> @@ -12,7 +12,10 @@
>  //! ```
>
>  #[doc(no_inline)]
> -pub use core::pin::Pin;
> +pub use core::{
> +    mem::{align_of, align_of_val, size_of, size_of_val},
> +    pin::Pin,
> +};
>
>  pub use ::ffi::{
>      c_char, c_int, c_long, c_longlong, c_schar, c_short, c_uchar, c_uint=
, c_ulong, c_ulonglong,
>
> base-commit: dff64b072708ffef23c117fa1ee1ea59eb417807
> --
> 2.50.1
>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
