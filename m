Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4D97B
	for <patches@lists.linux.dev>; Mon,  3 Oct 2022 02:04:37 +0000 (UTC)
Received: by mail-io1-f45.google.com with SMTP id z191so7145464iof.10
        for <patches@lists.linux.dev>; Sun, 02 Oct 2022 19:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date;
        bh=lbUBLwLrU+qNu9qKx+IuhKwkfyVt1vaaIOK0cPSiuDg=;
        b=HioAWnuOfe/FTNbLJL3xtog2XmNCRt3JV4vjJCHLn9bcukhXukL3J+iUzT4mRbvCYw
         cpyDCaVDR0jip5ywnHSP7OQrhxaFTe3Sogqb2uBJxP2KAE0xh8FNKiP6qD1EGmbawJeu
         psAmHfd4YryOosDz0caKncABwhAPRCHcHJh/cm1zPfp5/UxfTZNUCKuoFMsr/8Nyxopm
         yUhp3qhnczAf1rcJxUJELG3PMsepwNBL2S9a4iqXK1d21YoLKWALOIn+6QIJgg2K0aT0
         6E1TOEz118QCOMD2OXlt5GkMqsp2ggrv9wWqBvSvQd89wSbcXrFyWblKNdwv0J2bAY4u
         686Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=lbUBLwLrU+qNu9qKx+IuhKwkfyVt1vaaIOK0cPSiuDg=;
        b=3EdDkrJDWckAG3xyISnNyy6q5NuA5H9uOlRbcvzar62Q47MiHrO0r07W4y2AVwLEKp
         f6FNR0Pj2JyPPTOAG59xpSpYfFBel5De69BRz2+XiRZUEXksDj2KCj//yfznRt81khn1
         /USA/Tpq62yyDHrJMxK2ybG/c8323jOmOx9gHssByw1p1djvs4mJxOS5AYF3kLI6RIF6
         y9Z1PsYsGW+ThqaspYWIhXTIk124il+o9PAodqZcKtI/jeY/8JlmgHmnjgM9s/nh48f+
         kKg/vi4vIZyLkPmvLROufE2Wv5JRBOtto4QO3cqAdQXo+B+5YEpFMrwp2vGdg/oYGj/i
         piWQ==
X-Gm-Message-State: ACrzQf1LThC5h+wpAZaLtD9kf/Pt9q1S5Q3x3wWX4awYGfaIXV9jfqqW
	JcqqA+ETCcIA1JzGaIT5lJQ=
X-Google-Smtp-Source: AMsMyM45RfWeewKTijr68Piu9khnc2TzINnr1EIijRFvUbrW+VICxCrtRBi8yB6EXpEJycSHe42Tlg==
X-Received: by 2002:a02:a682:0:b0:34c:14fc:b490 with SMTP id j2-20020a02a682000000b0034c14fcb490mr9437006jam.196.1664762676359;
        Sun, 02 Oct 2022 19:04:36 -0700 (PDT)
Received: from smtpclient.apple ([75.104.65.53])
        by smtp.gmail.com with ESMTPSA id o21-20020a02c6b5000000b0035ada363720sm3710373jan.23.2022.10.02.19.03.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Oct 2022 19:04:35 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH v9 12/27] rust: add `kernel` crate
From: comex <comexk@gmail.com>
In-Reply-To: <YysdZIGp13ye0D4z@boqun-archlinux>
Date: Sun, 2 Oct 2022 22:03:22 -0400
Cc: Gary Guo <gary@garyguo.net>,
 "Eric W. Biederman" <ebiederm@xmission.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Alex Gaynor <alex.gaynor@gmail.com>,
 Wedson Almeida Filho <wedsonaf@gmail.com>,
 Matthew Wilcox <willy@infradead.org>,
 Kees Cook <keescook@chromium.org>,
 Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
 Konstantin Shelekhin <k.shelekhin@yadro.com>,
 ojeda@kernel.org,
 ark.email@gmail.com,
 bjorn3_gh@protonmail.com,
 bobo1239@web.de,
 bonifaido@gmail.com,
 davidgow@google.com,
 dev@niklasmohrin.de,
 dsosnowski@dsosnowski.pl,
 foxhlchen@gmail.com,
 geofft@ldpreload.com,
 gregkh@linuxfoundation.org,
 jarkko@kernel.org,
 john.m.baublitz@gmail.com,
 leseulartichaut@gmail.com,
 linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 me@kloenk.de,
 milan@mdaverde.com,
 mjmouse9999@gmail.com,
 patches@lists.linux.dev,
 rust-for-linux@vger.kernel.org,
 thesven73@gmail.com,
 viktor@v-gar.de,
 Andreas Hindborg <andreas.hindborg@wdc.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <FF630FE4-8DDB-43AE-A2B3-1708E260062A@gmail.com>
