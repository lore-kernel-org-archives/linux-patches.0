Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685103FE22
	for <patches@lists.linux.dev>; Wed, 18 Oct 2023 17:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="LXdbYs+n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=id5jhg4t6jh75dlqjp6pot5zcy.protonmail; t=1697651770; x=1697910970;
	bh=+Do60tFHTgD/yzVC6yohA+Xb+DeuzbVb/pyouLR43hE=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=LXdbYs+nAy09u7e3TbPcQo2fVpqLTtG1rOME0Ve16ipPFbaG1XVeNxSqmsqek1QpU
	 ErMTgCXBfV2e57cG3V0+htGeydsqb/fk135HE00P7rjfFyJwrN8kvFLsLiT2wxDG9b
	 HM4sK8FUsKPR2SQpWoNG1m1Ynp0BgeO8Tf2O9p+EHY1zU37qIRPBeVvhA1kzvIjgpf
	 Tmy1VMw8JggmdrPRLfkewxHrp8cWxnRIP6VI28yuyBgt1RYShb4Joc3HkoX7QlIVfG
	 tBPP8Lr0PItp1Z3KVJDNmLyg2JErVyhC9fQTmcGbOmuhuEdMCHeFAnxYL/YrJ8ISLW
	 ogx2NOXKEKIPA==
Date: Wed, 18 Oct 2023 17:55:59 +0000
To: Miguel Ojeda <ojeda@kernel.org>
From: Benno Lossin <benno.lossin@proton.me>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Carlos Bilbao <carlos.bilbao@amd.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl <aliceryhl@google.com>, linux-kbuild@vger.kernel.org, linux-doc@vger.kernel.org, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev, Akira Yokosawa <akiyks@gmail.com>, Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Subject: Re: [PATCH 1/2] docs: rust: update Rust docs output path
Message-ID: <9zPimFJ-VQdlvUz-8ChRRxxHCJviKOt0uoclPqJzpAL9t_1s7NoPnTzCcHC-0XAbWKoRK_VLIN_duiv09Zrb0EW2rixLUv0cbxBIy6GsG_w=@proton.me>
In-Reply-To: <20231018160145.1017340-1-ojeda@kernel.org>
References: <20231018160145.1017340-1-ojeda@kernel.org>
Feedback-ID: 71780778:user:proton
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 18.10.23 18:01, Miguel Ojeda wrote:
> The Rust code documentation output path moved from `rust/doc` to
> `Documentation/output/rust/rustdoc`, thus update the old reference.
>=20
> Fixes: 48fadf440075 ("docs: Move rustdoc output, cross-reference it")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Benno Lossin <benno.lossin@proton.me>

--=20
Cheers,
Benno
