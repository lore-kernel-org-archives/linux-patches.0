Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756701853
	for <patches@lists.linux.dev>; Tue, 10 Dec 2024 00:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733789372; cv=none; b=WWGLP/E9iK5UbREb/z+VxwJdoT3hUwRLGB66HOYW45CnmIPD9BOMiMJp0X0ahc18QBlcsAlQT+uvJ3MZuKjqatTso/W0rXbEeghME07y3NpYd2s1/ui0R2WccvdYl0JZTp7AObNveFGdznzG+OQ98y1C0WOXXKN713LcJZ7XC/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733789372; c=relaxed/simple;
	bh=RCOVJWgFhXT6DmylXTsI1S6NIDyGF9sD4+HqK8vNzXU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fY1lAeuVEQJTMDVvZoUG+RnckhabVaDtIHcSALLlNx6ILGxJCLpcwqsh7UJL9nINInWGehHM8xz6Yr1womUH/umoUvR78FYrlhpEt3GluDVk3g9/GKWEVXYJAnaB066LW2v8UbSSW/LaHBhJTpgKHrDPtxpp+jsnmxVfx2GTvNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O9DdHkot; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O9DdHkot"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2efdaa02378so22151a91.1
        for <patches@lists.linux.dev>; Mon, 09 Dec 2024 16:09:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733789370; x=1734394170; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bqf9Pw5ygFqNWLQdG8eH/zSqStheh4qMrd/FdN0cEGA=;
        b=O9DdHkotza8N6umbaTBJUz1RvmXgcMObH8q8oP2JyWREOj30WXnBhj8zGolvhIXunI
         khaN3odMVHiz0ceVuWN9KshDg5UBQwZgfZOn209g2bdrUdyClEkz20KopUfmbQgZ0FNV
         FvS+epwSQTgcFCnarKHk0sdAX0s2Amewed62OpXNF447y/lEG6cIvsvb5O6/k86OsIKI
         5OIAuBhJBcDlxPyvy3xtjTayhOp4pgdssRPQSFEWeOD7v+LHwP6Yi2IK38FXd5BMBs+u
         RdDG32jF5UCv6GnsYigbYOl+d5Vj/p6aB4U3C8mqoVl+dfGzH5jId3K1EtzpgYdIu3Hs
         Mvaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733789370; x=1734394170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bqf9Pw5ygFqNWLQdG8eH/zSqStheh4qMrd/FdN0cEGA=;
        b=ojA5jOHPXhAt/pBLdPSJvw666gv/m3eW2t4Foixb7GQjh6v7MIJkCfiVwy2GbsrI39
         HIoHhU06WqKfkJzRDwVnQMyQcy5GdS5Bc6cS2h+saOds0Bb45nTJ6KW7qNErkJRnDR4H
         dz2L8djT2wIKVRuhDsWgjRjG689SzhOTYlP4HjWKKIerQfMTJmfw/q4JcbjL8BWIln9K
         t450JpdobpuVz6z+EJtFo++1d7IGuo9y/CBJ5mEC59r+nKb/0XVCgkXjXyRHRQzIk9Ew
         exfW9X1ty3ru9g1MSRjoV9A8+ywBMiNUUl7xSDbdh69dwA3CGvlVfb0Op8VcZL+F0skm
         YSUQ==
X-Forwarded-Encrypted: i=1; AJvYcCXa6/p0qOwrLf2yLc1GGiZsBYiMKLBbzevEcgy4DUu19KkgIj6GP+KmIR/fN4C6SLga1/7z0q4N@lists.linux.dev
X-Gm-Message-State: AOJu0Yz4AZ3cGLYszwgH9wfcGqzG5KbyyK5zE51qrBFAWghYpfJmuKJZ
	l8TK6LWbI6NcW3lW3YGqvqC40Kumw+tiJspce6z59bWCAvqoEvHj0TA7KENq7yqBP23eREBjFAf
	Wec2DqjVDVsq2gheGFVwhXRT687A=
X-Gm-Gg: ASbGncvcQeDpxd/gg33aq1tl4XVzFntWw0BPab4duCsL52CrMHIedmLxFyGQqZ6Ejvj
	MMX7pv018ZPIdjtxxNO+JSyzFhOhf3+1N4Nc=
X-Google-Smtp-Source: AGHT+IH0533Z0lG1cmsFMSYTQgHR047SqSc1dGT+SjioNScy/dOIbt6nmvrmg4TjnlVulh/A/8MXVpm+7Nk8kFeG7Q8=
X-Received: by 2002:a17:90b:1b42:b0:2ee:6563:20b5 with SMTP id
 98e67ed59e1d1-2efd454dfb2mr887964a91.0.1733789369748; Mon, 09 Dec 2024
 16:09:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241123180323.255997-1-ojeda@kernel.org>
