Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1B215BC
	for <patches@lists.linux.dev>; Mon,  3 Oct 2022 04:17:25 +0000 (UTC)
Received: by mail-ej1-f51.google.com with SMTP id f1so2111885ejw.7
        for <patches@lists.linux.dev>; Sun, 02 Oct 2022 21:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=9ksXVMaoyiezvzOT4T4fypchzJ4+YFvVGZ+lnFeb2aw=;
        b=PmCcPLFjvenmI+fhAgzbecuICa+ogZ6PoCekZGUDFtxsTMtlUe1IQcEpjv+eJNUrTv
         01Krqp8RPW56WQvJ0a+WN0uM0/ED6/U8cQuKFLtLHpe3DfWS00jq7q0l0oEbriwseYT9
         5lh+K4TjZtGgZnJ1UDQMyUjzQHCoXlz1DGxNfLM4K9fyRbwdsrOOsamNeS3m0V5n3b2v
         L3tBTF6XW5d/kJeONeDt2NGLtQ/nry1+LzizOR26iYSlPamJbMyFb4db7SnBTqkgp/lx
         fDbKOLxyaJM1x5hMFzFuxyx0I9GSbYzj5h2kQERuiB5P4gjeVfCWtrtkciRnQ8uDQ3D/
         lWfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=9ksXVMaoyiezvzOT4T4fypchzJ4+YFvVGZ+lnFeb2aw=;
        b=aYZHG9V7xWBpZ85GCccI3VF+NiPUr5JBHZvjzC/MFnCgV2Zbd6YInHQq9MlBPJ1ogw
         6g8ystBzY0Jh3EXKEUivgGOmxvJmu1oPYbmbACIkpVyxpUOmmKfUJiZLDeiJiXgqM1CN
         Sq/jOF79jKA+4z5K9kLS366G9Da5CG4N1SRQzD3AxZf2sBmvxeZYLI59PoRgW7ufLVTz
         m+/JnIxIEdXl7DEf0NtbmNdFkotdC/yKljqM2KVmOKG8heRTMS7wOoVNPkEBlkch7OdE
         7OK51FHXkcgQ+cya0AsQWZII/YOE1+B3l9EeCHFmYPQIWdHf+Kj1zA8cF1zg3EcE/EWs
         bJsA==
X-Gm-Message-State: ACrzQf058cdQgg3T44l1wYXUahgkMpdzCx8FDmlhWkMy5BrQt6QC8F7u
	EQHLUy0s+lKPpI8AyXyz0N7swQ4NQPp8CAgI66A=
X-Google-Smtp-Source: AMsMyM4r/T90ofdnX8BPaBKuYhE2KKgPtQFGoX1z3qNwVvbeza0Ga7xXP5wsWUmUh7fwNtjnCcsexYHa0f/elrKdA8Q=
X-Received: by 2002:a17:907:1c24:b0:78a:3d92:7701 with SMTP id
 nc36-20020a1709071c2400b0078a3d927701mr4516406ejc.131.1664770644115; Sun, 02
 Oct 2022 21:17:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <Yu6BXwtPZwYPIDT6@casper.infradead.org> <Yyh3kFUvt2aMh4nq@wedsonaf-dev>
 <CAHk-=wgaBaVaK2K=N05fwWSSLM6YJx=yLmP4f7j6d6o=nCAtdw@mail.gmail.com>
 <CAHk-=whTDbFZKB4KJ6=74hoLcerTm3JuN3PV8G6ktcz+Xm1qew@mail.gmail.com>
 <YyivY6WIl/ahZQqy@wedsonaf-dev> <CAHk-=whm5Ujw-yroDPZWRsHK76XxZWF1E9806jNOicVTcQC6jw@mail.gmail.com>
 <Yyjut3MHooCwzHRc@wedsonaf-dev> <CAHk-=wityPWw4YkHeMNU4iGanyiC3UwDRhbOHYCJrhB2paCGwA@mail.gmail.com>
 <CAFRnB2VPpLSMqQwFPEjZhde8+-c6LLms54QkMt+wZPjOTULESw@mail.gmail.com>
 <CAHk-=wiyD6KqZN8jFkMHPRPxrbyJEUDRP6+WaH9Q9hjDB5i1zg@mail.gmail.com> <YykMBiE3L/ADVK0f@boqun-archlinux>
