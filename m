Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8B525C811
	for <patches@lists.linux.dev>; Fri,  2 May 2025 16:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746201763; cv=none; b=dy04G20W0UUP7rORPCV8SPS91Im10q6zAI0iar2pJ3o7KPrI2Xyrn0492sQFBTe6uxVKBKvXik+jAl2HhUqVmX+SkQv6hB6igGFVnwsjmc5I/fN2Mz878Qm/uxb6uRYynaoAVIHAN9jYJNwp6OxtpwrnxPuqsnFYjh/+0QX5CBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746201763; c=relaxed/simple;
	bh=UJ6WwhmFuVCqUdif14DkJqSkQxNVnMZG/jRa4NZF7Ko=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V8f8NCjpyJYxngUgJxIkPbSCH2YweWNwHq5yHJftOePgpSfs6EnyDGbY3rn8B0up/pvkqiDup+JNYqgoVC9Pt/PoPWEjYDRjQNL4i5kEXWUe1ypArdmJf9OBf5p5e7j7tinUzYrbBXV69D1H+1sPZHF7o5TplbrjpQQ4CfclQGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ken/KXOo; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ken/KXOo"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-54d6f933152so3021740e87.1
        for <patches@lists.linux.dev>; Fri, 02 May 2025 09:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746201760; x=1746806560; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bWXi6ouIHtCt+/SVmgFqOORSK5kSta3bTlozmNEeTOw=;
        b=ken/KXOoCUQ3sLrkOXDq1JDs5qfflFJlhaqQK1xTBCQFNTXg8D3ouyYfwoSfNQnih/
         nzPPbih5+5iA/upb9y19KsikfasGOoISWmrGfH5I3e996vgDf51RKBrF8Bzf+2jPVFK1
         l2uZ/q8/dcn9CvwVB3h1EEWJX2n6ban84R02/FIQml7DkWyOvoj9+Uq/rP63IYziibhN
         GKpTUDT2qywZQJ4uvhupg7PiV2THONhI3UB1p944VQPlp0XQ+jitRYw6TemXbFBLl+aF
         lVM/UHJa9I3teqanpulGs+snrvlWp47c9vXKwBnmL1r7NFwR2/m+JtbXvn8DIiAD21DK
         3fDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746201760; x=1746806560;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bWXi6ouIHtCt+/SVmgFqOORSK5kSta3bTlozmNEeTOw=;
        b=CaMdri0qXLlHRZSr6xjGG8xsbeYqBgpuMATq3zUtrr7/Cxl8+i/J7JqM2DZMhy+Z/X
         y/4I9KgGsRRNGrzQQHBX1uz6HzXsv+QUrvIpYDRy7jur6YvEiIyfB2HKON93ZTKj5TQr
         gMkD3IVXCuH+rgnyh3q7/bL9yfQBFVJnpIMljQrPc8V+wDRzdG8jiLGr3SsYQxTYZa7x
         F6lEdbfWBF2Q8aznBgy2+3yZfDCjPst6Zg8FUTnQvDCqfh++BRZgGIaYp/wAi0mDtH/4
         1XTX4Ct8iV63gsEwcE4yV5gBxBURMJGlcJDCPocH3wUM3SiB9CNiL9H7G+nHb2dtWcMB
         MZvQ==
X-Forwarded-Encrypted: i=1; AJvYcCWoFE6NV8Y6bsK9Im12WnpZulAqmXZXJHpKbEZOZDF8NPSzBraaPjskzDCs3ekgcosse//5i0nW@lists.linux.dev
X-Gm-Message-State: AOJu0Yw+Z29ydNGdmdJC2EIxnE/heAs5w41jLRoH+bXJnEEqy/RMluc/
	WIrP0RUiwkpi286SxM6qsJpNVR9fGglVDbm9zGRQpLi4cFy00kJXi12c4CA7F4XCzLavuGojq+f
	ZY49fUu5GQHbUZFXrusFAMiDJjLg=
