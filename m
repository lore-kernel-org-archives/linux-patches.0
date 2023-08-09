Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9641E507
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 23:22:01 +0000 (UTC)
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-d3563cb41e9so312435276.0
        for <patches@lists.linux.dev>; Wed, 09 Aug 2023 16:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691623320; x=1692228120;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HAUCVB9hbx+bm1gCJWJ7NI0D5vTP4KeLZCLHymhDXao=;
        b=V+ixzXp8y9iFryPiBEr/0UAIfaBTWtRqcmV3Epr223t+BlW+bs9j0UopmLWuAPAjyG
         qmzAhFYhpoB61/7wMfMHbFx70tFVDNx08ZNekOT8/GE1rKkP2DP+kD3YZlfSP+aUuKqg
         WTNKlKQmkthTgwEYq6GJNNcoq2gB44mMAJcORwhIWNJXgikdGjUgwaXGLVo4zukDt+zj
         EjTgO0Dl4Q2drNMKkYtcHmLwVk6UolBPC2g6qumyQKELnmYuHoR58EVEHCiEKXekqzCF
         d8Vpgh4ueyHv2A0iOYH2PWCnq6UK6RQnzSt1jdOIoRgrHfhW0/+EiMjnGsyzuSHZsQbp
         Csqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691623320; x=1692228120;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HAUCVB9hbx+bm1gCJWJ7NI0D5vTP4KeLZCLHymhDXao=;
        b=Ch7ZRYN7/81QrtLgpyatvTLjWCzu8gkQKuT8Va5O7HG5xI8Ec14SJXk00tfmTLDYHk
         qp1TmP0W6uq7aBprSMd90l9mY9u8jkmzB7mhtPu0NOFLJ123wMZ0WEujtlHZbRjwiRUr
         ZI4DN27TjLSInfsjZ9e+8iA1AAfj+qBN0OB4MzT9ksYy3nalTcwWEfGtQKnF1gT1WSSt
         liSFZOaII8h1El3fy4VkjSMQknsAiFERH/5+WIyvSlh62DSIaoMw5hmcOjvKjiSDc5wu
         B6V69kQZOco/XeUvqPAPnYciisOwwzsBPJzJpj+blRsk7wdSOzeHq92ixYOH66LKJ2by
         KqRQ==
X-Gm-Message-State: AOJu0Yyum5RONwLHAq25UK5AVhSjpgYT1FAwQr/iRwmSry71MQkhx3SP
	EJiyC7wKWDSy/8PhUBK8ARaFzh6/ZIjm6Yr7QwI=
X-Google-Smtp-Source: AGHT+IGplt7IN6NKg9sHyqvgrj1hGD6mus/KNdcOnf0yuldHarmJPd1+ib/dTzvV6O2KSekEQIs3TdDPlbLJu7pVKd4=
X-Received: by 2002:a25:ad20:0:b0:d19:d73d:7950 with SMTP id
 y32-20020a25ad20000000b00d19d73d7950mr903429ybi.27.1691623320133; Wed, 09 Aug
 2023 16:22:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230630150216.109789-1-benno.lossin@proton.me>
In-Reply-To: <20230630150216.109789-1-benno.lossin@proton.me>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 10 Aug 2023 01:21:49 +0200
Message-ID: <CANiq72kUFSc-iX7r0EQMXAh36Bc-4rWPdLnYO0CYbSCRyzpvXQ@mail.gmail.com>
Subject: Re: [PATCH] rust: types: make `Opaque` be `!Unpin`
To: Benno Lossin <benno.lossin@proton.me>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Alice Ryhl <aliceryhl@google.com>, Andreas Hindborg <nmi@metaspace.dk>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 30, 2023 at 5:03=E2=80=AFPM Benno Lossin <benno.lossin@proton.m=
e> wrote:
>
> Adds a `PhantomPinned` field to `Opaque<T>`. This removes the last Rust
> guarantee: the assumption that the type `T` can be freely moved. This is
> not the case for many types from the C side (e.g. if they contain a
> `struct list_head`). This change removes the need to add a
> `PhantomPinned` field manually to Rust structs that contain C structs
> which must not be moved.
>
> Signed-off-by: Benno Lossin <benno.lossin@proton.me>

Applied to `rust-next` -- thanks everyone!

Cheers,
Miguel
