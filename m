Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F65E7C
	for <patches@lists.linux.dev>; Mon, 19 Sep 2022 16:10:13 +0000 (UTC)
Received: by mail-lf1-f49.google.com with SMTP id a8so47652176lff.13
        for <patches@lists.linux.dev>; Mon, 19 Sep 2022 09:10:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=klevHm3vypIn+i0yQtuh2tQgsYKrfGVP5Z+xZ4SLjKs=;
        b=ZWK6YGLx9xp+wN7U3o4oknV3d7wzEt6zdkIwvLYoMR6GHwwihBnPuQsqWLF0E32rVI
         XWrgHrqAKsnmr2hYIz4w2o0kO+dzIj3hREoT4LKrx2QhuxcShGO4Hxn/FoOHQnnOIEwa
         DOVcvZm2pyQpKKMr7N+pt2/H35QT9+OITZEH0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=klevHm3vypIn+i0yQtuh2tQgsYKrfGVP5Z+xZ4SLjKs=;
        b=RqkIZMkzuFEOTCOMpCgWABaCEdzOH1oAeJtPp2pmcyu7FZHc/hwCVRMUev53TdX0Yr
         W0nWaI50pNXTe8dfR+vrGplNAvU9DBp5OEO1SndE5yqm5Otkw4juXzMoIOxuGy/k0h9m
         IPI8Hac+Qs1zAcI/WmvUyU7iMdjZitV9UFkVYzh6bTe+JRdlQgbLshvRwU1WhHhMsoEf
         YTarqGYh5wL8m+2MsLVGFuPhpfnfNLhmkzD3UMpCbCHFS157rf5KMsRjEPf7N2410NEK
         5eT2F7gkQLmvZWD4/iO7UAHzgeomjOWynCr3sLxX9QR37h0tdQq+ZwtryLQ78nAeEEL5
         yN0w==
X-Gm-Message-State: ACrzQf3yKi/TmEiup7N80Sfb8807RP6cvKofgLAGyxZsYuXlAjymP3cz
	h03KnGUCiPWIl4/FYUpJ8XnfbeQg8RzDCXbR
X-Google-Smtp-Source: AMsMyM5Vzv4FCKCai6dR9t3aJ/oEiqN5GFdPW7YYO0/Gu/4OZMIOFOhStUK9Euf494bBmFZYlFQrNw==
X-Received: by 2002:a05:6512:3f21:b0:49f:9e1d:9dc5 with SMTP id y33-20020a0565123f2100b0049f9e1d9dc5mr2789670lfa.611.1663603809232;
        Mon, 19 Sep 2022 09:10:09 -0700 (PDT)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id r13-20020a2eb60d000000b0026c4374a2a4sm1097896ljn.139.2022.09.19.09.10.08
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 09:10:08 -0700 (PDT)
Received: by mail-lf1-f46.google.com with SMTP id j16so20695956lfg.1
        for <patches@lists.linux.dev>; Mon, 19 Sep 2022 09:10:08 -0700 (PDT)
X-Received: by 2002:a05:6512:3d16:b0:498:f04f:56cf with SMTP id
 d22-20020a0565123d1600b00498f04f56cfmr7277354lfv.612.1663603797869; Mon, 19
 Sep 2022 09:09:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220805154231.31257-13-ojeda@kernel.org> <Yu5Bex9zU6KJpcEm@yadro.com>
 <CANiq72=3j2NM2kS8iw14G6MnGirb0=O6XQyCsY9vVgsZ1DfLaQ@mail.gmail.com>
 <Yu6BXwtPZwYPIDT6@casper.infradead.org> <Yyh3kFUvt2aMh4nq@wedsonaf-dev>
In-Reply-To: <Yyh3kFUvt2aMh4nq@wedsonaf-dev>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 19 Sep 2022 09:09:40 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgaBaVaK2K=N05fwWSSLM6YJx=yLmP4f7j6d6o=nCAtdw@mail.gmail.com>
Message-ID: <CAHk-=wgaBaVaK2K=N05fwWSSLM6YJx=yLmP4f7j6d6o=nCAtdw@mail.gmail.com>
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

