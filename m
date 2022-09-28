Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6289D7B
	for <patches@lists.linux.dev>; Wed, 28 Sep 2022 12:22:48 +0000 (UTC)
Received: by mail-io1-f49.google.com with SMTP id b23so10005397iof.2
        for <patches@lists.linux.dev>; Wed, 28 Sep 2022 05:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=+CftlzZKPWUN2sMz/9pukEyU4VBPKHGAq6MB8SWaK/0=;
        b=Ma+mmZRWMI3cY+2rtc2vD7UvUtG6FzcPx201Z6UpGUCyLi+RkY0iYsvORv0o8yfEeD
         2DAgSicf1WQChtVtofrVir/bg6zGOmpx3ezwoq+B3XuWzrLF26gmFuZ3vmiT2jBu2L2w
         wIEQdLkPCdJc+8xUGG+ITU4/dDC1Bpkkk6xIBpeMTmlPKu2+642XorDYvMn41eO68f/t
         YdfaJ/L1XjIc7jtCj6QMKYRPoYcuNRZ3wTYr6cHSekAMBvuxLidvMnbDynYJJRgayd14
         cVNHwVFYwQR5lgSJ3yog5eIjsMJ9wAl+YAH4Hr8tyDqovlr9Fxi5yKq5mF3Ln5KeWBJV
         n32A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=+CftlzZKPWUN2sMz/9pukEyU4VBPKHGAq6MB8SWaK/0=;
        b=OB73J+tv2u7NOYmy24uBh5t0dTqnmUZbRqntumLzuvi/SmhsGd2APLH1oT1VfW3OPY
         +YmWityvDWf9Dsa7CTU0M6/SDa+Jj9bR96sN/oI8Rz00UgRGtW/qR6e2zv/GHEWBjk6Q
         zJ+ZsMjJ0cjov7IXbdt7OMYwZB66PxHsF7dvsscs8a0AI+SJWOQaHER+JUfVyvqm4g1L
         amJsG/oSiO6e4xcsqODA10Mh3frtvjiYDKMKNk2jJEbNdRIxa5ZDrZWNdx2YGxoxzkb3
         tH5KsQ1IM1P3VTmh74lxPVxlNGFXJ7FZIMLiDryARNpfgmXdQnYqQcHEHn622FTxm9nC
         GwQQ==
X-Gm-Message-State: ACrzQf144+uCqTfhxmK8jJQUl1HAcXNy4fvOJQFoaDEr+8CtfNE4HCm9
	tGpnNz51iu5NaUJFwCI3a/jY+eip1DorOqnWU54=
X-Google-Smtp-Source: AMsMyM53QVkbDVC1kqX3LZXbJyrpKPjUY231Eosv6bsOxvN6nIiJ9eZkEjhcIK3hKUatI4G6U3r0as4TEUXZrNcQSlw=
X-Received: by 2002:a05:6602:1509:b0:69b:35ba:4720 with SMTP id
 g9-20020a056602150900b0069b35ba4720mr14240802iow.155.1664367767433; Wed, 28
 Sep 2022 05:22:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220927131518.30000-1-ojeda@kernel.org> <20220927131518.30000-28-ojeda@kernel.org>
 <20220927141137.iovhhjufqdqcs6qn@gpm.stappers.nl> <202209270818.5BA5AA62@keescook>
 <YzMX91Kq6FzOL9g/@kroah.com> <CANiq72kyW-8Gzeex4UCMqQPCrYyPQni=8ZrRO1dQsUwDmAPedw@mail.gmail.com>
 <202209271710.6DD4B44C@keescook> <CANeycqo3O3yh2ms6vpHkzBLtT7QuCYWeweLq_z9SVygsot43YA@mail.gmail.com>
In-Reply-To: <CANeycqo3O3yh2ms6vpHkzBLtT7QuCYWeweLq_z9SVygsot43YA@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 28 Sep 2022 14:22:36 +0200
Message-ID: <CANiq72nHZSsZD4_gxOJRio-i=WCoaLm5rGnQcdi36MLjxU7+WA@mail.gmail.com>
Subject: Re: [PATCH v10 27/27] MAINTAINERS: Rust
To: Wedson Almeida Filho <wedsonaf@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Miguel Ojeda <ojeda@kernel.org>, Geert Stappers <stappers@stappers.nl>, 
	Linus Torvalds <torvalds@linux-foundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	patches@lists.linux.dev, Jarkko Sakkinen <jarkko@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Maciej Falkowski <maciej.falkowski9@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Sep 28, 2022 at 1:57 PM Wedson Almeida Filho <wedsonaf@gmail.com> wrote:
>
> Our intent wasn't to have a known-invalid email in MAINTAINERS, it was
> just my mistake: after leaving Google I updated my email in a lot of
> places but missed this one. Apologies for that.

It was also mine for not realizing it! :)

> The patch below fixes this:

Thanks Wedson!

Kees and I discussed how to proceed earlier and so I updated a few
hours ago the branch collecting the tags we got so far and fixing your
email address in `MAINTAINERS`, so it is there in `rust-next` now:

    https://github.com/Rust-for-Linux/linux/blob/fd9517a1603f083dfa88f3cf9dc67d26f6ba0ec0/MAINTAINERS#L17764

Cheers,
Miguel
