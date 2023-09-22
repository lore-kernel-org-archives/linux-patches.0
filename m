Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE8A42BFB
	for <patches@lists.linux.dev>; Fri, 22 Sep 2023 18:45:35 +0000 (UTC)
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-59eb8ec5e20so31194547b3.3
        for <patches@lists.linux.dev>; Fri, 22 Sep 2023 11:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695408335; x=1696013135; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V/RXg7qoPV29Yjmc4Aum7okgMz0oycXOx15sVeIcRmM=;
        b=hBNTdIlr6jJREK21IfpCDsd3UJuhafPUn3gnVNfdtBybJ02KiyNtkpe3HE+M5NtQ++
         cPWEv9MQ4UxRGdr2uouu4jQE45Znz/G/p8UHkOzqvRR5HmmG760tMO7xmZusspH2Uz1U
         7jSev/UZJh0Ft3fxeOILw1hKOdBNws7R0Bji6JE6irhVqGotI9G9h7uHW6q0a73oeTI5
         2UCFPytBOJTzQqbGr8Rek4OCk2rvc6H13ARzNDP0ofllHV4Xy13AY79yzLt/Lc2yB4bg
         Mnql36ExtK8kmJrlHuYsEIWuC80i2Sl07A1imXxi5admLLvLCqQkkZ+s4o+mgGRShbDh
         FbiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695408335; x=1696013135;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V/RXg7qoPV29Yjmc4Aum7okgMz0oycXOx15sVeIcRmM=;
        b=MaDczMpOO/nZwP8L5cQJxPnlB+Iew5fLtAxguzNKveiFXt6m9UqbZPqBHxaq+Ya+3v
         PR6kWjQRv8yoNJiJWIuVsfWmurv1qmYv35Yql+5HWcfbkpvl/qZRA3jIQ4EmPOO1vj1e
         9h8HUyuGt9eQgVytP1kpTS/s2wlSnjPOqUYtPYIdoFFf9xUWXhoe5g9dNuIU+sy+u+Lu
         WbAXAbUN1GM6YQOz1q6g8844ZSD1LoaVWASXb9ansU0uLJpbhBRmYHdWpF43/w2WECvA
         AM+RFhmV6i1jIK+vDsb8SvLdcA3hcspZi7gYIjXhwtkB5caHzRK8vPs89frXaKatZpab
         hJHA==
X-Gm-Message-State: AOJu0YziaPBh2Wz8fQgAXeUbt1HcehvkCVpEXRABIrY2jQh7rJ9E4Meq
	/uuUAyTTsdOZBfQYCepFiv8go85ir8eseumcJb0=
X-Google-Smtp-Source: AGHT+IEJGuXkGoE5AoXH2Ej5LLIiwCK3pJP5rkiNaJ+MP8w/xC9pPc/vjysUkvkG7okFXh2JN6w+5WqePXRZgsUvips=
X-Received: by 2002:a0d:c084:0:b0:59b:1763:bff9 with SMTP id
 b126-20020a0dc084000000b0059b1763bff9mr606135ywd.49.1695408334726; Fri, 22
 Sep 2023 11:45:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230830165949.127475-1-ojeda@kernel.org> <ZO+CBdxxuDBrdDR8@gpm.stappers.nl>
In-Reply-To: <ZO+CBdxxuDBrdDR8@gpm.stappers.nl>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 22 Sep 2023 20:45:23 +0200
Message-ID: <CANiq72kMS8UoYpg0hW1=UDAAkytEoeyqGzg+Sys8VSaucr+HzQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] MAINTAINERS: update Rust webpage
To: Geert Stappers <stappers@stappers.nl>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 30, 2023 at 7:53=E2=80=AFPM Geert Stappers <stappers@stappers.n=
l> wrote:
>
> It looks like "mdbook" and "webbrowser view-source" confirms it is.

Yeah, it is, with some pre- & post-processing to add some extra features.

> Where to find the source for the MarkDownBook?

It is now published at https://github.com/Rust-for-Linux/rust-for-linux.com=
.

> Reviewed-by: Geert Stappers <stappers@stappers.nl>

Thanks!

Cheers,
Miguel
