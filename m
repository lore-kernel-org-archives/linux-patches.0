Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53391C07
	for <patches@lists.linux.dev>; Tue, 23 Aug 2022 12:12:43 +0000 (UTC)
Received: by mail-io1-f48.google.com with SMTP id y187so10727467iof.0
        for <patches@lists.linux.dev>; Tue, 23 Aug 2022 05:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Cyy+0Wr2/FQFq8AiuJF/AP46kwKgBUKjMZGYMyzEjI0=;
        b=EKOOtdBHyv4VP+YhKmoDJ9DcGZRVFDsK2vOWoj9zQ6zeHtMqh/yZx9iH/MhmJUbyVg
         gun7TgAS2d60qy4CMsHL7CC6xhym4NzcDtxSvYIA7twB+tPFB7cOgS7ZG3iK7jf6AgY1
         lLrTKo/Yul/3WC96WwPLmIvldy4LS7+v60EGBpp916LZOh55k2eHSfXEI0GNFjS9P9Un
         m7M2/N7rGrvXJbSGU1gZfHOru32NG/PTH2B0SkMZG8f/XQ4OsoGPf6ND1meDxXSougNS
         Mz3k8nqhxhqvbYju/0VBaaamPau1n/8cC02uA3t2MNIHI7eLsgNg8DXGC7d9vF3vxuhI
         KhIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Cyy+0Wr2/FQFq8AiuJF/AP46kwKgBUKjMZGYMyzEjI0=;
        b=rI1PRixweWAP2yMTTgUJ+2pybCq+uUka53txL9H1AkZfGWXiu1sW1qlcj4ONGBDvHN
         PzFy2mIast7Xr9UYZaBQQhGU4h6CAfNBKGkzW7KzTxFcdC6v0eOtA+UboRzSRo7twMgK
         qzBewnbg3Uh88L2T23JKQfeSbcqEJLRLPoyXFmaWYQZjIeZlLMf9qGori4Opyls5dgbC
         NB+ws/Ry3MEjBJQYfujZVd4IyqSrl2UILcLX3UKeoXy4YfwbIPlDaKCnSWlNbDjKecXr
         bjCspNK8nVduO8XrG0d9ElPHQVVaE1JNoQQ6fZK34gkvU8W1PPUBxDQyEZO8KhgqDI5d
         Nm7A==
X-Gm-Message-State: ACgBeo2KeANx9MuZj2oc56zWmBrCcstEKFjaTdsPwWU5EufmYIfUktrc
	lIJmT7Bdet6aJInRWhch1p9bWNQMtMrNZh21nlE=
X-Google-Smtp-Source: AA6agR4fuWtvTLj+xpcNEt1aREO3AwEB7XmRPoUgKPyeIKcu3wNqTOOxEhe9+Xkmj8N+6lhY/kg2PzVNlPK1Stv1nfc=
X-Received: by 2002:a05:6602:368a:b0:688:3aa5:19ab with SMTP id
 bf10-20020a056602368a00b006883aa519abmr10566870iob.44.1661256762815; Tue, 23
 Aug 2022 05:12:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220805154231.31257-1-ojeda@kernel.org> <20220805154231.31257-21-ojeda@kernel.org>
 <CAKwvOdndYxQ+KgVhC8F3vWnHDT8pD3px8cKjinu-khn25_FSYw@mail.gmail.com>
In-Reply-To: <CAKwvOdndYxQ+KgVhC8F3vWnHDT8pD3px8cKjinu-khn25_FSYw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 23 Aug 2022 14:12:31 +0200
Message-ID: <CANiq72nA0WwfnSaNxxz27iM5LXPELQVzTAQGBE30SXeLGVEf1A@mail.gmail.com>
Subject: Re: [PATCH v9 20/27] scripts: add `rust_is_available.sh`
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	patches@lists.linux.dev, Jarkko Sakkinen <jarkko@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@google.com>, Finn Behrens <me@kloenk.de>, 
	Miguel Cano <macanroj@gmail.com>, Tiago Lam <tiagolam@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Aug 22, 2022 at 10:09 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> because I'm using clang built from source from ToT.  Is this supposed
> to mean that I can't use clang-16, clang-14, clang-13, clang-12, or
> clang-11 (in the kernel we support clang-11+) in order to use rust?
> I'm guessing that's going to hinder adoption.  Is there a way to

No, it is only a warning, so you can proceed if you want to risk it.

However, is there a reason you would like to mix the versions?

If not, please point `bindgen` to your newer libclang (see below).

> specify which libclang version bindgen should be using?

Yes, see below.

> I have libclang built in my clang sources,
> llvm-project/llvm/build/lib/libclang.so.  I also tried:
>
> $ CLANG_PATH=/android0/llvm-project/llvm/build/lib/libclang.so.15 make
> LLVM=1 -j72 rustavailable

`CLANG_PATH` is for pointing to a `clang` executable, not `libclang`.

Instead, please try `LIBCLANG_PATH` (note the `LIB` there).

For instance, using the test header to print the libclang version,
this works for me:

    $ bindgen scripts/rust_is_available_bindgen_libclang.h
    ... clang version 14.0.6 (https://github.com/llvm/llvm-project.git ...

    $ LIBCLANG_PATH=.../libclang-6.0.so.1 \
      bindgen scripts/rust_is_available_bindgen_libclang.h
    ... clang version 6.0.0 (tags/RELEASE_600/final) ...

If the above does not work, for details on how the dependency is
resolved, please see:

    https://github.com/KyleMayes/clang-sys#linking
    https://github.com/KyleMayes/clang-sys#dependencies
    https://github.com/KyleMayes/clang-sys#environment-variables
    https://github.com/rust-lang/rust-bindgen#environment-variables

I will add a note about this to the docs.

Cheers,
Miguel
