Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9B4200CB
	for <patches@lists.linux.dev>; Mon, 20 May 2024 09:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716198029; cv=none; b=K+mAhwT2s2klhz6yV/1douzMlq0kQyn9n5h1UKZ33Kl6vby5AHql7JLPaPo4DrG/g6Y1IsHCTnLU79smRWLca00StdlmIfrmZ0ERmemlwJH9Guvx4AMSFBxjLwfXW9yveKwBG40JJNVvoX/fhNr1WzVCwtSdzXk5ODA/EAbbyEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716198029; c=relaxed/simple;
	bh=hlbB+kN75U9YScWnGXlfgm/HK3XeDX7QVEgtfCxUOBE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ThU33VYMM/lX4BlNi0dtTFrUElYHGuziAgTcGpsOIS2Jlz60XBm2gJyN3mV6+xxZBhhdH1mt+ZJjSTH/Tq3ykLqtR18wJB+gR/WJ7sZGCt2mFD7upqt5KgVdIqluo3ud/PBhGuJM3Yfd5Zkyksyon8CyZJodRUrQH1vWz2W7d/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mgh+RV0H; arc=none smtp.client-ip=209.85.217.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mgh+RV0H"
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-47ef5a51829so471940137.2
        for <patches@lists.linux.dev>; Mon, 20 May 2024 02:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716198027; x=1716802827; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QWeEZYLQFowsoh5tWMf37zmjnQP8pREzFJH0TgxKuRc=;
        b=mgh+RV0HKEX8fQBLq5D1AlZCdrvXclhFdw7Nqizo4tv6juC99W8k5jXyvgTvIbO49J
         bjO5/fjn5/nTgNSCuryL79JGc4/q/tkp+WMZeC4fF5IvWAR77A2lU3TsaYSyK9x+x+YX
         ilMPEN2qa7IOiYbvOONRtKE6UUPJyxiR0v/7njW2pqWWZFubffm8WKLdMb2cwfBLrqd9
         Jr2IH49XFGPatzjH/gWgRJHhDNvto6E5aExVQL9TwnP5ppgtP2c+Csuw6rHr0BeAZDWl
         Yom6JTEctP1RulXMiBUr2lQcEmy8jbyiLf/IO5oeFrVuKoYK1QIQjcNKyvG7yTcVxRQc
         vNsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716198027; x=1716802827;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QWeEZYLQFowsoh5tWMf37zmjnQP8pREzFJH0TgxKuRc=;
        b=Qq5X7iyybt/Fz972aMLHgQtBvRd6RM6fBwG7+o4f/8/P+NAitr1AyLMklpHwwkvUla
         TsDUaw1wvvLgldXeV4xswstzVgGkCqbcJDkKCzczsIIHbM4X3WtWKhMX1gxfwMIzKr/0
         oOpAnxNp2idx4aHCvfBZZpBgjD4cmfLUQO4uS9vl89sqFks8a8nsfVJ3xh+7/TvBHCNQ
         wq6z324oG/aB2wXrqE6LOini/o02STgTnJeM6GxKrafebZdV/y6hCLEvNCktI72jtw8F
         czuZ/n93Qa5uVGH2X011WYp1q5S6GYL4vRM4i979TPS8mE8YmQ82WIJOmI9JWtSvdBDY
         +KaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUCxpxrVNKUxj4kDEuAxD2JmWD2vEKL0L50RqMWNHQjrIdin2gZahKEYsHMqlYvV7JqDNqjXarWwRnw7oVojkvhZhKRRC097g==
X-Gm-Message-State: AOJu0YwJWAeOv5V4RlflJMEdgRyOAP3zu+i6YBv6ZfYz7PW1JhGC3mxA
	AI01fvG2zecLFNIk8AKLoA+63ck9l9jIZuDodluoz5U5QVKaPtI2YlDPhtMjpuvD2Hsr85LQ/c1
	Sf+u6z9TuJ5rMVDSSUtZaOC+YSgW2JcFtUQc3
X-Google-Smtp-Source: AGHT+IGRslYvtPZVflT9H/QVdXO5/e6Xw9lf8JCxCi36VGobIaGTO31kcm2q5Iy/MccVAuZ4g5GXjchLPJr6wZYIugk=
X-Received: by 2002:a05:6102:32cb:b0:47e:f5a5:7f79 with SMTP id
 ada2fe7eead31-48077dce359mr29874881137.2.1716198025227; Mon, 20 May 2024
 02:40:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240519210735.587323-1-ojeda@kernel.org>
In-Reply-To: <20240519210735.587323-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 20 May 2024 11:40:12 +0200
Message-ID: <CAH5fLghTdgWyEQFLL8VVSFBNq1hgXPF0gqoM2KETD=Ubj8xV9Q@mail.gmail.com>
Subject: Re: [PATCH] rust: avoid unused import warning in `rusttest`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Danilo Krummrich <dakr@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 19, 2024 at 11:07=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> When compiling for the `rusttest` target, the `core::ptr` import is
> unused since its only use happens in the `reserve()` method which is
> not compiled in that target:
>
>     warning: unused import: `core::ptr`
>     --> rust/kernel/alloc/vec_ext.rs:7:5
>       |
>     7 | use core::ptr;
>       |     ^^^^^^^^^
>       |
>       =3D note: `#[warn(unused_imports)]` on by default
>
> Thus clean it.
>
> Fixes: 97ab3e8eec0c ("rust: alloc: fix dangling pointer in VecExt<T>::res=
erve()")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
