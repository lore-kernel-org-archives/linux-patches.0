Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54553A271
	for <patches@lists.linux.dev>; Thu, 12 Oct 2023 18:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="gRFs3EZn"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-57bca5b9b0aso694550eaf.3
        for <patches@lists.linux.dev>; Thu, 12 Oct 2023 11:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1697135485; x=1697740285; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kmUopNj4SKl1oz8w54FsmEGmf+2bTIjcRS6uvAC4XKo=;
        b=gRFs3EZnYp1nTz8RIIcMCruGvv8DVM8QKPlj28Vkkxy6+B7kXdJ+UAz41YTK7NVbhD
         sgWXexVCcrhaz0daf3Cx55LtBYT96k/Q0jgb2GlRFsvcv7JC/WcNtfObbXXjDXbmxsfB
         CiTRgqd7oRmiI4nBH1y2vKjURuIbGmw9Qospc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697135485; x=1697740285;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kmUopNj4SKl1oz8w54FsmEGmf+2bTIjcRS6uvAC4XKo=;
        b=qUYjGQaZVHVGhqFrtUt/KSEvFmt5/GpvfRXu0S6AeSxKoza/aYEXkg5nQBHWRpl+nR
         YwGJe1drya8TrlGKRrhpqrcJS8F6odnQ2huIXzcX6viW3gYisrCLVwXqXY2loEea+oKB
         iQSaWDzQpMlOTq3B9nk/3MXm1sP6fKodh8xqbD5Zm6K/6Ka80Yi3blt8wOGi32cg6NUe
         bjQxIdkh2EesnFfD88scGB3gRC9U6QHezcsJhM4Jo6u2yocPzWyfH61fTISnQ8zOb3kL
         YdMaiJHIVAIo0hAIOzXYJHhkyCtbu4JG8KVzcEs8Hn180YDPGrYzKasn4iJslmJN6aNf
         l89Q==
X-Gm-Message-State: AOJu0YwPLY35626vL3XIvqmwKCiE+3PhIpFcCHbjW6H+46svw8RcdJFQ
	5zzJcr4L/Bat5pDVAl0IhGAYrQ==
X-Google-Smtp-Source: AGHT+IFb1ckH/xhcO6Zgz8KHFb8znJRiSnNP1u2o9ir74qQo0GMUO1tDivlCPnScZzkxDX4RIMu5BQ==
X-Received: by 2002:a05:6358:52c5:b0:14c:4411:2f4b with SMTP id z5-20020a05635852c500b0014c44112f4bmr32545120rwz.22.1697135485618;
        Thu, 12 Oct 2023 11:31:25 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id x3-20020aa793a3000000b0068a54866ca8sm12088064pff.134.2023.10.12.11.31.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Oct 2023 11:31:25 -0700 (PDT)
Date: Thu, 12 Oct 2023 11:31:16 -0700
From: Kees Cook <keescook@chromium.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	David Gow <davidgow@google.com>, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v10 25/27] x86: enable initial Rust support
Message-ID: <202310121130.256F581823@keescook>
References: <20220927131518.30000-1-ojeda@kernel.org>
 <20220927131518.30000-26-ojeda@kernel.org>
 <Y0BfN1BdVCWssvEu@hirez.programming.kicks-ass.net>
 <CABCJKuenkHXtbWOLZ0_isGewxd19qkM7OcLeE2NzM6dSkXS4mQ@mail.gmail.com>
 <CANiq72k6s4=0E_AHv7FPsCQhkyxf7c-b+wUtzfjf+Spehe9Fmg@mail.gmail.com>
 <CABCJKuca0fOAs=E6LeHJiT2LOXEoPvLVKztA=u+ARcw=tbT=tw@mail.gmail.com>
 <20231012104741.GN6307@noisy.programming.kicks-ass.net>
 <CABCJKufEagwJ=TQnmVSK07RDjsPUt=3JGtwnK9ASmFqb7Vx8JQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABCJKufEagwJ=TQnmVSK07RDjsPUt=3JGtwnK9ASmFqb7Vx8JQ@mail.gmail.com>

On Thu, Oct 12, 2023 at 10:50:36AM -0700, Sami Tolvanen wrote:
> On Thu, Oct 12, 2023 at 3:47 AM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Fri, Oct 14, 2022 at 11:34:30AM -0700, Sami Tolvanen wrote:
> > > On Fri, Oct 14, 2022 at 11:05 AM Miguel Ojeda
> > > <miguel.ojeda.sandonis@gmail.com> wrote:
> > > >
> > > > On Tue, Oct 11, 2022 at 1:16 AM Sami Tolvanen <samitolvanen@google.com> wrote:
> > > > >
> > > > > Rust supports IBT with -Z cf-protection=branch, but I don't see this
> > > > > option being enabled in the kernel yet. Cross-language CFI is going to
> > > > > require a lot more work though because the type systems are not quite
> > > > > compatible:
> > > > >
> > > > > https://github.com/rust-lang/rfcs/pull/3296
> > > >
> > > > I have pinged Ramon de C Valle as he is the author of the RFC above
> > > > and implementation work too; since a month or so ago he also leads the
> > > > Exploit Mitigations Project Group in Rust.
> > >
> > > Thanks, Miguel. I also talked to Ramon about KCFI earlier this week
> > > and he expressed interest in helping with rustc support for it. In the
> > > meanwhile, I think we can just add a depends on !CFI_CLANG to avoid
> > > issues here.
> >
> > Having just read up on the thing it looks like the KCFI thing is
> > resolved.
> >
> > I'm not sure I understand most of the objections in that thread through
> > -- enabling CFI *will* break stuff, so what.
> >
> > Squashing the integer types seems a workable compromise I suppose. One
> > thing that's been floated in the past is adding a 'seed' attribute to
> > some functions in order to distinguish functions of otherwise identical
> > signature.
> >
> > The Rust thing would then also need to support this attribute.
> >
> > Are there any concrete plans for this? It would allow, for example,
> > to differentiate address_space_operations::swap_deactivate() from any
> > other random function that takes only a file argument, say:
> > locks_remove_file().
> 
> I haven't really had time to look into it, so no concrete plans yet.
> Adding an attribute shouldn't be terribly difficult, but Kees
> expressed interest in automatic salting as well, which might be a more
> involved project:
> 
> https://github.com/ClangBuiltLinux/linux/issues/1736

Automatic would be nice, but having an attribute would let us at least
start the process manually (or apply salting from static analysis
output, etc).

-Kees

-- 
Kees Cook
