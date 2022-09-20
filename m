Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3469D7C
	for <patches@lists.linux.dev>; Tue, 20 Sep 2022 00:41:01 +0000 (UTC)
Received: by mail-qt1-f176.google.com with SMTP id cj27so736643qtb.7
        for <patches@lists.linux.dev>; Mon, 19 Sep 2022 17:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date;
        bh=A5JrRvFPvgTBxAfZAKAK1E/GXMmIkUYIowcl9smVVJA=;
        b=RaNUMNTVXgx/6fVL2hyD3X1EB/Wd7IOHZ/0QNP01z3mZI6+UIfN8W/rCkqtEAf9Lnt
         CXwcPDBlvdVwIpM2obbMk0biEbEI/5mb5uJSwHqKaDiw+GAeKge+Wdg42kShthTUavH7
         tiwkZoqcna5m3cYrzJt8/wHMn3mYLPXjXTUsP/QIbnL9h+5OOwIsZftRF8w3DxlrYDF3
         IlfuU+vyIDO78GOk7MM1CTKHFMfwCamPgQMQ48GUddpG1WMUJ012EtZfWcvFYUWNexs0
         y3SRwYiVEHaJr+LnmAZ/qagtRaiG27x7NUOh2e/i996adwsIAo2ZZtsAqUZonVS9ntlI
         jtPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date;
        bh=A5JrRvFPvgTBxAfZAKAK1E/GXMmIkUYIowcl9smVVJA=;
        b=KGRwJF4Vz6bHJrxP9ioTK0D6F4/cVr3226TDcKlojyYj2OjVx54WaCZbVhJHExgZGw
         vOPYSY+TQi/Q989WwLGcOUoP0yZn3LBVflM4yeN8k4C8e5GaFSIuRcnpoJxVWG7igzpA
         BTgK7Iu7ttnr4KBIJqTFNw+F3gsoQ2W39Yjq0XNomP+dO71OP4gfyg24aqXkjraApNEF
         47g/nDyqTHPb44cFE1QdgjXtssf7lU7WFDDwBvdxdh0WZ9TXFvb+Fs3bCSUyEu6sADph
         3nBkSKkfgUir6Mkwy25SWP7vRSAZgxE9Ydk2atA/EYFgiFZgH62CwlJah87C7PdRg1P4
         N1Jw==
X-Gm-Message-State: ACrzQf02h5xD/q4yEJA2JKx4YUHQdvPoVaDdjA9jLyyRnpOcqj1mG6LH
	GPuh7UKoYmq2Cj3ryB/kJB4=
X-Google-Smtp-Source: AMsMyM4pTk5E13cnJM1A2TVDqXD3X/MIa8ET3402ho4dQsYIrZ9xLMgSMJN6h2ea0GXIwziYqcVcGQ==
X-Received: by 2002:ac8:5d8b:0:b0:35b:b035:9573 with SMTP id d11-20020ac85d8b000000b0035bb0359573mr16886528qtx.632.1663634460145;
        Mon, 19 Sep 2022 17:41:00 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id ci5-20020a05622a260500b0033c36ef019esm11224361qtb.63.2022.09.19.17.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 17:40:59 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailauth.nyi.internal (Postfix) with ESMTP id 92D0127C0054;
	Mon, 19 Sep 2022 20:40:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 19 Sep 2022 20:40:58 -0400
X-ME-Sender: <xms:GQwpYxs5WoT-9xt9OpFDvYrs_j6u2TXgW4Tt8Zn57hTR3AWVNi163g>
    <xme:GQwpY6euksATrSemQrR3gjKHDp7KiveW75vQNHoU51FwpRKp-pyRjM672m4aF0YlJ
    yfyYjUiVcaKwPMy4Q>
X-ME-Received: <xmr:GQwpY0y_spK5A_ahtysOHDkV5dk8LriqJe1ouKzuNn3eZb1pOFCV-0pXeg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedvkedgfeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhu
    nhcuhfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrg
    htthgvrhhnpeehudfgudffffetuedtvdehueevledvhfelleeivedtgeeuhfegueeviedu
    ffeivdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    gsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtdei
    gedqudejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehfih
    igmhgvrdhnrghmvg
X-ME-Proxy: <xmx:GQwpY4Mn7ZQJEcsKfFhz7dIjZd9yMrBHyJqAxW8pWgDteTSfBTWeyQ>
    <xmx:GQwpYx9Jgb1DHd7CcWK_NIaebxSsWy088tvYz7x8fGn3CgWhBC1k1w>
    <xmx:GQwpY4WYOKO4NMKDKRPuy2aNTw61-N0pWhJSz0xS0KQD6wBfOhTttQ>
    <xmx:GgwpYy1kMZKpelYYzNzlJjW4i-C_7MkVIXX5ANhA4zX0zE9JOcOLiQ>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Sep 2022 20:40:56 -0400 (EDT)
