Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EE6269CFA
	for <patches@lists.linux.dev>; Thu, 22 May 2025 22:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747951839; cv=none; b=OZqVvQW58NriDaFRKNhNKAauy+HJH/uz5OIVshtTu9vihwhkgD/sCJoNZHoxlVzYGG5/pMN+nvaPvc2+J7Y3hCcrcPYfXhBuaMhjElI8yheuxgBimz3HGc8CLn2+k+gTQcU9qAb1vx1Gjal9OaQxYHgl2Q8LaIqUkjA03iSuVG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747951839; c=relaxed/simple;
	bh=Vwp7L6L0DbadGmW+6IbLFn7FDl7XlbaZVO+AUTwmZBA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MwMwdyLsHDvLimENrulVzopNfWe0csOgNSi5jDR7HOZhxYpZHww/Kpghizlrct0vZ4H6KonaHvmispX161H7OmAkvLSYL4vefnBFFcJzLD6UyEhfXFzuz0+Et+fRyJXbWZwhSmyGou9Vm0vyNWQGBJhQ92k9IF3tGtdoqkiZD1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mUox3gmr; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mUox3gmr"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-231ecbe2a5dso6455235ad.0
        for <patches@lists.linux.dev>; Thu, 22 May 2025 15:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747951837; x=1748556637; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QaVcQnOHZhXdhQaf8IN9xC9rWiAxsOh9GVu5nLs1VX8=;
        b=mUox3gmrjg/bSjAA0MnSwsHyjE+6EbxzAVoebN2V2Pi4bRXpxbdTvu5n97gKt14CBK
         c2SXkduzqn38/QTcaGbpufO5Qnw2xzU8Z9+Tlo0GcufBF1BSZNWVgSXpbHFXluoGzome
         rBia5KwlJGZOBmXQdpIxPZSxoS2Tj8vsnu1upCVMw28AM5xnsCPCiSnUZ+c/SrLujIO7
         Jexaknrs089pw/zSKA2CeD8NcRREcp0XoL/apVN6pITFYAc/fNmv2Hy5phAjwrFubCYG
         EGDuW5gzsBBRrUfywB4GFhWUhPfMcUXmH0iIKJ4f8rdIYaMPZ2TWg1K+w6JKo6W18L5c
         QBVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747951837; x=1748556637;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QaVcQnOHZhXdhQaf8IN9xC9rWiAxsOh9GVu5nLs1VX8=;
        b=GiyASEbRF7Cy3HA5ss8PPjLgEjf3cz3itoCSlBnbsrYw43c8B9Q50uC7+ex9jg1nW1
         RyEmbg6/hIqnnEfiyq60vWQFm50WIZoIIe58xZ3ubdxAm41AJYXRa3EEFLEzxrdzGTCU
         aMrXq5OHX28dXhpDDqf5eqmw/NcsC1p6D3F8SlfvCZuEEOEH0YOu25PbMNjNg4wEbELi
         9nYEOuulWiQzzUmLYAYd5/LVH9rCx+KQnRwqRUMLTb0N2jTlttMjP/ujseCJa8ujBYso
         MGl9mAi6IuHITt5sdP3LY6RR52F//8UOkb+2+9OLmcOp0HZVBkDAGb2TvUQF72QeMW6S
         pJgA==
X-Forwarded-Encrypted: i=1; AJvYcCU661VXnyICCjnHtZbsiP3N96GlOf3Rtr33oo/v+knG4k8kmlXbMW1a8YsmcDnvJpoTAznR605t@lists.linux.dev
X-Gm-Message-State: AOJu0YwYWuSgPERtVT0pnHIxw9+o5HIjzPs4uDXoaVptsxKk972HHXkf
	tKdfh5NOjC9Kk0Y+W8kZddivkxV48ZuyVwFD6LqAGwprGVCfxn6zkNXDm+tzZTH6YrD2RVcQYd5
	jZqz7NhCHQJ7ZB5L9/8E+Qc2QvumGQt4=
X-Gm-Gg: ASbGnct7xrjmvvRe47qfuyMUlkKndf0fHRjI+HFbIJRRaZBF+NZngUs9TcUpBHjttTq
	DqIRZgcEUcnVe+aWfxvU9kMirSmStYq9ToMGgbJ4DdLWf8Agx3Gjv6RZlT0eE2J4YZuRjS3HsAM
	ZVY6Y/sRE4fF1fF/roIDiqVFx5HjIrACzr
X-Google-Smtp-Source: AGHT+IE6aWxf93Mgju2436vKfZ9FnWr6MAWyx+AfEYRoQoWD+Un59jcMnqr7D+uOUxx2gT5GGNl/U6k7mzVQmXV29jA=
X-Received: by 2002:a17:903:4b28:b0:22e:50d1:b8d1 with SMTP id
 d9443c01a7336-233f3658cafmr976555ad.3.1747951837366; Thu, 22 May 2025
 15:10:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250325184309.97170-1-ojeda@kernel.org>
In-Reply-To: <20250325184309.97170-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 23 May 2025 00:10:24 +0200
X-Gm-Features: AX0GCFuI-Cp0LblAbfBsD5C8vBzb-kYyMkgjULkrHzzq5fNIwQ_8FcHrtWkpgus
Message-ID: <CANiq72mwbJZ4kDe6CGBovX=_y0h+6y_xzYKoY6384oyCmcazSw@mail.gmail.com>
Subject: Re: [PATCH] rust: workaround `bindgen` issue with forward references
 to `enum` types
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 25, 2025 at 7:43=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> `bindgen` currently generates the wrong type for an `enum` when there
> is a forward reference to it. For instance:
>
>     enum E;
>     enum E { A };
>
> generates:
>
>     pub const E_A: E =3D 0;
>     pub type E =3D i32;
>
> instead of the expected:
>
>     pub const E_A: E =3D 0;
>     pub type E =3D ffi::c_uint;
>
> The issue was reported to upstream `bindgen` [1].
>
> Now, both GCC and Clang support silently these forward references to
> `enum` types, unless `-Wpedantic` is passed, and it turns out that some
> headers in the kernel depend on them.
>
> Thus, depending on how the headers are included, which in turn may depend
> on the kernel configuration or the architecture, we may get a different
> type on the Rust side for a given C `enum`.
>
> That can be quite confusing, to say the least, especially since
> developers may only notice issues when building for other architectures
> like in [2]. In particular, they may end up forcing a cast and adding
> an `#[allow(clippy::unnecessary_cast)]` like it was done in commit
> 94e05a66ea3e ("rust: hrtimer: allow timer restart from timer handler"),
> which isn't great.
>
> Instead, let's have a section at the top of our `bindings_helper.h` that
> `#include`s the headers with the affected types -- hopefully there are
> not many cases and there is a single ordering that covers all cases.
>
> This allows us to remove the cast and the `#[allow]`, thus keeping the
> correct code in the source files. When the issue gets resolved in upstrea=
m
> `bindgen` (and we update our minimum `bindgen` version), we can easily
> remove this section at the top.
>
> Link: https://github.com/rust-lang/rust-bindgen/issues/3179 [1]
> Link: https://lore.kernel.org/rust-for-linux/87tt7md1s6.fsf@kernel.org/ [=
2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` -- thanks everyone!

    [ Added extra paragraph on the comment to clarify that the workaround m=
ay
      not be possible in some cases. - Miguel ]

Cheers,
Miguel
