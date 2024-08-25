Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2F874402
	for <patches@lists.linux.dev>; Sun, 25 Aug 2024 20:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724617349; cv=none; b=A1Dc9RiAgy1MVy4NOp7/KQrTjIwoQ1QLI3vceJqq8v2jCYgvXVnk4PCWWqNqGzsv/1E6I42nuvarygRn7FTPC3sZPfxsV4XXhGsT/FDF7jPqwSjJs9I2UzqALK8kPT218Xl/Z00vQwdKRMhLeBH3yXD6oMTI3PAQu6/jzPxhCYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724617349; c=relaxed/simple;
	bh=bcDrus2x7qjngtd9HfGohvO7PpI3tdrC/mNNgO20QR8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qz6wTiSzSF75C1XOYY+vuJCHTIQ3PDTKXM/dTXfY5e6hZvPrG1Dz7XGKEE7V475/5rIUfbaQUh94nf4bquKXmITBX98Upg59uopuaZufEvrRDZ7Lv+h+6y+AmumA0Y9a1uG/iMaFU/S/tI2mgfT80vTZ5cJGGDkU0Ex+YBGfL3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z/lPZtsD; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z/lPZtsD"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-75abb359fa5so524309a12.0
        for <patches@lists.linux.dev>; Sun, 25 Aug 2024 13:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724617347; x=1725222147; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6TA7z9uR8uwwIK2Am1DEh3j+frBHwJK1KKr0ycGgX0M=;
        b=Z/lPZtsDPeOuYTxjTAPziZNMCG0X7S4uBvMERCc9zIU1VQOHta7HphBXjko97dxhUU
         k4H8Go5fEbGG734D8raSMRxOAHwJMod7HLts/mGcWBSMg4CySni2HnN6cq0EfvbLIyPD
         teP3UPFBS89irgHrfGckzoweQNOnwzuE1U3uVvJtFuWkn2+hyrsV8w5zYwB6/JnFkheP
         uU3FcxTuWJn5GJxUgpzqSlptBsRk+XJVPlb08KzhytNbA4YHT9I9+68/XL1ckrVkcXoL
         Ji+nplS2lqRPO/1/KzRTIHOwxdDQRFxsIM4rnWgJKLirl9SOR87ShmIk4JBtVgvHQJxV
         pC2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724617347; x=1725222147;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6TA7z9uR8uwwIK2Am1DEh3j+frBHwJK1KKr0ycGgX0M=;
        b=ASdgKaMpW+ibmNO3LZOyzVgk674VNP9Fv0SELSn47QYs5xrn7LVW3vQNHYHnEPRjxA
         VlOywG/NewgZGY3bMcrX/NsjtPk+5YtF5bbgDxuZY8m1EXIoIKbN7df0bgqLaIQtMnXE
         gWiU6BWIESMm5x4XDEpCjiMFUTaCg5/CUPkGuO3cDQRGERiBJxH3tdsgC7pvdpGzFUTR
         wT6OYktKCPBL49no1AI1k7iSh4BiHbidlpuRc2bEqDpei+bCO67CGTzAPMHpoTbf08tX
         Nn58rhaj2DpEOytS+iNCbvOjzgJ7wMgAY67Dxty5AOLgjh3NUdqo+SIykaw5t63jbkcP
         qFOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVnmzcRks7UfZGsoylsDItW3/8wFPaaMPg4XNVvlhkUx5MMnwGpemixltuVpL6wL+wPflPNyqNB@lists.linux.dev
X-Gm-Message-State: AOJu0YwEgtozXMn8dgGBflwPH+7QIq9LiAN7cZqk8wdp6QweiWwn/Dk/
	PH6zaQQa/Ski/pTlsDmBIlooQGxB8TmLuTl8jeyaRD98Cqg9qLUNEX356gQXHUPGRt6Cy5CUm4i
	g7PAS78Ox06ceIbVxOqRII9yiA0o=
X-Google-Smtp-Source: AGHT+IGdXDKjouH0Gm9b7skaHai1GdkNTzwqm4rX+MkI9SAYI8T9MUrfWdgwvMOdX4c8YHBJOqjJdEIsctvJ/uR+410=
X-Received: by 2002:a17:902:ec85:b0:1f7:2046:a8ae with SMTP id
 d9443c01a7336-2039e34360dmr65583485ad.0.1724617346868; Sun, 25 Aug 2024
 13:22:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240818141249.387166-1-ojeda@kernel.org>
In-Reply-To: <20240818141249.387166-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 25 Aug 2024 22:22:12 +0200
Message-ID: <CANiq72=amLCxV3QRVqK0gVKnGZe_YeqB79LkydEjZ_hJ6_K4QA@mail.gmail.com>
Subject: Re: [RFC PATCH] rust: enable rustdoc's `--generate-link-to-definition`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, 
	Konstantin Ryabitsev <konstantin@linuxfoundation.org>, 
	Guillaume Gomez <guillaume1.gomez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 18, 2024 at 4:13=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> In Rust 1.56.0 [1], rustdoc introduced the "jump to definition"
> feature [2], i.e. the unstable flag `--generate-link-to-definition`.
> It adds links to the source view of the documentation.
>
> For instance, in the source view of `rust/kernel/sync.rs`, for this code:
>
>     impl Default for LockClassKey {
>         fn default() -> Self {
>             Self::new()
>         }
>     }
>
> It will add three hyperlinks:
>
>   - `Default` points to the rendered "Trait `core::default::Default`"
>     page (not the source view, since it goes to another crate, though
>     this may change).
>
>   - `LockClassKey` points to the `pub struct LockClassKey(...);` line
>     in the same page, highlighting the line number.
>
>   - `Self::new()` points to the `pub const fn new() -> Self { ... }`
>     associated function, highlighting its line numbers (i.e. for the
>     full function).
>
> This makes the source view more useful and a bit closer to the experience
> in e.g. the Elixir Cross Referencer [3].
>
> I have provisionally enabled it for rust.docs.kernel.org [4] -- one can
> take a look at the source view there for an example of how it looks like.
>
> Thus enable it.
>
> Cc: Guillaume Gomez <guillaume1.gomez@gmail.com>
> Link: https://github.com/rust-lang/rust/pull/84176 [1]
> Link: https://github.com/rust-lang/rust/issues/89095 [2]
> Link: https://elixir.bootlin.com [3]
> Link: https://rust.docs.kernel.org [4]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` -- thanks!

Let's enable this since it has already been useful for people. If it
happens to break, we can always disable it. And it may help getting it
stabilized.

Cheers,
Miguel
