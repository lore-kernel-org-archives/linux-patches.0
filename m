Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5063A2FA3C
	for <patches@lists.linux.dev>; Thu, 20 Jul 2023 17:30:07 +0000 (UTC)
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-c84fd44593aso969416276.0
        for <patches@lists.linux.dev>; Thu, 20 Jul 2023 10:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689874206; x=1690479006;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SCJQ65+7aQZac8L3veadNqaoOqxg9236xCtIGRaxWKA=;
        b=Vy0VLb8pBIRmkm/OCgFwCyVIHkdJkylVc+Hzceus7ZHA7wAZiPd1yx84YA+isdig02
         n9d9fo6a3ztiX81rtlbE20h6PR9YIXVXeKpFms6fadk9pnq9odSijinC8O/JL+qCQSfR
         GbXl9Jh2DBWBEY55CWGUmif9q5enGEF9UAZTNBxb43g2mc6d5RHI96pDNXMsBClswwcF
         gOxagc+I8oyWGwbWwVm7aPra4KhexdMQ+m4We2YQOKcTOuQD3JPKt9EsLzSa5hmW6mZh
         jetcV+WhXoikm5YfxU5IUZOjB0KTBO4K9rCS0l+KV/TWbY4eENQVyaYl7r7yjZpuOK+X
         TbwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689874206; x=1690479006;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SCJQ65+7aQZac8L3veadNqaoOqxg9236xCtIGRaxWKA=;
        b=F4Nu5ezYDh/KOIkcYQpIJhc37WIkjvwUXooHE+BR4AcDAHw62uztwzpQ3nLakMOlTw
         nL7RMK57ANUysBA3StxTy6wpfgTV+UcY6p2YzBTbzj9eNqo1WCyMgDQ9zwPwPldY9rw6
         Y0S7C5JUdZyEi3W014qU/O5vR7yeRFAK8EM30Xw/Ef1DlOf7cvusTH3MvIOihsR6gFAu
         zyMXKBIMUizDKTS4R6haUXhY1jO4E0LdvmcTEFhHGi3im0YYgc4esA+ExERo6x2yri3C
         gkqTKdFtZhcoKRrmnowflakLc6tO51+QVsN0Bg6L1y8dj+r3otwfw6mKxLvfJbVtqgkY
         ZfiA==
X-Gm-Message-State: ABy/qLa95Gd0znEirOI82WxqPr31DYofnVcl1p75jk2/qH9USnXtNvOg
	NdC1pT6UECwbVzG1B0NEXaaNMtBCaGPhjN8Frj4=
X-Google-Smtp-Source: APBJJlHbTOValRmB/GshYtHb4Ajg/BgY2O7fJVdJ6AqgyDWmi+wB4sVPiYYN+prjLl1boydok0lSDcaStxx1GIZ4igs=
X-Received: by 2002:a25:910:0:b0:ce7:ee46:debd with SMTP id
 16-20020a250910000000b00ce7ee46debdmr2953145ybj.16.1689874206039; Thu, 20 Jul
 2023 10:30:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230718055235.1050223-1-ojeda@kernel.org> <CAK7LNAQ-hjW_19fjA+E-bQCrXcVPdN4-GvzAnEnYzna5KRVXew@mail.gmail.com>
In-Reply-To: <CAK7LNAQ-hjW_19fjA+E-bQCrXcVPdN4-GvzAnEnYzna5KRVXew@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 20 Jul 2023 19:29:55 +0200
Message-ID: <CANiq72kZjOGvRKoRxtgG=2DhJnMJK9TCQtTmeef_B=nLcLQD6g@mail.gmail.com>
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

On Thu, Jul 20, 2023 at 7:18=E2=80=AFPM Masahiro Yamada <masahiroy@kernel.o=
rg> wrote:
>
> Applied to linux-kbuild/fixes. Thanks.
>
> I believe this is a fix, so I will include it
> in my next pull request.

Thanks Masahiro! Yeah, it can be considered a fix. By the way, in case you =
want:

    Fixes: 2f7ab1267dc9 ("Kbuild: add Rust support")

I guess it can be also considered a feature (e.g. "supporting more
setups"), but having the temporaries created where they were was
unintentional.

Cheers,
Miguel