On Mon, Sep 19, 2022 at 7:07 AM Wedson Almeida Filho <wedsonaf@gmail.com> wrote:
>
> For GFP_ATOMIC, we could use preempt_count except that it isn't always
> enabled. Conveniently, it is already separated out into its own config.
> How do people feel about removing CONFIG_PREEMPT_COUNT and having the
> count always enabled?
>
> We would then have a way to reliably detect when we are in atomic
> context [..]

No.

First off, it's not true. There are non-preempt atomic contexts too,
like interrupts disabled etc. Can you enumerate all those? Possibly.

But more importantly, doing "depending on context, I silently and
automatically do different things" is simply WRONG. Don't do it. It's
a disaster.

Doing that for *debugging* is fine. So having a

        WARN_ON_ONCE(in_atomic_context());

is a perfectly fine debug check to find people who do bad bad things,
and we have lots of variations of that theme (ie might_sleep(), but
also things like lockdep_assert_held() and friends that assert other
constraints entirely).

But having *behavior changes* depending on context is a total
disaster. And that's invariably why people want this disgusting thing.

They want to do broken things like "I want to allocate memory, and I
don't want to care where I am, so I want the memory allocator to just
do the whole GFP_ATOMIC for me".

And that is FUNDAMENTALLY BROKEN.

If you want to allocate memory, and you don't want to care about what
context you are in, or whether you are holding spinlocks etc, then you
damn well shouldn't be doing kernel programming. Not in C, and not in
Rust.

It really is that simple. Contexts like this ("I am in a critical
region, I must not do memory allocation or use sleeping locks") is
*fundamental* to kernel programming. It has nothing to do with the
language, and everything to do with the problem space.

So don't go down this "let's have the allocator just know if you're in
an atomic context automatically" path. It's wrong. It's complete
garbage. It may generate kernel code that superficially "works", but
one that is fundamentally broken, and will fail and becaome unreliable
under memory pressure.

The thing is, when you do kernel programming, and you're holding a
spinlock and need to allocate memory, you generally shouldn't allocate
memory at all, you should go "Oh, maybe I need to do the allocation
*before* getting the lock".

And it's not just locks. It's also "I'm in a hardware interrupt", but
now the solution is fundamentally different. Maybe you still want to
do pre-allocation, but now you're a driver interrupt and the
pre-allocation has to happen in another code sequence entirely,
because obviously the interrupt itself is asynchronous.

But more commonly, you just want to use GFP_ATOMIC, and go "ok, I know
the VM layer tries to keep a _limited_ set of pre-allocated buffers
around".

But it needs to be explicit, because that GFP_ATOMIC pool of
allocations really is very limited, and you as the allocator need to
make it *explicit* that yeah, now you're not just doing a random
allocation, you are doing one of these *special* allocations that will
eat into that very limited global pool of allocations.

So no, you cannot and MUST NOT have an allocator that silently just
dips into that special pool, without the user being aware or
requesting it.

That really is very very fundamental. Allocators that "just work" in
different contexts are broken garbage within the context of a kernel.

Please just accept this, and really *internalize* it.  Because this
isn't actually just about allocators. Allocators may be one very
common special case of this kind of issue, and they come up quite
often as a result, but this whole "your code needs to *understand* the
special restrictions that the kernel is under" is something that is
quite fundamental in general.

It shows up in various other situations too, like "Oh, this code can
run in an interrupt handler" (which is *different* from the atomicity
of just "while holding a lock", because it implies a level of random
nesting that is very relevant for locking).

Or sometimes it's subtler things than just correctness, ie "I'm
running under a critical lock, so I must be very careful because there
are scalability issues". The code may *work* just fine, but things
like tasklist_lock are very very special.

So embrace that kernel requirement. Kernels are special. We do things,
and we have constraints that pretty much no other environment has.

It is often what makes kernel programming interesting - because it's
challenging. We have a very limited stack. We have some very direct
and deep interactions with the CPU, with things like IO and
interrupts. Some constraints are always there, and others are
context-dependent.

The whole "really know what context this code is running within" is
really important. You may want to write very explicit comments about
it.

And you definitely should always write your code knowing about it.

              Linus
