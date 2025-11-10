Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8691A211A14
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 10:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762771956; cv=none; b=a12zPwaaCsU/s9Ac6oofPOKN6rCvPQ/zVMX1m9KXW1bGhgHm4gDXMDS0zlVPIGtY1Gj7cAarJGBJ1myQGeu1LFbUn13zO5HqdGs8gU11dZG5ZrFnKcMKcGbB3nwb7y73m86DSEkojhXhbgf8fofLlu9+b4SroVeiNG6BEi2HQXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762771956; c=relaxed/simple;
	bh=g1oy0my9Z+ccbHHb+iF/yvdsIdcE9KiibVk4bik3RqI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rxQgIEOBEeHK3sA5TWtntKke+5b72PL09YPs02hqsRZD9cJIFhwcmbgfHgnpp+sLP366XR1k791dazGJ04chS88tCRg2M5prE31zoMoLnoHaZglRIJM6lvID8s3O0dm87J66xnzYnrN79Cmo8bK4zeojAhU6oxf2hU6mxfh9CPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZX3AV8CN; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZX3AV8CN"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-46e39567579so15307595e9.0
        for <patches@lists.linux.dev>; Mon, 10 Nov 2025 02:52:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762771952; x=1763376752; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=N6NZ9bgEr68vNmFOnWb6hMPpN/BBFhK5I6oSe3Kfhy0=;
        b=ZX3AV8CNP3yzkWqxhswvSLhB0q8Gy+mbfRNm+lWr+02GfcYGJQBEu/c46tyBRPTuuD
         mz0781lMye7/Wuj/GnSMSLaIIPJzMT+q6ES22V9DiPDOFYWMRegErqvlJXHhRjZ5ziF4
         sGni2IHFu9fVJqTXpm3EijkdKnOA+TxlRJxIgDM5oScL/jM95WPjd6seQ5DNGI3fMbYb
         Kj+Do5aYCiH4GiH5Nwxu1vHViHvkU+6KfH4tJNb8qOi9P5oD65973NK0qMe4CemZMqz2
         eMh8wcnEGsmxZLB4SgAHJHEAobCCK7CtgkpH7YSdSiXwYd6eMP2bJAVk2npXXc93fFH3
         +Cfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762771952; x=1763376752;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N6NZ9bgEr68vNmFOnWb6hMPpN/BBFhK5I6oSe3Kfhy0=;
        b=BV3MxgnDO8C8GyT8Bzcj4RJgq5b1a8RjS6GFGBIgcmytBBhsT6f/wn+hRkkOBiHTnC
         iS+28d1Y23VJ8AnL61MsOpdpknrNGS9+VZsvTIe8Wa8irhRsu4O9eCsRMJcLf0zw8+AY
         mPqsI07YMqu/gGPWulxSj9prYB9Aq2GaLG3eQOWQ5UJdWxb5bEFmCxJQ7+zfurENMgv0
         4aCw4aePeqOgC3Vuz2svd9ag4rMoG7d4MwpSp/hZ+Wk0YlcsqUtlRDQk5ctk2vFZbhn4
         SgW7W3h/3bMcbbqLW0Eg7IQlc+BGAR0ZAuuNA0CKZ2XLJiDZhmi7FQHtljdPf0LPqud2
         wvhA==
X-Forwarded-Encrypted: i=1; AJvYcCVdTqFucbGGfAQXe2kmmokPlbXZLW6qbtI21IMYamSd91x8CD4iCmHdpPSbxTvLp7A6uQS8Jj8N@lists.linux.dev
X-Gm-Message-State: AOJu0YyDt/9REKa+FfOhOncDpEr0YBaCTQ1QNvpbKHE25/z+psfgTrh1
	hZz2DHKtCYR3OSKh5juhQffj+nbabeqGTBedREQw/zuZsT1rxdB+GugLD9na5bisGSrNwCqopnw
	HI+51CpB+AfD5MFnT+Q==
X-Google-Smtp-Source: AGHT+IHLTlx/88ANqEFu1mmPKn7N2gVA3BGY0KVpSBasitym/dwRaUr5k7lI5g/0T3mMBoRLLo/Kvlowmg2Jd7c=
X-Received: from wmjf14.prod.google.com ([2002:a7b:cd0e:0:b0:475:d8de:fe5b])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:524a:b0:46f:d682:3c3d with SMTP id 5b1f17b1804b1-4777323eb5fmr65374595e9.13.1762771951937;
 Mon, 10 Nov 2025 02:52:31 -0800 (PST)
Date: Mon, 10 Nov 2025 10:52:30 +0000
In-Reply-To: <20251110095025.1475896-9-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251110095025.1475896-1-ojeda@kernel.org> <20251110095025.1475896-9-ojeda@kernel.org>
Message-ID: <aRHD7m2f7CS_LGK4@google.com>
Subject: Re: [PATCH 08/18] rust: proc-macro2: add `README.md`
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

On Mon, Nov 10, 2025 at 10:50:13AM +0100, Miguel Ojeda wrote:
> Originally, when the Rust upstream `alloc` standard library crate was
> vendored in commit 057b8d257107 ("rust: adapt `alloc` crate to the
> kernel"), a `README.md` file was added to explain the provenance and
> licensing of the source files.
> 
> Thus do the same for the `proc-macro2` crate.
> 
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  rust/proc-macro2/README.md | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>  create mode 100644 rust/proc-macro2/README.md
> 
> diff --git a/rust/proc-macro2/README.md b/rust/proc-macro2/README.md
> new file mode 100644
> index 000000000000..af044fee4f59
> --- /dev/null
> +++ b/rust/proc-macro2/README.md
> @@ -0,0 +1,13 @@
> +# `proc-macro2`
> +
> +These source files come from the Rust `proc-macro2` crate, version
> +1.0.101 (released 2025-08-16), hosted in the
> +<https://github.com/dtolnay/proc-macro2> repository, licensed under
> +"Apache-2.0 OR MIT" and only modified to add the SPDX license
> +identifiers and to remove the `unicode-ident` dependency.
> +
> +For copyright details, please see:
> +
> +    https://github.com/dtolnay/proc-macro2/blob/1.0.101/README.md#license
> +    https://github.com/dtolnay/proc-macro2/blob/1.0.101/LICENSE-APACHE
> +    https://github.com/dtolnay/proc-macro2/blob/1.0.101/LICENSE-MIT

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