In-Reply-To: <YykMBiE3L/ADVK0f@boqun-archlinux>
From: Kyle Strand <batmanaod@gmail.com>
Date: Sun, 2 Oct 2022 22:17:10 -0600
Message-ID: <CAKzwK0V_xDKJckK-E45nwX48PsAumqmiytVnSMdw51eBLwpY4w@mail.gmail.com>
Subject: Re: [PATCH v9 12/27] rust: add `kernel` crate
To: Boqun Feng <boqun.feng@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Matthew Wilcox <willy@infradead.org>, 
	Kees Cook <keescook@chromium.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Konstantin Shelekhin <k.shelekhin@yadro.com>, ojeda@kernel.org, ark.email@gmail.com, 
	bjorn3_gh@protonmail.com, bobo1239@web.de, bonifaido@gmail.com, 
	davidgow@google.com, dev@niklasmohrin.de, dsosnowski@dsosnowski.pl, 
	foxhlchen@gmail.com, gary@garyguo.net, geofft@ldpreload.com, 
	gregkh@linuxfoundation.org, jarkko@kernel.org, john.m.baublitz@gmail.com, 
	leseulartichaut@gmail.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, m.falkowski@samsung.com, me@kloenk.de, 
	milan@mdaverde.com, mjmouse9999@gmail.com, patches@lists.linux.dev, 
	rust-for-linux@vger.kernel.org, thesven73@gmail.com, viktor@v-gar.de, 
	Andreas Hindborg <andreas.hindborg@wdc.com>
Content-Type: text/plain; charset="UTF-8"

I don't know if there was ever a direct answer to this question; I was
hoping someone with more involvement in the project would jump in.

> In this early experiment stage, if something is unsafe per Rust safety
> requirements, maybe we should mark it as "unsafe"? Not because Rust
> safety needs trump kernel needs, but because we need showcases to the
> Rust langauge people the things that are not working very well in Rust
> today.
>
> I definitely agree that we CANNOT change kernel behaviors to solely
> fulfil Rust safety requirements, we (Rust-for-Linux people) should
> either find a way to check in compiler time or just mark it as "unsafe".

From the perspective of a Linux outsider, marking huge swaths of Rust
code "unsafe" doesn't actually sound incorrect to me. If a function
may exhibit undefined behavior, it's unsafe; thus, it should be marked
as such. True, you lose some of Rust's guarantees within the code
marked "unsafe", but this is what permits Rust to enforce those
guarantees elsewhere. Having lots of uses of "unsafe" in kernel code
is probably to be expected, and (in my opinion) not actually a sign
that things "are not working very well in Rust." It's not even
particularly verbose, if the callers of unsafe functions are generally
also marked "unsafe"; in these cases, only the signatures are
affected.

The last sentence of Boqun's quote above captures the intent of
"unsafe" perfectly: it simply indicates that code cannot be proven at
compile time not to exhibit undefined behavior. It's important for
systems languages to enable such code to be written, which is
precisely why Rust has the "unsafe" keyword.


On Mon, Sep 19, 2022 at 6:45 PM Boqun Feng <boqun.feng@gmail.com> wrote:
>
> On Mon, Sep 19, 2022 at 04:58:06PM -0700, Linus Torvalds wrote:
> > On Mon, Sep 19, 2022 at 4:50 PM Alex Gaynor <alex.gaynor@gmail.com> wrote:
> > >
> > > Rust's rules are that a function that's safe must not exhibit UB, no
> > > matter what arguments they're called with. This can be done with
> > > static checking or dynamic checking, with obvious trade offs between
> > > the two.
> >
> > I think you are missing just how many things are "unsafe" in certain
> > contexts and *cannot* be validated.
> >
> > This is not some kind of "a few special things".
> >
> > This is things like absolutely _anything_ that allocates memory, or
> > takes a lock, or does a number of other things.
> >
> > Those things are simply not "safe" if you hold a spinlock, or if you
> > are in a RCU read-locked region.
> >
> > And there is literally no way to check for it in certain configurations. None.
> >
> > So are you going to mark every single function that takes a mutex as
> > being "unsafe"?
> >
>
> In this early experiment stage, if something is unsafe per Rust safety
> requirements, maybe we should mark it as "unsafe"? Not because Rust
> safety needs trump kernel needs, but because we need showcases to the
> Rust langauge people the things that are not working very well in Rust
> today.
>
> I definitely agree that we CANNOT change kernel behaviors to solely
> fulfil Rust safety requirements, we (Rust-for-Linux people) should
> either find a way to check in compiler time or just mark it as "unsafe".
>
> Maybe I'm naive ;-) But keeping Rust safety requirements as they are
> helps communication with the people on the other side (Rust
> langauge/compiler): "Hey, I did everything per your safety requirements,
> and it ends like this, I'm not happy about it, could you figure out
> something helpful? After all, Rust is a *system programming" language,
> it should be able to handle things like these".
>
> Or we want to say "kernel is special, so please give me a option so that
> I don't need to worry about these UBs and deal with my real problems"?
> I don't have the first hand experience, but seems this is what we have
> been doing with C for many years. Do we want to try a new strategy? ;-)
> But perhaps it's not new, maybe it's done a few times already but didn't
> end well..
>
> Anyway, if I really want to teach Rust language/compiler people "I know
> what I'm doing, the problem is that the language is not ready". What
> should I do?
>
> Regards,
> Boqun
>
> > Or are you just going to accept and understand that "hey, exactly like
> > with integer overflows, sometimes it will be checked, and sometimes it
> > just won't be".
> >
> > Because that is literally the reality of the kernel. Sometimes you
> > WILL NOT have the checks, and you literally CANNOT have the checks.
> >
> > This is just how reality is. You don't get to choose the universe you live in.
> >
> >                   Linus
