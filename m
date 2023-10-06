Received: from gimli.kloenk.dev (gimli.kloenk.dev [49.12.72.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07875CB5
	for <patches@lists.linux.dev>; Fri,  6 Oct 2023 08:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kloenk.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kloenk.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kloenk.dev header.i=@kloenk.dev header.b="WSZjBfy9"
From: Finn Behrens <me@kloenk.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kloenk.dev; s=mail;
	t=1696580059; bh=babyumwyBW20VjVqFpkm/3kmDeKlpEdTsi76E18IrY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WSZjBfy9mq6e/OnF60LDWW0QUgYpamzvi2OMn/HzEbGAAxAVJfZoyzfso8aw4BUsj
	 F2DTP91IECgzMNtpezKf0dYka/NEmtB5us3BRB80Hi3QrmJ9vF6rZ/gx5fBi8XfEHu
	 6aGnYQQL7N63gYi1P5IHK60drkqt8Y45u6Xk4ghY=
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
 Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl <aliceryhl@google.com>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
Subject: Re: [PATCH 2/3] rust: print: use explicit link in documentation
Date: Fri, 06 Oct 2023 10:14:15 +0200
Message-ID: <8887D7CE-BE4F-4EF4-92B4-33BAF229E590@kloenk.dev>
In-Reply-To: <20231005210556.466856-3-ojeda@kernel.org>
References: <20231005210556.466856-1-ojeda@kernel.org>
 <20231005210556.466856-3-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable



On 5 Oct 2023, at 23:05, Miguel Ojeda wrote:

> The future `rustdoc` in the Rust 1.73.0 upgrade requires an explicit
> link for `pr_info!`:
>
>     error: unresolved link to `pr_info`
>        --> rust/kernel/print.rs:395:63
>         |
>     395 | /// Use only when continuing a previous `pr_*!` macro (e.g. [=
`pr_info!`]).
>         |                                                              =
 ^^^^^^^^ no item named `pr_info` in scope
>         |
>         =3D note: `macro_rules` named `pr_info` exists in this crate, b=
ut it is not in scope at this link's location
>         =3D note: `-D rustdoc::broken-intra-doc-links` implied by `-D w=
arnings`
>
> Thus do so to avoid a broken link while upgrading.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---

Reviewed-by: Finn Behrens <me@kloenk.dev>
