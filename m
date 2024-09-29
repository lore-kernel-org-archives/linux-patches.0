Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B18717C9E
	for <patches@lists.linux.dev>; Sun, 29 Sep 2024 05:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727586370; cv=none; b=Z+TPs6/ClMEyJ73TpOBzZHlAQiF6rgBxyBM7uDs+jAYee9kOQVFwy70fT7B12pUHFOKWNZjVD5wlNsKVrbH2BwHe1x5rFKWzTavVph7eAwfOCH+h2uZ7LKM4Ti1m8yh97ifVIR8z7sjfz/RcCMRp9q4nkB2vKiS1SzkBZYpXPBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727586370; c=relaxed/simple;
	bh=aoMLEG5uYT+G721aBcrTsPEO44Pg0K8+G7jMYwzCd8E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SlAHfaVzYba2dhAZqf1zSh3A4DkkXaa9N2LoE40AZQAZNCsCSGG1W7ogm6Gmz8KIFAl3o8G/YxCEFh5VOWsMqmg+pSC8YPBUWWmP46e1hsKetaoayTxI155xKp1NM6Ht3fOYI2lOrETck9sZzwfBmJ3nZODShy2gsItyBYiwqXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu; spf=pass smtp.mailfrom=umich.edu; dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b=dnwYThvo; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=umich.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b="dnwYThvo"
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-e0875f1e9edso2905499276.1
        for <patches@lists.linux.dev>; Sat, 28 Sep 2024 22:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03; t=1727586366; x=1728191166; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J8Le84oFTMGyqOR3ASEcGevuk/Liy+yuFIJS9jscyss=;
        b=dnwYThvoYKFbWdQwjk0n8VlDyamEedt5yb0x8VAqrlqEbzgtIm+h5ZxIuWCEYYia9G
         ByIohn97Ir5SIegKG6xu6qBe+gd0d4B1GjcEcIbrsViLqjm6Ptp9pPZ4gID34yPktk+n
         N29vPBAMrEIn7QDJeHzMvQMT6WDYASUO/gEuIWpM+pdE1TnFKDJYxK/vMMMxGvzIRZP1
         5CF095V9HbiGdiqd5TnKnWYX3VHbX01bt1WT/Hi4VHDEfybP/NnTVv+H0c/iFi8xvPJ/
         N1wtQyXC/ku0u8Zvg3l/6WXgZcMi2HFxot5ieJCXHDcF5SYRTxbT+4Bfn35/op1CpOlg
         DQWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727586366; x=1728191166;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J8Le84oFTMGyqOR3ASEcGevuk/Liy+yuFIJS9jscyss=;
        b=lWQZkwAjakLLkVgo8sIimacBm0Q62yARhDWOniIsVi83cI1SY64I1Y2HyQFmPgWEg6
         NCg4ZJCtwTMH2eyr4ougMPvSbn6S/5KaFbWjUF0OtXHF7o0PBo4URvdGdn2c9sXYL+0N
         frVeJYUgGxa839bTRP02Z9dmutv7Kfqc2MgfVSKV3QQA4Z5iedF2e7K+WwGjv3U1w6jy
         xVxZMt5PemeWCp4UVxw4gWEK65795yhXIyN5wRmyP9ge7B7d3LBizXfGs6FbGekt3oAs
         kcCCGBJEjIl0CEAWTZzbiSBV4l6vWXdS2pxFOs8tsUrS9FbeM9zig9BXdQoriW+35SZA
         273g==
X-Forwarded-Encrypted: i=1; AJvYcCW+sEPJhR+qub7oOcEpnbdlUuk5UpuUAhcII42+d1+kZT0DG1dJkJeZaWs6u+jJAghozYgUWrC6@lists.linux.dev
X-Gm-Message-State: AOJu0YxNP4DHldUVieYnsn+WhBwgukBJjdI3Eq77WNsL4MjtMaOeLkoG
	dqFwH87r0/rgwws/PddH7b3p+yafonDAZm9QQXYHO8juy2/QghrL5aWm3k/L852f3/PcjMNPE5y
	a/b/+iFoKzKhXe9ohV8DwtkQr1NC3Kx03SyqDNQ==
X-Google-Smtp-Source: AGHT+IEloWzG2A11MN89rxxaEDbrR1lmHvEvCKeAdeymrrHOE5sVO9T1Agllzp8sYsh+vZl88oQ6oGw8u4gcQcVlQ1c=
X-Received: by 2002:a05:6902:1ac9:b0:e1d:1434:98a4 with SMTP id
 3f1490d57ef6-e2604b28394mr6473525276.9.1727586365868; Sat, 28 Sep 2024
 22:06:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-18-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-18-ojeda@kernel.org>
From: Trevor Gross <tmgross@umich.edu>
Date: Sun, 29 Sep 2024 01:05:54 -0400
Message-ID: <CALNs47swvJT+dwCXdFmYEWJg5fm9c3gpbGCwkOYE4v6Udx4E3w@mail.gmail.com>
Subject: Re: [PATCH 17/19] rust: start using the `#[expect(...)]` attribute
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Fridtjof Stoldt <xfrednet@gmail.com>, Urgau <urgau@numericable.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 4:45=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
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

Reviewed-by: Trevor Gross <tmgross@umich.edu>
