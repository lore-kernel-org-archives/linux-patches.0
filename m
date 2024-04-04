Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A0E8627A
	for <patches@lists.linux.dev>; Thu,  4 Apr 2024 12:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712234487; cv=none; b=hecqPG/cAUg//940bnvbDyUEOX7e+BXusjxMn2RyFMDxv8oAFLEvuFYaHSRyK7dquZYqSFoZd5FeHfMGcQsVBL9iJBjlRSV3iRsEgCcFtsylkPYpLNxJATAVEN9SRHC0ILDiBY/XmbV1EPqzPgzAWRWBcP3jVON7SkmIlBiXFak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712234487; c=relaxed/simple;
	bh=VB1gjWxgq3H3NWgFmMgqv5zGPvWFQxnyCbF71rK8suI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WXxPHtTOLXZLPyexMQw0dnGRmGoz2ATBQMUv0S8Gmk6OXlOAp5tho50Tva2fLjxcHz12bMmtOu23g2De1p2r2kD4SuL2Ji1ZyrZNPc55C8laROja0r54lAqTdGCN9CiSg4AemccsFXL4OweoLi0nzmxAoJ7hKpYg7JD9q6Ahxa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pxVh70mN; arc=none smtp.client-ip=209.85.217.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pxVh70mN"
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-4765cffb446so391009137.0
        for <patches@lists.linux.dev>; Thu, 04 Apr 2024 05:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712234483; x=1712839283; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bHQ1Hof4gKb6D2NbosG6UAy+Sr/kwbAbAaqsg+GZo3M=;
        b=pxVh70mNyhkMPxOAYr4Kh5a4so9MxoxxCACBME9EEYyDp0v1P8KDa0Nek//IS1MUEL
         MJYJ13tQJDaMpNWfnPVBptmB5FAGcxbNf2HH3sdIWWept7zwTa4kEGidKDWX3GKgoOrt
         y4pQMWMFx1XGpngG2ulf/JAzgK0uSt62vJc1PFnb7Omty2f3gn2TzRlzWROHoih7vuv1
         uvdPCiqo1SJ8RQ53SARhPWdKw6Ci8J405r4FfR0BE+qdPQ2ZcKAnn/LzveQhhBIFx0jP
         2ov0KauuxfDcPw4AxHFkwRVz9R7dh4EErIt9UM3UiIUoklbhHu9oiZRzl9RFZvrffuRP
         GfCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712234483; x=1712839283;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bHQ1Hof4gKb6D2NbosG6UAy+Sr/kwbAbAaqsg+GZo3M=;
        b=FgL+99eQX4v072Yd1a/2hw9n8W4wxC3YOHmVMmbX4duGxQ5drAUXnEbh7v51mhsCJV
         mVRdQUnEzyQAiRbX+J0IgPy07Mlj8aDW9nipupI8LAQP4ji0FVSRiNpyveioQLgH+X1w
         A0qce/ns3hDp9m0uFwE1b/7vtCR4YfvsURUFTjc/cCc+ek4QP/Tgq4XkdUdhzCWYSfZT
         hk4lQzk1MFH5wFzKGNrguv8GRs184p/fx0+WC6jzXEba6qu5pESY4Z/f/yd4zUqAlTR8
         wXkBraP9DfYeOIA/OomSZv56xyjUkZawoQNT/+bwWQD3uI1zm8bIVz182TZNtIpvVo7U
         /6wA==
X-Forwarded-Encrypted: i=1; AJvYcCWI18ptkDRohWYQA8yXlPUs6g2rH8ho8CTFpQ1Ainb/s2bjvFFT4gj6AiwNlFov7c3Iis84WU1br8t0vBKv+omubNhwYMDaQw==
X-Gm-Message-State: AOJu0Yxyjz2aoSu2wvp2IuFMwhwuJHHBkB7PGPTtse+x+9fuN0aL5FB6
	jvj1kWimZV5nsiJt+bn2547DUk+3BdrWL+UEtBxY83Ao+nedCgE7vWcU+nqjZYVqrE5Cb1i4jKd
	9ym3PqrYwkt8bHJ+SVNei2evOEn2LDFHeOtIT
X-Google-Smtp-Source: AGHT+IFPUV3XDlGbaJh0qXH0CVflqRkGjDzOhIshfasLsrm7uDlKmnUOsZ0i2TrnZBi4+kj/z4V7VA3vArBGT/irjZQ=
X-Received: by 2002:a67:fb4d:0:b0:479:bffa:1b53 with SMTP id
 e13-20020a67fb4d000000b00479bffa1b53mr1975366vsr.7.1712234483409; Thu, 04 Apr
 2024 05:41:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240401212303.537355-1-ojeda@kernel.org> <20240401212303.537355-4-ojeda@kernel.org>
