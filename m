Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45526199F1
	for <patches@lists.linux.dev>; Thu, 20 Jul 2023 09:59:34 +0000 (UTC)
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-cefa8fe4cc2so558638276.1
        for <patches@lists.linux.dev>; Thu, 20 Jul 2023 02:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689847173; x=1690451973;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YKuuwxkODmr9Zm8vKZysQKHD2KRDyuArZZruCry8jeM=;
        b=pznHFrr9YJM+RHqmlxyNJKXxI4h342lvODnvMjAwuIofkBABz6uKv0WMDFNup1Hdc5
         5jGNH94K9B+Rdq7apgK9JIPzNCMfE47B4efwzN1blJcyOvW5k+w7RNxm6GsYvCBiz6eE
         ru6042+DSrI4b2jXhoy+5yFR82uGwSOZQg3nZ7WW22sD0VRAT6YotZm0b3UrbqB56Lo5
         7Tl9NAu2AU2ZXHdBK8cc3AZn9EkoMqZBp07R2tX17t6r08TDzyqbPk/NYWnRyWZ2OZHf
         peAvgMcRRPDWHOXzDrVsjhQOT6RITDpkkWGFJ2yn7YiDlfV31DI5tSHrEQIezLGG95Qu
         C3CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689847173; x=1690451973;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YKuuwxkODmr9Zm8vKZysQKHD2KRDyuArZZruCry8jeM=;
        b=ZdHyRn4rU14ynQXNMDeU4USzyq9T2JzUx3tTFmfrteimsgUe0QVutHOMZBc06AKLpb
         zH5MMlH42o6tkcBeuYb9TnoL3YOB3cT9xSVunIw/o50SGYDnkyPhPePbcSJCGPYi5Zt6
         wc9Xy4MCHIMRyfrqZry+KZncwsbiLAy57PpZa7YunX5IcXn1uC8s0NNGYyY+GiYT2Iyk
         vwfagZOW2zE5po3zkrlBd3hC/6f2Ggl+8FtWzq1yMFSbmDXnQ1u5TsdJunKjQrC30GrG
         /lGOkDP4dkKHjyC6BTtvMBrsDL2VD2G6UM6Z81XXIdtsc97snvAY9XuKkaZ669mro4gQ
         xAyw==
X-Gm-Message-State: ABy/qLZTykWtXuswOFMWDw0610pvMPSmy39umvIPsbS/e11AZ6KG68bm
	i755/luBzp77mMUueuuMUAt/yfQnrNsoVVb8+jM=
X-Google-Smtp-Source: APBJJlFkbKzQpdC8KXGZW/X7uIsPXOLOYb3PRWFlS+ylspA7+yj85YcX50IxoR5pIDz0zccZqnOiHBLqWmdgKO1t4Ag=
X-Received: by 2002:a5b:3ce:0:b0:c60:1036:2082 with SMTP id
 t14-20020a5b03ce000000b00c6010362082mr4195170ybp.22.1689847172885; Thu, 20
 Jul 2023 02:59:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230718052752.1045248-1-ojeda@kernel.org> <20230718052752.1045248-7-ojeda@kernel.org>
 <CABVgOSnCY66C5wza-ZXb8c8UHg8ydbFv4U_7A14UU_gXeESKZg@mail.gmail.com>
 <CANiq72m08qGAa7k37A0rQNf7vvBc1o8JjSY8jNd+m2XzVOT9rw@mail.gmail.com> <CABVgOSnL0Kiv1Mo6feCLYVq6bGUjxN3gUVrW4ZKD4Fh1wUhWrQ@mail.gmail.com>
In-Reply-To: <CABVgOSnL0Kiv1Mo6feCLYVq6bGUjxN3gUVrW4ZKD4Fh1wUhWrQ@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 20 Jul 2023 11:59:21 +0200
Message-ID: <CANiq72nSy2r-sv_4EFJUsFB67WOiMTeaMoER0wKQBRtVx7jzNA@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] rust: support running Rust documentation tests as
 KUnit ones
To: David Gow <davidgow@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Brendan Higgins <brendan.higgins@linux.dev>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>, 
	Andreas Hindborg <nmi@metaspace.dk>, kunit-dev@googlegroups.com, 
	linux-kselftest@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 20, 2023 at 8:37=E2=80=AFAM David Gow <davidgow@google.com> wro=
te:
>
> We merged this as-is, and I've sent out a fixup patch here:
> https://lore.kernel.org/linux-kselftest/20230720062939.2411889-1-davidgow=
@google.com/T/#u

Thanks!

> I wasn't able to find any issues with changing the indentation, but
> let me know if there's some tool which complains about seeing tabs in
> .rs files we need to worry about.

Given it is inside a literal, I would expect it to work (I replied in
the thread).

Cheers,
Miguel
