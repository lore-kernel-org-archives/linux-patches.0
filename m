Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6921514CC
	for <patches@lists.linux.dev>; Sun, 24 Nov 2024 23:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732492561; cv=none; b=Jd/1XP+Z0L9mOHqWVgibwxK9roZOf43zLfAyonNbWSgail4BSMBzAslNyJGV/Yt64GZZCVU9UJArCYadhCsLpTd2iPt8eInvaI5QNYOdi8N9JHg0ZQ8B7UuhWjij6KlTFSXA84EGhVPE5MjsZE7dUYVlt+nETttesr7ddrcBb94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732492561; c=relaxed/simple;
	bh=PD/UJLm7LH6MMLLNmAJycIDksAQ/wERoT2FSyYoRmQA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lmvogy95VyIMzpnRbBCyOn5RM0x9a0fVea1Ga0+LWSm4RIga/H55pn2bCTpxLfksg/flSPOMk/ByXyzLQMFoY9T+FuZlmY6LcvXREGWH25+Ox7323PMeY6CUj3yrmF82APmS4G7/JZ5UP+477daZN4Bx6jW8Xp/aB42W97m6GO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QumRKFdq; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QumRKFdq"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2ea93311724so592786a91.2
        for <patches@lists.linux.dev>; Sun, 24 Nov 2024 15:55:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732492559; x=1733097359; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uSNG3NPvuuTBpMAx70Czhut8CJdhpPvO+OEns2dE0B0=;
        b=QumRKFdqJnK5R4t5fIglCL8AQvs19lgi5XxOxh55zqvPF+wF9gs8pt0mkBVVoFnSlu
         LghvrQJWVpJgyxqFl3zOrBFxtYj5wNLT3nSMyC8lwp+aP2+gZBy8WlVAyaUggKg0tp6N
         urcL8qJRYkCZ/aVzKqy892OaadenGWozOAbUNCxxQbNJds+kPJIk44RVDqLmVLVu75Vb
         NftQ9c2uXN2OyNtPoJ5j6VQGXvaTnYwQ91ffXS6+siJA1vDAc5J+BoD1E0nbpMBWsUsa
         z2AjZQ/fbCAI8bsGxMpuI9nOyUX9FjXWGhV545jhu0QXVSomgLIFeU5CHiI6a/5fFkaM
         cP0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732492559; x=1733097359;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uSNG3NPvuuTBpMAx70Czhut8CJdhpPvO+OEns2dE0B0=;
        b=B4Id8KP7d/6JkQdbH5382ZijhNUnD6r46GMKOuE0SSLNi26E8gPQfxLJUdOgGuRGwW
         XIEpw3s6Q3fkr1wI3GBecrvnXy7e//0DES3uhbfXdkOT5m5dicm6kIEg4cH/4kGtAc6Z
         kCohk5lcnJiUbyO/yjIvuauR07lY2qgbTBsRftbGgStBfw66a++FNWJHfMNEDpdfD/a3
         SwA1nVibxGkyetiuNA4R6zbxcmQYbXF8YgoMljOgbKWut5VwAeBhU45pFtIooNPYtHbO
         0jRGU4VLsmTi0ZEZhQwB9KCwGPn8N0mS0097qwBz+HtxVg4H/1WwKuaTPZNl6+y2RddC
         eHhQ==
X-Forwarded-Encrypted: i=1; AJvYcCXECmV38/ab8F8DveESKpdEeBNelJAySfC9Gl+OhSkrklPB13oG3LFa9MehpLAyONtHGZI827io@lists.linux.dev
X-Gm-Message-State: AOJu0YyJcYX9nGm6SZDPrTaVoMWdMtZ1SanQY98/qQ37jWqEZLq+Zcoa
	wDfd+nZG1pM5EdNN86Mi49waeD6zZZBXR48yn8OF2rcsGV08jD0zmEgRuqy1vXvRbDtJU+2WRpV
	5a8yHAohUtxIBY/msSAo/cgv/2zBSRZBj
X-Gm-Gg: ASbGnctOfnRt0eZl0nfWh013UpGgnJM0w9cYOMFmHaoMK+nI4GQu8sVS76B7WxDuVfE
	npqcgjlJoHt2dK0u3EjSe8Q+ULhlLYQ==
X-Google-Smtp-Source: AGHT+IExKJPMfSptNdZi1BZ8FL450ZEm2k8j2KwKqOU+8iLFSl8lseaokzOBbj+tjOdhAv+NUZEjQc4mBf4vzHjZBLU=
X-Received: by 2002:a17:90b:4b42:b0:2ea:a9ac:eeea with SMTP id
 98e67ed59e1d1-2eb0e025c93mr5664097a91.2.1732492559391; Sun, 24 Nov 2024
 15:55:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241116181538.369355-1-ojeda@kernel.org>
In-Reply-To: <20241116181538.369355-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 25 Nov 2024 00:55:47 +0100
Message-ID: <CANiq72m46L5sqU_fUapFMNF6m4mA9XHRaT-bRsPA7kffBmwnSg@mail.gmail.com>
Subject: Re: [PATCH] rust: allow `clippy::needless_lifetimes`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 16, 2024 at 7:16=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> In beta Clippy (i.e. Rust 1.83.0), the `needless_lifetimes` lint has
> been extended [1] to suggest eliding `impl` lifetimes, e.g.
>
>     error: the following explicit lifetimes could be elided: 'a
>     --> rust/kernel/list.rs:647:6
>         |
>     647 | impl<'a, T: ?Sized + ListItem<ID>, const ID: u64> FusedIterator=
 for Iter<'a, T, ID> {}
>         |      ^^                                                        =
          ^^
>         |
>         =3D help: for further information visit https://rust-lang.github.=
io/rust-clippy/master/index.html#needless_lifetimes
>         =3D note: `-D clippy::needless-lifetimes` implied by `-D warnings=
`
>         =3D help: to override `-D warnings` add `#[allow(clippy::needless=
_lifetimes)]`
>     help: elide the lifetimes
>         |
>     647 - impl<'a, T: ?Sized + ListItem<ID>, const ID: u64> FusedIterator=
 for Iter<'a, T, ID> {}
>     647 + impl<T: ?Sized + ListItem<ID>, const ID: u64> FusedIterator for=
 Iter<'_, T, ID> {}
>
> A possibility would have been to clean them -- the RFC patch [2] did
> this, while asking if we wanted these cleanups. There is an open issue
> [3] in Clippy about being able to differentiate some of the new cases,
> e.g. those that do not involve introducing `'_`. Thus it seems others
> feel similarly.
>
> Thus, for the time being, we decided to `allow` the lint.
>
> Link: https://github.com/rust-lang/rust-clippy/pull/13286 [1]
> Link: https://lore.kernel.org/rust-for-linux/20241012231300.397010-1-ojed=
a@kernel.org/ [2]
> Link: https://github.com/rust-lang/rust-clippy/issues/13514 [3]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` so that no one gets warnings on Thursday under
`CLIPPY=3D1` -- thanks everyone!

Cheers,
Miguel