In-Reply-To: <20240401212303.537355-4-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Thu, 4 Apr 2024 14:41:12 +0200
Message-ID: <CAH5fLgiLCraafBG5+n_TLZ_hRHM7Yj49QDd=TudHJVkomXyLqw@mail.gmail.com>
Subject: Re: [PATCH 3/3] rust: upgrade to Rust 1.78.0
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 1, 2024 at 11:23=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> This is the next upgrade to the Rust toolchain, from 1.77.1 to 1.78.0
> (i.e. the latest) [1].
>
> See the upgrade policy [2] and the comments on the first upgrade in
> commit 3ed03f4da06e ("rust: upgrade to Rust 1.68.2").
>
> # Unstable features
>
> There have been no changes to the set of unstable features used in
> our own code. Therefore, the only unstable features allowed to be used
> outside the `kernel` crate is still `new_uninit`.
>
> However, since we are finally dropping our `alloc` fork [3], all the
> unstable features used by `alloc` (~30 language ones, ~60 library ones)
> are not a concern anymore. This reduces the maintenance burden, increases
> the chances of new compiler versions working without changes and gets
> us closer to the goal of supporting several compiler versions.
>
> It also means that, ignoring non-language/library features, we are
> currently left with just the few language features needed to implement th=
e
> kernel `Arc`, the `new_uninit` library feature, the `compiler_builtins`
> marker and the few `no_*` `cfg`s we pass when compiling `core`/`alloc`.
>
> Please see [4] for details.
>
> # Required changes
>
> ## LLVM's data layout
>
> Rust 1.77.0 (i.e. the previous upgrade) introduced a check for matching
> LLVM data layouts [5]. Then, Rust 1.78.0 upgraded LLVM's bundled major
> version from 17 to 18 [6], which changed the data layout in x86 [7]. Thus
> update the data layout in our custom target specification for x86 so
> that the compiler does not complain about the mismatch:
>
>     error: data-layout for target `target-5559158138856098584`,
>     `e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S1=
28`,
>     differs from LLVM target's `x86_64-linux-gnu` default layout,
>     `e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16=
:32:64-S128`
>
> In the future, the goal is to drop the custom target specifications.
> Meanwhile, if we want to support other LLVM versions used in `rustc`
> (e.g. for LTO), we will need to add some extra logic (e.g. conditional on
> LLVM's version, or extracting the data layout from an existing built-in
> target specification).
>
> ## `unused_imports`
>
> Rust's `unused_imports` lint covers both unused and redundant imports.
> Now, in 1.78.0, the lint detects more cases of redundant imports [8].
> Thus one of the previous patches cleaned them up.
>
> ## Clippy's `new_without_default`
>
> Clippy now suggests to implement `Default` even when `new()` is `const`,
> since `Default::default()` may call `const` functions even if it is not
> `const` itself [9]. Thus one of the previous patches implemented it.
>
> # Other changes in Rust
>
> Rust 1.78.0 introduced `feature(asm_goto)` [10] [11]. This feature was
> discussed in the past [12].
>
> Rust 1.78.0 introduced support for mutable pointers to Rust statics,
> including a test case for the Linux kernel's `VTABLE` use case [13].
>
> Rust 1.78.0 with debug assertions enabled (i.e. `-Cdebug-assertions=3Dy`,
> kernel's `CONFIG_RUST_DEBUG_ASSERTIONS=3Dy`) now always checks all unsafe
> preconditions, without a way to opt-out for particular cases [14].
>
> Rust 1.78.0 also improved a couple issues we reported when giving feedbac=
k
> for the new `--check-cfg` feature [15] [16].
>
> # `alloc` upgrade and reviewing
>
> As mentioned above, compiler upgrades will not update `alloc` anymore,
> since we are dropping our `alloc` fork [3].
>
> Link: https://github.com/rust-lang/rust/blob/stable/RELEASES.md#version-1=
780-2024-05-02 [1]
> Link: https://rust-for-linux.com/rust-version-policy [2]
> Link: https://lore.kernel.org/rust-for-linux/20240328013603.206764-1-weds=
onaf@gmail.com/ [3]
> Link: https://github.com/Rust-for-Linux/linux/issues/2 [4]
> Link: https://github.com/rust-lang/rust/pull/120062 [5]
> Link: https://github.com/rust-lang/rust/pull/120055 [6]
> Link: https://reviews.llvm.org/D86310 [7]
> Link: https://github.com/rust-lang/rust/pull/117772 [8]
> Link: https://github.com/rust-lang/rust-clippy/pull/10903 [9]
> Link: https://github.com/rust-lang/rust/pull/119365 [10]
> Link: https://github.com/rust-lang/rust/issues/119364 [11]
> Link: https://lore.kernel.org/rust-for-linux/ZWipTZysC2YL7qsq@Boquns-Mac-=
mini.home/ [12]
> Link: https://github.com/rust-lang/rust/pull/120932 [13]
> Link: https://github.com/rust-lang/rust/issues/120969 [14]
> Link: https://github.com/rust-lang/rust/pull/121202 [15]
> Link: https://github.com/rust-lang/rust/pull/121237 [16]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
