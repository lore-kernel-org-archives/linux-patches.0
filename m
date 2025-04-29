Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05468255231
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 19:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745953536; cv=none; b=PA9lM0XFNnXx+85bWiHOz7O+1vyaE0NgQ+BhfBeYfDpSIRsYi2oLDJ7LsdaJSMR7sZf0ULR265rRXzH7N9aKNKvLnh5cJHIyaRzfuGIb9RNMsbEIn/0W9B/B6S5J/SGeeNBxgG+9Muz+nnTUFpZZRoIM2dxgLd74JrI1qv7hXEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745953536; c=relaxed/simple;
	bh=Cf/1Zs3LvoHH9crR8mIsN9S6Tq8TBj0Y0gYogsqqD/8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F5H+9suO2OUmdINLYXsNioNNPwee9E2ZQl+l162rjnb8bUWwt3QsdkrXNFyAfIrIRqmfRAmH7ix5+Qcka9QqDXypVU3DdoYdf+vUEXME4/C5uorTYdm8jSq463w1X6F9wR+dm0ScLQnR9229IhRsw36qyKqiP5zZDdsAb1o1d50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RF2la0fX; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RF2la0fX"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2240ff0bd6eso12996135ad.0
        for <patches@lists.linux.dev>; Tue, 29 Apr 2025 12:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745953534; x=1746558334; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r16Su1sCCYhnqNXeOKW7XODWPW+w2pTNIqFTeu9Mb/g=;
        b=RF2la0fXupSyW7cs7g/5AQNqVAiLUotl/weUZ5F/rrHuHMhdl1PHgVjDvXrbAycjZ7
         jTZJ4JckviX0Kl4VW7GXMM/Ra5T4+OFT1JblzIfmPR0J9HzmcmdcW/P6Ds74q1gdgi9B
         x48fuEiPBOkfTiSLviL6CGCOptZW4aRGsHzWujTDe7DW2LT8jj1lybNCPi36sG2yiSxO
         1imSZKRgxiFKT5V4SDMSoModYb2LlRgSNZCSeE8aW54eOFkewX2KVfvgw7y+25X0ak8m
         RbV1iBVoeNllRkOkyLDe39BJhQBkD4t4o6xMut5BQRZK1nqstSp5jlfbhR8Fa4/I0X9K
         kW0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745953534; x=1746558334;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r16Su1sCCYhnqNXeOKW7XODWPW+w2pTNIqFTeu9Mb/g=;
        b=F1mfvQTKMN+PLJJ0vevnzEHdLpiHnvyOp0je244KvVp7orLXTAv4rq49dYHPQJA1AD
         4aJIKH3JrbfcTaolI/gAiEOoltqh0LX9Z8XWutAfmDY7d4vLJNPbIc4pon6Vys2opZfS
         jd6wFXpLT6UX8PNZRZyXm1mAAdTsRjpVUnVMRxZI+m/Jirp0DJgcKYkMSipzupVENmpO
         tIa0fVHH8zy95q8yCMAk9cdd6fdpit5tOyLIjMowieLIJOaOT1lf6D18MUQUXD+7xR7+
         o1DahTuqmVDDoa+Pon9U2K4pdwF6kjGnBufmLsG+nfwfABjAwkFYtRs3ZG1cjQ/WMPC/
         DzBg==
X-Forwarded-Encrypted: i=1; AJvYcCWuKdxPteUX2kCiYYoM1nRRcRclfcWnYzlXZBe0EZE6njTVPKnljii2sTy+iN5ZCqjQUbO2ikh6@lists.linux.dev
X-Gm-Message-State: AOJu0Yw9QIAMeCvZyi7q/ap5Xw7IM6UEjc4UijLImUZS0UYRyD1aTRs6
	2LWCB9pHyds33kz/Or5+HgiECBYGkZrHLfflCLMVjemrne1ygieG3O0z7F9K+VSX2gVZ51xbDIk
	2qo9hJX+REdlpdUFZGMDEXRWB6eI=
X-Gm-Gg: ASbGncuKvKduLjBx8im9ggdsIwWTevwC5XkkzldrcsE4Gx9lBeXv3VxxjGtZWsskfWH
	lVoV0WBul75vLgqaSFeyIFjIOURXsmMHjUap3C1TjPoM6KF2Sl3CQrYAFwWwQgoWv35kDX+HeYw
	Fjcc9H2pJ7XzMkDE55IlicUA==
X-Google-Smtp-Source: AGHT+IHsGrvtNSu7zfAedzBqY74ny6UZBQfdnfghG/iiXxqtFrqxbDJyig015Pgn2rGVH3TXRtMbDQ9gB4KjH3DpDTY=
X-Received: by 2002:a17:90b:1d08:b0:305:5f25:59ad with SMTP id
 98e67ed59e1d1-30a3337c9e3mr114359a91.7.1745953534031; Tue, 29 Apr 2025
 12:05:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250429150346.392050-1-ojeda@kernel.org> <aBEXUG7QH0ymRuLm@pollux>
In-Reply-To: <aBEXUG7QH0ymRuLm@pollux>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 29 Apr 2025 21:05:21 +0200
X-Gm-Features: ATxdqUGcOr3gxJsr8USoDtVzfAIDvZ5RlCaobjuVVIdgjgS6lnLZdSU5M8Bwyt4
Message-ID: <CANiq72nf86+OcMTNPQVnF=pXuaJVw0bFixMxs6qwS5vTh7RWxw@mail.gmail.com>
Subject: Re: [PATCH] rust: device: allow `dead_code` for `Device<>::parent()`
To: Danilo Krummrich <dakr@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 29, 2025 at 8:15=E2=80=AFPM Danilo Krummrich <dakr@kernel.org> =
wrote:
>
> Maybe there is a much better solution I don't know about.

There is `cfg_attr` for that, and we use it in a couple places, e.g.

    #[cfg_attr(not(CONFIG_AUXILIARY_BUS), expect(dead_code))]

But unless we are more or less sure the condition will only ever
depend on a single `cfg` or so, I am not sure if it is worth the
complexity (and even then reasonable people could disagree).

I wrote about that approach in the "Conditional compilation" in one of
the bullets of:

    https://docs.kernel.org/rust/coding-guidelines.html#lints

I hope that helps!

Cheers,
Miguel
