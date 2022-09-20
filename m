Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17107C
	for <patches@lists.linux.dev>; Tue, 20 Sep 2022 00:42:02 +0000 (UTC)
Received: by mail-wr1-f53.google.com with SMTP id n10so1682833wrw.12
        for <patches@lists.linux.dev>; Mon, 19 Sep 2022 17:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=w5NQ4eJ3AvEfMH3wO5wEmrLOkl9vV98yVIRJdzhJLL4=;
        b=maTWnfMX3eLruQcCHwEUe7zRn4VJy5C/8UxKInbLs05VBNQHYWth5cIqaK4uh9WZRn
         lufl9My/P5sxPjZ5ijNqVB9T5E4uVyAxaQDtp+KlJNnkyiCl8qp+NEnTZ20RC4fYFSKG
         dG20Tw64ScdCJrYPOMubAu2EQIZy3CILsNGFomGFblAKlSKDZge9kXlWePsvJHvb1my9
         hCo0pa2E31uH2ZHWP3GkpMqQPpE/cVVAP5m2xbreaALVi7zVS2h3PyTnHRoi6bca38e7
         4oPK0Vf3OV1Y4wcS7B48C8gk2kyZqourLMuhbAb+PFwYg6f17UC4bFsMpClQ68tefvjp
         CKig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=w5NQ4eJ3AvEfMH3wO5wEmrLOkl9vV98yVIRJdzhJLL4=;
        b=HOOvvX2iLgxvrEX1jJXZv2M14yCLS56pkDJl5O5HILCw7HzzZh9Cge45mTXWuCDZIa
         zr3ES8ED3qV4VztMPdb5tYXJ8/l/gnbVwY9a5Ls6jAio/qiEMkHs4vda3hzo7ilDfUqK
         G5oHi5ZFyUD3EKUSAMPl26nff5kNcl4OW58qZzf1D3tw9RGLon/UzVhKgnGwGabTtgFu
         bb2ThtOftkiU0IJYc5nO+BDnInAff3HMorrh0mvMubsRro5Wpd7Vz+NlCKPpqkV9pf7Z
         CEsb0opjz4ohGzE6HIe8S5SxuPjd8rBW+YHESWUf5J8JVqHDG5kTIdXGHaN8MnPCw9uD
         GNkQ==
X-Gm-Message-State: ACrzQf1S63O0hmZVotxktbSAFG94/MCszQ3dbo1NiIuiK7JRRilfe4DX
	9nhP6SFbxD0XJ4g+Zsm+sOk=
X-Google-Smtp-Source: AMsMyM65xueCHkVTZospAcdD0FJYQU96yl/tLa9PareYqdGoUoRSOBuOiZ1nMswxPPfIn22lpgwu0Q==
X-Received: by 2002:a5d:500e:0:b0:22a:44ea:dee2 with SMTP id e14-20020a5d500e000000b0022a44eadee2mr12049069wrt.325.1663634521077;
        Mon, 19 Sep 2022 17:42:01 -0700 (PDT)
Received: from wedsonaf-dev ([81.2.152.129])
        by smtp.gmail.com with ESMTPSA id bh16-20020a05600c3d1000b003b339438733sm170902wmb.19.2022.09.19.17.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 17:42:00 -0700 (PDT)
Date: Tue, 20 Sep 2022 01:41:58 +0100
From: Wedson Almeida Filho <wedsonaf@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, Kees Cook <keescook@chromium.org>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Konstantin Shelekhin <k.shelekhin@yadro.com>, ojeda@kernel.org,
	alex.gaynor@gmail.com, ark.email@gmail.com,
	bjorn3_gh@protonmail.com, bobo1239@web.de, bonifaido@gmail.com,
	boqun.feng@gmail.com, davidgow@google.com, dev@niklasmohrin.de,
	dsosnowski@dsosnowski.pl, foxhlchen@gmail.com, gary@garyguo.net,
	geofft@ldpreload.com, gregkh@linuxfoundation.org, jarkko@kernel.org,
	john.m.baublitz@gmail.com, leseulartichaut@gmail.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	m.falkowski@samsung.com, me@kloenk.de, milan@mdaverde.com,
	mjmouse9999@gmail.com, patches@lists.linux.dev,
	rust-for-linux@vger.kernel.org, thesven73@gmail.com,
	viktor@v-gar.de, Andreas Hindborg <andreas.hindborg@wdc.com>
