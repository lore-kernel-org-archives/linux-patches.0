Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E148155723
	for <patches@lists.linux.dev>; Tue, 11 Jun 2024 22:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718144011; cv=none; b=Bxc4I6WkFMKoem/sElTA8mmQeeZMxoR/r1My9w6eV6iP59RmDxn02KJqVl/kkrSCtjGPbfU1TY7FhgkKTPAjTratQKTw0XBcHEVLylzV5Rn7mCg1KOuWF1Gh0qOWyc4qdqGOtTwrYvX4jKsGaEYKDUJTqQR95xlY7vbxcLNqynA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718144011; c=relaxed/simple;
	bh=jJPNqfRI/Cz7z2/d2q/YscZrx1nNwYFta+zUuMDS5wU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YnVRFUX+7x38Gt+W66PtICFlsmvzb4pssDhOBzPHLOfF0JfuVQqfcsG8PYl4AxRuZSiVoHcjsZxADq/Cj4A+BnsR9Pgr0BbIYABQrOKFwETQESPkgHiYUb6NwR4FkR6R+dychP8pWG9uiuf50NOjbv6stDmsfl+BIw1vctH2fkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MGk6pCHe; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MGk6pCHe"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2c2e72128b4so267735a91.0
        for <patches@lists.linux.dev>; Tue, 11 Jun 2024 15:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718144010; x=1718748810; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=afhBt1R47m/ezKSoV/9ouvvCFpR5TvvNgsKkb4qH0kc=;
        b=MGk6pCHeddjl6uYQP7Q1km3d8oHE7PWHyQGFLLUIEjRikJn4+dmWzIVwvBLrJI+UUx
         U62Xr+E60jBiCwAQIh+uJO7ihNW26EZYm21Kr/sI4pasmAT5ezCNhto3DvMmnTkRlDL5
         /ul44BBpM7bmyRFzOSw4UnNvz8GJJBzqJnt6imb33m2IJsjGU6BGDcFZ6L/yUh4I1fb8
         c6uswjhl196wNDA6YBiFbP2dQ4xHrXYHbuM429L10qDIy0Cb59ggd7TlznMuzYNiket9
         sre0/gOzJbZF1IpCPA/j09QXSX1EtF88e6r+7JLkRbRy4tfoVlDktN92qhnFAGNadd5t
         qexg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718144010; x=1718748810;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=afhBt1R47m/ezKSoV/9ouvvCFpR5TvvNgsKkb4qH0kc=;
        b=H5XOl+zyXXDrpv1PIbTJnl8wWnq+7BUDWUwv/DZgCxPfSP8dczq6EtLI8SR0N32mWa
         6n3MjaLA8dxSEmwz+QARPgHiJNhSR639I0SQ+WVaAcQ3OSf4ZoICV5IEYo/icZO68sCE
         C0q9ofFGf+IkjCN9Fj6HXVzYTcpnjq4SqGEIfXaZad7o6SjB2O5fzOihitXif5ubkaag
         H0DaAtBwZ0mpevuTNOf1DW5n9r7aVb2qOy9K3WEaT3hFFtbPZL0DpsbOrz4hWs8MHvLQ
         GEl/lmnk2XoYTBkgCSZ4RjAVxx+Nz9JTV/dq+4b2f/yf1ZJM+Pi6i2e72+EpzLUp+/Gg
         7zxA==
X-Forwarded-Encrypted: i=1; AJvYcCWiTCHQ9eepnX4KvXhVJZoEqNx8vRkW6st3WjfJaX9R6emsubpO75gtdQgyutAf+TAENcuQ5VxyPvvHfOdzuDY951YaO2fRVg==
X-Gm-Message-State: AOJu0YwVZq0hxtKrw8FMkhL5xzmaweIYNEcsaQ+BmcR0WRs38VbwdkXv
	LLlXHC5KKve0j9CSZqim3ZXc/QF1TEA0hpcyU5D97/9PHUJ4Ro89dKRWwLDynA+6luPiGh45urw
	WF01d8wEWh/2Tyq/Pjit49/BYspI=
X-Google-Smtp-Source: AGHT+IE9qlCqOLeQ05QKNJPKnN7tKouREQ3dXdvn72wh7ojH+wuSAOzWfyGt9Erib8sm0i0A/GgDresrtb8V839STDE=
X-Received: by 2002:a17:90a:6fa3:b0:2bd:801f:dabd with SMTP id
 98e67ed59e1d1-2c4a73a5950mr378332a91.3.1718144009637; Tue, 11 Jun 2024
 15:13:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240519210735.587323-1-ojeda@kernel.org>
In-Reply-To: <20240519210735.587323-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 12 Jun 2024 00:13:17 +0200
Message-ID: <CANiq72nXkNY2EUd_6noS-ZZ9xKa0sBYcby1QCovA8V9VxwTNXw@mail.gmail.com>
Subject: Re: [PATCH] rust: avoid unused import warning in `rusttest`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Danilo Krummrich <dakr@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 19, 2024 at 11:07=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> When compiling for the `rusttest` target, the `core::ptr` import is
> unused since its only use happens in the `reserve()` method which is
> not compiled in that target:
>
>     warning: unused import: `core::ptr`
>     --> rust/kernel/alloc/vec_ext.rs:7:5
>       |
>     7 | use core::ptr;
>       |     ^^^^^^^^^
>       |
>       =3D note: `#[warn(unused_imports)]` on by default
>
> Thus clean it.
>
> Fixes: 97ab3e8eec0c ("rust: alloc: fix dangling pointer in VecExt<T>::res=
erve()")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-fixes` -- thanks everyone!

Cheers,
Miguel
