Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BFF75817
	for <patches@lists.linux.dev>; Tue,  6 Aug 2024 18:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722969049; cv=none; b=mLJCNx1GlCQGrii9Aq38/eWu7mZ9gEgn+VKC+f4SOxwE4FpVmadDjqQwcqVo8qSDTchh4wL2D0oTUFo3JgUDC09Wkrt4Nfl0Q7WODcP82IgnZGiNT6ccRGhxSWVEffiUDu2ghgzUOXpr4pWRdXvoZP0o2nxgLgRinAR983yy2vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722969049; c=relaxed/simple;
	bh=oe38/BA3I3GPzGRZcA4tK3QobjJz3lxhxxE69sqobgM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KxtrWtmSCAKm3URQlTop17+F4D3P/f5qd+m9KQKAQf6m4/cZQzVIEkk/N6OE6jvCT4s8ANTN3ZLktlcNPZ1ZdZGhTp9EAcNep627xWQwDirglJqL+orxqBaDPUMiqtB6RbXymfXim0OntDJ6CmrQJdnJySLfMU0cexyLNRap+L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu; spf=pass smtp.mailfrom=umich.edu; dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b=EBQZWnRO; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=umich.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b="EBQZWnRO"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-66ca536621cso10777627b3.3
        for <patches@lists.linux.dev>; Tue, 06 Aug 2024 11:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03; t=1722969045; x=1723573845; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AJcjEsELElj17ftf1H3NNxeE2XuKAN8uQ1oS0Kp4OuE=;
        b=EBQZWnROFH2TmQ/C8W1LjjF33v0uHgmALblqwqjj9QVCKqyJiV6cMe7iIbtWkaNLHg
         GDiVHCFutPXCy1h7ZmBQE3h3lZyMkBOwaVPj0BIdmQYf1plbuOznnmgMgffpYRlVEUJP
         atbf+hUfBF8FhSAli8qhRsMFv/f9Hr04QkCdVsmWLwR8Xe0fjtTYyIdbxraoFlsvYDJf
         8PajRInYzYbcv5vMe0pP3qmugYWKcrZTpVFPjbR76RLyxZc8jJGVUbjr0UZPrnAEjmG9
         3gJH3ZovmNz8wPuK80lkheKKysiqr23C9R2wiDhEZR+k0sD76LNxxCMJIA28JL4IVtjW
         hKVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722969045; x=1723573845;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AJcjEsELElj17ftf1H3NNxeE2XuKAN8uQ1oS0Kp4OuE=;
        b=izKDD6kNf0zdSHZ5Co4FUW+hiPcBLZabwkXiHihRW37foXDddrvKJCEsWG5lk6cpvd
         /T43HvSRsxsQ2b8Xs5llPd0juOMMyjMn3QiI9QeI0k0Zz8MndKZ4UwKDs0QmN3QcLmXp
         qrEyE+IxXYJQgz/z92RPMonj1Lk+GBj6eh5MzJY0J+qMyf0UuUwEph39rlFO474BsdQG
         6Cu8z8Hj3mXuaE4dR6IWS73d6XB8E1LyBo4mRiCgi+BHZ0lK4Md6yeb1HBReYz2w9N4P
         dGPT0XHpv2wddgZR3EYEhPmJBdyWN/1rLZr1VV7Gv9KmHMB9d6e7dBtDgbaE2lTKeZKE
         r00A==
X-Forwarded-Encrypted: i=1; AJvYcCWxiO+SW8luRmbDSZEHzYA0Gpxdg4nJgnUGJagwtiEzdlCiYkydVF45ChMUJfp0CoMXAwoZk7NQSHHKELQI+YB2RETF/IlAAA==
X-Gm-Message-State: AOJu0YzEbQYJuQgtZwfVYwh7jbElixfZqzqaI5FlX9Dxtbj1ZIQGkLFJ
	dIDv7wgd3ka8Zc+Qt7ncrMiBge2ti7BhWscYC/JTYSItumnJj7lgKZ6/7CWmzI88AB0k7Dyo7HL
	A9TtB9GX3UoXf+muJ3tPURHFZYyQzcgIpGv4HBg==
X-Google-Smtp-Source: AGHT+IEi5wEKcxYijrCG9lZ62HVarFC1N/dov62z2Vvk1px7mbW2C3yfR+rXHXlo0cHub/OfafmZkMejgkYcoEw+XE8=
X-Received: by 2002:a81:5b06:0:b0:65f:9e35:af1a with SMTP id
 00721157ae682-68964590c97mr153755347b3.41.1722969045434; Tue, 06 Aug 2024
 11:30:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240806150619.192882-1-ojeda@kernel.org>
In-Reply-To: <20240806150619.192882-1-ojeda@kernel.org>
From: Trevor Gross <tmgross@umich.edu>
Date: Tue, 6 Aug 2024 14:30:33 -0400
Message-ID: <CALNs47swnK6je1o+LOLUFCDEZJmQmZx8vZ+7MPvUbNKdFr_Q_Q@mail.gmail.com>
Subject: Re: [PATCH] rust: add intrinsics to fix `-Os` builds
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Nathan Chancellor <nathan@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, llvm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 6, 2024 at 11:06=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Alice reported [1] that an arm64 build failed with:
>
>     ld.lld: error: undefined symbol: __extendsfdf2
>     >>> referenced by core.a6f5fc5794e7b7b3-cgu.0
>     >>>               rust/core.o:(<f32>::midpoint) in archive vmlinux.a
>     >>> referenced by core.a6f5fc5794e7b7b3-cgu.0
>     >>>               rust/core.o:(<f32>::midpoint) in archive vmlinux.a
>
>     ld.lld: error: undefined symbol: __truncdfsf2
>     >>> referenced by core.a6f5fc5794e7b7b3-cgu.0
>     >>>               rust/core.o:(<f32>::midpoint) in archive vmlinux.a
>
> Rust 1.80.0 or later together with `CONFIG_CC_OPTIMIZE_FOR_SIZE=3Dy`
> is what triggers it.
>
> In addition, x86_64 builds also fail the same way.
>
> Similarly, compiling with Rust 1.82.0 (currently in nightly) makes
> another one appear, possibly due to the LLVM 19 upgrade there:
>
>     ld.lld: error: undefined symbol: __eqdf2
>     >>> referenced by core.20495ea57a9f069d-cgu.0
>     >>>               rust/core.o:(<f64>::next_up) in archive vmlinux.a
>     >>> referenced by core.20495ea57a9f069d-cgu.0
>     >>>               rust/core.o:(<f64>::next_down) in archive vmlinux.a
>
> Gary adds [1]:
>
> > Usually the fix on rustc side is to mark those functions as `#[inline]`
> >
> > All of {midpoint,next_up,next_down} are indeed unstable functions not
> > marked as inline...
>
> Fix all those by adding those intrinsics to our usual workaround.
>
> Cc: Gary Guo <gary@garyguo.net>
> Reported-by: Alice Ryhl <aliceryhl@google.com>
> Closes: https://rust-for-linux.zulipchat.com/#narrow/stream/288089-Genera=
l/topic/v6.2E11-rc1.20doesn't.20build.20for.20arm64/near/455637364

Should this link have the `[1]`?

> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  rust/Makefile             | 4 ++--
>  rust/compiler_builtins.rs | 3 +++
>  2 files changed, 5 insertions(+), 2 deletions(-)

Reviewed-by: Trevor Gross <tmgross@umich.edu>

Also submitted a fix upstream https://github.com/rust-lang/rust/pull/128749=
.

- Trevor
