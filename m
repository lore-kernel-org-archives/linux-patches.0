Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800BD1C07
	for <patches@lists.linux.dev>; Tue, 23 Aug 2022 12:16:12 +0000 (UTC)
Received: by mail-io1-f49.google.com with SMTP id q81so3108859iod.9
        for <patches@lists.linux.dev>; Tue, 23 Aug 2022 05:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=qnlJbX7XO6SmNHU1bkg4hqymkER7fnKUTpqUuxqDC9Q=;
        b=YvkTldU56/KpYM/Q8lcjGj20r11xH73ScpVMfAJtufI/U10FglJMjHhHHXenufeP6H
         vwJF4VKfMLUOGuN/Ua9u/Pe2ldy5pEc0aOkanmbjmDEC0Fat0o9y72yF4o3KnaIuBvYX
         oox9tOffcxVjxvPm6v058yOrWSq9WziZzVJ89/og/LnYTqDPeN6o6irdH+dmnaTByX2G
         dVqo6nJhGl2YcKwW+g2mhGsbX8jcnWI3lTJuKlVci6IRshzUlRKxlIDtpx4HvS8Ggpj9
         ZWFLZKmO3B5TzTaJvbCBk7J+zga3aOc9LO6sA7oFd6sJhZXjX6qmoUIwrbaNFo7ACftp
         yMNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=qnlJbX7XO6SmNHU1bkg4hqymkER7fnKUTpqUuxqDC9Q=;
        b=Zd/tpkP81WTjegnzj3j1csjHcQJUtR9Akfpjh4tPhM7CX7KCQ/M8tMDsnZQx6GR9lG
         Wqw7sGTpuc0ZYQkPsgYkNRB6RCWK/bxL3i948hDsEa13FdirLPaLpBJU6g5WbSik7PIP
         u7mcsQ5B03wXLVo5V2O8TwxYYE8Mrxxo1M5dwWE17Mh7aTkFXqbfuvIluNAB8l671Jba
         by6PL7nnbFYJTFtzaUeVPe7DerGvtkYiiGyGgGdLvuRJGCsz9smL7o31gfxfmSfvLBgZ
         7Kn969azxyawHAvynpRjxrgqf/GC6PxYNa9pCbjk2RdiqD+wRBeLC0P9qlmYzKpwU7xa
         YzNA==
X-Gm-Message-State: ACgBeo3E682DtC0VFLnYFeFB5ATivcYk7r9OMgIQ4x4EZrR0zMkXs84J
	OGjERm+67lTlTXjWkwhpdgwF9G7QFSLARKtORJw=
X-Google-Smtp-Source: AA6agR65nLgIPp9dQRo/ThNtejGzyHMH3W7NSoUePFPp3ZDLsb4T5keII5Ok366GmAN6alr6UifMSJMIdk3AEK609RA=
X-Received: by 2002:a5d:8953:0:b0:67c:aa4c:2b79 with SMTP id
 b19-20020a5d8953000000b0067caa4c2b79mr11241778iot.172.1661256971635; Tue, 23
 Aug 2022 05:16:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220805154231.31257-1-ojeda@kernel.org> <20220805154231.31257-21-ojeda@kernel.org>
 <CAKwvOdndYxQ+KgVhC8F3vWnHDT8pD3px8cKjinu-khn25_FSYw@mail.gmail.com> <CANiq72nA0WwfnSaNxxz27iM5LXPELQVzTAQGBE30SXeLGVEf1A@mail.gmail.com>
In-Reply-To: <CANiq72nA0WwfnSaNxxz27iM5LXPELQVzTAQGBE30SXeLGVEf1A@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 23 Aug 2022 14:16:00 +0200
Message-ID: <CANiq72mZ6eiKRP59uFgPh=nV-_GavpuEM0zwPwM9BhtytmQbqw@mail.gmail.com>
Subject: Re: [PATCH v9 20/27] scripts: add `rust_is_available.sh`
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	patches@lists.linux.dev, Jarkko Sakkinen <jarkko@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@google.com>, Finn Behrens <me@kloenk.de>, 
	Miguel Cano <macanroj@gmail.com>, Tiago Lam <tiagolam@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Aug 23, 2022 at 2:12 PM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> For instance, using the test header to print the libclang version,
> this works for me:
>
>     $ bindgen scripts/rust_is_available_bindgen_libclang.h
>     ... clang version 14.0.6 (https://github.com/llvm/llvm-project.git ...
>
>     $ LIBCLANG_PATH=.../libclang-6.0.so.1 \
>       bindgen scripts/rust_is_available_bindgen_libclang.h
>     ... clang version 6.0.0 (tags/RELEASE_600/final) ...

By the way, a while ago I requested an easier way to check the
libclang version directly from bindgen, and Emilio quickly added it
(thanks a lot!): since `bindgen` 0.60.0 you can do:

    $ bindgen --version --verbose
    bindgen 0.60.0
    Clang: clang version 14.0.6 (https://github.com/llvm/ ...

Cheers,
Miguel
