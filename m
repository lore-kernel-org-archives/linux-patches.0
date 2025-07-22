Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CD62DCBF5
	for <patches@lists.linux.dev>; Tue, 22 Jul 2025 09:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753176033; cv=none; b=Pe3tYKQlUCTPtFE6GP3h6nw5DIM4J6b/OacQI2o0UdKUynXvx6CE1lgQ29oxb2qSM90aRFkX04l+gNspW3s3Xo/w7utJSOfUdXHYT1HUvAgBhvnvAv0NsJnJGnylE7/tSHzIMmJEBivfrlcsHmLTWfcQfnmtsfoe+PQujxrym3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753176033; c=relaxed/simple;
	bh=Nn9sCHDMbM7M13uC5Ckzj4+kXEm/XS8Z+xrifEuNhEM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UMNK1k0LPwhzgWmknJJh9Hs8BRmBISXDymXEzvqUbOcuvfS/pjd/iBEpxjtpu1qZ450mKbiFQOU5pS0vaELfgf0DYvgqaM9sWcqqrT/QhcHDC24jvPuEBqk+x6+lTJ8UNAo6ldEeWFVhJ4RcSJp2+5dH/6Nb/1hKyNjWaxh1P4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X5JfYo3t; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X5JfYo3t"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b31ef5f24b7so623193a12.0
        for <patches@lists.linux.dev>; Tue, 22 Jul 2025 02:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753176031; x=1753780831; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nn9sCHDMbM7M13uC5Ckzj4+kXEm/XS8Z+xrifEuNhEM=;
        b=X5JfYo3teZA8a8QpbT9MYQxrO+5jqqYvRjQ1ZEtC8x4bkOq1RMfdghxhfuN3GUEYWA
         IA6rA4UrPK+G8omNTQ92tRSx+IyisXGFLoZv3yfXdalp1EBZOH9ERWALYBmk+VN4Wvso
         JvLdRmmcNQqsuONrBM4UvAbcqkg/PeKD0RGkUsWWX3zk162Cyw80jimTxpNOrpUbTHUS
         FXM1T/WcsRgw9KkjSFgA/kusUV/K4DsuEiocfcFrq8Fp2Fxqwl/yDSaYFuKsYokU1DvY
         BdfC9eVujffw44LDOKlYpKDgCfJB9PuUEgLVOXKB69CkB1Cyv0GHKf/cU7WrxCpM//h7
         YGhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753176031; x=1753780831;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nn9sCHDMbM7M13uC5Ckzj4+kXEm/XS8Z+xrifEuNhEM=;
        b=UZE1RODigTLE9aF4BpHGFYioTu9T6bty8v/uYVVwBWLZiZ+vWWZ5CGVom8WNSSyMKr
         bbctdKNMrC9NL0Qzoi4VF7cJZlxTaftJbfAZUhpjzdMs/iz9pvOWyNy9IlSYKFQBH7Nr
         CQA3X60OfCoyiJPyjHPXcD9vGOSc06CFXD6D8/OCSF1XwHTOI+rqebXYovAFiOiUBZUF
         CzBbvU8EA3Dm51R8gIOQ40Q4Briq0gc3viTEc09j0MFqErqZBjISi64X4TVil8RKo5tv
         PJowHHnt6Rn/0TU1pV0xJM5AJ9QUZyqQyDmdDIOq80DKAtDOfHi05Hf+gJ5pBB7UjO/u
         QNKg==
X-Forwarded-Encrypted: i=1; AJvYcCWZ4LNbWrTc+XvvLkME85OObbXnxEahh3ehTzCbzRwaxtYFy9MeJyFi25bsxVmxy7IjxMDEkCXI@lists.linux.dev
X-Gm-Message-State: AOJu0YyHvnWlz5CQcwSFQc8SsOerSFtRa7/GkqjPfUd0t9JpYomcrCly
	U5Si6gwoh+9V1Dhhbl8pvShwULEus22eoSCpdUEfZLfOXnTeyqb2Pq+YNvX6V3ag6RcStqQVOob
	dTSQJjkxEHRPuDV+j6+DbtXS1bra2LJ4=
X-Gm-Gg: ASbGncu9fgB9VunWl17J5mcG8MR6TWBY1nrv9TAtHwuO99+qO5pYWKBF+ougLYUabBy
	5N2IJ3z+ihElns1EWM5Hgjmktji9cxwucmLZv7iLBtN18jl0xNxGxMQNu5YGcIBh7IZZXbfXZAT
	ljWijewPdB8dSQqztoe9IyH2GUaVqjOVtNLFjTstxwXfTXuhww2UzBb+b2VCq8iDtZd4pUnTeBV
	J0zDJs7
X-Google-Smtp-Source: AGHT+IEoG+ntdvZJtbRwxk5of51Jgz94WQ1WG6t+WIcog6BWsuPvnyj/cU03qQaaER0Rx0RjuH4r3NuQczU30CK1r40=
X-Received: by 2002:a17:90b:1cc3:b0:311:c5d9:2c8b with SMTP id
 98e67ed59e1d1-31c9e7767fbmr13255767a91.5.1753176031145; Tue, 22 Jul 2025
 02:20:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250722085500.1360401-1-ojeda@kernel.org>
In-Reply-To: <20250722085500.1360401-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 22 Jul 2025 11:20:18 +0200
X-Gm-Features: Ac12FXyNAwQRmWBDTmd-dEi5WjSAU__xl71rtwNdTomqSodwxeIO5UXzL_1ugaU
Message-ID: <CANiq72nyHPO-zFo9-4-MCmsPrxoQMK046EnvYSsQKCUBnz3MXw@mail.gmail.com>
Subject: Re: [PATCH 1/2] rust: io: fix broken intra-doc link to missing
 `flags` module
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 22, 2025 at 10:55=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> There is no `mod flags` in this case, unlike others. Instead, they are
> associated constants for the `Flags` type.
>
> Thus reword the sentence to fix the broken intra-doc link, providing
> an example of constant and linking to it to clarify which ones we are
> referring to.
>
> Fixes: 493fc33ec252 ("rust: io: add resource abstraction")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---

I should have mentioned that, as usual, please feel free to rebase
these if preferred (I think you don't in that tree, but
nevertheless...)

These two are meant to clean -next (and rust.docs.kernel.org, which I
build with WERROR so far).

Cheers,
Miguel
