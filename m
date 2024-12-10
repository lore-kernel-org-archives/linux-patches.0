Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4699538FAD
	for <patches@lists.linux.dev>; Tue, 10 Dec 2024 00:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733791885; cv=none; b=JdhQiM+jck+/RwoU5EcMj7HeKEYlQaK0YnclnpkOZfpqJ/bZBZtq4KrcIz4ZXgyC5bEsBJ3xTG9/ZFhPi+hhUnx2gwLhwq0jps6u7C8xdkmIfvhY6xnh0V2ucP17Tt+2fpORlZ72MqAKgofiqIg7Iq0zH4fu4W/BcSWKqcaTrkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733791885; c=relaxed/simple;
	bh=nEfEp69NvTTxONDAy+/5voS/7ePa27UpEn4sAPc0fxE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Aey+x5Lo7WwZhFom0CPpPEbjoBsc+DFnTsreJ0mwCJbWCpyqEpN92EErUClwQYvxfk6amWlQeNabR9ZXWUtXEPVFT0mT3oFrx4KLuY6dlVJTOqIkV5BZhR3X1gPBnLH03v7K5nQdAgP1d5iJQDezgMS+W28w/7cU+53oTzq1hSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cyN0NwCG; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cyN0NwCG"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-6d87ceb58a0so40401826d6.0
        for <patches@lists.linux.dev>; Mon, 09 Dec 2024 16:51:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733791881; x=1734396681; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n0h2b9mjtuI2QArXe16Gccc3cHk96ybHu37fBVSwW9M=;
        b=cyN0NwCGolHFZ88Fy21FmT4yWxAqBzUbHcmkfkY/hpNq8TguOhx2HXUsugsG01Ykc3
         cXovQg1qHa7lbDOH77etJyYmVPY+rqVsawvLXOxd8YP0y4h5lUI2D8MDgE7piXf/krwO
         Fj4X+42kvvB3uUhFLJmrZ7DLksBIakAU22/BbttmNq7Gp6jg/xb1NScWSn7ekyx0uICW
         U32Grvj+a6RLFO7GdWCEiL4MbjE5JNbXRVhzpT0c313uneAvRXS9dz5TPbzBCv/1XjRq
         1VpkEPN8KIqcRNTkzmYlv14L+C8YBQqdDrmqq340L3PSzUmblB0S7IDCjIMD/HC2MdHH
         OqqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733791881; x=1734396681;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n0h2b9mjtuI2QArXe16Gccc3cHk96ybHu37fBVSwW9M=;
        b=UU1tJAranJbag/5SMl5IoyH5yXJwMZmOS6H387OA7QZI2KAj2/xOPRxtS2c0dagqAX
         lfvspmJVqVX5FnAPQiYmdZZwrJLyY0vvZ5siPEH3EzzQ0Qx+gfuk593CZ+Mp+KotNhdP
         zd6hHS81W00eq7W2g9La6YqgBgJ7TwVm3GLVknIg2Ir2OOHqtS71qXPk8M4b9EdLdkcw
         4yjhftnWl0CUXoIeQ4OMH/MCBoUt87ocfRp9zIhJnYcNx6W9Q7JWDCFr3ioPodAB73xO
         fMGoXUR/THvQBRqdcF1OnazY7CaOvry+iXWy/O4mtx75Ze7i81aco5hYPDwsq8wCs+Lx
         msQw==
X-Forwarded-Encrypted: i=1; AJvYcCU6sEem6ulo+kBazhUa1O3JCc5cMK18ovHtJQDlC8nRntLZxr5lPMKr88/TtwLd0Fh/R2cp9jQx@lists.linux.dev
X-Gm-Message-State: AOJu0YypHH0y+DbdHH9dnX1V2PkqEZVfoREF40NoxQijnuK6zOGdaKOO
	VfYkPMM1BsG3O//PpCtTaBg9nkaiBnf0zCtbfHY3hWdMp+8pF2l4WP+B3cp9nw2QwIiCjemCUf9
	dA+yAGuXfz0e91wGonwylPLt9p0Ysm7kS2rIX
X-Gm-Gg: ASbGncvMKtcVEdg1s2r0VV4DUZqlebOTxMWshpR6ob60txTlBBdrHF4CIps+4+1hXJh
	mcgGkOtZYI/iAcBnYVb3O4qS4fgHG6D8svX3Ao35fRImkqXUDwBqdooJvPazNueZulZA=
