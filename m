Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FDA256C
	for <patches@lists.linux.dev>; Mon, 19 Sep 2022 20:43:14 +0000 (UTC)
Received: by mail-lj1-f173.google.com with SMTP id y14so590591ljn.7
        for <patches@lists.linux.dev>; Mon, 19 Sep 2022 13:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=axFkS9Utlog4o8yvW7z9cdhHkfxEIm+Wjlvn5hdmsPA=;
        b=Bol7xpNVdUt4dkpqIrlKRbKtSZ69qX8bFD7bM+UNptU6uew8jXanmgFFa2RaCjw/0K
         Viuw5KoW880GDkvlaepJfO1oNA6zu651EVs7nm6Ol+j+Qse3GrQl7IegVb+xVn3hyBjy
         DGilG+n8/9qEUM0E90L3OPfddms9ynHNQP4ec=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=axFkS9Utlog4o8yvW7z9cdhHkfxEIm+Wjlvn5hdmsPA=;
        b=Br9kyJtYjoCgcVY/qwrru9wXOXIYxIHdSe+CvTTzwlBvd9qrRXg6uS2C9mgS7uyjpT
         ZVoxqAQbbnBmqQQspi5MoDc54kyCh74MUVAa59kAA2cmaN9dex+zHbGqr7amWHeoIkxo
         lkRj7TWV+JpTWAN9eb1n+KZ9hGOjxBE5n6MMq1TAefac4180uXqTcsdLcODyp+2b/Ef5
         1qTjZ/k4B77EUYtPdXR8mRLJDqioVHjLfuRnHp1yJqY+ljI9vhchJ7kSmLE7aHxXxmuk
         R/QPyC62RuIhAzfdntXoJAfPaJMyU5DKwvdZv2OdrynheLoJLhPXMw7qsBR5IcA6gT/L
         dyyg==
X-Gm-Message-State: ACrzQf0WmWnsflV/8sXNNqoToR7xFvc3+Lr6XQPf7x2ELryJqCy1JVdL
	mOr4oA58pbaGSHDoXkoFIQUJCTDNZD0yUODxyEE=
