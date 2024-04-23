Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E6C14AA0
	for <patches@lists.linux.dev>; Tue, 23 Apr 2024 00:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713833028; cv=none; b=qJCyAoaAmz53QMAPjAfIAbTI7ZO0eHQTgla0M8y4e3zIImsM9NZjMDlWVTAYsEX/ZIfFITemsbIFY7M0eAsNlvqlJuFACMBDZkYHMK104Vc8qYlvhUHefVjuuBb1Be7+qPSWzDxh3tbz5SXF1Hci2a+J8/d2tRoh8DJIfxkuDYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713833028; c=relaxed/simple;
	bh=VFbAJUhcP0KMuDkHhwe98YCuNuSDX2maSRVfItJn72U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IAgK7inba+jv+SQiOQ/9H520lxDc92UeiYdAHEE7ZjWP2kHO/3tRLNyJbPSto5895l0bqTI+0K7MQk2ObFjuyT2Z+vHcMIx9BoPkIIsJdlng1a4Sa9845ghu+YAVTmCjOBIdfoc8rw3+xFxj57FN/KfbQ7URwYqWMEYfaSSA3Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZdV8LEst; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZdV8LEst"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2a7e19c440dso3519535a91.3
        for <patches@lists.linux.dev>; Mon, 22 Apr 2024 17:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713833026; x=1714437826; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y0vJ15HzyjugMAhNTAU3HivHhRTp3jhrffXYIhcyc1o=;
        b=ZdV8LEst31iV93aoaCj+KjFl1r1mJpwXGGp2zmobziP6l6Ah1TC/x8shZyHuFpx5+A
         qoM6BPG7G01+aZwWhXrKzrK66Bzj2JZXMDrcjBbOLb32ulJpGt4H2nlAiv87hT5gGL8M
         EFJT7NraQQ3s5YJO9loK4eRxQrk3RWVjemvD6sq03/9GhXmptyzzvU/9KDqs3k6qvuDl
         Tt+sYYSwK9EdV5ZjdmTGLat2Mmir3fHn8jh0JjPTcMrGkED5AG4FIDE3yz8VUf1HxI+R
         tMLXQ+y1xDFMZP0ckMLGr7X0jNUb0bQx59rQRSX5yqF/Ujxik57NsIWX+D//CY0unkGO
         6mjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713833026; x=1714437826;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y0vJ15HzyjugMAhNTAU3HivHhRTp3jhrffXYIhcyc1o=;
        b=e+mlk/qon8RYFU1IJCgbPIXidNytjLrGOsmQrqEJXe0MSbzeRzv5lq0FOgm4EHRHIf
         DMH03j2qgMNfIyyc+Mmjf4Uyh2z3ki0tkE3TF58QexvFhovVISNPdlyqNlGxAsv/T+Vo
         aD7n7By2Yt2sYJHpTeDD5aOt+XhUmE8GH1HtRYflY6F7H1PqwAJs8DaSwcUeu2tHWYDR
         svmQVAVvvx68RW3OCGJdIQhgnmMlxZR3C2mR6x236dLpXy+3l46Fq6pc5zdcGnde5aZC
         KwG9vNBaFEOlUhz/GSBchh2wO8iCFSWUREe9RjhGFhNAY8ar3dJH9/LhKveQxKKAjfL8
         li2g==
X-Forwarded-Encrypted: i=1; AJvYcCXgUMHlIMmV5eBOjJIUPakEBUMp2PgxP0blYOC40xEqR2ywmkGWtmPkHKsPEGP5DeLh5UtdbWQoQBd1MEmE4MY9QaHqbshrpQ==
X-Gm-Message-State: AOJu0YyTMzhMXtVYfVIDu2XdRX94L4YP5G1wpElXyXpZkqQawy8g8UzB
	EHk2Rm5VjQf9XVgBE5LMqtcV2iRny1xiGBROb7g49pfZ7qx/w9cCB+DdIj66GtXpmaA0G0Vkvdv
	CaUi1lrM+GXcztSFwsbdp4AoJ+lM=
X-Google-Smtp-Source: AGHT+IGLfYyTbl9vYvOYBfXcIXSEXDht3gOfURdaONNde0mhKnSeiXHNUhWNVYDkuOveQ9YnBGixGIsOfEfiKHSuM3Q=
X-Received: by 2002:a17:90a:55cb:b0:2ab:2b1d:7dae with SMTP id
 o11-20020a17090a55cb00b002ab2b1d7daemr8899537pjm.44.1713833026513; Mon, 22
 Apr 2024 17:43:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240422090644.525520-1-ojeda@kernel.org>
In-Reply-To: <20240422090644.525520-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 23 Apr 2024 02:42:41 +0200
Message-ID: <CANiq72=7BycaXS-mOpt1V5y8kw+v9yp0dLpdQTZ_KRRnEcwWVA@mail.gmail.com>
Subject: Re: [PATCH] kbuild: rust: force `alloc` extern to allow "empty" Rust files
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Nicolas Schier <nicolas@fjasle.eu>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, linux-kbuild@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, stable@vger.kernel.org, 
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

Applied to `rust-fixes` early to start getting some testing in -next.
Please feel free to send tags for this one.

Cheers,
Miguel
