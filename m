Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44B31DA21
	for <patches@lists.linux.dev>; Thu,  8 Aug 2024 15:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723132706; cv=none; b=YP7FO9vla8UFqMphCajgmZR3RHtCWPsIzaEENaGl64/zWbEk4LiO8tsfHu9hlntpDIjFEVhlCnYMkVBqdvY6G8Cia4g3fZTiWRKgjgo6WOt5pRQ+sBf2WPEEeUxjaDHQxfvN3WHjYv4koTDCv2BCXgqoBFYLKv34hnbWaqqPLEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723132706; c=relaxed/simple;
	bh=xJKc7zMMZinLoeAED3ynhwUt0GK66QI5w/EJt/HBNU0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CVzhlXzMW+fAMmhjx5DZfFGiVmWqIQ3keEIvZF+jUtHHBYNgks2jvFaKwnnkptR3uxslD/HoqVL/LOUSruAOKS7PSycaFbyBSNNENmTfB2aLcA5Kr5TNGAKLJEyqx0yAbWi/c4h2wfF7eVlegMz9yKZhxM+IJSkh7Uw/+fvL08A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HOf7MXo/; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HOf7MXo/"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3683f56b9bdso743007f8f.1
        for <patches@lists.linux.dev>; Thu, 08 Aug 2024 08:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723132703; x=1723737503; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EmuPsD4ykB+uFQrqKl/Jcu6p7dcw9XK2yyyIv/rvLfQ=;
        b=HOf7MXo/3L/rvFd9pU3XcDRqm/G36hOkpJcHrw4vLhsbid2MFyHFGJjlyIinf2Udew
         8CjQpbopA0uronNme8TtEbWuyz04Rh34phjKkPpUvr2IjpHAYIXuf0hF7zR26+CeUiDh
         f9PDhp3pwCTS4/qidXdg3gHxH2TXL4tqCpshFk78KTSLK6L0osTvcNrNFGHq8BGIAGZQ
         7pfOuzGmFBdKlcNkySafTk6OF0lbi+XZ5ODMV3crqPCuaK8lMvlCT9fjvloJDx446zc3
         2jA0ir6qiOwAQE49QZs2LkM7cDlMERNVycpZDUMr25s55glirWH4RVmCxBGH5uPGT5T+
         1r2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723132703; x=1723737503;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EmuPsD4ykB+uFQrqKl/Jcu6p7dcw9XK2yyyIv/rvLfQ=;
        b=VHuZhlRbRjv2MFZY60MBAI8+gGQj8QEHnS0O8gbiJBP9CxM6614XJH61K56zZodBvq
         uaEATNFK5FJITDue64RCk0dFxK3DOYfxlrJYIIkFauTmqra8wfMz12/OokcH+cKjvSu0
         xGzM+BaKbt6hJtgpItQvgK5+GggFAmMu+Fyh4uNpEKm4RVBpsnPxn14B+sLYsRNxUDWP
         KY6cuv12c9eiSYpqs9R+WZfz1BdNyNspEnxwWf7tRQs+MBp/z0feAPeOg2zCWpDBXk8w
         n1Uin2QBCIwwZ66RI4hRrGqepILKvsCtYf6hmTda78mmE/eaET5U15VRm89r5R0n8We1
         cEoQ==
X-Forwarded-Encrypted: i=1; AJvYcCUDEqKrN/fMmRYECFJ6wyD3nYNQNh24sPqg7Ua5HyXUvywwp2A65DBeuypyqoIE22qZmRJFC+So@lists.linux.dev
X-Gm-Message-State: AOJu0YzHhPVT/yceSlQZpDXSSNNhTZeANJCxDd+b1JWsgqO+8yW0LQIN
	gA0H2nJJdlfHGdKS5Y2LbM/b0m+ctsa3sNeuAU+k4AmawR8XXtQDs7QzXLkjasOudMyQDWVyK2p
	bSm/eo2P4uYudpNDJNYsguzT3Ztbt0owNSqcN
X-Google-Smtp-Source: AGHT+IFl5P1EQ04a2WEzWAlamIFO3bFNVG7GOWDyYdMGFdgiL+aGAC7M+K/zThfbi085VvFqTLq/8QQLXoznu7gLtmc=
X-Received: by 2002:a5d:4ec9:0:b0:367:8a87:ada2 with SMTP id
 ffacd0b85a97d-36d274daff5mr1545945f8f.26.1723132702779; Thu, 08 Aug 2024
 08:58:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240806144558.114461-1-ojeda@kernel.org>
In-Reply-To: <20240806144558.114461-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Thu, 8 Aug 2024 17:58:10 +0200
Message-ID: <CAH5fLghc6xs=YEdaVz7dBgzsEyEjs1CK-fkDCL5KTp51dGJaXA@mail.gmail.com>
Subject: Re: [PATCH] rust: x86: remove `-3dnow{,a}` from target features
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Nathan Chancellor <nathan@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	rust-for-linux@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, llvm@lists.linux.dev, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Nikita Popov <github@npopov.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 6, 2024 at 4:47=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> LLVM 19 is dropping support for 3DNow! in commit f0eb5587ceeb ("Remove
> support for 3DNow!, both intrinsics and builtins. (#96246)"):
>
>     Remove support for 3DNow!, both intrinsics and builtins. (#96246)
>
>     This set of instructions was only supported by AMD chips starting in
>     the K6-2 (introduced 1998), and before the "Bulldozer" family
>     (2011). They were never much used, as they were effectively supersede=
d
>     by the more-widely-implemented SSE (first implemented on the AMD side
>     in Athlon XP in 2001).
>
>     This is being done as a predecessor towards general removal of MMX
>     register usage. Since there is almost no usage of the 3DNow!
>     intrinsics, and no modern hardware even implements them, simple
>     removal seems like the best option.
>
> Thus we should avoid passing these to the backend, since otherwise we
> get a diagnostic about it:
>
>     '-3dnow' is not a recognized feature for this target (ignoring featur=
e)
>     '-3dnowa' is not a recognized feature for this target (ignoring featu=
re)
>
> We could try to disable them only up to LLVM 19 (not the C side one,
> but the one used by `rustc`, which may be built with a range of
> LLVMs). However, to avoid more complexity, we can likely just remove
> them altogether. According to Nikita [2]:
>
> > I don't think it's needed because LLVM should not generate 3dnow
> instructions unless specifically asked to, using intrinsics that Rust
> does not provide in the first place.
>
> Thus do so, like Rust did for one of their builtin targets [3].
>
> For those curious: Clang will warn only about trying to enable them
> (`-m3dnow{,a}`), but not about disabling them (`-mno-3dnow{,a}`), so
> there is no change needed there.
>
> Cc: Nikita Popov <github@npopov.com>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Cc: x86@kernel.org
> Link: https://github.com/llvm/llvm-project/commit/f0eb5587ceeb641445b64cb=
264c822b4751de04a [1]
> Link: https://github.com/rust-lang/rust/pull/127864#issuecomment-22358987=
60 [2]
> Link: https://github.com/rust-lang/rust/pull/127864 [3]
> Closes: https://github.com/Rust-for-Linux/linux/issues/1094
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Works with Rust Binder on the x86 cuttlefish emulator.

Tested-by: Alice Ryhl <aliceryhl@google.com>
