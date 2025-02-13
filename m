Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0722928A2B3
	for <patches@lists.linux.dev>; Thu, 13 Feb 2025 17:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739467149; cv=none; b=LFg6qFmk1J+5r4qqq1SHJ88a5KpgaNUAQ7n6eEGqmUkjLKLl5F3zRR4n+uai4BHIZiDJT8bKlxSIWNTEM9HEJvsfwIPIPd9Ax6l2DCmLdFrIq9RUj7R7U57k+uFKxhO7LQfEn4e4FJA3ZQR9I1UQkNhOEKR1NXDQ+LJaVgPJzdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739467149; c=relaxed/simple;
	bh=zKcbM6IcBXpQkvDiwQ/2d8+zEon4okynGxi4dN1iduQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TeQpekyYasXPoThI3/DcJ5H1oewPiDTaJoylgkOLQQ242PJpjl6H4/JxqYyXr68XZlfcSBKzidhjqaz9poAoKDo2KBAncC/zhmdvHkQHlwkNFMvbPHU7gSaayrByuT0V3pNHWGH9RVTBvu7tzq284AGAXrHJeSf7HTbcqQZF4yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fYjavnAg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fYjavnAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ABD0C4CEE5
	for <patches@lists.linux.dev>; Thu, 13 Feb 2025 17:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739467148;
	bh=zKcbM6IcBXpQkvDiwQ/2d8+zEon4okynGxi4dN1iduQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=fYjavnAgjG2ALVhU3n41CpcFyEECQXYNjeAbD5x55o34caZF2OembTmslX/NXoYiH
	 zeAduvH//VNzZhkC5ViOZAzGblsV8fseHGzpZqg5tGl6vSyoSacECfunMG+uPJ1ojm
	 Rn8IWOszs8CFlovgEXbRHxcfPrU8qOZX9YkbJKZu8XojMcf8JBZzW113LNzWs6vfXw
	 59sInjBAvJhxqXcJ8ABZ+uXQJRFXl4o0pPFNiJpCo0mfQn5E9+NUfENidJEdN40tRv
	 E9PYhxdf8RGCGr20maLcIs6D345DXeHoqDUJwgsvediNEY6op0B7DmcjSeTtXgDvEP
	 VhnFPdu0wOJww==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-545039b6a67so1019949e87.0
        for <patches@lists.linux.dev>; Thu, 13 Feb 2025 09:19:08 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUbH7rlOC8fFZwlFS5vIlGYfbcT/NyNlexFr2BHm1JG/jThyIiudiaXptbg+vWDT2907+eu189L@lists.linux.dev
X-Gm-Message-State: AOJu0Yz1nSGMoqgmxyQX2uL3NY1eAJLXMUC8XrQIzKBFwdYa3CQTHL7b
	hoaavchV5O01QG2uikCrHI5lXM9/yeaZd6HkSxCoDWV3nZSFASl0wTY6XLuIFmznNjfPnIM1GBO
	CKHOkq7iw088jdUcCC4V/Yrqu2lA=
X-Google-Smtp-Source: AGHT+IFBveEmZsMEZsyrxXtWamogvgck+sW2aQvGnVbR5VQvH4/CMwg5fT2sHta2nfxtlArh3COkxd584to+rMNeWCs=
X-Received: by 2002:a05:6512:ba3:b0:545:cc2:accb with SMTP id
 2adb3069b0e04-5451811d29fmr2744992e87.28.1739467146599; Thu, 13 Feb 2025
 09:19:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250210163732.281786-1-ojeda@kernel.org> <CAMj1kXHgjwHkLsJkM3H2pjEPXDvD80V+XhH_Gsjv8N4Cf6Bvkw@mail.gmail.com>
 <9430b26a-8b2b-4ad8-b6b0-402871f2a977@ralfj.de>
