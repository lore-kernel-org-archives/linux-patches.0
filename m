Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACCA182B1
	for <patches@lists.linux.dev>; Wed, 31 May 2023 17:07:46 +0000 (UTC)
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-b9a7e639656so10336531276.0
        for <patches@lists.linux.dev>; Wed, 31 May 2023 10:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685552866; x=1688144866;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=76vg60iW/EsEINmD+Bil9N8BO8s1pVlIY0spf2KHpnw=;
        b=AqFFPdnWQgjfaEVYQJhTRCZLbnnoP1T/OuVLPkM82QjyaLFvqLZkQvnLuFiUKznvbg
         5mnVnDzBYCxL/hKfAytTdiJQOLdEgoCvVB6AsWcKlQhmLeM+4GvfhyiTSKwYPOLeHCCr
         tKsAHo6lumCftCJDl3h3MmoFksS2OV/aCzedbK+fKrjLdgkBktemgwYem72t/j5R6V2U
         dXvny0xVl+mUZs5tJWBoYgmrvu6ydBZH+L8ohdlnNwHbsfpSkJkkjqZOpjXj7C1UA6It
         YihUAZcK76QDC7mPDkjbTJd7R2xdv95bumAe3vbat6Ttu/5QCDTK70W5HCpqe9JAsNCm
         BEUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685552866; x=1688144866;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=76vg60iW/EsEINmD+Bil9N8BO8s1pVlIY0spf2KHpnw=;
        b=FiXjs78wc5DLJx4x8owbcTbiLnxNge0j8J/WlEyA2RW0MM/lWOYnFUqW8ckzDbb9it
         U1RDjGW0gtHVBx/L5p7dkzSU+PVW0HnjHJJHXcjfBfEhbCixiAXZZ7SYBAkwkpAfKAaN
         2Ulmq9HzG2Tvvscp2TcHwKqmWTN9c1jA16TdaaXPO6624rgfsd0gA8pYA3NWUhqbTP2L
         Ly6VSY/VnHZZI9qdLLR5hxUQw8eVv3+tRYMVkkeG47ZIHw4tdgGHm43Le2fffemDDl1U
         K4LeWfPfOOdPPbK5dANDuXJYP9cvUz0x2CqcmONNKHFFYf+IFqY842vQFlbsj73kwDdG
         /ZCg==
X-Gm-Message-State: AC+VfDx1rDagrqVe4ibD09NCqag4uze2kNXK24s3xMo7lfVrbmaIWzSY
	G6RS7cN2/iAGG6lopR7Co1H0pmOsoqFgAHRcEMqlKgImtykdKE4P
X-Google-Smtp-Source: ACHHUZ4uqNma9e3+EYkNu8p5+bzGEjXLgfIeVC5PLIfPRxyx/cw9q8ArFbk7Z8GRYiv9JC2uWP48jpw4dudhtW6vhuA=
X-Received: by 2002:a25:5087:0:b0:ba2:ca56:7206 with SMTP id
 e129-20020a255087000000b00ba2ca567206mr7209029ybb.17.1685552865848; Wed, 31
 May 2023 10:07:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230424081112.99890-1-benno.lossin@proton.me>
In-Reply-To: <20230424081112.99890-1-benno.lossin@proton.me>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 31 May 2023 19:07:34 +0200
Message-ID: <CANiq72=OFioNTZiVR+vBkYs2Xum6Pv14x4kwNDqxJB0utB2dyA@mail.gmail.com>
Subject: Re: [PATCH 1/4] rust: macros: fix usage of `#[allow]` in `quote!`
To: Benno Lossin <benno.lossin@proton.me>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 24, 2023 at 10:11=E2=80=AFAM Benno Lossin <benno.lossin@proton.=
me> wrote:
>
> When using `quote!` as part of an expression that was not the last one
> in a function, the `#[allow(clippy::vec_init_then_push)]` attribute
> would be present on an expression, which is not allowed.
> This patch refactors that part of the macro to use a statement instead.
>
> Signed-off-by: Benno Lossin <benno.lossin@proton.me>

Series applied to `rust-next` (with the newline added) -- thanks everyone!

Cheers,
Miguel