References: <YyivY6WIl/ahZQqy@wedsonaf-dev>
 <CAHk-=whm5Ujw-yroDPZWRsHK76XxZWF1E9806jNOicVTcQC6jw@mail.gmail.com>
 <Yyjut3MHooCwzHRc@wedsonaf-dev>
 <CAHk-=wityPWw4YkHeMNU4iGanyiC3UwDRhbOHYCJrhB2paCGwA@mail.gmail.com>
 <CAFRnB2VPpLSMqQwFPEjZhde8+-c6LLms54QkMt+wZPjOTULESw@mail.gmail.com>
 <CAHk-=wiyD6KqZN8jFkMHPRPxrbyJEUDRP6+WaH9Q9hjDB5i1zg@mail.gmail.com>
 <CAHk-=wj6sDFk8ZXSEKUMj-J9zfrMSSO3jhBEaveVaJSUpr=O=w@mail.gmail.com>
 <87a66uxcpc.fsf@email.froward.int.ebiederm.org>
 <20220920233947.0000345c@garyguo.net>
 <C85081E7-99CB-421F-AA3D-60326A5181EB@gmail.com>
 <YysdZIGp13ye0D4z@boqun-archlinux>
To: Boqun Feng <boqun.feng@gmail.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)


>> On the other hand, it ought to be feasible to implement that kind of
>> =E2=80=99negative reasoning' as a custom lint.  It might not work as =
well as
>> something built into the language, but it should work decently well,
>> and could serve as a prototype for a future built-in feature.
>=20
> Interesting, do you have an example somewhere?
>=20
> Regards,
> Boqun

After some searching, I found this, which someone wrote several years =
ago for a
very similar purpose:

https://github.com/thepowersgang/tag_safe/

> This is a linter designed originally for use with a kernel, where =
functions
> need to be marked as "IRQ safe" (meaning they are safe to call within =
an IRQ
> handler, and handle the case where they may interrupt themselves).

> If a function is annotated with #[req_safe(ident)] (where ident can be
> anything, and defines the type of safety) this linter will check that =
all
> functions called by that function are either annotated with the same
> annotation or #[is_safe(ident)], OR they do not call functions with =
the
> reverse #[is_unsafe(ident)] annotation.

Note that the code won't work as-is with recent rustc.  rustc's API for =
custom
lints is not stable, and in fact rustc has deprecated linter plugins =
entirely
[1], though there are alternative approaches to using custom lints [2].  =
Still,
it's a good example of the approach.

One fundamental caveat is that it doesn't seem to have the =
sophistication
needed to be sound with respect to indirect calls.

For example, suppose you have a function that fetches a callback from =
some
structure and calls it.  Whether this function is IRQ-safe depends on =
whether
the callback is expected to be IRQ-safe, so in order to safety-check =
this, you
would need an annotation on either the callback field or the function =
pointer
type.  This is more complex than just putting annotations on function
definitions.

Or suppose you have the following code:

    fn foo() {
        bar(|| do_something_not_irq_safe());
    }

If `foo` is expected to be IRQ-safe, this may or may not be sound, =
depending on
whether `bar` calls the callback immediately or saves it for later.  If =
`bar`
saves it for later, then it could be marked unconditionally IRQ-safe.  =
But if
`bar` calls it immediately, then it's neither IRQ-safe nor IRQ-unsafe, =
but
effectively generic over IRQ safety.  You could pessimistically mark it
IRQ-unsafe, but Rust has tons of basic helper methods that accept =
callbacks and
call them immediately; not being able to use any of them in an IRQ-safe =
context
would be quite limiting.

In short, a fully sound approach requires not just checking which =
functions
call which, but having some kind of integration with the type system.  =
This is
the kind of issue that I was thinking of when I said a custom lint may =
not work
as well as something built into the language.

However, I do think it's *possible* to handle it soundly from a lint,
especially if it focuses on typical use cases and relies on manual =
annotations
for the rest.  Alternately, even an unsound lint would be a good first =
step.
It wouldn't really comport with Rust's ethos of making safety guarantees
ironclad rather than heuristic, but it would serve as a good proof of =
concept
for a future language feature, while likely being helpful in practice in =
the
short term.

[1] https://github.com/rust-lang/rust/pull/64675/files
[2] =
https://www.trailofbits.com/post/write-rust-lints-without-forking-clippy
