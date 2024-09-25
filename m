Received: from gimli.kloenk.de (gimli.kloenk.de [49.12.72.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB671D5AD7
	for <patches@lists.linux.dev>; Wed, 25 Sep 2024 22:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.72.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727302720; cv=none; b=rrzUw+1xRA6FHyU82BYi8qcL+gWmWvVUpP+HLDb+uP4h6oO5Sv+IMMOh5eBc6C5dTqOTCSqXESY06B3PSRLGcIy9z1UlxFYgg/j5CL4UFyYW3F9TVP0Ic4BLhY2/oFSq1uzb7teZ3jxeo6nnUFT8ziRruX0EsRCIqnMfaNX3biY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727302720; c=relaxed/simple;
	bh=LE/5H5zddx11cGwxEelSyFu3Z0cdaUyMfdlq01FKTrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RX8W/eNl3inWKkyQjmprsC3cLLD5RVWRgMCe5vD7E+nBWLc2uJWF+pLbcn6HL/9HRpHNy14nipTcVzuB0RvGmZCfRoLwT/pOFMvurQD6WuaF4wkPcfp4lblMALkYEpuvViudDfEP5PkKQWB2ZiGCHT4Y1NK9zqiQIpmNNl/YSNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kloenk.dev; spf=pass smtp.mailfrom=kloenk.dev; dkim=pass (1024-bit key) header.d=kloenk.dev header.i=@kloenk.dev header.b=X+mmF8Oy; arc=none smtp.client-ip=49.12.72.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kloenk.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kloenk.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kloenk.dev header.i=@kloenk.dev header.b="X+mmF8Oy"
From: Fiona Behrens <me@kloenk.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kloenk.dev; s=mail;
	t=1727302706; bh=qsa3hcM4i4uNxtF6Iy7B4Yg0mIWoDrXBhaA6O7F5E5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X+mmF8OygJ/RftH5zAL9e35qpGLQWLF+HPFWIWm6SCJCJ0WwfHWNt+hxu9QgZmLhD
	 OvJUVZj5vAhXjeUL4zThrQgHw1ZieaLiiPyX3TagHYFeUY6vtbRB3aZ+HENP4eWI+O
	 uScMONVmtobmy0JYbVNp036c6tg3G4X11kFgOevw=
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] rust: cfi: fix `patchable-function-entry` starting
 version
Date: Thu, 26 Sep 2024 00:18:25 +0200
Message-ID: <EE8681B8-817B-416B-9486-4380F277F30B@kloenk.dev>
In-Reply-To: <20240925141944.277936-1-ojeda@kernel.org>
References: <20240925141944.277936-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 25 Sep 2024, at 16:19, Miguel Ojeda wrote:

> The `-Zpatchable-function-entry` flag is available since Rust
> 1.81.0, not Rust 1.80.0, i.e. commit ac7595fdb1ee ("Support for -Z
> patchable-function-entry") in upstream Rust.
>
> Fixes: ca627e636551 ("rust: cfi: add support for CFI_CLANG with Rust")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Hit this today, nice that it=E2=80=99s now fixed

Reviewed-by: Fiona Behrens <me@kloenk.dev>

> ---
>  init/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/init/Kconfig b/init/Kconfig
> index 4ea2a161d362..89bbd0b8bdb7 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1911,7 +1911,7 @@ config RUST
>  	depends on !DEBUG_INFO_BTF || PAHOLE_HAS_LANG_EXCLUDE
>  	depends on !CFI_CLANG || RUSTC_VERSION >=3D 107900 && $(cc-option,-fs=
anitize=3Dkcfi -fsanitize-cfi-icall-experimental-normalize-integers)
>  	select CFI_ICALL_NORMALIZE_INTEGERS if CFI_CLANG
> -	depends on !CALL_PADDING || RUSTC_VERSION >=3D 108000
> +	depends on !CALL_PADDING || RUSTC_VERSION >=3D 108100
>  	depends on !KASAN_SW_TAGS
>  	help
>  	  Enables Rust support in the kernel.
>
> base-commit: a2f11547052001bd448ccec81dd1e68409078fbb
> -- =

> 2.46.2