In-Reply-To: <9430b26a-8b2b-4ad8-b6b0-402871f2a977@ralfj.de>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 13 Feb 2025 18:18:55 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHbXfDz96C3ZPyyXB_dSRyxbc4BP3qNN_oemG9T68eTsQ@mail.gmail.com>
X-Gm-Features: AWEUYZmMXwdsGWpyxIXpLuvhOOhu7SYkGwPGIA-pgYV0N-zrNn8_zzPI-Pd5f0o
Message-ID: <CAMj1kXHbXfDz96C3ZPyyXB_dSRyxbc4BP3qNN_oemG9T68eTsQ@mail.gmail.com>
Subject: Re: [PATCH] arm64: rust: clean Rust 1.85.0 warning using softfloat target
To: Ralf Jung <post@ralfj.de>
Cc: Miguel Ojeda <ojeda@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	moderated for non-subscribers <linux-arm-kernel@lists.infradead.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org, 
	Matthew Maurer <mmaurer@google.com>, Jubilee Young <workingjubilee@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 13 Feb 2025 at 16:46, Ralf Jung <post@ralfj.de> wrote:
>
> Hi all,
>
> > We have to carefully make the distinction here between codegen and ABI.
> >
> > The arm64 C code in the kernel is built with -mgeneral-regs-only
> > because FP/SIMD registers are not preserved/restored like GPRs, and so
> > they must be used only in carefully controlled circumstances, i.e., in
> > assembler code called under kernel_neon_begin()/kernel_neon_end()
> > [modulo some exceptions related to NEON intrinsics]
> >
> > This does not impact the ABI, which remains hard-float [this was the
> > only arm64 calling convention that existed until about a year ago].
> > Any function that takes or returns floats or doubles (or NEON
> > intrinsic types) is simply rejected by the compiler.
>
> That's how C works. It is not how Rust works. Rust does not reject using floats
> ever. Instead, Rust offers softfloat targets where you can still use floats, but
> it won't use float registers. Obviously, that needs to use a different ABI.
> As you said, aarch64 does not have an official softfloat ABI, but LLVM
> implements a de-facto softfloat ABI if you ask it to generate functions that
> take/return float types while disabling the relevant target features. (Maybe
> LLVM should just refuse to generate such code, and then Rust may have ended up
> with a different design. But now this would all be quite tricky to change.)
>
> > Changing this to softfloat for Rust modifies this calling convention,
> > i.e., it will result in floats and doubles being accepted as function
> > parameters and return values, but there is no code in the kernel that
> > actually supports/implements that.
>
> As explained above, f32/f64 were already accepted as function parameters and
> return values in Rust code before this change. So this patch does not change
> anything here. (In fact, the ABI used for these functions should be exactly the
> same before and after this patch.)
>

OK, so can I summarize the above as

- Rust calling Rust will work fine and happily use float types without
using FP/SIMD registers in codegen;
- Rust calling C or C calling Rust will not support float or double
arguments or return values due to the restrictions imposed by the C
compiler.

?

> > Also, it should be clarified
> > whether using a softfloat ABI permits the compiler to use FP/SIMD
> > registers in codegen. We might still need -Ctarget-feature="-neon"
> > here afaict.
>
> Rust's softfloat targets do not use FP/SIMD registers by default. Ideally these
> targets allow selectively using FP/SIMD registers within certain functions; for
> aarch64, this is not properly supported by LLVM and therefore Rust.
>

I read this as 'this default behavior might change in the future', and
so -Ctarget-feature="-neon" should be added even if it is redundant at
this point in time.

> > Ideally, we'd have a target/target-feature combo that makes this more
> > explicit: no FP/SIMD codegen at all, without affecting the ABI,
> > therefore making float/double types in function prototypes illegal.
> > AIUI, this change does something different.
>
> Having targets without float support would be a significant departure from past
> language decisions in Rust -- that doesn't mean it's impossible, but it would
> require a non-trivial effort (starting with an RFC to lay down the motivation
> and design).
>

Fair enough. The codegen is all that matters, and there are other
cases (e.g., spilling) where the compiler may decide to use FP/SIMD
registers without any floats or doubles in sight. In fact, there are
swaths of non-performance critical floating point code in the AMDGPU
driver where it would be useful to have float/double support using
softfloat codegen too.
