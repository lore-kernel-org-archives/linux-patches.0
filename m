Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B3D35B15D
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 13:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762869293; cv=none; b=BF3r6EpHUFApxzBAGGgHKQjwrQM9ia+mFZGdgSYlwEUprDjdi1nbwLVhRRn3I11ODE0lxs7QSme4QLs/W578gyTlkIVjnB93c/R5o30DdoMc6BHAJHvKSswiiipyzq1Hv6iG0o2RXRFNbqCP4cnp1YZZeRp4UESbWm/VAm/D3dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762869293; c=relaxed/simple;
	bh=A2TkjakrfDdkYRGuTxjcRqTay/V7iT1zDDZWS1m5mUQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TySBtlgxy0tNadjv+njTh+dLZpTzfSjoBN3j9hXCYrz1kfDZsIYC6zplvnh6mlFcnaBjBsKEmZghzK0bhZ2z9doSVv06UgEfFZsBAliut8S0rk7ZbxvjF+GY3o2OTDfhc0PQGvyEkPeoxERM2NDiIBl+YhEJZY3tI5ynXfNSjm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O6bsWCdl; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O6bsWCdl"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-297ea936b39so4128025ad.1
        for <patches@lists.linux.dev>; Tue, 11 Nov 2025 05:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762869289; x=1763474089; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DZoLj4f0GVdI3DGKFlEJ4QWVzpBGFdDaaHgYw2dfwqU=;
        b=O6bsWCdl6ph7BkPCn7Fy8Ijiwjgd08K6sNUoZVGt+mPcFX2EBZRvDORlzyQgl42QdW
         8GUrCW/iAkgY/68Qh2mAe+DwHDRdzzT5UKdt0jOlD6at3GzBoaN1UemiOKGFXy7BuzZo
         fuU5OAiuin+DStyjTcaidNLkjYeIDDStPo9GDnQBKGwlhfdltQ900bL56m15y2uSrxzU
         yXS3ixYXx0aBqY/diw/OdpvWNz1li6JJU6TYc8UYjeaP7DqRDocdfn3L/ugu7n7rX62x
         B5Hd/43q56ugyWvHKsFBiutbr4bvwVtzASVIUwowKUUHQk1nufkNdGyTa9+iLzuS5Gn1
         SiFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762869289; x=1763474089;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DZoLj4f0GVdI3DGKFlEJ4QWVzpBGFdDaaHgYw2dfwqU=;
        b=ZgFp5uzus0IFwFW5ZX8pAh9qZ8B0kV/k0eNgf27N1lX8UiAnfAU1O2vQot7EF9NtKI
         HbkBVWVqE0cWaXZJhaF4+uHHjCz1NjOY5lGWbMjLJgW/z/cZJ8sWmrxhKSpi/pKAeCs6
         M9MCsp8V8DEu2k/znL6K2ea/HTiMEAsccW8KoUag9SXfAnGDNm7N29DUNMs5CZ1Zg0Ly
         DstEFn4L12kCy7rOcAOdE1c1pK5eoYrZzonWB6F89JjwOGWCecE+2kC7Xgg37qgm5xDv
         DVF4SUqc+ikYhQTK44I+YQsBemHUoasV00xGu+317NG/vmwGHljtUioxsXeb6ghxVLWS
         yN7w==
X-Forwarded-Encrypted: i=1; AJvYcCWEYPNE8k4/GrrfWAEZj0e4Hsmcn7sh6hXRKF4cH3n6l7nsLrwOqP3IEQMYtwEidUewKlz5ABT3@lists.linux.dev
X-Gm-Message-State: AOJu0Yx/aFHYjEGTCoGA5pIMVcRqSes/y9EbfnsY9Bq19pIroRdzWekv
	EQa+gfBtXM3DSkAIShMdWJuX9CW8ifCLxh5heO4AHznLPobK2o42/+4856L5aAPmemdA8u8Alsu
	zqlO/4zi/G536736A281vcx9YaH63DDw=
