Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4555B76DBB;
	Thu, 21 Dec 2023 21:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rw9SlLBG"
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-dbd73cc1e52so1215856276.0;
        Thu, 21 Dec 2023 13:42:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703194935; x=1703799735; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rid+g3xZdJDgqp/Yc2xW5mOJwNnrU6NKIQJkfAyL0OA=;
        b=Rw9SlLBG5xa0IvKrfsEJBHbKwMpNOUiUfdiHyZbJFt1VqGH4tI1tQRZ7yg7MEqLitO
         TZVlmAyb1OX8B24srPEliWBx4XbzKIacszXikeCO08BoKFoEqFJPuw5/Z5oXfO68v9sz
         B0B3areS3wYWx438y/jsCv48tJbB7Dtnc/mHPLRsflJGqnhvKgqvro6pFKbg1LJblYsR
         ukA/bpwa0yV1vGb4HQu6WT63glJu/M4Oz6bafAhKz7LAlCRD2C15OniecESXdYjGx9+F
         vgY1IEg0X1jGEBM1cgxTvbdMRkMoZ/w0t07EPJ7IdLusbQ9Vmv3UUyuVRPXnIvjlbY7y
         YhKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703194935; x=1703799735;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rid+g3xZdJDgqp/Yc2xW5mOJwNnrU6NKIQJkfAyL0OA=;
        b=HodsN9EmBq5v7tS0V2HTAvSNMT9FjUlpXUR9kt6h1gFcTPN0QY8eP+6vlIEFcxiLX7
         22TeEgtbYF6q5+xDia2eVGJVTRLk0kbAioY+8+jBquv1fk+TiwjP6mefma+ZiWug7ZdW
         wmqlLP4sEEzqvTv7/m378mVR6Pw/FQLj0RIYN/HliD4cJTFx5hIhXwYDZUJ0eRETHxjg
         qG+cRx5mdZhR9yF1Tsn4obkhdyV/Y+bdPR3lRJGZjAT/eQDZEwKNod6d4Yzj+zNllr8j
         fByAAMOTtjIqx92IMT/0Aeow1OrG9R9CCzsQLOZePeXH37Jo3dqQsevOJjEbTarrb3Va
         gQkw==
X-Gm-Message-State: AOJu0YwGfjgoJ30CQAZhx6BCWLSxITwplceNu8nc6j+JY4Tnh8NwejW/
	+arwe2CRpHc59EsUaMq6oWIrGv6WcQJSo4reKgQ=
X-Google-Smtp-Source: AGHT+IFV/LMIZxkaJdLt4PJlTuBD8C3WJ6yeE+gO4Dg47v3tAtxOHZpyXy5abBbykfI3FbNxJ/O8C5pwwo8G880SUJs=
X-Received: by 2002:a25:d782:0:b0:dbd:6506:d8df with SMTP id
 o124-20020a25d782000000b00dbd6506d8dfmr388370ybg.74.1703194935306; Thu, 21
 Dec 2023 13:42:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231215124751.175191-1-ojeda@kernel.org>
In-Reply-To: <20231215124751.175191-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 21 Dec 2023 22:42:04 +0100
Message-ID: <CANiq72=vkdLQ=vu4tDZpWz8C+YJCeZfwToRAR3wKm1Vt2wxzcg@mail.gmail.com>
Subject: Re: [PATCH] docs: rust: remove `CC=clang` mentions
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Jonathan Corbet <corbet@lwn.net>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, linux-doc@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 15, 2023 at 1:48=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Nowadays all architectures except s390 recommend using `LLVM=3D1` instead=
 of
> `CC=3Dclang`, and since commit a3c6bfba4429 ("Documentation/llvm: refresh
> docs") the Kbuild LLVM documentation makes `LLVM=3D1` the way to go:
>
>     We want to encourage the use of ``LLVM=3D1`` rather than just
>     ``CC=3Dclang``. Make that suggestion "above the fold" and "front and
>     center" in our docs.
>
> In particular, that commit removes the examples with `CC=3Dclang`.
>
> Thus do the same in the Rust Quick Start guide, i.e. remove the `CC=3Dcla=
ng`
> mentions, especially since the architectures that have had their Rust
> support upstreamed (or soon to be upstreamed) are all `LLVM=3D1` ones
> anyway. And perhaps by the time Rust is supported for s390 (or new
> architectures), it may have moved to `LLVM=3D1` anyway. Otherwise,
> this can be added back if needed (or perhaps an extra link to
> Documentation/kbuild/llvm.rst).
>
> This should also help avoiding potential confusion around `CC=3Dclang` [1=
].
>
> Link: https://lore.kernel.org/rust-for-linux/6df6e8e5-8d5b-4d3d-91b5-bc0e=
90c424ea@nvidia.com/ [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` -- thanks everyone!

Cheers,
Miguel
