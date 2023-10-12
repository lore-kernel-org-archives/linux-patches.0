Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FB93F4CB
	for <patches@lists.linux.dev>; Thu, 12 Oct 2023 22:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2c1ARUlh"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-9b2cee55056so256808766b.3
        for <patches@lists.linux.dev>; Thu, 12 Oct 2023 15:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697149623; x=1697754423; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cHyo9fSi27Id6LrPtS/9KH9PdJ59imXr1RZnXM53Toc=;
        b=2c1ARUlhmrRdD54YDoYEM+T/eZRcTDBqRkN+qZmENfSG0nfXhYe7i4cJxikcDHlu3w
         fC2SPwGszFMnNdQOE3lbike1/bP4SuPGfzZyzWKIQQtf4rXBjozVGMsvYvAx8y/oxH6X
         9z8rip0wMp+SXt1PNPv4zk/ghmwmPv/PCSMDQoUfqnFMthGgzMsqPMXdWRxHqVe9brSa
         tONW+NRSzoKIGS4yG/6GjCA9CUKpKhpCqb+z0M9TzBJC47hAajugbI78VBQWEFAYQ4pH
         VjeRiKRmLoT7yAkdyeLXC2pUxIlyrQB8XqqGu2N47+ErR7BKIBSEiHgBgrwlY4k+TMnH
         VXZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697149623; x=1697754423;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cHyo9fSi27Id6LrPtS/9KH9PdJ59imXr1RZnXM53Toc=;
        b=gJrsFK95nWQWAEEpu1+iGJrMWJYxkgGP40r4ELiUrKajVgID8cLTWUShilhZq5Kdt3
         xdEtwU+lFII6e5kgd0URueJPwP3OyuBLqekgQ3A13qLiI5kG0jbk8lsSe50Ry0e9Elbl
         DIrX2py0gSCeCxmAKR+e/pS0N42FIXij6BHKPZXmU4znT+pJlKgYwCwv8/+wQgEaCspU
         kSiieUgV9LLPrATb3kGZHNxhYCQDC/LYxbz84HeJwEqcQClbr14PZLAPyoThawiDce+m
         aROKVqrvHMxV+QIjG0ZWJkNrNExXXCl0qtaDOVTmQ0k7+rLAEYC9EnRLYrp6LJH7IMz2
         zb9g==
X-Gm-Message-State: AOJu0YxYmSq1/SbxFFPDX2RGzZlr+ngPKCEF4DsYjFit9I5rQcg/B+s8
	L1EKs7CAymvSgHmLfX3aUtfn7jKdMNE1aDMXvj2+dA==
X-Google-Smtp-Source: AGHT+IGD1I7+hyhaygsRIBsksA6Z/9zQPJAvNgjGjr1zN+qJjt0GOQkR8nkHht+PI3KDyCs/v0xOZqolHjxki1yoH0A=
X-Received: by 2002:a17:907:760a:b0:9bd:8bf6:887c with SMTP id
 jx10-20020a170907760a00b009bd8bf6887cmr2835890ejc.53.1697149623041; Thu, 12
 Oct 2023 15:27:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220927131518.30000-1-ojeda@kernel.org> <20220927131518.30000-26-ojeda@kernel.org>
 <Y0BfN1BdVCWssvEu@hirez.programming.kicks-ass.net> <CABCJKuenkHXtbWOLZ0_isGewxd19qkM7OcLeE2NzM6dSkXS4mQ@mail.gmail.com>
 <CANiq72k6s4=0E_AHv7FPsCQhkyxf7c-b+wUtzfjf+Spehe9Fmg@mail.gmail.com>
 <CABCJKuca0fOAs=E6LeHJiT2LOXEoPvLVKztA=u+ARcw=tbT=tw@mail.gmail.com>
 <20231012104741.GN6307@noisy.programming.kicks-ass.net> <CABCJKufEagwJ=TQnmVSK07RDjsPUt=3JGtwnK9ASmFqb7Vx8JQ@mail.gmail.com>
 <202310121130.256F581823@keescook>
