Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA041E507
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 23:21:45 +0000 (UTC)
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-d63c0a6568fso80635276.0
        for <patches@lists.linux.dev>; Wed, 09 Aug 2023 16:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691623304; x=1692228104;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fqPhSKEhAxdN896thpE1jEBzRUIXHDDDcmy8dPclHgc=;
        b=YHpB1fM+/bsbFkErDhR9Q+L2r87uw9nADj/lA80maywU1ipSwvMdW0Y0k1MCBNT0hU
         Vcz1rrWGKw3PjIpf4qV0ai/27TeZvPzJbtIb8n+ejunzudwHGBQMUFBkyjLhI9puH4YV
         qYi2zuumU9X/ooIlMOY8S9mcC77Pkoq7e5V3U9oPBRzZdf70LGHwbDUhErClH/icDwhO
         FKeBG5KGrsCnWmfWpGOnDP0lO+bQD7ClaCs39ciIEPsFJUtMe3waiZZPjPoVUyHvEQy/
         bPQ9v/gyWCWnx7W2mASY8M1gVNnov8hT19t/o/c/rONc+5bl166nnwnG1eN/s3wJ1pvZ
         pJGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691623304; x=1692228104;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fqPhSKEhAxdN896thpE1jEBzRUIXHDDDcmy8dPclHgc=;
        b=lbnJkATBkv9GbIx3SulotkjxvbN25U4snih1ZfFs/B4UyHJhMaEzucGvZG29A8aymZ
         cPY6Klsnvj4K2rvxk5h5O0Gk92Srd8Zzu4oXk++CUE4awRQdJ41rvCuIXspdSVT9lvxk
         qxXevReIk4VnSryaQo0tdTCiAoKBxo/7tcJuDiuDAmWNuSdA31nR2Izn7knlyqBrpnMA
         nyxEn83KEGqJyMfw4MuDYKThdOA22cWLBPxkG8Dhk1DWD0WongvrnjirQEadli92XGFy
         Hl5gW3hjyNNlEEvmirSKrVHcm0cmSiQCm2Dt2wEQRnC5sQiRvHd3LJIsa0D2qeTRQYAs
         Ei1g==
X-Gm-Message-State: AOJu0Yxo6iZW+bLBebNu17e/JfPxWlxR6T8BxrgxzBwddhIJ2imZYJNy
	ui1gRfqft5P+7vxpYl/LdOuV63s4IP+i5iJFicM=
X-Google-Smtp-Source: AGHT+IFiyMa/iQ1NyMHGBxBvqSHp3vWMNVT0jkD4qUeKJs5plCuf861SCUO02G9gJm5D36GYtwWy6fs21qFzqzMa7bk=
X-Received: by 2002:a25:d206:0:b0:d1c:bb1d:238a with SMTP id
 j6-20020a25d206000000b00d1cbb1d238amr965837ybg.52.1691623304316; Wed, 09 Aug
 2023 16:21:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230614115328.2825961-1-aliceryhl@google.com>
In-Reply-To: <20230614115328.2825961-1-aliceryhl@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 10 Aug 2023 01:21:33 +0200
Message-ID: <CANiq72kVzySOqeWpK0+wn3gn-wOHUhm0TcSxdsr71eFsN3bnnA@mail.gmail.com>
Subject: Re: [PATCH] rust: make `UnsafeCell` the outer type in `Opaque`
To: Alice Ryhl <aliceryhl@google.com>
Cc: rust-for-linux@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 14, 2023 at 1:53=E2=80=AFPM Alice Ryhl <aliceryhl@google.com> w=
rote:
>
> When combining `UnsafeCell` with `MaybeUninit`, it is idiomatic to use
> `UnsafeCell` as the outer type. Intuitively, this is because a
> `MaybeUninit<T>` might not contain a `T`, but we always want the effect
> of the `UnsafeCell`, even if the inner value is uninitialized.
>
> Now, strictly speaking, this doesn't really make a difference. The
> compiler will always apply the `UnsafeCell` effect even if the inner
> value is uninitialized. But I think we should follow the convention
> here.
>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

Applied to `rust-next`, thanks everyone!

Cheers,
Miguel
