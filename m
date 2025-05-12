Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE004A3C
	for <patches@lists.linux.dev>; Mon, 12 May 2025 13:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747057685; cv=none; b=L7LheJMg+XOLQivlojiAnHZ7BKp/EgniUPUMdCUO+2VIm6nj2NGBlTta84DDcxaOPxRuMZG/mXFqfgawTzK3L60oRscUbD7JkZbPYTtbwwvjnvbZQ30CqD0KNWBCr8cNwAX3scWyj+zBmRQ+uHA3b4tRE6CdX+BLPFOHCi9KOQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747057685; c=relaxed/simple;
	bh=BHpueVAwfm3FWQvl4EsygXnay/5mtTUqUqaYBsW2JyM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kNpEGQrGZtbsYwQqOpvf73cANIWxGsRYkBEdfkZigTaAOf5dXOb1csE2bLaD9ORWRFxuY9ZKr3yyi8QXnhQQEzfUz0z2e6vYYpiDQHUlU0er25K6Ur/U5CeO5gmA09gSbmvjL/xI5Vy3tXsJ69OfNVpsFCnI4Dsf7j1wC1GWRgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ieqj1uaS; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ieqj1uaS"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b2001aafc3cso344247a12.2
        for <patches@lists.linux.dev>; Mon, 12 May 2025 06:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747057684; x=1747662484; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b1fMuIe/7ONMMCdQeIFnVXYkOelK3PlNZeZ2qTQVxIk=;
        b=Ieqj1uaSdwH2ufQVEeBb2chNtW15rChIkU0FpHGZnApoZzpARlaYsh99vPlNNyobmn
         oL568yaOyOL290d6m2rmboMm7OB2s7VLbQ2hbf+g2CdG78l9+QzI3tP+u0qa4cl6iIEN
         CtaxzBcm0tn8hQjS5gptRvk0yf8fr3MSm2zMxZVFCh2kLBbzqYbwJonBYtVMM88oJOFy
         qzQfHEYb6GDT4g0gO86dCOZ7GR9uFQrw3xiSNdjFTv1S79KVOH8Ted1C+b/3cRJHKnNJ
         kphsegtWgIMe6KpYHFjzNV37p2g3RV2sjS4cf6pJrO2CXggyR5Z44aGFHCDmedQOthRs
         /TSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747057684; x=1747662484;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b1fMuIe/7ONMMCdQeIFnVXYkOelK3PlNZeZ2qTQVxIk=;
        b=iejoyxL367bdRxrsxtPjaXOHtuLpjwEksk6ctzfng2D4W/bIz/DUidKkwrdqD3kpEV
         wMN/SJk0P9Rb1mtGYMFWj8gbrha7YZ94Cyj8TsD/6RrpMjHaihjoWw2t2m2oRkXHV1uQ
         0rwhw0unv1tOsij5HNxPDU3AelXp6ftfWOL4DTQuXRcM+q8msO1aHH6MPDssWOOfLROG
         w0FNP+nUwiJMgB7ROlJWTVvVxS69we3+Qhk2+afawVi8Rm7bx8fk1lcjiH8dqMCLRdj0
         6IcONparoX7v6VE4mlsTvlE9iXnDxsOGs63Xt1Z8exC7/0Pg3sCg/8n3ln1b2P2zMHfF
         976Q==
X-Forwarded-Encrypted: i=1; AJvYcCW2eym75lpGtwnJinFlNNn6RGa2A0sSayhrfb8OnCzTh4Oirm9sWXlNDbfPaJEAfMhfuM1N+1lN@lists.linux.dev
X-Gm-Message-State: AOJu0YwaDCXfeko/CQ1BBCfyqltKyWBly0Ep7NgFpUFxRU3kxuBLAjA/
	e88V4epXd8HSGA5XEDTudEErtSbEtSyHxrHv1wm670bY6MGnBz8iftz8Ni44V8+arrGEk3B6+Ir
	DlMTnC/9ptRtK05TnmXjHuTWnWTLEShYEQC8=
X-Gm-Gg: ASbGncsjg9zyry6evmBeyygU7W7nksPec8HdTEhOXLDAicnPfcEL7BPpPyOrwpDaKDN
	5Wc0SKAsrQByHiw8PcdnJB9L4lpi/xPXwDM4OAbvqKa6fRZ7pfITO2U3xNjT4R01tCuYg2ivxmo
	wBJRSUdGTSthM9XUZhZ/xsq4Bp0inpkqD7
X-Google-Smtp-Source: AGHT+IFdgJb6WFnCwQ1ckUq6mAtXOgztfx5HsquGECmUxd5me5EhOzT9KO3/c+Lqq8UBo7wF7VCfW7Fkeyh9no0X8W8=
X-Received: by 2002:a17:902:ec86:b0:224:1212:7da1 with SMTP id
 d9443c01a7336-22fc918d174mr63653765ad.13.1747057683677; Mon, 12 May 2025
 06:48:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250416112454.2503872-1-ojeda@kernel.org>
In-Reply-To: <20250416112454.2503872-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 12 May 2025 15:47:51 +0200
X-Gm-Features: AX0GCFssLceZsQg3tu5ORZXSomdeXScaEYnRsjvkmAEYjZ92Z9K6uKADlNuukfc
Message-ID: <CANiq72kEgg2ATEdtVPLX5shUcVJdJKuftt6qMtA-t5C-ALpx6A@mail.gmail.com>
Subject: Re: [PATCH] docs: rust: explain that `///` vs. `//` applies to
 private items too
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 16, 2025 at 1:25=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Sometimes kernel developers use `//` for documenting private items,
> since those do not get rendered at the moment.
>
> That is reasonable, but the intention behind `///` (and `//!`) vs. `//`
> is to convey the distinction between documentation and other kinds of
> comments, such as implementation details or TODOs.
>
> It also increases consistency with the public items and thus e.g. allows
> to change visibility of an item with less changed involved.
>
> It is not just useful for human readers, but also tooling. For instance,
> we may want to eventually generate documentation for private items
> (perhaps as a toggle in the HTML UI). On top of that, `rustdoc` lints
> as usual for those, too, so we may want to do it even if we do not use
> the result.
>
> Thus document this explicitly.
>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Link: https://lore.kernel.org/rust-for-linux/CANiq72n_C7exSOMe5yf-7jKKnhS=
Cv+a9QcD=3DOE2B_Q2UFBL3Xg@mail.gmail.com/
> Link: https://github.com/Rust-for-Linux/linux/issues/1157
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` -- thanks everyone!

    [ Fixed typo. - Miguel ]

Cheers,
Miguel
