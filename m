Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFED818F2FB
	for <patches@lists.linux.dev>; Mon, 25 Nov 2024 09:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732525798; cv=none; b=gHM9rATD9c+nDzn7BOqYDcJFY7vYeYhuM12CmZoAnTrDeqhDHPM0G5GD29UgFL1o7nGhQ6/FQIxSt4kP685yu8aG1wt/6oWkuVPoimd6DjqbXx+8Cq/qTF0j8l6Q1u8MlvBhoEjEGgVTT4o1WneQWlU/QxJJyVOuAg/HC0S6uwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732525798; c=relaxed/simple;
	bh=+iYj/LXeXfLCayyBoWgVOM4VHVy9tGibHOMx4/PqDv0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e8Ae7dwfG8JFcMWv08tLZVGq+mAqasw6QipRYJAawEn4/rhcXDigIFNoZ0V6ZRj+awWR0sAD9v5cD5qE7MdPUzApX7CUSeQDBNLYLiKOZG+28CtMZJx37jlcsMlD+ncoIXdPzu5vJGnX2b0o85RGnXEgQk/eszoqPG1htUm6qTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NvIKXnGr; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NvIKXnGr"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-38248b810ffso3171858f8f.0
        for <patches@lists.linux.dev>; Mon, 25 Nov 2024 01:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732525794; x=1733130594; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+iYj/LXeXfLCayyBoWgVOM4VHVy9tGibHOMx4/PqDv0=;
        b=NvIKXnGr3PryQwHShonaP/Iync5F/mswWE+mwg0vW8NJ7S3mZuoYNbLIEWHa08k+hu
         jWp/dKKE/qvCMNpl1OBMy1Oqkmk/iJ6rQUFDfm1kD4VDSee+q7Z5xtdj3gwrc2M1NP3p
         U4QjQajl0k0BdVOI1aS/uGPRz4DST5CxUBRlqCachRgxUdYLoqEqdM+p58CXoi64ggcg
         kMU5T7RpcaRo01D6lyU+geWFK88MmWYm53nosnAxpdxqclU8v6wULtkqjUR1FpOp5Ntb
         Cd9Ma6Xwg8iZ3RVBPnRByPLVMCuCMtF/m+7OfWlvhuWX5xXM3J8WpHkLhYMdlz4xTSof
         N6dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732525794; x=1733130594;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+iYj/LXeXfLCayyBoWgVOM4VHVy9tGibHOMx4/PqDv0=;
        b=WwPshDQaQn6/s8cMNOTbIUZgSZDrBBwEkxfk94/188yNUyMeCP9FBf36RDVUJnH1Em
         TsA5Q+jkFBsKIzELdYdfBBkqiw/5jiloe+MqwoqtHtcoQiIcONjjE3VbP81xNzc5hvhx
         Pnx1fkH7wV4k5ROWdzeqcI/a2pIL3HcTC3hkCrOuJTZ8K79a2uvW5oZ4zSj6WFaZ7pHO
         SgoSckbPhVczVspw+punCbog2JutSQE3HuRw+iRNIy8MB9I3ARD6dVUJJS7sxHQToTwR
         w2Iw/bHsP4zOAYNMnZMeuRlMC4RK2YBO4EQoYL7PVVaQV6axGxRiZE/sCui3cWdG11oW
         Z9Fw==
X-Forwarded-Encrypted: i=1; AJvYcCXkXZbvuS0Utbq08LeClqLN21Ce3fO7CEqC6Z5ZSZxY1gg/kNuwlW5gkZAhKRDDWXXWYinnQIMr@lists.linux.dev
X-Gm-Message-State: AOJu0YzvTOKZjmDWDbC8gNV1lGk0tUu8V2DQiQyqY4DFX3P6ym/8OF0o
	hkiQZEtCzEImlbsJ2LhlgjdTkPpl35gXj4tb5VMGQcjiMxwrkVNkBrf9siUCUuLMubYIQ+k4rr3
	EXBq1god/dtUYM6irb+189mQjJpg4uPcHncrZ
X-Gm-Gg: ASbGncvYDtFTWI5c859/BV6hkN9pTjl4ZRKh3U34q9NAXMWzsKaPsOd4h0mggvdhq19
	hU2fuJl+h2jqlN2xpv6V0wXObLe5tm57OTKWqvIu/IrrooxbXAw1xVheNcuT4/A==
X-Google-Smtp-Source: AGHT+IGUuEuCPmk+t9yOajZz2nGezK7YqZW9Qfb/96OWC3HZfQsiSBJ5BzwP+t8u98N6IXgnX1LVesACO+Kn/Ohc0AA=
X-Received: by 2002:a05:6000:1aca:b0:382:3210:4de0 with SMTP id
 ffacd0b85a97d-38260bcba20mr9942093f8f.44.1732525794090; Mon, 25 Nov 2024
 01:09:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241123222345.346976-1-ojeda@kernel.org>
In-Reply-To: <20241123222345.346976-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 25 Nov 2024 10:09:42 +0100
Message-ID: <CAH5fLghVxRbiNTVBF=Xh77gGGTF8K+jtgFFSe5HRSS_76GdttQ@mail.gmail.com>
Subject: Re: [RFC PATCH] rust: give Clippy the minimum supported Rust version
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 23, 2024 at 11:24=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> Clippy's lints may avoid emitting a suggestion to use a language or
> library feature that is not supported by the minimum supported version,
> if given by the `msrv` field in the configuration file.
>
> For instance, Clippy should not suggest using `let ... else` in a lint
> if the MSRV did not implement that syntax.
>
> If the MSRV is not provided, Clippy will assume all features are availabl=
e.
>
> Thus enable it with the minimum Rust version the kernel supports.
>
> Note that there is currently a small disadvantage in doing so: since
> we still use unstable features that nevertheless work in the range
> of versions we support (e.g. `#[expect(...)]`), we lose suggestions
> for those. However, over time we will stop using unstable features
> (especially language and library ones) as it is our goal, thus, in the
> end, we will want to have the `msrv` set.
>
> Rust is also considering adding a similar feature in `rustc` too, which
> we should probably enable if it becomes available [2].
>
> Link: https://github.com/rust-lang/rust-clippy/blob/8298da72e7b81fa30c515=
631b40fc4c0845948cb/clippy_utils/src/msrvs.rs#L20 [1]
> Link: https://github.com/rust-lang/compiler-team/issues/772 [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
