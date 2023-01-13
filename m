Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F99ABA57
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 23:15:32 +0000 (UTC)
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-4db05a4db9bso82539647b3.10
        for <patches@lists.linux.dev>; Fri, 13 Jan 2023 15:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ciy0ZWTd3lGR7fuS0JZR+cGtHCn30vXUtznCeqNuNtU=;
        b=P76dLekgwuMNxZPfxLDlCyL/lIIgZNjPmY8vqWnk0vw6tZRka1mEs/c8B0YbZ+vj4F
         TX5TiAAk93fQN3ebB++KENBioubOoKCEL3JihUsWc0QTwmYXioEV9h1tG67Ar3kjujNv
         Z/pIsqffFrsiSAswGddq5zo3MnHmlc4eXhaR2XkmKXUPMKeMhntx9MQ3yWXu2TGjPVI/
         7ahQSi7qmjq0c6FGW08WYmBTg15PzLqT9bk41vHUAuYM1moOM9f3s2ZKLABOaCn+5bEb
         bl7hhVRapNCFqtfbS25qUZcHq0nVJucpG0Gus9ivCPuJt3gmC3AZkJQw8ii+LiMD1Gt2
         Ef8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ciy0ZWTd3lGR7fuS0JZR+cGtHCn30vXUtznCeqNuNtU=;
        b=2mq8WTK1f20EgMitAjy5MlG9lqDST9b8lQMW3zi5g0+STo9AEOWRN22Fl3O4lpHAwz
         YyZ8o2t5k6k5zPs+4teSKsEHG52L/gbJ6NLNCQiktqJ/uZJAIX+oHdGMSuemhaiFddvo
         BDAFe63EDVDJOrWN/xRpXoiVYl3yc05WjdXdysos4CQ+hgbbq3O2uZs4j69iuqHQG5aX
         +/plWlMGUh+Q4I+LG505O7x/Lgbt90f9C8JTj+ZztRUv6S5mKfbjCU4vSuhIcU6Vs2aR
         QUF7WfVwEZ4IR7M4VX11F3t1gEMBInlV/2o8YpwS39tYQhT8uhikdf72Mtu1HCHASAjh
         lINA==
X-Gm-Message-State: AFqh2krcehOtDlkP5MztWq6Xx+Gem0o3r+SzxDdH6uKUOc1rIIkLoazs
	JH8xZHg6LsPxNTRXiYitkqAROSKfPS1kdV7fQ1k=
X-Google-Smtp-Source: AMrXdXum1Gc10mvDU+me61PfBaM5bpzVPQ2VyOympq/MwbmX4aEfLhJswzFyNI8ktuxhCAO0/ad2BGCOH77e+aAW7c0=
X-Received: by 2002:a05:690c:dc3:b0:4db:3ac0:78a3 with SMTP id
 db3-20020a05690c0dc300b004db3ac078a3mr941595ywb.266.1673651731430; Fri, 13
 Jan 2023 15:15:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230109204520.539080-1-ojeda@kernel.org> <20230109204520.539080-6-ojeda@kernel.org>
 <CAK7LNAQYk6s11MASRHW6oxtkqF00EJVqhHOP=5rynWt-QDUsXw@mail.gmail.com>
In-Reply-To: <CAK7LNAQYk6s11MASRHW6oxtkqF00EJVqhHOP=5rynWt-QDUsXw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 14 Jan 2023 00:15:20 +0100
Message-ID: <CANiq72kyUr9PGYqHTsNzYn0_cyuYA0vAxHLC08ivxKo5XvOESg@mail.gmail.com>
Subject: Re: [PATCH 6/6] kbuild: rust_is_available: normalize version matching
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, linux-kbuild@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Nicolas Schier <nicolas@fjasle.eu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 12, 2023 at 7:23 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> Maybe, your purpose is to use sed consistently, but
> perhaps you can avoid forking sed if you know the
> format of the first line.

The most unknown format would be the one of the libclang check, where
there may be other lines before the one we are interested in. However,
the pattern expansion would still match newlines, right?

> BTW, what is missing here is, you do not check if
> ${RUSTC} is really rustc.
>
> I can fool this script to print
> "arithmetic expression: expecting primary: "100000 *  + 100 *  + "

We can test if nothing was printed by `sed` for that (or do it with
shell builtins).

Having said that, I would say fooling the script on purpose is an more
of an oddity compared to the case `MAKEFLAGS` attempts to cover
(please see my reply on the other patch). So if we cover this, then I
would say we should really cover the other one.

Cheers,
Miguel
