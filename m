Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DE6A31
	for <patches@lists.linux.dev>; Mon, 19 Sep 2022 23:40:29 +0000 (UTC)
Received: by mail-lf1-f47.google.com with SMTP id u18so1017978lfo.8
        for <patches@lists.linux.dev>; Mon, 19 Sep 2022 16:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=NXzXxlM9sVEFzc66soX0I+Z/mq5m2rg9T8SoVpFvUT4=;
        b=NsywTCeY9sd40b/41h2okvpTgyG2TSi3t/dg5pbH/L3beDvVkydnABPeMyhFxfDIgt
         4OZkJs8sPvCO28LEtRRl+3W+3YNo6DLVmNhyIyLg+6fJ8XdVP3Pw424Mqr/64OBW8YJx
         KH623RdzusneU5G9sBz+JF5PMau1u0ftV/Lbg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=NXzXxlM9sVEFzc66soX0I+Z/mq5m2rg9T8SoVpFvUT4=;
        b=R6k+tWRgI+blfHP0cxZW4qeYuf0zOTcCcIJSgNDvW9iDFJME4AApZS6ecgceLrB2lY
         3gSm33h8bBoiJRa5Rgqxbbo/hly6SevmPh6xnfaaka1mojb8RYEpT5y2j/Jm67F4qNoz
         vYtvVGuHzz4KxwIz1SL9v7KJtdEtDjmVFbitRGX8ll5Mi9VKc0J71kXCpQxTT0toGKm4
         Zfl0tQsOZYtj8rcHHI4PDOd24TYRYRjgryJY2PsseKmUfRc7AYgyRjOthibEGpi9EKnK
         YJPObOSKPf8yxXU1bL11fN2/qqturjNFul0FAZplhnYRVRDA+uGOFZbohYS3TPMAgXTb
         4saA==
X-Gm-Message-State: ACrzQf2uH7qwg5sPZop61vK3bRBnE8wZirdNY8FZXGYRARFhgp5wpOEA
	/QtXidgYLfrtojWutqs5+zAJDbq0zR6g2wQgb7A=
X-Google-Smtp-Source: AMsMyM7qf1FNcyodqBOEenK8s4S0Zm4fFjcNGSpQ6n84qiACGnve03crxyi7c7RSVOzKYH2msJsUSA==
X-Received: by 2002:a05:6512:1153:b0:49e:805:b473 with SMTP id m19-20020a056512115300b0049e0805b473mr7121290lfg.450.1663630826623;
        Mon, 19 Sep 2022 16:40:26 -0700 (PDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id p14-20020a2e93ce000000b0026c446918acsm1228246ljh.134.2022.09.19.16.40.24
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 16:40:24 -0700 (PDT)
Received: by mail-lf1-f45.google.com with SMTP id x27so1130504lfu.0
        for <patches@lists.linux.dev>; Mon, 19 Sep 2022 16:40:24 -0700 (PDT)
X-Received: by 2002:a2e:9886:0:b0:26c:57d9:10c6 with SMTP id
 b6-20020a2e9886000000b0026c57d910c6mr778573ljj.309.1663630813877; Mon, 19 Sep
 2022 16:40:13 -0700 (PDT)
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
 <Yyjut3MHooCwzHRc@wedsonaf-dev>
In-Reply-To: <Yyjut3MHooCwzHRc@wedsonaf-dev>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 19 Sep 2022 16:39:56 -0700
X-Gmail-Original-Message-ID: <CAHk-=wityPWw4YkHeMNU4iGanyiC3UwDRhbOHYCJrhB2paCGwA@mail.gmail.com>
Message-ID: <CAHk-=wityPWw4YkHeMNU4iGanyiC3UwDRhbOHYCJrhB2paCGwA@mail.gmail.com>
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

On Mon, Sep 19, 2022 at 3:35 PM Wedson Almeida Filho <wedsonaf@gmail.com> wrote:
>
> No one is talking about absolute safety guarantees. I am talking about
> specific ones that Rust makes: these are well-documented and formally
> defined.

If you cannot get over the fact that the kernel may have other
requirements that trump any language standards, we really can't work
together.

Those Rust rules may make sense in other environments. But the kernel
really does have hard requirements that you continue to limp along
even if some fundamental rule has been violated. Exactly because
there's often no separate environment outside the kernel that can deal
with it.

End result: a compiler - or language infrastructure - that says "my
rules are so ingrained that I cannot do that" is not one that is valid
for kernel work.

This is not really any different from the whole notion of "allocation
failures cannot panic" that Rust people seemed to readily understand
is a major kernel requirement, and that the kernel needed a graceful
failure return instead of a hard panic.

Also note that the kernel is perfectly willing to say "I will use
compiler flags that disable certain guarantees". We do it all the
time.

For example, the C standard has a lot of "the compiler is allowed to
make this assumption". And then we disagree with those, and so "kernel
C" is different.

For example, the standard says that dereferencing a NULL pointer is
undefined behavior, so a C compiler can see a dereference of a pointer
to be a guarantee that said pointer isn't NULL, and remove any
subsequent NULL pointer tests.

That turns out to be one of those "obviously true in a perfect world,
but problematic in a real world with bugs", and we tell the compiler
to not do that by passing it the '-fno-delete-null-pointer-checks'
flag, because the compiler _depending_ on undefined behavior and
changing code generation in the build ends up being a really bad idea
from a security standpoint.

Now, in C, most of these kinds of things come from the C standard
being very lax, and having much too many "this is undefined behavior"
rules. So in almost all cases we end up saying "we want the
well-defined implementation, not the 'strictly speaking, the language
specs allows the compiler to do Xyz".

Rust comes from a different direction than C, and it may well be that
we very much need some of the rules to be relaxed.

And hey, Rust people do know about "sometimes the rules have to be
relaxed". When it comes to integer overflows etc, there's a
"overflow-checks" flag, typically used for debug vs release builds.

The kernel has similar issues where sometimes you might want the
strict checking (lockdep etc), and sometimes you may end up being less
strict and miss a few rules (eg "we don't maintain a preempt count for
this config, so we can't check RCU mode violations").

> But I won't give up on Rust guarantees just yet, I'll try to find
> ergonomic ways to enforce them at compile time.

I think that compile-time static checking is wonderful, and as much as
possible should be done 100% statically so that people cannot write
incorrect programs.

But we all know that static checking is limited, and then the amount
of dynamic checking for violations is often something that will have
to depend on environment flags, because it may come with an exorbitant
price in the checking.

Exactly like integer overflow checking.

                 Linus
