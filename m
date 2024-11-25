Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E721D190052
	for <patches@lists.linux.dev>; Mon, 25 Nov 2024 09:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732526064; cv=none; b=Q2Z2F/HQ8djUivK8gNeWTNRbNMtft3dFq1XdWI0FGcTD9cAI53UVNbeLztE+1pN/8FU4J2RgrYTDvDCix3/YWhuR6ZFHUS9be9STtXLuduXWeZlMQjgQVVBGaihEpRssXCBrhu9IiZj2TEUx+FJ+BHOfa3J6Z23cyfa9aSG8sRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732526064; c=relaxed/simple;
	bh=uSsPtNnVteIM2BzthXpkxL9YoGLmPqhmZKg37rTE7Tk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WJGweuG9PV5rpcSQol3/W7PUL0Sp2NDwSdP21dxV9H+qCJ3A1vsYFgU4lCsGOZgi49e4CN50L5C7qnlMGZo0uQzYb7fiEwgh2MuvHUdA1smq9T76E5Gq1j533xDmhKlj6vnd1NsMHhCscvK4W3I24Zv5/lfvnkAmhCdzlfqVjNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jsEMs49M; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jsEMs49M"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-38248b810ffso3175157f8f.0
        for <patches@lists.linux.dev>; Mon, 25 Nov 2024 01:14:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732526061; x=1733130861; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PrdMiDJt5vduIxa0PY5GoA+617/ZMEzbh2yCH7ixs2Q=;
        b=jsEMs49MhXIBWuI3Ed7HtVlKsAJUW672cfj2dDCcIN+RLKmepQuNsb8ZV73iDXEFun
         uEAt0jAd3xqAkzqMc4xnj9SQuTg+7bkDwCTDLvS9I+yrOrYdQMn/RBAQrzcP16LGTFmH
         ptmhxsj5vzlDX8Rzm1hoC1iOZhTQpsmxNNvEeHIdKVdxHO+UTFqhV6A51ZvzSbpGYDhf
         JcrMB0+Tzxv3+o06sY3XhQ7V/gqswzx1eS/c7rXe10de1wuRMJswvdpPwZSsF3jYWXDc
         5sFdbQg14hyS/yerH2YrIePiTgnV8+MNVB0c63bwEcjlmNRr4enAjLeds2vvgc3v04vG
         W2AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732526061; x=1733130861;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PrdMiDJt5vduIxa0PY5GoA+617/ZMEzbh2yCH7ixs2Q=;
        b=rNoodqROvvBEz1fcypl5drELWQvOQalRxAEbPLTOpBTP7cuXXJ+YVUcZo/qT/6PTQN
         a6Phnzz2qEeBDGuK6QM8VLSUnskPvbe7ZnS6zJSnExxCPN6GuSinWOOSZdjhT+VUVUoE
         CLlX8s1Hr8j/GK8BLzwuOmQp1PjXM1EdEt82Qt8ODV9mdbeg5PdsbLXdrMh5lzleRzx6
         6oNQZt/3/rxTk5GhXLP+m1WDAfybUL2JZvIAPPEpwjvmLKqM0R0q7TqV9ejiv2fWS36E
         ITlPtDaMBoQUvjmetMjHC3rugDQgEDJ1ByJQ7kI4JyqwPBn3Ef5jxw3ZfFHLGkwyVZp3
         Jucw==
X-Forwarded-Encrypted: i=1; AJvYcCVrinePQGd4irmeadGFHxnTYZb1MBX62lIzeyC9f+lIzQhk7Qk9xSqpp9gYSVqUVHzkdYlXMMJb@lists.linux.dev
X-Gm-Message-State: AOJu0YxtE6yWrMXVS0+nNlOFvgiVjl3t1Jzl+k59zsvmJIUyU6LA7K6z
	ayDfsjS+Qp53FyyN94UycE/9xsuOC4s8TvkkRIUZ3hAbfwy9FMaJpaWSRBtStHZpQi2pQzDucXG
	Rp+9WwFdStighPncfSTFPsQDFmjZ7cW03hnlU
X-Gm-Gg: ASbGnctLoI3Pb9klqgTKnSg8u63VX5ElmNr6qrH7ddUQPeYHtdWfIAoafGxiqxfAHve
	SHD3FFx/Puei0kt9XvWKQHAeTrnMlxZABiIrtJ9za0NEM5clFCVuL+n8reCAoGw==
X-Google-Smtp-Source: AGHT+IEOwMk3vapdbNHpELN0oZ6s3oro3YnZRn8GCOYxBikHFeMCXOFfPD4cUTzyUloMpcTHt84sQUv4Gf+wLfw8W4o=
X-Received: by 2002:a05:6000:23c5:b0:382:3e51:4b1d with SMTP id
 ffacd0b85a97d-38260b59530mr6868816f8f.20.1732526061276; Mon, 25 Nov 2024
 01:14:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241123222849.350287-1-ojeda@kernel.org> <20241123222849.350287-2-ojeda@kernel.org>
In-Reply-To: <20241123222849.350287-2-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 25 Nov 2024 10:14:09 +0100
Message-ID: <CAH5fLggK_uL0izyDogqdxqp+UEiDbMW555zgS6jk=gw3n07f6A@mail.gmail.com>
Subject: Re: [PATCH 2/3] rust: kernel: move `build_error` hidden function to
 prevent mistakes
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, FUJITA Tomonori <fujita.tomonori@gmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Trevor Gross <tmgross@umich.edu>, 
	rust-for-linux@vger.kernel.org, netdev@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 23, 2024 at 11:29=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> Users were using the hidden exported `kernel::build_error` function
> instead of the intended `kernel::build_error!` macro, e.g. see the
> previous commit.
>
> To force to use the macro, move it into the `build_assert` module,
> thus making it a compilation error and avoiding a collision in the same
> "namespace". Using the function now would require typing the module name
> (which is hidden), not just a single character.
>
> Now attempting to use the function will trigger this error with the
> right suggestion by the compiler:
>
>       error[E0423]: expected function, found macro `kernel::build_error`
>       --> samples/rust/rust_minimal.rs:29:9
>          |
>       29 |         kernel::build_error();
>          |         ^^^^^^^^^^^^^^^^^^^ not a function
>          |
>       help: use `!` to invoke the macro
>          |
>       29 |         kernel::build_error!();
>          |                            +
>
> An alternative would be using an alias, but it would be more complex
> and moving it into the module seems right since it belongs there and
> reduces the amount of code at the crate root.
>
> Keep the `#[doc(hidden)]` inside `build_assert` in case the module is
> not hidden in the future.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

> diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
> index bf8d7f841f94..73e33a41ea04 100644
> --- a/rust/kernel/lib.rs
> +++ b/rust/kernel/lib.rs
> @@ -32,7 +32,8 @@
>  pub mod alloc;
>  #[cfg(CONFIG_BLOCK)]
>  pub mod block;
> -mod build_assert;
> +#[doc(hidden)]
> +pub mod build_assert;

You could also put #![doc(hidden)] at the top of build_assert.rs to
simplify the lib.rs list. Not sure what is best.

Alice