Subject: Re: [PATCH v9 12/27] rust: add `kernel` crate
Message-ID: <YykMVoeTKO99JJPj@wedsonaf-dev>
References: <Yu5Bex9zU6KJpcEm@yadro.com>
 <CANiq72=3j2NM2kS8iw14G6MnGirb0=O6XQyCsY9vVgsZ1DfLaQ@mail.gmail.com>
 <Yu6BXwtPZwYPIDT6@casper.infradead.org>
 <Yyh3kFUvt2aMh4nq@wedsonaf-dev>
 <CAHk-=wgaBaVaK2K=N05fwWSSLM6YJx=yLmP4f7j6d6o=nCAtdw@mail.gmail.com>
 <CAHk-=whTDbFZKB4KJ6=74hoLcerTm3JuN3PV8G6ktcz+Xm1qew@mail.gmail.com>
 <YyivY6WIl/ahZQqy@wedsonaf-dev>
 <CAHk-=whm5Ujw-yroDPZWRsHK76XxZWF1E9806jNOicVTcQC6jw@mail.gmail.com>
 <Yyjut3MHooCwzHRc@wedsonaf-dev>
 <CAHk-=wityPWw4YkHeMNU4iGanyiC3UwDRhbOHYCJrhB2paCGwA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wityPWw4YkHeMNU4iGanyiC3UwDRhbOHYCJrhB2paCGwA@mail.gmail.com>

On Mon, Sep 19, 2022 at 04:39:56PM -0700, Linus Torvalds wrote:
> On Mon, Sep 19, 2022 at 3:35 PM Wedson Almeida Filho <wedsonaf@gmail.com> wrote:
> >
> > No one is talking about absolute safety guarantees. I am talking about
> > specific ones that Rust makes: these are well-documented and formally
> > defined.
> 
> If you cannot get over the fact that the kernel may have other
> requirements that trump any language standards, we really can't work
> together.
> 
> Those Rust rules may make sense in other environments. But the kernel
> really does have hard requirements that you continue to limp along
> even if some fundamental rule has been violated. Exactly because
> there's often no separate environment outside the kernel that can deal
> with it.
> 
> End result: a compiler - or language infrastructure - that says "my
> rules are so ingrained that I cannot do that" is not one that is valid
> for kernel work.
> 
> This is not really any different from the whole notion of "allocation
> failures cannot panic" that Rust people seemed to readily understand
> is a major kernel requirement, and that the kernel needed a graceful
> failure return instead of a hard panic.

I am not a programming language/compiler person. My background is in
kernel programming (Linux is not the only kernel in existence) so I have
no difficulty whatsoever with kernel requirements; the graceful handling
of allocation failures that you brought up is in fact something I added
soon after I started started working on rust-for-linux and realised (in
admittedly a bit of a shock) that userland Rust didn't have this at the
time.

> 
> Also note that the kernel is perfectly willing to say "I will use
> compiler flags that disable certain guarantees". We do it all the
> time.
> 
> For example, the C standard has a lot of "the compiler is allowed to
> make this assumption". And then we disagree with those, and so "kernel
> C" is different.
> 
> For example, the standard says that dereferencing a NULL pointer is
> undefined behavior, so a C compiler can see a dereference of a pointer
> to be a guarantee that said pointer isn't NULL, and remove any
> subsequent NULL pointer tests.
> 
> That turns out to be one of those "obviously true in a perfect world,
> but problematic in a real world with bugs", and we tell the compiler
> to not do that by passing it the '-fno-delete-null-pointer-checks'
> flag, because the compiler _depending_ on undefined behavior and
> changing code generation in the build ends up being a really bad idea
> from a security standpoint.
> 
> Now, in C, most of these kinds of things come from the C standard
> being very lax, and having much too many "this is undefined behavior"
> rules. So in almost all cases we end up saying "we want the
> well-defined implementation, not the 'strictly speaking, the language
> specs allows the compiler to do Xyz".
> 
> Rust comes from a different direction than C, and it may well be that
> we very much need some of the rules to be relaxed.

Sure. In fact, we are likely to be able to influence the Rust language
more and more quickly than C. So if things don't make sense, we may be
able to change them.

There are also opportunities here, for example, a compatible memory
model and guaranteed honouring of dependency chains for more efficient
synchronisation primitives. I'm not claiming this is surely going to
happen or that it's easy, just that there's an opportunity to do better
than C here.

> And hey, Rust people do know about "sometimes the rules have to be
> relaxed". When it comes to integer overflows etc, there's a
> "overflow-checks" flag, typically used for debug vs release builds.
> 
> The kernel has similar issues where sometimes you might want the
> strict checking (lockdep etc), and sometimes you may end up being less
> strict and miss a few rules (eg "we don't maintain a preempt count for
> this config, so we can't check RCU mode violations").
> 
> > But I won't give up on Rust guarantees just yet, I'll try to find
> > ergonomic ways to enforce them at compile time.
> 
> I think that compile-time static checking is wonderful, and as much as
> possible should be done 100% statically so that people cannot write
> incorrect programs.
> 
> But we all know that static checking is limited, and then the amount
> of dynamic checking for violations is often something that will have
> to depend on environment flags, because it may come with an exorbitant
> price in the checking.

If we can't find an ergonomic way to enforce safety guarantees, we have
fallbacks like unsafe functions or runtime enforcement. And as you
point out, if the runtime cost is too high in certain scenarios, we
do allow users to give up safety with a config as in the integer
overflow case you mentioned. We do try to minimise those.

Cheers,
-Wedson
