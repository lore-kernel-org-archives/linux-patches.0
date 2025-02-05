Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B76F21CA12
	for <patches@lists.linux.dev>; Wed,  5 Feb 2025 23:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738797414; cv=none; b=GhxNvCxyPCLmuQC6ZeO4fCykNnjYrtT0oRM9EwJxoi32DY4j4ZM6nuHUGmvUVXeNyABeyWZ2DurWyNPfLAfYHD58O1E/vbxmBK+hu4Wq5Lkwwd5U8eUgcUyK6aY6OxDQJSmsOTgO5VWlQ8BlJIvWIKktPGhXtGJETJWV90LlWDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738797414; c=relaxed/simple;
	bh=8aEVXKUAiX3jl+3diE6Q0vk3pLPdXXP6PT+//H2Bps0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oZscP2K8IdtSiY+jkFFNbF2DusGkP2UsIzx3H/fNX17U2jN5w5XpWMXMTpNYWoCaeYu3AVSYxWslQcuvKxMOjxE3vbsnX7FqZnaMlKEs6XmbAoh+kd/HwspKWQUT9Xqaw1CjhXVTJrmQAw7VbiviYFbFaMPKW5zQiv5jwNBw80I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PJc0SWfF; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PJc0SWfF"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2f9d1e44bcbso58727a91.0
        for <patches@lists.linux.dev>; Wed, 05 Feb 2025 15:16:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738797412; x=1739402212; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0rHjeh69SCDv8DGOvORSauZlHYEzWBvt+ziip+sBEbg=;
        b=PJc0SWfFz3Y+62Dirr2KhAMONMTeNe10LYtnVCi1aqyTRECd6ynU63UygOMBMgLJO1
         n3wFYLZs3WNrqxtnS5xX7WlomNegW53ZfATx5cDfniong+qZqpKJWAqE4a0yDcGdAlB5
         3SyG7Nck4JcvfIsB9UJC3o7Kbgcp9zycPk47TPopYKXnTJvu79I+JAcoVl9TDTPFCsLj
         erY4g9Jlc9mfqPZ3bRGJtTMyLQPqgYeZ8H93PFGbtvP+cD39fLYGvRpZiJHwq5rksaHD
         /LQ2zGXm+GGJky56hcMMNEXJ57TN5wIl/R0cRez+0Jgdf+Pz9+swSmt0RlWmE6a+halS
         vtSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738797412; x=1739402212;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0rHjeh69SCDv8DGOvORSauZlHYEzWBvt+ziip+sBEbg=;
        b=MEY27/RExavj0TQI33JyxAPybhJTopkDa+JAS5/rVlhfHnxio4c24K4WOsZ2guJ6EB
         ubV4bBF8d8Es46WSMGtTgRfKaZJEXxDOKQAjf0zoecnRqrgxHQDAr8cKb7hu7jPoFv3F
         pfDBqassLl2M5ow5/VsmfBQPaKCVMc9lp8J8Di9W3JHnqiFN2iX6rf1/2MHPW2tCyLYR
         yEgruFpvdiL6/GxzzinSoBGhXwzn0ochQOdwh3eh7ccCSz+ZoujFa6lt9iQwM+ONR41B
         T8JaEvypj8Zevg3Gauq7T27l/lbdcmf69YwYURbLrTaagpkSkKES4dypFhQnT0s05Wuf
         WTDQ==
X-Forwarded-Encrypted: i=1; AJvYcCWX07jXA85xlj0y8pE3iaL+PqwL1YbtrOoWaULHgOjiAfzrIxt6ZEeZlwbUt+qs4ScnXRylPqvV@lists.linux.dev
X-Gm-Message-State: AOJu0Yy8jXP/3sfdqLkiZenpZP6ecc6ncv6L1DhSzJoX4HstAZQ2QqUf
	we2no2VmoYfv9AfcuVbqTFboToE4lLrE8o/0bqCOYQjUYcRr7p7rl3wLVkxQQQhxvJXZJm7WOgk
	vSGyWAuIAlmogzdUgkkKPiwTgvNI=
X-Gm-Gg: ASbGnctMFVCPkEV2cL4YjJHiDt/QO6ae3RhcQ4tDD4qbRn5Sg+nHFgcHlgvneGxdK5F
	dYSFqfIroWsSXc7olW6UPAXVsahNSKpJiHCYAuxiQiCMxM/n3HMuhM+kyVd82vt41VQ7C5lLR
X-Google-Smtp-Source: AGHT+IGZoNZSpEbGizDvWVQqh2XixWLkNh3RqvbaonWI9OERbfVObNviSaPkChrUY9WhqbQKZZAZBpwhNYPXAsOuMEs=
X-Received: by 2002:a17:90b:3a88:b0:2ef:93:154e with SMTP id
 98e67ed59e1d1-2f9e08349d7mr2914333a91.5.1738797412290; Wed, 05 Feb 2025
 15:16:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250121200934.222075-1-ojeda@kernel.org>
In-Reply-To: <20250121200934.222075-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 6 Feb 2025 00:16:40 +0100
X-Gm-Features: AWEUYZk0hKQpZ6bO4ChD_-_7c2CWiyRib0WSoFJb76HCurgVXjbYBh--z0xP-So
Message-ID: <CANiq72kJu9Gxqg5MHUPW-RQaMj7Rz=3HAT1Kbc_d=aQx3QOSqw@mail.gmail.com>
Subject: Re: [PATCH] rust: init: use explicit ABI to clean warning in future compilers
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 21, 2025 at 9:10=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Starting with Rust 1.86.0 (currently in nightly, to be released on
> 2025-04-03), the `missing_abi` lint is warn-by-default [1]:
>
>     error: extern declarations without an explicit ABI are deprecated
>         --> rust/doctests_kernel_generated.rs:3158:1
>          |
>     3158 | extern {
>          | ^^^^^^ help: explicitly specify the C ABI: `extern "C"`
>          |
>          =3D note: `-D missing-abi` implied by `-D warnings`
>          =3D help: to override `-D warnings` add `#[allow(missing_abi)]`
>
> Thus clean it up.
>
> Link: https://github.com/rust-lang/rust/pull/132397 [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-fixes` -- thanks everyone!

[ Added 6.13.y to Cc: stable tag. - Miguel ]

Cheers,
Miguel
