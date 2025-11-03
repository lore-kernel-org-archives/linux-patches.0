Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D4413D503
	for <patches@lists.linux.dev>; Mon,  3 Nov 2025 17:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762192105; cv=none; b=kwcUXGP/AAiaFAhMq31itmZHeDB/YmSq5ff5AdufW+8Mz1WQuT7IBlDDO1ZjF9/UYMkS93cN+TVEb0HOVGVcK59lTDHiGUGWglAAGDewHsxMdP9igqb3OKSYxSXZH0Xwee3FKH9Nc4akKCDUy1oEzxS4NXHgNQb5e11qNr4Rv4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762192105; c=relaxed/simple;
	bh=DZohdGmwhvfS7Y62yh/IEXkOppV7V3lqoMgTejWulFA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T31D/EZyG45De5w7eHmNtadpIOYQnqecogvhsG2bp6glOXGwWW+GJK1Wue/SdH7cXEWE0jWuICn1r5STl0rpQ1VShEqyXtxi7rLwASfTnqqie75WkWbB/dcg1cNGxHiYrhgzW/ThtOMLC9k+pkkrhMaAYchuzs636BGtOuuwMlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linuxtx.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=YM8rL4z1; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="YM8rL4z1"
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-433100c59dcso13114545ab.0
        for <patches@lists.linux.dev>; Mon, 03 Nov 2025 09:48:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1762192103; x=1762796903; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nWkOe5YDiqYERha5LD7zMqeSoJ/N7fJr/JJ2cnjXNyg=;
        b=YM8rL4z118NgeHlaePRQCwKv9/vSmhlC5Ewal7rM+QFONV7laCbjqmm57hpNkO7OP1
         RHHuLlsY0e4ig3JNNtp4qM7F2e2K2463wHwN67ziqKNo1m8yjisWq1F0K35d32EC2m7A
         8W/FpjrZ/fKVsXfMLfNeMOwKs4f4sqXrdzhds=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762192103; x=1762796903;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nWkOe5YDiqYERha5LD7zMqeSoJ/N7fJr/JJ2cnjXNyg=;
        b=txOH7qfwJcu+uRRHH49OcmDnv2QGXE0IhbkwrUjQOJhu1n0d/7L1TZ3muzSo2kA5OZ
         GuxUUi08M5NB39tA9547mQ+nAsyXFgR2mV67RK+QNq0FK5pR/B80Rx3JidSPHcXsmjTy
         +c0iAIRoLahk4836IMiza0zx8L3PsJY04+7pyLF5Snas98E5s0OWFEO4ntyNoHk15Gud
         99sC1SpRMTqRk6Qv9GVVTwFqA9XcyDSKbOJGQBP40qP14vh10Ef6wVhf7xgazdemtPWl
         Vuzkx3f55Uk3FWDokgxKxWiqu2PLZmzGIRsF8ZU6Ts8aD4RYJTLdGaokt1IiiDCeUqHa
         lDfA==
X-Forwarded-Encrypted: i=1; AJvYcCXuyk6p+poskTx5+sEhm1hnegWuyKKc0bCdYuce90uIXgDFjkFg8V6wYlqT+ePn/r2+kxwIOW/i@lists.linux.dev
X-Gm-Message-State: AOJu0Yy6vdUA2/wi7OYazoDJfVyVCEJQYDBak8gD8wqALp1o3GmqOJ0v
	IZXxBxcTkfS7twu3Ma0s48NfMNviSTjp6sVK5qtq8pxFm1IwLfRMcWpJY6ybTq0QgMFfR7/2IeM
	z4LA4ldgTGlLBi4xG0SnmGXgaLFk1wBt1LusQNAaG
X-Gm-Gg: ASbGncurSmIAJ6oRAQ2+jgowE6GJiUFPqu0YlqS4vnmTHHJhT61Ftg62hPhZd4bE5Ae
	+U7DjSV3nCHgMrW+kePBLZEhvkn3RCJAhRvbnXw6fK5JAXzQAw3woYcISfgneiGUtms8hxvYt6H
	GICjFf48uALgsNqzOGfzZ5X8fR9/DM7cLDX9MMLPZv6iVdP65+fiqZH9LhH3RNPvwTzuYYdOQUX
	J8PFKfEljUr2HAB80cQF0oys8UjqWNBf6+RRWUfXd3dIMwYultpJEwSE6VRyA==
