Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CB12B9D8
	for <patches@lists.linux.dev>; Tue,  2 Jul 2024 06:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.165.51.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719901516; cv=none; b=O8dON7o+QKm+Kz+0RtUVS0tj+swVH9jc3t6rZiizk7XrhYD8GtrqNPacJR6HmhEQuDUA4lNKAmDO93kksagRUYh48awlCgqmoc+9PUTUpQ6NQsslfw4FowjcmHBy2dPL9Suy/2ab9dl6y7TFp5yS6BkNNhrH8u2F63ItUwixNfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719901516; c=relaxed/simple;
	bh=d7jmQn3cQKTbDmIwjhlKxQJjbtiLywWBTewUHIeU2cY=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iUyHDYW23nJYfAt0QFIFDC7+VC/fabUChN77xor26RZpLqmvfMJyZsVbjegCKWoojaVCewYUkunxkrcFgZ/kDVDTzwKAtQLg0R4ANKBIS8Qct+bg1vqUA7m3XCvy7bWnTj+jUNvC0WQHD19E5oRAnhvfhlr998m4lnjv4LpAlxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=W96gFTsV; arc=none smtp.client-ip=188.165.51.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="W96gFTsV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1719901504; x=1720160704;
	bh=ViRBjlbD8T+ejB+NOEPHsNS/Xejpr+JGkmJCTZcRKRM=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=W96gFTsVdPuMZBI2efwM/mLbKkDInLhNk7WNOUVDnaHYRba7PTr4IziNDstaJPpWw
	 x2fwWTpsmuuDUgT6OKYByhgEbbhKnwSgDvAD8VIYuo5wS5aaW3sOjhcEC/JxQ2h0N7
	 T2eMT6uS0q+VMXR6y4ACFDblkCp6fgQWux/jUpy8/DYseJmY3oOBMIB0j8Znn7pfvu
	 4BIbuWfSgov8Ckk2MAut9aDgQs08tnoRH2FRZaks28KhQoVcZoG0JW4t2ptLel0LYe
	 vzNGhAcVtP+quAX6DMXHyn5TEoZTRcO2Br3m9tb1De9D0kM+WKHE4loaMOxE44qGNZ
	 9RuppLPlvCxmQ==
Date: Tue, 02 Jul 2024 06:25:02 +0000
To: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>
From: Benno Lossin <benno.lossin@proton.me>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 00/13] Support several Rust toolchain versions
Message-ID: <4fa15761-7cab-4463-a2ff-717256c67d76@proton.me>
In-Reply-To: <20240701183625.665574-1-ojeda@kernel.org>
References: <20240701183625.665574-1-ojeda@kernel.org>
Feedback-ID: 71780778:user:proton
X-Pm-Message-ID: 2e9bc08aec290fbcb180ad6148608273607df319
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 01.07.24 20:36, Miguel Ojeda wrote:
> Hi all,
>=20
> It is time to start supporting several Rust toolchain versions and thus
> establish a minimum Rust compiler and `bindgen` version.
>=20
> For the Rust compiler, we will start with a window of two stable
> releases, and widen it over time. This series keeps the minimum where
> it is (1.78.0), but adds support for the recently released 1.79.0.
>=20
> This should already be enough for kernel developers in distributions that
> provide recent Rust compiler versions routinely, such as Arch Linux,
> Debian Unstable (outside the freeze period), Fedora Linux, Gentoo
> Linux (especially the testing channel), Nix (unstable) and openSUSE
> Tumbleweed. A documentation adds the instructions for each of them.
>=20
> In addition, Rust for Linux is now being built-tested in Rust's
> pre-merge CI. That is, every change that is attempting to land into the
> Rust compiler is tested against the kernel, and it is merged only if it
> passes -- thanks to the Rust project for that!
>=20
> Thus, with the pre-merge CI in place, both projects hope to avoid
> unintentional changes to Rust that break the kernel. This means that,
> in general, apart from intentional changes on their side (that we will
> need to workaround conditionally on our side), the upcoming Rust compiler
> versions should generally work.
>=20
> For instance, currently, the beta (1.80.0) and nightly (1.81.0) branches
> work as well.
>=20
> Similarly, we kept the minimum as it is for `bindgen`. `bindgen` is also
> adding the kernel to its CI -- thanks!
>=20
> Cheers,
> Miguel
>=20
>=20
> Miguel Ojeda (13):
>   rust: macros: indent list item in `paste!`'s docs
>   rust: init: simplify from `map_err` to `inspect_err`
>   rust: allow `dead_code` for never constructed bindings
>   rust: relax most deny-level lints to warnings
>   rust: simplify Clippy warning flags set
>   rust: start supporting several compiler versions
>   rust: warn about `bindgen` versions 0.66.0 and 0.66.1
>   rust: work around `bindgen` 0.69.0 issue
>   rust: avoid assuming a particular `bindgen` build
>   rust: start supporting several `bindgen` versions
>   kbuild: rust: add `rustc-version` support
>   rust: support the new `-Zub-checks` flag
>   docs: rust: quick-start: add section on Linux distributions
>=20
>  Documentation/process/changes.rst  |   9 +--
>  Documentation/rust/quick-start.rst | 118 +++++++++++++++++++++++------
>  Makefile                           |  29 +++----
>  init/Kconfig                       |  11 ++-
>  lib/Kconfig.debug                  |  18 +++++
>  rust/Makefile                      |   4 +-
>  rust/bindings/lib.rs               |   1 +
>  rust/kernel/init.rs                |  12 +--
>  rust/macros/lib.rs                 |   2 +-
>  rust/uapi/lib.rs                   |   1 +
>  scripts/Kconfig.include            |   6 ++
>  scripts/Makefile.compiler          |   4 +
>  scripts/rust_is_available.sh       |  20 ++---
>  scripts/rust_is_available_test.py  |  40 +++++-----
>  scripts/rustc-version.sh           |  52 +++++++++++++
>  15 files changed, 238 insertions(+), 89 deletions(-)
>  create mode 100755 scripts/rustc-version.sh
>=20
>=20
> base-commit: f2661062f16b2de5d7b6a5c42a9a5c96326b8454
> --
> 2.45.2

I applied the series and successfully ran the kunit tests on nixos.
I tried the following rust versions via fenix:
- rustc 1.78.0 (9b00956e5 2024-04-29)
- rustc 1.79.0 (129f3b996 2024-06-10)
- 1.80.0-beta.4 (64a1fe671 2024-06-21)
- 1.81.0-nightly (6868c831a 2024-06-30)

My bindgen version is 0.69.4.

Everything worked as expected :)

Tested-by: Benno Lossin <benno.lossin@proton.me>

---
Cheers,
Benno

