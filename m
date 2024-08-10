Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E1C182D8
	for <patches@lists.linux.dev>; Sat, 10 Aug 2024 11:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723289777; cv=none; b=mjOxBkZzUGuOvjp+BnVCC0npexNHIO421MsvBir5O0bIy7LcTVQCmTPqSFLcjELpwkz/hHAg5ttqgHLYCkSBbsp1v3Jz1T3ELToAf1dQPOoro0ZeGvZPXx3DLYH7A1WouAb46vaPnPUuehkIgDT9tnKck4TB6p5Wj1RlD6x+7es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723289777; c=relaxed/simple;
	bh=pRDv7ES/6srChhxqUba+UjeIOeYp7UdK0hH4IWFavG4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T+5GB5gI3ALevC1QNO5Ls+yLrz74Ej+OoBgwD3Xih/RVAR4zXvrZZdUSzu4T/yCjNAo8fCueCJPNY0A7COgD8Xju6COUIGyLJMODnCCfNTr0DawWbCRVvLgEUxiRlbrH0PhYqvfkhWv/7XfluCP2KPvoS3O2q07lvGGg1CGFr9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KE0oEzl1; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KE0oEzl1"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-7ae3d7222d4so2050048a12.3
        for <patches@lists.linux.dev>; Sat, 10 Aug 2024 04:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723289775; x=1723894575; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pRDv7ES/6srChhxqUba+UjeIOeYp7UdK0hH4IWFavG4=;
        b=KE0oEzl1NEqdKbJLcN0ujoIy56CJpuHvlQnMvKZN+6XjXdWnLJTf6qmBDzBjjeT9MJ
         IpbzgV/b/DbpyKnctHbuHoz0PIL+zl20kdPiE6KIBga+6FHU2XRpSRFntrR2YFcKO/Jt
         4tGhY+QctFlp1L3td81XChSX9TZIusv3iLazCkjj4fMdg64biHOeiN6f3lKqJqEgaNiv
         IKz7UZQzJ44O5WYvaac9opPWEeB3mLb4+zJ1deAn1O1MWmr897r0rBEgY5ccbsWKRO5L
         /upKkC16EEnit/jZuOZUDm9HylhZbyK2+gAwF/ztEuiRQpm+Co6vQsJUhXys1NFKbwtc
         xFWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723289775; x=1723894575;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pRDv7ES/6srChhxqUba+UjeIOeYp7UdK0hH4IWFavG4=;
        b=H6DCgw6JCuUxVy2GY59h50kJ2wSc1xWucK8boTM4331iElVCdhjrPoZX52/K1r/LXx
         EPHRNh7vPtoStLkubgAj7MpXiINazM3rF+zQMM8rLPX3MmixoyZQR4dDPJno3CWfvwCr
         7K5PGnxcX70Os8X4zwAReWOjClY8JHLXio5yeHwN578usrXw++ZwAEAxBXfIJzQaHr+S
         GsKDsx9ITEvnfl1EweY6SAAEoHPTYnAdtVc//G7PMmpycw5rOAQs0gPzPP7+Gp3klzMn
         4Z3zJyysQa+mKORIoRX0LV6FAWbjHL42JO9rE95ApDAXUAJnUNLiAYHLA63iJSSYV/7Z
         Cr2w==
X-Forwarded-Encrypted: i=1; AJvYcCW6F5Q3RnQ2RxsuLpt6XIQKRDFBrENgCIouHO+8wLAhfqs+zZnPBvsk5kilSiLyFPyDMUejPBDiC28pI3DON7pBb2eQqgTOnw==
X-Gm-Message-State: AOJu0YwEOE9oBofvTLK5b65NCi7LIHs1rX6f+GM3yPBvnXFVd5sKcPX4
	fD6TmzOXIUlNHMFAhsYgHU8OOeh1d98P9Y0TugHS+S4ERMp3oYd17+0+GCwAG4V54w4nXz4xzWw
	DoXyVIyEABy47mvZZ2VSBYaXTRnw=
X-Google-Smtp-Source: AGHT+IFpnJ7gvKTJSB6GWIWnhoHi3O1Ctb9UwS4DLIOCEJdg3CUgwGq9dgvZ3o1M5AYwLlbS30DJQDd8snHf8qzoS1E=
X-Received: by 2002:a17:90b:190a:b0:2c2:df58:bb8c with SMTP id
 98e67ed59e1d1-2d1e7fdb96amr5139875a91.18.1723289774767; Sat, 10 Aug 2024
 04:36:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240808221138.873750-1-ojeda@kernel.org> <20240808221138.873750-6-ojeda@kernel.org>
 <CAK7LNAQBG0nDupXSgAAk-6nOqeqGVkr3H1RjYaqRJ1OxmLm6xA@mail.gmail.com>
In-Reply-To: <CAK7LNAQBG0nDupXSgAAk-6nOqeqGVkr3H1RjYaqRJ1OxmLm6xA@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 10 Aug 2024 13:36:02 +0200
Message-ID: <CANiq72knS9dGTh1uEQzYvmZuFz6fE8tNhZ8JEuyKFHYR=Kh8sQ@mail.gmail.com>
Subject: Re: [PATCH 5/6] kbuild: rust: replace proc macros dependency on
 `core.o` with the version text
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 9, 2024 at 7:31=E2=80=AFPM Masahiro Yamada <masahiroy@kernel.or=
g> wrote:
>
> The touched file, include/config/*, is an implementation detail
> in Kconfig and fixdep.
>
> Rather, I'd like to put the string "CONFIG_RUST_VERSION_TEXT"
> in the comment of the source file.
>
> This is the idea adopted in include/linux/compiler-version.h

+1, I did it this way to follow the same pattern to the previous patch
on `core.o`, since that one needed another approach, but I am happy to
change it.

> I do not know how to do it for rust/core.o because there is no in-tree
> source file.
>
> But, can we add rust/core.rs, from which
> rustlib/src/rust/library/core/src/macros/mod.rs is imported?

That is an interesting idea... :)

Hmm... I think `core` is a bit too special for that, since we need
attributes on the crate root and it is the one defining things like
`include!`. Even if we generated the file on the fly to mimic the
original, we would still need to handle the paths for each module or
recreate a directory hierarchy or similar.

We are also in talks with the Rust project to figure out building
`core` in a stable way, so the details around it may change too, e.g.
probably something like passing a flag like `-Cbuild-std=3Dcore`. They
may also want to figure out the right input file path themselves, i.e.
rather than having to provide one from our side.

So I think a hack may not be worth it compared to depending on the
implementation detail, and may be a bit brittle until we know the
final details of that.

Thanks!

Cheers,
Miguel
