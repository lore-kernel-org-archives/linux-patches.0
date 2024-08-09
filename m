Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2D5168C33;
	Fri,  9 Aug 2024 22:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723241437; cv=none; b=XCVFyvc2TfbRsWtr7ZxP+KV+tvUmkSBTrGC6ZF4q6A1XHA2bM/XRl5YJcjh6CpHQVq555MZlu99rbZurZDPHBlUjjPuZtHVFRytX44mm1nhGAtDqLrXgf9uvxs4RC3Bi/bv9W5aiZlBi+olMVvZ1HeCFbcfHhiK5BEv/YmZrl1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723241437; c=relaxed/simple;
	bh=xTu96gVQQIBkQAzBesrcr+iZgSsTX+f9z99eY96at7M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FareJ3MEP1w4ksDGs8gavncNePbGK9JC7j0lC1+eHLDBtD3bnEIyyd+b8qVkQKH95LP9qnGZJMZCvvPBiUdl36K/01xR3C2nDGgrdT+2S2FNZEqA4FOsppoCIqjlOZKEu/4Ok4sKF5FbspNlN3pwGTekUY3rjrFb3r25kCjASzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e0TsSmzB; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e0TsSmzB"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1fc4fccdd78so21743015ad.2;
        Fri, 09 Aug 2024 15:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723241435; x=1723846235; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vbzkV7xxeRVV81QNV7X70uUFN/Mul0WcTbpnujOxo6M=;
        b=e0TsSmzBxPYTcehan2YGdOuzD9m8/rIm/AAd9DOk4hVuC6E9UyYpfwvebFOlo6rie6
         6xt4or+IqQ6bRm5MMXyXFO6uzjnsJ6Q+DGkgpJvNtIrPWu4fBTOHciOKFaVTbbVDGd9d
         Uuw9Ql/ns4T0xRAR85SqaQW3vYfGTb1DI+ZTl6FuCFMxhs0yRVA+n9zQk11DEntCr62o
         R6uTQPzlxcZP70COAn3VphqPxi8zsIkQopG1BvK0b8PiVmv/TTihP+jVElXwzvKT5ivn
         18xSfoFnOs5PP4xUS6AwIfdqGem4SgqxMvVswyOq+tkNFBTX6JhzAkzmzs+IJhrc/sXn
         27Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723241435; x=1723846235;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vbzkV7xxeRVV81QNV7X70uUFN/Mul0WcTbpnujOxo6M=;
        b=uy5EsjKeTJ86uO6EU7EVJgyCdN9qocMVEVuRF/0Liio774Ar/ojRwadYrs34AWjkjr
         cG3Mp4ChRlhw1UufzCt04wsFkej2+UIf2o4Yqfvw04pLYzvzzdV2PgYuxcLTM+jWTP2w
         PxqBAtes2aNmvIPTiiN9yUN3wCxlfYEPA8kFx0KtVXWQf2VOO8/nOBcxPafOwAXI9If+
         coPhmFhrJ1OV2a2DMf5kqtLANlzF9GjSUYGMppwZGf+ypEitV9dOtuxPMONguZCyCfmv
         H3VxTp3I47+AyRYTYwIZgmMIXaCkDeJNjLnLdsIGyEtFvaO55js8GCsPSw4cPyuvG8/F
         JdJA==
X-Forwarded-Encrypted: i=1; AJvYcCV+PWqaIimt8hjAlgvU6sFj4Cv+OpapXHQqrxmcQFWM03I8z8m4N8vu8MZhjqs6RdkkY3Yu2P3ioglUG1uauQOiycL8TduRM5HxyVhSgvgQV9gEJM4SL46XWmtQuNU=
X-Gm-Message-State: AOJu0Yx7+gQ9AEO/fwBKz8OTglbor3mn19E4ZH0REXFGVKvolPFSF7Ti
	OZ9rxGygTNpRZmzfMoTkDvxk4bRZM7wbuR/nSPBne04ievdd3g5Nu3J2NLw7kN2+b0FTPFU4xaA
	WKq2jWW0Obyq/ez2n7P5ufd/JJdo=
X-Google-Smtp-Source: AGHT+IGgYkQr+MjS1MO5T+I/pnZfPga7tHNHKQpH9oOqar6JGxzbYKJJ3wD/ZViolCQTXbW9ZXLpRZtda0elVbgGs2o=
X-Received: by 2002:a17:90b:384c:b0:2cd:3445:f87b with SMTP id
 98e67ed59e1d1-2d1e80604a8mr3034755a91.29.1723241435433; Fri, 09 Aug 2024
 15:10:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240806150619.192882-1-ojeda@kernel.org>
In-Reply-To: <20240806150619.192882-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 10 Aug 2024 00:10:23 +0200
Message-ID: <CANiq72=oimd=7wL9_Dfy2+yEwcW9MKQ54dAHAm0TxoRVajPS=A@mail.gmail.com>
Subject: Re: [PATCH] rust: add intrinsics to fix `-Os` builds
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Nathan Chancellor <nathan@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, llvm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 6, 2024 at 5:06=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> Alice reported [1] that an arm64 build failed with:
>
>     ld.lld: error: undefined symbol: __extendsfdf2
>     >>> referenced by core.a6f5fc5794e7b7b3-cgu.0
>     >>>               rust/core.o:(<f32>::midpoint) in archive vmlinux.a
>     >>> referenced by core.a6f5fc5794e7b7b3-cgu.0
>     >>>               rust/core.o:(<f32>::midpoint) in archive vmlinux.a
>
>     ld.lld: error: undefined symbol: __truncdfsf2
>     >>> referenced by core.a6f5fc5794e7b7b3-cgu.0
>     >>>               rust/core.o:(<f32>::midpoint) in archive vmlinux.a
>
> Rust 1.80.0 or later together with `CONFIG_CC_OPTIMIZE_FOR_SIZE=3Dy`
> is what triggers it.
>
> In addition, x86_64 builds also fail the same way.
>
> Similarly, compiling with Rust 1.82.0 (currently in nightly) makes
> another one appear, possibly due to the LLVM 19 upgrade there:
>
>     ld.lld: error: undefined symbol: __eqdf2
>     >>> referenced by core.20495ea57a9f069d-cgu.0
>     >>>               rust/core.o:(<f64>::next_up) in archive vmlinux.a
>     >>> referenced by core.20495ea57a9f069d-cgu.0
>     >>>               rust/core.o:(<f64>::next_down) in archive vmlinux.a
>
> Gary adds [1]:
>
> > Usually the fix on rustc side is to mark those functions as `#[inline]`
> >
> > All of {midpoint,next_up,next_down} are indeed unstable functions not
> > marked as inline...
>
> Fix all those by adding those intrinsics to our usual workaround.
>
> Cc: Gary Guo <gary@garyguo.net>
> Reported-by: Alice Ryhl <aliceryhl@google.com>
> Closes: https://rust-for-linux.zulipchat.com/#narrow/stream/288089-Genera=
l/topic/v6.2E11-rc1.20doesn't.20build.20for.20arm64/near/455637364
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-fixes` -- thanks everyone!

    [ Trevor quickly submitted a fix to upstream Rust [2] that has already
      been merged, to be released in Rust 1.82.0 (2024-10-17). - Miguel ]

    [ Shortened Zulip link. - Miguel ]

Cheers,
Miguel
