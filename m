Received: from mail-24416.protonmail.ch (mail-24416.protonmail.ch [109.224.244.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D47198A34
	for <patches@lists.linux.dev>; Mon, 24 Mar 2025 22:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742857169; cv=none; b=GJOJhMnCobbDYJxEoXVz61MGJf5Jlpm0KqMtMTgKVMknbgWenvU3ZXhy0hnrM/u2xlJ80WSkzQnA4C+LOe4rvgECjAzrk+HymVAf0c7mn9DRpIQ3BPzUJ+AvvTpcnmJf9k5S4L3HxkSZD9RWY/zwZ+Z1meyt/z9A8K0sLGhnujA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742857169; c=relaxed/simple;
	bh=j3AtbBepxVY9t4s2Hi3h6u0/eJQIjx5Yl0Fb4JK3+wM=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aEyXnaLDHTMn+J+xstuoNqMxwQUuL/nMk/uc3UNdhEn+JW4Tots+UEiUyrv1xiWojVfbj4rzxmWeuTSG10bRY0WAu4TvSgTIqTLbPWPSEigONb/g30oTOfvukG91WlWgQQDs0Re4/mNvfkM/fa6e7p7/hbexbfmPT58IMK//Sd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=Ju3AGeh6; arc=none smtp.client-ip=109.224.244.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="Ju3AGeh6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1742857165; x=1743116365;
	bh=UkVSl0Pru0KKuSb5x4nU9T1S7nrs/LDzBYVaKWSryss=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector:List-Unsubscribe:List-Unsubscribe-Post;
	b=Ju3AGeh6bAflmU8tuB2a6+dalFaD10S3vxKIbxUhAJW7AignUSoB38bGeKyJHzt4F
	 OkdEmupXefgu5Ww1ORUuoFlmdo47WFJunrqMikr/nFjqV5htyQmsrTQoaEY89EEJLT
	 32uVMpqQ8FB8SlQv550UB+58IszlOaLIL8sWBCEnntZKNdUgrjlASsGmP9tav3X63K
	 IYnntr8zEzmvGdnqkNrO5Be4BwyTAe4luxOAbT5cEw8TcPIDouJFdQQji37efTod9X
	 mj3KMNAdwNz/205DGVTQkKQMw1EM2yAMsmAmSY4DK0vmJkA1yNU2mvy8+53U8vj0GF
	 onIJkEpOy7qPw==
Date: Mon, 24 Mar 2025 22:59:22 +0000
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>
From: Benno Lossin <benno.lossin@proton.me>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 00/10] rust: clean and enable Clippy `doc_markdown` lint
Message-ID: <D8OVATSS19YC.1GXZRNM6TBA0X@proton.me>
In-Reply-To: <20250324210359.1199574-1-ojeda@kernel.org>
References: <20250324210359.1199574-1-ojeda@kernel.org>
Feedback-ID: 71780778:user:proton
X-Pm-Message-ID: f923cfed497f62b6bdc1c007c1284d6c95c1ef17
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon Mar 24, 2025 at 10:03 PM CET, Miguel Ojeda wrote:
> This is how it would look like -- I am not sure how many false positives
> we will get, so I marked the last commit as RFC and perhaps we just want
> this lint as an opt-in in e.g. `W=3D2`.

I think we should try. If it's too much trouble, we can disable it
again.

> However, so far, we only got one ("KUnit"), plus a couple others that
> are in C side comments that were copied, and thus someone may want to
> keep them exactly in sync. So it seems pretty OK so far.
>
> Another question is whether we want to commit to something like the
> global list in `.clippy.toml`.

Not sure what you mean by this, but I think we need some way to disable
it for some acronyms.

> Anyway, please take a look -- the other commits should probably be
> picked even if we do not enable the lint.

For the entire series:

Reviewed-by: Benno Lossin <benno.lossin@proton.me>

---
Cheers,
Benno

> Thanks!
>
> Miguel Ojeda (10):
>   drm/panic: add missing space
>   drm/panic: add missing Markdown code span
>   rust: alloc: add missing Markdown code spans
>   rust: alloc: add missing Markdown code span
>   rust: dma: add missing Markdown code span
>   rust: of: add missing Markdown code span
>   rust: pci: fix docs related to missing Markdown code spans
>   rust: platform: fix docs related to missing Markdown code spans
>   rust: task: add missing Markdown code spans and intra-doc links
>   rust: kbuild: enable `doc_markdown` Clippy lint
>
>  .clippy.toml                        |  4 ++++
>  Makefile                            |  1 +
>  drivers/gpu/drm/drm_panic_qr.rs     |  4 ++--
>  rust/kernel/alloc.rs                |  4 ++--
>  rust/kernel/alloc/allocator_test.rs |  2 +-
>  rust/kernel/dma.rs                  |  2 +-
>  rust/kernel/of.rs                   |  2 +-
>  rust/kernel/pci.rs                  | 15 +++++++++------
>  rust/kernel/platform.rs             |  9 +++++----
>  rust/kernel/task.rs                 |  4 ++--
>  10 files changed, 28 insertions(+), 19 deletions(-)
>
> --
> 2.49.0