X-Google-Smtp-Source: AMsMyM6XEk1cxH0xeld3EzAvp/kwpp/IuH+/1i7XVzruwcEQkMkAw48F7jP+QgfrJUd5sevF3j1cmg==
X-Received: by 2002:a2e:5357:0:b0:26a:9a92:86c2 with SMTP id t23-20020a2e5357000000b0026a9a9286c2mr5624115ljd.178.1663620192411;
        Mon, 19 Sep 2022 13:43:12 -0700 (PDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id dt6-20020a0565122a8600b004976809d6a7sm5315673lfb.283.2022.09.19.13.43.11
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 13:43:12 -0700 (PDT)
Received: by mail-lj1-f171.google.com with SMTP id y14so590510ljn.7
        for <patches@lists.linux.dev>; Mon, 19 Sep 2022 13:43:11 -0700 (PDT)
X-Received: by 2002:a2e:b4ad:0:b0:26c:24f:b260 with SMTP id
 q13-20020a2eb4ad000000b0026c024fb260mr5573619ljm.173.1663620181394; Mon, 19
 Sep 2022 13:43:01 -0700 (PDT)
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
 <CAHk-=whTDbFZKB4KJ6=74hoLcerTm3JuN3PV8G6ktcz+Xm1qew@mail.gmail.com> <YyivY6WIl/ahZQqy@wedsonaf-dev>
In-Reply-To: <YyivY6WIl/ahZQqy@wedsonaf-dev>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 19 Sep 2022 13:42:44 -0700
X-Gmail-Original-Message-ID: <CAHk-=whm5Ujw-yroDPZWRsHK76XxZWF1E9806jNOicVTcQC6jw@mail.gmail.com>
Message-ID: <CAHk-=whm5Ujw-yroDPZWRsHK76XxZWF1E9806jNOicVTcQC6jw@mail.gmail.com>
Subject: Re: [PATCH v9 12/27] rust: add `kernel` crate
To: Wedson Almeida Filho <wedsonaf@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, Kees Cook <keescook@chromium.org>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Konstantin Shelekhin <k.shelekhin@yadro.com>, ojeda@kernel.org, alex.gaynor@gmail.com, 
	ark.email@gmail.com, bjorn3_gh@protonmail.com, bobo1239@web.de, 
	bonifaido@gmail.com, boqun.feng@gmail.com, davidgow@google.com, 
	dev@niklasmohrin.de, dsosnowski@dsosnowski.pl, foxhlchen@gmail.com, 
	gary@garyguo.net, geofft@ldpreload.com, gregkh@linuxfoundation.org, 
	jarkko@kernel.org, john.m.baublitz@gmail.com, leseulartichaut@gmail.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	m.falkowski@samsung.com, me@kloenk.de, milan@mdaverde.com, 
	mjmouse9999@gmail.com, patches@lists.linux.dev, 
	rust-for-linux@vger.kernel.org, thesven73@gmail.com, viktor@v-gar.de, 
	Andreas Hindborg <andreas.hindborg@wdc.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Sep 19, 2022 at 11:05 AM Wedson Almeida Filho
<wedsonaf@gmail.com> wrote:
>
> As you know, we're trying to guarantee the absence of undefined
> behaviour for code written in Rust. And the context is _really_
> important, so important that leaving it up to comments isn't enough.

You need to realize that

 (a) reality trumps fantasy

 (b) kernel needs trump any Rust needs

And the *reality* is that there are no absolute guarantees.  Ever. The
"Rust is safe" is not some kind of absolute guarantee of code safety.
Never has been. Anybody who believes that should probably re-take
their kindergarten year, and stop believing in the Easter bunny and
Santa Claus.

Even "safe" rust code in user space will do things like panic when
things go wrong (overflows, allocation failures, etc). If you don't
realize that that is NOT some kind of true safely, I don't know what
to say.

Not completing the operation at all, is *not* really any better than
getting the wrong answer, it's only more debuggable.

In the kernel, "panic and stop" is not an option (it's actively worse
than even the wrong answer, since it's really not debugable), so the
kernel version of "panic" is "WARN_ON_ONCE()" and continue with the
wrong answer.

So this is something that I really *need* the Rust people to
understand. That whole reality of "safe" not being some absolute
thing, and the reality that the kernel side *requires* slightly
different rules than user space traditionally does.

> I don't care as much about allocation flags as I do about sleeping in an
> rcu read-side critical region. When CONFIG_PREEMPT=n, if some CPU makes
> the mistake of sleeping between rcu_read_lock()/rcu_read_unlock(), RCU
> will take that as a quiescent state, which may cause unsuspecting code
> waiting for a grace period to wake up too early and potentially free
> memory that is still in use, which is obviously undefined behaviour.

So?

You had a bug. Shit happens. We have a lot of debugging tools that
will give you a *HUGE* warning when said shit happens, including
sending automated reports to the distro maker. And then you fix the
bug.

Think of that "debugging tools give a huge warning" as being the
equivalent of std::panic in standard rust. Yes, the kernel will
continue (unless you have panic-on-warn set), because the kernel
*MUST* continue in order for that "report to upstream" to have a
chance of happening.

So it's technically a veryu different implementation from std:panic,
but you should basically see it as exactly that: a *technical*
difference, not a conceptual one. The rules for how the kernel deals
with bugs is just different, because we don't have core-files and
debuggers in the general case.

(And yes, you can have a kernel debugger, and you can just have the
WARN_ON_ONCE trigger the debugger, but think of all those billions of
devices that are in normal users hands).

And yes, in certain configurations, even those warnings will be turned
off because the state tracking isn't done. Again, that's just reality.
You don't need to use those configurations yourself if you don't like
them, but that does *NOT* mean that you get to say "nobody else gets
to use those configurations either".

Deal with it.

Or, you know, if you can't deal with the rules that the kernel
requires, then just don't do kernel programming.

Because in the end it really is that simple.  I really need you to
understand that Rust in the kernel is dependent on *kernel* rules. Not
some other random rules that exist elsewhere.

                Linus
