Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED651B85C5
	for <patches@lists.linux.dev>; Tue, 21 Jan 2025 21:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737496057; cv=none; b=NA87IAZKaEACXU6boUTpAvxvr8man7t6Zmzsf8ShXyVSqhw2hf8WeuZj5RfWz2UDcXdrCEaHW86Cf9/gcIsrC6mbwadwzPgDzE6T7WTNaPrUxbhlUzvYtUBIadmzFAiVg+mc0UmGij5nILAHp5M/xCSIBxwCYvgrlqQUdXqSBrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737496057; c=relaxed/simple;
	bh=SFQdO87KU6rMmmKG466+pHg05L5s4MNtWbHODZ2EOyI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FVmv31g5iwcD4vuIASvMuOsg4NDiUPsJVqkHmGPf113pCvxm5L+0kR9BFwF0oCyr4SSXYC3IBvhQXaUlEzjaBlpiRRrsK1VuD43bzy5VdBmNXSh+ElPgEUa9p9eZgBA55UNnP9p5V/Fwb4SMuTvzD3eV2P5V22wcD9hC3TaTh9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rj7K0Aln; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rj7K0Aln"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-216513f8104so9864255ad.2
        for <patches@lists.linux.dev>; Tue, 21 Jan 2025 13:47:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737496055; x=1738100855; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l7o+9JshcrBofeKTB9tW09tsPDVhMqj/3ufOD6DtXHI=;
        b=Rj7K0AlnMubreh8YdYSUGShTZiWSFVbvlkRrC/Oid6NupstkPc+H30BdoErKF/cEBs
         ZmcUmsvOByey3V+h560kmvik5yxE+mPil+iW+VFW7ddpfmq4UVOU9NQQ7v2UtA75HJYX
         LjbBpmt2yLR3K1zbN294HPXG6bIk1WrFvzxORInMwvx/JTeFGqVKNTTmHQdLLblmZTUJ
         ehCMjNsVezChlvWSpdRbXsCDStOodAPC7MGdPp2Zh02u/XN03RvbiqIXd9Cjbtmt8FvV
         98lN1C3gTwKq9jDOUaBJcaCSA6/s9zLm9s1481z0dP6rACGw0J4WiJXM2iZX+qcFyLQD
         INVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737496055; x=1738100855;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l7o+9JshcrBofeKTB9tW09tsPDVhMqj/3ufOD6DtXHI=;
        b=dArSUVuF9AzPsMnp1seYDRIIMD9HeRMmOcTBlBDyh6mK0e+8lnuivLxJ7Ud/LMtJIm
         kzRDMbUyUPgOkhJZPh5XDi/MP8HtsQogMP7X4w3xrfUQ1fJfQ+v40UsHsmMO4bvzIyEU
         LV9bbUk/9R0W7u8kiCSpfDC0pQGF0RJSt11WEBtL45hZGhBjimm1hInZpKt4f5r0iZCe
         xJFyUQC+dnvWFKOHwAPZ/SK67ExuMHVk+phBHGmtrCQdktmRnRW7WEetlpMrcVph/+HK
         4om/Yrs+cZ1RLe6+F3pS4AeVkA/1dzjn7tlh13vZeV2U0youq3zQp7QyKY1xF9DCMWUJ
         0jFg==
X-Forwarded-Encrypted: i=1; AJvYcCWG+8k/5L43iW+BFfrTNU9eEGoMD75Ftd9tnNJGp9coOtAWJGE0yAkvi3rhUjULbNvs4OZaNH+O@lists.linux.dev
X-Gm-Message-State: AOJu0YwPZRbah41v+qbBLOu4+q4KiHXySfhr/ygfM1OLrz4ULQWB8eoa
	JD1WABUkl8iv0y9rhoHln/hUP0Gk+VBdtkuqoUkqwqAjM0U+Z5WQ0KwgAuOtb8ZdVgZbqdRGgye
	VFpEvzA6PgcGnUrTD7fvDn+HxuDd9O/dOGe0=
X-Gm-Gg: ASbGncstVyMkW5tghW5KWKeqDV3NpJci6jAwgQLxTCwxq17cz/0Hl8jfLSARPPzvfy3
	tGP/ogNGxnjniUztEfiW3IvS+vweVlFyNhYjvW586hjinbgex5/0=
X-Google-Smtp-Source: AGHT+IHRk2ZLyf0ysaNReOYuyZFvxKpMP3e7AM7p3wxJojsGYuVF9Jzwo3/st9jP2UCgo7y6AAVXBGJVBhXdH7oeheE=
X-Received: by 2002:a17:902:d2c2:b0:21a:8ce5:10f0 with SMTP id
 d9443c01a7336-21c355869a8mr97456405ad.9.1737496055410; Tue, 21 Jan 2025
 13:47:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250121200934.222075-1-ojeda@kernel.org>
In-Reply-To: <20250121200934.222075-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 21 Jan 2025 22:47:23 +0100
X-Gm-Features: AbW1kva6Rn2sOfmf9JeN8H86I4Id2gUtstZTDCg6KdGBDAiqPupe7dqT1tfE2rE
Message-ID: <CANiq72=mL45_xJBmQNzaXtP3v317ZbQthH2g5rAH3tw3U6uovg@mail.gmail.com>
Subject: Re: [PATCH] rust: init: use explicit ABI to clean warning in future compilers
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 21, 2025 at 9:10=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Starting with Rust 1.86.0 (currently in nightly, to be released on
> 2025-04-03), the `missing_abi` lint is warn-by-default [1]:
>
>     error: extern declarations without an explicit ABI are deprecated
>         --> rust/doctests_kernel_generated.rs:3158:1
>          |
>     3158 | extern {
>          | ^^^^^^ help: explicitly specify the C ABI: `extern "C"`
>          |
>          =3D note: `-D missing-abi` implied by `-D warnings`
>          =3D help: to override `-D warnings` add `#[allow(missing_abi)]`
>
> Thus clean it up.
>
> Link: https://github.com/rust-lang/rust/pull/132397 [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Cc: <stable@vger.kernel.org> # Needed in 6.12.y only (Rust is pinned
in older LTSs).

And while there was nothing wrong back then with the commit, as usual:

    Fixes: 7f8977a7fe6d ("rust: init: add `{pin_}chain` functions to
`{Pin}Init<T, E>`")

Cheers,
Miguel
