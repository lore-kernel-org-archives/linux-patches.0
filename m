Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E4479FE
	for <patches@lists.linux.dev>; Sun, 29 Sep 2024 05:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727586195; cv=none; b=RMWN3wCEasR/6QnVbn0H2GmXLNQe/xa0QEpc59/ftYmI4QG4Fo9kXbIRjL4vqVU1CQSRHuFXsFdXFO7rR1TBgGRejHPKBp5UyRB+wWaF8LrWyM7slpJE4hRZIskRu7n1sXziVHl4sXEaWuRFboDnmY7dXGhINLdq242+YuZLKcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727586195; c=relaxed/simple;
	bh=MBBs2gBB1cs7jAj7EozRTGzyrlscYTocqcXOG2eQawU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZLypcurmqptfNiv9W3JwZQQ/jULVmWXSbJil0OLBhjYwzyWPEyJnvycd7XXMETXvTgdXEhZ07nS5apDyTyVLnvLYdjEsTQZeXjGyno0S1psXr7lv7TnIpW5/x/nwMHHrKHLVAOkDcfLx/YmfnZf/q4cjU2wUAGOLTlnAohLJ9GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu; spf=pass smtp.mailfrom=umich.edu; dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b=clDXB+8o; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=umich.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b="clDXB+8o"
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e02c4983bfaso3092887276.2
        for <patches@lists.linux.dev>; Sat, 28 Sep 2024 22:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03; t=1727586193; x=1728190993; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T4fJ3od1/Qv1njknmjb1VUvECYnufqLrw2fjOCobJsA=;
        b=clDXB+8o4LCc96nvYTeacW8DGjOTdqa/PGv5BcNTQJLmnCRo9wn58ocYJYhEuVbSYJ
         8UXotCpqEIWgkumoYhV9go+rXXatsws+stDreTKGTPMnU6l8s2oUzxCB+vSspuAr3rYv
         1f7V6WEX3wRJAILIvidCqUNdlaJkF53h0LDuahLz1dbyWbaQebFO2ft3D1UABmhpHI8I
         os4lNNvlWshGUp2rJ5ACXb7TKOY/sp+cnddUQ2zD6Ac9QgalXBAw3f45IDbp22GV6kuJ
         AaDDvZm2Ir/zLN4ICqUhPqVU2ipy3gUCfaF53aS/OJPrqDtOp/bQ3X2FQZn7QZw6P8DK
         TL0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727586193; x=1728190993;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T4fJ3od1/Qv1njknmjb1VUvECYnufqLrw2fjOCobJsA=;
        b=tFg0YFGQ0I2NyazHMzXHTt3giGAqmoThR5F8yHRFjwj0nxt2+MtBt9x3uRV7N6H3tg
         9178j/1c6p/qDipfI91LzpEoVfrvrscPeY4PemZaX5MJYZqNko331tVOlh1jYmJ4K7qa
         o/WnwMhuj/Kb+cm7IMuu+00cvAp6PVoROpsRlDJHkSS3Itz2Y/TBLsulT6wp160tLCbG
         jD6Wbr0yyB72XT663iL+Flu+XBpdPAn8iG4k+yW8+VMEybdlLcjhVE841PJPNJFkky0+
         Gzyi2qOuR919jlYoRPQ/hbyxGh1+F9XY7iL2kBnfvfYl2fuvEIS3ZS2FsDiflUh3BPwL
         NThw==
X-Forwarded-Encrypted: i=1; AJvYcCU9Mj/q/eCKkE+fE51TlzHnxYSAveVAeOZWLVa09CENdjQIhCUx3mkY2h46/Kww0DCOhLt07T6g@lists.linux.dev
X-Gm-Message-State: AOJu0YzxpE/S+flc459UDKGu40tq38SPI5tepqF58bJaNRUJ0IKdiZl/
	a/qvfRwBam2b1G8GI+dVbMxyCTUJaazCAY+DdppoX4RRUn9hnRscIWyYuDeYSW+ZxqTWOJwkwTS
	qUn2jmoBolQJBzldIFZUJ6QFOxDJXOgjV9VbxyQ==
X-Google-Smtp-Source: AGHT+IGFGA2ibiacUm5SY6v/Uk0BKQDc1zVikRtFuWauzKWc3ornt2i9Ow+fpFE8fh1RyZtr7swqV66pd31i/h5zmXg=
X-Received: by 2002:a05:690c:3385:b0:6d0:f91e:2ff0 with SMTP id
 00721157ae682-6e24751f3ecmr63818057b3.11.1727586192644; Sat, 28 Sep 2024
 22:03:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240904204347.168520-1-ojeda@kernel.org> <20240904204347.168520-17-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-17-ojeda@kernel.org>
From: Trevor Gross <tmgross@umich.edu>
Date: Sun, 29 Sep 2024 01:03:01 -0400
Message-ID: <CALNs47s=kCJUJstB4WW1KF_b55-e1kYQ_1rZjPu=LWxv2gmF3w@mail.gmail.com>
Subject: Re: [PATCH 16/19] Documentation: rust: add coding guidelines on lints
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
> In the C side, disabling diagnostics locally, i.e. within the source code=
,
> is rare (at least in the kernel). Sometimes warnings are manipulated
> via the flags at the translation unit level, but that is about it.
>
> In Rust, it is easier to change locally the "level" of lints
> (e.g. allowing them locally). In turn, this means it is easier to
> globally enable more lints that may trigger a few false positives here
> and there that need to be allowed ocally, but that generally can spot
> issues or bugs.

s/ocally/locally

> Thus document this.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  Documentation/rust/coding-guidelines.rst | 29 ++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>
> diff --git a/Documentation/rust/coding-guidelines.rst b/Documentation/rus=
t/coding-guidelines.rst
> index 05542840b16c..185d3b51117d 100644
> --- a/Documentation/rust/coding-guidelines.rst
> +++ b/Documentation/rust/coding-guidelines.rst
> @@ -227,3 +227,32 @@ The equivalent in Rust may look like (ignoring docum=
entation):
>  That is, the equivalent of ``GPIO_LINE_DIRECTION_IN`` would be referred =
to as
>  ``gpio::LineDirection::In``. In particular, it should not be named
>  ``gpio::gpio_line_direction::GPIO_LINE_DIRECTION_IN``.
> +
> +
> +Lints
> +-----
> +
> +In Rust, it is possible to ``allow`` particular warnings (diagnostics, l=
ints)
> +locally, making the compiler ignore instances of a given warning within =
a given
> +function, module, block, etc.
> +
> +It is similar to ``#pragma GCC diagnostic push`` + ``ignored`` + ``pop``=
 in C:
> +
> +.. code-block:: c
> +
> +       #pragma GCC diagnostic push
> +       #pragma GCC diagnostic ignored "-Wunused-function"
> +       static void f(void) {}
> +       #pragma GCC diagnostic pop
> +
> +But way less verbose:
> +
> +.. code-block:: rust
> +
> +       #[allow(dead_code)]
> +       fn f() {}
> +
> +By that virtue, it makes it possible to comfortably enable more diagnost=
ics by
> +default (i.e. outside ``W=3D`` levels). In particular, those that may ha=
ve some
> +false positives but that are otherwise quite useful to keep enabled to c=
atch
> +potential mistakes.

It may be good to link to the docs on this,
https://doc.rust-lang.org/stable/reference/attributes/diagnostics.html.
Either way:

Reviewed-by: Trevor Gross <tmgross@umich.edu>
