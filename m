Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B145C6FD9
	for <patches@lists.linux.dev>; Wed,  2 Aug 2023 17:37:33 +0000 (UTC)
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-d05a63946e0so57059276.1
        for <patches@lists.linux.dev>; Wed, 02 Aug 2023 10:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690997852; x=1691602652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cWhqiuP44YcPPmHT2vtf0tx+jxKs6e8QElNN/SdMb8g=;
        b=d8YUDFp4xGGHKlKo4qxm10TFjBfG5za+jCOGSSZfc4uigmwcE7fawwWjhKPlAddKjl
         kxyqnjhCXDS5WrHv9b8Vwk8g0k82CLk/p3rIYxAktSX5QpV2YVLCqQFw3SZIezG03R3h
         gufN0IDwJlaDaSYToXk5wZHGVgkDOJ/BMss+kP069FWUiyQkSO9BT9oMFLkEVTsJuTGz
         6KIrCAiSMtSG6Xs+5b247hYTuFsjUwfoMXe7GLosBZXp/9b7UrB7scEPca4B/xqfNhRn
         186/kPTqAVq+JeJwJ0ERGkOVYBazGmg143nD8//bPjg6Pe1wQVUCt10OuBxu2eW6cLDL
         dayA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690997852; x=1691602652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cWhqiuP44YcPPmHT2vtf0tx+jxKs6e8QElNN/SdMb8g=;
        b=jZANjvx6QFt/qKfUH85PD7j8kKkU+/mzRVU10bxLxQu/30atUXf6ZjV+q9CZaCFh0M
         hugqedf6eSJaNGlRVCEydIJLpqRRgr/LXbssEo+WR35c85mwd+nq4cAsRqKPAKBbpaAU
         /PDsphu/UwGh6Vvp1I0wbismkS4r7XuMnPnXLqdH5QMchZgLMRPLSSDjBstr6bgxmBjc
         3Pzc6phc4QFPQEUcwqC/KtQpzuT1N7ibnPcis3sbLg+zoOrNvBjD26kvEWbLAvAJPNBj
         asUgOZr0jHNJ79bdh/QgnlwZurEnTyg/DKhl4qH+5HSVh/Zl7p/rQsfB/gz9UPNjc0Hs
         Ydow==
X-Gm-Message-State: ABy/qLbzCltKP3XOaa0+/drKPTn1Kl1uTVhBG9DNfEJYJGAwTq4RbubU
	IeUkEH4v2r7uYxezpt4JXUC+1BEb9x36DsITEg4=
X-Google-Smtp-Source: APBJJlFG7pGYvNOa2exsr6kzC1NMZtwy3KV9/KAnI0deA9i0OtvGsSvpUpgk4SkO4gsMReHE0IEf7vnukdCNIwdMqoA=
X-Received: by 2002:a25:ac2:0:b0:d0a:353b:b939 with SMTP id
 185-20020a250ac2000000b00d0a353bb939mr12886281ybk.52.1690997852583; Wed, 02
 Aug 2023 10:37:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230706094615.3080784-1-aliceryhl@google.com>
In-Reply-To: <20230706094615.3080784-1-aliceryhl@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 2 Aug 2023 19:37:21 +0200
Message-ID: <CANiq72=cT_f90GJkaRq_rBKYMnruSf87UVKSX0TBbNWETYya_g@mail.gmail.com>
Subject: Re: [PATCH] rust: delete `ForeignOwnable::borrow_mut`
To: Alice Ryhl <aliceryhl@google.com>
Cc: rust-for-linux@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 6, 2023 at 11:46=E2=80=AFAM Alice Ryhl <aliceryhl@google.com> w=
rote:
>
> We discovered that the current design of `borrow_mut` is problematic.
> This patch removes it until a better solution can be found.
>
> Specifically, the current design gives you access to a `&mut T`, which
> lets you change where the `ForeignOwnable` points (e.g., with
> `core::mem::swap`). No upcoming user of this API intended to make that
> possible, making all of them unsound.
>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

Applied to `rust-fixes`, thanks! I added a `Fixes` tag.

Cheers,
Miguel
