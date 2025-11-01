Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A660254AE1
	for <patches@lists.linux.dev>; Sat,  1 Nov 2025 11:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761995748; cv=none; b=Yrn8GiG9YrreJZSAP4LrqFwwHr6qtJxfwyuVQU0lQostHt/0bNcQr8Muz/TURuELspPqs+qq+rti6BbxHJSA6T+r8CZ1vo9By7A7qZn+flEioSgl7DPo0SrTTQgEnTwJMtkLZsRvyucdk0HX1lRbfmt0YIwWP0m0k726+/FHQcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761995748; c=relaxed/simple;
	bh=53L4Agml3krEnn3GEm4C8FtLZA7Y88RpvZUAfOW9in8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i0oU51kswahreUsQLgJkRafJU+2PQ0YVf19Y5aP/BcJS+TbddqNynQQQ1JU66LSDan3VpfLWfgEuWfDENtM9ul3N09+YA1+7EK8ftPVcXCYLoEUyGQYJedfZ7boREeffO6hloQe3FOCIx81hyvalVoroqbKUvTPYwr2/4etTtTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QPewvctK; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QPewvctK"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-47721743fd0so16275325e9.2
        for <patches@lists.linux.dev>; Sat, 01 Nov 2025 04:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761995744; x=1762600544; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ai02d9ytggMhjQZGGyjFxbHV7RPoREkTPHk/zt6GB60=;
        b=QPewvctKIOjXAdmCkaTKJppw0mGUoqQs9ayrbp4Ld+LiQJB1/SJd1BxVG2lbGC/zLF
         tX3mDrrq8Q93UkD6zXllo2zbmj/kQM9mHZ+uBuM+s1VF8IktwsdVQGssA2mikq3q2ihJ
         b96C+WW/FwYW/p46Yu0YC1uAUkdMXs7CRqMNZwgS4jxebB2V0scrkVGbIV1mMQh8A7lo
         d/DvTE5O71fsgZeTOKO9DrhAjh21qTaRMASIq9aum5+YymNRlba9WbvReDJuLBhwYThm
         JIsB1npBbUH/EEdD2/e+hKjQI2sVXGzL22W9g/o6Y6GXWbNRnEKuyKAUzxd3IrStVyXD
         q9IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761995744; x=1762600544;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ai02d9ytggMhjQZGGyjFxbHV7RPoREkTPHk/zt6GB60=;
        b=nfkvO1jCuOW/gKL4ujetWr7IkMwC/CGAzSRA4W3OXR3mtrI+HUDah9c92oQ4JeVKuD
         ksQHP5bkgTNawnNngDMkB4YjYrUg3MO+u8xbZVzu1trR2hDWBYPWIshZ7vg2rLX3ekAI
         JzN2UQljvei2DVlboiCJt/j9N+kVFFsScF3c5ORvYjFdK4J3yQp40iKQUv7uJdrQDZ28
         TyZhXgumwBV5H5mYw37xqkzOLlWsuTzWRR6vaUd1Dc2VbFCnxS4MV0jhkrXYD+HSHalx
         EUBoLzLVydiWmJN0BhoerWgpPmPGcHPhwDmPOx06sMErHQuxB4nRNJEgR3Ru/tE9SffC
         RO3g==
X-Forwarded-Encrypted: i=1; AJvYcCVQOLxxoP8Cz5MviONZduogaPbGSRkP3U388I0BqOgHBaQiUi8A4/gxn3cXKzLYrjyiMElRifxs@lists.linux.dev
X-Gm-Message-State: AOJu0YzYs3NV8/+pfa/NFZ/kd/fmrU6sEIJ1+190JBrpmNg4Ivnz59Pb
	wox5ImWlr8XBzKRjXtDaFoM8u0XI6drsQF/RFFBVtY8NLS52zHA9LZ8nM93orqgZTAy9f4XLo6x
	YkzEJ2Hdi01LAPP5xz4E7SQB5LJANWrcVDdqgCAAJ
X-Gm-Gg: ASbGncuQIgSI5VueXP1rlCo/RzhWcfQnUElOsBRdEcD27R08cd3doxtm8fTHNKEjxuS
	SAb5UrLQCSIzaGg+DY89eA9zaaYMGH9+OEPWz3RAtN4WrE9jCdKiMplnQ9CGAkEdeanVlUUu3ci
	4uKcTu/D6ytCO+r5R0l12WMkNbeMg2tU99S7ldnmkXIUYVh1o3KYe31+937bRi41o7cRVZYceas
	ELfNZA7+JZplUezQ9B80/tOZehi+rezl65yXjq+CpGIC2H+j64hYIldMEJ8oLRPrZTVAT1N3lTn
	pUI22wk=
X-Google-Smtp-Source: AGHT+IHrIEVELwPGMqLbRWNgWbAG7AKm0IuH/YHGr2zDN7xvNJeF7aEkl72R6eP6GC+NpxMmGv0UTbdaiKEnSuynERI=
X-Received: by 2002:a05:600c:4687:b0:477:fcb:226b with SMTP id
 5b1f17b1804b1-477307b6162mr64979195e9.2.1761995743628; Sat, 01 Nov 2025
 04:15:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251101094011.1024534-1-ojeda@kernel.org>
In-Reply-To: <20251101094011.1024534-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Sat, 1 Nov 2025 12:15:31 +0100
X-Gm-Features: AWmQ_bmbaSU9JnSKerRHv6L6osQHqI4rsJcPefb_e0R-EWm-pbSdfEtmq0KM5lk
Message-ID: <CAH5fLgjC20QmK0s_6ht1edL8wSR3d-yrJ_viuwdOxTCQRpMmgg@mail.gmail.com>
Subject: Re: [PATCH] rust: kbuild: support `-Cjump-tables=n` for Rust 1.93.0
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, Huacai Chen <chenhuacai@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 1, 2025 at 10:40=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Rust 1.93.0 (expected 2026-01-22) is stabilizing `-Zno-jump-tables`
> [1][2] as `-Cjump-tables=3Dn` [3].
>
> Without this change, one would eventually see:
>
>       RUSTC L rust/core.o
>     error: unknown unstable option: `no-jump-tables`
>
> Thus support the upcoming version.
>
> Link: https://github.com/rust-lang/rust/issues/116592 [1]
> Link: https://github.com/rust-lang/rust/pull/105812 [2]
> Link: https://github.com/rust-lang/rust/pull/145974 [3]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Does this need a CC stable too?

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
