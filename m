Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762B6A20
	for <patches@lists.linux.dev>; Tue, 20 Sep 2022 00:15:47 +0000 (UTC)
Received: by mail-ej1-f51.google.com with SMTP id lc7so2556025ejb.0
        for <patches@lists.linux.dev>; Mon, 19 Sep 2022 17:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=BgWrStjazBL3noD9/vk03t6GhWMu6WHkO8oDZrwsiw4=;
        b=SJSO8IZCt0Y5kVGyIwQdueMBTnqTxxL958lu9VE+yxSsYNOU0eyCEEmnqg94jyfjNV
         KNmUMvZPN7glZM0GJC6KmElL09bXeF6IzD009CSYWLhp9dSWYCICBezT84oZ8V12JkEM
         /7eszFNQyjg/zQP3c6u5LG9DPaqw5laxsPfEw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=BgWrStjazBL3noD9/vk03t6GhWMu6WHkO8oDZrwsiw4=;
        b=XCDu8yBY8LoKH4Q8KTEJgHcmI8mtekdWa51s/nFIa2arDrq8W7tl8qPL1vdyXIyhFa
         G9+k3LjyWyisrvMwTBUrbiLphpdzcdpUIxNEDOoO4kzZ1Iv43os4pOcg1AC64xHdT/GJ
         eh4UNNAQirw2h99SIlZk3urCX6tqZs0XjWJk2FuLwbd21C54SowldxIqRmmL5F9NFnfl
         Oph3lgXnKcHAirYpThTy1aPGbiDdygqb8wclXbyEFSBpEaBpJMv4MDjgRe/0YnSidcdW
         qIcvTZZkI+3SRHG5s5QjjT+xN2tH7moN9LizmFL0nCyIHknUCC7sryV1X/skhh7Bh2J2
         sbbA==
X-Gm-Message-State: ACrzQf1roEYbEaRVskTEemBbuKWygm7IT13jLz2HCTXheOj7ibhZig9K
	JB9GQ4oVq7JaMJoJ0IBhStFrVaGq1Mbc0ux2hv4=
X-Google-Smtp-Source: AMsMyM5fd8SfOTb2rXhVLJwiONRc+BQolDEzDoKxhdAniTCf4XydOXUHloQP+lrKCXdy8Y3gt+4ChQ==
X-Received: by 2002:a17:906:65c6:b0:73c:8897:65b0 with SMTP id z6-20020a17090665c600b0073c889765b0mr15186042ejn.322.1663632944940;
        Mon, 19 Sep 2022 17:15:44 -0700 (PDT)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com. [209.85.221.54])
        by smtp.gmail.com with ESMTPSA id s20-20020a056402521400b0044ed7a75c33sm67673edd.6.2022.09.19.17.15.41
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 17:15:43 -0700 (PDT)
Received: by mail-wr1-f54.google.com with SMTP id y5so1691327wrh.3
        for <patches@lists.linux.dev>; Mon, 19 Sep 2022 17:15:41 -0700 (PDT)
X-Received: by 2002:a19:4f45:0:b0:49a:63c9:190d with SMTP id
 a5-20020a194f45000000b0049a63c9190dmr6637732lfk.61.1663632930544; Mon, 19 Sep
 2022 17:15:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220805154231.31257-13-ojeda@kernel.org> <Yu5Bex9zU6KJpcEm@yadro.com>
 <CANiq72=3j2NM2kS8iw14G6MnGirb0=O6XQyCsY9vVgsZ1DfLaQ@mail.gmail.com>
 <Yu6BXwtPZwYPIDT6@casper.infradead.org> <Yyh3kFUvt2aMh4nq@wedsonaf-dev>
 <CAHk-=wgaBaVaK2K=N05fwWSSLM6YJx=yLmP4f7j6d6o=nCAtdw@mail.gmail.com>
 <CAHk-=whTDbFZKB4KJ6=74hoLcerTm3JuN3PV8G6ktcz+Xm1qew@mail.gmail.com>
 <YyivY6WIl/ahZQqy@wedsonaf-dev> <CAHk-=whm5Ujw-yroDPZWRsHK76XxZWF1E9806jNOicVTcQC6jw@mail.gmail.com>
 <Yyjut3MHooCwzHRc@wedsonaf-dev> <CAHk-=wityPWw4YkHeMNU4iGanyiC3UwDRhbOHYCJrhB2paCGwA@mail.gmail.com>
 <CAFRnB2VPpLSMqQwFPEjZhde8+-c6LLms54QkMt+wZPjOTULESw@mail.gmail.com> <CAHk-=wiyD6KqZN8jFkMHPRPxrbyJEUDRP6+WaH9Q9hjDB5i1zg@mail.gmail.com>
In-Reply-To: <CAHk-=wiyD6KqZN8jFkMHPRPxrbyJEUDRP6+WaH9Q9hjDB5i1zg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 19 Sep 2022 17:15:13 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj6sDFk8ZXSEKUMj-J9zfrMSSO3jhBEaveVaJSUpr=O=w@mail.gmail.com>
Message-ID: <CAHk-=wj6sDFk8ZXSEKUMj-J9zfrMSSO3jhBEaveVaJSUpr=O=w@mail.gmail.com>
Subject: Re: [PATCH v9 12/27] rust: add `kernel` crate
To: Alex Gaynor <alex.gaynor@gmail.com>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Matthew Wilcox <willy@infradead.org>, 
	Kees Cook <keescook@chromium.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Konstantin Shelekhin <k.shelekhin@yadro.com>, ojeda@kernel.org, ark.email@gmail.com, 
	bjorn3_gh@protonmail.com, bobo1239@web.de, bonifaido@gmail.com, 
	boqun.feng@gmail.com, davidgow@google.com, dev@niklasmohrin.de, 
	dsosnowski@dsosnowski.pl, foxhlchen@gmail.com, gary@garyguo.net, 
	geofft@ldpreload.com, gregkh@linuxfoundation.org, jarkko@kernel.org, 
	john.m.baublitz@gmail.com, leseulartichaut@gmail.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, me@kloenk.de, 
	milan@mdaverde.com, mjmouse9999@gmail.com, patches@lists.linux.dev, 
	rust-for-linux@vger.kernel.org, thesven73@gmail.com, viktor@v-gar.de, 
	Andreas Hindborg <andreas.hindborg@wdc.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Sep 19, 2022 at 4:58 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> This is not some kind of "a few special things".
>
> This is things like absolutely _anything_ that allocates memory, or
> takes a lock, or does a number of other things.

Examples of "number of other things" ends up being things like
"accessing user memory", which depending on what you are doing may be
very common too.

And btw, it's not only about the (multiple kinds of) atomic regions.

We have other context rules in the kernel too, like "does floating
point or vector unit calculations". Which you can actually do, but
only in a kernel_fpu_begin/kernel_fpu_end region.

Now, the floating point thing is rare enough that it's probably fine
to just say "no floating point at all in Rust code".  It tends to be
very special code, so you'd write it in C or inline assembly, because
you're doing special things like using the vector unit for crypto
hashes using special CPU instructions.

                  Linus
