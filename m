Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB21753B4
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 12:33:21 +0000 (UTC)
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-d665467e134so3391905276.2
        for <patches@lists.linux.dev>; Mon, 21 Aug 2023 05:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692621200; x=1693226000;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TcMV5lQGmI98bFrnU90JtTBiUMBBaOFYKC9uq0wQzqQ=;
        b=CtGnDzrFXF4ikbz3/LMJBL/g5EpeOh6nCO0uLoGIrP01UWZ8oLjEBKWRnZuoDngy7X
         NPH/LPsYScIubKeTnNNX6e2lnvRBBrAlHFK3zHb+cT20O9/dXDdhvt4aHxBQds1e1Mhw
         xslpg0qeE5Vj9CuaHY/HlWw7lW82wGQwet0K3pg5fTZirwu5Ob72HAJ3QgAZcwbVa5N2
         XOSgXb3qfzZHdCITK8+tCLytj/o1dr1AUhKdHuY8VVNmmcFyR21XbyB1lZ7dQMRJ6PcG
         S8uh7OaimxwxtnaSraOhkMa9pAsj9GjoPoHLpYMkoYlEBzM32G9LMuaaoSUaF0i6r2R9
         Mm8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692621200; x=1693226000;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TcMV5lQGmI98bFrnU90JtTBiUMBBaOFYKC9uq0wQzqQ=;
        b=Wr1OCEu3gDbrZPfbc8tBObWnWIXJgTg7FfKUoNorCbSaCLk1ZKpv605JxmCBoXlAgK
         72yuy+rFu7Tm9lDXQwElaHcADS0ltypiZiZ+RwX8E1N+XXiLur5TNl2ph7dMmCutSFfu
         osNibqil0jNNdHJqSFBnKMCArmy6hy6UNenrJJW2CE8NbSN+jPP+4X2GI01riMCbp6r8
         dlHEwXQtmH09gjRSHoFdKfEz6ON/kXfz+xdx7eCZewNFprYrqwKOOpbpLuoOui8xOId9
         j9TXCBvadlmsrJ1sHehgiu55GnCZwMzCcNGDv2U0lYwmgOlX3atxojwS000++hI6WGqT
         83xg==
X-Gm-Message-State: AOJu0Yxjpc4tHaXgBJ81Nc692L1rQ0m1bb9YP85Vqf1zLe/VsBK514ST
	SLbZUAXLZVVg9Z+MK1RSU1SEuZSojslQzMGJsj4=
X-Google-Smtp-Source: AGHT+IGp9QiWZj4Ddo/semyKuYTZr8VO1JUjgMfKoXzyeNtcXUtGkEtBIfPojap0bJJIiJLCyRujKuuTz/7iy27Mecc=
X-Received: by 2002:a25:d650:0:b0:d05:96e4:b379 with SMTP id
 n77-20020a25d650000000b00d0596e4b379mr7666381ybg.56.1692621200528; Mon, 21
 Aug 2023 05:33:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230814084602.25699-1-benno.lossin@proton.me>
In-Reply-To: <20230814084602.25699-1-benno.lossin@proton.me>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 21 Aug 2023 14:33:09 +0200
Message-ID: <CANiq72kjUGmWDrjQDsZ185Pm+yKGMKZUAtgT0ykx3saZdiGxTw@mail.gmail.com>
Subject: Re: [PATCH v4 00/13] Quality of life improvements for pin-init
To: Benno Lossin <benno.lossin@proton.me>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Alice Ryhl <aliceryhl@google.com>, Andreas Hindborg <nmi@metaspace.dk>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 14, 2023 at 10:46=E2=80=AFAM Benno Lossin <benno.lossin@proton.=
me> wrote:
>
> This patch series adds several improvements to the pin-init api:
> - a derive macro for the `Zeroable` trait,
> - makes hygiene of fields in initializers behave like normal struct
>   initializers would behave,
> - prevent stackoverflow without optimizations
> - add `..Zeroable::zeroed()` syntax to zero missing fields,
> - support arbitrary paths in initializer macros.

Applied to `rust-next` with a few changes -- thanks everyone!

  - Rebased on top of `rust-next` instead of `rust-dev`, which
requires a small `use` line change due to the KUnit patches being
there back then.

  - Added an `ignore` for the `macros/lib.rs` example to avoid
breaking `rusttest`.

  - Cleaned a few trivial nits I noticed in several commits.

Cheers,
Miguel
