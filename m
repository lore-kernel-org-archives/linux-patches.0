Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E438E2F87A
	for <patches@lists.linux.dev>; Fri, 15 Dec 2023 12:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qgcoPyPo"
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-7cb0fdced70so242274241.1
        for <patches@lists.linux.dev>; Fri, 15 Dec 2023 04:51:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702644712; x=1703249512; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/amUsMdukpvUs/gATYcpXgU/bNaTGRBLojO0rCY2bTM=;
        b=qgcoPyPoSNMcUS0AI9hvrlnFWNtwD/qzCiqsdaP04YCvkPzTSMN8DBL2c+k1QH+95f
         zuITzZrt6OwBHx9cSwp2flRZTQgTeFGQr2apPS/Zrh0JuuH5JDlnZ8v4ECIgIOKR4g7C
         ytczcm6w0VPKSnCJztsaKAeaFVeVEsMrUXFqc2LFope5qggrMgoE1VA4ti9YrA0Tliy2
         2eqBuXQ8F6N11I0iDMg2ZsoKhiOINMk7xUitIHy1vYX87nh2DW2XE055CUngx5K1TExB
         kP4GNaAnkmV7xWwIkbDxUM9hLj5Cpl0WBVu8K3/LIYG2yOAXoq9xmeozlYkdjQjfI5cU
         PSjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702644712; x=1703249512;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/amUsMdukpvUs/gATYcpXgU/bNaTGRBLojO0rCY2bTM=;
        b=al0VHE5h0+Fyc41AbEO/nOlVAgUX+G2ChPHeKTDmNFos25lH/FXzf/KgHRO1QIFwg2
         +HG9VWHuzIF7ZZl08PMSP2+dX8LD/d7V/ZapsrzdQxJVCuWKagn8MKQlJgdBgUFRzglO
         3pHhEKQX7HADSS7lbyhplBBQY7S/13+l6ofVCHU3n1aDppEKYYX1pJywkXgHlSxEc4/c
         I9NB1rIosHtMuV/FrU+q3eeXHBAynkNzIo2nyhkPYOFz6gN1XitWzTwcy0eGqyfwQUwD
         Rcu7DOVM4zYzIFYMHpjVaAqXBYyhMKAR3HDn6tC4/CepSr3kUuCMYwdjO/ffpTAzC781
         HR+w==
X-Gm-Message-State: AOJu0Yy+0pgrm3xpFmPSqg5Oclz0tW1Ylu1uKJbJelM4QySqt9boorYk
	foamD/nqJio+jx13dyPDScTanmg6GSDjw4eZNtzlwQ==
X-Google-Smtp-Source: AGHT+IHO1d4i21i8Ce+aVgKTZYqcdXxdqABuqr+WSle2HNf7ucrVLYhaY40y3LgoCGQ2roFwOXppI9igvBnBX8o2sk4=
X-Received: by 2002:a05:6102:ccf:b0:464:426c:a5c with SMTP id
 g15-20020a0561020ccf00b00464426c0a5cmr11869653vst.18.1702644712467; Fri, 15
 Dec 2023 04:51:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231215124751.175191-1-ojeda@kernel.org>
In-Reply-To: <20231215124751.175191-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Fri, 15 Dec 2023 13:51:41 +0100
Message-ID: <CAH5fLgjYMpd-NG5D2dh=zH3+RWGtuHZE+6Td7tDE+s7n7qsm4A@mail.gmail.com>
Subject: Re: [PATCH] docs: rust: remove `CC=clang` mentions
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Jonathan Corbet <corbet@lwn.net>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, linux-doc@vger.kernel.org, 
	llvm@lists.linux.dev
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

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
