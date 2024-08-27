Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9779B19FA8A
	for <patches@lists.linux.dev>; Tue, 27 Aug 2024 11:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724758245; cv=none; b=A+tDAQsOCfCEeL3X5P+S+XI7ok7I4tf8fTMvVGSiS4ZlxxIxcQjk4teLtSk0fRbFR4duc0I3ZOt6vi/8Vd6v2z5uHy3q85+WD9vOdlchWZiq9+cMrrzqE3wt7Nw/eX7oHEh9dkqUmsM2BS37eO8myXKqq110EtGmZcqhOAz+o3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724758245; c=relaxed/simple;
	bh=pxwUZjIEzUdNMrTjj+dC9adH6yYFv8ZxuOHul7Of6Ak=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tBVqQuSFn5pPmJd4li4tKO10btcxwLDmTSMY2Wz47i1dzwpT9+sozF6wdlL6PKadia5NniPyQsu2hyvZF5pWzY403vBxYY2NUTzCraebenmUB9GinhkyGbslPTCkz4vLK2ccFcdxKEfJwNnOo7sxYprHqjLept0ptTvtrxurzkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n0B7L0UP; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n0B7L0UP"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-428e0d18666so46024715e9.3
        for <patches@lists.linux.dev>; Tue, 27 Aug 2024 04:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724758242; x=1725363042; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eUhlT5a/QMpCNH2uUAixzmV7FXsegXG889Otbeqkao4=;
        b=n0B7L0UPKNQIP00Gk2fwnssEejEOmLlJB7yo7JIiT35W8j3BP/wETSZVR/gY53U+HK
         BtRVOJ7P9Di3/JJnuymRjASet5uBqc0ozmLOena0hQwhvteVW7yjo4OS8SF5uYAb2kiJ
         6k2VBHF5ejeMx04GhZKxFXWqGwzAY3glY4fkJVwBew6xHqoWslyPa/YhxaGvj70EHMew
         1EHn3ey4Uxy/FruX1LM8SgO/Rb4XCH4avRPI4OSTtn8LzZ4yasqlt/588ZxQLm0FNgoV
         W5rQ1j/7siVbVowuC/5LhT0cHPrGMi2jN6lNaEckDzoZyXjvo998o3psEBmE80yvaTEQ
         aVmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724758242; x=1725363042;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eUhlT5a/QMpCNH2uUAixzmV7FXsegXG889Otbeqkao4=;
        b=vQsc/nKQ/tT/dKFBbL1LWhl9Ys/1azs6jT4cUXsjarVDkFJSgWhuxWvZQ9RZ9cTcwJ
         GQST3xuxsA5svX0yYqJQaepnBw2f1e1EGJXxz/RM45DKX/neQczUg+nGUk57Xa3rv/Nd
         gdf1JiUBRi37EqftEyLCev7FkDiTd6+GjqKZnghKFwtd86oC55bCApjhE+j0D/6puB0c
         TRK1mK0N316tnCznxX2bpKpEejXfPC3fXjIfKpTzS0J6tbHnAnzD9qoCEO3ueBvoS4iI
         GQmULyknLogNFv+DbJDap80CmUliElHivayL7mBZAPBPAqhAQj1eBp8XQjSz9sLswo4u
         oqmg==
X-Forwarded-Encrypted: i=1; AJvYcCVPfkNixn+WHlaNbpy+X6/EabPwsTZOvporgFIDy3S36tRFMXfSC44sEMXHXpJY5LKPnw3NqKrJ@lists.linux.dev
X-Gm-Message-State: AOJu0Yyfu+JO/jzetxGMIFgSmchhgxNMP55A/uaht/2NVP9vjPj4mQpE
	/T0qVS6FwGMoahzDCmQhmsSmCtkgaNn+V0tb3fTbjkOy2cRJ5GLUJQ4DSqP4cJu8RGssB59mH82
	ENjkZJwzytJYTUcaobeRivo5s7JZz4g5tF7KD
X-Google-Smtp-Source: AGHT+IH6vpUg+8mWXDKTFNmf1KdzZsxtXKssoNipDJms7hahddmniOI+sSiJNcbup7z54o3qp32hTwnfiagOWZS6Kts=
X-Received: by 2002:a5d:4fc5:0:b0:368:3f6a:1dec with SMTP id
 ffacd0b85a97d-3748c7c790emr1887630f8f.9.1724758241551; Tue, 27 Aug 2024
 04:30:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240827100403.376389-1-ojeda@kernel.org> <CAH5fLghhgWdJHdOR7TYwGADecsqBtOF08+S4v3RimeFsqvdfuw@mail.gmail.com>
 <ab399fac-4b10-4ed9-ac28-55797a17fff2@proton.me>
In-Reply-To: <ab399fac-4b10-4ed9-ac28-55797a17fff2@proton.me>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 27 Aug 2024 13:30:29 +0200
Message-ID: <CAH5fLgi1_=FhM1800xz=53OpfvF55WqBijPSvSXC7pHuFL41rA@mail.gmail.com>
Subject: Re: [PATCH] rust: allow `stable_features` lint
To: Benno Lossin <benno.lossin@proton.me>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Andreas Hindborg <a.hindborg@samsung.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 27, 2024 at 1:29=E2=80=AFPM Benno Lossin <benno.lossin@proton.m=
e> wrote:
>
> On 27.08.24 12:39, Alice Ryhl wrote:
> > On Tue, Aug 27, 2024 at 12:04=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org=
> wrote:
> >>
> >> Support for several Rust compiler versions started in commit 63b27f4a0=
074
> >> ("rust: start supporting several compiler versions"). Since we current=
ly
> >> need to use a number of unstable features in the kernel, it is a matte=
r
> >> of time until one gets stabilized and the `stable_features` lint warns=
.
> >>
> >> For instance, the `new_uninit` feature may become stable soon, which
> >> would give us multiple warnings like the following:
> >>
> >>     warning: the feature `new_uninit` has been stable since 1.82.0-dev
> >>     and no longer requires an attribute to enable
> >>       --> rust/kernel/lib.rs:17:12
> >>        |
> >>     17 | #![feature(new_uninit)]
> >>        |            ^^^^^^^^^^
> >>        |
> >>        =3D note: `#[warn(stable_features)]` on by default
> >>
> >> Thus allow the `stable_features` lint to avoid such warnings. This is
> >> the simplest approach -- we do not have that many cases (and the goal
> >> is to stop using unstable features anyway) and cleanups can be easily
> >> done when we decide to update the minimum version.
> >>
> >> An alternative would be to conditionally enable them based on the
> >> compiler version (with the upcoming `RUSTC_VERSION` or maybe with the
> >> unstable `cfg(version(...))`, but that one apparently will not work fo=
r
> >> the nightly case). However, doing so is more complex and may not work
> >> well for different nightlies of the same version, unless we do not car=
e
> >> about older nightlies.
> >>
> >> Another alternative is using explicit tests of the feature calling
> >> `rustc`, but that is also more complex and slower.
> >
> > You mention a bunch of alternatives, but I agree that this is the best
> > way forward. It's very simple. Only possible disadvantage could be if
> > we forget to remove features when raising the MSRV, but I don't think
> > that's a big risk.
>
> What even are the risks associated with enabling an already stable
> feature?

Nothing, really. Clutter?

Alice
