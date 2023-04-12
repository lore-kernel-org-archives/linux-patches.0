Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8383A935
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 22:21:57 +0000 (UTC)
Received: by mail-lj1-f172.google.com with SMTP id be27so13583175ljb.12
        for <patches@lists.linux.dev>; Wed, 12 Apr 2023 15:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681338116; x=1683930116;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TJr6AWFebjK1Coi807z+XBUR1Np+UcCq6pNM3vMGwoo=;
        b=aNuQQWmbgSMWmF1ot1asUunY9Gtyu9/w4nuwYix+fSMpVIlCplQvbcBt6ATr0gP6zy
         21wf8/gsMaOWQAoOnnfASoVsyM76miHNwFyJnme8ADMsg+1kjc4ZjN4Y+zI32F1+cr0S
         FJ1NaoY3mTLXj8jryuimEXKCWhofdVNAbvE1HwaNhJt/A2Qo5WQCZCWoBOXsxBl2jtbM
         0ROSrO9fpaBHAEUVifIfSZSNHgyHdG7OX1jzuzhlMYSvbfsjlB+MSN0j5u4+1jZDY5AG
         0GoFgVHdYQHhCtUI6fBKVbOBD/X995rGDzp7NdPDDVqg0hU/NKLfq3PGcVmBlQQmBMKl
         I1lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681338116; x=1683930116;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TJr6AWFebjK1Coi807z+XBUR1Np+UcCq6pNM3vMGwoo=;
        b=bwny4F42jupA0YFkfIs7Apw4HvGShCyeVMqTEZPIbsZXdFuFLR903s2/DNh+uxTlBX
         mXMqAnwO5kZ0+lOMy+mu6PeVjUZK1B2il5M4t6r9eh447Gq8DIDkXW3dt+s67Ap08cu7
         Z7Z+exQQCOBgXFyjNmwzvf2IWwCvLu0xNTpbCvHwUZiFitKFbS6H+CIOubNNtMvDC5Eg
         ozbZmfyvrUNeeIoAEb0hQctfnsQL1Grf1OnwTpaHpwOLO3OTwBylcRaorDCWt0ojMSpj
         +eWiWEaUzX/gsgvYlJ0GPyEp+UAHWaUp1QW+i2grZ3WQr+86VQDH4QhEq3rlV/5taF4h
         FxaA==
X-Gm-Message-State: AAQBX9ef9SHlvgqcZtbFL8NUSk83/KZUAWIQsOKNU4ZRxJIsd3TDfRkd
	NuhMflM192DkYj3pVGN/eYb4BUPkvPmwnNzuyJQ=
X-Google-Smtp-Source: AKy350ZKq0MErucl+c8u4wpRhsUOwBNFfKHT4tb97uXRU0ahEt4j/D4sUk0PdPgT82Uvx9Nus5B+BCaePsGQTAdrvu4=
X-Received: by 2002:a2e:8296:0:b0:2a7:73ce:93be with SMTP id
 y22-20020a2e8296000000b002a773ce93bemr73252ljg.9.1681338115661; Wed, 12 Apr
 2023 15:21:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230412221823.830135-1-ojeda@kernel.org>
In-Reply-To: <20230412221823.830135-1-ojeda@kernel.org>
From: Alex Gaynor <alex.gaynor@gmail.com>
Date: Wed, 12 Apr 2023 18:21:44 -0400
Message-ID: <CAFRnB2VygPYBY7MbxoftzEtqs52YG5AN_EO72Nm1ukLWnApa=Q@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add Benno Lossin as Rust reviewer
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Benno Lossin <benno.lossin@proton.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>

On Wed, Apr 12, 2023 at 6:18=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Benno has been involved with the Rust for Linux project for
> the better part of a year now. He has been working on solving
> the safe pinned initialization problem [1], which resulted in
> the pin-init API patch series [2] that allows to reduce the
> need for `unsafe` code in the kernel. He is also working on
> the field projection RFC for Rust [3] to bring pin-init as
> a language feature.
>
> His expertise with the language will be very useful to have
> around in the future if Rust grows within the kernel, thus
> add him to the `RUST` entry as reviewer.
>
> Link: https://rust-for-linux.com/the-safe-pinned-initialization-problem [=
1]
> Link: https://lore.kernel.org/rust-for-linux/20230408122429.1103522-1-y86=
-dev@protonmail.com/ [2]
> Link: https://github.com/rust-lang/rfcs/pull/3318 [3]
> Cc: Benno Lossin <benno.lossin@proton.me>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 90abe83c02f3..bf9deaa4aa5a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -18225,6 +18225,7 @@ M:      Wedson Almeida Filho <wedsonaf@gmail.com>
>  R:     Boqun Feng <boqun.feng@gmail.com>
>  R:     Gary Guo <gary@garyguo.net>
>  R:     Bj=C3=B6rn Roy Baron <bjorn3_gh@protonmail.com>
> +R:     Benno Lossin <benno.lossin@proton.me>
>  L:     rust-for-linux@vger.kernel.org
>  S:     Supported
>  W:     https://github.com/Rust-for-Linux/linux
>
> base-commit: 09a9639e56c01c7a00d6c0ca63f4c7c41abe075d
> --
> 2.40.0
>


--=20
All that is necessary for evil to succeed is for good people to do nothing.
