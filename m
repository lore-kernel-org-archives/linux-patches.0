Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FFEB194AD9
	for <patches@lists.linux.dev>; Thu,  5 Sep 2024 08:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725524282; cv=none; b=PyzjPJt8+pWcSodEtgFr24Sy50uvrUtSEmM0hfrWr6AfbrvxNasThoc3DfhK8dxkFBRosmOnIzi5hlVJWjpU8/xbUr3llKGkO7WSpdScQDIGps7UUXqPFEZOhoctDsPYkhZ/E2HYpWarwrsRPV+2lyMsEASyfO4MmUr/zXPZPHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725524282; c=relaxed/simple;
	bh=7Y9mMvURfqBtSXQvsVegDkMt+DE23gELOjibhwvkhKY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IsMv0bwPI+RWV93VDb+jVYPtRN8nCGJIKDo5sRTXKaNeNoy0wI0AGq0zUNPsnEgH8gHlOCSsrQVNxqIb3Z5wBrUjr7MFNalOTJO5YYIinN4eHTekH4ZuseLpZgTw4wl6pzsKsdjUxImHynWulMD4N1kW54mlfmQkt7agN0NitX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nOILbsJv; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nOILbsJv"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-53343bf5eddso492773e87.1
        for <patches@lists.linux.dev>; Thu, 05 Sep 2024 01:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725524277; x=1726129077; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=maHTiqvxZFhGv52tqnTG+Ua5ccl+t5ZmEQhD3kv29/g=;
        b=nOILbsJveZFCb4krWFNu0rm9WCvsje2AOsrYJVsk6ebOl2VK9csRfU0/KOR3lrwM4K
         gGTI++dM08oB7/dKLIU40XDgvXxSLtRvuyUrISMEiJtKKkl3VlRe9FX6uJro2SSlytU2
         gQ8iOvHGecer7Il2KoE/GWbc6ST2Smpf6zttV2LbfqqPQfCZDYmavDh/v4dkCvgwrZ9m
         tc2LQXlvBcn9BFAuQ2aPvL49IA50RrC6M2JvdsooIyGG9xDut/zLTbBzBZ2J2LPvdB+R
         4Lvm13myPIa6z46aoTBVM8pM8Zy1ZIYa5StgPxk8Jl0JN8ZnB31gVGG+Hac2Y5o5B4bf
         WX7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725524278; x=1726129078;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=maHTiqvxZFhGv52tqnTG+Ua5ccl+t5ZmEQhD3kv29/g=;
        b=cK8CurpC2T6/f+qcM4qzPqU4tsNam5owGhq3zrAr8loPLEAPTq0j5J6+aX2hxItxox
         NMhEfwMjOxGmfegEFQeLJmgcxqPXlh+89vxT0F/7D9JWTqIacCtK+fSXnpi0UUmby0k5
         Jp/WTZwgvMliC3gEQQMpd1sXXM+eJMN3w9rBn0/lF5b6J8uxsJ4IVL49ZLfEgkMw08It
         EfCZ9oPfW+yeV7RaNWkPf0PKg59TSZRRbWPKKQz434sVoRquIsxTP7NSyFMb2qJwrwmf
         dITeUG5QIg1DCe/WavZObWxu5E+mkKl4KFA4luWL2yigzrbTf2kWMViDTNHNBO3rEQWL
         ilrw==
X-Forwarded-Encrypted: i=1; AJvYcCX3Yd3dlccObNIMtcJLz0wgMCVaZOJRqhpFKmsSc7acaMDEWEJeAaUrsaOxnLDhrbhugs4yJs+n@lists.linux.dev
X-Gm-Message-State: AOJu0Ywt+jkbJjxRsmaj7cTLeP0jBvh2QTdeqRCazQ8luA13uyE2eGRi
	Zpu900Ib4fZxsduPys6bBuTT9khVfMpVz6vyI8Ugz7Lg0HQKvbIrGYdxu4Evo71jEZdCCsXU72G
	r+VCGzBF9OfQmJiwRqkae1Fana1o7Pca8xENT
X-Google-Smtp-Source: AGHT+IG6Om9J4eOqgOko9ka7GX8WLUwtyLwQ/+bHxDiMJosbus8+m1xto+kgJ/kB8HOh9qlOy1x8XjJXUGcGNgggKT4=
X-Received: by 2002:a05:6512:3b8c:b0:52f:159:2dc5 with SMTP id
 2adb3069b0e04-53546ba9fd4mr13925653e87.42.1725524277149; Thu, 05 Sep 2024
 01:17:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-18-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-18-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Thu, 5 Sep 2024 10:17:45 +0200
Message-ID: <CAH5fLgiwOWtAqhJR+crLm1p4zP-YSd8NjmF0pDdqq5C275B6Fg@mail.gmail.com>
Subject: Re: [PATCH 17/19] rust: start using the `#[expect(...)]` attribute
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Fridtjof Stoldt <xfrednet@gmail.com>, Urgau <urgau@numericable.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 10:45=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> In Rust, it is possible to `allow` particular warnings (diagnostics,
> lints) locally, making the compiler ignore instances of a given warning
> within a given function, module, block, etc.
>
> It is similar to `#pragma GCC diagnostic push` + `ignored` + `pop` in C:
>
>     #pragma GCC diagnostic push
>     #pragma GCC diagnostic ignored "-Wunused-function"
>     static void f(void) {}
>     #pragma GCC diagnostic pop
>
> But way less verbose:
>
>     #[allow(dead_code)]
>     fn f() {}
>
> By that virtue, it makes it possible to comfortably enable more
> diagnostics by default (i.e. outside `W=3D` levels) that may have some
> false positives but that are otherwise quite useful to keep enabled to
> catch potential mistakes.
>
> The `#[expect(...)]` attribute [1] takes this further, and makes the
> compiler warn if the diagnostic was _not_ produced. For instance, the
> following will ensure that, when `f()` is called somewhere, we will have
> to remove the attribute:
>
>     #[expect(dead_code)]
>     fn f() {}
>
> If we do not, we get a warning from the compiler:
>
>     warning: this lint expectation is unfulfilled
>      --> x.rs:3:10
>       |
>     3 | #[expect(dead_code)]
>       |          ^^^^^^^^^
>       |
>       =3D note: `#[warn(unfulfilled_lint_expectations)]` on by default
>
> This means that `expect`s do not get forgotten when they are not needed.
>
> See the next commit for more details, nuances on its usage and
> documentation on the feature.
>
> The attribute requires the `lint_reasons` [2] unstable feature, but it
> is becoming stable in 1.81.0 (to be released on 2024-09-05) and it has
> already been useful to clean things up in this patch series, finding
> cases where the `allow`s should not have been there.
>
> Thus, enable `lint_reasons` and convert some of our `allow`s to `expect`s
> where possible.
>
> This feature was also an example of the ongoing collaboration between
> Rust and the kernel -- we tested it in the kernel early on and found an
> issue that was quickly resolved [3].
>
> Cc: Fridtjof Stoldt <xfrednet@gmail.com>
> Cc: Urgau <urgau@numericable.fr>
> Link: https://rust-lang.github.io/rfcs/2383-lint-reasons.html#expect-lint=
-attribute [1]
> Link: https://github.com/rust-lang/rust/issues/54503 [2]
> Link: https://github.com/rust-lang/rust/issues/114557 [3]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