In-Reply-To: <202310121130.256F581823@keescook>
From: Ramon de C Valle <rcvalle@google.com>
Date: Thu, 12 Oct 2023 15:26:51 -0700
Message-ID: <CAOcBZOQ=M7zpXTA7Ue1=2436N4=MFgKVRPmTQ1H=b1mUwJEqEQ@mail.gmail.com>
Subject: Re: [PATCH v10 25/27] x86: enable initial Rust support
To: Kees Cook <keescook@chromium.org>
Cc: Sami Tolvanen <samitolvanen@google.com>, Peter Zijlstra <peterz@infradead.org>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	patches@lists.linux.dev, Jarkko Sakkinen <jarkko@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@google.com>, 
	David Gow <davidgow@google.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 12, 2023 at 11:31=E2=80=AFAM Kees Cook <keescook@chromium.org> =
wrote:
>
> On Thu, Oct 12, 2023 at 10:50:36AM -0700, Sami Tolvanen wrote:
> > On Thu, Oct 12, 2023 at 3:47=E2=80=AFAM Peter Zijlstra <peterz@infradea=
d.org> wrote:
> > >
> > > On Fri, Oct 14, 2022 at 11:34:30AM -0700, Sami Tolvanen wrote:
> > > > On Fri, Oct 14, 2022 at 11:05 AM Miguel Ojeda
> > > > <miguel.ojeda.sandonis@gmail.com> wrote:
> > > > >
> > > > > On Tue, Oct 11, 2022 at 1:16 AM Sami Tolvanen <samitolvanen@googl=
e.com> wrote:
> > > > > >
> > > > > > Rust supports IBT with -Z cf-protection=3Dbranch, but I don't s=
ee this
> > > > > > option being enabled in the kernel yet. Cross-language CFI is g=
oing to
> > > > > > require a lot more work though because the type systems are not=
 quite
> > > > > > compatible:
> > > > > >
> > > > > > https://github.com/rust-lang/rfcs/pull/3296
> > > > >
> > > > > I have pinged Ramon de C Valle as he is the author of the RFC abo=
ve
> > > > > and implementation work too; since a month or so ago he also lead=
s the
> > > > > Exploit Mitigations Project Group in Rust.
> > > >
> > > > Thanks, Miguel. I also talked to Ramon about KCFI earlier this week
> > > > and he expressed interest in helping with rustc support for it. In =
the
> > > > meanwhile, I think we can just add a depends on !CFI_CLANG to avoid
> > > > issues here.
> > >
> > > Having just read up on the thing it looks like the KCFI thing is
> > > resolved.
> > >
> > > I'm not sure I understand most of the objections in that thread throu=
gh
> > > -- enabling CFI *will* break stuff, so what.
> > >
> > > Squashing the integer types seems a workable compromise I suppose. On=
e
> > > thing that's been floated in the past is adding a 'seed' attribute to
> > > some functions in order to distinguish functions of otherwise identic=
al
> > > signature.
> > >
> > > The Rust thing would then also need to support this attribute.
> > >
> > > Are there any concrete plans for this? It would allow, for example,
> > > to differentiate address_space_operations::swap_deactivate() from any
> > > other random function that takes only a file argument, say:
> > > locks_remove_file().
> >
> > I haven't really had time to look into it, so no concrete plans yet.
> > Adding an attribute shouldn't be terribly difficult, but Kees
> > expressed interest in automatic salting as well, which might be a more
> > involved project:
> >
> > https://github.com/ClangBuiltLinux/linux/issues/1736
>
> Automatic would be nice, but having an attribute would let us at least
> start the process manually (or apply salting from static analysis
> output, etc).

An idea would be to add something like the Rust cfi_encoding
attribute[1] and use it with something similar to the Newtype
Pattern[2], but in C[3], for aggregating function pointers that
otherwise would be aggregated in the same group in different groups.

[1]: https://doc.rust-lang.org/nightly/unstable-book/language-features/cfi-=
encoding.html
[2]: https://doc.rust-lang.org/book/ch19-04-advanced-types.html#using-the-n=
ewtype-pattern-for-type-safety-and-abstraction
[3]: Wrapping a type in a struct should achieve something similar even
without using the cfi_encoding attribute since the encoding for
structs is <length><name>, where <name> is <unscoped-name>.
