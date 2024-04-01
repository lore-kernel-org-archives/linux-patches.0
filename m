Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E2D535B7
	for <patches@lists.linux.dev>; Mon,  1 Apr 2024 21:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712008369; cv=none; b=ISv8oelqNCXFbaDHSdlFAaymL6UOxdROaeQnOoJuE1Rpjgy41GgfGGuLlIUVmWWTHgj67+k/moHR0ftIBNiR72a6sW4Li2FVQ1V/t4qQdF4YBPtblgtHpKPq8JXxqrBmzttStF1YX7wVSLARwyLG44Kptr2qf/AqFIr+A5b6p1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712008369; c=relaxed/simple;
	bh=+mUgi1Gjenu9kWJsbSxl2FyKXeH8k9dLSGa1afErYxo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BW1kzW8DPYtFhbrC655tLvuE+oCu8743oBTTycOIpNZQ2DqaOr/y3Pv8znQWHqgEv5zbhP7rmE18pN2fXwnbYOs0RnLeLP8/VBHLaloCNSydeWWkxNPWqtbZzOPgAROlupb0NxV9CgAT6HhdzIPXs83SYT98gaiu/wPBc7aET9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Oq3SolA8; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oq3SolA8"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-5d4d15ec7c5so3388553a12.1
        for <patches@lists.linux.dev>; Mon, 01 Apr 2024 14:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712008367; x=1712613167; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+mUgi1Gjenu9kWJsbSxl2FyKXeH8k9dLSGa1afErYxo=;
        b=Oq3SolA8LBPtV2rFIhUxuT9T9Y6mYmpQdBBCE0peulOL/ZAO4HNWDuFOD/QHu5VBZZ
         hXKDU9Am6Wz89p5CMndq9kcGJ2JGTOsza2XsGTFPrdF1x948E6FTTRCvgBIyRN6dgGpQ
         nSu7kshkjfMG8rqGApLRx/1/+4FdI2/xMSwnnT0qBbxrvicwq3MyIvRKOhCU7eJofUUO
         XVAIzoSPeTaZi0OYxtb48LVW6BXSFwSdkLsz/K4pJUYuXzO+AhQtVnDy8gSGni//+O0l
         kP0sAhT1pbji6CUiZlJBFdo5jmbIehKuz3FX2CUyO8CbDDktslfBXzQWqbpKcBfASGwc
         dgcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712008367; x=1712613167;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+mUgi1Gjenu9kWJsbSxl2FyKXeH8k9dLSGa1afErYxo=;
        b=U76aFqarHEgRAFfLFAdcmxJMtH32CgjJ2sqJBtbTSC80DBvTzWrPsS8wFljFkPgkIQ
         B3FElngekfnTuVeF5qhzy5BspcKUMUQthy7FZtaxA5XU5x0/Cysp9LCsgqQgYZJKPWvi
         ctNk7eKDEyhvKKjYPP/ObtsA1zXRGTR1hyxtAi9N6BRU5UOXidiUk+5Iex8kTqliItjc
         Mx+Qq6xyc46M4yJaMkxmMCwVm0NxrpssqpnFb98yQ8DUnDvCUhfl1Fq4hIp6Ppl0vLBg
         0ZLgSoXt7njDTDbXrohyIQf1Fobbc5Lrjr3W68w7Qqd9QceVHmGrv1gE2qknXx0Jmzrp
         HP2w==
X-Forwarded-Encrypted: i=1; AJvYcCXDoNqiRe2LAu2Jdis5CahY465ALo96h0kG0vmaxIITHFLtvEw0grhW5y81zO/wzE6YxE/t8oWzEFqGr6Mqigf4cvTOd08E7A==
X-Gm-Message-State: AOJu0YwpVfLeFQCltMr/029SBctOPyc0OQZzjmSq0g2K2sMVrlg0v8Nf
	m73bTYI3goTvSWvCL+FipwKDHwdP7qOdf90AFSOzwheYcRdOVPQrFlAFVC4KLqdb2XrILQzV2J9
	Fo/eBYvm9a/fU8Tp1F6hYVmvrdxU=
X-Google-Smtp-Source: AGHT+IHOVFFEVYukvj+UTvjExqrrX2EQj/VredfPX+lNRU5rsGxijk8SP8Fgw/EP+hDBGh6McIwYX9ZAn7gfBXG04q0=
X-Received: by 2002:a17:90a:62c4:b0:2a0:6649:7582 with SMTP id
 k4-20020a17090a62c400b002a066497582mr9131491pjs.46.1712008366778; Mon, 01 Apr
 2024 14:52:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240401212303.537355-1-ojeda@kernel.org> <20240401212303.537355-4-ojeda@kernel.org>
In-Reply-To: <20240401212303.537355-4-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 1 Apr 2024 23:52:11 +0200
Message-ID: <CANiq72=FM2+VWs1sJTc3i2u4Y4P-DBR8o_h4Gd7MYXfxULjR-A@mail.gmail.com>
Subject: Re: [PATCH 3/3] rust: upgrade to Rust 1.78.0
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 1, 2024 at 11:23=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> It also means that, ignoring non-language/library features, we are
> currently left with just the few language features needed to implement th=
e
> kernel `Arc`, the `new_uninit` library feature, the `compiler_builtins`
> marker and the few `no_*` `cfg`s we pass when compiling `core`/`alloc`.

To be clear, by "currently" I meant in mainline, i.e. it does not mean
that we will not need/add a few more language/library features in the
future.

> Rust 1.78.0 introduced support for mutable pointers to Rust statics,
> including a test case for the Linux kernel's `VTABLE` use case [13].

I should have mentioned constants so that it makes sense. I will link
to `const_refs_to_static`, i.e.
https://github.com/rust-lang/rust/issues/119618.

> Rust 1.78.0 with debug assertions enabled (i.e. `-Cdebug-assertions=3Dy`,
> kernel's `CONFIG_RUST_DEBUG_ASSERTIONS=3Dy`) now always checks all unsafe
> preconditions, without a way to opt-out for particular cases [14].

It would be ideal to have a way to selectively disable certain checks
per-call site for this one (i.e. not just per check but for particular
instances of a check), even if the vast majority of the checks remain
in place. I discuss the details a bit more at
https://github.com/Rust-for-Linux/linux/issues/354.

> Please note that Rust 1.78.0 will be released in a month (2024-05-02).

By the way, I tested these with arm64, loongarch64 and x86_64.

Cheers,
Miguel
