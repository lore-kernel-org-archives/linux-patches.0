Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B145B946F
	for <patches@lists.linux.dev>; Thu, 20 Apr 2023 22:32:50 +0000 (UTC)
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-4ec8c2907c9so932749e87.3
        for <patches@lists.linux.dev>; Thu, 20 Apr 2023 15:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682029969; x=1684621969;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uu5fEGna14apSV36eBzrBJKSSgNGXIkFyyYc8j8im+A=;
        b=M8NzpQPDufCc/THsQ6NUHXVlCqectlkQUml+fbYe0mHFdOks/dkqlkolj90S3/lw0z
         tmpl/xt+3sQcegT2/5HKHE5EJz1Mg9l23K+YP60mBbUVx7cdf9FzhM8ghFYPOfDdCKfl
         62mZ3X8cURbQccP7odvT/uplCzdlCyHNmXbJowfu+f8Ns7htPoln35fYpZeqQqzCxG2H
         pt2Q48CyDaew2DAlrW7e5fhyZRSt1yK8jJjyGA3bNY7MTkvKvwpFIZWn7ryG+etzxse7
         jAav/T8MPS7OYJurm3tadx19fg/wvc+EbPkjGwrO2mOKBHE9cnmRqyLm1z1OWoh9xUX8
         3fTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682029969; x=1684621969;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uu5fEGna14apSV36eBzrBJKSSgNGXIkFyyYc8j8im+A=;
        b=WLXbYYWfTgVQ9flEmvgP+gkGJmD5/Hm27wJxaMmvMY40VsA/HM3UFzh1qEH1Lxf3j1
         wOfUCPmwuBglohgCgqyIfH97/WDhs+fFFcgxucesGs8v2VaV+53BYfq9nVwEtQvgQh+h
         BI41oNJ8aa+mhHgTY1IhvO+EA5XN6alu2kbHHFmsj3jo8PItJuIfhH+1982i90679lAU
         FIyb14Av2vGUOSupS9TlTgSE6l5DuHrMww3xQ6o9ujOJtVsrXHnwydGbxioG5aMyqdbN
         Vp6txFwapwrkbeafIFdD3sDLu2jDHVoY2TlEzAVqK0bnaegGU+BhFbNhA0fkeCM/sT6C
         KY4A==
X-Gm-Message-State: AAQBX9fHxAvbKRp9008IqdH2j530x8kecTonwoSNNDZmZX0zMMOkUdhg
	V/dEZcMDdvx+UZkLQHMbzK1/QuVEFOv14CuGdTw=
X-Google-Smtp-Source: AKy350YvQx5zR5xZc6+121+MdNqnfEy5eH4YDG5HCIQmBw1915BCnOfYvXxjmAJ627xWYymyLsV+CIwKOxUWVb8sgKU=
X-Received: by 2002:a05:6512:69:b0:4eb:1192:ce6f with SMTP id
 i9-20020a056512006900b004eb1192ce6fmr804371lfo.13.1682029968553; Thu, 20 Apr
 2023 15:32:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230412221823.830135-1-ojeda@kernel.org> <CAFRnB2VygPYBY7MbxoftzEtqs52YG5AN_EO72Nm1ukLWnApa=Q@mail.gmail.com>
In-Reply-To: <CAFRnB2VygPYBY7MbxoftzEtqs52YG5AN_EO72Nm1ukLWnApa=Q@mail.gmail.com>
From: Alex Gaynor <alex.gaynor@gmail.com>
Date: Thu, 20 Apr 2023 16:32:37 -0600
Message-ID: <CAFRnB2W_KSpUMJQXvzyOcR8XBUmO=Bx+hDZH_Se-QrMfyiKsgQ@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add Benno Lossin as Rust reviewer
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Benno Lossin <benno.lossin@proton.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

My previous line was incorrect. Corrected:

Reviewed-by: Alex Gaynor <alex.gaynor@gmail.com>

On Wed, Apr 12, 2023 at 4:21=E2=80=AFPM Alex Gaynor <alex.gaynor@gmail.com>=
 wrote:
>
> Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>
>
> On Wed, Apr 12, 2023 at 6:18=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> w=
rote:
> >
> > Benno has been involved with the Rust for Linux project for
> > the better part of a year now. He has been working on solving
> > the safe pinned initialization problem [1], which resulted in
> > the pin-init API patch series [2] that allows to reduce the
> > need for `unsafe` code in the kernel. He is also working on
> > the field projection RFC for Rust [3] to bring pin-init as
> > a language feature.
> >
> > His expertise with the language will be very useful to have
> > around in the future if Rust grows within the kernel, thus
> > add him to the `RUST` entry as reviewer.
> >
> > Link: https://rust-for-linux.com/the-safe-pinned-initialization-problem=
 [1]
> > Link: https://lore.kernel.org/rust-for-linux/20230408122429.1103522-1-y=
86-dev@protonmail.com/ [2]
> > Link: https://github.com/rust-lang/rfcs/pull/3318 [3]
> > Cc: Benno Lossin <benno.lossin@proton.me>
> > Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> > ---
> >  MAINTAINERS | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 90abe83c02f3..bf9deaa4aa5a 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -18225,6 +18225,7 @@ M:      Wedson Almeida Filho <wedsonaf@gmail.co=
m>
> >  R:     Boqun Feng <boqun.feng@gmail.com>
> >  R:     Gary Guo <gary@garyguo.net>
> >  R:     Bj=C3=B6rn Roy Baron <bjorn3_gh@protonmail.com>
> > +R:     Benno Lossin <benno.lossin@proton.me>
> >  L:     rust-for-linux@vger.kernel.org
> >  S:     Supported
> >  W:     https://github.com/Rust-for-Linux/linux
> >
> > base-commit: 09a9639e56c01c7a00d6c0ca63f4c7c41abe075d
> > --
> > 2.40.0
> >
>
>
> --
> All that is necessary for evil to succeed is for good people to do nothin=
g.



--=20
All that is necessary for evil to succeed is for good people to do nothing.
