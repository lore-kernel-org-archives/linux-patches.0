Received: from gimli.kloenk.de (gimli.kloenk.de [49.12.72.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4C423DE8D
	for <patches@lists.linux.dev>; Tue, 10 Dec 2024 10:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.72.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733825929; cv=none; b=p5BIWrdpDd1a+oupoD/M7sDrAoQnK8CImhSEB4Fp8WxZMuOqHFVX96efn6FUPEAQWS7qazXj1KKWBU1D9DBg3aoidMvdcs4i0V+glZ/4wfL2Rz5yCsiWEFX8bd8z4pcYSfOqtMlD95sRsrdhy8htIYWBR72bzGYsdFjcIUS8VZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733825929; c=relaxed/simple;
	bh=Nj05O/ueN/PMCm5p4N1zDixMdHIiDU9Yqel2bHGFdQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jodLd1u095P7DMcbqN/VJwZT2+E7YvTBzV1wfOWOkB8iWNX0DTu3ra3R9zSiL3Fchrki4Qdh848hWE1PyHKkZzqzTJJ9FqjLK4Ew9oitH2d1AfBOKWj4G6G0uj020i0eX5aP+qmhCRuZLIM4U8CPdti2wUql3KjLPIfXGEaWcmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kloenk.dev; spf=pass smtp.mailfrom=kloenk.dev; dkim=pass (1024-bit key) header.d=kloenk.dev header.i=@kloenk.dev header.b=tCjew8Fl; arc=none smtp.client-ip=49.12.72.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kloenk.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kloenk.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kloenk.dev header.i=@kloenk.dev header.b="tCjew8Fl"
From: Fiona Behrens <me@kloenk.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kloenk.dev; s=mail;
	t=1733825925; bh=znw9RaPDGdZv374XX1ZIqQi1J1m6y/QWq9gDvavyvQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tCjew8FlvciVZ73tkgrEjFvkxLIG2ETPTuX2yUH6sOfN9PSvC/Tj9w/ZjDjk7QETX
	 eFXJZTRjtazxAW6uSvCx1t6pspw3r7pCn2C9ufb13O6B8PagnPxSEm081u5WfaRxbr
	 InakM2F118yzlooG9tYTT1g/rsaFukzUYyXlHNmY=
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <benno.lossin@proton.me>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] rust: document `bindgen` 0.71.0 regression
Date: Tue, 10 Dec 2024 11:18:44 +0100
Message-ID: <AE7176FF-D196-4199-AA8C-B16FBC31B417@kloenk.dev>
In-Reply-To: <20241209212544.1977065-1-ojeda@kernel.org>
References: <20241209212544.1977065-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable



On 9 Dec 2024, at 22:25, Miguel Ojeda wrote:

> `bindgen` 0.71.0 regressed [1] on the "`--version` requires header"
> issue which appared in 0.69.0 first [2] and was fixed in 0.69.1. It has=

> been fixed again in 0.71.1 [3].
>
> Thus document it so that, when we upgrade the minimum past 0.69.0 in th=
e
> future, we do not forget that we cannot remove the workaround until we
> arrive at 0.71.1 at least.
>
> Link: https://github.com/rust-lang/rust-bindgen/issues/3039 [1]
> Link: https://github.com/rust-lang/rust-bindgen/issues/2677 [2]
> Link: https://github.com/rust-lang/rust-bindgen/blob/main/CHANGELOG.md#=
v0711-2024-12-09 [3]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Fiona Behrens <me@kloenk.dev>

> ---
>  init/Kconfig                 | 6 ++++--
>  scripts/rust_is_available.sh | 6 ++++--
>  2 files changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/init/Kconfig b/init/Kconfig
> index a20e6efd3f0f..e8d2b5128f87 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1989,8 +1989,10 @@ config BINDGEN_VERSION_TEXT
>  	string
>  	depends on RUST
>  	# The dummy parameter `workaround-for-0.69.0` is required to support =
0.69.0
> -	# (https://github.com/rust-lang/rust-bindgen/pull/2678). It can be re=
moved when
> -	# the minimum version is upgraded past that (0.69.1 already fixed the=
 issue).
> +	# (https://github.com/rust-lang/rust-bindgen/pull/2678) and 0.71.0
> +	# (https://github.com/rust-lang/rust-bindgen/pull/3040). It can be re=
moved
> +	# when the minimum version is upgraded past the latter (0.69.1 and 0.=
71.1
> +	# both fixed the issue).
>  	default "$(shell,$(BINDGEN) --version workaround-for-0.69.0 2>/dev/nu=
ll)"
>
>  #
> diff --git a/scripts/rust_is_available.sh b/scripts/rust_is_available.s=
h
> index 93c0ef7fb3fb..d2323de0692c 100755
> --- a/scripts/rust_is_available.sh
> +++ b/scripts/rust_is_available.sh
> @@ -123,8 +123,10 @@ fi
>  # Non-stable and distributions' versions may have a version suffix, e.=
g. `-dev`.
>  #
>  # The dummy parameter `workaround-for-0.69.0` is required to support 0=
=2E69.0
> -# (https://github.com/rust-lang/rust-bindgen/pull/2678). It can be rem=
oved when
> -# the minimum version is upgraded past that (0.69.1 already fixed the =
issue).
> +# (https://github.com/rust-lang/rust-bindgen/pull/2678) and 0.71.0
> +# (https://github.com/rust-lang/rust-bindgen/pull/3040). It can be rem=
oved when
> +# the minimum version is upgraded past the latter (0.69.1 and 0.71.1 b=
oth fixed
> +# the issue).
>  rust_bindings_generator_output=3D$( \
>  	LC_ALL=3DC "$BINDGEN" --version workaround-for-0.69.0 2>/dev/null
>  ) || rust_bindings_generator_code=3D$?
>
> base-commit: fac04efc5c793dccbd07e2d59af9f90b7fc0dca4
> -- =

> 2.47.1
