Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7ADA18641
	for <patches@lists.linux.dev>; Sun, 29 Sep 2024 04:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727584644; cv=none; b=JvMNipwk+K0uts1q3C7AQN/xOGVMV0a5OxXcADC9ZPvwYGz/B3HF7OD5fI6TqXYwyqiBjpCnebfzbHqHznUpjnaQI2AWWC8vizjxO+04bHBl6TFG3LzsOBKeiZmDdxfc2Sm3QAOMqApzzIKkej/l/qFNwrOznE6fl7rfEbxqPnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727584644; c=relaxed/simple;
	bh=YFwu01Y7TeiQz29fQ6MSlA65RT/0TJfLp1urzhN2k0k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wqv/jvhEt1czWWKQl3JCnChJqqoUk7/0ZEZSj6fD04yHwxCXr/jljrmynbfYJKsJIE2hIJs+SxeYl32G9y8FKjT1f1AN6qD9B9RVb+MuvOapJHbKBO93UYyCo7GoWOyfwPXxvLPVgVDJSRybNjcJMDG35JJUgE+uwo5HZ+Y/D3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu; spf=pass smtp.mailfrom=umich.edu; dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b=j53oedcf; arc=none smtp.client-ip=209.85.219.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=umich.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b="j53oedcf"
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-e25d57072dcso2527330276.0
        for <patches@lists.linux.dev>; Sat, 28 Sep 2024 21:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03; t=1727584641; x=1728189441; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V42qN1WQV/laReG496kmeSiiLIY8lCzO5J1gHdR31kI=;
        b=j53oedcfnYszv82uTFZlTw1h2zfxCm1ULf+MkxWwLiDJuKvjtLfkyfrTaCRSPXd0QC
         NhDUjj7lPAk84fBLEW1Z9mEPCS5tssybhUsuQww6sM07H+BP/YQOyezVXMIooO7DopGj
         d1hGc4pIQDiQ/l4JJ2vR9LMdviLwCpYzz4za6ZpiH1TMv+OH0tyW1fmsoc8jKN7gCMfu
         3erbzRkjIulx/rKmhbJt+DZhAj7ey8lmXPHQrcN9eRdgYyyEIi+xpYkEV32DGFU24ISY
         eg+HgpEY3lVkYVkK5JVjv8n/Z927Sb9gPJxyHeNqvntpDnGO7s1H20xVeEF9rzumexCL
         53iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727584641; x=1728189441;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V42qN1WQV/laReG496kmeSiiLIY8lCzO5J1gHdR31kI=;
        b=Dv1T1aGw9IL8LCrliE2hg5fPDzBPT3DepJKV9e/L/UXrk41BX7D/j+nMiqrLKVQiIB
         fiD1W+8VfcSnrW362YCyx9lXNv5wti5zm481wTJ2Z8JQGC6uG05jAr42OX3SNcvVsHS6
         +zFClrOGLRV3Zt7yRkH6IlnxOxhU6bcWvCfLaqhSnvu7rUB2O5s2CTnBFtlQzsDhabw+
         0ONgImWdNueq7sTh2EbWfL7OVrYYh0i4kx9fFBMNBRf1+x1EgzjJsYk4ceeu149PPugr
         IIbWj6XftemOAbk2keawh4qE+y3m7AhqYkbdsbqIOfu6+O/+urwvBr5pcE7JKNcIAcAm
         QjtA==
X-Forwarded-Encrypted: i=1; AJvYcCXtoVylKH6FDvfmQfAI1aYZGU939c9Oe0L0E7llIyyC05os8Njb6Zyang8Ag3Sv0lgnD+5sn9cy@lists.linux.dev
X-Gm-Message-State: AOJu0YxDFU6yqtHTc7BKKwSPk3YfTJyqyp8DXeqTmilqzuiW/sLbZpMT
	grPgEEVTy2j5Fd0K1Gr2RKVw4qGfdGBnqsZd49SM8gaDpakuz4/VNbPllYzcQhd/W5fLvAHKvkn
	8r8Ji+2+JqxA/H53SmAUzuTkKuV//EuD8HZzuUw==
X-Google-Smtp-Source: AGHT+IFflyx4smOHfMTuag0OKxVqo73QHCgDXjWZ8we+nIfLuHLH3n1yJuvkzYi/Z0pOSaiUUVzhsTTfIRORRjN+gBE=
X-Received: by 2002:a05:690c:700d:b0:6dd:d06a:b840 with SMTP id
 00721157ae682-6e247621811mr70577967b3.39.1727584641683; Sat, 28 Sep 2024
 21:37:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-8-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-8-ojeda@kernel.org>
From: Trevor Gross <tmgross@umich.edu>
Date: Sun, 29 Sep 2024 00:37:10 -0400
Message-ID: <CALNs47s9GFAp-6p6sYizOLbsAwUJS2EFxGtPDbvvegqHRPV-zQ@mail.gmail.com>
Subject: Re: [PATCH 07/19] rust: enable `clippy::ignored_unit_patterns` lint
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 4:45=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> In Rust 1.73.0, Clippy introduced the `ignored_unit_patterns` lint [1]:
>
> > Matching with `()` explicitly instead of `_` outlines the fact that
> > the pattern contains no data. Also it would detect a type change
> > that `_` would ignore.
>
> There is only a single case that requires a change:
>
>     error: matching over `()` is more explicit
>        --> rust/kernel/types.rs:176:45
>         |
>     176 |         ScopeGuard::new_with_data((), move |_| cleanup())
>         |                                             ^ help: use `()` in=
stead of `_`: `()`
>         |
>         =3D help: for further information visit https://rust-lang.github.=
io/rust-clippy/master/index.html#ignored_unit_patterns
>         =3D note: requested on the command line with `-D clippy::ignored-=
unit-patterns`
>
> Thus clean it up and enable the lint -- no functional change intended.
>
> Link: https://rust-lang.github.io/rust-clippy/master/index.html#/ignored_=
unit_patterns [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Trevor Gross <tmgross@umich.edu>
