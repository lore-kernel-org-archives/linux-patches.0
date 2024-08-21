Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8473117B500
	for <patches@lists.linux.dev>; Wed, 21 Aug 2024 22:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724278428; cv=none; b=WT4UfXwJ8uVip64thbu7iZdFYnMb2FYInw/g8ez2M8UEuiozbThDqINaOA8rfQm8jTZtH6ftCnazt4k03lqXZudaw5AMe5cWq9K4ZO52gj0vWIGtu9RbnQHPTbKHw71RyXvQy8i5gnqUx+z7IWtJ8Td4tgjHi2L2r3USxBqbmYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724278428; c=relaxed/simple;
	bh=QhXejlXvAomkFd8EP61NJGFSBPRUcQ/txFYLGv+s3pk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o4BeiveP222nTal3T9Hn+q7XCLilWndiofjBrNv77NNV4wjXjyybLF+AJCeJUGX+Y13apw3bp8MRj8qs02+409PVQJ84nwquV8itEunjj55LQ+ac+zbqZF9RFa7n7vuwm0Step40heXr3MDaJoDHeV7NScwcOJ8Jxqjh7Jpn08c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JdoPnSB4; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JdoPnSB4"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-70d2ff38af8so22446b3a.2
        for <patches@lists.linux.dev>; Wed, 21 Aug 2024 15:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724278427; x=1724883227; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pgTqsnBM9O5JTCZtnF9wRMYwA4akEnvManPLStJFabI=;
        b=JdoPnSB4LbwEdKD0rEMh6f0n/BUD+cgTup19dahg7cO5KIIADcqNrEEvXmSa13yvzk
         Vmjrdre//MF7uZ0yMDjaJMg+RCSH+WyxYgGTkbqNwUummeEeho2Hqf7B5kZIsUVQuWaX
         FcscjO0Ph84MUpkmnwSeC31RK6LhtP+JFskQpZVDZoHXLzj2NM/5479nStZgRO4wbyMw
         TpgbW3N9Axuko5ulEwfK3YYTZPQmIGqCEB++ajtjuSlwgEZWWYYsnfptzGJXEV/fK6I8
         PC8a4OFK99C34TfuhTrKVaXhOAkHl2Ng/NJfp5kCjfYyDTKUjkrVkcih+0Vbs6CpE86y
         Fj2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724278427; x=1724883227;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pgTqsnBM9O5JTCZtnF9wRMYwA4akEnvManPLStJFabI=;
        b=I0MJB1QMU62oFhGcEijTOqlDx6uA0Wxd0eFLOJmdKdeyoS3Rli6kxBc1KDcLi88l5t
         fHMxAyCNtC711/eHgt/ukl7tf+EQR6OOZsgs67UON/qc2ob7PUcQg93x+VOGrKGK0kZ2
         h6oWaS/DvMG2RztLZklZQKXuyCwTwCl2dbXfOkqsKsieSZKOwWjxJK4PjcQF5yCsT3WV
         P/1pUwsCIQEuketqhal1/VWtWeiC6D2YL58Xb3txHHPCEEcnDR1gk3s5UcVuEqbJaKky
         HMGhcDMd703M5iB1mlWIM5DiSZqmQj1d5npp2zGeti3NL+qCD23r5TwZrzpw8TkgTOs+
         KZpA==
X-Forwarded-Encrypted: i=1; AJvYcCWPYC+L5GXfIk/ugTc5AuQ1FPb42ndMwuRymq6zV8ACJ4al6JLEPpsyBejlnliU9zgLjDj8HYzV@lists.linux.dev
X-Gm-Message-State: AOJu0YxmKXAozJFaDBQKmI/WL9VtVXciNPP3RrUTWQbxtdAnbL1AQQDf
	hcy0zzsRizL/zoyyyqJVGldqzNZZ8/vwDv8kHmsCboqt6FTtK9YocFdsEHiOMrKCwl6E3vg5ttZ
	63nG5GHhwID03IKltzWs9f+128/s=
X-Google-Smtp-Source: AGHT+IFt49kL1Ixsc3kRci9+nRnfWm7P1N0g0CNp61ltVH4fSelwuKgrdRmJAH6JtYIjIvS6h/bvJPl/72+LTfQImeI=
X-Received: by 2002:a05:6a20:2588:b0:1c3:b106:d293 with SMTP id
 adf61e73a8af0-1cada0422f6mr2590110637.3.1724278426631; Wed, 21 Aug 2024
 15:13:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240814163722.1550064-1-ojeda@kernel.org>
In-Reply-To: <20240814163722.1550064-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 22 Aug 2024 00:13:33 +0200
Message-ID: <CANiq72k435QRB1ZGLTaf-yPgGZ4br5UZCrCDx3TWZxDavAbJgA@mail.gmail.com>
Subject: Re: [PATCH] rust: enable bindgen's `--enable-function-attribute-detection`
 flag
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 14, 2024 at 6:37=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> `bindgen` is able to detect certain function attributes and annotate
> functions correspondingly in its output for the Rust side, when the
> `--enable-function-attribute-detection` is passed.
>
> In particular, it is currently able to use `__must_check` in C
> (`#[must_use]` in Rust), which give us a bunch of annotations that are
> nice to have to prevent possible issues in Rust abstractions, e.g.:
>
>      extern "C" {
>     +    #[must_use]
>          pub fn kobject_add(
>              kobj: *mut kobject,
>              parent: *mut kobject,
>              fmt: *const core::ffi::c_char,
>              ...
>          ) -> core::ffi::c_int;
>      }
>
> Apparently, there are edge cases where this can make generation very slow=
,
> which is why it is behind a flag [1], but it does not seem to affect us
> in any major way at the moment.
>
> Link: https://github.com/rust-lang/rust-bindgen/issues/1465 [1]
> Link: https://lore.kernel.org/rust-for-linux/CANiq72=3Du5Nrz_NW3U3_VqywJk=
D8pECA07q2pFDd1wjtXOWdkAQ@mail.gmail.com/
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` -- thanks everyone!

Cheers,
Miguel
