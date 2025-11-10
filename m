Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50F6309EEC
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 11:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762775250; cv=none; b=NgjHEjNBs3Utau4boZ0x5hRp839qc3OXPqcizXeYkkpv4bWizAfPk41zWCtX1Yx7nHX6VhYJlmLhLR255KO764fHENd2AObJDgy5G+e8UAIctk0QAeP5xATHEQi2ehB0Dfc+u0/MWJAM+IP4eYcd/MjTPVMf6KuwenLxl+z8p8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762775250; c=relaxed/simple;
	bh=Certre8NKMBWjJMOdCkjiT37S95gzPpjFWT1M8r9T2M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DmY+6bjNb30mytMUnolv0EcTg/zpgpZDc2GwW2SzwcA88YQo0wuDbawZB+2sdjfUANEci15yAT/QxWjQ8rCasLiGRfpEUtB5NW6LuiVXzcIA8sAKDLcV1x/8JuMJluD4jktcsASeOn3cGlWJps+6w9H33btDY5DhPaskMOg2saw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QkiBUjmj; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QkiBUjmj"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-42b2c8fb84fso821319f8f.2
        for <patches@lists.linux.dev>; Mon, 10 Nov 2025 03:47:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762775247; x=1763380047; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yAt7Z27w/lXRkHSeX0o2zGMIVMbZvME2esCv61DwS7Q=;
        b=QkiBUjmj+xVV60xHRz6GjK24EqEwvM9vkzSOOfJeSgkWZ5zkr2CHF/OB2xSOkrbuxA
         jyG1kJCGmLi2+vGnUxhrPXmfrMDOXGySwIHVPW7gdrLTdKzz32x0HuEH63dFM7buIL/e
         8QWzKvIAATOh5J31wZZ6XEoL/pGQ+KOWRumr4kdsCw4nVymKYUbnTso8EV3waAUcH1bx
         0bexpkAedNZgRMKxAk4pZ7vqMzSMJa9JdJSdanErx/Yn7AJs+quDX7YZn62P9+jmLPFM
         h9Kjjr0O8L+gq27FRsc3l4uFET32CteBZNmzoWKIzL8oZ/KfSy3FgiUNaTL3IyzLx8iN
         ghlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762775247; x=1763380047;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yAt7Z27w/lXRkHSeX0o2zGMIVMbZvME2esCv61DwS7Q=;
        b=s+IeJ7KQyRZ04Lo06WAJ/QAE4U57u/IHVMqsemhAEq3Qg5iRYrLG2SZZel4t/4pNJg
         wlTKAHS4OfaVQCX41cZip7EsiprkRAVKk9oyn13p6et1bP98hBfRzmvktm/BE2t1rssJ
         EZ6vmzTm9TdIrHjdShCUrJzTCA1oErXTEwbrxJaMfsA5BmtB5P43rAny7cqCfp3/Grqz
         IbHnRsEDCYXHNF73vNAj9BCJZoe/Zp/qSJhCHlmqTNOYdUKdCI48Yxpy+iFCGrdJzgp7
         r68q2klg7qc4zFYHDeq6R4AEhp7Glq+u+TBz0bn38akKt/2XmRFm5eQxkVlu5W6WWSOe
         fiaQ==
X-Forwarded-Encrypted: i=1; AJvYcCWCqcv0lw7WMxBCl/EJDyZLUKwzVXcF+ZCBVhuZzDKyXS0Z3kemndVzStJqouDV06DDnXrVXNCQ@lists.linux.dev
X-Gm-Message-State: AOJu0YwTi0LTHv+u5kPn/An1EFO9gra12YfVOcnETnuFuGfB9tgBq178
	lltk2NLGopL4ol+H396JTrzf0k1fkZSb0Ru/b2810/oZ4mk95PmQhXu+4JEyt9U+wSxQ1XeJkTM
	vGSoTd2fyjRqOypEULw==
X-Google-Smtp-Source: AGHT+IHCLy2mdnxpnK0+nxJnKpheaCzAh9ChVq3lvYBA5uZFfrDQycfDIP5ZYdgDCadZ+3ZCgwyWUNwt33mUhMs=
X-Received: from wrbfp24.prod.google.com ([2002:a05:6000:2798:b0:429:ef2d:571d])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5f96:0:b0:429:d004:bb2c with SMTP id ffacd0b85a97d-42b2dc6c8a9mr5644715f8f.57.1762775247005;
 Mon, 10 Nov 2025 03:47:27 -0800 (PST)
Date: Mon, 10 Nov 2025 11:47:26 +0000
In-Reply-To: <20251110095025.1475896-18-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251110095025.1475896-1-ojeda@kernel.org> <20251110095025.1475896-18-ojeda@kernel.org>
Message-ID: <aRHQztaAl6Hi67FM@google.com>
Subject: Re: [PATCH 17/18] rust: syn: add `README.md`
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="utf-8"

On Mon, Nov 10, 2025 at 10:50:22AM +0100, Miguel Ojeda wrote:
> Originally, when the Rust upstream `alloc` standard library crate was
> vendored in commit 057b8d257107 ("rust: adapt `alloc` crate to the
> kernel"), a `README.md` file was added to explain the provenance and
> licensing of the source files.
> 
> Thus do the same for the `syn` crate.
> 
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  rust/syn/README.md | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>  create mode 100644 rust/syn/README.md
> 
> diff --git a/rust/syn/README.md b/rust/syn/README.md
> new file mode 100644
> index 000000000000..d3e3981da2fe
> --- /dev/null
> +++ b/rust/syn/README.md
> @@ -0,0 +1,13 @@
> +# `syn`
> +
> +These source files come from the Rust `syn` crate, version 2.0.106
> +(released 2025-08-16), hosted in the <https://github.com/dtolnay/syn>
> +repository, licensed under "Apache-2.0 OR MIT" and only modified to add
> +the SPDX license identifiers and to remove the `unicode-ident`
> +dependency.
> +
> +For copyright details, please see:
> +
> +    https://github.com/dtolnay/syn/blob/2.0.106/README.md#license
> +    https://github.com/dtolnay/syn/blob/2.0.106/LICENSE-APACHE
> +    https://github.com/dtolnay/syn/blob/2.0.106/LICENSE-MIT
> -- 
> 2.51.2
> 

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
