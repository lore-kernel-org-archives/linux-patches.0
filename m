Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE631DF25D
	for <patches@lists.linux.dev>; Sun,  2 Mar 2025 06:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740898461; cv=none; b=bbb+zR+PBtcaiK92ToI/tE7MuISO5nTicA4P8IPnhmtXcQJ58PhjxxlNLWM2J7TACU81168GzhzYVabQp29bdpF54FBH31QgXUt2HITlDV0ZHwgBRiO8tKVqr12ktKKB7QWHflSV8pYyZDjbU8c9Odmew6TXuKLnHwABcvBBasg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740898461; c=relaxed/simple;
	bh=odNY4XzOtm5aV62NW+b9pTfuSooL8hassutZzyUijxs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WDEBIWTa8s+uVOcKMUhKr2gFsrPwfkZy3cw899ppXdBjLTH5Oa/dSJO+f+1sfKpr5S2vI42+O7ggELkjsmAU/Y1hCn6wQLluURwnLtQH/f2iU05ZMcNhzpGzcjlTpxU9kpofYPFHYgjqj+/tBduYOx1HbB4lU0UqvwYsMZh9eek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iY6odkpb; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iY6odkpb"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2feae7e56c6so860482a91.1
        for <patches@lists.linux.dev>; Sat, 01 Mar 2025 22:54:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740898459; x=1741503259; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NLVLObx6uS9bBjmY8f5wb7+n2yEgDTNv1aQqp5H8/BY=;
        b=iY6odkpbWVvao/PXWj/PkJK/MbTItZbAg+SDHPhpcgbilXpBK8SDqTX/PE4tP3b8eP
         FTFodMh4OS3r8RPQ0BaobhgrJmRn+l5do8DN0K52olqAV8EarSBa0IQpGGtTrbDROKji
         Tzy8IBopS07MHu7d25fKnuq5rjVF171cQmqw/amKC2/ImPCU5jYv5tlHmbJqCjUkzdtb
         dC1iCQUrg4cED0T+C9757UquMwo4aj6Jy19tCjYGMsMwKm6mfGHQQmd9hcp/AMmf34/w
         k3AYTRxyWEybT1cZsGTYtsf3CUdHCUyfNelicSOfyt0rfglRTUvM+8yvhBtDnC27WomP
         2pmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740898459; x=1741503259;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NLVLObx6uS9bBjmY8f5wb7+n2yEgDTNv1aQqp5H8/BY=;
        b=WHs2jHopElgooJT35jKj/+p9q7Bqua6CHNa06022FxiriRFH5u0MEe4g1j3jzoJxe6
         kSoPEK9b0Md32PWqqnm+9kKTBmIiDPFSWwcbqcL7h1+qX4j+4HoAv67SOe9VAWc5FPQ+
         btbjBfW/e987vr88LUz9+iU+bPPO3xujTyyoyUEq7YK1E+2L2FJfc1a/PbJNU1STFdal
         xfxrsOpfYj7cn/JVBomO2sOzjTHSqOMpR/2X0r117zbwyRW7XMvq/E4PlJd5I0py79Yn
         6XO2PDOSOr2P84q28cr666lkdlbTzPXEr7w4K23ONLeh03oXgsMouRTc0B9cmXqaR9CM
         Qg3g==
X-Forwarded-Encrypted: i=1; AJvYcCWciP4vaBFEzhDZMBHlwwF+zXdSwJ1MVqCVFXjBm6r8zWc4xo3xnrRNuzOUlXoQG8qvvurffVo8@lists.linux.dev
X-Gm-Message-State: AOJu0Yw90CV0bbrbSJPt2/69/t+hkNYIKAQ8rUQbnzeKJAP73BPDQpnp
	O2vIJc7656ot9E6aoznxoVJIjh9NTbOojtpjwF2LP6z/8qc2m9KkPDqtgoku4ZGbncouDfZ0Dtj
	aPIZE2HE8yWARNRuPZ+v1bhPqe0E=
X-Gm-Gg: ASbGncv6PQxv8hnzVIUNkfjFWrWYQsUyhpIs/jozjjemoph9/+NgXRc7pOL8/MjVEzP
	RHJSoqiB2qjhj8FlWQwsmvDeztQEf4adn3vPaEZXgNwkraXKagrpz5QZRRVhs8kTvo7AKajAF3Z
	FR8TonLmhobVXJuvowwlQL+2WpzQ==
X-Google-Smtp-Source: AGHT+IHh1k5f2tWxMNYSe/y3kE7Ra5Zf6Er2pwX6coXwO+JW2sI9aLEqs9LceEvDYhdwv4wseu00qX6LVvsx+04aHts=
X-Received: by 2002:a17:90b:1d8a:b0:2ee:6db1:21dc with SMTP id
 98e67ed59e1d1-2febab2bdf7mr5608489a91.1.1740898459164; Sat, 01 Mar 2025
 22:54:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250301231602.917580-1-ojeda@kernel.org>
In-Reply-To: <20250301231602.917580-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 2 Mar 2025 07:54:00 +0100
X-Gm-Features: AQ5f1JrtjtdA7vxoGkxnJQQ2oihRlgLnRnvB1-jZWod_EJ2aQH_uVcVqeA0S0x8
Message-ID: <CANiq72ne57qiwgWSDE=C1bvBuYGsUg9f8PooM+V_nZFo1Z5ogQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] drm/panic: use `div_ceil` to clean Clippy warning
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Jocelyn Falempe <jfalempe@redhat.com>, =?UTF-8?Q?Thomas_B=C3=B6hler?= <witcher@wiredspace.de>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alex Gaynor <alex.gaynor@gmail.com>, dri-devel@lists.freedesktop.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 2, 2025 at 12:17=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Starting with the upcoming Rust 1.86.0 (to be released 2025-04-03),
> Clippy warns:
>
>     error: manually reimplementing `div_ceil`
>        --> drivers/gpu/drm/drm_panic_qr.rs:548:26
>         |
>     548 |         let pad_offset =3D (offset + 7) / 8;
>         |                          ^^^^^^^^^^^^^^^^ help: consider using =
`.div_ceil()`: `offset.div_ceil(8)`
>         |
>         =3D help: for further information visit https://rust-lang.github.=
io/rust-clippy/master/index.html#manual_div_ceil
>
> And similarly for `stride`. Thus apply the suggestion to both.
>
> The behavior (and thus codegen) is not exactly equivalent [1][2], since
> `div_ceil()` returns the right value for the values that currently
> would overflow.
>
> Link: https://github.com/rust-lang/rust-clippy/issues/14333 [1]
> Link: https://godbolt.org/z/dPq6nGnv3 [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Cc: stable@vger.kernel.org # Needed in 6.12.y and 6.13.y only (Rust is
pinned in older LTSs).

Cheers,
Miguel
