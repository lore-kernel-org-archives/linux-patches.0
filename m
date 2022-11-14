Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FB5748D
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 16:46:17 +0000 (UTC)
Received: by mail-yb1-f181.google.com with SMTP id 7so14072419ybp.13
        for <patches@lists.linux.dev>; Mon, 14 Nov 2022 08:46:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6PDWKr1Lico+R6l9kWk21WMB4IP6L9ftmFPgT8rPDko=;
        b=SgkbCIZ0KaM/6mUz/qPDJN6WPOynC0EzEswiXIAhp2nvPH2C+AHIVkTmNuBRkTCEZd
         D9Jt5Hc6kiRV5T5gYd9VZlTdUFggkr/AKZkgj4dPhwzr9fiKnhBfiscRtrweLCqRF6PL
         e4PwmFUtsEtA5k45fYIlPMRzzpgjcmXg0libX3BB4Fr4Td+CQEwG/EDvxAGjd4qlKXqe
         P6QfLOAftwBAklHJ0EDSmmSfYQGkIk5ZWnhEGE0Em2TwBtHgbOgnq5BU+tDQD4oKKtPT
         nAVhX5H7D1AgVgg6ItVj6D9Uycu6aLKdSURb/4SUfehymHwkndbefjuJf3oCz7Sgmwy1
         lxnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6PDWKr1Lico+R6l9kWk21WMB4IP6L9ftmFPgT8rPDko=;
        b=XeYoxkFd9xQgSOukbBnBRgRj5j7XeLvQi6sX4+BS9zFcQLezVGKlFLP7cGFBWroXLa
         QgUxuRA8uhi+2KlbsedLfz4b6KIWjJ5P2HNucVXMCGMNxLeMFAmYG01FEy6t0CsjF1UG
         TtDWGu82MOkOfTlVzHOvgsn+zzUaKlzBYWux6QtqrpBsBd+domEkO3zLO4kqbT70BKax
         0dxx53GgevUMVgb4mzItc/gcQVOzEik+sD+Ugc1b9kdiWXVI4rZ5KYHDSpzksmS56IpO
         wloPfKhdEPouyUtn8RHHTb0geQQjJkuzvTISQ8H5TtUsfTNjagbneGaDHPOavKcc5Aix
         YXRg==
X-Gm-Message-State: ANoB5plLE5GBXH+Vjh7fwCuCCwjh9eeGYbxPS5ljNd4B1H3ss1/nB++2
	1FvmWR9pqumzgrl74Qg6NoJ4SCGnH3gAskOb4qo=
X-Google-Smtp-Source: AA0mqf4z1gnq/YSPfIwEXyKb6zjnFt9rolNflsgmMyDDkftPESjmz6aCvolB1Ttivp89/7uE+JKd1GOFH3lxM1kn4/g=
X-Received: by 2002:a25:8503:0:b0:6be:9368:4bcd with SMTP id
 w3-20020a258503000000b006be93684bcdmr12983927ybk.632.1668444376320; Mon, 14
 Nov 2022 08:46:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221110164152.26136-1-ojeda@kernel.org> <20221110164152.26136-8-ojeda@kernel.org>
 <Y3JU5xAGv3bNG7q2@liuwe-devbox-debian-v2>
In-Reply-To: <Y3JU5xAGv3bNG7q2@liuwe-devbox-debian-v2>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 14 Nov 2022 17:46:05 +0100
Message-ID: <CANiq72mE5=R4fv4Qee+hEkuXSHPjO3RzmOU45mqE3ztJ8XfS4A@mail.gmail.com>
Subject: Re: [PATCH v1 07/28] rust: macros: take string literals in `module!`
To: Wei Liu <wei.liu@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 14, 2022 at 3:47 PM Wei Liu <wei.liu@kernel.org> wrote:
>
> What's the rationale behind allowing UTF-8? Why not stick with ASCII
> only?

The reason is that there are already some cases on the C side.

For authors, there are about 158 non-ASCII in the kernel tree (if I
grepped correctly), e.g.:

    MODULE_AUTHOR("=E6=BC=86=E9=B9=8F=E6=8C=AF (Qi Pengzhen) <aric.pzqi@ing=
enic.com>");
    MODULE_AUTHOR("Martin Povi=C5=A1er <povik+lin@cutebit.org>");
    MODULE_AUTHOR("J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>")=
;
    MODULE_AUTHOR("Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>")=
;

There are also a few descriptions too, e.g.:

    MODULE_DESCRIPTION("NAND flash driver for OLPC CAF=C3=89 chip");
    MODULE_DESCRIPTION("NHPoly1305 =CE=B5-almost-=E2=88=86-universal hash f=
unction");

Cheers,
Miguel
