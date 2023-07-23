Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C2A17F8
	for <patches@lists.linux.dev>; Sun, 23 Jul 2023 14:27:54 +0000 (UTC)
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-bff89873d34so2748396276.2
        for <patches@lists.linux.dev>; Sun, 23 Jul 2023 07:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690122473; x=1690727273;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HFiEDMhSpzLopPoOlxDs4RsXxTglhVRYk9wnNiaoU+k=;
        b=MgzRVzh3ZoIlTtu5Rl8dFU+0y9ZM5ybnecxFcj1xrbAagKWs2YTjOedKvokIU9O7Oh
         crpfbGyfIsl2XhsK4jzXExTAZlCnT+wopexNXvLs4MdR4UehZr3wQ21yBVIchbZNlleV
         jVIPiXuX0rkExO+zzR5jybEwV2/EaXmQmztjEWZy3bhQ8FzlpYpzYHmM8uIVDUE2ksxY
         n5mJy/OSuNCqKm0F5zWNS/6idr1cOnfz8U1/QS9gOZQDWE27+Yxa9hrO7fa6PN6InsBQ
         m0g3ylDXHUi4MEGEJD1dzKQWkkGEjXApzfRtJ/vVWaDahvjRgiwsxhxdaJv5Y7yqxb7f
         zf0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690122473; x=1690727273;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HFiEDMhSpzLopPoOlxDs4RsXxTglhVRYk9wnNiaoU+k=;
        b=VL3lOpvceU2JyvxhRTD0iJfu3iN8pq8gw9s7/GbhfSIzAaaqtzr5RLw4vNhapXRRJ5
         eEZSG3MxtvEwFG6YH/LukuvRvVac/hLFnf8BzjFGWKrN6jxoEWs51LbN8Uir3QhJrQOD
         48AJl8DH8kjIBIXS6Qx4qAI2wFXSsOkIAWrx20J7R5dA6q87vQzNUib/tf1aCsJgv4tO
         zLWjJyaCD5JZZgPL9NYd85OKoSDogHIjMNW6lU3BzaikqzsKNiYy764qZDL3HljpgCfL
         U24hiO9Ghe1tL+gRo5PE86yViK/AbmrXJFtU53yQP6UvyjYDA8t7rJRxXP0AZVKEut+H
         0D6g==
X-Gm-Message-State: ABy/qLYZTRMf3Iej8hkciF8dqqWggOZ2Zv8dwiLjw4Iq++rlY46ybRnC
	Ql+cSOWFWLsliMPxXjFU9g2x2DBBBaGwozxLcfc=
X-Google-Smtp-Source: APBJJlHKjY4S91COs3SvmMr8xgjcPvakjvQDa3/QiQBlB6ZxUeFGQ6i9syJCna6ZBeQXdxliBsCVBQFatVghbOFa5Po=
X-Received: by 2002:a5b:c6:0:b0:c5d:1407:f2bc with SMTP id d6-20020a5b00c6000000b00c5d1407f2bcmr4649024ybp.17.1690122473065;
 Sun, 23 Jul 2023 07:27:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230718055235.1050223-1-ojeda@kernel.org> <CAK7LNAQ-hjW_19fjA+E-bQCrXcVPdN4-GvzAnEnYzna5KRVXew@mail.gmail.com>
 <CANiq72kZjOGvRKoRxtgG=2DhJnMJK9TCQtTmeef_B=nLcLQD6g@mail.gmail.com>
 <CAK7LNASqumGb0xvSa8n4Heasz9BKxgk4mvzNXsfFhZE1G+Bxbg@mail.gmail.com>
 <CANiq72kD2wxXy2ri8sBhVJ4y-JJiq+kYt_MRZwuwB9uGkX-_jQ@mail.gmail.com> <CAK7LNARm1LevTQVw1j5pQjp_gP=6-4CiwXLRDXbVH3bnC0OCxg@mail.gmail.com>
In-Reply-To: <CAK7LNARm1LevTQVw1j5pQjp_gP=6-4CiwXLRDXbVH3bnC0OCxg@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 23 Jul 2023 16:27:41 +0200
Message-ID: <CANiq72m0ZnVNj5p8LApsBJO2NWZ2-wnr4hdP6qhgkvBnLdXWsQ@mail.gmail.com>
Subject: Re: [PATCH] kbuild: rust: avoid creating temporary files
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Nicolas Schier <nicolas@fjasle.eu>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>, 
	Andreas Hindborg <a.hindborg@samsung.com>, linux-kbuild@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Raphael Nestler <raphael.nestler@gmail.com>, 
	Andrea Righi <andrea.righi@canonical.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 23, 2023 at 7:06=E2=80=AFAM Masahiro Yamada <masahiroy@kernel.o=
rg> wrote:
>
> Can you send v2 with the following squashed?
>
> I think it makes sense to fix both if we add
> Fixes: 295d8398c67e ("kbuild: specify output names separately for each
> emission type from rustc")

Both done [1] -- I marked the `Tested-by`s with "# non-hostprogs" to avoid
losing the tags.

Thanks!

[1] https://lore.kernel.org/rust-for-linux/20230723142128.194339-1-ojeda@ke=
rnel.org/

Cheers,
Miguel