X-Google-Smtp-Source: AGHT+IF9g9cwwuNwEQElfAQDhH0pHEpQX+9ymSaDZSx7wt1xXs7tDoLgwlfGaAsR869GJ5w28gauCBpymwrx1MG7HaA=
X-Received: by 2002:a05:6e02:470e:b0:433:22fc:bb9a with SMTP id
 e9e14a558f8ab-43322fcc5d4mr112236115ab.13.1762192102332; Mon, 03 Nov 2025
 09:48:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251102212853.1505384-1-ojeda@kernel.org> <20251102212853.1505384-2-ojeda@kernel.org>
 <aQiDdZvRNrBkrB-U@google.com>
In-Reply-To: <aQiDdZvRNrBkrB-U@google.com>
From: Justin Forbes <jmforbes@linuxtx.org>
Date: Mon, 3 Nov 2025 10:48:11 -0700
X-Gm-Features: AWmQ_blfBw9zTFrICe8pc1ZBkE8gZV528mb4K6Tu6zlEDetF0EtgCfFYO7hVTdg
Message-ID: <CAFxkdArACiepmcjk7GFH313db4cpXDcWouVy4a6zQTMR1aDmPA@mail.gmail.com>
Subject: Re: [PATCH 2/2] rust: kbuild: workaround `rustdoc` doctests modifier bug
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 3, 2025 at 3:28=E2=80=AFAM Alice Ryhl <aliceryhl@google.com> wr=
ote:
>
> On Sun, Nov 02, 2025 at 10:28:53PM +0100, Miguel Ojeda wrote:
> > The `rustdoc` modifiers bug [1] was fixed in Rust 1.90.0 [2], for which
> > we added a workaround in commit abbf9a449441 ("rust: workaround `rustdo=
c`
> > target modifiers bug").
> >
> > However, `rustdoc`'s doctest generation still has a similar issue [3],
> > being fixed at [4], which does not affect us because we apply the
> > workaround to both, and now, starting with Rust 1.91.0 (released
> > 2025-10-30), `-Zsanitizer` is a target modifier too [5], which means we
> > fail with:
> >
> >       RUSTDOC TK rust/kernel/lib.rs
> >     error: mixing `-Zsanitizer` will cause an ABI mismatch in crate `ke=
rnel`
> >      --> rust/kernel/lib.rs:3:1
> >       |
> >     3 | //! The `kernel` crate.
> >       | ^
> >       |
> >       =3D help: the `-Zsanitizer` flag modifies the ABI so Rust crates =
compiled with different values of this flag cannot be used together safely
> >       =3D note: unset `-Zsanitizer` in this crate is incompatible with =
`-Zsanitizer=3Dkernel-address` in dependency `core`
> >       =3D help: set `-Zsanitizer=3Dkernel-address` in this crate or uns=
et `-Zsanitizer` in `core`
> >       =3D help: if you are sure this will not cause problems, you may u=
se `-Cunsafe-allow-abi-mismatch=3Dsanitizer` to silence this error
> >
> > A simple way around is to add the sanitizer to the list in the existing
> > workaround (especially if we had not started to pass the sanitizer
> > flags in the previous commit, since in that case that would not be
> > necessary). However, that still applies the workaround in more cases
> > than necessary.
> >
> > Instead, only modify the doctests flags to ignore the check for
> > sanitizers, so that it is more local (and thus the compiler keeps check=
ing
> > it for us in the normal `rustdoc` calls). Since the previous commit
> > already treated the `rustdoc` calls as kernel objects, this should allo=
w
> > us in the future to easily remove this workaround when the time comes.
> >
> > By the way, the `-Cunsafe-allow-abi-mismatch` flag overwrites previous
> > ones rather than appending, so it needs to be all done in the same flag=
.
> > Moreover, unknown modifiers are rejected, and thus we have to gate base=
d
> > on the version too.
>
> Ah .. we may want to file a bug for that.
>
> > Finally, `-Zsanitizer-cfi-normalize-integers` is not affected, so it is
> > not needed in the workaround.
> >
> > Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned=
 in older LTSs).
> > Link: https://github.com/rust-lang/rust/issues/144521 [1]
> > Link: https://github.com/rust-lang/rust/pull/144523 [2]
> > Link: https://github.com/rust-lang/rust/issues/146465 [3]
> > Link: https://github.com/rust-lang/rust/pull/148068 [4]
> > Link: https://github.com/rust-lang/rust/pull/138736 [5]
> > Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
>
> Reviewed-by: Alice Ryhl <aliceryhl@google.com>

I can verify that this fixes kernel builds with rust 1.91 in Fedora.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
