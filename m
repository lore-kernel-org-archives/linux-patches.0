Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF845101A
	for <patches@lists.linux.dev>; Mon, 22 Apr 2024 09:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713777194; cv=none; b=lRoC6T/m8gp3CnU2wFseauI4RzuEal4BbExe08DXsMLXNwdRSiIErRYds6hkiKDtiTZUIf1BqowGD3DQd2aH6CbQOPoX0pebP6LDZXbIf2uH27AHBYuNwlOv8znq4GGWiHGVspax3DjHvSGye9R1Amq6aXOwShp1lS0x/fEGYPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713777194; c=relaxed/simple;
	bh=7avuffUOa/Q3Pcy1DWsnTSzRKVAI1nDHdyVzBoGiFPY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FmHr3JPqBu3AG1+HNRZMjidPuPXGmaJeWwevT6xiajAstPj464XTRaXaSiWWmKkkNX67EYZSAhGSg1pHmIENiWxwbW71ERj5t6avTAurjZmZYCu9E7P3XIdLtBiwDSPoSg37yTKSoCaSR/p0RoYhOKFphS0HiXwqTMk95PTjb3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AQ6HaAND; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AQ6HaAND"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-61b62005f38so7796577b3.2
        for <patches@lists.linux.dev>; Mon, 22 Apr 2024 02:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713777192; x=1714381992; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QebkKGtK/XqpHpUc2nwxSwucxpv5AvI/DnU2unuULxo=;
        b=AQ6HaANDuxntfYLjt1dvCht1ZXpCVcHFuT0P1kaiQz8YArtN82nQ6nS30odPlWjwWK
         QeGbc178qGpV/99lFUPuHs4HI/WY/nYVeuy1CTAZuiApgyj33N9AbigT1nOphKmourml
         TK3rpIDDxwofYjBYnnDEPyTCGORXEbP5wFF/1z8ki3GFNSqGwn9Ukd41tx8nYjQVPdQu
         7JhVyZFtEHImiEgrVvrpKU5PEj6YtgGyKHa9FVpFXmbZfl21DFM5FGIU/7HyVzANa4Y1
         BoFJk0OuLbiKgs2bkIyvrNMhgk47aF8xieL1JUX91hZu7WXYk06GrdP0bHegXcV7ar1F
         jHFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713777192; x=1714381992;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QebkKGtK/XqpHpUc2nwxSwucxpv5AvI/DnU2unuULxo=;
        b=u8HcvbFNDbe7FadsPsaA+j0fZk4TuHMXJlBHv0R+PAeTFM6mA34wT6UcKfVJBRnNBQ
         4JSMT7C8MHxKxmTyF4fw3yJAwcz0/ch0XDbrWQ8ab5Eddpw5FBcbMwQbpR9GZDKpGCXe
         0ovLlastbufbYfCZbZLllBHnRPrNDfCM1B1PF7/tSJ1ROActxSxuC7ZgQbKPylkPzMIR
         t5/9EfH+gyE3er01aBITK+FVLmqf0YIeCdKtVVQPOWfXUYec2ow/nRfsspPG8XVD2QXM
         4y1Cibw+qCRUILs9oDwWFL8rKOvGwYGW4DWBu1rVsAdkmodY3W46dyNDo/wb7qG/uGeO
         elpQ==
X-Forwarded-Encrypted: i=1; AJvYcCUuyok9N5ru7Twlfwy0Jpwd0184pRgsQY1XWIiqUBiMWVnPR+PeV9JV0vJoBveL02Sn0fo3pQTG2Q9oaKR4eVPHCmr/kRksPQ==
X-Gm-Message-State: AOJu0YywiPT2+1OH6GE8ZphOKM+OsFGEtVaWxjD8xxXK7aYV+dO5+5gt
	5ohkt4ZplYBt/EySqT6m7OVk4Li1OaJ2OLw0IOBNdBCnMbMCM2tvqMZAkgIIFaf8Wjm0gx4lRQS
	N0VgH79UKnqxyMl1htXNyPxPhBN3KNm67TXvQ
X-Google-Smtp-Source: AGHT+IGPV1n6INq1IZnWcH4jwUQjF+85AP6wkfO43I5XKvgDoerlYI3OZEKXn8hqPjJOSlBElMOsvK2X5IZbqu1bWaI=
X-Received: by 2002:a05:690c:b15:b0:618:8a27:f26 with SMTP id
 cj21-20020a05690c0b1500b006188a270f26mr8241721ywb.48.1713777191944; Mon, 22
 Apr 2024 02:13:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240422090644.525520-1-ojeda@kernel.org>
In-Reply-To: <20240422090644.525520-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 22 Apr 2024 11:13:00 +0200
Message-ID: <CAH5fLgjoD+EVYCt-E_MVx2SA1RYRstEgFGXSQZe8aBbwVbLt+w@mail.gmail.com>
Subject: Re: [PATCH] kbuild: rust: force `alloc` extern to allow "empty" Rust files
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Nicolas Schier <nicolas@fjasle.eu>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	linux-kbuild@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org, 
	Daniel Almeida <daniel.almeida@collabora.com>, 
	Julian Stecklina <julian.stecklina@cyberus-technology.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 22, 2024 at 11:08=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> If one attempts to build an essentially empty file somewhere in the
> kernel tree, it leads to a build error because the compiler does not
> recognize the `new_uninit` unstable feature:
>
>     error[E0635]: unknown feature `new_uninit`
>      --> <crate attribute>:1:9
>       |
>     1 | feature(new_uninit)
>       |         ^^^^^^^^^^
>
> The reason is that we pass `-Zcrate-attr=3D'feature(new_uninit)'` (togeth=
er
> with `-Zallow-features=3Dnew_uninit`) to let non-`rust/` code use that
> unstable feature.
>
> However, the compiler only recognizes the feature if the `alloc` crate
> is resolved (the feature is an `alloc` one). `--extern alloc`, which we
> pass, is not enough to resolve the crate.
>
> Introducing a reference like `use alloc;` or `extern crate alloc;`
> solves the issue, thus this is not seen in normal files. For instance,
> `use`ing the `kernel` prelude introduces such a reference, since `alloc`
> is used inside.
>
> While normal use of the build system is not impacted by this, it can stil=
l
> be fairly confusing for kernel developers [1], thus use the unstable
> `force` option of `--extern` [2] (added in Rust 1.71 [3]) to force the
> compiler to resolve `alloc`.
>
> This new unstable feature is only needed meanwhile we use the other
> unstable feature, since then we will not need `-Zcrate-attr`.
>
> Cc: stable@vger.kernel.org # v6.6+
> Reported-by: Daniel Almeida <daniel.almeida@collabora.com>
> Reported-by: Julian Stecklina <julian.stecklina@cyberus-technology.de>
> Closes: https://rust-for-linux.zulipchat.com/#narrow/stream/288089-Genera=
l/topic/x/near/424096982 [1]
> Fixes: 2f7ab1267dc9 ("Kbuild: add Rust support")
> Link: https://github.com/rust-lang/rust/issues/111302 [2]
> Link: https://github.com/rust-lang/rust/pull/109421 [3]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