X-Gm-Gg: ASbGnctMlihRVjSlMQjIEOrQgX3HBQ2aTrjk8HdZ9qkuyTtQkssDKYx3sI6yL9n0lHO
	pg83oF6PRL58b3aszI9lDKNAQiUjcuL51FiaqqGwn1e6Ltp0MJmP7DEY6hN2p+Q4cDXHsxsdTaP
	MU9gyV4IPTRw8J6OEivwsOI+uZ8fpxxpsKMDKR2A==
X-Google-Smtp-Source: AGHT+IFQVJp0oLfBErJDYrcvWauZBR16iubXjM5Ov20E4hDu+u4f8dcYnUxZFRb2GWq/A5s6LAVkaHyvKfsIiT02qF0=
X-Received: by 2002:a05:6512:3b0b:b0:545:a2f:22ba with SMTP id
 2adb3069b0e04-54eac242c91mr923495e87.37.1746201756548; Fri, 02 May 2025
 09:02:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250502140237.1659624-1-ojeda@kernel.org> <20250502140237.1659624-6-ojeda@kernel.org>
In-Reply-To: <20250502140237.1659624-6-ojeda@kernel.org>
From: Tamir Duberstein <tamird@gmail.com>
Date: Fri, 2 May 2025 09:01:59 -0700
X-Gm-Features: ATxdqUEluk2jv-DmfiRVYlxsy5N_uo2h5vdZh8glM634BlTDAbUSZr2VxhwzSKA
Message-ID: <CAJ-ks9=XJ_cX8=vCtAr8Qr+4iaX9fyc8+djiBmg8=FxJTggS9w@mail.gmail.com>
Subject: Re: [PATCH 5/5] rust: clean Rust 1.88.0's `clippy::uninlined_format_args`
 lint
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 2, 2025 at 7:04=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> Starting with Rust 1.88.0 (expected 2025-06-26) [1], `rustc` may move
> back the `uninlined_format_args` to `style` from `pedantic` (it was
> there waiting for rust-analyzer suppotr), and thus we will start to see

Typo: s/suppotr/support/

> lints like:
>
>     warning: variables can be used directly in the `format!` string
>        --> rust/macros/kunit.rs:105:37
>         |
>     105 |         let kunit_wrapper_fn_name =3D format!("kunit_rust_wrapp=
er_{}", test);
>         |                                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^=
^^^^^^^^^^^
>         |
>         =3D help: for further information visit https://rust-lang.github.=
io/rust-clippy/master/index.html#uninlined_format_args
>     help: change this to
>         |
>     105 -         let kunit_wrapper_fn_name =3D format!("kunit_rust_wrapp=
er_{}", test);
>     105 +         let kunit_wrapper_fn_name =3D format!("kunit_rust_wrapp=
er_{test}");
>
> There is even a case that is a pure removal:
>
>     warning: variables can be used directly in the `format!` string
>       --> rust/macros/module.rs:51:13
>        |
>     51 |             format!("{field}=3D{content}\0", field =3D field, co=
ntent =3D content)
>        |             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^=
^^^^^^^^^^^^
>        |
>        =3D help: for further information visit https://rust-lang.github.i=
o/rust-clippy/master/index.html#uninlined_format_args
>     help: change this to
>        |
>     51 -             format!("{field}=3D{content}\0", field =3D field, co=
ntent =3D content)
>     51 +             format!("{field}=3D{content}\0")
>
> The lints all seem like nice cleanups, thus just apply them.
>
> We may want to disable `allow-mixed-uninlined-format-args` in the future.
>
> Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned i=
n older LTSs).
> Cc: Benno Lossin <benno.lossin@proton.me>
> Link: https://github.com/rust-lang/rust-clippy/pull/14160 [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  drivers/gpu/nova-core/gpu.rs              |  2 +-
>  rust/kernel/str.rs                        | 46 +++++++++++------------
>  rust/macros/kunit.rs                      | 13 ++-----
>  rust/macros/module.rs                     | 19 +++-------
>  rust/macros/paste.rs                      |  2 +-
>  rust/pin-init/internal/src/pinned_drop.rs |  3 +-
>  6 files changed, 35 insertions(+), 50 deletions(-)

Reviewed-by: Tamir Duberstein <tamird@gmail.com>