X-Gm-Gg: ASbGncuLMAnpYFmB2dFn3rPi+1LQY+Ji1FPMuLT89HkZXWzBJ6K1nEzsNPzVVMVd32N
	CqP8I92PyZZ6y/STGNncqSPvBgjHCoWWhgJUZDrDDCYsspM3EYxlimu4yB+gZs15ws5Cb0QiRsJ
	C+J7PndS8LHUtYBDo63FRg9BZqNGgy9e3vw60ftn5q3mYja7NffE/XhPmHJaT8pkDt2pWUeR/7M
	tlVYJeWIdHDLPtkX7+820EqP12S8PbxHhQNqCyxXP8BoQdk0QZ2jXxEa04hl0JzCPTBDA7Bo+o8
	QBRtyShDQ+dWT4Hzil1HPQsPwhs+oqF8NOy4ryc2gLS0Ucjt62p7d2VmhZkmJL5BHZK6NdFUBCv
	fswVzteUy3D0RPA==
X-Google-Smtp-Source: AGHT+IF0Z68cGNnWIYfhE+GmNXty3zSKglcsJIW8DTGnNaR5oz+N94f18Ae9bgXwDGF1o3kKuYh1bmeQkQ96c2H5z8Y=
X-Received: by 2002:a17:902:ea09:b0:295:511d:534 with SMTP id
 d9443c01a7336-297e5731561mr84933915ad.10.1762869289453; Tue, 11 Nov 2025
 05:54:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251110131913.1789896-1-ojeda@kernel.org>
In-Reply-To: <20251110131913.1789896-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 11 Nov 2025 14:54:36 +0100
X-Gm-Features: AWmQ_blj1Y6aEDrIDY1SHsBj9ipAJhqLELG9lX2PJ-XtkIigMIPK_72YnkrkjN8
Message-ID: <CANiq72mjFobjfQEtNvk9aA+757RkLpcfmCCEJAH69ZYsr67GdA@mail.gmail.com>
Subject: Re: [PATCH v2] gendwarfksyms: Skip files with no exports
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	linux-modules@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org, 
	Haiyue Wang <haiyuewa@163.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2025 at 2:19=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> From: Sami Tolvanen <samitolvanen@google.com>
>
> Starting with Rust 1.91.0 (released 2025-10-30), in upstream commit
> ab91a63d403b ("Ignore intrinsic calls in cross-crate-inlining cost model"=
)
> [1][2], `bindings.o` stops containing DWARF debug information because the
> `Default` implementations contained `write_bytes()` calls which are now
> ignored in that cost model (note that `CLIPPY=3D1` does not reproduce it)=
.
>
> This means `gendwarfksyms` complains:
>
>       RUSTC L rust/bindings.o
>     error: gendwarfksyms: process_module: dwarf_get_units failed: no debu=
gging information?
>
> There are several alternatives that would work here: conditionally
> skipping in the cases needed (but that is subtle and brittle), forcing
> DWARF generation with e.g. a dummy `static` (ugly and we may need to
> do it in several crates), skipping the call to the tool in the Kbuild
> command when there are no exports (fine) or teaching the tool to do so
> itself (simple and clean).
>
> Thus do the last one: don't attempt to process files if we have no symbol
> versions to calculate.
>
>   [ I used the commit log of my patch linked below since it explained the
>     root issue and expanded it a bit more to summarize the alternatives.
>
>       - Miguel ]
>
> Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned i=
n older LTSs).
> Reported-by: Haiyue Wang <haiyuewa@163.com>
> Closes: https://lore.kernel.org/rust-for-linux/b8c1c73d-bf8b-4bf2-beb1-84=
ffdcd60547@163.com/
> Suggested-by: Miguel Ojeda <ojeda@kernel.org>
> Link: https://lore.kernel.org/rust-for-linux/CANiq72nKC5r24VHAp9oUPR1HVPq=
T+=3D0ab9N0w6GqTF-kJOeiSw@mail.gmail.com/
> Link: https://github.com/rust-lang/rust/commit/ab91a63d403b0105cacd72809c=
d292a72984ed99 [1]
> Link: https://github.com/rust-lang/rust/pull/145910 [2]
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

I will send a couple other fixes to Linus this week, so if nobody
shouts, I will be picking this one.

Thanks!

Cheers,
Miguel
