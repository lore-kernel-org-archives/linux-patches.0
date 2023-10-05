Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9166B30F93
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 16:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HydebVo3"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-5a505762c9dso13570327b3.2
        for <patches@lists.linux.dev>; Thu, 05 Oct 2023 09:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696522372; x=1697127172; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+qmSzyY+migyqbDuywRVcv9SVkRkaGgH1rCeouBnpl4=;
        b=HydebVo30xKuIyge3hq3LR0yldRp4C6Ymr5v3cqsulKjzQiLcfk8/nebl/iF4kmty+
         xKoS5XwUir0wUF6o08rjCQoxsEZXfmQmf8u8S8AT7YqH1h32CXEHdy7U7jWGLR75x40U
         YwVUjkfter09mJPP+kRopMXpQVtiT9ANjZ/c8HHSVwhs0eq4BAHg+WUyKGg3mZ9yvv7O
         aIVH/lEsKby1fHy0Ds6I/c+YwvDl1d7kpWOIjX5oAfwmLiPBSEDr357/e1ruXY7R5iTm
         5iyy3e9dPwndtGwW7JrLb8Sf3VrORvzv2NzVjGp58F8k6tfWRm6vaftd9HIk33QYFopx
         h0sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696522372; x=1697127172;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+qmSzyY+migyqbDuywRVcv9SVkRkaGgH1rCeouBnpl4=;
        b=bvN+Cqe5ANvE/vszXyVcpePsYg5c7fGP1tutTKz/aEf+ekXuftaKQn2jhxkgAKK15q
         7tUKdfTkQerobPbiaXZRir6A91OZoIAi42nLyrJkUTge1r/rbwFpmNZ1YwqVk07hc6XJ
         2tqrasu2iCE7xFLkLucOcm5C9kLSWdR5FY15CfeTowNrLDxqZPasVjlvFqkxWydecurJ
         hGXAPR5e1pZ7X6apeg3f+Igm26K+muvLCkJRvSMuabCAw9YRPsljXadf52DTqvJOs/1E
         9iwH9p05doamtDlbjQVb5ktLpbJpUz8RyOUPs92GYsM5immmptK/OtoY7z22F7D5s62a
         44dw==
X-Gm-Message-State: AOJu0Yzbgz4LVellEXROd28jMW2m9fUPV82lC6M36xLC6l1VZpT+3N1Y
	7GHaQlqKZRCH+8w8ov+cwO2B2+wnlByPcrQeFDI=
X-Google-Smtp-Source: AGHT+IFyDJEnqRL20o900cgp9GOfXgPyMQ2L6Aqu6Z2jkwZ63XPw2aTYKRO6CldxKTzNI0xpEBmV02zjKYsX4Y67FmI=
X-Received: by 2002:a81:7c46:0:b0:59f:6766:2c12 with SMTP id
 x67-20020a817c46000000b0059f67662c12mr6423391ywc.39.1696522372498; Thu, 05
 Oct 2023 09:12:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230830165949.127475-1-ojeda@kernel.org>
In-Reply-To: <20230830165949.127475-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 5 Oct 2023 18:12:40 +0200
Message-ID: <CANiq72kmC1Az=gCMnJ_jcsQHNpbbQn=qUytyFexeg9uPpW=q4Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] MAINTAINERS: update Rust webpage
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 30, 2023 at 7:00=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> A few months ago we started a webpage for the Rust subsystem and
> the overall Rust for Linux project [1].
>
> The current `W:` field of the Rust entry points to the GitHub
> repository, since originally we kept information in a `README.md`
> file that got rendered by GitHub when visiting that URL.
>
> That information was moved into the webpage and got expanded.
> The webpage is also nowadays the entry point to the project,
> and we pointed the "Website" GitHub metadata field to it.
>
> Thus update the `W:` field to point to the actual webpage.
>
> Link: https://rust-for-linux.com [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Series applied to `rust-next`-- thanks everyone!

Cheers,
Miguel
