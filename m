Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B65F2C21DE
	for <patches@lists.linux.dev>; Mon,  3 Nov 2025 23:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762211159; cv=none; b=gvEFlrJjCYxIj2KJ1q6XUiDuPwYWlJ9v525Tp3+9ZdPCFufSb8+AL71ahuX7wpfJ8t2e59Qz6YuLylQIxqEwLjL2GrGSpaTBsqweEApFZ6PEYldhiVPXhA/5lGQm4ZrVdm41ClrMDQb7L9YNcdbLBBaTBi6h88SGL1pAM7xC1k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762211159; c=relaxed/simple;
	bh=wpVJWBuenZcD3eSVXXuQBdHxyRZUm/ZGGvsoPgMAlCE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LIvBl3KzkHB2QJ9U4SmhcT5ztzRHgKYcJ9OaR10F3IiGzl8+VGCGxQFK8at5b4dHr9PogiYS267Ho6X60YtMA7SadxIRJV3BMoV3Ms3aY35dT0QOcud6FRwm9bwvu28lHPvP4vC5yxv+RJO81XORHszP7c502N2CLiU0qIAdt48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fGM+c4Uv; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fGM+c4Uv"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-28d18e933a9so4791055ad.3
        for <patches@lists.linux.dev>; Mon, 03 Nov 2025 15:05:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762211157; x=1762815957; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ogon7TK6sOugcfKJJppW+WnECgyNYUKvMApdomYEbKo=;
        b=fGM+c4UvRcTZzOMeO5isrYhNd4M+XuxBpzoKUBzM78n9maNGxyyXhEWm7Omwn6ynn1
         gfZnUvvFjflOhIEb9Qu1SWZyzqfGwFNYWwSqfNn6xkZyJ1xgSFiIixorNJKoWPLbfi6C
         h+ZJIyCablEhFKIT777rtTw4Po6Yu6K/Doen362ldiogrpdV8lNpEFdP+ANYIGh1fkFU
         MtFSV9itAlF+yTp0eaYYxJSkFwkvzClW/scOdi1s5UTGyS3jirDzDxjmuJfpvj1ozw64
         9ctvq+UkuYiU4G7141i1GYcNFYMi5F3fbAl6umPHjxhGMlrF40OBKrHw3Gg3isyeOExp
         MOzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762211157; x=1762815957;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ogon7TK6sOugcfKJJppW+WnECgyNYUKvMApdomYEbKo=;
        b=p1gafLRZIhjndJxz0Smj9JBTbjnT2E3PR9G9SFfOv9iEJVCmeNmdEYusC4I5koHo2+
         nq9WPgjIAtMPMd35GjCkXMlbReKd9qyutOOfzZkmVXtFJ/LIBObM5q/a8/JOdxLhohkj
         4zr7eOVqZ08CCnoBHFIkKRIMrnl0mYKoVan7UyUdX6FNuFj1OfUTJ26nCmZt+XY7oMIn
         7yNvzyGUSqomccaztKra5y4XYucOPoVimYrFkV2DDZRbw2xXEJgEFz5Euc5/ha6R3pTs
         PMB8y2WCj8/TGp5+BzH2yBxl5RN3ChDdbpFhQP5rAqKyQ5BvIWr6AHaE743J86157Goq
         SzEA==
X-Forwarded-Encrypted: i=1; AJvYcCXkUUe2r6pJtpoTtIqj4beMfvsjVgOU1Nv+82+1TNhAfOyZO+BXSxOgpD7Fp+foznirMEibfZqM@lists.linux.dev
X-Gm-Message-State: AOJu0YyBR5jsbxKruxm5tgA9fQWPZ+uPjd48lj8ukIeykChDiXxFGfS6
	8nO6IPVimrUbc6T318FnoUXjsCT449cDzo2qyU0tUtyFDQzxnzufU9C6yHJFD4eXgNr7gyg9x9Z
	xNfDx5Mf6CNSdfw5tfpkmwrjKDjptlLU=
X-Gm-Gg: ASbGncuBg+IKgv8lMFgOmNOG9xAvOrRb6kPohEX2dkIhMVzZZhYji35YMPS84zedRKM
	wMAJdmnM7HtLBiXV+WEpQYKg8GTKyYnmKY3tI+xqx7dKoFqzkztEd03KmagdSUEMVbSb9smGT+v
	QKGyokaNyX6x7mgS1EpICfxL67DuFzTp9bTqXoc39dYVeNrGkcUwCWw8cngaX9wgRpTpu+adQlQ
	sEsOH/kgEhp2GUi6Mb45PgX+ndMjld+aRNQEOGd681mfozGK37Fe8VC6ujv5xBE9dUfgYEaOSJc
	FaneC9LyALI7eMVLIAyRDoXS+MjqE+TEQssSp2/0TpFuqAxyUWuBtKvrOYmZtBSZwtHx+N6j5/P
	00vlKQ3B5d/xtaQ==
X-Google-Smtp-Source: AGHT+IHugv4iFaTOCN4EOCjTVF2FfjlZWUSHrrn/GBxoYhXzdeo7YpUX0U5SRp9TWEaFsHczNUaXZUgkuqVdFch+J/I=
X-Received: by 2002:a17:903:187:b0:290:ad79:c617 with SMTP id
 d9443c01a7336-2951a380699mr111057345ad.1.1762211157387; Mon, 03 Nov 2025
 15:05:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251102212853.1505384-1-ojeda@kernel.org>
In-Reply-To: <20251102212853.1505384-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 4 Nov 2025 00:05:45 +0100
X-Gm-Features: AWmQ_bkuLE73e6Hn0H_oMw4VNuro5lNa0qxJ-qywqWQaWYuKfzn120mRL3CMPr4
Message-ID: <CANiq72=0JJz5XDHGpiyQBd9AmPCr4veJ=2oJywyyqQB8iMxqvA@mail.gmail.com>
Subject: Re: [PATCH 1/2] rust: kbuild: treat `build_error` and `rustdoc` as
 kernel objects
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 2, 2025 at 10:30=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Even if normally `build_error` isn't a kernel object, it should still
> be treated as such so that we pass the same flags. Similarly, `rustdoc`
> targets are never kernel objects, but we need to treat them as such.
>
> Otherwise, starting with Rust 1.91.0 (released 2025-10-30), `rustc`
> will complain about missing sanitizer flags since `-Zsanitizer` is a
> target modifier too [1]:
>
>     error: mixing `-Zsanitizer` will cause an ABI mismatch in crate `buil=
d_error`
>      --> rust/build_error.rs:3:1
>       |
>     3 | //! Build-time error.
>       | ^
>       |
>       =3D help: the `-Zsanitizer` flag modifies the ABI so Rust crates co=
mpiled with different values of this flag cannot be used together safely
>       =3D note: unset `-Zsanitizer` in this crate is incompatible with `-=
Zsanitizer=3Dkernel-address` in dependency `core`
>       =3D help: set `-Zsanitizer=3Dkernel-address` in this crate or unset=
 `-Zsanitizer` in `core`
>       =3D help: if you are sure this will not cause problems, you may use=
 `-Cunsafe-allow-abi-mismatch=3Dsanitizer` to silence this error
>
> Thus explicitly mark them as kernel objects.
>
> Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned i=
n older LTSs).
> Link: https://github.com/rust-lang/rust/pull/138736 [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied series to `rust-fixes` -- thanks everyone!

I will send another less urgent one for 1.92.0 (in beta now) that goes
on top of these here.

Cheers,
Miguel
