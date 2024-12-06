Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660CD13C8F4
	for <patches@lists.linux.dev>; Fri,  6 Dec 2024 01:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733448518; cv=none; b=XGVbo/49R57sgug8IFV+e3FusG9v0TQlrX9VrPlEe/Ukf4zmvtSWI1HEIO0TJlHRongjQtP5Q6JoZJLQ0DJzN7P6Ub7aJZzpwBDGrfGkLzCIftJBRH02dpacOchsmrZ4O78tvOt/Aj8lebo1EyQ5GWs+goTHN1Rs8oDkdTDJJGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733448518; c=relaxed/simple;
	bh=uXOkT0VrvXMh/h3R6LYcX+mJKHk2QtN0tnV9zftZjME=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RNLjhKphA6nVD1dWFcItA24BX0tRW3Ma3rXUgyMEVPpnCtlPsZk8s1iwsFudmzF+sXXQE3ouZp/SWUXeM5dBK1pqmPsAt5EhePYnqSU0U2lAFmKPnvqeYQvJDECeFtUX5IW3N9bFxXnYSb67JI4n2wV4eHr32gPLON5XUL9F6yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BsinynbD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BsinynbD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E90C4CEE3
	for <patches@lists.linux.dev>; Fri,  6 Dec 2024 01:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733448517;
	bh=uXOkT0VrvXMh/h3R6LYcX+mJKHk2QtN0tnV9zftZjME=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=BsinynbD7HombrLn5HWtLhfzzFaQRZhmRmmL4e9KeTA/BcHrGP8X+KKRgg9P/eLwr
	 1Fj37l/dw0oW/osqyqWGYkNnToBtGE6TTPKVTJlLGpNPzrDr3aIluO/lxSoYGWSsaP
	 eNumJ5IV0+onX+eDGBqXJVFd9bWIKcoMSvIyE8ydm0QNOCf2u+NR9Q9Po5AacF47ZO
	 flfqqFNklN8ikvpxeqRfLTeY7jemUOhvYLwuIYdEWG4z5q197QY+hFWjNqBYDZxnXQ
	 xj0yN3jpUYsxYo+0ULUFVcgAMAnKjtOaKMm42tHhdiPcJLzfULD77LFF3yzq8ZjMyT
	 NC/Tgyl9UkXCw==
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-53e1f673ca8so1697730e87.3
        for <patches@lists.linux.dev>; Thu, 05 Dec 2024 17:28:37 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCX0MkYPeoyQOnv+XWOnTgQTMVHRjOV2ksgdBQZi+jdsVS6hqBOWaBZtd1O09Xj7ix+pdDdmhkO8@lists.linux.dev
X-Gm-Message-State: AOJu0Yx3hQTydxrba0J1rlXKRvnvYBWtQgBQu//OiJQ617dE1dguLg7U
	qg843pNwYKOrzB2L1nNkwH9Vz1ZiC6E4ImZqt3VXYIc9lHBDNDRqOxJgZqzZ1e6byhSkjl8z8ja
	qbtOCdFG56POC4ZTZRulHRiBOLwg=
X-Google-Smtp-Source: AGHT+IHJHMWnWMgIAhy8U/PVa4PWcqtts3A/TomGTjqvTPJOcqu5+lV9LJ1GR++FcxyZceA8baC6Laf/rCrlanCUvcE=
X-Received: by 2002:a05:6512:3b0b:b0:53e:1b79:adaa with SMTP id
 2adb3069b0e04-53e2c2b1266mr300719e87.9.1733448516447; Thu, 05 Dec 2024
 17:28:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241112184455.855133-1-ojeda@kernel.org> <CAABy=s1u75ywAECbkCmGfyt+Yp5khnF0UVcezA-_BEDWUVrHkw@mail.gmail.com>
