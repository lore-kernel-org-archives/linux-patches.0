Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D444118F2FB
	for <patches@lists.linux.dev>; Mon, 25 Nov 2024 09:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732525710; cv=none; b=R0Pt6fLpVMnL2U3z21jkeqdxbdt7aq1bYv0ZmmsYcXk0lbkPMzIq7idESbG/nhRyZbW99+sE22mVeHWKAqdrspaYkv8as4TUNQWkJjBG3TXsM5cyKksSVjSHsJ2183jTC4fiyxAkCquxP8pyOcl7XG50CuFuUfUMY+ra4wN24XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732525710; c=relaxed/simple;
	bh=ZFiDIMX0PjIK7KxSAeWlLey7+/mh5K+ji23nWIAmMLA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IYdomNdfQgCuDfE8ZD0u8xbLEzLqaBwO6fJt9h1SHD3jVRq2usxekvslyDdfTj1Yjow9sZyQiOqnd1UUrQlSMdkAknsA/lngVJY91UDzKjyqICHYoacJ6viti9QLLN8hXbEN0y8jd+QHlBkR7u8bwX9OKwHParXScuf5Z6SSmA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OW6MJ53o; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OW6MJ53o"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-382433611d0so3596198f8f.3
        for <patches@lists.linux.dev>; Mon, 25 Nov 2024 01:08:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732525707; x=1733130507; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KXAcH18gdxYq9GcIQcUwx7uYz5V1gi29j89//5ppp0s=;
        b=OW6MJ53owcLnFA807p2n7z10r0MRs5XBnf6vCT8/Djx60decDbi4w+bLH6ynVVVF4t
         8lpHEBBVWhWiHcvEoC1cOBtr8UiQFRFFqxj04FAeyPoEL+5Xq1WHpuVJabe05MOd4ZPs
         Tyyg1RoyluD2s3EfVN2yk2DPfa9wt/30YD1Prw0AEdtLNz+cRfvKeYEmU4IXYJ0GKQBY
         H5TpSdchJz3mFwTxXhI3v+e4z0PklFPm+4/kV6ydeJEmSD8iFux0EmXSTcE4E+k4Fp83
         0W4+oAFxWjR2NKNwnJlqoOwLF6buKWq/6Qm0HoVBG6Q8STxS/sdeHTvJ+cizvQYKIB0g
         n+yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732525707; x=1733130507;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KXAcH18gdxYq9GcIQcUwx7uYz5V1gi29j89//5ppp0s=;
        b=LMCqV4WAU09NcNTrnxT4Ko+VZ4tHJyAM5Aioqrod9+3kJsi5jHvlWvVZKQuZDjnVPY
         PslWxyTH3kUxLu2A4fIWJS9wfExN/vDfHKE70ppeZWLBB55jCnfc+SAd1diviF+oLhVq
         gAyfh2mNdh1EMlg3MNlmMMO1TzzrCGOBB1viEX61cEB3I7TPbXe8M1VQhbZR8CpNbSws
         ofnFiF3ZnERyby8UeMxmG3FiJ93apEVeDN6L7Km87UktlmfpVlAWJTh0cPDx0ttqKOd6
         CutPYDHmj/9RAPpFxbjomhnwC/HMwp21dPhhuShn6KZeOll1Xa7ZT2iTuNg0I54sDVjJ
         Q9NQ==
X-Forwarded-Encrypted: i=1; AJvYcCWR2m0lhPf0O9F64bH9QJV9h2vbk/eohwTnkHBS/FyzR7HvIuGFvidIVju9y+InUzW7bdLLtqPa@lists.linux.dev
X-Gm-Message-State: AOJu0YzvmE4rbm+FUZB1MY8g9ox/BTPWS++c+bmUYWMDWOZ2KzJwaraG
	x2a6k8jiLQzS/zj5g8o0XIn/XRh3eB48/HFS7mYs0/mTFwzRuCWmrwikL6EXC+U/iD4Go71+t+G
	OPTh+Nu4+f4etsdsR/ICE97+EPP8WCLQdbCbS
X-Gm-Gg: ASbGnctj0DxhwBFWM3dXB5LtK8k8rFGDw0D2swqSY30aMmrKQ6lV8O66HUxL9f5HlJu
	d4AvcGrg7yA6fJiDtSNvE5C9qwD4/XmA62b2i3YmuLsiF03RTx0qJq04pE8e0+g==
X-Google-Smtp-Source: AGHT+IE+OQhREcTfAKueVgcaqoVBWDnV0rrbEkwbQowdAdSPH7dvgYIlFA0qd/qkJIo9gO5cQhqStvOzQrQOvhhAWD4=
X-Received: by 2002:a5d:47cc:0:b0:382:506b:f627 with SMTP id
 ffacd0b85a97d-38260bea7a0mr14291058f8f.57.1732525707135; Mon, 25 Nov 2024
 01:08:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241123180323.255997-1-ojeda@kernel.org>
In-Reply-To: <20241123180323.255997-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 25 Nov 2024 10:08:14 +0100
Message-ID: <CAH5fLggg5f0KpaObVtZc7WaxHjUqbhCDsn5CwnA5-3df2HEjnw@mail.gmail.com>
Subject: Re: [PATCH] rust: kbuild: set `bindgen`'s Rust target version
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
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

Just to double-check, the problem is that bindgen currently doesn't
get any information about the rustc we're using, so it may generate
code invalid on the rustc we are actually using?

Alice
