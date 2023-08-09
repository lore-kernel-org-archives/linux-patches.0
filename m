Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169691E507
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 23:20:16 +0000 (UTC)
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-6bd0a0a6766so318110a34.2
        for <patches@lists.linux.dev>; Wed, 09 Aug 2023 16:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691623216; x=1692228016;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q4bjpbOVzhS/c71+nx5Vv5jKZGKpCfxh8wPlkNMHQKA=;
        b=jjJOPhx6JTrsO9FS7aBuBZ1m4BVV4rSCmkmT7q0epzQwjEGjsYbjj7WWhQr504ivDT
         whbaPitcK7eiPRqQdOlSIrRZXuE6xiqfcCtFYOmF/Oqk2IJMCHjv3MOpnu2uNBmf0FVw
         yknUDb7q+DMM7LIW2Amun+1mbYCVTG/+oYsrSN5QsTKR3ErxcoQxbQLiaJcmzgcO6Xb3
         8zfpb5pM/DbK6wJayfk4HYxy85iU8M/C5Ij9H5WyQ3qdA38A0dvcdgkuNOj2A+5PgBK1
         yFhoUjmmFhXPVMVtSwMJBclyayEox4B1LxEB8lgcGK3BUucovjoehA91etuXl739JCJ7
         eY9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691623216; x=1692228016;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q4bjpbOVzhS/c71+nx5Vv5jKZGKpCfxh8wPlkNMHQKA=;
        b=j726NXOhKT34eZrUzUjiyDE/3p4ZQGZvpe6qz/pyLnmsIWWtHGXf+0m8UtpbWvWj2N
         PrYiMEMN1gJqbasreWyBRnSsBmo3wIsdsATESlmJFvfsNmcsvem8b7tKDqBfwLvb6p3K
         czoRbnReM/PSROu6h29XRr5cN3P93JcXrg+w/nV6VSXkPgD3IllqgA+GImGkaQoIQlMJ
         RTvtraJwYBdPUf9Mgez7IZXRHw/wvCW7beVia8hC5rqaiJxvK229o1HlW/t6n6X90BCh
         YK1+D5hQuVJQZXW4JqYyyhj7wQvH6mFZZjGtgPvIKgrA98VhmOgbCNxzJXsgBWHFRWrU
         ct0w==
X-Gm-Message-State: AOJu0YxDQ9T2jIA2ExddBMotUB0OXOWNWLzZ34zPvdx0uMpX4oD0aWEN
	blmMcTBB193YL103SSnlHlZ5eyaZBFC1Src2r3Y=
X-Google-Smtp-Source: AGHT+IFzc9WExJTelE4UFXJdXGTsbbj7zl8kEJ1ObbVww635P/YePw5RXRXX2R/HzdZTmwBWSFoSOsp+jAXgiJNEqMk=
X-Received: by 2002:a05:6358:905:b0:135:89d6:22e9 with SMTP id
 r5-20020a056358090500b0013589d622e9mr972139rwi.13.1691623215946; Wed, 09 Aug
 2023 16:20:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230718054521.1048785-1-ojeda@kernel.org>
In-Reply-To: <20230718054521.1048785-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 10 Aug 2023 01:20:05 +0200
Message-ID: <CANiq72mizpDgKq+1vn0aQejMw0205oq6A_1yfw5RCVsVA1mVkA@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add Alice Ryhl as Rust reviewer
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>, 
	Andreas Hindborg <a.hindborg@samsung.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 18, 2023 at 7:45=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Alice has been involved with the Rust for Linux project for
> almost a year now. She has been primarily working on the
> Android Binder Driver [1].
>
> In addition, she has been reviewing patches in the mailing
> list for some months and has submitted improvements to the
> core Rust support.
>
> She is also part of the core maintainer team for the widely
> used library Tokio [2], an asynchronous Rust runtime.
>
> Her expertise with the language will be very useful to have
> around in the future if Rust grows within the kernel, thus
> add her to the `RUST` entry as reviewer.
>
> Link: https://rust-for-linux.com/android-binder-driver [1]
> Link: https://tokio.rs [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` -- thanks & welcome!

Cheers,
Miguel
