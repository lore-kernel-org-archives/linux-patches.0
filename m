Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A157D225DD
	for <patches@lists.linux.dev>; Mon, 19 Feb 2024 09:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708333763; cv=none; b=HXVh24kyahJVgCuhCnifl590kRPfeAVxq5EBDz56+GYQ193xUWpIFbTKMAkbpygi4iSrg9MByFU1cKk09wzL+8A6wuEdAl41FNIyVLYEzmISpLlkOWifG+PMeAzWNg4hmmPIakU5Pp7AXfgoaqcxH87VS+ndSO1h4I5JUlHyIoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708333763; c=relaxed/simple;
	bh=DJul3TWyiyFiIYG37u7BiMg+il0uv1aR4uQbAGcWQQ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gD12qt4q6cBf+kD5RDH9H02Oz3oxcgh1C7jcvY17RH3q5Cwq1oEKe8p/3Y4a3UYESeTxRIsc8a0me5WPCRhz0jjzUuRtywhubh5DKOoV57HeaN4S5wDuSqrVVeekazexSDzYZaZarnjdp6Wsw4yH3znvHLFfa8eAo5PFQuOMaHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1RXA2/i1; arc=none smtp.client-ip=209.85.222.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1RXA2/i1"
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-7ce3c7566e0so1729453241.1
        for <patches@lists.linux.dev>; Mon, 19 Feb 2024 01:09:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708333760; x=1708938560; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pITza/p79puTXkzLF57AKL2ujyb3FxitC2KLqmYBBWs=;
        b=1RXA2/i1bforKAVO2TvRWotOV/RkNFgLxBVGlsHGuNtTk1QgY5rZuYRW9ZK/UDBOfU
         YXdCB2IH++OuHiZHy+rO7g3GHZWj4DLNZxBYwEfgiEGGW+zzPopTBEfJAJhz9PRXlrnp
         QeY1Kh+3X4pGigtZQMm1Wfp2S8fc0ifT7z72ngwEgLXeXAjlsNSeHK0KnzqFsEiKMvLx
         p3cgjUTG8BLhDWtuQ2NaQZX8AnoBZAicq3dzRIlAHe8/MUgZXF0GNkeah6wNwdgQvrHQ
         Ou9RWxKoP9yEIspWB0ZmYtoABz+iVL5BsI/AAl0yVzKITb1ITqLKFFADaRINH/3/bJiS
         gSDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708333760; x=1708938560;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pITza/p79puTXkzLF57AKL2ujyb3FxitC2KLqmYBBWs=;
        b=I542SPGZfGPbsprAZHsG+2tj4pM8znItAae2UEdOKWYHUX2o2N8p9ZmGOkIp5XW68o
         kdy0G6GPNjyfsYjZARzOiWwF0l6wwffE1BOesvTavIW0nk/cw4aoQ1jpn4MMKX66fLpn
         TzdPOyD8QA8YDUNLhi5yZq/tsRMGXeDivzqOGEe+AhY1H4RCknlPgG2bfGUqgllEMioy
         yy84RMniOig17NV9n23C+w/0Y8aPvbGchMScJIm0Az6Tax/F886yAAEt8XKsCmwBGR0d
         PGJppU0/towCc9/RmXP3Yp0F0EC0u3lnM+4dm4/6NI6y4PAR2hL6iQw8Mw2hpelDjZ94
         0j6w==
X-Forwarded-Encrypted: i=1; AJvYcCVv6BnuMJFnU7Cxoih25GNwSv76gyVFKnM2c5ce8bMn29jpMSHz50mDyv/U0O8hUtel5N5tE5ulj20mhxeU0vIxIlLPBBN/VA==
X-Gm-Message-State: AOJu0Yz9EDdQ7WOrKYUrWa6AaOcHhJotz4Lxa9zZC8JaCO+JVHQhE7Tb
	Irh0iaM/Z3xYjoRLMVdBXapDkZn3APvTD+5JhBnfViAHpd2Qg0jqGbYThFrJXRNGxBbI1ZRNZHI
	eQZcUsWpRQmrk3vIsxqEybkAiwX9FeB/WJ8J4
X-Google-Smtp-Source: AGHT+IHzGqRc5VnbP00Jo3Xc0zRJ6YpmB8/ccl+F//H9hD5P0VDV2TgQ4Y+PEIWCp01pNe7fCDf3Nd+l617M5tt21mY=
X-Received: by 2002:a05:6102:6c6:b0:46e:c3db:aab6 with SMTP id
 m6-20020a05610206c600b0046ec3dbaab6mr8365013vsg.24.1708333760384; Mon, 19 Feb
 2024 01:09:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240217002638.57373-1-ojeda@kernel.org> <20240217002638.57373-2-ojeda@kernel.org>
In-Reply-To: <20240217002638.57373-2-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 19 Feb 2024 10:09:09 +0100
Message-ID: <CAH5fLghAC7yJLzH1K4Jv10QggnG5eHacGTJ8mxgO5neH7YR+EA@mail.gmail.com>
Subject: Re: [PATCH 2/2] rust: upgrade to Rust 1.76.0
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, linux-kbuild@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 17, 2024 at 1:27=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> This is the next upgrade to the Rust toolchain, from 1.75.0 to 1.76.0
> (i.e. the latest) [1].
>
> See the upgrade policy [2] and the comments on the first upgrade in
> commit 3ed03f4da06e ("rust: upgrade to Rust 1.68.2").
>
> # Unstable features
>
> No unstable features that we use were stabilized in Rust 1.76.0.
>
> The only unstable features allowed to be used outside the `kernel` crate
> are still `new_uninit,offset_of`, though other code to be upstreamed
> may increase the list.
>
> Please see [3] for details.
>
> # Required changes
>
> `rustc` (and others) now warns when it cannot connect to the Make
> jobserver, thus mark those invocations as recursive as needed. Please
> see the previous commit for details.
>
> # Other changes
>
> Rust 1.76.0 does not emit the `.debug_pub{names,types}` sections anymore
> for DWARFv4 [4][5]. For instance, in the uncompressed debug info case,
> this debug information took:
>
>     samples/rust/rust_minimal.o   ~64 KiB (~18% of total object size)
>     rust/kernel.o                 ~92 KiB (~15%)
>     rust/core.o                  ~114 KiB ( ~5%)
>
> In the compressed debug info (zlib) case:
>
>     samples/rust/rust_minimal.o   ~11 KiB (~6%)
>     rust/kernel.o                 ~17 KiB (~5%)
>     rust/core.o                   ~21 KiB (~1.5%)
>
> In addition, the `rustc_codegen_gcc` backend now does not emit the
> `.eh_frame` section when compiling under `-Cpanic=3Dabort` [6], thus
> removing the need for the patch in the CI to compile the kernel [7].
> Moreover, it also now emits the `.comment` section too [6].
>
> # `alloc` upgrade and reviewing

[...]

> Link: https://github.com/rust-lang/rust/blob/stable/RELEASES.md#version-1=
760-2024-02-08 [1]
> Link: https://rust-for-linux.com/rust-version-policy [2]
> Link: https://github.com/Rust-for-Linux/linux/issues/2 [3]
> Link: https://github.com/rust-lang/compiler-team/issues/688 [4]
> Link: https://github.com/rust-lang/rust/pull/117962 [5]
> Link: https://github.com/rust-lang/rust/pull/118068 [6]
> Link: https://github.com/Rust-for-Linux/ci-rustc_codegen_gcc [7]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
