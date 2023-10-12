Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11D32AB53
	for <patches@lists.linux.dev>; Thu, 12 Oct 2023 17:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i27mmqYz"
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-7b636ee2b38so543739241.0
        for <patches@lists.linux.dev>; Thu, 12 Oct 2023 10:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697133073; x=1697737873; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R/kcvd3Ium4zd9I0dnayawEHaM8pcXlmWMrCCjUShbo=;
        b=i27mmqYzqacDC2r+q4we1/gcD3iBw+/7Lr4PUurYxzg+BsRM99HJ50hv4aQuJYZAt/
         pZI88Lix7ZchVsacenE0nkMSIz9gioQ3AdFR4ym2wKCvl2xjxav/5zFRLqME40lgF6rB
         CPpHMM4TwEZAodjGeUt2F073BK+q8A+WQRl3SEaxPWjFQGum9Fdzih8ZI6vftkJRUYyO
         wVwqvBixM5HM1mztot+dv1kzZo6F1jX62uLD576sXKTVmyCNmjR3i6RbmF5PmPNwiQ73
         P7JdTmfWfYETB1Des65QEc8NRFDB0U/Z6ChJmHXyj2/grwJmybLFAmgUiImLIhJ2tUIJ
         JMIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697133073; x=1697737873;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R/kcvd3Ium4zd9I0dnayawEHaM8pcXlmWMrCCjUShbo=;
        b=fLsNfnQk9yS+biM7zNvb5MGtRSdV4uufVDlBCBdRZ7RG45DmRFTy3jBuBKiCZecmO1
         KIpnCE7/ShwMa2ovjTmM/JHV7EazB1UfIcpIx+CQEe+diPhU18Zj8UZG8tpBlm2Ckxt6
         myDazxmi9lvFs2l1r/QVvIVPrPACTP2NGUKciOHAy+gVG3mP75VoJ7GkZfGjUwDsMwPt
         1qZblP+v7nhvk3iBeOpRIHmIxQhIDPjATEG8FOQOfXjzCZQj1FCQPoyjC8KfKvvFL+EX
         KEXtngSXOucpDj7zYy5oFAcihnrvpGroSvHywCVe9LAOgxAIX/buAgducVNcW5p1UL5/
         qZMQ==
X-Gm-Message-State: AOJu0YxAecITS4m2OHV9bP4mPH5gAQ+75vaZunGvBcJj8+wR2C/VcP6D
	J2q8wJ4f8N2Z1FbexZwJuygSddtIkRGrXRGi/TOIPA==
X-Google-Smtp-Source: AGHT+IFBDsg58VP5xYZQboRt0WLteQXM1skYg3czfbQs8hc1QGVa/ZbStRHvWCw3FQEgq8wuA3BSiMYUfa0Ix7/fOAY=
X-Received: by 2002:a05:6102:579b:b0:452:6d82:56e3 with SMTP id
 dh27-20020a056102579b00b004526d8256e3mr13976905vsb.6.1697133072474; Thu, 12
 Oct 2023 10:51:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220927131518.30000-1-ojeda@kernel.org> <20220927131518.30000-26-ojeda@kernel.org>
 <Y0BfN1BdVCWssvEu@hirez.programming.kicks-ass.net> <CABCJKuenkHXtbWOLZ0_isGewxd19qkM7OcLeE2NzM6dSkXS4mQ@mail.gmail.com>
 <CANiq72k6s4=0E_AHv7FPsCQhkyxf7c-b+wUtzfjf+Spehe9Fmg@mail.gmail.com>
 <CABCJKuca0fOAs=E6LeHJiT2LOXEoPvLVKztA=u+ARcw=tbT=tw@mail.gmail.com> <20231012104741.GN6307@noisy.programming.kicks-ass.net>
In-Reply-To: <20231012104741.GN6307@noisy.programming.kicks-ass.net>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Thu, 12 Oct 2023 10:50:36 -0700
Message-ID: <CABCJKufEagwJ=TQnmVSK07RDjsPUt=3JGtwnK9ASmFqb7Vx8JQ@mail.gmail.com>
Subject: Re: [PATCH v10 25/27] x86: enable initial Rust support
To: Peter Zijlstra <peterz@infradead.org>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	patches@lists.linux.dev, Jarkko Sakkinen <jarkko@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Wedson Almeida Filho <wedsonaf@google.com>, David Gow <davidgow@google.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 12, 2023 at 3:47=E2=80=AFAM Peter Zijlstra <peterz@infradead.or=
g> wrote:
>
> On Fri, Oct 14, 2022 at 11:34:30AM -0700, Sami Tolvanen wrote:
> > On Fri, Oct 14, 2022 at 11:05 AM Miguel Ojeda
> > <miguel.ojeda.sandonis@gmail.com> wrote:
> > >
> > > On Tue, Oct 11, 2022 at 1:16 AM Sami Tolvanen <samitolvanen@google.co=
m> wrote:
> > > >
> > > > Rust supports IBT with -Z cf-protection=3Dbranch, but I don't see t=
his
> > > > option being enabled in the kernel yet. Cross-language CFI is going=
 to
> > > > require a lot more work though because the type systems are not qui=
te
> > > > compatible:
> > > >
> > > > https://github.com/rust-lang/rfcs/pull/3296
> > >
> > > I have pinged Ramon de C Valle as he is the author of the RFC above
> > > and implementation work too; since a month or so ago he also leads th=
e
> > > Exploit Mitigations Project Group in Rust.
> >
> > Thanks, Miguel. I also talked to Ramon about KCFI earlier this week
> > and he expressed interest in helping with rustc support for it. In the
> > meanwhile, I think we can just add a depends on !CFI_CLANG to avoid
> > issues here.
>
> Having just read up on the thing it looks like the KCFI thing is
> resolved.
>
> I'm not sure I understand most of the objections in that thread through
> -- enabling CFI *will* break stuff, so what.
>
> Squashing the integer types seems a workable compromise I suppose. One
> thing that's been floated in the past is adding a 'seed' attribute to
> some functions in order to distinguish functions of otherwise identical
> signature.
>
> The Rust thing would then also need to support this attribute.
>
> Are there any concrete plans for this? It would allow, for example,
> to differentiate address_space_operations::swap_deactivate() from any
> other random function that takes only a file argument, say:
> locks_remove_file().

I haven't really had time to look into it, so no concrete plans yet.
Adding an attribute shouldn't be terribly difficult, but Kees
expressed interest in automatic salting as well, which might be a more
involved project:

https://github.com/ClangBuiltLinux/linux/issues/1736

Sami