In-Reply-To: <CAABy=s1u75ywAECbkCmGfyt+Yp5khnF0UVcezA-_BEDWUVrHkw@mail.gmail.com>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Fri, 6 Dec 2024 10:28:00 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQJUdubjkvV0T0XRU8=336rV88b7+t6BP4xR9v_g38eKQ@mail.gmail.com>
Message-ID: <CAK7LNAQJUdubjkvV0T0XRU8=336rV88b7+t6BP4xR9v_g38eKQ@mail.gmail.com>
Subject: Re: [PATCH v3] kbuild: rust: add PROCMACROLDFLAGS
To: "Hong, Yifan" <elsk@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, 
	linux-kbuild@vger.kernel.org, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 6, 2024 at 8:40=E2=80=AFAM Hong, Yifan <elsk@google.com> wrote:
>
> On Tue, Nov 12, 2024 at 10:45=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> =
wrote:
> >
> > From: HONG Yifan <elsk@google.com>
> >
> > These are flags to be passed when linking proc macros for the Rust
> > toolchain. If unset, it defaults to $(KBUILD_HOSTLDFLAGS).
> >
> > This is needed because the list of flags to link hostprogs is not
> > necessarily the same as the list of flags used to link libmacros.so.
> > When we build proc macros, we need the latter, not the former (e.g. whe=
n
> > using a Rust compiler binary linked to a different C library than host
> > programs).
> >
> > To distinguish between the two, introduce this new variable to stand
> > out from KBUILD_HOSTLDFLAGS used to link other host progs.
> >
> > Signed-off-by: HONG Yifan <elsk@google.com>
> > Link: https://lore.kernel.org/r/20241017210430.2401398-2-elsk@google.co=
m
> > [ v3:
> >
> >   - `export`ed the variable. Otherwise it would not be visible in
> >     `rust/Makefile`.
> >
> >   - Removed "additional" from the documentation and commit message,
> >     since this actually replaces the other flags, unlike other cases.
> >
> >   - Added example of use case to documentation and commit message.
> >     Thanks Alice for the details on what Google needs!
> >
> >   - Instead of `HOSTLDFLAGS`, used `KBUILD_HOSTLDFLAGS` as the fallback
> >     to preserve the previous behavior as much as possible, as discussed
> >     with Alice/Yifan. Thus moved the variable down too (currently we
> >     do not modify `KBUILD_HOSTLDFLAGS` elsewhere) and avoided
> >     mentioning `HOSTLDFLAGS` directly in the documentation.
> >
> >   - Fixed documentation header formatting.
> >
> >   - Reworded slightly.
> >
> >          - Miguel ]
> > Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> > ---
> > Masahiro: if Kbuild wants to pick this up, that is great. Otherwise, I =
am happy
> > picking this up early next cycle, if you give an `Acked-by` since this =
is
> > changing the interface for Kbuild users given we are introducing a new
> > environment variable. Thanks!
> >
> > Note that the `or` means if the string is empty, we will use the defaul=
t rather
> > than nothing. I didn't change that from Yifan's version, but maybe we w=
ant to do
> > otherwise. Users can still provide e.g. an empty space to avoid any fla=
g.
>
> I am not sure if I understand the implications here.
> https://www.gnu.org/software/make/manual/html_node/Conditional-Functions.=
html
> says:
>
> The or function provides a =E2=80=9Cshort-circuiting=E2=80=9D OR operatio=
n. Each
> argument is expanded, in order. If an argument expands to a non-empty
> string the processing stops and the result of the expansion is that
> string. If, after all arguments are expanded, all of them are false
> (empty), then the result of the expansion is the empty string.
>
> I am assuming that this means:
> - If PROCMACROLDFLAGS is not empty, KBUILD_PROCMACROLDFLAGS evaluates
> to PROCMACROLDFLAGS
> - Otherwise if KBUILD_HOSTLDFLAGS is not empty,
> KBUILD_PROCMACROLDFLAGS evaluates to KBUILD_HOSTLDFLAGS
> - Otherwise KBUILD_PROCMACROLDFLAGS is set to empty.

I think your understanding is correct.

$(or A,B) works like $(if A,A,B)

Commit 5c8166419acf shorten the code.



> What do you mean by "use the default"?


"use the default" means,
"use $(KBUILD_HOSTLDFLAGS)"


--=20
Best Regards
Masahiro Yamada