X-Google-Smtp-Source: AGHT+IEv6tYwzZCcY/GOnNZgDCbTNuvBneF8FHhUJ+RFI7vCCo2P0NeWoE+7XRtH4l48ug99YpLfJjAiat491cNQKC4=
X-Received: by 2002:a05:6214:c8b:b0:6d8:b2f2:bcb8 with SMTP id
 6a1803df08f44-6d91e2f23c5mr42708296d6.8.1733791881156; Mon, 09 Dec 2024
 16:51:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241112184455.855133-1-ojeda@kernel.org> <CANiq72=BvnriScFay8SpLNe9mNhjvGsBJ9W9UtdzU_6v_i+woA@mail.gmail.com>
In-Reply-To: <CANiq72=BvnriScFay8SpLNe9mNhjvGsBJ9W9UtdzU_6v_i+woA@mail.gmail.com>
From: "Hong, Yifan" <elsk@google.com>
Date: Mon, 9 Dec 2024 16:50:45 -0800
Message-ID: <CAABy=s12gOZadhYC+=6=TbbyN9j5L0B19ZLSGR_VFEdt1jhwEA@mail.gmail.com>
Subject: Re: [PATCH v3] kbuild: rust: add PROCMACROLDFLAGS
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 9, 2024 at 10:30=E2=80=AFAM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Tue, Nov 12, 2024 at 7:45=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> w=
rote:
> >
> >   - Removed "additional" from the documentation and commit message,
> >     since this actually replaces the other flags, unlike other cases.
>
> Some news regarding this: we asked upstream Rust about supporting
> overriding all flags (including e.g. `--edition`, `--target` and
> `--sysroot`) and apparently this was already accepted via an MCP
> (thanks Oli Scherer for the pointer!):
>
>     https://github.com/rust-lang/compiler-team/issues/731
>
> So, in the future, `rustc` will likely get support for this. Thus it
> may be best to go with an "additional" approach (rather than
> "replace"), so that this environment variable works the same way as
> the rest.
>
> We can do that by simply waiting until `rustc` implements it and we
> upgrade the minimum, or by implementing a workaround on our side
> meanwhile. For instance, something simple like:
>
>     $(filter-out --target=3D%,$(s)) $(lastword $(filter --target=3D%,$(s)=
))
>
> would be probably enough to cover Android's use case since we use the
> syntax with `=3D` elsewhere rather than with a space -- the equal sign
> plays well with Make's string functions. We can also add other flags
> if needed.

My original intention was to have PROCMACROLDFLAGS to be a completely
separate thing. That was partially why I used an $(or) there. This was
because "the list of flags to link hostprogs is not necessarily the
same as the list of flags used to link libmacros.so" (see commit
message). The fallback to HOSTLDFLAGS was just to be backwards
compatible so existing users don't get surprises.

In details, here's what Android does with V3 of the patch, roughly:

HOSTLDFLAGS=3D
    -L<paths>... -fuse-ld=3Dlld --rtlib=3Dcompiler-rt
--sysroot=3D<musl_sysroot> -Wl,-rpath,<paths>
PROCMACROLDFLAGS=3D
    -fuse-ld=3Dlld --rtlib=3Dcompiler-rt --sysroot=3D<glibc_sysroot>

With https://github.com/rust-lang/compiler-team/issues/731 fixed and
this idea of appending flags, our --sysroot flag should be able to be
properly overridden. But the -L and -Wl,-rpath's remains, and could
potentially be disturbing.

The reason for this difference is that we build hostprogs like
sign-file, fixdep, etc. with prebuilt libraries (e.g. sign-file needs
libcrypto, etc.) that were built against a prebuilt musl libc. On the
other hand, the Rust toolchain we are using was built against glibc,
and won't need these -L and -Wl,-rpath flags for the libraries.

So if I understand what you mean correctly, with this:
  KBUILD_PROCMACROLDFLAGS :=3D $(HOSTLDFLAGS) $(PROCMACROLDFLAGS)
Android might need a separate mechanism (another variable?) to filter
out our -L/-Wl,-rpath from HOSTLDFLAGS. (Dumb question: We can't take
-L/-Wl,-rpath away by prepending/appending more flags, right?)

>
> I will send a v4 unless someone thinks it is a bad idea.
>
> Cheers,
> Miguel
