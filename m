Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A75F79C3
	for <patches@lists.linux.dev>; Fri,  6 Oct 2023 08:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W7OIlyt6"
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-452863742f3so894728137.1
        for <patches@lists.linux.dev>; Fri, 06 Oct 2023 01:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696582375; x=1697187175; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qxeu+1oR48xD2Gd7sf1n3o5+xMOLz2MYkIZCLI1NQDM=;
        b=W7OIlyt6Cs35jMST2E2hgeDsAB77jLaZ3XV4LunF9ZXanJ37vQZQ0KDQXhwPpATbf4
         z+5OTdVJ4RKtjK0VTd/0AJRWCXYcU6afKMz5+cuEKT6kE4b/uZ26jfZzIlXFuLQYo6kE
         6Lrdqq9SuC5sl3ADubPdvupENm3RlVJ8Yy2e4s8L0qwqpkVvzbX1OCYBMWJGlC/HjkI/
         S7aCjHnL8/LtbOmtXf4wXqFRTGHxuUAFkSh8xHqsjPFyxSshANqyXd7dIqu7gSFj3Td+
         EAO6Z45UWrCG+yCPxguZWvuxGGCB1UKlKmrw+419RNYf++4hbZM3QEmdiI96ztrzF9Dv
         sppA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696582375; x=1697187175;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qxeu+1oR48xD2Gd7sf1n3o5+xMOLz2MYkIZCLI1NQDM=;
        b=I2ah2BCQs9fGfLOo6X0N00xFuiZJMOlaWJZ3lKU5XsDfLMgLwL2jLS7qIr/30Fn6QG
         Oci+WRw9GYYjDzLGtn4SaIJLua762WHwVHcZVAYcwN+IwAxeVkGr60I9Dh0ZEWfy2Jr9
         bCjuHgnwR+09lT+V38yTEkAlvUOFNoCLlS2m3301UqeHixTrebs2zsdDAY8MXBltaHfY
         p41TnuoiXPOVM5A0RD7Knq3K0G60ZkybyZwcHgK0gl+4/64fA/omUluETXpYDWluNLVT
         J8iZz2NkSMXl6fMOXL62x0OyKcM+MiJaFoXqcMr3lD7B2DqZzvnsMYI/yOFBxzb3puyP
         k4Bg==
X-Gm-Message-State: AOJu0YxAaUlsNX//XKp1Tc7RR2yAuPTnG0PYG5eL4Wf8B+RTJYyZou9N
	wXKxJVUiMJAX9rw/JQ3FZvnoj1ROSEStJVesnPkjPA==
X-Google-Smtp-Source: AGHT+IGpa9oDupsxw07rqioIpfopJAPI0Ytv6CAxXQQ9ojG3965uvekx2SZ/ff+/vZJ9EI796i4mhJoVjm+u2xK7FaU=
X-Received: by 2002:a67:bb06:0:b0:44e:9674:7781 with SMTP id
 m6-20020a67bb06000000b0044e96747781mr7243449vsn.15.1696582374867; Fri, 06 Oct
 2023 01:52:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231005210556.466856-1-ojeda@kernel.org> <20231005210556.466856-3-ojeda@kernel.org>
In-Reply-To: <20231005210556.466856-3-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Fri, 6 Oct 2023 10:52:44 +0200
Message-ID: <CAH5fLgiqCyV3OJ_mvBrSH0rX+GhQ9f6EpY+eZ13g_ebmue1TNg@mail.gmail.com>
Subject: Re: [PATCH 2/3] rust: print: use explicit link in documentation
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 5, 2023 at 11:06=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
> The future `rustdoc` in the Rust 1.73.0 upgrade requires an explicit
> link for `pr_info!`:
>
>     error: unresolved link to `pr_info`
>        --> rust/kernel/print.rs:395:63
>         |
>     395 | /// Use only when continuing a previous `pr_*!` macro (e.g. [`p=
r_info!`]).
>         |                                                               ^=
^^^^^^^ no item named `pr_info` in scope
>         |
>         =3D note: `macro_rules` named `pr_info` exists in this crate, but=
 it is not in scope at this link's location
>         =3D note: `-D rustdoc::broken-intra-doc-links` implied by `-D war=
nings`
>
> Thus do so to avoid a broken link while upgrading.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
