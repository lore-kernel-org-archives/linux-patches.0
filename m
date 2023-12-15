Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DB047F76
	for <patches@lists.linux.dev>; Fri, 15 Dec 2023 21:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Cc3qIS4P"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-552e4a68de0so1019571a12.0
        for <patches@lists.linux.dev>; Fri, 15 Dec 2023 13:28:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702675718; x=1703280518; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cC1bTSXVCMzouBImm4Lunm53BHd7q+29uIzARRshG/Q=;
        b=Cc3qIS4PEWDLwVhvmZ215vv5FXj4WeLECHp2BlNO1n1gb/Qvw3ohixWNbuz6c/4DoL
         wCi47sfBNVe95Dd3VhQ2oAkeIR3DDXYcDeSJSVFlFcE41CLMy5WqbLdVGKf8DkLPplSO
         4j1OYN6JlrfOeVDQS2qEtL7xtnS70A13EA8y/qrMK+8EeK0MOOkJZSH/3WB6kj2vQA03
         1P3GgCPRGR1MInbLVz+v+SPjMy9FdtRLLesyy4zI6CvpLVesDRB0pqU/egEs73l12KCM
         wjeFeTacj8y50cv/+0ntgpL43q76/X3LUDIiJ2OneSTedwuEnWAtJo93wS2TGCqUFncy
         vENA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702675718; x=1703280518;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cC1bTSXVCMzouBImm4Lunm53BHd7q+29uIzARRshG/Q=;
        b=ITL0u39hYCPFIbZDshEfumjEa3rOy9cwXKGRXN1XKKgsaGXNgrO6bPmf1px0v8al/e
         XDc9+YJDocRhwYmjqePDUmdRBT/Glox1pWdhU0nKpB5rwRwedYju7G6ehif1I3JUZb6r
         z8wcT7fWieDahHwdUtkVRP7tb6k9GEaKsJsZdzL7IyPbvsNm+5uVJIsGqUm/uQh5hQsP
         Xq2seJPBqIyYwr0XaaHzqc7CsDxfNIYuf8Wct4bEThbFylrhlA20GbpvUz7dZfT8pN0c
         Sv17a+8MbvEPa3KaAThgknKontlf/424C1Ay4VQB2C3Uv0KT1yB1rNLBlZmMoBZJnjtc
         8vmw==
X-Gm-Message-State: AOJu0YwRpvuMNrkDhXIVkstSrSUINf7keHEv69kzud9PNrvsn4Njy8kf
	JRx41YvHloso/CXq4eKHUaZWZ4wE/80NTSCKTfv4Eg==
X-Google-Smtp-Source: AGHT+IE2mXg2+E2jLeKihSLfRCnuQkYt+4zI+WvSBMFz2WgpbdwhTo/O+qkSxIF4jSezpRGJphrMSKQXA2O0/0ant9E=
X-Received: by 2002:a50:cd53:0:b0:551:cfab:5538 with SMTP id
 d19-20020a50cd53000000b00551cfab5538mr6411620edj.32.1702675718126; Fri, 15
 Dec 2023 13:28:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231215124751.175191-1-ojeda@kernel.org>
In-Reply-To: <20231215124751.175191-1-ojeda@kernel.org>
From: Justin Stitt <justinstitt@google.com>
Date: Fri, 15 Dec 2023 13:28:26 -0800
Message-ID: <CAFhGd8pHtfuMYfx=uEzssvesQDZ-BS0BzPwn06WbasXKUfPBJg@mail.gmail.com>
Subject: Re: [PATCH] docs: rust: remove `CC=clang` mentions
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Jonathan Corbet <corbet@lwn.net>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, linux-doc@vger.kernel.org, 
	llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Dec 15, 2023 at 4:48=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
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

Yes!


> Link: https://lore.kernel.org/rust-for-linux/6df6e8e5-8d5b-4d3d-91b5-bc0e=
90c424ea@nvidia.com/ [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Justin Stitt <justinstitt@google.com>

> ---
>  Documentation/rust/quick-start.rst | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/Documentation/rust/quick-start.rst b/Documentation/rust/quic=
k-start.rst
> index f382914f4191..75faa987079a 100644
> --- a/Documentation/rust/quick-start.rst
> +++ b/Documentation/rust/quick-start.rst
> @@ -76,7 +76,7 @@ libclang
>
>  ``libclang`` (part of LLVM) is used by ``bindgen`` to understand the C c=
ode
>  in the kernel, which means LLVM needs to be installed; like when the ker=
nel
> -is compiled with ``CC=3Dclang`` or ``LLVM=3D1``.
> +is compiled with ``LLVM=3D1``.
>
>  Linux distributions are likely to have a suitable one available, so it i=
s
>  best to check that first.
> @@ -229,10 +229,6 @@ at the moment. That is::
>
>         make LLVM=3D1
>
> -For architectures that do not support a full LLVM toolchain, use::
> -
> -       make CC=3Dclang
> -
>  Using GCC also works for some configurations, but it is very experimenta=
l at
>  the moment.
>
>
> base-commit: a39b6ac3781d46ba18193c9dbb2110f31e9bffe9
> --
> 2.43.0
>

Thanks
Justin