Date: Mon, 19 Sep 2022 17:40:38 -0700
From: Boqun Feng <boqun.feng@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Kees Cook <keescook@chromium.org>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Konstantin Shelekhin <k.shelekhin@yadro.com>, ojeda@kernel.org,
	ark.email@gmail.com, bjorn3_gh@protonmail.com, bobo1239@web.de,
	bonifaido@gmail.com, davidgow@google.com, dev@niklasmohrin.de,
	dsosnowski@dsosnowski.pl, foxhlchen@gmail.com, gary@garyguo.net,
	geofft@ldpreload.com, gregkh@linuxfoundation.org, jarkko@kernel.org,
	john.m.baublitz@gmail.com, leseulartichaut@gmail.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	m.falkowski@samsung.com, me@kloenk.de, milan@mdaverde.com,
	mjmouse9999@gmail.com, patches@lists.linux.dev,
	rust-for-linux@vger.kernel.org, thesven73@gmail.com,
	viktor@v-gar.de, Andreas Hindborg <andreas.hindborg@wdc.com>
Subject: Re: [PATCH v9 12/27] rust: add `kernel` crate
Message-ID: <YykMBiE3L/ADVK0f@boqun-archlinux>
References: <Yu6BXwtPZwYPIDT6@casper.infradead.org>
 <Yyh3kFUvt2aMh4nq@wedsonaf-dev>
 <CAHk-=wgaBaVaK2K=N05fwWSSLM6YJx=yLmP4f7j6d6o=nCAtdw@mail.gmail.com>
 <CAHk-=whTDbFZKB4KJ6=74hoLcerTm3JuN3PV8G6ktcz+Xm1qew@mail.gmail.com>
 <YyivY6WIl/ahZQqy@wedsonaf-dev>
 <CAHk-=whm5Ujw-yroDPZWRsHK76XxZWF1E9806jNOicVTcQC6jw@mail.gmail.com>
 <Yyjut3MHooCwzHRc@wedsonaf-dev>
 <CAHk-=wityPWw4YkHeMNU4iGanyiC3UwDRhbOHYCJrhB2paCGwA@mail.gmail.com>
 <CAFRnB2VPpLSMqQwFPEjZhde8+-c6LLms54QkMt+wZPjOTULESw@mail.gmail.com>
 <CAHk-=wiyD6KqZN8jFkMHPRPxrbyJEUDRP6+WaH9Q9hjDB5i1zg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiyD6KqZN8jFkMHPRPxrbyJEUDRP6+WaH9Q9hjDB5i1zg@mail.gmail.com>

On Mon, Sep 19, 2022 at 04:58:06PM -0700, Linus Torvalds wrote:
> On Mon, Sep 19, 2022 at 4:50 PM Alex Gaynor <alex.gaynor@gmail.com> wrote:
> >
> > Rust's rules are that a function that's safe must not exhibit UB, no
> > matter what arguments they're called with. This can be done with
> > static checking or dynamic checking, with obvious trade offs between
> > the two.
> 
> I think you are missing just how many things are "unsafe" in certain
> contexts and *cannot* be validated.
> 
> This is not some kind of "a few special things".
> 
> This is things like absolutely _anything_ that allocates memory, or
> takes a lock, or does a number of other things.
> 
> Those things are simply not "safe" if you hold a spinlock, or if you
> are in a RCU read-locked region.
> 
> And there is literally no way to check for it in certain configurations. None.
> 
> So are you going to mark every single function that takes a mutex as
> being "unsafe"?
> 

In this early experiment stage, if something is unsafe per Rust safety
requirements, maybe we should mark it as "unsafe"? Not because Rust
safety needs trump kernel needs, but because we need showcases to the
Rust langauge people the things that are not working very well in Rust
today.

I definitely agree that we CANNOT change kernel behaviors to solely
fulfil Rust safety requirements, we (Rust-for-Linux people) should
either find a way to check in compiler time or just mark it as "unsafe".

Maybe I'm naive ;-) But keeping Rust safety requirements as they are
helps communication with the people on the other side (Rust
langauge/compiler): "Hey, I did everything per your safety requirements,
and it ends like this, I'm not happy about it, could you figure out
something helpful? After all, Rust is a *system programming" language,
it should be able to handle things like these".

Or we want to say "kernel is special, so please give me a option so that
I don't need to worry about these UBs and deal with my real problems"?
I don't have the first hand experience, but seems this is what we have
been doing with C for many years. Do we want to try a new strategy? ;-)
But perhaps it's not new, maybe it's done a few times already but didn't
end well..

Anyway, if I really want to teach Rust language/compiler people "I know
what I'm doing, the problem is that the language is not ready". What
should I do?

Regards,
Boqun

> Or are you just going to accept and understand that "hey, exactly like
> with integer overflows, sometimes it will be checked, and sometimes it
> just won't be".
> 
> Because that is literally the reality of the kernel. Sometimes you
> WILL NOT have the checks, and you literally CANNOT have the checks.
> 
> This is just how reality is. You don't get to choose the universe you live in.
> 
>                   Linus