In-Reply-To: <20241123180323.255997-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 10 Dec 2024 01:09:17 +0100
Message-ID: <CANiq72kTX5o2rs=A51keKQiV=6fT0sN+FjWygL4=ddytnNM8Cg@mail.gmail.com>
Subject: Re: [PATCH] rust: kbuild: set `bindgen`'s Rust target version
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Christian Poveda <git@pvdrz.com>, =?UTF-8?Q?Emilio_Cobos_=C3=81lvarez?= <emilio@crisal.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 23, 2024 at 7:03=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Each `bindgen` release may upgrade the list of Rust targets. For instance=
,
> currently, in their master branch [1], the latest ones are:
>
>     Nightly =3D> {
>         vectorcall_abi: #124485,
>         ptr_metadata: #81513,
>         layout_for_ptr: #69835,
>     },
>     Stable_1_77(77) =3D> { offset_of: #106655 },
>     Stable_1_73(73) =3D> { thiscall_abi: #42202 },
>     Stable_1_71(71) =3D> { c_unwind_abi: #106075 },
>     Stable_1_68(68) =3D> { abi_efiapi: #105795 },
>
> By default, the highest stable release in their list is used, and users
> are expected to set one if they need to support older Rust versions
> (e.g. see [2]).
>
> Thus, over time, new Rust features are used by default, and at some
> point, it is likely that `bindgen` will emit Rust code that requires a
> Rust version higher than our minimum (or perhaps enabling an unstable
> feature). Currently, there is no problem because the maximum they have,
> as seen above, is Rust 1.77.0, and our current minimum is Rust 1.78.0.
>
> Therefore, set a Rust target explicitly now to prevent going forward in
> time too much and thus getting potential build failures at some point.
>
> Since we also support a minimum `bindgen` version, and since `bindgen`
> does not support passing unknown Rust target versions, we need to use
> the list of our minimum `bindgen` version, rather than the latest. So,
> since `bindgen` 0.65.1 had this list [3], we need to use Rust 1.68.0:
>
>     /// Rust stable 1.64
>     ///  * `core_ffi_c` ([Tracking issue](https://github.com/rust-lang/ru=
st/issues/94501))
>     =3D> Stable_1_64 =3D> 1.64;
>     /// Rust stable 1.68
>     ///  * `abi_efiapi` calling convention ([Tracking issue](https://gith=
ub.com/rust-lang/rust/issues/65815))
>     =3D> Stable_1_68 =3D> 1.68;
>     /// Nightly rust
>     ///  * `thiscall` calling convention ([Tracking issue](https://github=
.com/rust-lang/rust/issues/42202))
>     ///  * `vectorcall` calling convention (no tracking issue)
>     ///  * `c_unwind` calling convention ([Tracking issue](https://github=
.com/rust-lang/rust/issues/74990))
>     =3D> Nightly =3D> nightly;
>
>     ...
>
>     /// Latest stable release of Rust
>     pub const LATEST_STABLE_RUST: RustTarget =3D RustTarget::Stable_1_68;
>
> Thus add the `--rust-target 1.68` parameter. Add a comment as well
> explaining this.
>
> An alternative would be to use the currently running (i.e. actual) `rustc=
`
> and `bindgen` versions to pick a "better" Rust target version. However,
> that would introduce more moving parts depending on the user setup and
> is also more complex to implement.
>
> Cc: Christian Poveda <git@pvdrz.com>
> Cc: Emilio Cobos =C3=81lvarez <emilio@crisal.io>
> Link: https://github.com/rust-lang/rust-bindgen/blob/21c60f473f4e824d4aa9=
b2b508056320d474b110/bindgen/features.rs#L97-L105 [1]
> Link: https://github.com/rust-lang/rust-bindgen/issues/2960 [2]
> Link: https://github.com/rust-lang/rust-bindgen/blob/7d243056d335fdc4537f=
7bca73c06d01aae24ddc/bindgen/features.rs#L131-L150 [3]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-fixes` -- thanks!

I added the following note to the commit message and added a small
sentence to the comment too:

    Starting with `bindgen` 0.71.0 [4], we will be able to set any future
    Rust version instead, i.e. we will be able to set here our minimum
    supported Rust version. Christian implemented it [5] after seeing this
    patch. Thanks!

I also queued it for stable:

    Cc: stable@vger.kernel.org # needed for 6.12.y; unneeded for
6.6.y; do not apply to 6.1.y
    Fixes: c844fa64a2d4 ("rust: start supporting several `bindgen` versions=
")

Cheers,
Miguel
